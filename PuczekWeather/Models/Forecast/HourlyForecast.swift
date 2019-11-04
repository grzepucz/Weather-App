//
//  Forecast.swift
//  grzepucz.SimpleWeather
//
//  Created by Grzegorz Puczkowski on 19/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation

public class HourlyForecast: Decodable {
    let summary: String
    let icon: String
    let data: Array<HourlyForecastElement>
    
    enum CodingKeys: String, CodingKey {
        case summary
        case icon
        case data
    }
    
    public class HourlyForecastElement: Decodable {
        let time: TimeInterval
        let summary: String
        let icon: String
        let precipIntensity: Double
        let precipProbability: Double
        let precipType: String?
        let temperature: Double
        let apparentTemperature: Double
        let dewPoint: Double
        let humidity: Double
        let pressure: Double
        let windSpeed: Double
        let windGust: Double
        let windBearing: Int
        let cloudCover: Double
        let uvIndex: Int
        let visibility: Double
        let ozone: Double
        
        enum CodingKeys: String, CodingKey {
            case time
            case summary
            case icon
            case precipIntensity
            case precipProbability
            case precipType
            case temperature
            case apparentTemperature
            case dewPoint
            case humidity
            case pressure
            case windSpeed
            case windGust
            case windBearing
            case cloudCover
            case uvIndex
            case visibility
            case ozone
        }
    }
}
