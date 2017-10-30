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
