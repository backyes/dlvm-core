//
//  Tool.swift
//  DLCommandLineTools
//
//  Copyright 2016-2018 The DLVM Team.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if os(Linux)
@_exported import Glibc
#else
@_exported import Darwin.C
#endif

import Basic
import Utility

open class CommandLineTool<Options : ToolOptions> {
    /// The options of this tool.
    public let options: Options

    /// Reference to the argument parser.
    public let parser: ArgumentParser

    /// The execution status of the tool.
    var executionStatus: ExecutionStatus = .success

    /// Create an instance of this tool.
    ///
    /// - parameter args: The command line arguments to be passed to this tool.
    public init(toolName: String, usage: String, overview: String, args: [String], seeAlso: String? = nil) {
        // Create the parser.
        parser = ArgumentParser(
            commandName: "\(toolName)",
            usage: usage,
            overview: overview,
            seeAlso: seeAlso)

        // Create the binder.
        let binder = ArgumentBinder<Options>()

        // Bind the common options.
        binder.bindArray(
            positional: parser.add(positional: "input files", kind: [PathArgument].self,
                                   usage: "DLVM IR input files"),
            to: { $0.inputFiles = $1.lazy.map({ $0.path }) })

        binder.bindArray(
            parser.add(option: "--passes", shortName: "-p", kind: [TransformPass].self,
                       usage: "Transform passes"),
            parser.add(option: "--outputs", shortName: "-o", kind: [PathArgument].self,
                       usage: "Output paths"),
            to: {
                if !$1.isEmpty { $0.passes = $1 }
                if !$2.isEmpty { $0.outputPaths = $2.lazy.map({ $0.path }) }
        })

        binder.bind(
            option: parser.add(option: "--print-ir", kind: Bool.self,
                               usage: "Print IR after transformations instead of writing to files"),
            to: { $0.shouldPrintIR = $1 })

        // Let subclasses bind arguments.
        type(of: self).defineArguments(parser: parser, binder: binder)

        do {
            // Parse the result.
            let result = try parser.parse(args)
            // Fill and set options.
            var options = Options()
            binder.fill(result, into: &options)
            self.options = options
        } catch {
            handle(error: error)
            CommandLineTool.exit(with: .failure)
        }
    }

    open class func defineArguments(parser: ArgumentParser, binder: ArgumentBinder<Options>) {
        fatalError("Must be implemented by subclasses")
    }

    /// Execute the tool.
    public func run() {
        do {
            // Call the implementation.
            try runImpl()
        } catch {
            // Set execution status to failure in case of errors.
            executionStatus = .failure
            handle(error: error)
        }
        CommandLineTool.exit(with: executionStatus)
    }

    /// Run method implementation to be overridden by subclasses.
    open func runImpl() throws {
        fatalError("Must be implemented by subclasses")
    }

    /// Exit the tool with the given execution status.
    private static func exit(with status: ExecutionStatus) -> Never {
        switch status {
        #if os(Linux)
        case .success: Glibc.exit(EXIT_SUCCESS)
        case .failure: Glibc.exit(EXIT_FAILURE)
        #else
        case .success: Darwin.exit(EXIT_SUCCESS)
        case .failure: Darwin.exit(EXIT_FAILURE)
        #endif
        }
    }

    /// An enum indicating the execution status of run commands.
    enum ExecutionStatus {
        case success
        case failure
    }
}
