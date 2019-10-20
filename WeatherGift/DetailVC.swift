//
//  DetailVCViewController.swift
//  WeatherGift
//
//  Created by Kyle Gil Tan on 10/11/19.
//  Copyright © 2019 Kyle Gil Tan. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        // Do any additional setup after loading the view.
    }
    

}
