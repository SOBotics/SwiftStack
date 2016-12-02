import XCTest
@testable import SwiftStack

class SwiftStackTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SwiftStack().text, "Hello, World!")
    }


    static var allTests : [(String, (SwiftStackTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
