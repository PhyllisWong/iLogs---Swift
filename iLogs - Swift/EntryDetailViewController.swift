//
//  EntryDetailViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/28/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry!
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func setUpObservers() {
        entry.addObserver(self, forKeyPath: "subject", options: .new, context: nil)
    }
    
    private func removeOvservers() {
        entry.removeObserver(self, forKeyPath: "subject")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath! {
        case "diary":
            title = entry.subject
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show entry":
                let vc = (segue.destination as! UINavigationController).topViewController! as! EntryViewController
                vc.entry = entry
            default:
                break
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = entry.subject
    }

}
