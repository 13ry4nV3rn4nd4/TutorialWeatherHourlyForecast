//
//  HoursDetails.swift
//  WeatherHourlyForecast
//
//  Created by Bryan Vernanda on 23/07/24.
//

import SwiftUI
import WeatherKit

struct HoursDetails: View {
    @ObservedObject var weatherManager: WeatherManager
    var hourWeather: HourWeather?
    var displayTime: String?
    
    var body: some View {
        if let hour = hourWeather {
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Text(displayTime ?? hour.date.formatted(.dateTime.hour()))
                        .font(.system(size: 13.0))
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .fixedSize(horizontal: true, vertical: false)
                }
                
                HStack {
                    Image(systemName: "\(hour.symbolName).fill")
                        .font(.system(size: 24.46))
                }
                .frame(height: 40)
                
                HStack(alignment: .center) {
                    Text("\(Int(hour.temperature.value))°")
                        .font(.system(size: 13.0))
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                }
            }
            .frame(width: displayTime != "Sekarang" ? 40 : nil, height: 80)
            .frame(maxWidth: displayTime != "Sekarang" ? nil : .infinity)
            .padding(displayTime != "Sekarang" ? [.top, .bottom] : .all, 4)
        }
    }
}

#Preview {
    HoursDetails(
        weatherManager: WeatherManager()
    )
}

