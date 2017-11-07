//
//  Moments.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/29/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension Moment {
    
    @discardableResult
    convenience init(blankCopy source: Moment, `in` context: NSManagedObjectContext) {
        self.init(title: source.title!, parent: source.directory!.parent, in: context)
        
        self.dateCreated = NSDate()
        self.notes = source.notes
        self.collection = source.collection
    }
    
    var sortedStamps: [TimeStamp]? {
        return self.stamps?.sortedArray(using: [NSSortDescriptor(key: "stamp", ascending: false)]) as! [TimeStamp]?
    }
}

extension Directory {
    var moment: Moment {
        return self.info! as! Moment
    }
}

extension NSFetchedResultsController {
    func moment(at indexPath: IndexPath) -> Moment {
        return self.object(at: indexPath) as! Moment
    }
}

extension TimeStamp {
    enum Types: Int16 {
        case Start = 1
        case Pause = 2
    }
    
    var type: Types {
        return Types(rawValue: typeValue)!
    }
    
    @discardableResult
    convenience init(type: Types = .Start, timeStamp date: Date = Date(), moment: Moment, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.stamp = date as NSDate
        self.owner = moment
        self.typeValue = type.rawValue
    }
}

extension NSFetchedResultsController {
    func timeStamp(at indexPath: IndexPath) -> TimeStamp {
        return self.object(at: indexPath) as! TimeStamp
    }
}
