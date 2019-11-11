//
//  CityMapViewController.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 10/11/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CityMapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var longitude: Double? = 0
    var latitude: Double? = 0
    var name: String? = ""
    lazy var geocoder = CLGeocoder()
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var findLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityName.text! = self.name ?? "Undefined"
        self.showOnMap()
        // Do any additional setup after loading the view.
    }
    
    private func showOnMap() {
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.latitude!, self.longitude!)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
    }
    
    @IBAction func resetMap() {
        showOnMap()
    }
    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
