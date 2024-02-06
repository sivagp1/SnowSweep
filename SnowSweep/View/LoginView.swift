//
//  LoginView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/4/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var isPresentingUserHomeView = false
    @State private var isPresentingEmployeeHomeView = false
    @State private var isPresentingSignupSheet = false
    @State private var isPresent = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @StateObject private var viewModel = AuthModel()
    
    var body: some View {
        NavigationView {
            ScrollView  {
                VStack(spacing: 20) {
                    Spacer() // Add Spacer view to center text fields vertically
                    
                    Image("LoginImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 250)
                        .padding(.bottom, 20)
                    
                    CustomTextField(placeholder: "Email", text: $viewModel.currUser.email)
                        .frame(maxWidth: .infinity)
                    
                    CustomPasswordField(placeholder: "Password", password: $viewModel.currUser.password)
                        .frame(maxWidth: .infinity)
                    
                    CustomButton(title: "Log In", backgroundColor: .blue, foregroundColor: .white) {
                        viewModel.login  { error in
                            // Handle error
                            if let error = error {
                                self.alertMessage = error.localizedDescription
                                self.showAlert = true
                            }
                            else    {
                                print("In Login View, user logged in succesfully")
                                print(viewModel.userInfo.email)
                                if(viewModel.userInfo.isIndividualSelected) {
                                    email = viewModel.userInfo.email
                                    isPresentingUserHomeView = true
                                    // isUser = true
                                }
                                else if (viewModel.userInfo.isEmployeeSelected) {
                                    email = viewModel.userInfo.email
                                    isPresentingEmployeeHomeView = true
                                }
                            }
                        }
                    }
                    
                    Spacer() // Add Spacer view to center buttons vertically
                        .frame(height: 5) // Set height for button spacing
                    
                    CustomButton(title: "Sign Up", backgroundColor: .white, foregroundColor: .blue) {
                        isPresentingSignupSheet = true
                    }
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Login")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $isPresentingSignupSheet)  {
                SignupView()
            }
            .fullScreenCover(isPresented: $isPresentingUserHomeView){
                UserView(email: $email, isUser: $isPresentingEmployeeHomeView)
            }
            .fullScreenCover(isPresented: $isPresentingEmployeeHomeView){
                EmployeeView(email: $email, isEmployee: $isPresentingEmployeeHomeView)
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            TextField("", text: $text)
                .font(.system(size: 14))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

struct CustomPasswordField: View {
    var placeholder: String
    @Binding var password: String
    @State private var showPassword = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            if password.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            if showPassword {
                TextField("", text: $password)
                    .font(.system(size: 14))
            } else {
                SecureField("", text: $password)
                    .font(.system(size: 14))
            }
            HStack {
                Spacer()
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Color.gray.opacity(0.7))
                }
                .padding(.trailing, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var foregroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(foregroundColor)
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
        }
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
