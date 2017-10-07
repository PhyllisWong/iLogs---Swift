//
//  Entry+Meta.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/7/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import UIKit

extension Entry {
    enum WeatherConditionValues {
        case None
        case Sunny
        case Clear
        case Cloudy(CloudyScale?)
        case Windy(WindyScale?)
        case Foggy(FogScale?)
        case Gloomy
        case Misty
        case Rainy(RainScale?)
        case Stormy(StormScale?)
        case Snowy(SnowyScale?)
        
        enum CloudyScale {
            case Light
            case Broken
            case Overcast
        }
        
        enum WindyScale {
            case Low
            case Mild
            case Strong
        }
        
        enum FogScale {
            case Light
            case Mild
            case Think
        }
        
        enum RainScale {
            case Drizzle
            case Shower
            case Pour
        }
        
        enum StormScale {
            case Mild
            case Heavy
            case Lighting
        }
        
        enum SnowyScale {
            case Light
            case Mild
            case Hale
        }
        
        var meta: (name: String, image: (icon: UIImage, enlarged: UIImage?), scale: String?) {
            switch self {
            case .Sunny:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherSunny"),#imageLiteral(resourceName: "misc_weatherSunny-enlarged")),nil)
            case .Clear:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherClear"),#imageLiteral(resourceName: "misc_weatherClear-enlarged")),nil)
            case .Gloomy:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherGloomy"),#imageLiteral(resourceName: "misc_weatherGloomy-enlarged")),nil)
            case . Misty:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weatherMisty"),#imageLiteral(resourceName: "misc_weatherMisty-enlarged")),nil)
            case .Cloudy(let scale):
                return ("Cloudy",(#imageLiteral(resourceName: "misc_weatherCloudy"),#imageLiteral(resourceName: "misc_weatherCloudy-enlarged")),String(describing: scale ?? nil))
            case .Windy(let scale):
                return ("Windy",(#imageLiteral(resourceName: "misc_weatherWindy"),#imageLiteral(resourceName: "misc_weatherWindy-enlarged")),String(describing: scale ?? nil))
            case .Foggy(let scale):
                return ("Fog",(#imageLiteral(resourceName: "misc_weatherFoggy"),#imageLiteral(resourceName: "misc_weatherFoggy-enlarged")),String(describing: scale ?? nil))
            case .Rainy(let scale):
                return ("Rainy",(#imageLiteral(resourceName: "misc_weatherRainy"),#imageLiteral(resourceName: "misc_weatherRainy-enlarged")),String(describing: scale ?? nil))
            case .Stormy(let scale):
                return ("Stormy",(#imageLiteral(resourceName: "misc_weatherStormy"),#imageLiteral(resourceName: "misc_weatherStormy-enlarged")),String(describing: scale ?? nil))
            case .Snowy(let scale):
                return ("Snowy",(#imageLiteral(resourceName: "misc_weatherSnowy"),#imageLiteral(resourceName: "misc_weatherSnowy-enlarged")),String(describing: scale ?? nil))
            case .None:
                return (String(describing: self),(#imageLiteral(resourceName: "misc_weather-disabled"),nil),nil)
            }
        }
        
        static var count: Int {
            return self.array.count
        }
        
        static var array: [WeatherConditionValues] {
            return [.Sunny,.Clear,.Cloudy(nil),.Windy(nil),.Foggy(nil),.Gloomy,.Misty,.Rainy(nil),.Stormy(nil),.Snowy(nil)]
        }
    }
}
