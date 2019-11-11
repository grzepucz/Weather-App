//
//  SearchLocationViewController.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 05/11/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol AddLocationDelegate {
    
    func addLocation(coordinates: Coordinates)
}

class SearchLocationViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dataHelper = CoreDataHelper()
    
    var addLocationDelegate: AddLocationDelegate? = nil
    var masterController: MasterViewController? = nil
    var currentLocation: Coordinates? = nil
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var findMeButton: UIButton!

    override func viewDidLoad()
    {
        self.setUpSearchBar()
        navigationItem.leftBarButtonItem?.action = backButton.action
        activityIndicatorView.isHidden = true
        super.viewDidLoad()
        self.manager.requestAlwaysAuthorization()
        self.manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
        
        geocoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                var name = String(location.coordinate.latitude) + ", " + String(location.coordinate.longitude)
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                // City
                if let cityName = placeMark.locality {
                    name = cityName
                }
                // Country
                if let country = placeMark.country {
                    name = name + ", " + country
                }
                self.currentLocation = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, name: name)
        })
        self.map.showsUserLocation = true
    }
    
    @IBAction func addLocation() {
        let locationExists = dataHelper.locationAlreadyExists(name: self.currentLocation!.name)
        
        if (locationExists) {
            infoLabel.isHidden = false
            infoLabel.text = "Location already exists!"
            self.changeLabelHiddenValue(object: self.infoLabel, state: true, delay: 3.0)
        } else {
            self.addLocationDelegate!.addLocation(coordinates: self.currentLocation!)
            infoLabel.isHidden = false
            infoLabel.text = "Location added!"
            self.changeLabelHiddenValue(object: self.infoLabel, state: true, delay: 3.0)
        }
    }
    
    @IBAction func findMe() {
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, name: String) {
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            infoLabel.isHidden = false
            infoLabel.text = "Cannot get Localization"
            self.changeLabelHiddenValue(object: self.infoLabel, state: true, delay: 3.0)
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                self.currentLocation = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, name: name)
                infoLabel.isHidden = false
                infoLabel.text = "\(name) found!"
                self.changeLabelHiddenValue(object: self.infoLabel, state: true, delay: 3.0)
                
                addLocationButton.isHidden = false
                locationManager(_: manager, didUpdateLocations: [location])
                
            } else {
                infoLabel.isHidden = false
                infoLabel.text = "Location nearby exists"
                self.changeLabelHiddenValue(object: self.infoLabel, state: true, delay: 3.0)
            }
        }
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        geocoder.geocodeAddressString(searchBar.text ?? "Cracow") { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error, name: searchBar.text ?? "Cracow")
        }
        
        addLocationButton.isHidden = true
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        geocoder.geocodeAddressString(searchBar.text ?? "Cracow") { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error, name: searchBar.text ?? "Cracow")
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        infoLabel.isHidden = true
        infoLabel.text = ""
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search location..."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       masterController?.tableView.reloadData()
    }
    
    private func locationAlreadyExists() {
        
    }

    private func changeLabelHiddenValue(object: UILabel, state: Bool, delay: Double) {
        let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            object.isHidden = state
        }
    }
}
