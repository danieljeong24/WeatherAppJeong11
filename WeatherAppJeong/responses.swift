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
    let currentweather: [OpenCurrentWeather]
    let main: [OpenMain]
}

struct OpenCurrentWeather: Decodable {
    let temperature: Float
    let windspeed: Float
    let winddirection: Int
    let weathercode: Int
}
struct OpenMain: Decodable
{
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Float
    let humidity: Float
}


