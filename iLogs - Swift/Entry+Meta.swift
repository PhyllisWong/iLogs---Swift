//
//  Entry+Meta.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/7/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import UIKit

/** Pass this protocol to allow any scalable types as a single type */
protocol ScaleDescriptor {
    var name: String { get }
    
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
        //TODO : Maybe Rename Weather Conditions
        
        static var array: [Types] = [.Sunny,.Clear,.Cloudy,.Windy,.Foggy,.Gloomy,.Misty,.Rainy,.Stormy,.Snowy]
        
        static func type(`for` rawValue: Int16) -> WeatherCondition.Types? {
            return WeatherCondition.Types.array.first { $0.rawValue == rawValue }
        }
        
        /**
         true if the enum case has scales like think fog for foggy or strong
         winds for windy
         */
        var hasScalableTypes: Bool {
            switch self {
            case .Cloudy, .Windy, .Foggy, .Rainy, .Stormy, .Snowy:
                return true
            default:
                return false
            }
        }
        
        /** an array of all scalable types */
        var scalableTypes: [ScaleDescriptor]? {
            switch self {
            case .Cloudy:
                return CloudyScale.array
            case .Windy:
                return WindyScale.array
            case .Foggy:
                return FogScale.array
            case .Rainy:
                return RainScale.array
            case .Stormy:
                return StormScale.array
            case .Snowy:
                return SnowyScale.array
            default:
                return nil
            }
        }
        
        /** contains each type's name, image, and enlarged image */
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
    
    enum CloudyScale: Int16, ScaleDescriptor {
        case Light = 1
        case Broken = 2
        case Overcast = 3
        
        static var array: [CloudyScale] = [.Light,.Broken,.Overcast]
        
        var name: String {
            switch self {
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
        case Low = 1
        case Mild = 2
        case Strong = 3
          
        static var array: [WindyScale] = [.Low,.Mild,.Strong]
        
        var name: String {
            switch self {
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
        case Light = 1
        case Mild = 2
        case Thick = 3
        
        static var array: [FogScale] = [.Light,.Mild,.Thick]
        
        var name: String {
            switch self {
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
        case Drizzle = 1
        case Shower = 2
        case Pour = 3
        
        static var array: [RainScale] = [.Drizzle,.Shower,.Pour]
        
        var name: String {
            switch self {
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
        case Mild = 1
        case Heavy = 2
        case Lighting = 3
        
        static var array: [StormScale] = [.Mild,.Heavy,.Lighting]
        
        var name: String {
            switch self {
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
        case Light = 1
        case Mild = 2
        case Hale = 3
        
        static var array: [SnowyScale] = [.Light,.Mild,.Hale]
        
        var name: String {
            switch self {
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
