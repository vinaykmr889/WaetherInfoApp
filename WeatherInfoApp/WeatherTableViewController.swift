//
//  ViewController.swift
//  WeatherInfo
//
//  Created by Vinay Kumar on 21/11/19.
//  Copyright © 2019 Vinay Kumar. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchBarEnable : Bool = false
    var searchedValues = [String]()
    var weatherDetailedInfo: MoreComplexStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        searchBarEnable = true
        self.weatherDetailedInfo = nil
        self.tableView.reloadData()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            searchedValues.insert(locationString, at: 0)
            if (searchedValues.count > 10){
                let arraySlice = searchedValues[..<10]
                searchedValues = Array(arraySlice)
            }
            updateWeatherForLocation(location: locationString)
        }
    }
    
    func updateWeatherForLocation (location:String) {
        APIClient.init().forecast(withLocation: location, completion: { (results: MoreComplexStruct?) in
            self.searchBarEnable = false
            if (results != nil){
                self.weatherDetailedInfo = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Message", message: "Data is not available", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchBarEnable == true){
            return searchedValues.count
        } else if (self.weatherDetailedInfo != nil){
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (self.searchBarEnable == true){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = searchedValues[indexPath.row]
            return cell

        } else{
            let cellIdentifier : NSString = "WeatherInfoCell"
            let cell: WeatherInfoCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as! WeatherInfoCell
            cell.name?.text = self.weatherDetailedInfo?.name
            if let pressure = self.weatherDetailedInfo?.main.pressure {
                cell.pressure?.text = "Pressure: \(String(describing: pressure))"            }
            
            if let temperature = self.weatherDetailedInfo?.main.temp {
                cell.temperature?.text = "Temperature: \(String(describing: temperature))"
            }
            
            if let windSpeed = self.weatherDetailedInfo?.wind.speed {
                cell.windSpeed?.text = "Wind Speed: \(String(describing: windSpeed))"
            }
            
            if let humidity = self.weatherDetailedInfo?.main.temp {
                cell.humidity?.text = "Humidity: \(String(describing: humidity))"
            }
            
            if let clouds = self.weatherDetailedInfo?.clouds.all {
                cell.clouds?.text = "Clouds: \(String(describing: clouds))"
            }
            
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (searchBarEnable == true){
            return 55.0
        } else if (self.weatherDetailedInfo != nil){
            return 196.0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
        let location = self.searchedValues[indexPath.row] as String
        self.searchBar.text = location
        updateWeatherForLocation(location: location)
    }
}


