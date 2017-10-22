//
//  Timer.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/24/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension iLogs___Swift.Timer {
    convenience init(title: String, dateCreated date: Date = Date(), parent: Directory?, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.dateCreated = date as NSDate
        
        _ = Directory(info: self, parent: parent, in: context)
    }
}

extension Directory {
    var timer: Timer {
        return self.info! as! Timer
    }
}

extension NSFetchedResultsController {
    func timer(at indexPath: IndexPath) -> iLogs___Swift.Timer {
        return self.object(at: indexPath) as! iLogs___Swift.Timer
    }
}

extension TimeStamp {
    enum Types: Int16 {
        case Start
        case Stop
    }
    
    convenience init(type: Types, timeStamp date: Date = Date(), timer: iLogs___Swift.Timer, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.timeStamp = date as NSDate
        self.timer = timer
        self.stampValue = type.rawValue
    }
}

extension NSFetchedResultsController {
    func timeStamp(at indexPath: IndexPath) -> TimeStamp {
        return self.object(at: indexPath) as! TimeStamp
    }
}
