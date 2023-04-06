//
//  ActionTypeViewModel.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 5/8/21.
//

import Foundation
import FirebaseFirestore


class ActionTypeViewModel : ObservableObject {
    
    // newsItems state variable - an array of News objects
    @Published var actionTypes = [ActionType]()
    
    // Connect to FireStore instance
    private var db = Firestore.firestore()
    
    // fetchData function.  The data returned is the News object
    func fetchData() {
        
        // Get a snapshot of our news collection
        db.collection("actionTypes").addSnapshotListener { (querySnapshot, error ) in
            
            // Unlike an if statement, guard statements only run if the conditions are not met.
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            
            // Map to News
            self.actionTypes = documents.map { (queryDocumentSnapshot) -> ActionType in
                
                // Get dictionary data, store in data variable.
                let data = queryDocumentSnapshot.data()
                
                // Read the various parts into local variables.
                // We need to type cast each.  If there a nil value, we need to return a default value for each variable
                
                let typeID = data["typeID"] as? Int ?? 0
                let description = data["description"] as? String ?? ""
                
                // Finally, return the News object
                return ActionType(typeID: typeID, description: description)
                
            }
        }
        
    }
    
}

