//
//  Created by Zsombor SZABO on 08/09/2017.
//  Copyright © 2017 IZE. All rights reserved.
//

import UIKit

/// A view for message input.
///
/// This view assumes it sits at the bottom of a view controller's view, which has a matching size scroll view subview, similar to Messages.app.
///
/// Pass the view controller's view as the parameter of `setup(withView:)` to set it up. Set the scroll view to `hostScrollView` to get functionality like maintaining scroll position on text change. Finally, in the view controller's `viewDidAppear(_:)`, call `startAutomaticallyAdjustingAdditionalSafeAreaInsets()`.
public class MessageInputView: UIView {
        
    /// The background visual effect view with an effect that matches the system chrome. Its `contentView` is the main container view.
    public var visualEffectView: UIVisualEffectView!
        
    /// The horizontal stack view that holds `textView` and `trailingButton`.
    public var stackView: UIStackView!
        
    /// The text view that has the user's text input.
    public var textView: UITextView! {
        didSet {
            if let textView = oldValue {
                NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: textView)
            }
            if let textView = self.textView {
                NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChangeNotification), name: UITextView.textDidChangeNotification, object: textView)
                self.textViewHeightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.minTextViewHeight)
                self.textViewHeightConstraint.priority = .defaultHigh
                self.textViewHeightConstraint.isActive = true
                self.setNeedsLayout()
            }
        }
    }
        
    /// The border color of `textView`'s layer. Defaults to `.systemGray2`.
    public var textViewLayerBorderColor: UIColor? = .systemGray2 {
        didSet { self.configureTextViewLayerBorderColorIfNeeded() }
    }
        
    /// The minimum height of `textView`. Defaults to `35.0`.
    public var minTextViewHeight: CGFloat = 35.0 {
        didSet { self.setNeedsLayout() }
    }
    
    /// The maximum height of `textView`. Defaults to `170.0`.
    public var maxTextViewHeight: CGFloat = 170.0 {
        didSet { self.setNeedsLayout() }
    }
    
    private var textViewHeightConstraint: NSLayoutConstraint!
        
    /// The trailing button in `stackView`.
    public var trailingButton: UIButton!
        
    /// The host scroll view whose scroll position to maintain on begin editing, end editing and text change. Also, whose `contentInset.bottom` and `verticalScrollIndicatorInsets.bottom` to update based on the receiver's height.
    weak public var hostScrollView: UIScrollView? {
        didSet { self.setNeedsLayout() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        
        self.visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        self.visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.visualEffectView)
        NSLayoutConstraint.activate([
            self.visualEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.visualEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.visualEffectView.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        
        let textViewWithPlaceholder = TextViewWithPlaceholder(frame: .zero)
        textViewWithPlaceholder.placeholder = NSLocalizedString("Message", comment: "")
        self.textView = textViewWithPlaceholder
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.backgroundColor = .clear
        self.textView.isEditable = true
        self.textView.isSelectable = true
        self.textView.isScrollEnabled = true
        self.textView.dataDetectorTypes = .all
        self.textView.font = .preferredFont(forTextStyle: .body)
        self.textView.adjustsFontForContentSizeCategory = true
        self.textView.accessibilityIdentifier = "MessageInputTextView"
        self.textView.textContainerInset = UIEdgeInsets(top: 6.5, left: 8, bottom: 6.5, right: 8)
        let cornerRadius: CGFloat = self.minTextViewHeight / 2
        self.textView.layer.cornerRadius = cornerRadius
        self.textView.layer.borderWidth = 1
        self.textView.scrollIndicatorInsets = UIEdgeInsets(top: cornerRadius / 2, left: cornerRadius / 2, bottom: cornerRadius / 2, right: cornerRadius / 2)
        self.textView.scrollsToTop = false
        self.configureTextViewLayerBorderColorIfNeeded()
        
        self.trailingButton = UIButton(type: .system)
        self.trailingButton.translatesAutoresizingMaskIntoConstraints = false
        self.trailingButton.setContentHuggingPriority(.required, for: .horizontal)
        self.trailingButton.setTitle(NSLocalizedString("Send", comment: ""), for: UIControl.State())
        self.trailingButton.accessibilityIdentifier = "SendButton"
        self.trailingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.trailingButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        self.stackView = UIStackView(arrangedSubviews: [self.textView, self.trailingButton])
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .horizontal
        self.stackView.alignment = .center
        self.stackView.distribution = .fill
        self.stackView.spacing = 8.0
        self.stackView.layoutMargins = .init(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0)
        self.stackView.isLayoutMarginsRelativeArrangement = true
        self.visualEffectView.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.visualEffectView.contentView.safeAreaLayoutGuide.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.visualEffectView.contentView.safeAreaLayoutGuide.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.visualEffectView.contentView.safeAreaLayoutGuide.bottomAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.visualEffectView.contentView.safeAreaLayoutGuide.topAnchor),
        ])
        
        self.setNeedsLayout()
    }
        
    /// A convenience method that adds `self` as a subview of `view` and sets up the layout constraints so that `self` sits at the bottom of `view`, similar to a toolbar.
    /// - Parameter view: The view to set up `self` with.
    public func setup(withView view: UIView) {
        view.addSubview(self)
        // Anchor self to the bottom of the view.
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // Limit self's growth to the top of the view's safe area.
            self.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    deinit {
        if let textView = self.textView {
            NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: textView)
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        return .zero
    }
    
    private var previousSafeAreaInsets: UIEdgeInsets = .zero
    
    public override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if let scrollView = self.hostScrollView, !scrollView.isTracking, !scrollView.isDecelerating, !scrollView.isAtBottom {
            scrollView.contentOffset.y += max(0, self.safeAreaInsets.bottom - self.previousSafeAreaInsets.bottom)
        }
        self.previousSafeAreaInsets = self.safeAreaInsets
    }
    
    @objc private func textDidChangeNotification() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .beginFromCurrentState, animations: {
            self.configureTextViewHeightConstraint()
            self.superview?.layoutIfNeeded()
        })
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.configureTextViewHeightConstraint()
        }
    }
    
    private func configureTextViewHeightConstraint() {
        let size = self.textView.sizeThatFits(CGSize(width: self.textView.bounds.size.width, height: 0))
        let maxHeight = self.maxTextViewHeight - self.stackView.layoutMargins.top - self.stackView.layoutMargins.bottom
        let previousValue = self.textViewHeightConstraint.constant
        self.textViewHeightConstraint.constant = min(size.height, maxHeight)
        if self.textViewHeightConstraint.constant < self.minTextViewHeight {
            self.textViewHeightConstraint.constant = self.minTextViewHeight
        }
        if let scrollView = self.hostScrollView {
            if previousValue != self.textViewHeightConstraint.constant {
                scrollView.contentOffset.y += (self.textViewHeightConstraint.constant - previousValue)
            }
            scrollView.contentInset.bottom = self.textViewHeightConstraint.constant + self.stackView.layoutMargins.top + self.stackView.layoutMargins.bottom
            scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Since we use CGColor for the text view layer's border, we need to update it manually when the user interface style changes
        if previousTraitCollection?.userInterfaceStyle != self.traitCollection.userInterfaceStyle {
            self.configureTextViewLayerBorderColorIfNeeded()
        }
    }
    
    private func configureTextViewLayerBorderColorIfNeeded() {
        guard let color = self.textViewLayerBorderColor else { return }
        self.textView.layer.borderColor = color.cgColor
    }
}
