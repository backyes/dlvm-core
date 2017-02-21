//
//  Ownership.swift
//  DLVM
//
//  Created by Richard Wei on 2/19/17.
//
//

/// "deref" operator that looks like C's deref
/// This is a hacky operator which is equivalent to
/// Unowned.object / Weak.object
/// - Note: With Swift 4's memory ownership model,
/// we'll no longer need Unowned/Weak wrappers. Yay!
prefix operator *

public struct Unowned<Object: AnyObject> {
    public unowned var object: Object

    public init(_ object: Object) {
        self.object = object
    }

    static prefix func * (ref: Unowned) -> Object {
        return ref.object
    }
}

public struct Weak<Object: AnyObject> {
    public weak var object: Object?

    public init(_ object: Object) {
        self.object = object
    }

    static prefix func * (ref: Weak) -> Object? {
        return ref.object
    }
}