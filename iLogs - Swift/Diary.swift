//
//  Diary.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/23/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension Diary {
    
    @discardableResult
    convenience init(title: String, dateCreated: Date = Date(), `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.dateCreated = dateCreated as NSDate
    }
    
    class func fetchDiaries() -> [Diary] {
        let fetch: NSFetchRequest<Diary> = Diary.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        
        return try! AppDelegate.diaryViewContext.fetch( fetch)
    }
    
    override public func prepareForDeletion() {
        super.prepareForDeletion()
        
        //Removes itself from user defaults as default diary if it is the default diary
        if let defaultDiary = UserDefaults.standard.value(forKey: "diary_default_diary") as! String? {
            if defaultDiary == self.objectID.uriRepresentation().absoluteString {
                UserDefaults.standard.setValue(nil, forKey: "diary_default_diary")
            }
        }
    }
}

extension NSFetchedResultsController {
    func diary(at indexPath: IndexPath) -> Diary {
        return object(at: indexPath) as! Diary
    }
}
