//
//  BlueMarbleApp.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 3/21/21.
//

import SwiftUI
import GoogleMaps
import Firebase

@main
struct BlueMarbleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Initialize Firebase
    init() {
        FirebaseApp.configure()
    }
    
    // Start by showing the ContentView
    var body: some Scene {
        WindowGroup {
            //ContentView()
            
            // This is how I could start up the Session without an SceneDelegate
            ContentView().environmentObject(SessionStore())
        }
    }
}


// This will grab our Google Maps API from GoogleMaps.plist. 
private var apiKey: String {
    get {
        
        guard let filePath = Bundle.main.path(forResource: "GoogleMaps", ofType: "plist") else {
            fatalError("Couldn't find file 'GoogleMaps.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GoogleMaps.plist'.")
        }
        return value
    }
}


// AppDelegate when we don't have an AppDelegate file in our project.
class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Set up Google Maps
        GMSServices.provideAPIKey(apiKey)
        
        return true
    }
}
