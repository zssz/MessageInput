//
// Copyright © 2020 IZE Ltd. and the project authors
// Licensed under MIT License
//
// See LICENSE.txt for license information.
//

import Foundation
import UIKit

extension UIScrollView {
        
    /// Returns a Boolean value that indicates whether the scroll view is at the bottom of its content.
    open var isAtBottom: Bool {
        return contentOffset.y >= (contentSize.height - bounds.size.height + adjustedContentInset.bottom)
    }
}
