//
//  CollectionGroupViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 11/5/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import  CoreData

class CollectionGroupViewController: UIViewController, UITableViewDelegate {
    
    var collectionGroup: CollectionGroup!
    
    var currentInstance: iLogs___Swift.Collection? {
        return collectionGroup.currentInstance
    }
    
    private var tableViewController: CollectionItemFetchedRequestTableViewController!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSum: UILabel!
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        labelTitle.text = currentInstance?.title ?? "No saved instances"
        // disable adding a moment/stopwatch
        buttonAdd.isEnabled = currentInstance != nil
        
        updateInfo()
        tableViewController.instance = currentInstance
    }
    
    private func updateInfo() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "embed":
                tableViewController = segue.destination as! CollectionItemFetchedRequestTableViewController
                tableViewController.instance = currentInstance
                tableViewController.tableView.delegate = self
            default:
                break
            }
        }
    }
    
    // MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tableViewController.fetchedResultsController.moment(at: indexPath)
        if item.isStopWatch {
            let lastStampType: TimeStamp.Types = item.lastStamp?.type.inverse ?? .Start
            TimeStamp(type: lastStampType, timeStamp: Date(), moment: item, in: AppDelegate.timersViewContext)
            AppDelegate.sharedInstance.timersController.saveContext()
        } else {
            TimeStamp(type: .Start, timeStamp: Date(), moment: item, in: AppDelegate.timersViewContext)
            AppDelegate.sharedInstance.timersController.saveContext()
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBAction func pressAdd(_ sender: Any) {
        func rename(_ object: Moment, complition: @escaping () -> Void) {
            let alertTitle = UITextAlertController(title: "Add", message: "enter a title", textFieldConfig: nil)
            alertTitle.addButton(title: "Add", with: { (action) in
                let title = alertTitle.inputField.text!
                object.title = title
                complition()
            })
            .present(in: self)
            
//            let alertTitle = UITextAlertController(title: "Add", message: "enter a title")
//            alertTitle.addConfirmAction(action: UIAlertActionInfo(title: "Add", handler: { (action) in
//                let title = alertTitle.inputField.text!
//                object.title = title
//                complition()
//            }))
//            self.present(alertTitle, animated: true)
        }
        
        let alertNewMoment = UIAlertController(title: "Add New", message: nil, preferredStyle: .actionSheet)
        alertNewMoment.addActions(
            actions: UIAlertActionInfo(title: "Moment", handler: { [weak self] (action) in
                let alertTitle = UITextAlertController(title: "Add", message: "enter a title", textFieldConfig: nil)
                alertTitle.addButton(title: "Add", with: { [weak self] (action) in
                    let title = alertTitle.inputField.text!
                    let moment = Moment(title: title, parent: self!.collectionGroup.directory, in: AppDelegate.timersViewContext)
                    moment.collection = self!.currentInstance!
                    AppDelegate.sharedInstance.timersController.saveContext()
                })
                .present(in: self!)
                
//                let alertTitle = UITextAlertController(title: "Add", message: "enter a title")
//                alertTitle.addConfirmAction(action: UIAlertActionInfo(title: "Add", handler: { [weak self] (action) in
//                    let title = alertTitle.inputField.text!
//                    let moment = Moment(title: title, parent: self!.collectionGroup.directory, in: AppDelegate.timersViewContext)
//                    moment.collection = self!.currentInstance!
//                    AppDelegate.sharedInstance.timersController.saveContext()
//                }))
//                self!.present(alertTitle, animated: true)
            }),
            UIAlertActionInfo(title: "Stop Watch", handler: { [weak self] (action) in
                let alertTitle = UITextAlertController(title: "Add", message: "enter a title", textFieldConfig: nil)
                alertTitle.addButton(title: "Add", with: { [weak self] (action) in
                    let title = alertTitle.inputField.text!
                    let stopWatch = StopWatch(title: title, parent: self!.collectionGroup.directory, in: AppDelegate.timersViewContext)
                    stopWatch.collection = self!.currentInstance!
                    AppDelegate.sharedInstance.timersController.saveContext()
                })
                .present(in: self!)
                
//                let alertTitle = UITextAlertController(title: "Add", message: "enter a title")
//                alertTitle.addConfirmAction(action: UIAlertActionInfo(title: "Add", handler: { [weak self] (action) in
//                    let title = alertTitle.inputField.text!
//                    let stopWatch = StopWatch(title: title, parent: self!.collectionGroup.directory, in: AppDelegate.timersViewContext)
//                    stopWatch.collection = self!.currentInstance!
//                    AppDelegate.sharedInstance.timersController.saveContext()
//                }))
//                self!.present(alertTitle, animated: true)
            })
        )
        self.present(alertNewMoment, animated: true)
    }
    
    @IBAction func pressNewGroupInstance(_ sender: Any) {
        if currentInstance != nil { // There is at least one instance created
            let actionNewInstance = UIAlertController(title: "New Instance", message: nil, preferredStyle: .actionSheet)
            func insert(`for` copyType: CopyOptions<Directory>) {
                let alertTitle = UITextAlertController(title: "New Instance", message: "enter a title", textFieldConfig: nil)
                alertTitle.addButton(title: "Add", with: { [weak self] (action) in
                    let title = alertTitle.inputField.text!
                    let newCollectionInstance = iLogs___Swift.Collection(title: title, for: self!.collectionGroup, in: AppDelegate.timersViewContext)
                    
                    //Create deep copies but with default attributes such as the date created
                    switch copyType {
                    case .All:
                        for item in self!.currentInstance!.items! as! Set<Moment> {
                            let copiedItem: Moment
                            if item.isStopWatch {
                                copiedItem = StopWatch(blankCopy: item, in: AppDelegate.timersViewContext)
                            } else {
                                copiedItem = Moment(blankCopy: item, in: AppDelegate.timersViewContext)
                            }
                            copiedItem.collection = newCollectionInstance
                        }
                    case .Some(let selectedItems):
                        break
                    case .None:
                        break
                    }
                    self!.collectionGroup.currentInstance = newCollectionInstance
                    AppDelegate.sharedInstance.timersController.saveContext()
                    self!.updateUI()
                })
                .addCancelButton()
                .present(in: self)
                
                
                
//                let alertTitle = UITextAlertController(title: "New Instance", message: "enter a title")
//                alertTitle.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (action) in
//                    let title = alertTitle.inputField.text!
//                    let newCollectionInstance = iLogs___Swift.Collection(title: title, for: self!.collectionGroup, in: AppDelegate.timersViewContext)
//
//                    //Create deep copies but with default attributes such as the date created
//                    switch copyType {
//                    case .All:
//                        for item in self!.currentInstance!.items! as! Set<Moment> {
//                            let copiedItem: Moment
//                            if item.isStopWatch {
//                                copiedItem = StopWatch(blankCopy: item, in: AppDelegate.timersViewContext)
//                            } else {
//                                copiedItem = Moment(blankCopy: item, in: AppDelegate.timersViewContext)
//                            }
//                            copiedItem.collection = newCollectionInstance
//                        }
//                    case .Some(let selectedItems):
//                        break
//                    case .None:
//                        break
//                    }
//                    self!.collectionGroup.currentInstance = newCollectionInstance
//                    AppDelegate.sharedInstance.timersController.saveContext()
//                    self!.updateUI()
//                }))
//                alertTitle.addDismissAction()
//                self.present(alertTitle, animated: true)
            }
            actionNewInstance.addActions(
                actions:
                UIAlertActionInfo(title: "Copy All Items", handler: { (action) in
                    insert(for: .All)
                }),
                UIAlertActionInfo(title: "Copy None", handler: { (action) in
                    insert(for: .None)
                }),
                UIAlertActionInfo(title: "Select Some...", handler: { (action) in
                    // TODO : select some items to copy
                })
            )
            self.present(actionNewInstance, animated: true)
        } else { // None are created thus create an empty one
            let alertTitle = UITextAlertController(title: "New Instance", message: "enter a title", textFieldConfig: nil)
            alertTitle.addButton(title: "Add", with: { [weak self] (action) in
                let title = alertTitle.inputField.text!
                let instance = iLogs___Swift.Collection(title: title, for: self!.collectionGroup, in: AppDelegate.timersViewContext)
                self!.collectionGroup.currentInstance = instance
                AppDelegate.sharedInstance.timersController.saveContext()
                self!.updateUI()
            })
            .addCancelButton()
            .present(in: self)
            
//            let alertTitle = UITextAlertController(title: "New Instance", message: "enter a title")
//            alertTitle.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (action) in
//                let title = alertTitle.inputField.text!
//                let instance = iLogs___Swift.Collection(title: title, for: self!.collectionGroup, in: AppDelegate.timersViewContext)
//                self!.collectionGroup.currentInstance = instance
//                AppDelegate.sharedInstance.timersController.saveContext()
//                self!.updateUI()
//            }))
//            alertTitle.addDismissAction()
//            self.present(alertTitle, animated: true)
        }
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = collectionGroup.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
}

class CollectionItemFetchedRequestTableViewController: FetchedResultsTableViewController {
    
    fileprivate var instance: iLogs___Swift.Collection? {
        didSet {
            updateUI()
        }
    }
    
    private var refreshTimer: UIKit.Timer?
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Items"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = fetchedResultsController.moment(at: indexPath)
        if row.isStopWatch {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stop watch", for: indexPath)
            let stopWatch = row as! StopWatch
            
            cell.textLabel!.text = row.title
            if stopWatch.isPaused ?? true { //no timer is counting or empty list of timers
                cell.detailTextLabel!.textColor = UIColor.black
            } else {
                cell.detailTextLabel!.textColor = UIColor.blue
            }
            if let sum = stopWatch.continuousSum {
                cell.detailTextLabel!.text = "Sum: \(String(timeInterval: sum))"
            } else {
                cell.detailTextLabel!.text = "No recorded time stamps"
                cell.detailTextLabel!.textColor = UIColor.darkText
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moment", for: indexPath)
            let moment = row as Moment
            
            cell.textLabel!.text = row.title
            if let timeStamp = moment.lastStamp {
                cell.detailTextLabel!.text = "Last time stamp: \(String(date: timeStamp.stamp!, dateStyle: .medium, timeStyle: .medium))"
                cell.detailTextLabel!.textColor = UIColor.black
            } else {
                cell.detailTextLabel!.text = "No recoreded time stamps"
                cell.detailTextLabel!.textColor = UIColor.darkText
            }
            
            return cell
        }
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        if instance != nil {
            let fetch: NSFetchRequest<Moment> = Moment.fetchRequest()
            fetch.predicate = NSPredicate(format: "collection = %@", instance!)
            fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
                fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
                managedObjectContext: AppDelegate.timersViewContext,
                sectionNameKeyPath: nil, cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show moment":
                let vc = segue.destination as! MomentViewController
                let cell = sender as! UITableViewCell
                let indexPath = tableView.indexPath(for: cell)!
                vc.moment = fetchedResultsController.moment(at: indexPath)
            default:
                break
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveHandler = AppDelegate.sharedInstance.timersController.saveContext
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
