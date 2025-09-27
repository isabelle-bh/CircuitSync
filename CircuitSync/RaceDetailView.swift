//
//  RaceDetailView.swift
//  CircuitSync
//
//  Created by Isabelle Beaudry Hajji on 2025-09-26.
//

import SwiftUI

struct RaceDetailView: View {
    let race: Race
    
    var body: some View {
        Text(race.name)
            .foregroundColor(Color(red: 207/255, green: 46/255, blue: 30/255))
            .font(.custom("Formula1-Display-Wide", size: 30.0))
            .multilineTextAlignment(.center)
            .padding()
        VStack(alignment: .leading, spacing: 20) {
            Text("Race Date & Time: \(formatDate(race.date))")
            Text("Circuit: \(race.track)")
            Text("No. Of Laps: \(race.laps)")
            Text("Track Length: \(race.circuitLength)km")
            Spacer()
        }
        .padding()
        /*
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(race.name) Details")
                    .foregroundColor(Color(red: 207/255, green: 46/255, blue: 30/255))
                    .font(.custom("Formula1-Display-Wide", size: 20.0))
            }
        }
        */

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

#Preview {
    ContentView()
}
