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
 */

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack{
            BackgroundView(topColor: .blue, bottomColor: .purple )
             
            VStack{
                CityTextView(cityName: "Colorado Springs, CO")
                
                MainWeatherStatusView(imageName: "cloud.sun.fill", temperature: 77)
                
                HStack(spacing: 20){
                    WeatherDayView(dayOfWeek: "TUES", imageName: "cloud.sun.fill", temp: 69)
                    WeatherDayView(dayOfWeek: "WED", imageName: "cloud.snow.fill", temp: 25)
                    WeatherDayView(dayOfWeek: "THUR", imageName: "sun.max.fill", temp: 88)
                    WeatherDayView(dayOfWeek: "FRI", imageName: "cloud.bolt.rain.fill", temp: 45)
                    WeatherDayView(dayOfWeek: "SAT", imageName: "sunset.fill", temp: 72)
                    
                    
                }
                Spacer() //vstack is the whole length of the screen but the rest of the space below the text is free to use
                
                Button{
                    print("tapped")
                } label:{
                    //label is what the button looks like
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                     
                }
                
                //Space co unts as a view, You can only have 10 views so no more than 11 views
                Spacer()
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
            Text("\(temp)°")
                .font(.system(size: 28, weight: .medium))
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
    var temperature: Int
    var body: some View{
        VStack(spacing: 10){
            Image(systemName: imageName)
                .renderingMode(.original)
                //make your image resizable
                .resizable()
                // fits it within the frame
                .aspectRatio(contentMode: .fit)
                //make a frame to give it a fixd size
                .frame(width: 180, height: 180)
                
                Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
                
        }
        .padding(.bottom, 40)
    }
}

