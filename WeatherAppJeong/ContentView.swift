//
//  ContentView.swift
//  WeatherAppJeong
//
//  Created by Daniel Jeong on 8/28/23.
//

/*  Name: Daniel Jeong
 *  Assignment: PEX 1
 * Feature Added:
 *  Documentation Statement:
 * Used the template code for weather view model to pull data from JSON files
 *https://www.tutorialspoint.com/swift-program-to-convert-fahrenheit-to-celsius#:~:text=Swift%20provides%20good%20support%20to,to%20convert%20Fahrenheit%20to%20Celsius.
 *https://stackoverflow.com/questions/56828331/display-a-float-with-specified-decimal-places-in-swiftui
* Used this link above to convert farehnheit to celsius
 */

import CoreLocation
import SwiftUI

struct ContentView: View {
    
    //How can you make struct hold state
    //
    @State private var isNight = false
    @ObservedObject var locationManager = LocationManager()
    //CLLocationManager to pull current location
    
    //Variables to store latitude and longtitude
    
    // Create an observed object property wrapper to an instance of WeatherViewMode.
    // SwiftUI watches this object for any changes to update the UI accordingly.
    @ObservedObject var viewModel = WeatherViewModel()
    

    //Text("Latitude: \(location.coordinate.latitude)")
    //Text("Longitude: \(location.coordinate.longitude)")
    var body: some View {
        let location = locationManager.currentLocation
        let latitude  = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        
        
        ZStack{
            BackgroundView(topColor: isNight ? .black: .blue, bottomColor: isNight ? .gray : .purple )
            
            
            VStack{
                
                
                
 
                Button(action: {
                    
                    // Creates a new task to run the getCoordinates method asynchronously.
                    Task {
                        
                        // A do-catch block to try calling the async method and
                        //  handle any errors that might occur.
                        do {
                            
                            // Calls the getCoordinates method asynchronously using await
                            // If the method throws an error, it will be caught in the catch block
                            try await viewModel.getCityForLatLong(latitude: latitude ?? 33.8703, longitude: longitude ?? -117.9253)
                            try await viewModel.getWeatherForLatLong(latitude: latitude ?? 33.8703, longitude: longitude ?? -117.9253)
                            
                        } catch {
                            
                            // Catches any errors thrown by the
                            //  getCoordinates method and prints an
                            //  error message to the console.
                            print("An error occurred: \(error)")
                        }
                    }
                }) {
                    Text("Get Weather") // The label for the button
                        .foregroundColor(Color.white)
                        .frame(width: 280, height: 50)
                }
                if let location1 = locationManager.currentLocation {
                                Text("Latitude: \(location1.coordinate.latitude)")
                                Text("Longitude: \(location1.coordinate.longitude)")
                            } else {
                                Text("Fetching Location...")
                            }
         

                CityTextView(cityName: viewModel.cityName)
                
                MainWeatherStatusView(imageName: "cloud.sun.fill", temperature: viewModel.currentTemp,
                                      windSpeed: viewModel.windspeed, windDirection: viewModel.winddirection)
                
                
                HStack(spacing: 20){
                    WeatherDayView(dayOfWeek: "TUES", imageName: "cloud.sun.fill", temp: 69)
                    WeatherDayView(dayOfWeek: "WED", imageName: "cloud.snow.fill", temp: 25)
                    WeatherDayView(dayOfWeek: "THUR", imageName: "sun.max.fill", temp: 88)
                    
                    
                }
                Spacer() //vstack is the whole length of the screen but the rest of the space below the text is free to use
                
                
                Button{
                    //toggles the var from false to true
                    isNight.toggle()
                } label:{
                    //label is what the button looks like
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                     
                }
                
                //Space counts as a view, You can only have 10 views so no more than 11 views
                Spacer()
            }
            
            
        }
        .onAppear{
        Task(priority: .background){
            Task {
                
                // A do-catch block to try calling the async method and
                //  handle any errors that might occur.
                do {
                    
                    // Calls the getCoordinates method asynchronously using await
                    // If the method throws an error, it will be caught in the catch block
                    try await viewModel.getCityForLatLong(latitude: latitude ?? 33.8703, longitude: longitude ?? -117.9253)
                    
                } catch {
                    
                    // Catches any errors thrown by the
                    //  getCoordinates method and prints an
                    //  error message to the console.
                    print("An error occurred: \(error)")
                }
            }
        }
    }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var temp: Int
    var body: some View {
        VStack{
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
            //make your image resizable
                .resizable()
            //fits it within the frame
                .aspectRatio(contentMode: .fit)
            //make a frame to give it a fixd size
                .frame(width: 40, height: 40)
            Text("High \(temp)°F")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
            Text("Low \(temp)°F")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
            
        }
    }
}

struct BackgroundView: View {
    var topColor: Color
    var bottomColor: Color
    var body: some View {
        
        
        LinearGradient(gradient: Gradient (colors: [topColor, bottomColor]), startPoint: .topTrailing, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View{
    var cityName: String
    var body: some View{
        Text(cityName)
            //order of modifiers matter
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View{
    var imageName: String
    var temperature: Float
    var windSpeed: Float
    var windDirection: Int
    var body: some View{
        VStack(spacing: 10){
            Image(systemName: imageName)
                .renderingMode(.original)
                //make your image resizable
                .resizable()
                // fits it within the frame
                .aspectRatio(contentMode: .fit)
                //make a frame to give it a fixd size
                .frame(width: 100, height: 100)
                
            HStack{
                Text("\(Int(temperature))°F |" )
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.white)
                
                let celsius = (temperature - 32) * 5/9
                let formattedFloat = String(format: "%.1f", celsius)
                Text("\(formattedFloat)°C")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.white)
                
            }
    
       
                
                Text("3-day Forecast")
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(.white)
                
        }
        .padding(.bottom, 10)
    }
}

