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

// creating a race model
struct Race: Identifiable, Codable {
    let id = UUID() // unique identifier for each race
    let name: String // name of race, eg. Monaco Grand Prix
    let track: String// location of race, eg. Circuit de Monaco
    let date: Date // date of race start time in UTC
    var laps: Int = 0// number of laps
    var circuitLength: Float = 0// length of circuit, eg. 3.337 km
    var attending: Bool = false // if the user will be attending or not (for notification purposes)
    
    enum CodingKeys: String, CodingKey {
        case name = "meeting_name"
        case track = "circuit_short_name"
        case date = "date_start"
    }
}

struct ContentView: View {
    @StateObject private var fetcher = RaceFetcher()
    var currentYear: String {
        let year = Calendar.current.component(.year, from: Date())
        return String(year)
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 21/255, green: 21/255, blue: 29/255).ignoresSafeArea()
                List($fetcher.races){ $race in
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
            .onAppear {
                fetcher.fetchRaces()
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
