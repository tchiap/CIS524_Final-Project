//
//  NewsViewModel.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 4/18/21.
//




import Foundation
import FirebaseFirestore


/*
 This is a class that connects and fetches our Firestore 'news' document
 that I create in the Firebase console.
 */
class NewsViewModel : ObservableObject {
    
    // newsItems state variable - an array of News objects
    @Published var newsItems = [News]()
    
    // Connect to FireStore instance
    private var db = Firestore.firestore()
    
    // fetchData function.  The data returned is the News object
    func fetchData() {
        
        // Get a snapshot of our news collection
        db.collection("news").addSnapshotListener { (querySnapshot, error ) in
            
            // Unlike an if statement, guard statements only run if the conditions are not met.
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            
            // Map to News
            self.newsItems = documents.map { (queryDocumentSnapshot) -> News in
                
                // Get dictionary data, store in data variable.
                let data = queryDocumentSnapshot.data()
                
                // Read the various parts into local variables.
                // We need to type cast each.  If there a nil value, we need to return a default value for each variable
                
                let storyID = data["storyID"] as? Int ?? 0
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let url = data["url"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                
                // Finally, return the News object
                return News(storyID: storyID, title: title, description: description, url: url, imageURL: imageURL)
                
            }
        }
        
    }
    
}
