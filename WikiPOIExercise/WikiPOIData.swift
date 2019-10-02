//
//  WikiPOIData.swift
//  WikiPOIExercise
//
//  Created by Ari Peltoniemi on 30.9.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation


/*
struct WikiPOI: Decodable {
    let pageid: String
    let title: String
    let lat: Double
    let lon: Double
}
*/



//-----------------------------------------------------------------------

//A class to contain Wiki POI data.

//-----------------------------------------------------------------------


class WikiPOI: NSObject, MKAnnotation {
   
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let action: (() -> Void)?
  //  let pageID: String?
    
    init(coordinate: CLLocationCoordinate2D,
            title: String? = nil,
            subtitle: String? = nil,
            action: (() -> Void)? = nil) {
           self.coordinate = coordinate
           self.title = title
           self.subtitle = subtitle
           self.action = action
       }
}


class WikiPOIData {

    

 var wikiPOIs: [WikiPOI] = [
     WikiPOI(coordinate: CLLocationCoordinate2D(latitude: 60.2,
                                               longitude: 24.8),
            title: "WikiPOI Täällä",
            subtitle: " ",
            action: { print("WIkiPOI") } ),

     WikiPOI(coordinate: CLLocationCoordinate2D(latitude: 60.3,
                                               longitude: 24.9),
            title: "WikiPOI2 ",
            subtitle: " ",
            action: { print("WikiPOI2") } ),


    ]
    
    func init() {
    
        return wikiPOIs
    }
}
