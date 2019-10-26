//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Kyle Gil Tan on 10/20/19.
//  Copyright © 2019 Kyle Gil Tan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation{
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    func getWeather(completed: @escaping () -> ()){
        let weatherURL = urlBase + urlAPIKey + coordinates
        //print(weatherURL)
        Alamofire.request(weatherURL).responseJSON{
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double{
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°F"
                }
                else{
                    print("No temperature")
                }
                if let summary = json["daily"]["summary"].string{
                    self.currentSummary = summary
                }
                else{
                    print("No summary")
                }
                if let icon = json["currently"]["icon"].string{
                    self.currentIcon = icon
                }
                else{
                    print("No icon")
                }
                if let timeZone = json["timezone"].string{
                    //print("Time zone for \(self.name) is \(timeZone)")
                    self.timeZone = timeZone
                }
                else{
                    print("No time zone")
                }
                if let time = json["currently"]["time"].double{
                    //print("Time for \(self.name) is \(time)")
                    self.currentTime = time
                }
                else{
                    print("No time")
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
