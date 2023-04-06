//
//  ActionType.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 4/27/21.
//

import Foundation
import SwiftUI


// Data Model for ActionType
    
struct ActionType {

    let typeID: Int
    let description: String
    
    init(typeID: Int, description: String) {
            
            self.typeID = typeID
            self.description = description
            
        }
}

