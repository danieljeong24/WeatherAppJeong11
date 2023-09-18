//
//  WeatherViewModel.swift
//  geocoding_and weather_web
//
//  Created by Daniel Jeong on 9/7/23.
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
    
    // A set to store any cancellable operations.
    // This is used to store references to network data tasks
    //  so they can be cancelled if needed.
    private var cancellables = Set<AnyCancellable>()
    
    // An asynchronous function that tries to get geo-coordinates from the given address.
    // It may throw errors which should be handled by the caller.
    func getWeatherForLocation(address: String) async throws {
        
        weatherDetails=""
        
        // Step 1: Constructing the URL
        // Encoding the address string to safely include it in a URL.
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        // Constructing the URL string using the encoded address.
        let url:String = "https://api.opencagedata.com/geocode/v1/json?q=\(encodedAddress))&key=46928845ebb9451b92671562d811794d"
        
        // Checking if the URL is valid, if not print an error and return.
        guard let openCageURL = URL(string:url)
        else
        {
            print("Invalid address or URL")
            return
        }
        
        // Initiating a do-catch block to handle potential errors
        //  during the network request and JSON decoding process.
        do {
            
            // Step 2: Making a network request to fetch coordinates.
            // Making an asynchronous network request to get data and response from the URL.
            let (data, response) = try await URLSession.shared.data(from: openCageURL)
            
            // Step 3: Checking the response code to ensure the response is successful (status code 200).
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else
            {
                throw URLError(.badServerResponse)
            }
            
            // Step 4: Decoding the JSON data to extract coordinates.
            // Decoding the received data to 'OpenCageResponse' model to extract the coordinates.
            let openCageResponse = try JSONDecoder().decode(OpenCageResponse.self, from: data)
            
            // Checking if coordinates are present and
            //  then fetching weather data using those coordinates.
            if let lat = openCageResponse.results.first?.geometry.lat,
                let lon = openCageResponse.results.first?.geometry.lng {
                
                // Step 5: Initiating a call to fetch weather data using the coordinates retrieved.
                try await getWeatherForLatLong(latitude: lat, longitude: lon)
            }
        } catch {
            
            // Handling and printing errors that might occur
            //  during the network request or JSON decoding.
            print("Failed to get coordinates: \(error)")
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



