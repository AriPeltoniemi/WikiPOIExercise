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
import Combine



//Used to pass user location on different app components
class UserWhereAbouts : NSObject, ObservableObject {
    
  //defaults to front of Helsinki rautatieasema
    var userCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 60.1699888, longitude: 24.9440547)
    var userLocationFound: Bool = false
}



//-----------------------------------------------------------------------
//
// Map to display Wiki POIs and manage when POI (annotation)  is selected
//
//
//-----------------------------------------------------------------------

struct POIMapView : UIViewRepresentable {

    
class Coordinator: NSObject, MKMapViewDelegate {

    @Binding var selectedWikiPOI: WikiPOI?
    @Binding var userWhereAbouts: UserWhereAbouts?
    
    var found: Bool = false

    let locationManager =  CLLocationManager()
       

    init(selectedWikiPOI: Binding<WikiPOI?>, userWhereAbouts: Binding<UserWhereAbouts?>) {
        _selectedWikiPOI = selectedWikiPOI
        _userWhereAbouts = userWhereAbouts
    }

    
    //Her is the catch for application. This func is called when user selects POI = annotation from map. It sets the observed selectedWikiPOI which trigget the main view update. When it founds selected POI, it displays card for it
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
        guard let wikiPOI = view.annotation as? WikiPOI else {
            return
        }
        selectedWikiPOI = wikiPOI
              
    }

    
    //User unselects the POI
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard (view.annotation as? WikiPOI) != nil else {
            return
        }
        selectedWikiPOI = nil
        for poll in mapView.overlays {
            mapView.removeOverlay(poll)
        }
    }
    
    
    //Here we start location fetching.
    
    func mapViewDidFinishLoadingMap(_ view: MKMapView) {
        
        //Display user location on map
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 20.0
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
       
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        view.showsUserLocation = true

    }
   
    //User location updates
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
     
        
        if found == false {
            let userWhere = UserWhereAbouts()
            userWhere.userCoordinates  = userLocation.coordinate
            userWhere.userLocationFound = true
            userWhereAbouts = userWhere
            
            found = true
        
            //TODO: IF this would be real app, I would add tracking, eg when user moves we would fetch new WIKI POIs. For exersice we take user location just once
            locationManager.stopUpdatingLocation()
          
        }
    }
    
   
    
    
    //-----------------------------------------------------------------------
    //
    // Display route from user location to selected POI
    
    //-----------------------------------------------------------------------

    
  //  func routeToWikiPOI(_ view: MKMapView, selectedWikiPOI: WikiPOI) {
    
    func routeToWikiPOI(_ view: MKMapView, fromCoordinates: CLLocationCoordinate2D, toCoordinates: CLLocationCoordinate2D) {
      
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: fromCoordinates, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: toCoordinates, addressDictionary: nil))
          
        
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate {response, error in
                
            guard let unwrappedResponse = response else { return }

            //First remove old route
            for poll in view.overlays {
                           view.removeOverlay(poll)
                       }
            //Then add new
            if (unwrappedResponse.routes.count > 0) {
                view.addOverlay(unwrappedResponse.routes[0].polyline)
                var region = unwrappedResponse.routes[0].polyline.boundingMapRect
                
                //Map area somewhat bigger that route fits nicely on view
                
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

    
    //--------------------------------------------------------------------

    // POIMapView as SwiftUI view startshere
    
    
    //--------------------------------------------------------------------

    
    @ObservedObject var wikiAPIManager: WikiAPIManager
    @Binding var wikiPOIs: [WikiPOI]
    @Binding var selectedWikiPOI: WikiPOI?
    @Binding var userWhereAbouts: UserWhereAbouts?
  
    
    var POIsFetched: Bool = false
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedWikiPOI: $selectedWikiPOI, userWhereAbouts: $userWhereAbouts)
    }
    
 
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ view: MKMapView, context: Context) {

        
        if userWhereAbouts != nil && userWhereAbouts?.userLocationFound == true && wikiAPIManager.dataFetched == false {
            
            //When the user location is found, we pass coordinates to API manager and make it fetch data
            wikiAPIManager.fetch(userWhereAbouts: userWhereAbouts!)
        }

        if userWhereAbouts != nil && selectedWikiPOI == nil {
        
            //We have user location but no POI selected --> we center map on user coordinates
            let span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
            let region = MKCoordinateRegion(center: userWhereAbouts!.userCoordinates, span: span)
            view.setRegion(region, animated: true)
            
        }
       
        //IF POI is selected, center map on that and draw route
        if userWhereAbouts != nil && selectedWikiPOI != nil {
         
            //We have user location AND selected POI -->Display route
            context.coordinator.routeToWikiPOI(view, fromCoordinates:  userWhereAbouts!.userCoordinates,  toCoordinates:  selectedWikiPOI!.coordinate)
            
        }
    
        
        //View WikiPOIs and selected one on map
        
        view.addAnnotations(wikiPOIs)
        
       // print(wikiPOIs)
        if let selectedWikiPOI = selectedWikiPOI {
            view.selectAnnotation(selectedWikiPOI, animated: true)
        }

    }
}

    

