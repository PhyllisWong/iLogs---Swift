//
//  DiaryController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/23/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

class DiaryController {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.undoManager = UndoManager()
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    var defaultDiary: Diary {
        get {
            if let employer = UserDefaults.standard.string(forKey: "diary_default_diary") { //Fetches the default employer
                if let objectId = self.persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: URL(string: employer)!) {
                    return self.persistentContainer.viewContext.object(with: objectId) as! Diary
                } else { //Not found, then remove the saved Id and create a new default
                    UserDefaults.standard.setValue(nil, forKey: "diary_default_diary")
                    
                    return self.defaultDiary
                }
            } else { //Assume there is no employer saved in context and create a new one
                let defaultEmployer = Diary(title: "Untitled Diary", in: self.persistentContainer.viewContext)
                self.saveContext() //Save new object in store first before saving the ID into User Defaults
                self.defaultDiary = defaultEmployer
                
                return self.defaultDiary
            }
        }
        set {
            UserDefaults.standard.setValue(newValue.objectID.uriRepresentation().absoluteString, forKey: "diary_default_diary")
            UserDefaults.standard.synchronize()
        }
    }
}

extension AppDelegate {
    class var diaryViewContext: NSManagedObjectContext {
        return AppDelegate.sharedInstance.diaryController.persistentContainer.viewContext
    }
}
