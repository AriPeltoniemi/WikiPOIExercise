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
    
  
    
    //For storing user location and triggering action when it changes
    @State var userWhereAbouts: UserWhereAbouts?

    //Selected wiki POI, NOTE: will be set on MapView based on user selections
    @State var selectedWikiPOI: WikiPOI?

    
    //WikiAPImanager fetches POIs from WIKI, we observe it and update app main view when data changes
    @ObservedObject var wikiAPIManager = WikiAPIManager()
    
    
    //----------------------------------------------------
    
    // App main view. Displays map, wiki POIs on that as annotations.
    
    // If some POI is selected, display a sliding card for wiki page info
    
    //----------------------------------------------------
    
    
    var body: some View {

       
        //wikiAPIManager.setCoordinates()
        

        ZStack {

            
            //Display full screen map with wiki POIs as annotations
            //POIMapView(wikiPOIs: $wikiAPIManager.wikiPOIs, selectedWikiPOI: $selectedWikiPOI, userWhereAbouts: $userWhereAbouts)
            
            POIMapView(wikiAPIManager: wikiAPIManager, wikiPOIs: $wikiAPIManager.wikiPOIs, selectedWikiPOI: $selectedWikiPOI, userWhereAbouts: $userWhereAbouts)
            
            
            // POIMapView(wikiPOIs: $wikiAPIManager.wikiPOIs, selectedWikiPOI: $selectedWikiPOI)
                         
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.bottom)
      
            //IF POI is selected, display Wikicard for it
             if selectedWikiPOI != nil {
                
                WikiSlideOverCard (selectedWikiPOI: $selectedWikiPOI)
                                    
            }
            
            if userWhereAbouts == nil {
                Text("Fetching location....")
            }
        }
    }
}
       


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        ContentView()
    }
}
