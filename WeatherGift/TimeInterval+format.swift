//
//  TimeInterval+format.swift
//  WeatherGift
//
//  Created by Kyle Gil Tan on 10/26/19.
//  Copyright © 2019 Kyle Gil Tan. All rights reserved.
//

import Foundation

extension TimeInterval{
    func format(timeZone: String, dateFormatter: DateFormatter) -> String {
        let useableDate = Date(timeIntervalSince1970: self)
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: useableDate)
        return dateString
    }
}
