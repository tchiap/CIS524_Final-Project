//
//  AddToMapView.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 4/26/21.
//

import SwiftUI
import Combine
import Firebase
import GeoFire
import UIKit
import MobileCoreServices
import Foundation
import SwiftUI
import FirebaseStorage


struct AddToMapView: View {
    
    // From the GoogleMapView, we need to pass in the showSheet parameter in order to know what the
    // visibility status is of the sheet
    //@Binding var showSheet: Bool
    
    // State variables for description and the selected type of action
    @State private var description = ""
    @State private var selectedType = "Planted Tree"
    
    //@StateObject var actionTypeViewModel = ActionTypeViewModel()
    
    // We need access to the location manager to get the user's location for this form
    @ObservedObject var locationManager = LocationManager()
    
    // Grab the session so we can use it when needed
    @EnvironmentObject var session: SessionStore
    
    // This state variable controls when the built-in image picker control is shown
    @State var showCaptureImageView = false
    
    // We need to generate a unique filename for when we upload photos for a geotag.  We'll write this
    // filename in both Firebase and the Storage
    @State var filename  = NSUUID().uuidString + ".jpg"
    
    // A flag to track when the geotag is written.
    @State var isGeotagWritten = false
    
    // Instead of a boring background, I rather have something much more colorful, so I'll create a green-blue gradient
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.green, Color.blue]),
        startPoint: .top, endPoint: .bottom)
    
    

    @StateObject var actionTypeViewModel = ActionTypeViewModel()

    // Action type list
    var actionList =
        [
            "Planted Tree",
            "Planted Pollinating Plants",
            "Bought an Electric Vehicle",
            "Replace Lighting with LEDs"
        ]
    

    var body: some View {
        
        
        ZStack {
            
            // Set gradient background
            backgroundGradient
                .ignoresSafeArea()
            
            
            
            // Get coordinates from location manager.  We'll need this to write into Firebase.
            
            let myLocation = locationManager.lastKnownLocation
            
            
            ScrollView {
                
                // Define a Vstack to show these elements, since we want all of our UI elements in the sheet
                // to be shown in a vertical format
                VStack {
                    
                    
                    Spacer()
                    
                    
                    // Start type of action section
                    
                    Section {
                        
                        Text("Type of Action:")
                            .font(.subheadline).fontWeight(.thin).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                        
                        // For each data in the actionList array, we'll want to show it in our picker.
                        // actionList
                        
                        Picker(selection: $selectedType, label: Text("Choose Type...")) {
                            ForEach(actionList, id: \.self) {
                                Text($0)
                            }
                        }
                                                
                    }
                    
                    
                    // Start description section
                    Section {
                        Text("Description:")
                            .font(.subheadline).fontWeight(.thin).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                        
                        // A text field for the user to type in a description
                        TextField("Describe what you did for the environment!", text: $description)
                            .padding()
                            .cornerRadius(4.0)
                            .padding()
                            .border(Color("separatorColor"))
                            .background(Color.white)
                            .padding()
                    }
                    
                    // Get current GPS location latitude and longitude
                    let latitude = myLocation?.coordinate.latitude
                    let longitude = myLocation?.coordinate.longitude
                    
                    
                    
                    // https://www.javaer101.com/en/article/40758113.html
                    
                    // I want a link to let the user choose and photo.  However, the image picker view should only show
                    // when the link is clicked (using state variable).
                    Button(action: {
                        self.showCaptureImageView.toggle()
                    }) {
                        Text("Choose Photo")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // When the Choose Photo link is clicked, now we should show the image picker view
                    // Note:  imagePicker() is defined below.
                    if(self.showCaptureImageView) {
                        imagePicker(shown: self.$showCaptureImageView, filename: $filename)
                        
                        Spacer()
                        
                    }
                    
                    
                    // Add button to write geotag
                    Button(action: {
                        
                        // Let's make the call to the createGeotag function in order to commit a geotag to firebase!
                        // (uid holds the authenticated user's uid)
                        createGeotag(uid: session.session!.uid, actionType: selectedType, lat: latitude ?? 0.0, lng: longitude ?? 0.0, description: description, file: filename)
                        
                        // Set flag.  This controls when the app knows when to navigate back to the main part of the app.
                        isGeotagWritten = true
                        
                        
                        
                    }) {
                        
                        // "Add" button
                        Text("Add!")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.green)
                                    .frame(minWidth: 300, alignment: .center)
                            )
                        
                    }
                    
                    // I feel like this is kind of a "hacky" way I got the app to navigate back to ContentView().
                    // When the isGeotagWritten flag is true, go back to ContentView(), even though it's not attached
                    // to a button.  I couldn't get button "actions" to work with a NavigationLink, so I created a dummy button
                    // inside a NavigationLink with an isActive argument to get it working the way I wanted.

                    NavigationLink(destination: ContentView(), isActive: $isGeotagWritten) {
                        
                        Text("")
                            .opacity(0.0)
                        
                    }
                    .padding()
                    
                    
                }
                .navigationBarTitle("Add to Map")
                
            }
            .onAppear() {
                
                // When this view appears, we'll go to the news view model to fetch the
                // Firebase data
                self.actionTypeViewModel.fetchData()
                
            }
        }
        
    }
    
    // A function I created that takes in a uid (the user's ID), an action type, a latitude and longitude, and a description
    // This will write that data into Firebase.
    func createGeotag(uid: String, actionType: String, lat: Double, lng: Double, description: String, file: String) {
        
        // Create a coordinate from the latitude and longitude
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        // Calculate the geohash using GeoFire, passing in the location (coordinate)
        let geohash = GFUtils.geoHash(forLocation: location)
        
        // Time to set up Firebase for writing
        let db = Firestore.firestore()
        
        // Setting this DocumentReference to nil.  The reason to do this is for Firebase to give the geotag document its
        // own name for the document.
        var ref: DocumentReference? = nil
        
        // Construct and write what we're writing into Firebase "geotags" collection.
        ref = db.collection("geotags").addDocument(data: [
            "uid": uid,
            "actionType": actionType,
            "lat": lat,
            "lng": lng,
            "geohash": geohash,
            "description": description,
            "imageFilename" : file,
            "createdTs" : FieldValue.serverTimestamp()
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        
        
    }
}




struct AddToMapView_Previews: PreviewProvider {
    static var previews: some View {
        AddToMapView()
    }
}




// imagePicker control
// Got an example from here:  https://gist.github.com/thomas-sivilay/f1a46809859f59c342cb3973d8598559
// and some other online resources.

struct imagePicker : UIViewControllerRepresentable{
    
    func makeCoordinator() -> imagePicker.Coordinator {
        return imagePicker.Coordinator(parent1: self, filename1: filename)
    }
    
    @Binding var shown : Bool
    @Binding var filename : String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) ->
    UIImagePickerController {
        
        // Lets get the image picker controller ready
        let imagepic = UIImagePickerController()
        imagepic.sourceType = .photoLibrary
        imagepic.delegate = context.coordinator
        
        return imagepic
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {
        
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent : imagePicker!
        var filename: String
        
        init(parent1: imagePicker, filename1: String){
            parent = parent1
            filename = filename1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.shown.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // Hold the image
            let image = info[.originalImage] as! UIImage
            
            let storage = Storage.storage()
            //let storingimage = storage.reference().child("temp.jpg")
            let storingimage = storage.reference().child(filename)
            
            
            // Take uploaded picture and have as a jpeg so we can store it
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storingimage.putData(image.jpegData(compressionQuality: 0.35)!, metadata: metadata)
            {(response,err) in
                if(err != nil){
                    print(err?.localizedDescription)
                }
                else{
                    
                    // You can also access to download URL after upload.
                    storingimage.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            
                            return
                        }

                    }
                }
            }
        }
    }
}
