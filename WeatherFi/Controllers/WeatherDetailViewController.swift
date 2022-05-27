//
//  WeatherDetailViewController.swift
//  WeatherFi
//
//  Created by Aakash Sinha on 26/05/22.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var times = ""
    var temp = ""
    var textt = ""
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
            time.text = "Time:  \(convertToDate(time: times))"
            temperature.text = "Temperature:  \( temp)F"
            weatherText.text = textt
        
    }
    
    func convertToDate(time: String) -> String{
        let epochTime = TimeInterval(time) ?? 0 / 1000
        let date = Date(timeIntervalSince1970: epochTime)
        return date.formatted()
    }
  
}
