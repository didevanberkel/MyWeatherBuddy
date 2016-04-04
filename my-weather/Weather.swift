//
//  Weather.swift
//  my-weather
//
//  Created by Dide van Berkel on 01-04-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    
    private var _location: String!
    private var _temp: Double!
    private var _icon: String!
    private var _description: String!
    private var _wind: Double!
    private var _rain: Double!
    private var _day: String!
    
    private var _tempArray = [Double]()
    private var _iconArray = [String]()
    private var _dayArray = [String]()
    
    private var _weatherUrls: String!
    private var _lat: Double!
    private var _lon: Double!

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
    
    func grabVariables(latt: Double, long: Double) {
        _lat = latt
        _lon = long
    }
    
    func downloadWeatherDetails(completed: DownloadComplete) {
        self._tempArray.removeAll()
        self._iconArray.removeAll()
        self._dayArray.removeAll()
        
        if NSUserDefaults.standardUserDefaults().boolForKey("switchIsOn") {
            _weatherUrls = "\(FIRST_URL)\(_lat)\(SECOND_URL)\(_lon)\(THIRD_URL_F)"
        } else {
            _weatherUrls = "\(FIRST_URL)\(_lat)\(SECOND_URL)\(_lon)\(THIRD_URL)"
        }
        let weatherUrl = NSURL(string: _weatherUrls)!
        Alamofire.request(.GET, weatherUrl).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let loc = dict["city"] as? Dictionary<String, AnyObject> {
                    if let locat = loc["name"] as? String {
                        self._location = locat
                    }
                }
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    if let days = list[0]["dt"]! as? Double {
                        let date = NSDate(timeIntervalSince1970: days)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
                        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                        dateFormatter.timeZone = NSTimeZone()
                        let locDate = dateFormatter.stringFromDate(date)
                        self._day = locDate
                    }
                    
                    for x in 1...list.count - 1 {
                        //For NextWeatherVC:
                        if let days1 = list[x]["dt"]! as? Double {
                            let date1 = NSDate(timeIntervalSince1970: days1)
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
                            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                            dateFormatter.timeZone = NSTimeZone()
                            let dateArray = dateFormatter.stringFromDate(date1)
                            self._dayArray.append(dateArray)
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
//            print(self._location)
//            print(self._temp)
//            print(self._rain)
//            print(self._description)
//            print(self._wind)
//            print(self._icon)
//            print(self._tempArray)
//            print(self._iconArray)
//            print(self._day)
//            print(self._dayArray)
            }
            completed()
        }
    }
}
