//
//  ViewController.swift
//  Weather
//
//  Created by Antonija Pek on 28/02/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    
    // MARK: Properties
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentCity: String!
    var weather: Weather!
    var name: String!
    
    
    // MARK: Methods & Actions
    
    // Getting name of the city from location
    func getCityName() {
        print("I'm in getCityName()")
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemark: [CLPlacemark]?, err: NSError?) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemark?[0]
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.currentCity = "\(city)"
                print("Just got city name, it is: \(self.currentCity)")
                
                self.name = self.currentCity.stringByReplacingOccurrencesOfString("City of ", withString: "")
                let finalCityName = self.name.lowercaseString
                self.name = finalCityName
                
                self.weather = Weather(location: "\(self.name)")
                print("Before getting to API, city name is: \(self.name)")
                self.weather.downloadWeatherData { () -> () in
                    self.updateUI()
                }

            }

        }
    }
    
    func updateUI() {
        print("I'm inside of updateUI")
        cityLabel.text = name.capitalizedString
        temperatureLabel.text = weather.temperature
    }
    
    // Getting user location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("I'm in didUpdateLocations")
        if let location = locations.first {
            currentLocation = location
            print("My current location is: \(currentLocation)")
            getCityName()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // Check if the user allowed authorization
    func locationAuthStatus() {
        print("I'm in locationAuthStatus()")
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        temperatureLabel.text = "0"
        cityLabel.text = "Updating..."
        locationAuthStatus()
    }
}

