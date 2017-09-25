//
//  TimersTableViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/24/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class TimersTableViewController: FetchedResultsTableViewController {
    
    var currentDirectory: Directory?
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let row = fetchedResultsController.directory(at: indexPath)
        cell.textLabel!.text = row.timer.title
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        updateUI()
    }

}
