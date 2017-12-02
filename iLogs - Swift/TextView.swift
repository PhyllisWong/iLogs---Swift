//
//  TextView.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/20/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

class TextView: UITextView, UITextViewDelegate {

    @IBOutlet weak var placeholderLabel: UILabel?
    
    @IBOutlet weak open var delegation: UITextViewDelegate? {
        didSet {
            self.hidePlaceholderIfNeeded()
            delegate = self
        }
    }
    
    override var text: String! {
        didSet {
            self.hidePlaceholderIfNeeded()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegation?.textViewDidBeginEditing?(textView)
        placeholderLabel?.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegation?.textViewDidEndEditing?(textView)
        self.hidePlaceholderIfNeeded()
    }
    
    private func hidePlaceholderIfNeeded() {
        if self.text.isEmpty {
            placeholderLabel?.isHidden = false
        } else {
            placeholderLabel?.isHidden = true
        }
    }

}
