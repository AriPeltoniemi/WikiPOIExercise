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

struct WikiImage: Decodable {
    let ns: Int?
    let title: String?
}

struct Page:   Decodable {
    let pageid: Int
    let title: String
    let description: String?
    let images: [WikiImage]?
    init() {
        pageid = 0
        title = ""
        description = ""
        images = []
    }
}


class WikiPageManager : ObservableObject {
    var objectWillChange = PassthroughSubject<WikiPageManager, Never>()

    
    @Published private(set) var page = Page() {
          didSet {
              objectWillChange.send(self)
          }
      }
    
    var pageFetched: Bool = false
  
    
    //--------------------------------------------
    //Fetch wiki page data as JSON from wiki API
    //--------------------------------------------

    
    func fetchPage (pageid: Int) {
    
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&prop=info%7Cdescription%7Cimages&pageids=" + String(pageid) + "&format=json"
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {
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
        
            DispatchQueue.main.async {
                self.page = page
                self.pageFetched = true
                //print(page)
            }
        }.resume()
    }

}
