import XCTest
@testable import AdditionalMembers

final class AdditionalMembersTests: XCTestCase {
    static var allTests = [
        ("testCodingWithEmptyDict", testCodingWithEmptyDict),
        ("testCodingWithDict", testCodingWithDict),
        ("testCodingWithConfusingDict", testCodingWithConfusingDict),
        ("testCodingWithNSNumber", testCodingWithNSNumber),
        ("testCodingWithArray", testCodingWithArray),
        ("testCodingWithDictionary", testCodingWithDictionary),
        ("testCodingWithComplexStructure", testCodingWithComplexStructure)
    ]
    
    func codeAdditionalMembers(with dict: [String:Any], assertEquals: Bool = true) throws {
        
        let additionalMembers = AdditionalMembers<IncludingAllKeys>(json: dict)
        
        let encoder = JSONEncoder()
        
        let data = try encoder.encode(additionalMembers)
        
        let decoder = JSONDecoder()
        
        let result = try decoder.decode(AdditionalMembers<IncludingAllKeys>.self, from: data)
        
        if assertEquals {
            XCTAssertEqual(additionalMembers, result, "Additional members did not decode to the same value.")
        }
    }
    
    func testCodingWithEmptyDict() throws {
        try codeAdditionalMembers(with: [:])
    }
    
    func testCodingWithDict() throws {
        // Event additional info can hold String, Double, and Bool values
        try codeAdditionalMembers(with: [
            "nop": "qrs",
            "tuv": 1,
            "wxy": 2.3,
            "z": true,
            "_": false
        ])
    }
    
    func testCodingWithConfusingDict() throws {
        // Make sure values are being parse to the correct types
        try codeAdditionalMembers(with: [
            "string1": "true",
            "string2": "false",
            "string3": "0",
            "string4": "1",
            "string5": "1.23",
            "number1": 0,
            "number2": 1
        ])
    }
    
    func testCodingWithNSNumber() throws {
        // Make sure that ambiguous NSNumbers parsed to the correct type
        try codeAdditionalMembers(with: [
            "bool1": NSNumber(value: true),
            "bool2": NSNumber(value: false),
            "number1": NSNumber(value: 0),
            "number2": NSNumber(value: 1),
            "number3": NSNumber(value: 2),
            "number4": NSNumber(value: 3.4)
        ])
    }
    
    func testCodingWithArray() throws {
        // Make sure that arrays of strings and numbers are coded properly
        try codeAdditionalMembers(with: [
            "stringArr": ["abc", "def", "ghi", "jkl", "mno"],
            "intArray": [1, 2, 3, 4, 5],
            "doubleArray": [0.1, 2.3, 4.5, 6.7, 8.9],
            "emptyArray": [String]()
        ])
    }
    
    func testCodingWithDictionary() throws {
        // Make sure that dictionaries of strings and numbers are coded properly
        try codeAdditionalMembers(with: [
            "stringDict": ["one": "abc", "two": "def", "three": "ghi", "four": "jkl", "five": "mno"],
            "intDict": ["six": 1, "seven": 2, "eight": 3, "nine": 4, "ten": 5],
            "doubleDict": ["eleven": 0.1, "twelve": 2.3, "thirteen": 4.5, "fourteen": 6.7, "fifteen": 8.9],
            "emptyDict": [String: Any]()
        ])
    }
    
    
    func testCodingWithComplexStructure() throws {
        // Make sure that dictionaries of strings and numbers are coded properly
        try codeAdditionalMembers(with: [
            "dictArray": [["one": "abc", "two": "def", "three": "ghi", "four": "jkl", "five": "mno"],["six": 1, "seven": 2, "eight": 3, "nine": 4, "ten": 5],["eleven": 0.1, "twelve": 2.3, "thirteen": 4.5, "fourteen": 6.7, "fifteen": 8.9]],
            "arrayDict": ["stringArr": ["abc", "def", "ghi", "jkl", "mno"], "intArray": [1, 2, 3, 4, 5], "doubleArray": [0.1, 2.3, 4.5, 6.7, 8.9]],
            "arrayDictArray": [["hey": ["you!"]]],
            "dictArrayDict": ["hey": [["you": "!"]]]
        ])
    }
    
    func testCodingNil() throws {
        //Make sure that coding a dictionary with null values does not crash
        //Do not test equality as null values are not encoded, resulting in the decoded data missing that entry.
        try codeAdditionalMembers(with: ["nullValue": NSNull()], assertEquals: false)
    }
}
