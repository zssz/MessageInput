//
//  Created by Zsombor SZABO on 22/04/16.
//  Copyright © 2016 IZE. All rights reserved.
//

import UIKit

private var textObservationContext = 0

/// An `UITextView` subclass with `placeholder` support, like in `UITextField`.
open class TextViewWithPlaceholder: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    fileprivate var originalTextColor: UIColor?
    
    open var placeholder: String? {
        didSet {
            if oldValue == nil {
                originalTextColor = textColor
            }
            if !isFirstResponder {
                if (text == oldValue && textColor == placeholderTextColor) || text == nil || text == "" {
                    textColor = placeholderTextColor
                    text = placeholder
                }
            }
        }
    }
    
    open var placeholderTextColor = UIColor.placeholderText {
        didSet {
            if !isFirstResponder {
                if text == placeholder && textColor == oldValue {
                    textColor = placeholderTextColor
                }
            }
        }
    }
    
    open var isShowingPlaceholder: Bool {
        if placeholder != nil {
            return (text == placeholder && textColor == placeholderTextColor)
        }
        return false
    }
    
    func commonInit() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(configurePlaceholderIfNeeded), name: UITextView.textDidChangeNotification, object: self)
        notificationCenter.addObserver(self, selector: #selector(configurePlaceholderIfNeeded), name: UITextView.textDidBeginEditingNotification, object: self)
        notificationCenter.addObserver(self, selector: #selector(configurePlaceholderIfNeeded), name: UITextView.textDidEndEditingNotification, object: self)
        addObserver(self, forKeyPath: "text", options: .new, context: &textObservationContext)
        textAlignment = .natural
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
        notificationCenter.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: self)
        notificationCenter.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: self)
        removeObserver(self, forKeyPath: "text", context: &textObservationContext)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &textObservationContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        configurePlaceholderIfNeeded()
    }
    
    @objc private func configurePlaceholderIfNeeded() {
        if isFirstResponder {
            if isShowingPlaceholder {
                textColor = originalTextColor
                text = ""
            }
        }
        else {
            if (text == nil || text == "") && placeholder != nil {
                textColor = placeholderTextColor
                text = placeholder
            }
        }
    }
}
