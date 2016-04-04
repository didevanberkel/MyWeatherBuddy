//
//  OptionsVC.swift
//  my-weather
//
//  Created by Dide van Berkel on 03-04-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
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
        
        if NSUserDefaults.standardUserDefaults().boolForKey("switchIsOn") {
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
        banner.loadRequest(request)
        banner.frame = CGRectMake(0, view.bounds.height - banner.frame.size.height, banner.frame.size.width, banner.frame.size.height)
        self.view.addSubview(banner)
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func switchChanged(sender: AnyObject) {
        
        if mySwitch.on {
            offOnLabel.text = "ON"
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "switchIsOn")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            offOnLabel.text = "OFF"
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "switchIsOn")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
