//
//  ContentView.swift
//  WeatherHourlyForecast
//
//  Created by Bryan Vernanda on 23/07/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var weatherManager: WeatherManager = WeatherManager()
    let location: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    var body: some View {
        VStack {
            Text("Hourly Weather Forecast on a Specific Coordinate")
            HStack {
                if !weatherManager.isLoading {
                    // use the "hourlyForecast" variabel to get hourly weather forecast from a specific location
                    if let hourly = weatherManager.hourlyForecast {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 3) {
                                ForEach(hourly.forecast.indices, id: \.self) { index in
                                    let hour = hourly.forecast[index]
                                    HoursDetails(
                                        weatherManager: weatherManager,
                                        hourWeather: hour,
                                        displayTime: index == 0 ? String(localized: "Now") : nil
                                    )
                                    .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                } else {
                    Text(weatherManager.stateText)
                }
            }
            .padding(.bottom, 64)
            
            Text("Hourly Weather Forecast on user's current location")
            HStack {
                if !weatherManager.isLoading {
                    // use the "userHourlyForecast" variabel to get hourly weather forecast from user's location
                    if let hourly = weatherManager.userHourlyForecast {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 3) {
                                ForEach(hourly.forecast.indices, id: \.self) { index in
                                    let hour = hourly.forecast[index]
                                    HoursDetails(
                                        weatherManager: weatherManager,
                                        hourWeather: hour,
                                        displayTime: index == 0 ? String(localized: "Now") : nil
                                    )
                                    .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                } else {
                    Text(weatherManager.stateText)
                }
            }
        }
        .task {
            // to get hourly weather data on a specific location
            await weatherManager.fetchWeatherDataOnLoc(for: location)
            
            // to get hourly weather data on user's location
            await weatherManager.fetchWeatherDataOnUserLoc()
        }
    }
}

#Preview {
    ContentView()
}
