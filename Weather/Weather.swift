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
    private var _weatherURL: String!
    
    var city: String {
        return _city
    }

    var temperature: String {
        return _temperature
    }
    
    var weatherURL: String {
        return _weatherURL
    }
    
    init(location: String) {
        _city = location
        self._weatherURL = "\(baseURL)\(self._city)\(unit)&appid=\(API)"
    }
    
    func downloadWeatherData(completed: DownloadComplete) {
        print("I am downloading now")
        let url = NSURL(string: self._weatherURL)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {

                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let tmp = main["temp"] as? Int {
                        self._temperature = "\(tmp)"
                    }
                }
                
            }
            completed()
        }

    }   

}