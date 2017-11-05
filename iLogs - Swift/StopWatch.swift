//
//  Timer.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/24/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension StopWatch {
    
    /** aux to allow not set on Int16 */
    var timeLimit: TimeInterval? {
        set {
            timeLimitValue = newValue != nil ? Int16(newValue!) : Int16(0)
        }
        get {
            if timeLimitValue == 0 {
                return nil
            } else {
                return TimeInterval(timeLimitValue)
            }
        }
    }
}

extension Moment {
    var isStopWatch: Bool {
        return self is StopWatch
    }
}

extension Directory {
    var stopWatch: StopWatch {
        return self.info! as! StopWatch
    }
}

extension NSFetchedResultsController {
    func stopWatch(at indexPath: IndexPath) -> StopWatch {
        return self.object(at: indexPath) as! StopWatch
    }
}
