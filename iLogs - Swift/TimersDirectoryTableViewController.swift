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
        
        let row = fetchedResultsController.directory(at: indexPath)
        cell.textLabel!.text = row.info!.title
        
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
        self.performSegue(withIdentifier: "show timer", sender: indexPath)
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func pressAdd(_ sender: UIBarButtonItem) {
        _ = iLogs___Swift.Timer(title: "Untitled", parent: currentDirectory, in: AppDelegate.timersViewContext)
        AppDelegate.sharedInstance.timersController.saveContext()
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveHandler = AppDelegate.sharedInstance.timersController.saveContext
        
        AppDelegate.sharedInstance.dismissableViewControllers.insert(self)
        
        updateUI()
        
        self.navigationItem.rightBarButtonItem = editButtonItem
    }

}
