//
//  ContentView.swift
//  WikiPOIExercise
//
//  Created by Ari Peltoniemi on 30.9.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation


struct ContentView: View {
    
  

   
    @State var wikiPOIs: [WikiPOI] = WikiPOIData()
        
        /*
        [
        WikiPOI(coordinate: CLLocationCoordinate2D(latitude: 60.2,
                                                  longitude: 24.8),
               title: "WikiPOI Täällä",
               subtitle: "Big Smoke",
               action: { print("Hey mate!") } ),

        WikiPOI(coordinate: CLLocationCoordinate2D(latitude: 60.3,
                                                  longitude: 24.9),
               title: "WikiPOI2 ",
               subtitle: "Big Smoke",
               action: { print("Hey mate!") } ),


    ]
 
 */
    
    @State var selectedWikiPOI: WikiPOI?
    
    var body: some View {
        
        ZStack {

            //Display full screen map with wiki POIs as annotations
            POIMapView(wikiPOIs: $wikiPOIs, selectedWikiPOI: $selectedWikiPOI)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.bottom)
      
            VStack {
                Spacer()
                
                if selectedWikiPOI != nil {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .frame(width: 400.0, height: 200.0, alignment: .bottom)
                            .padding(.bottom, -40)
                        Text(String(selectedWikiPOI?.title ?? "TODO Localization"))
                            
                    }
                    
                }
                
            }
        
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        ContentView()
    }
}
