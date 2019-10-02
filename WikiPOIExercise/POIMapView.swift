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




//-----------------------------------------------------------------------
//
// Map to display Wiki POIs and manage when POI (annotation)  is selected
//
//
//-----------------------------------------------------------------------

struct POIMapView : UIViewRepresentable {

class Coordinator: NSObject, MKMapViewDelegate {

    @Binding var selectedWikiPOI: WikiPOI?

    init(selectedWikiPOI: Binding<WikiPOI?>) {
        _selectedWikiPOI = selectedWikiPOI
    }

    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
        guard let wikiPOI = view.annotation as? WikiPOI else {
            return
        }
        wikiPOI.action?()
        selectedWikiPOI = wikiPOI
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard (view.annotation as? WikiPOI) != nil else {
            return
        }
        selectedWikiPOI = nil
    }
    
    
    
    //-----------------------------------------------------------------------
    //
    // Display route from user location to selected POI
    
    
    //-----------------------------------------------------------------------

    
    func routeToWikiPOI(_ view: MKMapView, selectedWikiPOI: WikiPOI) {
        
        
         let lahtocoordinate = CLLocationCoordinate2D(latitude: 60.1604818, longitude: 24.8715087)
        
        
        let request = MKDirections.Request()
                
                
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: lahtocoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedWikiPOI.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate {response, error in
                
            guard let unwrappedResponse = response else { return }

            if (unwrappedResponse.routes.count > 0) {
                view.addOverlay(unwrappedResponse.routes[0].polyline)
                var region = unwrappedResponse.routes[0].polyline.boundingMapRect
                
                //Map rectannle somwwhat bigger that route fits nicely on view
                
                let wPadding = region.size.width * 0.25
                let hPadding = region.size.height * 0.25

                //Add padding to the region
                region.size.width += wPadding
                region.size.height += hPadding

                //Center the region on the line
                region.origin.x -= wPadding / 2
                region.origin.y -= hPadding / 2
                                          
                view.setVisibleMapRect(region, animated: true)
            
            }
        
        }
    }
    
    //-----------------------------------------------------------------------
    // Renderer for route, eg color line thickness etc are set here
    //-----------------------------------------------------------------------

    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .blue
            polylineRenderer.lineWidth = 2
            return polylineRenderer
        }
        return nil
    }
    
} //Coordinator

    
    
    
    
    @Binding var wikiPOIs: [WikiPOI]
    @Binding var selectedWikiPOI: WikiPOI?

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedWikiPOI: $selectedWikiPOI)
    }

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ view: MKMapView, context: Context) {

        
        //TODO: Vaihda userin lokaatioon
        // STAATTISESTI ABOUT LAUTTASAARI
        let lahtocoordinate = CLLocationCoordinate2D(latitude: 60.2000, longitude: 24.850000)

       
        //IF POI is selected, center map on that and draw route
        if selectedWikiPOI != nil {
         
            //Display route
            context.coordinator.routeToWikiPOI(view, selectedWikiPOI: selectedWikiPOI!)
            
        }
    
            //Else, center map on user location
            else {
        
                //TODO: Hae käyttäjän koordinaatit
            
                 // STAATTISESTI ABOUT LAUTTASAARI
                let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                let region = MKCoordinateRegion(center: lahtocoordinate, span: span)
                view.setRegion(region, animated: true)
                        
        }
        
        //View WikiPOIs over map
        
        view.removeAnnotations(view.annotations)
        view.addAnnotations(wikiPOIs)
        if let selectedWikiPOI = selectedWikiPOI {
            view.selectAnnotation(selectedWikiPOI, animated: false)
        }

    }
}

    

