//
//  DiaryTableViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/26/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class DiaryTableViewController: FetchedResultsTableViewController, CustomTableViewCellDelegate {
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diary = fetchedResultsController.diary(at: indexPath)
        if tableView.isEditing {
            let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath) as! CustomTableViewCell
            
            cell.labelTitle.text = diary.title
            cell.switcher.isOn = diary.isArchived.inverse
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
            
            cell.labelTitle.text = diary.title
            
            return cell
        }
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<Diary> = Diary.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        if tableView.isEditing != true {
            fetch.predicate = NSPredicate(format: "isArchived == FALSE")
        }
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.diaryViewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        buttonAdd.isEnabled = editing.inverse
        buttonDone.isEnabled = editing.inverse
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Delegate
    // TODO Update arraganging Diaryies
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let diary = fetchedResultsController.diary(at: indexPath)
            let alertRename = UIAlertController(title: "Rename Diary", message: "enter a new title", preferredStyle: .alert)
            alertRename.addTextField(configurationHandler: { (textField) in
                textField.setStyleToParagraph(withPlaceholderText: "title", withInitalText: diary.title)
            })
            alertRename.addActions(actions: UIAlertActionInfo(title: "Rename", handler: { (action) in
                diary.title = alertRename.inputField.text
                AppDelegate.sharedInstance.diaryController.saveContext()
            }))
            present(alertRename, animated: true)
        } else {
            //TODO Update visiability on which diary is showing in the filter
        }
    }
    
    // MARK: Custom Table View Cell Delegate
    
    func customCell(_ cell: CustomTableViewCell, switchDidChange switcher: UISwitch) {
        let indexPath = tableView.indexPath(for: cell)!
        let diary = fetchedResultsController.diary(at: indexPath)
        diary.isArchived = switcher.isOn.inverse
        AppDelegate.sharedInstance.diaryController.saveContext()
        
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBAction func pressAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Add a Diary", message: "enter a title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.setStyleToParagraph(withPlaceholderText: "title")
        }
        alert.addActions(actions: UIAlertActionInfo(title: "Add", handler: { (action) in
            let diaryTitle = alert.inputField.text!
            _ = Diary(title: diaryTitle, in: AppDelegate.diaryViewContext)
            AppDelegate.sharedInstance.diaryController.saveContext()
        }))
        present(alert, animated: true)
    }
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBAction func pressDone(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveHandler = AppDelegate.sharedInstance.diaryController.saveContext
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateUI()
    }

}
