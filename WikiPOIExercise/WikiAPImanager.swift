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
import Combine



//-----------------------------------------------------------------------

//Nested structs to decode data from wiki API with JSONDecoder

//-----------------------------------------------------------------------


struct WikiFullResult : Decodable {
    var query: Geosearch
}

struct Geosearch : Decodable {
    var geosearch: [PageData]
}

struct PageData: Decodable {
    var title: String
    var pageid: Int
    var lat: Double
    var lon: Double
}





//-----------------------------------------------------------------------

//A class to contain Wiki POI data as MKAnnotation to be displayed on map

//-----------------------------------------------------------------------


class WikiPOI: NSObject, MKAnnotation, ObservableObject  {
   
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    @Published var pageID: Int?
   // let action: (() -> Void)?
    
    init(coordinate: CLLocationCoordinate2D,
            title: String? = nil,
            subtitle: String? = nil,
            pageID: Int? = 0,
           action: (() -> Void)? = nil) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
            self.pageID = pageID
           // self.action = action
       }
}

class WikiAPIManager : ObservableObject {
    var objectWillChange = PassthroughSubject<WikiAPIManager, Never>()
    
    
    @Published var wikiPOIs: [WikiPOI] = [] {
    
          didSet {
              objectWillChange.send(self)
          }
      }
    
    var dataFetched: Bool = false
    
    //@Binding var userWhereAbouts: UserWhereAbouts?
    
    
    //For storing & decoding wiki API returned data
    var wikiFullResult = WikiFullResult(query: Geosearch(geosearch: []) )

    
    func fetch(userWhereAbouts: UserWhereAbouts) {
        
        print("fetching")
        print(userWhereAbouts.userCoordinates.latitude)
    
        if dataFetched == true {
            
            return

        } else {
                dataFetched = true
        }
    

        
        //Create wiki API url based on user location to fetch POIs from wiki API
        let latitude = String(userWhereAbouts.userCoordinates.latitude)
        let longitude = String(userWhereAbouts.userCoordinates.longitude)
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&list=geosearch&gsradius=10000&gscoord=" + latitude + "%7C" + longitude + "&gslimit=50&format=json"
        
        
        guard let url = URL(string: urlString) else {
                   return
               }
        
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            
            //Mihtahan sielta saadaan?
            //let dataString = String(data: data, encoding: .utf8)
            //print(dataString)
            
            
            
            let wikiFullResult = try! JSONDecoder().decode(WikiFullResult.self, from: data)
            
            DispatchQueue.main.async {
                self.wikiFullResult = wikiFullResult
                
                //Convert struct JSON to wikiPOI classes
                for PageData in wikiFullResult.query.geosearch {
                    
                    let wikiPOI = WikiPOI(coordinate: CLLocationCoordinate2D(latitude: PageData.lat, longitude: PageData.lon), title: PageData.title , subtitle: "", pageID: PageData.pageid)
                    self.wikiPOIs.append(wikiPOI)
                }
            
            }
        }.resume()
    }
}

