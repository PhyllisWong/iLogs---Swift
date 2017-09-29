//
//  Entry.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/28/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(subject: String = "", date: Date = Date(), dateCreated: Date = Date(), diary: Diary, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.subject = subject
        self.date = date as NSDate
        self.dateCreated = dateCreated as NSDate
        self.diary = diary
    }
}

extension NSFetchedResultsController {
    func entry(at indexPath: IndexPath) -> Entry {
        return object(at: indexPath) as! Entry
    }
}
