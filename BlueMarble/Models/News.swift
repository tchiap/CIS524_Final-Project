//
//  News.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 4/18/21.
//


import Foundation
import SwiftUI


// Data Model for News
    
struct News:  Identifiable {

    let id = UUID()
    let storyID: Int
    let title: String
    let description: String
    let url: String
    let imageURL: String
    
    
    
}
