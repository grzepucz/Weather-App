//
//  CityModel.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 31/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation

class Coordinates : Codable {
    let latitude: Double
    let longitude: Double
    let name: String
    var weather: WeatherModel?
    
    init(latitude: Double, longitude: Double, name: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
    
    func setWeather(weather: WeatherModel) {
        self.weather = weather
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case name
    }
}
