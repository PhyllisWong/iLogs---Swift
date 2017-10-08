//
//  Entry.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/28/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(subject: String = "", date: Date = Date(), dateCreated: Date = Date(), diary: Diary, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.subject = subject
        self.date = date as NSDate
        self.dateCreated = dateCreated as NSDate
        self.diary = diary
    }
}

extension NSFetchedResultsController {
    func entry(at indexPath: IndexPath) -> Entry {
        return object(at: indexPath) as! Entry
    }
}

extension WeatherCondition {
    convenience init(conditionType: WeatherCondition.Types, scaleType scale: ScaleDescriptor, `for` entry: Entry, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.entry = entry
        self.conditionValue = conditionType.rawValue
        self.scaleValue = scale.rawValue
    }
    
    /** Convert Weather Condition Value to a type */
    var conditionType: WeatherCondition.Types {
        return WeatherCondition.Types(rawValue: conditionValue)!
    }
    
    var scaleType: ScaleDescriptor? {
        switch conditionType {
        case .Cloudy:
            let type = WeatherCondition.CloudyScale(rawValue: scaleValue)!
            return type == .NotSet ? nil : type
        case .Windy:
            let type = WeatherCondition.WindyScale(rawValue: scaleValue)!
            return type == .NotSet ? nil : type
        case .Foggy:
            let type = WeatherCondition.FogScale(rawValue: scaleValue)!
            return type == .NotSet ? nil : type
        case .Rainy:
            let type = WeatherCondition.RainScale(rawValue: scaleValue)!
            return type == .NotSet ? nil : type
        case .Stormy:
            let type = WeatherCondition.StormScale(rawValue: scaleValue)!
            return type == .NotSet ? nil : type
        case .Snowy:
            let type = WeatherCondition.SnowyScale(rawValue: scaleValue)!
            return type == .NotSet ? nil : type
        default:
            return nil
        }
    }
    
    var name: String {
        return scaleType?.name ?? conditionType.meta.name
    }
}
