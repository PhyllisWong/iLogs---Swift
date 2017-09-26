//
//  DiaryTableViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/26/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class DiaryTableViewController: FetchedResultsTableViewController {
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diary = fetchedResultsController.diary(at: indexPath)
        if tableView.isEditing {
            let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath) as! CustomTableViewCell
            
            cell.labelTitle.text = diary.title
            cell.switcher.isOn = diary.isArchived.inverse
            
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
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.diaryViewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        buttonAdd.isEnabled = editing.inverse
        buttonDone.isEnabled = editing.inverse
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateUI()
    }

}
