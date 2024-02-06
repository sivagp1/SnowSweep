//
//  UserProfileImpl.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import Foundation
import SwiftUI
import Foundation
import Firebase
import FirebaseStorage
import UIKit

class UserProfileImpl: ObservableObject {
    // The user's profile image
    @Published var profileImage: UIImage?

    // The user's name, country, city, and phone number
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var street: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var phoneNumber: String = ""


    // Firebase references
    private let user = Auth.auth().currentUser
    private let storageRef = Storage.storage().reference()

    func loadProfile() {
        let db = Firestore.firestore()
        guard let uid = user?.uid else { return }
        
        // Load profile image from Firebase Storage
        let profileImageRef = storageRef.child("users/\(uid)/profile.jpg")
        profileImageRef.downloadURL { url, error in
            if let url = url {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.profileImage = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        
        // Load user profile details from Firebase Firestore
        let profileDetailsRef = db.collection("users").document(uid)
        profileDetailsRef.getDocument { snapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            if let profileDetails = snapshot?.data() {
                self.lastName = profileDetails["firstName"] as? String ?? ""
                self.firstName = profileDetails["lastName"] as? String ?? ""
                self.street = profileDetails["street"] as? String ?? ""
                self.city = profileDetails["city"] as? String ?? ""
                self.state = profileDetails["state"] as? String ?? ""
                self.phoneNumber = profileDetails["phoneNumber"] as? String ?? ""
            }
        }
    }

//    // Update only the user's profile image in Firebase
//    func updateProfilePic(completion: @escaping (Error?) -> Void) {
//        guard let uid = user?.uid,
//              let profileImage = profileImage,
//              let imageData = profileImage.jpegData(compressionQuality: 0.5) else {
//            return
//        }
//
//        let profileImageRef = storageRef.child("users/\(uid)/profile.jpg")
//        profileImageRef.putData(imageData, metadata: nil) { metadata, error in
//            if let error = error {
//                completion(error)
//                return
//            }
//
//            profileImageRef.downloadURL { url, error in
//                if let error = error {
//                    completion(error)
//                    return
//                }
//
//                guard let url = url else {
//                    completion(NSError(domain: "FirebaseStorage", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get image URL"]))
//                    return
//                }
//
//                let db = Firestore.firestore()
//                let userRef = db.collection("users").document(uid)
//                let values: [String: Any] = ["profileImageUrl": url.absoluteString]
//                userRef.updateData(values) { error in
//                    if let error = error {
//                        print("Error updating profile details: \(error.localizedDescription)")
//                    } else {
//                        print("Profile details updated successfully!")
//                    }
//                }
//            }
//        }
//    }

    
    func updateProfile() {
        guard let uid = user?.uid else { return }

        // Upload profile image to Firebase Storage
        if let profileImage = profileImage,
           let imageData = profileImage.jpegData(compressionQuality: 0.5) {
            let profileImageRef = storageRef.child("users/\(uid)/profile.jpg")
            profileImageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading profile image: \(error.localizedDescription)")
                } else {
                    // Save image URL to Firestore
                    profileImageRef.downloadURL { url, error in
                        if error != nil {
                            print("Error getting profile image URL: \(error?.localizedDescription ?? "")")
                        } else if let url = url {
                            let db = Firestore.firestore()
                            let profileDetailsRef = db.collection("users").document(uid)
                            let values: [String: Any] = ["profileImageUrl": url.absoluteString]
                            profileDetailsRef.updateData(values) { error in
                                if let error = error {
                                    print("Error updating profile image URL: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }

        // Update user profile details in Firestore
        let db = Firestore.firestore()
        let profileDetailsRef = db.collection("users").document(uid)
        let values: [String: Any] = [
            "lastName": firstName,
            "firstName":lastName,
            "street": street,
            "city": city,
            "state": state,
            "phoneNumber": phoneNumber
        ]
        profileDetailsRef.updateData(values) { error in
            if let error = error {
                print("Error updating profile details: \(error.localizedDescription)")
            }
        }
    }
    
}

