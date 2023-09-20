//
//  WeatherViewModel.swift
//  geocoding_and weather_web
//
//  Created by Chad on 9/7/23.
//

import Foundation
import SwiftUI
import Combine

// Define a class named 'WeatherViewModel' that conforms to the ObservableObject protocol.
// This protocol allows SwiftUI to watch for changes in this object and update the UI accordingly.
class WeatherViewModel: ObservableObject {
    
    // A published property wrapper that notifies its subscribers about changes to 'weatherDetails' string
    // which will help in automatically updating the UI when this property changes.
    @Published var weatherDetails: String = ""
    @Published var cityName: String = ""
    @Published var currentTemp: Float = 0.0
    @Published var windspeed: Float = 0.0
    @Published var winddirection: Float = 0.0
    
    // A set to store any cancellable operations.
    // This is used to store references to network data tasks
    //  so they can be cancelled if needed.
    private var cancellables = Set<AnyCancellable>()
    
    //asynchronous function to get city given latitude and longitude
    func getCityForLatLong(latitude: Double, longitude: Double) async throws  {
        
        cityName=""
        
        // Step 1: Constructing the URL for fetching weather data.
        // Creating a URL to fetch weather data based on the provided latitude and longitude.
        guard let weatherURL = URL(string: "https://api.opencagedata.com/geocode/v1/json?q=\(latitude)+\(longitude)&key=1b4c15a80e764b62922872339c99f30b")
        else {
            print("Invalid URL")
            return
        }
        
        // Initiating another do-catch block to handle potential errors during the network request and JSON decoding process.
        do {
            
            // Step 2: Making a network request to fetch weather data.
            // Making an asynchronous network request to get data and response from the URL.
            let (data, response) = try await URLSession.shared.data(from: weatherURL)
            
            // Step 3: Checking the response code to ensure the response is successful (status code 200).
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            // Step 4: Decoding the JSON data to extract weather details.
            // Decoding the received data to 'OpenWeatherResponse' model to extract the weather details.
            let openCageResponse = try JSONDecoder().decode(OpenCageResponse.self, from: data)
            
            // Step 5: Updating the UI with weather details.
            // Switching to the main thread to update the 'weatherDetails' property with fetched weather description.
            // This will automatically update the UI since 'weatherDetails' is marked with the @Published property wrapper.
            DispatchQueue.main.async {
                self.cityName = "\(openCageResponse.results.first?.components.city ?? "No description available")"
            }
        } catch {
            
            // Handling and printing errors that might occur during the network request or JSON decoding.
            print("Failed to get city of lat and long: \(error)")
        }
    }

    
    // An asynchronous function to fetch weather data for given latitude and longitude.
    // It may throw errors which need to be handled by the caller.
    func getWeatherForLatLong(latitude: Double, longitude: Double) async throws  {
        
        weatherDetails=""
        
        // Step 1: Constructing the URL for fetching weather data.
        // Creating a URL to fetch weather data based on the provided latitude and longitude.
        guard let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=3132aec7af5def9f379ab3785edae6fc")
        else {
            print("Invalid URL")
            return
        }
        
        // Initiating another do-catch block to handle potential errors during the network request and JSON decoding process.
        do {
            
            // Step 2: Making a network request to fetch weather data.
            // Making an asynchronous network request to get data and response from the URL.
            let (data, response) = try await URLSession.shared.data(from: weatherURL)
            
            // Step 3: Checking the response code to ensure the response is successful (status code 200).
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            // Step 4: Decoding the JSON data to extract weather details.
            // Decoding the received data to 'OpenWeatherResponse' model to extract the weather details.
            let weatherResponse = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
            
            // Step 5: Updating the UI with weather details.
            // Switching to the main thread to update the 'weatherDetails' property with fetched weather description.
            // This will automatically update the UI since 'weatherDetails' is marked with the @Published property wrapper.
            DispatchQueue.main.async {
                self.weatherDetails = "Weather Info: \(weatherResponse.weather.first?.description ?? "No description available")"
            }
        } catch {
            
            // Handling and printing errors that might occur during the network request or JSON decoding.
            print("Failed to get weather data: \(error)")
        }
    }
}





