//
//  TimerTableViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/17/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var timer: iLogs___Swift.Timer!
    
    private let controller = AppDelegate.sharedInstance.timersController
    
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshTimer: UIKit.Timer?
    
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject>! {
        didSet {
            if let controller = fetchedResultsController {
                controller.delegate = self
                do {
                    try controller.performFetch()
                } catch {
                    print(error.localizedDescription)
                }
                tableView.reloadData()
            }
        }
    }
    
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.text = timer.notes
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.text = timer.title
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: Table View
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Time Stamps"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeStamp = fetchedResultsController.timeStamp(at: indexPath)
        let cell: CustomTableViewCell
        
        //Last time stamp in collection thus show initial cell
        if timeStamp == fetchedResultsController.fetchedObjects!.last! {
            cell = tableView.dequeueReusableCustomCell(withIdentifier: "initial", for: indexPath)
            let stamp = timeStamp.timeStamp! as Date
            cell.config(timeStamp: stamp)
        } else {
            cell = tableView.dequeueReusableCustomCell(withIdentifier: "extended", for: indexPath)
            let adjacentIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let adjacentTimeStamp = fetchedResultsController.timeStamp(at: adjacentIndexPath)
            let stamp = timeStamp.timeStamp! as Date
            let adjacentStamp = adjacentTimeStamp.timeStamp as Date?
            cell.config(timeStamp: stamp, forExtendedCell: adjacentStamp)
        }
        
        return cell
    }
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        timer.title = textField.text
        controller.saveContext()
    }
    
    // MARK: Text View Delegate
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        return true
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
    
    // MARK: Text View Delegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        timer.notes = textView.text
        controller.saveContext()
    }
    
    // MARK: - IBACTIONS
    
    @IBAction private func pressAdd(_ sender: Any) {
        _ = TimeStamp(type: .Start, timer: timer, in: AppDelegate.timersViewContext)
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
        
        updateUI()
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

extension TimerViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: tableView.insertSections([sectionIndex], with: .fade)
        case .delete: tableView.deleteSections([sectionIndex], with: .fade)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: Fetched Results Controller Delegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let row = fetchedResultsController.object(at: indexPath)
            let context = row.managedObjectContext!
            context.delete(row)
            AppDelegate.sharedInstance.timersController.saveContext()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

extension CustomTableViewCell {
    
    fileprivate func config(timeStamp: Date, forExtendedCell adjacentTimeStamp: Date? = nil) {
        self.labelTitle?.text = String(timeStamp, dateStyle: .full, timeStyle: .medium)
        self.labelSubtitle?.text = String(timeStamp.timeIntervalSinceNow)
        if adjacentTimeStamp != nil {
            let interval = timeStamp.timeIntervalSince(adjacentTimeStamp!)
            self.labelCaption?.text = String(interval)
        }
    }
}
