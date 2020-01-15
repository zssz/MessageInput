# MessageInput

This project demonstrates how to achieve the following functionality present in Messages.app for iOS and iPadOS, related to text message input and keyboard handling:

- The input view's width is equal to the detail scroll view's width. See [testMessageInputViewWidthIsEqualToScrollViewWidthOnDeviceOrientationChange()](https://github.com/zssz/MessageInput/blob/b84b4742b811c0f8943f5a86f5b2f5d85665c69f/MessageInputDemo/MessageInputDemoUITests/MessageInputDemoUITests.swift#L24).
- The input view does not get covered by the keyboard; it's pushed up and pulled down by it, with matching animation. See [testMessageInputViewDoesNotGetCoveredByTheKeyboard()](https://github.com/zssz/MessageInput/blob/b84b4742b811c0f8943f5a86f5b2f5d85665c69f/MessageInputDemo/MessageInputDemoUITests/MessageInputDemoUITests.swift#L34).
- The keyboard can be dismissed interactively. See [testKeyboardInteractiveDismiss()](https://github.com/zssz/MessageInput/blob/b84b4742b811c0f8943f5a86f5b2f5d85665c69f/MessageInputDemo/MessageInputDemoUITests/MessageInputDemoUITests.swift#L42).
- The detail scroll view's content insets and vertical scroll indicator's insets are updated on text change. TODO: Add UI test.
- The detail scroll view maintains its scroll position on begin editing, end editing, and text change. TODO: Add UI test.
- The input view grows until it reaches a maximum value or reaches the top of the safe area of the detail scroll view. TODO: Add UI test.

Extra functionality that made sense to add, but missing in Messages.app:
- The input view's height is adjusted with animation.

![](Resources/demo.gif)

## Swift Package

`https://github.com/zssz/MessageInput.git`
