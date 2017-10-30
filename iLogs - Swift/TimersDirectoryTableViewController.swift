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
        cell.detailTextLabel!.text = String(directory)
        
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
                break
            case "show timer":
                let vc = segue.destination as! TimerViewController
                let indexPath = sender as! IndexPath
                let directory = fetchedResultsController.directory(at: indexPath)
                vc.timer = directory.timer
            default:
                break
            }
        }
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: check what cell was tapped, timer or a folder
        // self.performSegue(withIdentifier: "show timer", sender: indexPath)
    }
    
    // MARK: - IBACTIONS
    
    //add folder, moment, timer
    //add collection group
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
        addAction(actionTitle: "Timer", alertTitle: "Add a Timer", alertMessage: "enter a title", complitionHandler: { [weak self] title in
            Timer(title: title, parent: self?.currentDirectory, in: AppDelegate.timersViewContext)
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
    }

}
