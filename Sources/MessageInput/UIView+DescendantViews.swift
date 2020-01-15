//
//  Created by Zsombor Szabo on 14/01/2020.
//  
//

import Foundation
import UIKit

extension UIView {
        
    /// Returns an array of descendant views whitch are instances of `aClass` by examining the receiver's hierarchy recursively.
    /// - Parameter aClass: A class object representing the Objective-C class to be tested.
    public func descendantViews(ofMember aClass: AnyClass) -> [UIView] {
        var descendantViews = [UIView]()
        for subview in self.subviews {
            if subview.isMember(of: aClass) {
                descendantViews.append(subview)
            }
            descendantViews += subview.descendantViews(ofMember: aClass)
        }
        return descendantViews
    }
}
