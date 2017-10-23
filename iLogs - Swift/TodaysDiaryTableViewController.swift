//
//  TodaysDiaryTableViewController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/23/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class TodaysDiaryTableViewController: FetchedResultsTableViewController {
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let entry = fetchedResultsController.entry(at: indexPath)
        cell.textLabel?.text = entry.subject
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date())
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)!
        fetch.predicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", dateFrom as NSDate, dateTo as NSDate)
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.diaryViewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show entry detail":
                let vc = segue.destination as! EntryDetailViewController
                let entry = fetchedResultsController.entry(at: tableView.indexPath(for: sender! as! UITableViewCell)!)
                vc.entry = entry
            default:
                break
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveHandler = AppDelegate.sharedInstance.diaryController.saveContext
        
        AppDelegate.sharedInstance.dismissableViewControllers.insert(self)
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
