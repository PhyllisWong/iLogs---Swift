//
//  UniversalExtentions.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/26/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    open func setStyleToParagraph(withPlaceholderText placeholder: String? = "", withInitalText text: String? = "") {
        self.autocorrectionType = .default
        self.autocapitalizationType = .words
        self.text = text
        self.placeholder = placeholder
        
    }
    
}

public struct UIAlertActionInfo {
    var title: String?
    var style: UIAlertActionStyle
    var handler: ((UIAlertAction) -> Swift.Void)?
    
    init(title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Swift.Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension UIAlertController {
    open func addActions(cancelButton cancel: String? = "Cancel", actions: UIAlertActionInfo...) {
        for action in actions {
            self.addAction(UIAlertAction(title: action.title, style: action.style, handler: action.handler))
        }
        if cancel != nil {
            self.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        }
    }
    
    var inputField: UITextField {
        return self.textFields!.first!
    }
}

extension Bool {
    public mutating func invert() {
        if self == true {
            self = false
        } else {
            self = true
        }
    }
    
    public var inverse: Bool {
        if self == true {
            return false
        } else {
            return true
        }
    }
}
