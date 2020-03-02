//
//  File.swift
//  
//
//  Created by Roy Dawson on 3/2/20.
//

import Foundation

extension NSNumber {
    func toSwiftType() -> Any {
        switch CFNumberGetType(self as CFNumber) {
        case .charType:
            return self.boolValue
        case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .shortType, .intType, .longType, .longLongType, .cfIndexType, .nsIntegerType:
            return self.intValue
        case .float32Type, .float64Type, .floatType, .doubleType, .cgFloatType:
            return self.doubleValue
        @unknown default:
            return self
        }
    }
}
