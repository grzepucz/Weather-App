//
//  Forecast.swift
//  grzepucz.SimpleWeather
//
//  Created by Grzegorz Puczkowski on 19/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation

public class DailyForecast: Decodable {
    let summary: String
    let icon: String
    let data: Array<DailyForecastElement>
    
    enum CodingKeys: String, CodingKey {
        case summary
        case icon
        case data
    }
    
    public class DailyForecastElement: Decodable {
        let time: TimeInterval
        let summary: String
        let icon: String
        let sunriseTime: TimeInterval
        let sunsetTime: TimeInterval
        let moonPhase: Double
        let precipIntensity: Double
        let precipIntensityMax: Double
        let precipIntensityMaxTime: TimeInterval
        let precipProbability: Double
        let precipType: String?
        let temperatureHigh: Double
        let temperatureHighTime: TimeInterval
        let temperatureLow: Double
        let temperatureLowTime: TimeInterval
        let apparentTemperatureHigh: Double
        let apparentTemperatureHighTime: TimeInterval
        let apparentTemperatureLow: Double
        let apparentTemperatureLowTime: TimeInterval
        let dewPoint: Double
        let humidity: Double
        let pressure: Double
        let windSpeed: Double
        let windGust: Double
        let windGustTime: TimeInterval
        let windBearing: Int
        let cloudCover: Double
        let uvIndex: Int
        let uvIndexTime: TimeInterval
        let visibility: Double
        let ozone: Double
        let temperatureMin: Double
        let temperatureMinTime: TimeInterval
        let temperatureMax: Double
        let temperatureMaxTime: TimeInterval
        let apparentTemperatureMin: Double
        let apparentTemperatureMinTime: TimeInterval
        let apparentTemperatureMax: Double
        let apparentTemperatureMaxTime: TimeInterval
        
        enum CodingKeys: String, CodingKey {
            case time
            case summary
            case icon
            case sunriseTime
            case sunsetTime
            case moonPhase
            case precipIntensity
            case precipIntensityMax
            case precipIntensityMaxTime
            case precipProbability
            case precipType
            case temperatureHigh
            case temperatureHighTime
            case temperatureLow
            case temperatureLowTime
            case apparentTemperatureHigh
            case apparentTemperatureHighTime
            case apparentTemperatureLow
            case apparentTemperatureLowTime
            case dewPoint
            case humidity
            case pressure
            case windSpeed
            case windGust
            case windGustTime
            case windBearing
            case cloudCover
            case uvIndex
            case uvIndexTime
            case visibility
            case ozone
            case temperatureMin
            case temperatureMinTime
            case temperatureMax
            case temperatureMaxTime
            case apparentTemperatureMin
            case apparentTemperatureMinTime
            case apparentTemperatureMax
            case apparentTemperatureMaxTime
        }
    }
}
