//
//  TimersTableViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/24/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class TimersDirectoryTableViewController: FetchedResultsTableViewController {
    
    var currentDirectory: Directory?
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let directory = fetchedResultsController.directory(at: indexPath)
        cell.textLabel!.text = directory.info!.title
        cell.accessoryType = .none
        switch directory.info! {
        case is StopWatch:
            let stopWatch = directory.stopWatch
            if let sum = stopWatch.sum {
                cell.detailTextLabel!.text = "Sum: \(String(sum))"
            } else {
                cell.detailTextLabel!.text = "Sum: 0m"
            }
        case is Moment:
            let moment = directory.moment
            if let timeStamp = moment.lastStamp {
                cell.detailTextLabel!.text = "Last time stamp: \(String(timeStamp.stamp!, dateStyle: .medium, timeStyle: .medium))"
            } else {
                cell.detailTextLabel!.text = "No recoreded time stamps"
            }
        case is CollectionGroup, is Folder:
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel!.text = nil
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<Directory> = Directory.fetchRequest()
        if let directory = currentDirectory {
            fetch.predicate = NSPredicate(format: "parent == %@", directory)
        } else {
            fetch.predicate = NSPredicate(format: "parent == NULL")
        }
        fetch.sortDescriptors = [NSSortDescriptor(key: "info.title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.timersViewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show directory":
                let vc = segue.destination as! TimersDirectoryTableViewController
                let indexPath = sender as! IndexPath
                let directory = fetchedResultsController.directory(at: indexPath)
                vc.currentDirectory = directory
            case "show collection":
                let vc = segue.destination as! CollectionGroupViewController
                let indexPath = sender as! IndexPath
                let directory = fetchedResultsController.directory(at: indexPath)
                vc.collectionGroup = directory.collectionGroup
            case "show moment": // TODO: refactor timer to moment
                let vc = segue.destination as! MomentViewController
                let indexPath = sender as! IndexPath
                let directory = fetchedResultsController.directory(at: indexPath)
                vc.moment = directory.moment
            default:
                break
            }
        }
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let directory = fetchedResultsController.directory(at: indexPath)
        switch directory.info {
        case is StopWatch, is Moment:
            self.performSegue(withIdentifier: "show moment", sender: indexPath)
        case is CollectionGroup:
            self.performSegue(withIdentifier: "show collection", sender: indexPath)
        case is Folder:
            self.performSegue(withIdentifier: "show directory", sender: indexPath)
        default:
            fatalError("Directory.info type not handled")
        }
    }
    
    // MARK: - IBACTIONS
    
    // TDOD: add collection group
    @IBAction func pressAdd(_ sender: UIBarButtonItem) {
        let alertAdd = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        func addAction(actionTitle: String, alertTitle: String, alertMessage: String, complitionHandler handler: @escaping (String) -> Void) {
            alertAdd.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { [weak self] (action) in
                let alertTitle = UITextAlertController(title: alertTitle, message: alertMessage)
                alertTitle.addConfirmAction(action: UIAlertAction(title: "Add", style: .default, handler: { (action) in
                    let title = alertTitle.inputField.text!
                    handler(title)
                    AppDelegate.sharedInstance.timersController.saveContext()
                }))
                self?.present(alertTitle, animated: true)
            }))
        }
        
        addAction(actionTitle: "Folder", alertTitle: "Add a Folder", alertMessage: "enter a title", complitionHandler: { [weak self] title in
            Folder(title: title, parent: self?.currentDirectory, in: AppDelegate.timersViewContext)
        })
        addAction(actionTitle: "Collection", alertTitle: "Add a Collection", alertMessage: "enter a title", complitionHandler: { [weak self] title in
            CollectionGroup(title: title, parent: self?.currentDirectory, in: AppDelegate.timersViewContext)
        })
        addAction(actionTitle: "Moment", alertTitle: "Add a Moment", alertMessage: "enter a title", complitionHandler: { [weak self] title in
            Moment(title: title, parent: self?.currentDirectory, in: AppDelegate.timersViewContext)
        })
        addAction(actionTitle: "Stop Watch", alertTitle: "Add a Stop Watch", alertMessage: "enter a title", complitionHandler: { [weak self] title in
            StopWatch(title: title, parent: self?.currentDirectory, in: AppDelegate.timersViewContext)
        })
        alertAdd.addDismissAction()
        self.present(alertAdd, animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveHandler = AppDelegate.sharedInstance.timersController.saveContext
        
        AppDelegate.sharedInstance.dismissableViewControllers.insert(self)
        
        updateUI()
        
        title = currentDirectory?.info!.title ?? "Root"
    }

}
