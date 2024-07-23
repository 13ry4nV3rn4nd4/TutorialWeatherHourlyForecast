//
//  WeatherManager.swift
//  WeatherHourlyForecast
//
//  Created by Bryan Vernanda on 23/07/24.
//

import CoreLocation
import WeatherKit

class WeatherManager: ObservableObject {
    private let weatherService = WeatherService()
    
    //this is used to store the hourlyForecast for specific location coordinate
    @Published var hourlyForecast: Forecast<HourWeather>?
    
    //this is used to store the hourlyForecast for user location coordinate
    @Published var userHourlyForecast: Forecast<HourWeather>?
    
    // this is used to manage when weather hasn't load yet
    @Published var isLoading = true
    @Published var stateText: String = "Loading.."
    
    // use the LocationManager in order to get user's current location
    var locationManager = LocationManager()

    func getHourlyForecast(for location: CLLocation, userLocation: Bool) async {
        let startDate = Date()
        
        //takes 25 hours from our current hour time and is updated every hour, the "value" parameter can be adjusted as needed.
        let endDate = Calendar.current.date(byAdding: .hour, value: 25, to: startDate) ?? startDate

        do {
            //fetching hourly forecast from the weather service on a specific location
            let forecastData = try await weatherService.weather(for: location, including: .hourly(startDate: startDate, endDate: endDate))
            DispatchQueue.main.async {
                (userLocation != true) ? (self.hourlyForecast = forecastData) : (self.userHourlyForecast = forecastData)
            }
        } catch {
            print("Failed to get hourly forecast data. \(error)")
        }
    }
    
    // to get hourly weather forecast on a specific location coordinate
    func fetchWeatherDataOnLoc(for location: CLLocation) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        await self.getHourlyForecast(for: location, userLocation: false)
        
        DispatchQueue.main.async {
            self.isLoading = false
            self.stateText = ""
        }
    }
    
    // to get hourly weather forecast based on user's current location
    func fetchWeatherDataOnUserLoc() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        // run the location manager update location to get the user's location
        locationManager.updateLocation { location, error in
            DispatchQueue.main.async {
                guard let currentLocation = location, error == nil else {
                    self.stateText = "Cannot get your location. \n \(error?.localizedDescription ?? "")"
                    self.isLoading = false
                    return
                }

                Task {
                    await self.getHourlyForecast(for: currentLocation, userLocation: true)
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.stateText = ""
                    }
                }
            }
        }
    }
}
