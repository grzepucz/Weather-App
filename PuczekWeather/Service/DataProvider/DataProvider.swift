//
//  DataProvider.swift
//
//  Created by Grzegorz Puczkowski on 19/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation

let secret: String = "SECRET"
let endpoint: String = "https://api.darksky.net/forecast/"
let unitsQuery = "?lang=en&units=si"

class DataProvider {
    var weather: WeatherModel?
    var delegate: DataProviderDelegate?
    var urlString: String!
    var latitude: Double!
    var longitude: Double!
    var cityName: String? = nil
    
    init(latitude: Double, longitude: Double, query: String?, cityName: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.urlString = endpoint + secret + "/" + String(latitude) + "," + String(longitude)
        self.weather = nil
        
        if (query != nil) {
            self.urlString = self.urlString + unitsQuery + "&" + query!
        }
        
        if (cityName != nil) {
            self.cityName = cityName
        }
    }
    
    func getDataFromApi() {
        let urlEndpoint = urlString!
        
        if let url = URL(string: urlEndpoint){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        do {
                            self.weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                            self.didDelegateFinish()
                        } catch let error {
                            print(error)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func didDelegateFinish() {
        delegate?.didFinish(self)
    }
}
