//
//  WeatherVC.swift
//  my-weather
//
//  Created by Dide van Berkel on 01-04-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit

class NextWeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var weather = Weather()
    var passedTemp = [Double]()
    var passedImage = [String]()
    var passedDate = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(red: 64.0/255.0, green: 146.0/255.0, blue: 168.0/255.0, alpha: 1)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedDate.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as? WeatherCell {
            cell.configureCell(passedTemp[indexPath.row], img: passedImage[indexPath.row], date: passedDate[indexPath.row])
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
