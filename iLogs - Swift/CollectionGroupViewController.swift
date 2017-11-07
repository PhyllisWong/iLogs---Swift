//
//  CollectionGroupViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 11/5/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import  CoreData

class CollectionGroupViewController: UIViewController {
    
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
            default:
                break
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBAction func pressAdd(_ sender: Any) {
        let alertNewMoment = UIAlertController(title: "Add New", message: nil, preferredStyle: .actionSheet)
        alertNewMoment.addActions(
            actions: UIAlertActionInfo(title: "Moment", handler: { [weak self] (action) in
                let moment = Moment(title: "Untitled", parent: self!.collectionGroup.directory, in: AppDelegate.timersViewContext)
                moment.collection = self!.currentInstance!
                AppDelegate.sharedInstance.timersController.saveContext()
            }),
            UIAlertActionInfo(title: "Stop Watch", handler: { [weak self] (action) in
                let stopWatch = StopWatch(title: "Untitled", parent: self!.collectionGroup.directory, in: AppDelegate.timersViewContext)
                stopWatch.collection = self!.currentInstance!
                AppDelegate.sharedInstance.timersController.saveContext()
            })
        )
        self.present(alertNewMoment, animated: true)
    }
    
    @IBAction func pressNewGroupInstance(_ sender: Any) {
        if currentInstance != nil { // There is at least one instance created
            let actionNewInstance = UIAlertController(title: "New Instance", message: nil, preferredStyle: .actionSheet)
            func insert(`for` copyType: CopyOptions<Directory>) {
                let alertTitle = UITextAlertController(title: "New Instance", message: "enter a title")
                alertTitle.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (action) in
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
                }))
                alertTitle.addDismissAction()
                self.present(alertTitle, animated: true)
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
            let alertTitle = UITextAlertController(title: "New Instance", message: "enter a title")
            alertTitle.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (action) in
                let title = alertTitle.inputField.text!
                let instance = iLogs___Swift.Collection(title: title, for: self!.collectionGroup, in: AppDelegate.timersViewContext)
                self!.collectionGroup.currentInstance = instance
                AppDelegate.sharedInstance.timersController.saveContext()
                self!.updateUI()
            }))
            alertTitle.addDismissAction()
            self.present(alertTitle, animated: true)
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
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = fetchedResultsController.moment(at: indexPath)
        if row.isStopWatch {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stop watch", for: indexPath)
            
            cell.textLabel!.text = row.title
            cell.detailTextLabel!.text = "I am a Stop Watch"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moment", for: indexPath)
            
            cell.textLabel!.text = row.title
            cell.detailTextLabel!.text = "I am a Moment"
            
            return cell
        }
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        if instance != nil {
            let fetch: NSFetchRequest<Moment> = Moment.fetchRequest()
            fetch.predicate = NSPredicate(format: "collection = %@", instance!)
            fetch.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
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

}
