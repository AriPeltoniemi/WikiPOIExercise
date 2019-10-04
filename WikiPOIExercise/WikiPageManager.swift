//
//  WikiPageManager.swift
//  WikiPOIExercise
//
//  Created by Ari Peltoniemi on 3.10.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Combine


//Struc for page data from WIKI API

struct Page:   Decodable {
    let pageid: Int
    let title: String
    let description: String
}




class WikiPageManager : ObservableObject {
    var objectWillChange = PassthroughSubject<WikiPageManager, Never>()

    
    //For storing & decoding wiki API returned page data
    
    @Published var page: Page? {
    
          didSet {
              objectWillChange.send(self)
          }
      }
    
    init() {
        guard let url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&prop=info%7Cdescription%7Cimages&pageids=537137&format=json") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            //Clean return JSON to be JSONDecoder compatible. (Eg remove chancing  numeric key. Decoder needs key names defined in structs)
            //Yes, it s a hack for now to get page data without fighting wiht some other decoding means
            //TODO: Do nicer solution
            let dataString = String(data: data, encoding: .utf8)
            let range = dataString!.range(of: "{\"pageid")
            var riisuttu = dataString![range!.lowerBound..<dataString!.endIndex]
            riisuttu.removeLast()
            riisuttu.removeLast()
            riisuttu.removeLast()
            
            //Decode page
            
            let page = try! JSONDecoder().decode(Page.self, from: riisuttu.data(using: .utf8)!)
            
            print(page)
            
            DispatchQueue.main.async {
                self.page = page
                
            }
        }.resume()
    }

}
