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
    var meta: (name: String, rawValue: Int16) { get }
}

extension WeatherCondition {
    enum Types {
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
        //TODO : Rename Weather Conditions
        enum CloudyScale: ScaleDescriptor {
            case Light
            case Broken
            case Overcast
            
            static var array: [CloudyScale] = [.Light,.Broken,.Overcast]
            
            var meta: (name: String, rawValue: Int16) {
                switch self {
                case .Light:
                    return ("Light Clouds",1)
                case .Broken:
                    return ("Broken Clouds",2)
                case .Overcast:
                    return ("Overcast",3)
                }
            }
        }
        
        enum WindyScale: ScaleDescriptor {
            case Low
            case Mild
            case Strong
            
            static var array: [WindyScale] = [.Low,.Mild,.Strong]
            
            var meta: (name: String, rawValue: Int16) {
                switch self {
                case .Low:
                    return ("Low Winds",1)
                case .Mild:
                    return ("Mild Winds",2)
                case .Strong:
                    return ("Strong Winds",3)
                }
            }
        }
        
        enum FogScale: ScaleDescriptor {
            case Light
            case Mild
            case Thick
            
            static var array: [FogScale] = [.Light,.Mild,.Thick]
            
            var meta: (name: String, rawValue: Int16) {
                switch self {
                case .Light:
                    return ("Light Fog",1)
                case .Mild:
                    return ("Mild Fog",2)
                case .Thick:
                    return ("Thick Fog",3)
                }
            }
        }
        
        enum RainScale: ScaleDescriptor {
            case Drizzle
            case Shower
            case Pour
            
            static var array: [RainScale] = [.Drizzle,.Shower,.Pour]
            
            var meta: (name: String, rawValue: Int16) {
                switch self {
                case .Drizzle:
                    return ("Drizzle",1)
                case .Shower:
                    return ("Showers",2)
                case .Pour:
                    return ("Pouring",3)
                }
            }
        }
        
        enum StormScale: ScaleDescriptor {
            case Mild
            case Heavy
            case Lighting
            
            static var array: [StormScale] = [.Mild,.Heavy,.Lighting]
            
            var meta: (name: String, rawValue: Int16) {
                switch self {
                case .Mild:
                    return ("Mild Storm",1)
                case .Heavy:
                    return ("Heavy Storm",2)
                case .Lighting:
                    return ("Lighting Storm",3)
                }
            }
        }
        
        enum SnowyScale: ScaleDescriptor {
            case Light
            case Mild
            case Hale
            
            static var array: [SnowyScale] = [.Light,.Mild,.Hale]
            
            var meta: (name: String, rawValue: Int16) {
                switch self {
                case .Light:
                    return ("Light Snow",1)
                case .Mild:
                    return ("Mild Snow",2)
                case .Hale:
                    return ("Hale",3)
                }
            }
        }
        
        var meta: (name: String, rawValue: Int16, image: (icon: UIImage, enlarged: UIImage?), scale: String?) {
            switch self {
            case .Sunny:
                return (String(describing: self), 1,(#imageLiteral(resourceName: "misc_weatherSunny"),#imageLiteral(resourceName: "misc_weatherSunny-enlarged")),nil)
            case .Clear:
                return (String(describing: self), 2,(#imageLiteral(resourceName: "misc_weatherClear"),#imageLiteral(resourceName: "misc_weatherClear-enlarged")),nil)
            case .Gloomy:
                return (String(describing: self), 3,(#imageLiteral(resourceName: "misc_weatherGloomy"),#imageLiteral(resourceName: "misc_weatherGloomy-enlarged")),nil)
            case . Misty:
                return (String(describing: self), 4,(#imageLiteral(resourceName: "misc_weatherMisty"),#imageLiteral(resourceName: "misc_weatherMisty-enlarged")),nil)
            case .Cloudy(let scale):
                return (scale?.meta.name ?? "Cloudy", 5,(#imageLiteral(resourceName: "misc_weatherCloudy"),#imageLiteral(resourceName: "misc_weatherCloudy-enlarged")),String(describing: scale ?? nil))
            case .Windy(let scale):
                return (scale?.meta.name ?? "Windy", 6,(#imageLiteral(resourceName: "misc_weatherWindy"),#imageLiteral(resourceName: "misc_weatherWindy-enlarged")),String(describing: scale ?? nil))
            case .Foggy(let scale):
                return (scale?.meta.name ?? "Foggy", 7,(#imageLiteral(resourceName: "misc_weatherFoggy"),#imageLiteral(resourceName: "misc_weatherFoggy-enlarged")),String(describing: scale ?? nil))
            case .Rainy(let scale):
                return (scale?.meta.name ?? "Rainy", 8,(#imageLiteral(resourceName: "misc_weatherRainy"),#imageLiteral(resourceName: "misc_weatherRainy-enlarged")),String(describing: scale ?? nil))
            case .Stormy(let scale):
                return (scale?.meta.name ?? "Stormy", 9,(#imageLiteral(resourceName: "misc_weatherStormy"),#imageLiteral(resourceName: "misc_weatherStormy-enlarged")),String(describing: scale ?? nil))
            case .Snowy(let scale):
                return (scale?.meta.name ?? "Snowy", 10,(#imageLiteral(resourceName: "misc_weatherSnowy"),#imageLiteral(resourceName: "misc_weatherSnowy-enlarged")),String(describing: scale ?? nil))
            }
        }
        
        static var count: Int {
            return self.array.count
        }
        
        static var array: [Types] = [.Sunny,.Clear,.Cloudy(nil),.Windy(nil),.Foggy(nil),.Gloomy,.Misty,.Rainy(nil),.Stormy(nil),.Snowy(nil)]
        
        static func type(`for` value: Int16) -> WeatherCondition.Types? {
            return WeatherCondition.Types.array.first { $0.meta.rawValue == value }
        }
    }
}
