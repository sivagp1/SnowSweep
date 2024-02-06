//
//  SignupView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/4/23.
//

import SwiftUI

struct SignupView: View {
    
    @State private var isIndividualSelected = true
    @State private var isEmployeeSelected = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AuthModel()
    var body: some View {
        NavigationView  {
            ScrollView{
                VStack {
                    Spacer()
                    CustomTextField(placeholder: "Email", text: $viewModel.newUser.email)
                        .padding()
                    
                    CustomPasswordField(placeholder: "Password", password: $viewModel.newUser.password)
                        .padding()
                    
                    CustomTextField(placeholder: "First Name", text: $viewModel.newUser.firstName)
                        .padding()
                    
                    CustomTextField(placeholder: "Last Name", text: $viewModel.newUser.lastName)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            viewModel.newUser.isIndividualSelected = true
                            viewModel.newUser.isEmployeeSelected = false
                            self.isIndividualSelected = true
                            self.isEmployeeSelected = false
                        }) {
                            Circle()
                                .fill(isIndividualSelected ? Color.blue : Color.gray)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        Text("User")
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.newUser.isIndividualSelected = false
                            viewModel.newUser.isEmployeeSelected = true
                            self.isIndividualSelected = false
                            self.isEmployeeSelected = true
                            
                        }) {
                            Circle()
                                .fill(isEmployeeSelected ? Color.blue : Color.gray)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "building.2.fill")
                                        .foregroundColor(.white)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        Text("Employee")
                    }
                    .padding()
                    
                    CustomButton(title: "Sign Up", backgroundColor: .blue, foregroundColor: .white) {
                        viewModel.signup  { error in
                            // Handle error
                            if let error = error {
                                self.alertMessage = error.localizedDescription
                                self.showAlert = true
                            }   else {
                                // Signup successful, close the signup view and navigate to the login view
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("Register")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
