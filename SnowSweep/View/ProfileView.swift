//
//  ProfileView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    // Create an instance of ProfileViewModel and initialize it as a StateObject
    @StateObject var viewModel = UserProfileImpl()
    //@EnvironmentObject var service: SessionServiceImpl

    // Create a state variable to control the ImagePicker sheet
    @State private var showLogin = false
    @State private var showImagePicker = false
    @State private var showReview = false
    @State private var isEmployee = false
    @Binding var email: String
    @State private var isEmployeeSelected = false
    //@Binding var isUser: String
   // @Binding var isEmployee: String


    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            // Display the profile image or a placeholder if it's not available
            ScrollView  {
                VStack(spacing: 30) {
                    Spacer()
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    }
                    
                    // Button to show the ImagePicker sheet
                    Button(action: { showImagePicker = true }) {
                        Image(systemName: "camera")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 4)
                            )
                            .padding(10)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ProfileImagePicker(image: $viewModel.profileImage)
                    }
                
                // Form to edit the user's profile details
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Profile Details")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        ProfileTextField(placeholder: "First Name", text: $viewModel.firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        ProfileTextField(placeholder: "Last Name", text: $viewModel.lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        ProfileTextField(placeholder: "Street", text: $viewModel.street)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        ProfileTextField(placeholder: "City", text: $viewModel.city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        ProfileTextField(placeholder: "State", text: $viewModel.state)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        ProfileTextField(placeholder: "Phone Number", text: $viewModel.phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    }
                    .padding(.horizontal, 20)
                    ProfileButtons(action: viewModel.updateProfile, label: "Save")
                        
                    ProfileButtons(action: {showLogin = true}, label: "Log Out", backgroundColor: .red)
                        .padding(.bottom, 30)
                    
                    

                   
                    if !isEmployeeSelected {
                                            ProfileButtons(action: { showReview = true }, label: "Give a Review", backgroundColor: .green)
                                                .padding(.bottom, 30)
                                        }
                    
                    

                    
                       
                    
                    
                    Spacer()
                }
            }
            .padding()
            .navigationBarTitle("Profile")
            // Call the loadProfile method of the viewModel when the view appears
            .onAppear {
                viewModel.loadProfile()
                checkIfEmployeeSelected(email: email) { isEmployeeSelected in
                    self.isEmployeeSelected = isEmployeeSelected
                }
            }
            .fullScreenCover(isPresented: $showLogin) {
                LoginView()
            }
            .fullScreenCover(isPresented: $showReview) {
                ReviewView(email: $email)
            }
        }
    }
 

    func checkIfEmployeeSelected(email: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        usersCollection.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error retrieving documents: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(false)
                return
            }
            
            if let document = documents.first,
               let isEmployeeSelected = document.data()["isEmployeeSelected"] as? Bool {
                completion(isEmployeeSelected)
            } else {
                completion(false)
            }
        }
    }

    


}

    
struct ProfileButtons: View {
    let action: () -> Void
    let label: String
    let backgroundColor: Color

    init(action: @escaping () -> Void, label: String, backgroundColor: Color = .blue) {
        self.action = action
        self.label = label
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 50)
                .padding(.vertical, 10)
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
    }
}

struct ProfileTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(Color.white)
            .cornerRadius(10)
            .padding(.vertical, 5)
    }
}


