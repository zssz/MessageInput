# MessageInput

This project demonstrates how to achieve the following functionality present in Messages.app for iOS and iPadOS, related to text message input and keyboard handling:

- The input view's width is equal to the detail scroll view's width.
- The input view does not get covered by the keyboard; it's pushed up and pulled down by it, with matching animation.
- The keyboard can be dismissed interactively.
- The detail scroll view's content insets and vertical scroll indicator's insets are updated on text change.
- The detail scroll view maintains its scroll position on begin editing, end editing, and text change.
- The input view grows until it reaches a maximum value or reaches the top of the safe area of the detail scroll view.

Extra functionality that made sense to add, but missing in Messages.app:
- The input view's height is adjusted with animation.

![](Resources/demo.gif)

## Swift Package

`https://github.com/zssz/MessageInput.git`
