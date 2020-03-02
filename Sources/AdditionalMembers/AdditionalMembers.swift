//
//  AdditionalMembers.swift
//  Additional Members
//
//  Created by Roy Dawson on 2/27/20.
//  Copyright © 2020 Lucid Software. All rights reserved.
//

import Foundation

public struct AdditionalMembers<T: ExcludingKey>: Codable, Equatable {
    private let _guts: [String: Any]
    
    public init(json: [String: Any]) {
        self._guts = json
    }
    
    struct CodingKeys: CodingKey, Hashable {
        
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            return nil
        }
        
        // MARK: Helpers
        
        init(_ stringValue: String) {
            self.init(stringValue: stringValue)!
        }
    }
    
    public init(from decoder: Decoder) throws {
        func dictionary(from decoder: Decoder, subtracting: Set<CodingKeys> = Set()) throws -> [String: Any] {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            var result = [String: Any]()
            for key in Set(container.allKeys).subtracting(subtracting) {
                if let string = try? container.decode(String.self, forKey: key) {
                    result[key.stringValue] = string
                } else if let bool = try? container.decode(Bool.self, forKey: key) {
                    result[key.stringValue] = bool
                } else if let int = try? container.decode(Int.self, forKey: key) {
                    result[key.stringValue] = int
                } else if let double = try? container.decode(Double.self, forKey: key) {
                    result[key.stringValue] = double
                } else if let nestedDecoder = try? container.superDecoder(forKey: key) {
                    if let dictionary = try? dictionary(from: nestedDecoder) {
                        result[key.stringValue] = dictionary
                    } else if let array = try? array(from: nestedDecoder) {
                        result[key.stringValue] = array
                    }
                }
            }
            return result
        }
        
        func array(from decoder: Decoder) throws -> [Any] {
            var container = try decoder.unkeyedContainer()
            guard let count = container.count else { throw NSError(domain: "Unkeyed container has a nil count", code: 0, userInfo: nil) }
            var result = [Any]()
            for _ in 0..<count {
                if let string = try? container.decode(String.self) {
                    result.append(string)
                } else if let bool = try? container.decode(Bool.self) {
                    result.append(bool)
                } else if let int = try? container.decode(Int.self) {
                    result.append(int)
                } else if let double = try? container.decode(Double.self) {
                    result.append(double)
                } else if let nestedDecoder = try? container.superDecoder() {
                    if let dictionary = try? dictionary(from: nestedDecoder) {
                        result.append(dictionary)
                    } else if let array = try? array(from: nestedDecoder) {
                        result.append(array)
                    }
                }
            }
            return result
        }
        self._guts = try dictionary(from: decoder, subtracting: Set(T.excludingKeys.map(CodingKeys.init)))
    }
    
    public func encode(to encoder: Encoder) throws {
        func encode(dictionary: [String: Any], to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            for (key, value) in dictionary {
                switch value {
                case let string as String:
                    try container.encode(string, forKey: CodingKeys(key))
                case let number as NSNumber:
                    switch number.toSwiftType() {
                    case let bool as Bool:
                        try container.encode(bool, forKey: CodingKeys(key))
                    case let int as Int:
                        try container.encode(int, forKey: CodingKeys(key))
                    case let double as Double:
                        try container.encode(double, forKey: CodingKeys(key))
                    default:
                        throw NSError(domain: "failed to encoded json", code: 0, userInfo: nil)
                    }
                case let array as [Any]:
                    try encode(array: array, to: container.superEncoder(forKey: CodingKeys(key)))
                case let dict as [String:Any]:
                    try encode(dictionary: dict, to: container.superEncoder(forKey: CodingKeys(key)))
                default:
                    throw NSError(domain: "failed to encoded json", code: 0, userInfo: nil)
                }
            }
        }
        func encode(array: [Any], to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            for value in array {
                switch value {
                case let string as String:
                    try container.encode(string)
                case let number as NSNumber:
                    switch number.toSwiftType() {
                    case let bool as Bool:
                        try container.encode(bool)
                    case let int as Int:
                        try container.encode(int)
                    case let double as Double:
                        try container.encode(double)
                    default:
                        throw NSError(domain: "failed to encoded json", code: 0, userInfo: nil)
                    }
                case let array as [Any]:
                    try encode(array: array, to: container.superEncoder())
                case let dict as [String:Any]:
                    try encode(dictionary: dict, to: container.superEncoder())
                default:
                    throw NSError(domain: "failed to encoded json", code: 0, userInfo: nil)
                }
            }
        }
        try encode(dictionary: self._guts, to: encoder)
    }
    
    public static func == (lhs: AdditionalMembers, rhs: AdditionalMembers) -> Bool {
        func anyEquals(_ lhs: Any, _ rhs: Any) -> Bool {
            switch (lhs, rhs) {
            case let (a, b) as (String, String):
                return a == b
            case let (a, b) as (NSNumber, NSNumber):
                switch (a.toSwiftType(), b.toSwiftType()) {
                case let (a, b) as (Bool, Bool):
                    return a == b
                case let (a, b) as (Int, Int):
                    return a == b
                case let (a, b) as (Double, Double):
                    return a == b
                default:
                    return false
                }
            case let (a, b) as ([Any], [Any]):
                return arrayEquals(a, b)
            case let (a, b) as ([String: Any], [String: Any]):
                return dictionaryEquals(a, b)
            default:
                return false
            }
        }
        func dictionaryEquals(_ lhs: [String: Any], _ rhs: [String: Any]) -> Bool {
            return lhs.keys == rhs.keys && lhs.keys.allSatisfy { anyEquals(lhs[$0]!, rhs[$0]!) }
        }
        func arrayEquals(_ lhs: [Any], _ rhs: [Any]) -> Bool {
            return lhs.count == rhs.count && zip(lhs, rhs).allSatisfy(anyEquals)
        }
        return dictionaryEquals(lhs._guts, rhs._guts)
    }
}
