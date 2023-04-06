//
//  NewsView.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 4/18/21.
//

import SwiftUI

struct NewsView: View {
    
    @StateObject private var newsViewModel = NewsViewModel()
    
    
    var body: some View {
        
        // I want to make the news list scrollable
        ScrollView {
            
            Text("News Stories")
                .fontWeight(.bold)
                .frame(alignment: .leading)
                .font(.largeTitle)
            
            // Everything will be in a vertical stack
            VStack(spacing: 5) {
                
                // Call the ListView to show.  Give it some padding on the left and right side.
                ListView()
                    .padding(.leading)
                    .padding(.trailing)
                
            }
            .padding(.top) // add a little padding to the top of the stack
        }
        
        .onAppear() {
            
            // When this view appears, we'll go to the news view model to fetch the
            // Firebase data
            self.newsViewModel.fetchData()
            
        }
        
        // Save the newsViewModel to the environment
        .environmentObject(newsViewModel)
        
        
    }
}

// For each document from the news documents in Firebase, we'll need to construct a row.
struct ListView : View {
    
    @EnvironmentObject var newsViewModel: NewsViewModel
    
    var body: some View {
        
        // For each news item, construct a RowView
        ForEach(newsViewModel.newsItems) { i in
            
            // For Sprint 03, I added the imageURL as well to the RowView view
            RowView(storyID: i.storyID, title: i.title, description: i.description, url: i.url, imageURL: i.imageURL)

        }
        
        
    }
    
}

//  RowView will construct the UI to show the parts of the news item.
struct RowView: View {
    
    // Each RowView needs an item name, description, and price.
    let storyID: Int
    let title: String
    let description: String
    let url: String
    let imageURL: String

    
    var body: some View {
        

        
        // HStack to construct row.
        HStack {
            
            VStack {
                
                // Show image form web URL.  Notice that ImageView is defined another class, and not Image()
                ImageView(withURL: imageURL)
                    //.aspectRadio(contentMode: .fit)
                    .frame(width: 100)
            }
            .frame(maxWidth: 110)
            
            
            // Since I want to place a title and description vertically from each other,
            // I'll use a vertical stack
            VStack {
                
                // Show title -- but make it hyperlinkable using the news item URL
                // Make it bold to make it stand out a little more
                Link(destination: URL(string: url)!) {
                    
                    Text(title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Show description
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                
            }
            
        }
        
        // Add a separation line.  When all items are rendered, items will
        // be separated by a line break to help readability.
        Rectangle()
        .frame(height: 1.0, alignment: .bottom)
        .padding(.top)
        .foregroundColor(Color.gray)
        
    }
}


// Show the NewsView preview inside the canvas
struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}


