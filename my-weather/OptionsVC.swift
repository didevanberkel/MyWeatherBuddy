//
//  OptionsVC.swift
//  my-weather
//
//  Created by Dide van Berkel on 03-04-16.
//  Copyright © 2017 Dide van Berkel. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OptionsVC: UIViewController {
    
    var mainWeatherVC = MainWeatherVC()
    
    @IBOutlet weak var offOnLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "switchIsOn") {
            offOnLabel.text = "ON"
            mySwitch.setOn(true, animated:true)
        } else {
            offOnLabel.text = "OFF"
            mySwitch.setOn(false, animated:true)
        }
        
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
    
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchChanged(_ sender: AnyObject) {
        
        if mySwitch.isOn {
            offOnLabel.text = "ON"
            UserDefaults.standard.set(true, forKey: "switchIsOn")
            UserDefaults.standard.synchronize()
        } else {
            offOnLabel.text = "OFF"
            UserDefaults.standard.set(false, forKey: "switchIsOn")
            UserDefaults.standard.synchronize()
        }
    }
}
