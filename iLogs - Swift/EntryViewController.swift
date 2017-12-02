//
//  EntryViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/26/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class EntryViewController: UITableViewController, UITextFieldDelegate, ModularTableViewDelegate {
    
    var entry: Entry!
    
    private var crud: CRUD = .Create
    
    private struct Table {
        static var diaryIndexPath = IndexPath(row: 1, section: 0)
    }
    
    private var viewDidAppear = false
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        if entry == nil {
            entry = Entry(diary: AppDelegate.sharedInstance.diaryController.defaultDiary, in: AppDelegate.diaryViewContext)
            crud = .Create
        } else {
            crud = .Update
        }
        textFieldSubject.text = entry.subject
        labelDiary.text = entry.diary!.title
        textViewBody.text = entry.body
        if entry.isBookMarked {
            buttonBookmark.setImage(#imageLiteral(resourceName: "misc_bookmark-enabled"), for: .normal)
        } else {
            buttonBookmark.setImage(#imageLiteral(resourceName: "misc_bookmark-disabled"), for: .normal)
        }
    }
    
    private func dismissFirstResponder() {
        if textFieldSubject.isFirstResponder {
            textFieldSubject.resignFirstResponder()
        }
        if textFieldStories.isFirstResponder {
            textFieldStories.resignFirstResponder()
        }
        if textFieldTags.isFirstResponder {
            textFieldTags.resignFirstResponder()
        }
    }
    
    private func setUpObservers() {
        entry.addObserver(self, forKeyPath: "diary", options: .new, context: nil)
        entry.addObserver(self, forKeyPath: "body", options: .new, context: nil)
        entry.addObserver(self, forKeyPath: "isBookMarked", options: .new, context: nil)
    }
    
    private func removeObservers() {
        entry.removeObserver(self, forKeyPath: "diary")
        entry.removeObserver(self, forKeyPath: "body")
        entry.removeObserver(self, forKeyPath: "isBookMarked")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath! {
        case "diary":
            labelDiary.text = entry.diary!.title
        case "body":
            textViewBody.text = entry.body
        case "isBookMarked":
            if entry.isBookMarked {
                buttonBookmark.setImage(#imageLiteral(resourceName: "misc_bookmark-enabled"), for: .normal)
            } else {
                buttonBookmark.setImage(#imageLiteral(resourceName: "misc_bookmark-disabled"), for: .normal)
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show body":
                let vc = segue.destination as! ModularTableViewController
                vc.delegate = self
                vc.value = entry.body
            case "show weather":
                let vc = (segue.destination as! UINavigationController).topViewController! as! EntryCollectionViewController
                vc.mode = .WeatherConditions
                vc.selectedItems = entry.weatherConditions as! Set<NSManagedObject>?
                vc.entry = entry
            default: break
            }
        }
    }
    
    // MARK: Text Field Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case textFieldSubject:
            entry.subject = textField.text
        default: break
        }
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case Table.diaryIndexPath:
            let alertDiaries = UIAlertController(title: nil, message: "select a diary", preferredStyle: .actionSheet)
            let diaries = Diary.fetchDiaries()
            for diary in diaries {
                alertDiaries.addAction(UIAlertAction(title: diary.title, style: .default, handler: { [weak self] (action) in
                    self!.entry.diary = diary
                }))
            }
            alertDiaries.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            tableView.deselectRow(at: Table.diaryIndexPath, animated: true)
            self.present(alertDiaries, animated: true)
        default: break
        }
    }
    
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
    
    // MARK: Modular Table View Delegate
    
    func modular(_ module: ModularTableViewController, didFinishWithObject object: Any?) {
        switch module.moduleType {
        case .Body:
            entry.body = object as! String?
        }
    }
    
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
        entry.isBookMarked.invert()
    }
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textFieldStories: UITextField! {
        didSet {
            textFieldStories.inputView = UIView()
        }
    }
    @IBOutlet weak var textFieldTags: UITextField! {
        didSet {
            textFieldTags.inputView = UIView()
        }
    }
    @IBOutlet weak var buttonBody: UIButton!
    @IBAction func pressBody(_ sender: UIButton) {
    }
    @IBOutlet weak var buttonOutline: UIButton!
    @IBAction func pressOutline(_ sender: Any) {
    }
    @IBOutlet weak var textViewBody: UITextView!
    
    @IBAction func pressSave(_ sender: Any) {
        removeObservers()
        dismissFirstResponder()
        AppDelegate.sharedInstance.diaryController.saveContext()
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func pressDismiss(_ sender: Any) {
        removeObservers()
        dismissFirstResponder()
        AppDelegate.diaryViewContext.rollback()
        presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        setUpObservers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewDidAppear != true && crud == .Create {
            textFieldSubject.becomeFirstResponder()
            viewDidAppear = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
