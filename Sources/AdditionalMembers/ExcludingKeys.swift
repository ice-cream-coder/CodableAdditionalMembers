//
//  File.swift
//  
//
//  Created by Roy Dawson on 3/2/20.
//

import Foundation

public protocol ExcludingKey {
    static var excludingKeys: [String] { get }
}

public struct IncludingAllKeys: ExcludingKey {
    public static let excludingKeys = [String]()
}
