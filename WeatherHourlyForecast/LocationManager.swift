//
//  LocationManager.swift
//  WeatherHourlyForecast
//
//  Created by Bryan Vernanda on 23/07/24.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager() // Instance of CLLocationManager for location updates
    typealias LocationUpdateHandler = ((CLLocation?, Error?) -> Void) // Typealias for location update handler closure
    private var didUpdateLocation: LocationUpdateHandler? // Closure to handle location updates
    
    override init() {
        super.init()
        manager.delegate = self  // Set the delegate to self to receive location updates
        manager.desiredAccuracy = kCLLocationAccuracyKilometer  // Set the desired accuracy for location updates
        manager.requestWhenInUseAuthorization()  // Request authorization to use location services when the app is in use
    }
    
    // Public method to start location updates and provide a closure to handle updates
    public func updateLocation(handler: @escaping LocationUpdateHandler) {
        self.didUpdateLocation = handler  // Set the closure to handle location updates
        manager.startUpdatingLocation()  // Start receiving location updates
    }
    
    // CLLocationManagerDelegate method called when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let handler = didUpdateLocation {
            handler(locations.last, nil)  // Pass the last location update and no error to the handler
        }
        manager.stopUpdatingLocation()  // Stop receiving location updates after receiving new data
    }
    
    // CLLocationManagerDelegate method called when location updates fail
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let handler = didUpdateLocation {
            handler(nil, error)  // Pass no location data and the error to the handler
        }
    }
}
