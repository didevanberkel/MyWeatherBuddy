//
//  ViewController.swift
//  my-weather
//
//  Created by Dide van Berkel on 31-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMobileAds

class MainWeatherVC: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    private var _currLat: Double!
    private var _currLon: Double!
    
    var lat: Double {
        if _currLat == nil {
            _currLat = 52.379189
        }
        return _currLat
    }
    
    var lon: Double {
        if _currLon == nil {
            _currLon = 4.899431
        }
        return _currLon
    }
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var rain: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var dayAndTime: UILabel!

    var weather = Weather()
    var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 500.0
        locationManager.startUpdatingLocation()
        
        loadBanner()
    }
    
    func loadBanner() {
        banner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        banner.adUnitID = "ca-app-pub-3274698501837481/3640900453"
        banner.rootViewController = self
        let request: GADRequest = GADRequest()
        banner.loadRequest(request)
        banner.frame = CGRectMake(0, view.bounds.height - banner.frame.size.height, banner.frame.size.width, banner.frame.size.height)
        self.view.addSubview(banner)
    }
    
    override func viewDidAppear(animated: Bool) {
        downloadAndUpdate()
    }
    
    func updateUI() {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("switchIsOn") {
            temp.text = "\(round(weather.temp * 10)/10)ºF"
        } else {
            temp.text = "\(round(weather.temp * 10)/10)ºC"
        }

        location.text = weather.location.uppercaseString
        wind.text = "\(round(weather.wind * 10)/10) MPS"
        rain.text = "\(round(weather.rain * 10)/10) %"
        weatherDesc.text = weather.description.uppercaseString
        dayAndTime.text = weather.localDate.uppercaseString
        
        if weather.icon == "" {
            weatherImg.hidden = true
        } else {
            weatherImg.hidden = false
            weatherImg.image = UIImage(named: weather.icon)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMore" {
            let svc = segue.destinationViewController as! NextWeatherVC;
            //print(weather.tempArray)
            svc.passedTemp = weather.tempArray
            svc.passedImage = weather.iconArray
            svc.passedDate = weather.localDateArray
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currLat: Double = manager.location!.coordinate.latitude {
            self._currLat = currLat
            NSUserDefaults.standardUserDefaults().setDouble(self._currLat, forKey: "LAT")
        }
        if let currLon: Double = manager.location!.coordinate.longitude {
            self._currLon = currLon
            NSUserDefaults.standardUserDefaults().setDouble(self._currLon, forKey: "LON")
        }
        downloadAndUpdate()
    }
    
    func downloadAndUpdate() {
        let lattitude = NSUserDefaults.standardUserDefaults().doubleForKey("LAT")
        let longitude = NSUserDefaults.standardUserDefaults().doubleForKey("LON")
        weather.grabVariables(lattitude, long: longitude)
        weather.downloadWeatherDetails() { () -> () in
            self.updateUI()
        }
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        _currLat = 52.379189
        _currLon = 4.899431
        print("Your location isn't found")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        _currLat = 52.379189
        _currLon = 4.899431
        print("App may not (yet) authorized to obtain location information. Check status here and respond accordingly")
    }
}

