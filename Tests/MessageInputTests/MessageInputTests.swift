import XCTest
@testable import MessageInput

final class MessageInputTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MessageInput().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}