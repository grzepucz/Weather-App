//
//  DataProvider.swift
//
//  Created by Grzegorz Puczkowski on 19/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation

let secret: String = "b97537869e85cb0d815424a516b2df41"
let endpoint: String = "https://api.darksky.net/forecast/"
let unitsQuery = "?lang=pl&units=si"

class DataProvider {
    var weather: WeatherModel?
    var delegate: DataProviderDelegate?
    var urlString: String!
    var latitude: Double!
    var longitude: Double!
    
    init(latitude: Double, longitude: Double, query: String?) {
        self.urlString = endpoint + secret + "/" + String(longitude) + "," + String(latitude)
        self.weather = nil
        
        if (query != nil) {
            self.urlString = self.urlString + unitsQuery + "&" + query!
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
