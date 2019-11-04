//
//  WeatherModel.swift
//  grzepucz.SimpleWeather
//
//  Created by Grzegorz Puczkowski on 19/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation

public class WeatherModel : Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: CurrentlyForecast
    let hourly: HourlyForecast
    let daily: DailyForecast
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case timezone
        case currently
        case hourly
        case daily
    }
}
