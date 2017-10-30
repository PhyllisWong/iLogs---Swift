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
}

extension Directory {
    var moment: Moment {
        return self.info! as! Timer
    }
}

extension NSFetchedResultsController {
    func moment(at indexPath: IndexPath) -> Moment {
        return self.object(at: indexPath) as! Moment
    }
}

extension TimeStamp {
    enum Types: Int16 {
        case Start
        case Pause
    }
    
    convenience init(type: Types = .Start, timeStamp date: Date = Date(), timer: iLogs___Swift.Timer, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.stamp = date as NSDate
        self.owner = timer
        self.type = type.rawValue
    }
}

extension NSFetchedResultsController {
    func timeStamp(at indexPath: IndexPath) -> TimeStamp {
        return self.object(at: indexPath) as! TimeStamp
    }
}
