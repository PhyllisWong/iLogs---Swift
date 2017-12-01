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
    
    /// aux to allow not set on Int16
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
    
    /**
     if the count of stamps is odd, then a stamp does not have an upper stamp.
     Thus, the stop watch is still counting
     */
    var isPaused: Bool? {
        if lastStamp != nil { //is there a last, or any stamps?
            if self.stamps!.count.isEven { //odd number of stamps is stop watch is not paused
                return true
            } else {
                return false
            }
        } else { //no stamps
            return nil
        }
    }
    
    /**
     using the array.at(index:_), sum will pair stamps, even and odd counts, to
     create the sum in a time interval
     */
    var sum: TimeInterval? {
        if let _ = lastStamp {
            let stamps = sortedStamps!
            var sum: TimeInterval = 0
            for index in 0...(max(0, stamps.count - 1)) / 2 {
                let stampBounds = stamps.at(index: index)
                if stampBounds.upperStamp != nil {
                    sum += stampBounds.upperStamp!.stamp!.timeIntervalSince(stampBounds.lowerStamp.stamp! as Date)
                }
            }
            
            return sum
        } else {
            return nil
        }
    }
    
    
    /**
     using sum, this will add the duration since today's date if isPaused is true
     */
    var continuousSum: TimeInterval? {
        if let _ = sum {
            if isPaused! {
                return sum!
            } else {
                let sinceNow = Date().timeIntervalSince(lastStamp!.stamp! as Date)
                
                return sum! + sinceNow
            }
        } else {
            return nil
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

extension Array {
    
    /**
     returns the tuple of and index path's row, the stamp at the row and an
     optional upper stamp depending on the count of the array
     */
    func at(index i: Int) -> (lowerStamp: TimeStamp, upperStamp: TimeStamp?) {
        let index: Int
        if self.count.isEven {
            index = i * 2 + 1
        } else {
            index = i * 2
        }
        let lower = self[index] as! TimeStamp
        let upper: TimeStamp?
        if index == 0 {
            if self.count.isEven {
                upper = .some(self[index - 1] as! TimeStamp)
            } else {
                upper = nil
            }
        } else {
            upper = .some(self[index - 1] as! TimeStamp)
        }
        
        return (lower,upper)
    }
}
