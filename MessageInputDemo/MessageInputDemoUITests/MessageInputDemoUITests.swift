//
//  Created by Zsombor Szabo on 14/01/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import XCTest

class MessageInputDemoUITests: XCTestCase {
    
    var restoredOrientation: UIDeviceOrientation?
    
    override func setUp() {
        continueAfterFailure = false
        self.restoredOrientation = XCUIDevice.shared.orientation
        XCUIDevice.shared.orientation = .portrait
    }
    
    override func tearDown() {
        if let orientation = self.restoredOrientation {
            XCUIDevice.shared.orientation = orientation
        }
    }
    
    func testMessageInputViewWidthIsEqualToScrollViewWidthOnDeviceOrientationChange() {
        let app = XCUIApplication()
        app.launch()
        let messageInputView = app.descendants(matching: .any)["MessageInputView"]
        let detailScrollView = app.descendants(matching: .any)["DetailScrollView"]
        XCTAssertEqual(messageInputView.frame.size.width, detailScrollView.frame.size.width)
        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssertEqual(messageInputView.frame.size.width, detailScrollView.frame.size.width)
    }
    
    func testMessageInputViewDoesNotGetCoveredByTheKeyboard() {
        let app = XCUIApplication()
        app.launch()
        let messageInputTextView = app.textViews["MessageInputTextView"]
        messageInputTextView.tap()
        XCTAssert(messageInputTextView.isHittable, "Message input text view can not be tapped.")
    }
    
    func testKeyboardInteractiveDismiss() {
        let app = XCUIApplication()
        app.launch()
        let messageInputTextView = app.textViews["MessageInputTextView"]
        messageInputTextView.tap()
        app.descendants(matching: .any)["DetailScrollView"].press(forDuration: 0, thenDragTo: app.keyboards.firstMatch)
        expectation(for: NSPredicate(format: "exists == 0"), evaluatedWith: app.keyboards.firstMatch, handler: nil)
        waitForExpectations(timeout: 3.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testMessageInputViewHeightChangesOnTextChange() {
        let app = XCUIApplication()
        app.launch()
        let messageInputTextView = app.textViews["MessageInputTextView"]
        let frameBeforeTextEntry = messageInputTextView.frame
        messageInputTextView.tap()
        let numberOfNewLines = 5
        messageInputTextView.typeText(String(repeating: "\n", count: numberOfNewLines))
        XCTAssert(messageInputTextView.frame.height > frameBeforeTextEntry.height)
        messageInputTextView.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: numberOfNewLines))
        XCTAssert(messageInputTextView.frame.height == frameBeforeTextEntry.height)
        // Used to take preview video
        // app/*@START_MENU_TOKEN@*/.buttons["Hide keyboard"]/*[[".keyboards.buttons[\"Hide keyboard\"]",".buttons[\"Hide keyboard\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
