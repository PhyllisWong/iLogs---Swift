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
    
    private func updateUI() {
        if let stopWatch = moment as? StopWatch {
            if let _ = stopWatch.timeLimit {
                buttonTimeLimit.setTitle(String(stopWatch.timeLimit!), for: .normal)
                stepperTimeLimit.value = Double(stopWatch.timeLimit ?? 0)
            } else {
                buttonTimeLimit.setTitle("Not Set", for: .normal)
            }
        }
    }
    
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
    
    @IBOutlet weak var viewTimeLimit: UIView!
    @IBOutlet weak var stepperTimeLimit: UIStepper!
    @IBAction func stepperDidChange(_ sender: Any) {
        stepperTimeLimit.minimumValue = 1
        (moment as! StopWatch).timeLimit = TimeInterval(stepperTimeLimit.value)
        AppDelegate.sharedInstance.timersController.saveContext()
        updateUI()
    }
    
    @IBOutlet weak var buttonTimeLimit: UIButton!
    @IBAction func pressTimeLimit(_ sender: Any) {
        let stopWatch = moment as! StopWatch
        let alertTimeLimit = UITextAlertController(title: "Time Limit", message: "enter a time limit") { (textField) in
            textField.placeholder = "minutes"
            textField.keyboardType = .numberPad
        }
        alertTimeLimit.addAction(UIAlertAction(title: "Set", style: .default, handler: { [weak self] (action) in
            let timeLimit = TimeInterval(alertTimeLimit.inputField.text!)! // TODO : Custom number pad for time inputs
            stopWatch.timeLimit = timeLimit * 60
            AppDelegate.sharedInstance.timersController.saveContext()
            self?.updateUI()
        }))
        
        // only if a time limit already exists
        if stopWatch.timeLimit != nil {
            alertTimeLimit.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] (action) in
                stopWatch.timeLimit = nil //TODO : Fix stepper being set to 1
                self?.stepperTimeLimit.minimumValue = 0
                self?.stepperTimeLimit.value = 0
                AppDelegate.sharedInstance.timersController.saveContext()
                self?.updateUI()
            }))
        }
        alertTimeLimit.addDismissAction()
        self.present(alertTimeLimit, animated: true)
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
    
    override func viewDidLayoutSubviews() {
        if moment.isStopWatch == false {
            viewTimeLimit?.removeFromSuperview()
        }
        
        self.title = moment.isStopWatch ? "Stop Watch" : "Moment"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
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
    
    //TODO : auto update the table on changes
    private var fetchedObjects: [TimeStamp]? {
        return fetchedResultsController?.fetchedObjects as! [TimeStamp]?
    }
    
    private var refreshTimer: UIKit.Timer?
    
    private let controller = AppDelegate.sharedInstance.timersController
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if moment.isStopWatch {
            if let nObjects = fetchedObjects?.count {
                return Int(ceil(Double(Double(nObjects) / 2.0)))
            } else {
                return 0
            }
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Time Stamps"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell
        
        if moment.isStopWatch {
            cell = tableView.dequeueReusableCustomCell(withIdentifier: "cell", for: indexPath)
            let boundedStamps = fetchedObjects!.at(index: indexPath.row)
            let lowerStamp = boundedStamps.lowerStamp
            let higherStamp = boundedStamps.upperStamp
            cell.config(lowerStamp: lowerStamp, higherStamp: higherStamp)
        } else {
            let timeStamp = fetchedResultsController.timeStamp(at: indexPath)
            //The tast time stamp in collection thus show initial cell
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
    
    override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData() // TODO : update using the fetched results controller
    }
    
    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert: tableView.insertSections([sectionIndex], with: .fade)
//        case .delete: tableView.deleteSections([sectionIndex], with: .fade)
//        default: break
//        }
    }
    
    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
//        case .update:
//            tableView.reloadRows(at: [indexPath!], with: .fade)
//        case .move:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
//        }
    }
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if moment.isStopWatch {
            let timeStamps = fetchedObjects!.at(index: indexPath.row)
            let context = AppDelegate.timersViewContext
            context.delete(timeStamps.lowerStamp)
            if let upperStamp = timeStamps.upperStamp {
                context.delete(upperStamp)
            }
            AppDelegate.sharedInstance.timersController.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else {
            super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
        }
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
    
    /** set the cell's view based on what is available; @IBOutlet labels that are not nil */
    fileprivate func config(lowerStamp: TimeStamp, higherStamp: TimeStamp?) {
        self.labelTitle.text = String(lowerStamp.stamp!, dateStyle: .full)
        self.labelCaption.text = String(lowerStamp.stamp!, dateStyle: .none, timeStyle: .medium)
        if let upperStamp = higherStamp {
            let trailingDay: String? // If the two stamps are different days, print the day for the upper stamp
            let calendar = Calendar.current
            var lowerDay = DateComponents(date: lowerStamp.stamp! as Date, forComponents: [.day, .month, .year, .weekday, .weekOfYear])
            lowerDay.calendar = calendar
            var upperDay = DateComponents(date: upperStamp.stamp! as Date, forComponents: [.day, .month, .year, .weekday, .weekOfYear])
            upperDay.calendar = calendar
            if lowerDay == upperDay {
                trailingDay = nil
            } else {
                if lowerDay.weekOfYear! != upperDay.weekOfYear! {
                    // show month, day and year
                    trailingDay = String(upperStamp.stamp!, dateStyle: .medium)
                } else {
                    // show only weekday
                    trailingDay = upperDay.weekdayTitle!
                }
            }
            self.labelCaption2.text = String(upperStamp.stamp!, dateStyle: .none, timeStyle: .medium) + (trailingDay != nil ? "\n\(trailingDay!)" : "")
            let variance = upperStamp.stamp!.timeIntervalSince(lowerStamp.stamp! as Date)
            self.labelSubtitle.text = String(variance)
        } else {
            self.labelCaption2.text = "now"
            let variance = Date().timeIntervalSince(lowerStamp.stamp! as Date)
            self.labelSubtitle.text = String(variance)
        }
    }
}
