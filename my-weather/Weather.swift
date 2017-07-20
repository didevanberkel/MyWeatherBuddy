//
//  Weather.swift
//  my-weather
//
//  Created by Dide van Berkel on 01-04-16.
//  Copyright © 2017 Dide van Berkel. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    
    fileprivate var _location: String!
    fileprivate var _temp: Double!
    fileprivate var _icon: String!
    fileprivate var _description: String!
    fileprivate var _wind: Double!
    fileprivate var _rain: Double!
    fileprivate var _day: String!
    
    fileprivate var _tempArray = [Double]()
    fileprivate var _iconArray = [String]()
    fileprivate var _dayArray = [String]()
    
    fileprivate var _weatherUrls: String!
    fileprivate var _lat: Double!
    fileprivate var _lon: Double!
    
    var location: String {
        if _location == nil {
            _location = ""
        }
        return _location
    }
    
    var temp: Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }
    
    var tempArray: [Double] {
        if _tempArray == [] {
            _tempArray = []
        }
        return _tempArray
    }
    
    var icon: String {
        if _icon == nil {
            _icon = ""
        }
        return _icon
    }
    
    var iconArray: [String] {
        if _iconArray == [] {
            _iconArray = []
        }
        return _iconArray
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var wind: Double {
        if _wind == nil {
            _wind = 0.0
        }
        return _wind
    }
    
    var rain: Double {
        if _rain == nil {
            _rain = 0.0
        }
        return _rain
    }
    
    var localDate: String {
        if _day == nil {
            _day = ""
        }
        return _day
    }
    
    var localDateArray: [String] {
        if _dayArray == [] {
            _dayArray = []
        }
        return _dayArray
    }
    
    func grabVariables(_ latt: Double, long: Double) {
        _lat = latt
        _lon = long
    }
    
    func downloadWeatherDetails(_ completed: @escaping DownloadComplete) {
        if UserDefaults.standard.bool(forKey: "switchIsOn") {
            _weatherUrls = "\(FIRST_URL)\(_lat!)\(SECOND_URL)\(_lon!)\(THIRD_URL_F)"
        } else {
            _weatherUrls = "\(FIRST_URL)\(_lat!)\(SECOND_URL)\(_lon!)\(THIRD_URL)"
        }
        
        
        Alamofire.request(_weatherUrls).responseJSON { (response:DataResponse<Any>) in
            let result = response.result
            
            self._tempArray.removeAll()
            self._iconArray.removeAll()
            self._dayArray.removeAll()
            
            if let dict = result.value as? Dictionary<String, AnyObject> {

                if let loc = dict["city"] as? Dictionary<String, AnyObject> {
                    if let locat = loc["name"] as? String {
                        self._location = locat
                    }
                }
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    if let days = list[0]["dt"]! as? Double {
                        let date = Date(timeIntervalSince1970: days)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .medium
                        //dateFormatter.timeZone = NSTimeZone() as TimeZone!
                        let locDate = dateFormatter.string(from: date)
                        
                        dateFormatter.dateFormat = "EEEE"
                        let stringDate: String = dateFormatter.string(from: date)
                        
                        self._day = ("\(stringDate) \(locDate)")
                    }
                    
                    for x in 1...list.count - 1 {
                        //For NextWeatherVC:
                        if let days1 = list[x]["dt"]! as? Double {
                            let date1 = Date(timeIntervalSince1970: days1)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = .medium
                            dateFormatter.dateStyle = .medium
                            //dateFormatter.timeZone = NSTimeZone() as TimeZone!
                            let dateArray = dateFormatter.string(from: date1)
                            
                            dateFormatter.dateFormat = "EEEE"
                            let stringDate: String = dateFormatter.string(from: date1)
                            
                            self._dayArray.append("\(stringDate) \(dateArray)")
                        }
                    }
                    
                    if let main = list[0]["main"]! as? Dictionary<String, AnyObject> {
                        
                        if let temperature = main["temp"] as? Double {
                            self._temp = temperature
                        }
                        
                        if let humid = main["humidity"] as? Double {
                            self._rain = humid
                        }
                    }
                    
                    for x in 1...list.count - 1 {
                        //For NextWeatherVC:
                        if let main2 = list[x]["main"]! as? Dictionary<String, AnyObject> {
                            if let temperature2 = main2["temp"] as? Double {
                                self._tempArray.append(temperature2)
                            }
                        }
                    }
                    
                    if let weatherLst = list[0]["weather"]! as? [Dictionary<String, AnyObject>] {
                        if let wtr = weatherLst[0]["description"] as? String {
                            self._description = wtr
                        }
                        
                        if let wtrIcon = weatherLst[0]["icon"] as? String {
                            self._icon = wtrIcon
                        }
                    }
                    
                    for x in 1...list.count - 1 {
                        
                        //For NextWeatherVC:
                        if let weatherLst2 = list[x]["weather"]! as? [Dictionary<String, AnyObject>] {
                            if let wtrIcon2 = weatherLst2[0]["icon"] as? String {
                                self._iconArray.append(wtrIcon2)
                            }
                        }
                        
                        if let windLst = list[0]["wind"]! as? Dictionary<String, AnyObject> {
                            if let windSpeed = windLst["speed"] as? Double {
                                self._wind = windSpeed
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
}
