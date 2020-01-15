//
//  Created by Zsombor Szabo on 14/01/2020.
//  
//

import Foundation
import UIKit

extension UIScrollView {
        
    /// Returns a Boolean value that indicates whether the scroll view is at the bottom of its content.
    open var isAtBottom: Bool {
        return contentOffset.y >= (contentSize.height - bounds.size.height + adjustedContentInset.bottom)
    }
}
