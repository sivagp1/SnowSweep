//
//  UserView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI

struct UserView: View {
    @State private var selectedTab = 0
    @Binding var email: String
    @Binding var isUser: Bool
    
    var body: some View {
        TabView(selection: $selectedTab) {
            UserHomeView(email: $email, isUser: $isUser)
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

struct UserView_Previews: PreviewProvider {
    @State private static var isUser = false
    @State private static var email = ""
    static var previews: some View {
        UserView(email: $email, isUser:$isUser)
    }
}
