//
//  CollectionGroup.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 11/5/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension CollectionGroup {
}

extension Directory {
    var collectionGroup: CollectionGroup {
        return self.info! as! CollectionGroup
    }
}

extension NSFetchedResultsController {
    func collectionGroup(at indexPath: IndexPath) -> CollectionGroup {
        return self.object(at: indexPath) as! CollectionGroup
    }
}

extension iLogs___Swift.Collection {
    
    @discardableResult
    convenience init(title: String = "Untitled", dateCreated: Date = Date(), `for` collectionGroup: CollectionGroup, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.dateCreated = dateCreated as NSDate
        self.collectionGroup = collectionGroup
    }
}
