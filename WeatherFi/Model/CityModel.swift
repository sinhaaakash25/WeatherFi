//
//  CityModel.swift
//  WeatherFi
//
//  Created by Aakash Sinha on 24/05/22.
//

import Foundation



// MARK: - CityModel
struct CityModel: Codable {
    
    var key: String
    

    enum CodingKeys: String, CodingKey {
        case key = "Key"
        
    }
}

typealias CityData = [CityModel]
