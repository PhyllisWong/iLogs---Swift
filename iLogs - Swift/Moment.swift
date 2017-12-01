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
    
    /**
     sorts the set stamps by the decending order of the stamp date
     */
    var sortedStamps: [TimeStamp]? {
        return self.stamps?.sortedArray(using: [NSSortDescriptor(key: "stamp", ascending: false)]) as! [TimeStamp]?
    }
    
    /**
     since sortedStamps has the most recent stamp at index 0, this will return
     the first stamp in the sorted array, if available
     */
    var lastStamp: TimeStamp? {
        return sortedStamps?.first
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
        
        mutating func invert() {
            self = self == .Start ? .Pause : .Start
        }
        
        var inverse: Types {
            return self == .Start ? .Pause : .Start
        }
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
