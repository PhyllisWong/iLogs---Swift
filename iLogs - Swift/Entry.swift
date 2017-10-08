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
    convenience init(conditionType: WeatherCondition.Types, scaleType scale: ScaleDescriptor, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.conditionValue = conditionType.meta.rawValue
        self.scaleValue = scale.meta.rawValue
    }
    
    /** Convert Weather Condition to a type. This includes the associated values as an optional scale */
    var conditionType: WeatherCondition.Types {
        //Looks for the weather condition type according to the condition value, non-nil
        let type = WeatherCondition.Types.array.first { $0.meta.rawValue == conditionValue }!
        switch type {
        case .Cloudy:
            //Looks for the scale type according to the scale value
            return .Cloudy(WeatherCondition.Types.CloudyScale.array.first { $0.meta.rawValue == scaleValue })
        case .Windy:
            //Looks for the scale type according to the scale value
            return .Windy(WeatherCondition.Types.WindyScale.array.first { $0.meta.rawValue == scaleValue })
        case .Foggy:
            //Looks for the scale type according to the scale value
            return .Foggy(WeatherCondition.Types.FogScale.array.first { $0.meta.rawValue == scaleValue })
        case .Rainy:
            //Looks for the scale type according to the scale value
            return .Rainy(WeatherCondition.Types.RainScale.array.first { $0.meta.rawValue == scaleValue })
        case .Stormy:
            //Looks for the scale type according to the scale value
            return .Stormy(WeatherCondition.Types.StormScale.array.first { $0.meta.rawValue == scaleValue })
        case .Snowy:
            //Looks for the scale type according to the scale value
            return .Snowy(WeatherCondition.Types.SnowyScale.array.first { $0.meta.rawValue == scaleValue })
        default:
            return type
        }
    }
}
