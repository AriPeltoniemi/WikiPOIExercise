//
//  MapView.swift
//  WikiPOIExercise
//
//  Created by Ari Peltoniemi on 30.9.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//

//
//  MapView.swift
//  SwiftUITest2
//
//  Created by Ari Peltoniemi on 29.9.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation



struct MapView: UIViewRepresentable {
 
    @Binding var wikiPOIs: [WikiPOI]
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
    
        MKMapView()
        
    }

    
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        // STAATTISESTI ABOUT LAUTTASAARI
    
        let coordinate = CLLocationCoordinate2D(latitude: 60.2000, longitude: 24.850000)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        
        //Add annotation for each items on POI list
        
        for wikiPOI in wikiPOIs {
            
            //print(wikiPOI.title)

            let coordinate = CLLocationCoordinate2D(latitude: wikiPOI.lat, longitude: wikiPOI.lon)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = wikiPOI.title
            //annotation.subtitle = "Alaotsikko2"
            view.addAnnotation(annotation)

        }
        
        /*
        
         let annotation = MKPointAnnotation()
         annotation.coordinate = coordinate
         annotation.title = "Title"
         annotation.subtitle = "Alaotsikko"
         view.addAnnotation(annotation)
        
        let coordinate2 = CLLocationCoordinate2D(latitude: 60.3000, longitude: 24.80000)
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = coordinate2
        annotation2.title = "Title2"
       annotation2.subtitle = "Alaotsikko2"
       view.addAnnotation(annotation2)
*/
        
    }
    
}
