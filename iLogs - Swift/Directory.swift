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
        self.parent = parent
    }
}

extension String {
    init(_ directory: Directory) {
        let info = directory.info!
        switch info {
        case is StopWatch:
            self.init("I am a Stop Watch")!
        case is Moment:
            self.init("I am a Moment")!
        case is CollectionGroup:
            self.init("I am a Collection Group")!
        case is Folder:
            self.init("I am a Folder")!
        default:
            self.init("Undefined")!
        }
    }
}

extension NSFetchedResultsController {
    func directory(at indexPath: IndexPath) -> Directory {
        return self.object(at: indexPath) as! Directory
    }
}

extension DirectoryInfo {
    
    @discardableResult
    convenience init(title: String, dateCreated date: Date = Date(), parent: Directory?, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.dateCreated = date as NSDate
        
        Directory(info: self, parent: parent, in: context)
    }
}
