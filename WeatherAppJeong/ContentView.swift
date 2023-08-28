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
            LinearGradient(gradient: Gradient (colors: [.blue, .green, .white]), startPoint: .topTrailing, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
             
            VStack{
                Text("Colorado Springs, CO")
                    //order of modifiers matter
                    .font(.system(size: 32, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding()
                Spacer() //vstack is the whole length of the screen but the rest of the space below the text is free to use
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
