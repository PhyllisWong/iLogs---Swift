//
//  Directory.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/24/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension Directory {
    
    @discardableResult
    convenience init(info: DirectoryInfo, parent: Directory?, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.info = info
    }
}

extension NSFetchedResultsController {
    func directory(at indexPath: IndexPath) -> Directory {
        return self.object(at: indexPath) as! Directory
    }
}
