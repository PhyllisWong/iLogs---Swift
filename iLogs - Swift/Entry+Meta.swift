//
//  Entry+Meta.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/7/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import UIKit

/** Pass this protocol to allow any of the scales as a single type */
protocol ScaleDescriptor {
    var name: String? { get }
    
    var rawValue: Int16 { get }
}

extension WeatherCondition {
    enum Types: Int16 {
        case Sunny
        case Clear
        case Cloudy
        case Windy
        case Foggy
        case Gloomy
        case Misty
        case Rainy
        case Stormy
        case Snowy
        //TODO : Rename Weather Conditions
        
        static var array: [Types] = [.Sunny,.Clear,.Cloudy,.Windy,.Foggy,.Gloomy,.Misty,.Rainy,.Stormy,.Snowy]
        
        static func type(`for` value: Int16) -> WeatherCondition.Types? {
            return WeatherCondition.Types.array.first { $0.rawValue == value }
        }
        
        var meta: (name: String, image: (icon: UIImage, enlarged: UIImage)) {
            switch self {
            case .Sunny:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherSunny"),#imageLiteral(resourceName: "misc_weatherSunny-enlarged")))
            case .Clear:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherClear"),#imageLiteral(resourceName: "misc_weatherClear-enlarged")))
            case .Gloomy:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherGloomy"),#imageLiteral(resourceName: "misc_weatherGloomy-enlarged")))
            case .Misty:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherMisty"),#imageLiteral(resourceName: "misc_weatherMisty-enlarged")))
            case .Cloudy:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherCloudy"),#imageLiteral(resourceName: "misc_weatherCloudy-enlarged")))
            case .Windy:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherWindy"),#imageLiteral(resourceName: "misc_weatherWindy-enlarged")))
            case .Foggy:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherFoggy"),#imageLiteral(resourceName: "misc_weatherFoggy-enlarged")))
            case .Rainy:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherRainy"),#imageLiteral(resourceName: "misc_weatherRainy-enlarged")))
            case .Stormy:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherStormy"),#imageLiteral(resourceName: "misc_weatherStormy-enlarged")))
            case .Snowy:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherSnowy"),#imageLiteral(resourceName: "misc_weatherSnowy-enlarged")))
            }
        }
    }
    
    enum NoneScale: Int16, ScaleDescriptor {
        case None = -1
        static var array: [NoneScale] = []
        var name: String? {
            return nil
        }
    }
    
    enum CloudyScale: Int16, ScaleDescriptor {
        case NotSet = -1
        case Light
        case Broken
        case Overcast
        
        static var array: [CloudyScale] = [.Light,.Broken,.Overcast]
        
        var name: String? {
            switch self {
            case .NotSet:
                return nil
            case .Light:
                return "Light Clouds"
            case .Broken:
                return "Broken Clouds"
            case .Overcast:
                return "Overcast"
            }
        }
    }
    
    enum WindyScale: Int16, ScaleDescriptor {
        case NotSet = -1
        case Low
        case Mild
        case Strong
        
        static var array: [WindyScale] = [.Low,.Mild,.Strong]
        
        var name: String? {
            switch self {
            case .NotSet:
                return nil
            case .Low:
                return "Low Winds"
            case .Mild:
                return "Mild Winds"
            case .Strong:
                return "Strong Winds"
            }
        }
    }
    
    enum FogScale: Int16, ScaleDescriptor {
        case NotSet = -1
        case Light
        case Mild
        case Thick
        
        static var array: [FogScale] = [.Light,.Mild,.Thick]
        
        var name: String? {
            switch self {
            case .NotSet:
                return nil
            case .Light:
                return "Light Fog"
            case .Mild:
                return "Mild Fog"
            case .Thick:
                return "Thick Fog"
            }
        }
    }
    
    enum RainScale: Int16, ScaleDescriptor {
        case NotSet = -1
        case Drizzle
        case Shower
        case Pour
        
        static var array: [RainScale] = [.Drizzle,.Shower,.Pour]
        
        var name: String? {
            switch self {
            case .NotSet:
                return nil
            case .Drizzle:
                return "Drizzle"
            case .Shower:
                return "Showers"
            case .Pour:
                return "Pouring"
            }
        }
    }
    
    enum StormScale: Int16, ScaleDescriptor {
        case NotSet = -1
        case Mild
        case Heavy
        case Lighting
        
        static var array: [StormScale] = [.Mild,.Heavy,.Lighting]
        
        var name: String? {
            switch self {
            case .NotSet:
                return nil
            case .Mild:
                return "Mild Storm"
            case .Heavy:
                return "Heavy Storm"
            case .Lighting:
                return "Lighting Storm"
            }
        }
    }
    
    enum SnowyScale: Int16, ScaleDescriptor {
        case NotSet = -1
        case Light
        case Mild
        case Hale
        
        static var array: [SnowyScale] = [.Light,.Mild,.Hale]
        
        var name: String? {
            switch self {
            case .NotSet:
                return nil
            case .Light:
                return "Light Snow"
            case .Mild:
                return "Mild Snow"
            case .Hale:
                return "Hale"
            }
        }
    }
}
