//
//  TimerTableViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/17/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class MomentViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var moment: Moment!
    
    private let controller = AppDelegate.sharedInstance.timersController
    
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.text = moment.notes
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.text = moment.title
        }
    }
    
    @IBOutlet weak var stepperTimeLimit: UIStepper!
    @IBAction func stepperDidChange(_ sender: Any) {
        (moment as! StopWatch).time
    }
    
    @IBOutlet weak var buttonTimeLimit: UIButton!
    @IBAction func pressTimeLimit(_ sender: Any) {
        
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moment.title = textField.text
        controller.saveContext()
    }
    
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
                viewVC.moment = moment
            default:
                break
            }
        }
    }
    
    // MARK: Text View Delegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        moment.notes = textView.text
        controller.saveContext()
    }
    
    // MARK: - IBACTIONS
    
    @IBAction private func pressAdd(_ sender: Any) {
        let type: TimeStamp.Types
        if moment.isStopWatch {
            if let lastStamp = moment.sortedStamps?.first {
                type = lastStamp.type == .Start ? .Pause : .Start
            } else {
                type = .Start
            }
        } else {
            type = .Start
        }
        TimeStamp(type: type, moment: moment, in: AppDelegate.timersViewContext)
        controller.saveContext()
    }
    
    @IBAction private func dismissKeyboard(_ sender: Any) {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = moment.isStopWatch ? "Stop Watch" : "Moment"
    }

}

//
//  Timer Fetched Request Table View Controller
//

class TimerFetchedRequestTableViewController: FetchedResultsTableViewController {
    
    fileprivate var moment: Moment! {
        didSet {
            updateUI()
        }
    }
    
    private var refreshTimer: UIKit.Timer?
    
    private let controller = AppDelegate.sharedInstance.timersController
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Time Stamps"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeStamp = fetchedResultsController.timeStamp(at: indexPath)
        let cell: CustomTableViewCell
        
        if moment.isStopWatch {
            //Last time stamp in collection thus show initial cell
            if timeStamp == fetchedResultsController.fetchedObjects!.last! {
                cell = tableView.dequeueReusableCustomCell(withIdentifier: "initial", for: indexPath)
                let stamp = timeStamp.stamp! as Date
                cell.config(timeStamp: stamp)
            } else {
                cell = tableView.dequeueReusableCustomCell(withIdentifier: "extended", for: indexPath)
                let adjacentIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                let adjacentTimeStamp = fetchedResultsController.timeStamp(at: adjacentIndexPath)
                let stamp = timeStamp.stamp! as Date
                let adjacentStamp = adjacentTimeStamp.stamp as Date?
                cell.config(timeStamp: stamp, forExtendedCell: adjacentStamp)
            }
        } else {
            cell = tableView.dequeueReusableCustomCell(withIdentifier: "cell", for: indexPath)
            let stamp = fetchedResultsController.timeStamp(at: indexPath)
            cell.config(timeStamp: stamp.stamp! as Date)
        }
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<TimeStamp> = TimeStamp.fetchRequest()
        fetch.predicate = NSPredicate(format: "owner = %@", moment)
        fetch.sortDescriptors = [NSSortDescriptor(key: "stamp", ascending: false)]
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.timersViewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
    }
    
    // MARK: Fetched Results Controller Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
        // TODO: Update rows when the last row is deleted
//        tableView.customCellForRow(at: indexPath)?.refreshTimer?.invalidate()
//        
//        //update the row above the deleting row to update the time between the
//        //new adjacent rows
//        if indexPath.row != 0 {
//            let adjacentIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
//            tableView.reloadRows(at: [adjacentIndexPath], with: .automatic)
//        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveHandler = controller.saveContext
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 78
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshTimer = UIKit.Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            if self?.tableView.isEditing == false {
                self?.tableView.reloadData() // TODO : May break during iCloud Sync
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        refreshTimer?.invalidate()
    }
    
}

extension CustomTableViewCell {
    
    /** set the cell's view based on what is available; @IBOutlet labels that are not nil */
    fileprivate func config(timeStamp: Date, forExtendedCell adjacentTimeStamp: Date? = nil) {
        self.labelTitle?.text = String(timeStamp, dateStyle: .full, timeStyle: .medium)
        self.labelSubtitle?.text = String(timeStamp.timeIntervalSinceNow)
        if adjacentTimeStamp != nil {
            let interval = timeStamp.timeIntervalSince(adjacentTimeStamp!)
            self.labelCaption?.text = String(interval)
        }
    }
}
