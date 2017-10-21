//
//  TimerTableViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/17/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: UIViewController, UITextViewDelegate {
    
    var timer: iLogs___Swift.Timer!
    
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.text = timer.notes
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: Text View Delegate
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        return true
    }
    
    // MARK: - VOID METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "dates table": //Initalize the embedded view
                let viewVC = segue.destination as! TimerFetchedRequestTableViewController
                viewVC.timer = timer
            default:
                break
            }
        }
    }
    
    // MARK: Text View Delegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        timer.notes = textView.text
        AppDelegate.sharedInstance.timersController.saveContext()
    }
    
    // MARK: - IBACTIONS
    
    @IBAction private func pressAdd(_ sender: Any) {
        _ = TimeStamp(type: .Start, timer: timer, in: AppDelegate.timersViewContext)
        AppDelegate.sharedInstance.timersController.saveContext()
    }
    
    @IBAction private func dismissKeyboard(_ sender: Any) {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = editButtonItem
    }

}

//
//  Timer Fetched Request Table View Controller
//

class TimerFetchedRequestTableViewController: FetchedResultsTableViewController {
    
    fileprivate var timer: iLogs___Swift.Timer! {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Time Stamps"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeStamp = fetchedResultsController.timeStamp(at: indexPath)
        let cell: CustomTableViewCell
        
        //Last time stamp in collection thus show initial cell
        if timeStamp == fetchedResultsController.fetchedObjects!.last! {
            cell = tableView.dequeueReusableCustomCell(withIdentifier: "initial", for: indexPath)
            cell.refreshTimer = UIKit.Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak cell] (timer) in
                guard let stamp = timeStamp.timeStamp as Date? else {return}
                cell?.config(timeStamp: stamp)
            })
        } else {
            cell = tableView.dequeueReusableCustomCell(withIdentifier: "extended", for: indexPath)
            let adjacentIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let adjacentTimeStamp = fetchedResultsController.timeStamp(at: adjacentIndexPath)
            cell.refreshTimer = UIKit.Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak cell] (timer) in
                guard let stamp = timeStamp.timeStamp as Date? else {return}
                guard let adjacentStamp = adjacentTimeStamp.timeStamp as Date? else {return}
                cell?.config(timeStamp: stamp, forExtendedCell: adjacentStamp)
            })
        }
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<TimeStamp> = TimeStamp.fetchRequest()
        fetch.predicate = NSPredicate(format: "timer = %@", timer)
        fetch.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.timersViewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
    }
    
    // MARK: Fetched Results Controller Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
        
        tableView.customCellForRow(at: indexPath)?.refreshTimer?.invalidate()
        
        //update the row above the deleting row to update the time between the
        //new adjacent rows
        if indexPath.row != 0 {
            let adjacentIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            tableView.reloadRows(at: [adjacentIndexPath], with: .automatic)
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveHandler = AppDelegate.sharedInstance.timersController.saveContext
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 78
    }
    
}

extension CustomTableViewCell {
    
    fileprivate func config(timeStamp: Date, forExtendedCell adjacentTimeStamp: Date? = nil) {
        self.labelTitle?.text = String(timeStamp, dateStyle: .long)
        self.labelSubtitle?.text = String(timeStamp.timeIntervalSinceNow)
        if adjacentTimeStamp != nil {
            let interval = timeStamp.timeIntervalSince(adjacentTimeStamp!)
            self.labelCaption?.text = String(interval)
        }
    }
}
