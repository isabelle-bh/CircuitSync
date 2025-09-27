//
//  RaceFetcher.swift
//  CircuitSync
//
//  Created by Isabelle Beaudry Hajji on 2025-09-26.
//

/*
 We need a function that:

 Calls the API URL.

 Gets raw JSON back.

 Decodes JSON → Race models.

 Updates races.
 */

import SwiftUI
import Combine

let circuitData: [String: (laps: Int, length: Float)] = [
    "Albert Park": (laps: 58, length: 5.303),                  // from your example
    "Jeddah Corniche": (laps: 50, length: 6.174),              // 2025 Saudi GP :contentReference[oaicite:0]{index=0}
    "Monaco": (laps: 78, length: 3.337),                       // Monaco GP standard :contentReference[oaicite:1]{index=1}
    "Silverstone": (laps: 52, length: 5.891),                  // Silverstone track listing :contentReference[oaicite:2]{index=2}
    "Spa-Francorchamps": (laps: 44, length: 7.004),             // Belgian GP 2025 :contentReference[oaicite:3]{index=3}

    // Additional ones found:
    "Shanghai": (laps: 56, length: 5.451),             // China GP circuit listing :contentReference[oaicite:4]{index=4}
    "Suzuka": (laps: 53, length: 5.807),                // Suzuka circuit info from sportmonks page :contentReference[oaicite:5]{index=5}
    "Bahrain": (laps: 57, length: 5.412),                      // Bahrain GP track info :contentReference[oaicite:6]{index=6}
    "Miami": (laps: 57, length: 5.412),                        // 2025 Miami GP info :contentReference[oaicite:7]{index=7}
    "Barcelona": (laps: 66, length: 4.675),        // Circuit de Barcelona info :contentReference[oaicite:8]{index=8}
    "Red Bull Ring": (laps: 71, length: 4.318),      // Austria GP track info :contentReference[oaicite:9]{index=9}
    "Hungaroring": (laps: 70, length: 4.381),        // from sportmonks track listing :contentReference[oaicite:10]{index=10}
    "Zandvoort": (laps: 72, length: 4.259),      // Dutch GP 2025 data :contentReference[oaicite:11]{index=11}
    "Monza": (laps: 53, length: 5.793),                // Monza (Italy) info from track listing :contentReference[oaicite:12]{index=12}
    "Circuit of The Americas": (laps: 56, length: 5.513),// US GP 2025 info :contentReference[oaicite:13]{index=13}
    "Autódromo Hermanos Rodríguez (Mexico)": (laps: 71, length: 4.304), // Mexico GP track listing :contentReference[oaicite:14]{index=14}
    "Interlagos / José Carlos Pace (Brazil)": (laps: 71, length: 4.309), // Brazilian GP track listing :contentReference[oaicite:15]{index=15}
    "Las Vegas Strip Circuit": (laps: 50, length: 6.201),      // Las Vegas GP 2025 info from Formula1 site :contentReference[oaicite:16]{index=16}
    "Marina Bay (Singapore)": (laps: 61, length: 5.063),       // Singapore track listing :contentReference[oaicite:17]{index=17}
    "Yas Marina (Abu Dhabi)": (laps: 58, length: 5.281)        // Abu Dhabi GP track listing :contentReference[oaicite:18]{index=18}
]

// we make this observable so that SwiftUI views automatically update when the fetcher gets new data
class RaceFetcher : ObservableObject {
    // we want the list of races that updates when data is fetched
    @Published var races: [Race] = [] // empty but gets populated when api call finishes
    //@Published means: whenever this property changes, any SwiftUI view using it will refresh.
    
    func fetchRaces() {
        var currentYear: String {
            let year = Calendar.current.component(.year, from: Date())
            return String(year)
        }
        guard let url = URL(string: "https://api.openf1.org/v1/meetings?year=\(currentYear)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let decodedMeetings = try? decoder.decode([Race].self, from: data) {
                    let enriched = decodedMeetings.map { race -> Race in
                             var enrichedRace = race
                             if let info = circuitData[race.track] {
                                 enrichedRace.laps = info.laps
                                 enrichedRace.circuitLength = info.length
                             }
                             return enrichedRace
                         }
                    
                    DispatchQueue.main.async {
                        self.races = enriched
                    }
                }
            }
        }.resume()
    }
    
}
