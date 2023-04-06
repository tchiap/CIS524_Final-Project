//
// This was an example I pulled down.
//  NOT in use for this project.  Was using for reference.
//

import SwiftUI


struct AppView : View {
    @EnvironmentObject var session: SessionStore
    //@ObjectBinding var recipeStore = RecipeStore()
    @State var query = ""
    
    
    /*
    func fetchRecipes () {
        print("Fetching recipes")
        recipeStore.fetch(userId: self.session.session!.uid)
    }
 */

    
    var body: some View {
        
        
        return NavigationView {
            
            List {
                Section() {
                    NavigationLink(destination: Text("Hello")) {
                        Text("Following").fontWeight(.semibold).padding(.vertical)
                    }
                    NavigationLink(destination: Text("Hello")) {
                        Text("Followers").fontWeight(.semibold).padding(.vertical)
                    }
                }
            }
        }
    }
}
                

            

struct PresentationLink : View {
    
    @State var isPresented = false
    
    var body: some View {
        
        NavigationView {
            List {
                Button(action: { self.isPresented.toggle() })
                { Text("Source View")}
                
            }.sheet(isPresented: $isPresented, content: { Text("Destination View") })
        }
    }
    
}
