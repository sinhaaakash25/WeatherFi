//
//  API+Extension.swift
//  Weather
//
//  Created by Aakash Sinha on 20/05/22.
//

import Foundation
// Weather
//https://dataservice.accuweather.com/currentconditions/v1/28143?apikey=5JDRFIrXaiDvy8eHQC0LeC1DjzQWpt5h

// City
//https://dataservice.accuweather.com/locations/v1/topcities?apikey=5JDRFIrXaiDvy8eHQC0LeC1DjzQWpt5h
extension API {
    static let baseURLString = "https://dataservice.accuweather.com"
    
    static func getCityURL(cityName: String) -> String {
        return "\(baseURLString)/locations/v1/cities/search?apikey=\(API.key)&q=\(cityName)"
    }
    
    static func getWeatherURL(locationKey: String) -> String {
        return "\(baseURLString)/currentconditions/v1/\(locationKey)?apikey=\(API.key)"
    }
}

