//
//  ContentView.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 3/21/21.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    
    
    @EnvironmentObject var session: SessionStore
    
    func getUser() {
        session.listen()
    }
    
    var body: some View { 
        
        VStack {
            
            
            // If logged in, show MainView()
            // If not, show LoginView()
            
            Group {
                if (session.session != nil) {
                    MainView()
                    
                } else {
                    LoginView()
                    
                }
            }
            
            // When the view is generated, run getUser
            .onAppear(perform: getUser)
            
        }
        
    }
}


// I now created a MainView to host the TabView.
// I figured I might need to do this in order to know when to
// show a LoginView vs. the MainView when they are authenticated
struct MainView: View {
    
    // Previously, I had the Add to Map open in a "sheet".  Now, I have it navigating to its own view page.
    // State variable for when to show the sheet to Add to Map
    // @State var showSheet = false
    
    
    
    var body: some View {
        
        // Return the view inside a NavigationView.
        return NavigationView {
            
            // Need a tab view for bottom navigation
            TabView {
                
                // Placeholder for the news screen
                NewsView()
                    .padding()
                    
                    // News button
                    .tabItem {
                        Image(systemName: "newspaper")
                        Text("News")
                    }
                    .tag(1)
                
                
                // MapView -- Google Maps rendering screen
                
                VStack {
                    
                    
                    // I want the plus sign icon to be placed on the far right side.  I'll do this by adding
                    // a spacer before the image button
                    HStack {
                        
                        
                        VStack {
                            
                            // Heading
                            Text("Map")
                                .fontWeight(.bold)
                                .frame(alignment: .leading)
                                .font(.largeTitle)
                            
                            
                            HStack {
                                
                                // Create a button with an icon and text.  Link to the AddToMapView.
                                NavigationLink(destination: AddToMapView()) {
                                    // Left side
                                    Text("Add to Map!")
                                        .frame(alignment: .trailing)
                                    
                                    // Right side -- contains icon
                                    Image("plusSignButton")
                                        .scaledToFit()
                                        .frame(width: 48, height: 48, alignment: .trailing)
                                }
                                
                            }
                            .frame( height: 55, alignment: .trailing)
                            .padding()
                            
                        }
                        
                    }
                    
                    
                    
                    
                    // Next, in the VStack, we want to show the MapView
                    
                    MapView()
                        .frame(maxHeight: .infinity)

                    
                }
                

                // Map button
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(2)
            }
            
            
            
        }
        
        // Set navigation bar options
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
}





/*
 Preview the ContentView()
 */
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
