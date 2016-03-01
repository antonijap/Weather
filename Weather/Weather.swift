//
//  Weather.swift
//  Weather
//
//  Created by Antonija Pek on 28/02/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    
    private var _city: String!
    private var _temperature: String!
    private var _descShort: String!
    private var _humidity: String!
    private var _pressure: String!
    private var _wind: String!
    private var _weatherURL: String!
    
    var weatherImgName: String!
    
    var city: String {
        return _city
    }

    var temperature: String {
        return _temperature
    }
    
    var weatherURL: String {
        return _weatherURL
    }
    
    var humidity: String {
        return _humidity
    }
    
    var wind: String {
        return _wind
    }
    
    var pressure: String {
        return _pressure
    }
    
    var descShort: String {
        return _descShort
    }
    
    init(location: String) {
        _city = location
        self._weatherURL = "\(baseURL)\(self._city)\(unit)&appid=\(API)"
    }
    
    func downloadWeatherData(completed: DownloadComplete) {
        print("I am downloading now")
        let url = NSURL(string: self._weatherURL)!
        print("My URL is: \(url)")
        
        Alamofire.request(.GET, url).responseJSON { response in
            print("I am in Alamo")
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {

                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let tmp = main["temp"] as? Int {
                        self._temperature = "\(tmp)"
                    }
                    
                    if let humidity = main["humidity"] as? Int {
                        self._humidity = "\(humidity)"
                    }
                    
                    if let pressure = main["pressure"] as? Int {
                        self._pressure = "\(pressure)"
                    }
  
                }
                
                if let main = dict["wind"] as? Dictionary<String, AnyObject> {
                    if let wind = main["speed"] as? Int {
                        self._wind = "\(wind)"
                    }
                }
                
                if let desc = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let dShort = desc[0]["main"] as? String {
                        self._descShort = dShort
                    }
                    
                }
                
                if self._descShort == "Rain" {
                    self.weatherImgName = self._descShort
                } else if self._descShort == "Sunny" {
                    self.weatherImgName = self._descShort
                } else if self._descShort == "Clear" {
                    self.weatherImgName = self._descShort
                } else if self._descShort == "Clouds" {
                    self.weatherImgName = self._descShort
                } else {
                    self.weatherImgName = "Default"
                }
                
            }
            completed()
        }

    }   

}