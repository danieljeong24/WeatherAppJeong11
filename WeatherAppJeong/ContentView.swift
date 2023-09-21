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
 *https://www.tutorialspoint*.com/swift-program-to-convert-fahrenheit-to-celsius#:~:text=Swift%20provides%20good%20support%20to,to%20convert%20Fahrenheit%20to%20Celsius.
 *https://stackoverflow.com/questions/56828331/display-a-float-with-specified-decimal-places-in-swiftui
 *https://stackoverflow.com/questions/26441733/functions-returning-a-string-swift
 * I used the website above to understand how to make a function that returns a string to get the right SF symbol depending on the weather code
 
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
                if let location1 = locationManager.currentLocation {
                                Text("Latitude: \(location1.coordinate.latitude)")
                                Text("Longitude: \(location1.coordinate.longitude)")
                            } else {
                                Text("Fetching Location...")
                            }
         

                CityTextView(cityName: viewModel.cityName)
                
                MainWeatherStatusView(imageName: getSymbol(value: viewModel.currentWeatherCode), temperature: viewModel.currentTemp,
                                      windSpeed: viewModel.windspeed, windDirection: viewModel.winddirection)
                
                
                HStack(spacing: 20){
                    WeatherDayView(dayOfWeek: viewModel.times[0], imageName: getSymbol(value: viewModel.weathercodes[0]), maxtemp: viewModel.tempMax[0], mintemp: viewModel.tempMin[0])
                    WeatherDayView(dayOfWeek: viewModel.times[1], imageName: getSymbol(value: viewModel.weathercodes[1]), maxtemp: viewModel.tempMax[1], mintemp: viewModel.tempMin[1])
                    WeatherDayView(dayOfWeek: viewModel.times[2], imageName: getSymbol(value: viewModel.weathercodes[2]), maxtemp: viewModel.tempMax[2], mintemp: viewModel.tempMin[2])
                    
                    
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
    var maxtemp: Float
    var mintemp: Float
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
            Text("High \(Int(maxtemp))°F")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
            Text("Low \(Int(mintemp))°F")
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
                .frame(width: 50, height: 50)
                
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

func getSymbol(value: Int) -> String{
    var symbolstring = ""
    switch value{
        //clear sky
    case 0:
        //
        symbolstring = "sun.max.fill"
    //Mainly Clear
    case 1:
        symbolstring = "sun.max.fill"
    //Partly Cloudy
    case 2:
        symbolstring = "cloud.sun.fill"
    //Overcast
    case 3:
        symbolstring = "cloud.fill"
    //Fog
    case 45,48:
        symbolstring = "cloud.fog.fill"
    //Drizzle
    case 51,53,55:
        symbolstring = "cloud.drizzle.fill"
    //Freezing Drizzle
    case 56,57:
        symbolstring = "cloud.hail.fill"
    //Rain
    case 61,63,65:
        symbolstring = "cloud.rain.fill"
    //Freezing Rain
    case 66,67:
        symbolstring = "cloud.hail.fill"
    //Snow Fall
    case 71,73,75:
        symbolstring = "cloud.snow.fill"
    //Snow Grains
    case 77:
        symbolstring = ""
    //Rain Showers
    case 80,81,82:
        symbolstring = "cloud.heavyrain.circle.fill"
    //Snow showers
    case 85,86:
        symbolstring = "cloud.sleet.fill"
    //Thunderstorm
    case 95:
        symbolstring = "cloud.bolt.rain.fill"
    //Thunderstorm with hail
    case 96, 99:
        symbolstring = "cloud.bolt.rain.circle"
    default:
        return "hurricane"
    }

    
    
    return symbolstring
}

