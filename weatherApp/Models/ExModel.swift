//
//  ExModel.swift
//  weatherApp
//
//  Created by Timur Israilov on 22/01/21.
//

import Foundation
struct WeatherResult: Decodable {
    let list: Array<WeatherModel>
}

struct WeatherModel: Decodable {
    let dt_txt: String
    let main: WeatherMainModel
    let weather: Array<WeatherWeatherModel>
}

struct WeatherMainModel: Decodable {
    let temp: Double
}

struct WeatherWeatherModel: Decodable {
    let description: String
    let id: Int
}
