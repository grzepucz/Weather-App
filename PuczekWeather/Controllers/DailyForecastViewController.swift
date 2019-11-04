//
//  DailyForecastViewController.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 04/11/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import UIKit

class DailyForecastViewController: UIViewController {
    var location: Coordinates! = nil
    var forecast: DailyForecast.DailyForecastElement!
    
    @IBOutlet weak var temperatureMax: UILabel!
    @IBOutlet weak var temperatureMin: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var precipProp: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var precipType: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    
    func configureView() {
        if forecast != nil {
            if let label = summary {
                label.text = forecast.summary
            }
            if let label = temperatureMin {
                label.text = String(forecast.temperatureMin) + " st. C"
            }
            if let label = temperatureMax {
                label.text = String(forecast.temperatureMax) + " st. C"
            }
            if let label = pressure {
                label.text = String(forecast.pressure) + " hPa"
            }
            if let label = wind {
                label.text = String(forecast.windSpeed) + " km/h"
            }
            if let label = precipProp {
                label.text = String(forecast.precipProbability)
            }
            if let label = precipType {
                label.text = String(forecast.precipType ?? "?")
            }
            if let icon = icon {
                icon.image = UIImage(named: String(forecast.icon + ".png"))
            }
            if let label = time {
                label.text = DateHelper.getDateWithWeekday(dateTime: forecast.time)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
