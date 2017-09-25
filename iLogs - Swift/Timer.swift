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
