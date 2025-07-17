//
//  UIKitComponentsTests.swift
//  UIKitComponentsTests
//
//  Created by 고혁준 on 3/24/25.
//

import XCTest
@testable import UIKitComponents

final class UIKitComponentsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    struct TestStruct: Equatable, Hashable {
        var id: String
        var value: Int
        
        static func == (lhs: TestStruct, rhs: TestStruct) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    func testPerformanceExample() throws {
        let fst = TestStruct(id: "1", value: 1)
        let snd = TestStruct(id: "2", value: 2)
        let trd = TestStruct(id: "3", value: 3)
        let forth = TestStruct(id: "4", value: 4)
        var list = [fst, snd, trd, forth]
        
        list[list.count] = TestStruct(id: "2", value: 3)
        print(list)
    }
}
