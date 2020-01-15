//
// Copyright © 2020 IZE Ltd. and the project authors
// Licensed under MIT License
//
// See LICENSE.txt for license information.
//

import Foundation
import UIKit

extension UIWindowScene {
        
    /// Returns the view that hosts the input set (including the software keyboard).
    var inputSetHostView: UIView? {
        guard let textEffectsWindowClass = NSClassFromString("UI" + "Text" + "Effects" + "Window"),
            let inputSetHostViewClass = NSClassFromString("UI" + "Input" + "Set" + "Host" + "View"),
            let textEffectsWindow = self.windows.filter({ $0.isMember(of: textEffectsWindowClass) }).first,
            let inputSetHostView = textEffectsWindow.descendantViews(ofMember: inputSetHostViewClass).first else {
                return nil
        }
        return inputSetHostView
    }
}
