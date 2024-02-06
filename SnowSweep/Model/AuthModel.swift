//
//  AuthModel.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI
import Foundation
import Firebase

struct RegistrationDetails {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var isIndividualSelected: Bool
    var isEmployeeSelected: Bool
}

struct LoginDetails {
    var email: String
    var password: String
}

struct UserInfo {
    var email: String
    var firstName: String
    var lastName: String
    var isIndividualSelected: Bool
    var isEmployeeSelected: Bool
}

class AuthModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var loginErrorMessage: String?
    private var db = Firestore.firestore()
    @Published var newUser = RegistrationDetails(email: "",
                                                     password: "",
                                                     firstName: "",
                                                     lastName: "",
                                                 isIndividualSelected: true,
                                                 isEmployeeSelected: false
                                                     )
    
    @Published var currUser = LoginDetails(email: "",
                                                     password: ""
                                                     )
    
    @Published var userInfo = UserInfo(email: "",
                                         firstName: "",
                                         lastName: "",
                                     isIndividualSelected: true,
                                     isEmployeeSelected: false
                                         )
    
    func signup(completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { authResult, error in
            if let error = error as NSError? {
                self.errorMessage = error.localizedDescription
                print("Error creating user: \(error.localizedDescription)")
                completion(error)
            } else {
                // User was created successfully, now update the user's details in Firestore
                guard let uid = authResult?.user.uid else { return }
                let userRef = self.db.collection("users").document(uid)
                userRef.setData([
                    "firstName": self.newUser.firstName,
                    "lastName": self.newUser.lastName,
                    "email": self.newUser.email,
                    "isIndividualSelected": self.newUser.isIndividualSelected,
                    "isEmployeeSelected": self.newUser.isEmployeeSelected
                ]) { error in
                    if let error = error as NSError? {
                        // Handle any errors here
                        self.errorMessage = error.localizedDescription
                        print("Error updating user details: \(error.localizedDescription)")
                        completion(error)
                    } else {
                        // User details were updated successfully
                        print("User details updated successfully")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func login(completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: currUser.email, password: currUser.password) { result, error in
            if let error = error {
                // Handle any errors here
                self.loginErrorMessage = error.localizedDescription
                print("Error logging in: \(error.localizedDescription)")
                completion(error)
            } else {
                // User was logged in successfully
                print("User logged in successfully")
                guard let userId = result?.user.uid else {
                    completion(nil)
                    return
                }
                
                // Search for the user table in Firestore database
                let db = Firestore.firestore()
                db.collection("users").document(userId).getDocument { (snapshot, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    guard let userData = snapshot?.data() else {
                        completion(nil)
                        return
                    }
                    // Fetch user info from the user table
                    self.userInfo.firstName = userData["firstName"] as? String ?? ""
                    self.userInfo.lastName = userData["lastName"] as? String ?? ""
                    self.userInfo.email = userData["email"] as? String ?? ""
                    self.userInfo.isEmployeeSelected = userData["isEmployeeSelected"] as? Bool ?? false
                    self.userInfo.isIndividualSelected = userData["isIndividualSelected"] as? Bool ?? false
                    
                    completion(nil)
                }
            }
        }
    }
}

