//
//  ModularTableViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/3/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

enum ModularTableViewTypes {
    case Body
}

@objc
protocol ModularTableViewDelegate {
    @objc optional func modular(_ module: ModularTableViewController, didFinishWithObject object: Any?)
}

class ModularTableViewController: UITableViewController {
    
    var moduleType: ModularTableViewTypes = .Body
    
    var value: Any?
    
    var delegate: ModularTableViewDelegate?
    
    @IBOutlet weak var textField: UITextView! {
        didSet {
            textField.text = value as! String?
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    @IBOutlet weak var buttonRightNav: UIBarButtonItem!
    @IBAction func pressRightNav(_ sender: Any) {
        delegate?.modular!(self, didFinishWithObject: textField.text)
        navigationController!.popViewController(animated: true)
    }
    
    @IBOutlet weak var pressLeftNav: UIBarButtonItem!
    @IBAction func pressLeftNav(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        switch moduleType {
        case .Body:
            textField.becomeFirstResponder()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
    }
}
