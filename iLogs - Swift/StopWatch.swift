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
