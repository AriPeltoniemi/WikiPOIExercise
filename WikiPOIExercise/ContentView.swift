//
//  ContentView.swift
//  WikiPOIExercise
//
//  Created by Ari Peltoniemi on 30.9.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//

import SwiftUI

/*
struct WikiPOI: Decodable {
       let pageid: String
       let title: String
       let lat: Double
       let lon: Double
   }
*/

struct ContentView: View {
    
    @State var wikiPOIs: [WikiPOI] = [
        WikiPOI(pageid: "1234", title: "otsikko1", lat: 60.200, lon: 24.800),
        WikiPOI(pageid: "1222", title: "otsikko3", lat: 60.250, lon: 24.750),
        WikiPOI(pageid: "4567", title: "otsikko2", lat: 60.300, lon: 24.700)
    ]

   
    var body: some View {
        
        ZStack {

            //Display full screen map with wiki POIs as annotations
            MapView(wikiPOIs: $wikiPOIs)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        ContentView()
    }
}
