//
//  TopViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/22/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show diary", "show timers":
                break
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
}
