//
//  ViewController.swift
//  my-weather
//
//  Created by Dide van Berkel on 31-03-16.
//  Copyright © 2017 Dide van Berkel. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMobileAds

class MainWeatherVC: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    fileprivate var _currLat: Double!
    fileprivate var _currLon: Double!
    
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
        banner.load(request)
        banner.frame = CGRect(x: 0, y: view.bounds.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        self.view.addSubview(banner)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadAndUpdate()
    }
    
    func updateUI() {
        
        if UserDefaults.standard.bool(forKey: "switchIsOn") {
            temp.text = "\(round(weather.temp * 10)/10)ºF"
        } else {
            temp.text = "\(round(weather.temp * 10)/10)ºC"
        }
        
        location.text = weather.location.uppercased()
        wind.text = "\(round(weather.wind * 10)/10) MPS"
        rain.text = "\(round(weather.rain * 10)/10) %"
        weatherDesc.text = weather.description.uppercased()
        dayAndTime.text = weather.localDate.uppercased()
        
        if weather.icon == "" {
            weatherImg.isHidden = true
        } else {
            weatherImg.isHidden = false
            weatherImg.image = UIImage(named: weather.icon)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMore" {
            let svc = segue.destination as! NextWeatherVC;
            svc.passedTemp = weather.tempArray
            svc.passedImage = weather.iconArray
            svc.passedDate = weather.localDateArray
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self._currLat = manager.location!.coordinate.latitude
        UserDefaults.standard.set(self._currLat, forKey: "LAT")
        
        self._currLon = manager.location!.coordinate.longitude
        UserDefaults.standard.set(self._currLon, forKey: "LON")
        
        downloadAndUpdate()
    }
    
    func downloadAndUpdate() {
        let lattitude = UserDefaults.standard.double(forKey: "LAT")
        let longitude = UserDefaults.standard.double(forKey: "LON")
        weather.grabVariables(lattitude, long: longitude)
        weather.downloadWeatherDetails() { () -> () in
            self.updateUI()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        _currLat = 52.379189
        _currLon = 4.899431
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        _currLat = 52.379189
        _currLon = 4.899431
    }
}

