//
//  From tutorial: https://benmcmahen.com/authentication-with-swiftui-and-firebase/
//  This other code that uses the above tutorial uses similar code too for their SessionStore:
//  https://github.com/bmcmahen/julienne-swift



// These are Session functions I will use to listen, sign in, and sign up in this app

import SwiftUI
import Firebase
import Combine
import FirebaseAuth

class SessionStore : ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    var session: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    // Sign up function
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    // Sign in function
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    // Sign out function
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    // Unbind function
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

// User will hold some session information important to us.
class User {
    var uid: String
    var email: String?
    var displayName: String?
    
    // Initiate User object
    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
    
}
