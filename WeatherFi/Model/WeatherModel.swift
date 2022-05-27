//
//  WeatherModel.swift
//  WeatherFi
//
//  Created by Aakash Sinha on 24/05/22.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WeatherModel

typealias WeatherData = [WeatherModel]


struct WeatherModel: Codable {
    var epoch: Int
    var weatherText: String
    var temperature: Temperature
    

    enum CodingKeys: String, CodingKey {
        case epoch = "EpochTime"
        case weatherText = "WeatherText"
        case temperature = "Temperature"
    }
}

// MARK: - Temperature
struct Temperature: Codable {
    var metric, imperial: Imperial

    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        case imperial = "Imperial"
    }
}

// MARK: - Imperial
struct Imperial: Codable {
    var value: Double
    var unit: String
    var unitType: Int

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}



