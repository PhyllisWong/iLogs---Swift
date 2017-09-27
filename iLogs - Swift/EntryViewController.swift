//
//  EntryViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/26/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

class EntryViewController: UITableViewController {
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let identifier = segue.identifier {
     switch identifier {
     case <#pattern#>:
     <#code#>
     default:
     break
     }
     }
     }*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var textFieldSubject: UITextField!
    @IBOutlet weak var labelDiary: UILabel!
    
    @IBOutlet weak var imageEmotion: UIImageView!
    @IBOutlet weak var buttonEmotions: UIButton!
    @IBAction func pressEmotions(_ sender: UIButton) {
    }
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var buttonWeather: UIButton!
    @IBAction func pressWeather(_ sender: UIButton) {
    }
    @IBOutlet weak var buttonHighlight: UIButton!
    @IBAction func pressHighlight(_ sender: Any) {
    }
    @IBOutlet weak var buttonBookmark: UIButton!
    @IBAction func pressBookmark(_ sender: Any) {
    }
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textFieldStories: UITextField!
    @IBOutlet weak var textFieldTags: UITextField!
    @IBOutlet weak var buttonBody: UIButton!
    @IBAction func pressBody(_ sender: UIButton) {
    }
    @IBOutlet weak var buttonOutline: UIButton!
    @IBAction func pressOutline(_ sender: Any) {
    }
    @IBOutlet weak var textViewBody: UITextView!
    
    
    @IBAction func pressDismiss(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
