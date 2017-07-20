//
//  WeatherCell.swift
//  my-weather
//
//  Created by Dide van Berkel on 01-04-16.
//  Copyright © 2017 Dide van Berkel. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    func configureCell(_ text: Double, img: String, date: String) {
        
        if UserDefaults.standard.bool(forKey: "switchIsOn") {
            temp.text = "\(round(text * 10)/10)ºF"
        } else {
            temp.text = "\(round(text * 10)/10)ºC"
        }
        
        weatherImg.image = UIImage(named: "\(img)")
        day.text = date.uppercased()
    }
}
