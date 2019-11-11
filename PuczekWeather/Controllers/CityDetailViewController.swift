//
//  DetailViewController.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 31/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import UIKit
import CoreData

class CityDetailViewController: UIViewController, DataProviderDelegate {

    var dailyForecastCollectionViewController: DailyForecastCollectionViewController? = nil
    var dataProvider: DataProvider!
    var latitude: Double? = 50.4241
    var longitude: Double? = 37.4124
    var cityName: String? = "Undefined"
    var weather: WeatherModel!
    var cellIndex: Int? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dataHelper = CoreDataHelper()
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var precip: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var nextDays: UIButton!
    @IBOutlet weak var wind: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let split = splitViewController {
            let controllers = split.viewControllers
            dailyForecastCollectionViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DailyForecastCollectionViewController
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.

        if weather != nil {
            if let label = temperature {
                label.text = String(self.weather!.currently.temperature) + " st. C"
            }
            if let label = time {
                label.text = DateHelper.getDate(dateTime: self.weather.currently.time)
            }
            if let label = pressure {
                label.text = String(self.weather!.currently.pressure) + " hPa"
            }
            if let label = wind {
                label.text = String(self.weather!.currently.windSpeed) + " km/h"
            }
            if let label = precip {
                label.text = String(self.weather!.currently.precipProbability)
            }
            if let label = name {
                label.text = self.cityName ?? "lat: " + String(self.latitude!) + " long: " + String(self.longitude!)
            }
            if let icon = icon {
                icon.image = UIImage(named: String(self.weather!.currently.icon + ".png"))
            }
            
            dataHelper.updateRecord(city: cityName!, icon: self.weather!.currently.icon, temperature: self.weather!.currently.temperature)
        }
    }
    
    var cityDetailForecast: NSManagedObject? {
        didSet {
            self.dataProvider = DataProvider(latitude: latitude!, longitude: longitude!, query: "", cityName: cityName)
            dataProvider?.delegate = self
            dataProvider?.getDataFromApi()
        }
    }

    func didFinish(_ provider: DataProvider) {
        self.weather = dataProvider!.weather
        configureView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDailyForecast" {
            let controller = segue.destination as! DailyForecastCollectionViewController
            controller.dailyForecast = self.weather!.daily
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
        
        if segue.identifier == "showCityOnMap" {
            let controller = segue.destination as! CityMapViewController
            controller.longitude = self.longitude!
            controller.latitude = self.latitude!
            controller.name = self.cityName ?? ""
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            
        }
    }
    
}

