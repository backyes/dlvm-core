//
//  Module.swift
//  DLVM
//
//  Copyright 2016-2017 Richard Wei.
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

import Foundation

/// Module representing a neural network
public final class Module : IRCollection, IRUnit {
    public enum Stage {
        case raw, canonical
    }
    
    public typealias Element = Function
    public typealias Index = Int
    
    public var name: String
    public internal(set) var stage: Stage = .raw
    public var elements: OrderedMapSet<Function> = []
    public var globalValues: OrderedMapSet<GlobalValue> = []
    public var typeAliases: OrderedMapSet<TypeAlias> = []
    public private(set) var analysisManager: AnalysisManager<Module> = AnalysisManager()
    public internal(set) var transformManager: TransformManager<Module> = TransformManager()

    public init(name: String) {
        self.name = name
    }
}

// MARK: - Output
extension Module {

    open func write(toFile path: String) throws {
        var contents = ""
        write(to: &contents)
        try contents.write(toFile: path, atomically: true, encoding: .utf8)
    }
    
}
