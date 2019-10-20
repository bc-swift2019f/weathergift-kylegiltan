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
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() { //
        super.viewDidLoad()
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (currentPage==0){
            getLocation()
        }
    }
}

extension DetailVC: CLLocationManagerDelegate{
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status: status)
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
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
        print(currentCoordinates)
        dateLabel.text = currentCoordinates
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location")
    }
}
