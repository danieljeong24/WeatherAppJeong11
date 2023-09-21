//
//  responses.swift
//  Weather App Jeong
//
//  Created by Daniel Jeong on 9/16/23.
//

import Foundation

// Models to decode the JSON response data
// from opencage and openweather REST requests.

struct OpenCageResponse: Decodable {
    let results: [OpenCageResult]
}

struct OpenCageResult: Decodable {
    let components: OpenCageComponents
}

struct OpenCageComponents: Decodable{
    let city: String
}

struct OpenWeatherResponse: Decodable {
    let current_weather: OpenCurrentWeather
    let daily: OpenDaily
}



struct OpenCurrentWeather: Decodable {
    let temperature: Float
    let windspeed: Float
    let winddirection: Int
    let weathercode: Int
}

struct OpenDaily: Decodable{
    let time: [String]
    let weathercode: [Int]
    let temperature_2m_max: [Float]
    let temperature_2m_min: [Float]
    let sunrise: [String]
    let sunset: [String]
}

