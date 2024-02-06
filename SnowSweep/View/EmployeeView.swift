//
//  EmployeeView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI

struct EmployeeView: View {
    @State private var selectedTab = 0
    @Binding var email: String
    @Binding var isEmployee: Bool
    @State private var employee = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EmployeeHomeView(email: $email, isEmployee: $isEmployee)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            ProfileView(email: $email)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(1)
        }
    }
}

struct EmployeeView_Previews: PreviewProvider {
    @State private static var isUser = false
    @State private static var email = ""
    static var previews: some View {
        UserView(email: $email, isUser:$isUser)
    }
}
