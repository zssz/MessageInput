//
//  Created by Zsombor Szabo on 10/01/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
        
    /// Starts automatically adjusting `additionalSafeAreaInsets` based on the `userInfo` of `UIResponder.keyboardWillChangeFrameNotification` notifications.
    ///
    /// - Returns: A `NSKeyValueObservation` instance to be used to call `stopAutomaticallyAdjustingAdditionalSafeAreaInsets(observation:)` with.
    public func startAutomaticallyAdjustingAdditionalSafeAreaInsets() -> NSKeyValueObservation? {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrameNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let observation = self.view.window?.windowScene?.inputSetHostView?.observe(\.center) { (view, change) in
            NotificationCenter.default.post(name: UIResponder.keyboardWillChangeFrameNotification, object: nil, userInfo: [
                UIResponder.keyboardFrameEndUserInfoKey : NSValue(cgRect: view.frame),
                UIResponder.keyboardAnimationDurationUserInfoKey : NSNumber(value: 0.0),
                UIResponder.keyboardAnimationCurveUserInfoKey : NSNumber(value: UIView.AnimationOptions(arrayLiteral: [.beginFromCurrentState, .curveEaseInOut]).rawValue)
            ])
        }
        return observation
    }
        
    /// Stops automatically adjusting `additionalSafeAreaInsets` based on the `userInfo` of `UIResponder.keyboardWillChangeFrameNotification` notifications.
    ///
    /// - Parameter observation: The `NSKeyValueObservation` instance received from the call to `startAutomaticallyAdjustingAdditionalSafeAreaInsets()`.
    public func stopAutomaticallyAdjustingAdditionalSafeAreaInsets(observation: NSKeyValueObservation?) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        observation?.invalidate()
    }
    
    @objc private func keyboardWillChangeFrameNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        
        let keyboardFrameInView = self.view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -self.additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)
        
        let keyboardAnimationDuration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
        let keyboardAnimationCurveRawValue = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationOptions = UIView.AnimationOptions(rawValue: keyboardAnimationCurveRawValue).intersection([.beginFromCurrentState])
        
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: animationOptions, animations: {
            self.additionalSafeAreaInsets.bottom = intersection.height
            self.view.layoutIfNeeded()
        })
    }
}
