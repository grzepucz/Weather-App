//
//  CityModel.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 31/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation

public class Coordinates {
    var latitude: Double
    var longitude: Double
    var weather: WeatherModel?
    var name: String?
    
    init(latitude: Double, longitude: Double, name: String?) {
        self.latitude = latitude
        self.longitude = longitude
    
        if (name != nil) {
            self.setName(name: name!)
        }
    }
    
    func setWeather(weather: WeatherModel) {
        self.weather = weather
    }
    
    func setName(name: String) {
        self.name = name
    }
    
}
