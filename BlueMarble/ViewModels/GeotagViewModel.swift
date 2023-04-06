//
//  GeotagViewModel.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 4/17/21.
//


import Foundation
import FirebaseFirestore
import GoogleMaps
import FirebaseCore
import FirebaseFirestore
import GeoFire
import CoreLocation


//  http://geohash.org/  geo hash generator -- used this before I was using GFUtils to generate it for me
//  http://www.simpleimageresizer.com/upload  - image resizer
//  https://uxwing.com - icons


//
class GeotagViewModel : ObservableObject {
    
    // geotag state variable, an array of Geotag objects
    @Published var geotags = [Geotag]()
    
    // Connect to FireStore instance
    private var db = Firestore.firestore()
    
    
    
    // Code snippet for storing a geohash to Firebase (unused right now)
    func storeGeoHash() {

        let latitude = 42.6438
        let longitude = -87.8527
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let hash = GFUtils.geoHash(forLocation: location)

        // Add the hash and the lat/lng to the document.
        // Hashes will be used for queries and the lat/lng for distance comparisons.
        let documentData: [String: Any] = [
            "geohash": hash,
            "lat": latitude,
            "lng": longitude
        ]
    
        //latitude: 42.6438, longitude: -87.8527
        
    }
    

    // This queries the marker data out of Firebase
    func geoQuery(centerLatitude: Double, centerLongitude: Double) {

        // We need to set a center coordinate, found by the latitude and longitude we got from the person's location
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        
        // We need to set a radius from the center to look at markers for.
        let radiusInKilometers: Double = 25
        let radiusInMeters: Double = radiusInKilometers * 1000
        
        
        // Each item in 'bounds' represents a startAt/endAt pair.
        
        // Get query bounds using queryBounds().  We need this to limit our query of markers
        let queryBounds = GFUtils.queryBounds(forLocation: center,  withRadius: radiusInMeters)
        
        let queries = queryBounds.compactMap { (any) -> Query? in
            guard let bound = any as? GFGeoQueryBounds else { return nil }
            
            // Return the geotags with the start and end boundary.
            return db.collection("geotags")
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }
        
        // Get matching documents from Firebase that meet the criteria.
        var matchingDocs = [QueryDocumentSnapshot]()
        
        // Collect all the query results together into a single list
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
            guard let documents = snapshot?.documents else {
                print("Unable to fetch snapshot data. \(String(describing: error))")
                return
            }
            
            // For each document geotag marker, get the latitude and longitude attributes.
            for document in documents {
                let lat = document.data()["lat"] as? Double ?? 0
                let lng = document.data()["lng"] as? Double ?? 0
                let actionType = document.data()["actionType"] as? String ?? ""
                
                // Create a coordinate based on the Firebase document
                let coordinates = CLLocation(latitude: lat, longitude: lng)
                
                // Create a center point coordinate from the user's latitude on longitude
                let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
                
                // Next, calculate the distance between the center point and the Firebase coordinates for this document
                let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                
                //  If the distance between the center point and the user's coordinates is 25 Km or less, then we want to
                //  add the Geotag to the geotags array.
                if distance <= radiusInMeters {
                    matchingDocs.append(document)
                    
                    geotags.append(
                        Geotag(latitude: lat, longitude: lng, actionType: actionType)
                    )
                    
                }
            }
        }
        
        // matchingDocs contains the result. 
        for query in queries {
            query.getDocuments(completion: getDocumentsCompletion)
        }
        
    }
}
