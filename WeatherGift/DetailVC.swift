//
//  DetailVCViewController.swift
//  WeatherGift
//
//  Created by Kyle Gil Tan on 10/11/19.
//  Copyright © 2019 Kyle Gil Tan. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() { //
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if currentPage != 0{
            self.locationsArray[currentPage].getWeather{
                self.updateUserInterface()}
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (currentPage==0){
            getLocation()
        }
    }
    
    func updateUserInterface(){
        let location = locationsArray[currentPage]
        let dateString = formatTimeforTimeZone(unixDate: location.currentTime, timeZone: location.timeZone)
        locationLabel.text = location.name
        dateLabel.text = dateString
        temperatureLabel.text = location.currentTemp
        summaryLabel.text = location.currentSummary
        currentImage.image = UIImage(named: location.currentIcon)
    }
    
    func formatTimeforTimeZone(unixDate: TimeInterval,timeZone: String) -> String {
        let useableDate = Date(timeIntervalSince1970: unixDate)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd, y"
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: useableDate)
        return dateString
    }
}

extension DetailVC: CLLocationManagerDelegate{
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
//        let status = CLLocationManager.authorizationStatus()
//        handleLocationAuthorizationStatus(status: status)
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus){
        switch status{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, . authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            print("I'm sorry can't show location user has not authorized it")
        case . restricted:
            print("Access denied.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        var place = ""
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            placemarks, error in
            if placemarks != nil{
                let placemark = placemarks?.last
                place = (placemark?.name)!
            }
            else{
                print("Error retrieving place. Error code:\(error)")
                place = "Unknown Weather Location"
            }
            self.locationsArray[0].name = place
            self.locationsArray[0].coordinates = currentCoordinates
            self.locationsArray[0].getWeather{
                self.updateUserInterface()}
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location")
    }
}

extension DetailVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
