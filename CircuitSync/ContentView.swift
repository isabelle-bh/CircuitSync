//
//  ContentView.swift
//  CircuitSync
//
//  Created by Isabelle Beaudry Hajji on 2025-09-26.
//

import SwiftUI

/*
 from https://f1calendar.com/api/races.json , we should get

 [
   {
     "race": "Australian Grand Prix",
     "circuit": "Albert Park Circuit",
     "country": "Australia",
     "date": "2025-03-16T04:00:00Z",
     "laps": 58,
     "length": 5303
   },
   {
     "race": "Saudi Arabian Grand Prix",
     "circuit": "Jeddah Corniche Circuit",
     "country": "Saudi Arabia",
     "date": "2025-03-23T18:00:00Z",
     "laps": 50,
     "length": 6174
   }
 ]

 */

let circuitData: [String: (laps: Int, length: Float)] = [
    "Albert Park": (laps: 58, length: 5.303),                  // from your example
    "Jeddah Corniche": (laps: 50, length: 6.174),              // 2025 Saudi GP :contentReference[oaicite:0]{index=0}
    "Monaco": (laps: 78, length: 3.337),                       // Monaco GP standard :contentReference[oaicite:1]{index=1}
    "Silverstone": (laps: 52, length: 5.891),                  // Silverstone track listing :contentReference[oaicite:2]{index=2}
    "Spa-Francorchamps": (laps: 44, length: 7.004),             // Belgian GP 2025 :contentReference[oaicite:3]{index=3}

    // Additional ones found:
    "Shanghai (China)": (laps: 56, length: 5.451),             // China GP circuit listing :contentReference[oaicite:4]{index=4}
    "Suzuka (Japan)": (laps: 53, length: 5.807),                // Suzuka circuit info from sportmonks page :contentReference[oaicite:5]{index=5}
    "Bahrain": (laps: 57, length: 5.412),                      // Bahrain GP track info :contentReference[oaicite:6]{index=6}
    "Miami": (laps: 57, length: 5.412),                        // 2025 Miami GP info :contentReference[oaicite:7]{index=7}
    "Barcelona (Catalunya)": (laps: 66, length: 4.675),        // Circuit de Barcelona info :contentReference[oaicite:8]{index=8}
    "Red Bull Ring (Austria)": (laps: 71, length: 4.318),      // Austria GP track info :contentReference[oaicite:9]{index=9}
    "Hungaroring (Hungary)": (laps: 70, length: 4.381),        // from sportmonks track listing :contentReference[oaicite:10]{index=10}
    "Zandvoort (Netherlands)": (laps: 72, length: 4.259),      // Dutch GP 2025 data :contentReference[oaicite:11]{index=11}
    "Monza (Italy)": (laps: 53, length: 5.793),                // Monza (Italy) info from track listing :contentReference[oaicite:12]{index=12}
    "Circuit of The Americas (USA)": (laps: 56, length: 5.513),// US GP 2025 info :contentReference[oaicite:13]{index=13}
    "Autódromo Hermanos Rodríguez (Mexico)": (laps: 71, length: 4.304), // Mexico GP track listing :contentReference[oaicite:14]{index=14}
    "Interlagos / José Carlos Pace (Brazil)": (laps: 71, length: 4.309), // Brazilian GP track listing :contentReference[oaicite:15]{index=15}
    "Las Vegas Strip Circuit": (laps: 50, length: 6.201),      // Las Vegas GP 2025 info from Formula1 site :contentReference[oaicite:16]{index=16}
    "Marina Bay (Singapore)": (laps: 61, length: 5.063),       // Singapore track listing :contentReference[oaicite:17]{index=17}
    "Yas Marina (Abu Dhabi)": (laps: 58, length: 5.281)        // Abu Dhabi GP track listing :contentReference[oaicite:18]{index=18}
]


// creating a race model
struct Race: Identifiable, Codable {
    let id = UUID() // unique identifier for each race
    let name: String // name of race, eg. Monaco Grand Prix
    let track: String = "N/A"// location of race, eg. Circuit de Monaco
    let circuitLength: Float = 0// length of circuit, eg. 3.337 km
    let laps: Int = 0// number of laps
    let date: Date // date of race start time in UTC
    var attending: Bool // if the user will be attending or not (for notification purposes)
    
    enum CodingKeys: String, CodingKey {
        case name = "meeting_name"
        case track = "circuit_short_name"
        case date = "date_start"
    }
}

let sampleRaces: [Race] = [
    Race(name: "Monaco Grand Prix", date: Date(timeIntervalSinceNow: 86400), attending: true), // date = 1 day from now
    Race(name: "Canadian Grand Prix", date: Date(timeIntervalSinceNow: 604800), attending: false), // date = 1 week from now
    Race(name: "Italian Grand Prix", date: Date(timeIntervalSinceNow: 1209600), attending: true) // date = 2 weeks from now
]

struct ContentView: View {
    @State private var races = sampleRaces
    var currentYear: String {
        let year = Calendar.current.component(.year, from: Date())
        return String(year)
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 21/255, green: 21/255, blue: 29/255).ignoresSafeArea()
                List($races){ $race in
                    NavigationLink(destination: RaceDetailView(race: race)) {
                        VStack(alignment: .leading) {
                            HStack {
                                CheckBoxView(checked: $race.attending)
                                Text(race.name)
                                    .font(.custom("Formula1-Display-Bold", size: 20.0))
                                    .foregroundColor(Color(red: 207/255, green: 46/255, blue: 30/255))
                            }
                            Text(formatDate(race.date))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.top, 20)

                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack(spacing:0) {
                            Text("\(currentYear)")
                                .foregroundColor(Color(red: 207/255, green: 46/255, blue: 30/255))
                                .font(.custom("Formula1-Display-Wide", size: 30.0))

                            Text("RACE WEEKENDS")
                                .font(.custom("Formula1-Display-Bold", size: 30.0))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 50)
                    }
                }
            }
        }
    }
}

/*
 font postscript names
 Formula1-Display-Bold
 Formula1-Display-Regular
 Formula1-Display-Wide
 
 f1 color red:
 Color(red: 207/255, green: 46/255, blue: 30/255)
 
 f1 color "black":
 Color(red: 21/255, green: 21/255, blue: 29/255)
 
 f1 color "tyre yellow":
 Color(red: 247/255, green: 214/255, blue: 77/255)
 
 f1 color "tyre blue":
 Color(red: 72/255, green: 160/255, blue: 237/255)

 */

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.timeZone = .current // convert UTC to their own time zone
    return formatter.string(from:date)
}


#Preview {
    ContentView()
}
