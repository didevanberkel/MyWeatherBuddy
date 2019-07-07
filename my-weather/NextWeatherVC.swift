//
//  WeatherVC.swift
//  my-weather
//
//  Created by Dide van Berkel on 01-04-16.
//  Copyright © 2017 Dide van Berkel. All rights reserved.
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return passedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherCell {
            cell.configureCell(passedTemp[indexPath.row], img: passedImage[indexPath.row], date: passedDate[indexPath.row])
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
}
