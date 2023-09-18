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
    let geometry: OpenCageGeometry
    let main: OpenMain
}

struct OpenCageGeometry: Decodable {
    let lat: Double
    let lng: Double
}

struct OpenWeatherResponse: Decodable {
    let weather: [OpenWeather]
}

struct OpenWeather: Decodable {
    let description: String
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


