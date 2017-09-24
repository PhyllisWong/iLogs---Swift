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
    convenience init(name: String, dateCreated: Date = Date(), `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = name
        self.dateCreated = dateCreated as NSDate
    }
}

extension NSFetchedResultsController {
    func diary(at indexPath: IndexPath) -> Diary {
        return object(at: indexPath) as! Diary
    }
}
