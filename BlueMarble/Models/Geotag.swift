//
//  Geotag.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 4/13/21.
//

import Foundation
import SwiftUI


// Data model for geotag

struct Geotag:  Identifiable {
    
    
    let id = UUID()
    let latitude: Double
    let longitude:  Double
    let actionType: String
    
    // TODO - add image URL for uploaded image & action type
    
    

    
    
}
