//
//  ArrayTransformer.swift
//  CoreModule
//
//  Created by Mai Hassen on 02/12/2024.
//

import Foundation
import CoreData

@objc(ArrayTransformer)
public class ArrayTransformer: ValueTransformer {
    override public class func allowsReverseTransformation() -> Bool {
        return true
    }

    override public func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [Int] else { return nil }
        return try? JSONEncoder().encode(array)
    }

    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? JSONDecoder().decode([Int].self, from: data)
    }
}
