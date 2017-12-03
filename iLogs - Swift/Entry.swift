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
    @discardableResult
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
    @discardableResult
    convenience init(conditionType: WeatherCondition.Types, scaleType scale: ScaleDescriptor?, `for` entry: Entry, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.entry = entry
        self.conditionValue = conditionType.rawValue
        self.scaleValue = scale?.rawValue ?? 0 //zero is the nil value
    }
    
    /** Convert Weather Condition Value to a type */
    var conditionType: WeatherCondition.Types {
        return WeatherCondition.Types(rawValue: conditionValue)!
    }
    
    var scaleType: ScaleDescriptor? {
        set {
            scaleValue = scaleType?.rawValue ?? 0
        }
        get {
            //default: not set to any scale
            if scaleValue == 0 {
                return nil
            } else {
                switch conditionType {
                case .Cloudy:
                    return WeatherCondition.CloudyScale(rawValue: scaleValue)!
                case .Windy:
                    return WeatherCondition.WindyScale(rawValue: scaleValue)!
                case .Foggy:
                    return WeatherCondition.FogScale(rawValue: scaleValue)!
                case .Rainy:
                    return WeatherCondition.RainScale(rawValue: scaleValue)!
                case .Stormy:
                    return WeatherCondition.StormScale(rawValue: scaleValue)!
                case .Snowy:
                    return WeatherCondition.SnowyScale(rawValue: scaleValue)!
                default: //for non-scalable weather types
                    return nil
                }
            }
        }
    }
    
    /**
     returns a scalable type's title if .scaleType != nil , otherwise return
     the type.title
     */
    var name: String {
        return scaleType?.name ?? conditionType.meta.name
    }
}
