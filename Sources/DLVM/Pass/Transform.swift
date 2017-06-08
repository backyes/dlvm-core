//
//  Transform.swift
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

public extension IRCollection {
    /// Applies a transform pass on self
    ///
    /// - Returns: whether changes are made
    @discardableResult
    func applyTransform<Transform : TransformPass>(_ transform: Transform.Type) throws -> Bool
        where Transform.Body == Self
    {
        let changed = try transform.run(on: self)
        if transform.shouldInvalidateAnalyses, changed {
            invalidateAnalyses()
        }
        /// Run verifier
        try verify()
        return changed
    }
}

public extension IRCollection {
    @discardableResult
    func mapTransform<Transform : TransformPass>(_ transform: Transform.Type) throws -> Bool
        where Transform.Body == Iterator.Element
    {
        var changed = false
        for element in self {
            changed = try element.applyTransform(transform) || changed
        }
        return changed
    }
}