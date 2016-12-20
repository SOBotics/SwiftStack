import XCTest
@testable import SwiftStack

class BasicRequestTests: XCTestCase {
	func testGet() {
		let client = APIClient()
		
		let url = "https://httpbin.org/get"
		let result = try? client.get(url) as String
		XCTAssert(result != nil)
		
		let json = (try? client.parseJSON(result!)) as? [String:Any]
		XCTAssert(json != nil)
		
		XCTAssert((json!["url"] as? String) == url)
	}
	
    func testPost() {
		let client = APIClient()
		
		let url = "https://httpbin.org/post"
		let result = try? client.post(url, fields: ["test":"123456"]) as String
		XCTAssert(result != nil)
		
		let json = (try? client.parseJSON(result!)) as? [String:Any]
		XCTAssert(json != nil)
		
		XCTAssert((json!["url"] as? String) == url)
		XCTAssert(((json!["form"] as? [String:Any])?["test"] as? String) == "123456")
		
    }


    static var allTests : [(String, (BasicRequestTests) -> () throws -> Void)] {
        return [
			("testGet", testGet),
            ("testPost", testPost),
        ]
    }
}
