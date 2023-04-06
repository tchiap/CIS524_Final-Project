//
//  GoogleMapsView.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 3/24/21.
//

import SwiftUI
import UIKit
import GoogleMaps


//

//
//  https://www.andyibanez.com/posts/using-corelocation-with-swiftui/
//


struct MapView: UIViewRepresentable {
    
    // State object to store the geotag View Model
    @StateObject private var geotagViewModel = GeotagViewModel()
    
    
    // Listen to changes on the locationManager
    @ObservedObject var locationManager = LocationManager()
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        // Just default the camera to anywhere - this will be overwritten when GPS coordinates received.
        let camera = GMSCameraPosition.camera(withLatitude: 42.643890, longitude: -87.85278, zoom: 13.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.setMinZoom(14, maxZoom: 20)
        
        // Updating settings to mapView
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        mapView.isIndoorEnabled = false
        
        //let rect = CGRect(x:10, y:10, width: 100, height: 100)
        //let myView = UIView(frame: rect)
        //mapView.bringSubviewToFront(myView)
        
        
        // Return the UIViewRepresentable
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Self.Context) {
        
        // When the locationManager publishes updates, respond to them
        if let myLocation = locationManager.lastKnownLocation {
            
            //mapView.animate(toLocation: myLocation.coordinate)
            
            // Some debug info
            print("User location: \(myLocation)")
            
            geotagViewModel.geoQuery(centerLatitude: myLocation.coordinate.latitude, centerLongitude: myLocation.coordinate.longitude)
            
        }
        
        // Get geotags
        let tags = geotagViewModel.geotags
        
        // Custom Google Maps markers
        // https://stackoverflow.com/questions/54211322/swift-show-image-in-custom-gmsmarker
        
        
        // For each tag, we want to show it on the map
        for tag in tags {
            let marker = GMSMarker()
            
            
            // Depending on the action type, I want to show a different marker from Assets
            if (tag.actionType == "Planted Tree") {
                marker.icon = UIImage(named: "iconTree")
            }
            else if (tag.actionType == "Planted Pollinating Plants") {
                marker.icon = UIImage(named: "iconFlower")
            }
            else if (tag.actionType == "Bought an Electric Vehicle") {
                marker.icon = UIImage(named: "iconElectricVehicle")
            }
            else if (tag.actionType == "Replace Lighting with LEDs") {
                marker.icon = UIImage(named: "iconLED")
            }
            else {
                marker.icon = UIImage(named: "leaf")
            }
            
            
            
            
            // Set position of the marker from the geotag latitude and longitude
            marker.position = CLLocationCoordinate2D(latitude: tag.latitude, longitude: tag.longitude)
            
            marker.map = mapView
            
            //comment this line if you don't wish to put a callout bubble
            //mapView.selectedMarker = marker

        }
            
        
    }
}

