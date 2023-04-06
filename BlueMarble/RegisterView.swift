//
//  RegisterView.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 5/2/21.
//



import SwiftUI
import Firebase

struct RegisterView: View {
    
    // Some state variables we'll need to hold form information, in order for the user to sign up.
    @State var errorText: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var loading = false
    @State var error = false
    
    // To have access to the session, create an environment object
    @EnvironmentObject var session: SessionStore
    
    // I need a state variable to know when somebody has registered, to know when to navigate
    @State private var isRegistered = false
    
    // Construct a gradient
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.purple]),
        startPoint: .top, endPoint: .bottom)
    
    
    // Construct the form
    var body: some View {
        
        
        ZStack {
            
            // Show background.  I defined a blue-purple background above.
            backgroundGradient
                .ignoresSafeArea()
            
            // We'll also put these form UI elements in a vertical stack, but for each set logical set of elements, lets group them too.
            // Without using groups, SwiftUI doesn't like something over 10 Text() and TextField() UI elements without giving an error.
            
            ScrollView {
                
                // List form elements vertically
                VStack {
                    
                    // Heading
                    Text("Sign Up!")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .fontWeight(.light)
                    
                    // Add space if needed
                    Spacer()
                    
                    // Email label and text element
                    Group {
                        Text("Email").font(.subheadline).fontWeight(.thin).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                            .foregroundColor(.white)
                        
                        // Email textfield
                        TextField("user@domain.com", text: $email)
                            .textContentType(.emailAddress)
                            .padding()
                            .cornerRadius(4.0)
                            .border(Color("separatorColor"))
                            .background(Color.white)
                            .padding()
                    }
                    
                    // Password label and text element
                    Group {
                        Text("Password").font(.subheadline).fontWeight(.thin)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                            .foregroundColor(.white)
                        
                        
                        // Use SecureField because we want to hide display of the password
                        SecureField("Enter a password", text: $password)
                            .padding()
                            .cornerRadius(4.0)
                            .border(Color("separatorColor"))
                            .background(Color.white)
                            .padding()
                    }
                    
                    // First name label and text element
                    Group {
                        
                        Text("First Name").font(.subheadline).fontWeight(.thin).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                            .foregroundColor(.white)
                        
                        
                        
                        TextField("Enter your first name", text: $firstName)
                            .padding()
                            .cornerRadius(4.0)
                            .border(Color("separatorColor"))
                            .background(Color.white)
                            .padding()
                    }
                    
                    // Last name label and text element
                    Group {
                        
                        Text("Last Name").font(.subheadline).fontWeight(.thin).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                            .foregroundColor(.white)
                        
                        
                        
                        
                        TextField("Enter your last name", text: $lastName)
                            .padding()
                            .cornerRadius(4.0)
                            .border(Color("separatorColor"))
                            .background(Color.white)
                            .padding()
                        
                    }
                    
                    // Spacer to shove the registration button to the bottom of the screen.
                    Spacer()
                    
                    
                    
                    // The UI button on screen that we'll do all the backend Firebase registration stuff
                    Button(action: {
                        
                        
                        // The app should only do account creation stuff if all the information is typed in...
                        // If something is left out, the button won't do anything.
                        
                        if (email != "" && password != "" && firstName != "" && lastName != "") {
                            // Create account creates the user in the Authentication screen in Firebase
                            createAccount(email: email, password: password)
                            
                            // Since Firebase Authentication only stores an email
                            // and password, I would like to store other information about the user as well.
                            // This function will write the the 'users' collection with information about the user.
                            createUserProfile(email: email, firstName: firstName, lastName: lastName)
                            
                            // Finally, I want to set a boolean telling the app that registration is complete, and that
                            // it is OK to move to the login screen for the user to log in.
                            isRegistered = true
                        }
                        
                        
                    }) {
                        Spacer()
                        
                        VStack {
                            // Show a green button with rounded corners
                            Text("Sign Up!")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.green)
                                        .frame(width: 200)
                                )
                            
                            
                            // If the user is on this screen by mistake, allow them to jump back to LoginView()
                            NavigationLink(
                                destination: LoginView()
                            ) {
                                Text("Log In")
                                    .foregroundColor(Color.white)
                            }
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                        }
                        
                        
                        
                        
                        Spacer()
                        
                        // If there is an error during the Firebase authentication account creation, let the user know.
                        if (error) {
                            Text("Could not create your account at this time.")
                                .foregroundColor(Color.yellow)
                        } else {
                            
                            // After registration is complete, we want to show the LoginView for the user to login
                            NavigationLink(destination: LoginView(), isActive: $isRegistered) {
                            }
                        }
                        
                    }
                    .padding(.vertical, 10.0)
                    
                    
                }//.navigationBarBackButtonHidden(true)
            }
        }
        
    }
    
    
    // This function will create a document in the 'users' collection, passing in an email,
    // first name, and last name.
    func createUserProfile(email: String, firstName: String, lastName: String) {
        let db = Firestore.firestore()
        
        // I'll give it a document name of the user's email
        let docName = email.lowercased()
        
        // Create a reference with the document name of the user's email
        let docRef = db.collection("users").document(docName)
        
        // Finally, write the data to Firebase 'users' collection!
        docRef.setData([
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "createdTs": FieldValue.serverTimestamp()
        ])
        
    }
    
    // This function will create the Authentication account within Firebase.
    // Note:  this is writing to Authentication, and not any document.
    func createAccount(email: String, password: String) {
        
        // Create the user with the email and password passed in
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard let user = authResult?.user, error == nil else {
                
                // If there is a problem, store the error in errorText
                let errorText: String  = error?.localizedDescription ?? "unknown error"
                self.errorText = errorText
                
                return
            }
            
            // We can ask Firebase to send email verification to make sure the user's email
            // is legitimate.
            Auth.auth().currentUser?.sendEmailVerification { (error) in
                if let error = error {
                    self.errorText = error.localizedDescription
                    return
                }
            }
            
            print("\(user.email!) created")
            
        }
    }
    
}

// Show preview for the RegisterView()
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
