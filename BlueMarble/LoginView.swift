//
//  LoginView.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 4/26/21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    // State variables to save email and password
    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false
    
    // Bring in the session, as we'll need to sign in
    @EnvironmentObject var session: SessionStore
    
    // State boolean to see if person is authenticated or not.
    // This will indicate whether or not to move to the main part of the app.
    @State private var isAuthenticated = false
    
    // Sign in function -- got this from:  https://benmcmahen.com/authentication-with-swiftui-and-firebase/
    
    // Local signIn function that calls the Session's sign in.
    // I also have a loading boolean in case I want to animate the "loading".
    func signIn () {
        loading = true
        error = false
        
        // Call the session authentication function call sign in,
        // passing in the email and password.
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            
            if error != nil {
                self.error = true
                
                // There was an error encountered, so make sure the authentication flag is false.
                isAuthenticated = false
            } else {
                
                // Authentication succeeded!  Make sure to update the authentication flag to let navigation know we're ready to move on to the
                // main part of the app.
                self.email = ""
                self.password = ""
                isAuthenticated = true
            }
        }
    }
    
    
    // My old background was pretty boring, so I wanted to change my design to use a gradient instead.
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.purple]),
        startPoint: .top, endPoint: .bottom)
    
    
    
    // Construct the login form
    var body: some View {
        
        NavigationView {
            ZStack {
                
                // Use a gradient background, as defined above
                backgroundGradient
                    .ignoresSafeArea()
                
                // Inside a vertical stack, let's start putting together the form.
                VStack {
                    
                    // Heading
                    Text("Welcome!")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .fontWeight(.light)
                    
                    // TextField to allow user to type in their email
                    TextField("Email",  text: $email)
                        .padding()
                        .cornerRadius(4.0)
                        .border(Color("separatorColor"))
                        .background(Color.white)
                        .padding()
                    
                    // A SecureField to allow user to type in their password
                    SecureField("Password", text: $password)
                        .padding()
                        .cornerRadius(4.0)
                        .border(Color("separatorColor"))
                        .background(Color.white)
                        .padding()
                    
                    // On error, let the user know that they couldn't be authenticated
                    if (error) {
                        Text("Could not validate email or password.")
                            .foregroundColor(Color.yellow)
                    } else {
                        
                        // Navigate to MainView() (main part of the app) only when isAuthenticated flag = true
                        NavigationLink(destination: MainView(), isActive: $isAuthenticated) {
                        }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                    }
                    // Display Login button
                    Button(action: signIn) {
                        Spacer()
                        
                        // Show a green button with rounded corners
                        Text("Login")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.green)
                                    .frame(width: 200)
                            )
                        Spacer()
                        
                    }
                    .padding(.vertical, 10.0)
                    
                    
                    // We need to give the user some way to register for an account.
                    NavigationLink(
                        destination: RegisterView()
                    ) {
                        Text("Sign Up")
                            .foregroundColor(Color.white)
                    }
                    
                    // Setting some navigation bar options so I can control navigation flow
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
                
            }
            
        }
    }
    
}



// LoginView preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
