//
//  RequestDetailView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI
import URLImage
import Firebase

struct RequestDetailView: View {
    var request: RequestModel
    
    @Binding var email: String
    @Binding var isUser: Bool
    // @State private var user2 = ""
    var onFetch: (() -> Void)?
    
    @State private var showAlert = false
    @State private var showAlert1 = false
    
    
    var body: some View {
        Spacer()
        Spacer()
        ScrollView{
        VStack(alignment: .leading, spacing: 10) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                Spacer()
                HStack {
                    Spacer()
                    
                    if let urlString = request.image1, let imageURL = URL(string: urlString) {
                        URLImage(imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 225, height: 225)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.trailing, 10)
                    }
                    
                    if let urlString = request.image2, let imageURL = URL(string: urlString) {
                        URLImage(imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 225, height: 225)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.trailing, 10)
                    }
                    
                    if let urlString = request.image3, let imageURL = URL(string: urlString) {
                        URLImage(imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 225, height: 225)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.trailing, 10)
                    }
                    
                    if let urlString = request.image4, let imageURL = URL(string: urlString) {
                        URLImage(imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 225, height: 225)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.trailing, 10)
                    }
                    
                    Spacer()
                }
                .padding(.leading)
            }
            
            
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer()
                    
                    Text(request.serviceType)
                        .font(.title)
                        .bold()
             
                    Spacer()
                }

                   
                
                
                Text("Hourly Rate: $\(request.hourlyRate)")
                    .font(.headline)
                
                Text("Address:")
                    .font(.headline)
                
                Text("Street: \(request.streetAddress)")
                    .font(.subheadline)
                
                Text("City: \(request.city)")
                    .font(.subheadline)
                
                Text("State: \(request.state)")
                    .font(.subheadline)
                
                
                if let description = request.description {
                    Text("Description: \(description)")
                        .font(.headline)
                } else {
                    Text("No description available")
                        .font(.headline)
                }
            }
            
            //   user2 = request.user2 ?? "default value"
            if request.email == email{
                if request.employee == "1" {
                    NavigationLink(destination: ChattingView(email: $email, user1: { request.email ?? "" }, user2: { request.user2 ?? "" })) {
                        Text("Contact Employee")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top)
                    }
                }
            }
            else{
                if request.employee == "1" {
                    NavigationLink(destination: ChattingView(email: $email, user1: { request.user2 ?? "" },  user2: { request.email ?? "" })) {
                        Text("Contact Employee")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top)
                    }
                }
            }
            
            
            
            
            
            
            if isUser && request.employee != "1" {
                Button(action: {
                    onFetch?()
                    // Update Firebase database
                    let db = Firestore.firestore()
                    let requestRef = db.collection("Requests").document(request.myID)
                    requestRef.updateData([
                        "employee": "1",
                        "user2": email
                    ]) { error in
                        if let error = error {
                            print("Error updating request: \(error.localizedDescription)")
                        } else {
                            print("Request updated successfully!")
                            showAlert = true
                        }
                    }
                    
                }) {
                    Text("Accept")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.top)
                .alert(isPresented: $showAlert) {
                        Alert(title: Text("Job Accepted"), message: Text("Congratulations! You have accepted the job."), dismissButton: .default(Text("OK")))
                    }
            }
            
            if request.user2 == email && request.status == "0" {
               
                
                Button(action: {
                    onFetch?()
                    let db = Firestore.firestore()
                    let requestRef = db.collection("Requests").document(request.myID)
                    requestRef.updateData([
                        "status": "1"
                    ]) { error in
                        if let error = error {
                            print("Error updating request: \(error.localizedDescription)")
                        } else {
                            print("Request updated successfully!")
                            showAlert1 = true // Show the alert after successful update
                        }
                    }
                }) {
                    Text("Finish Work")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.top)
                .alert(isPresented: $showAlert1) {
                    Alert(title: Text("Thank you!"),
                          message: Text("Thank you for completing the job!"),
                          dismissButton: .default(Text("OK")))
                }
            }

            
            
            
            
            VStack {
                HStack {
                    Spacer()
                    if request.status == "1" {
                        Text("Completed")
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.green)
                            .cornerRadius(10)
                    } else {
                        Text("Pending")
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.yellow)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.horizontal, 10)
                Spacer() // Add spacer to push buttons to the top
            }
 // Apply horizontal padding to HStack
     
            
        }
    }
        .edgesIgnoringSafeArea(.all)
    }
}



extension RequestModel {
    func image(for index: Int) -> String? {
        switch index {
        case 0: return image1
        case 1: return image2
        case 2: return image3
        case 3: return image4
        default: return nil
        }
    }
}


//struct RequestDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestDetailView(request: RequestModel)
//    }
//}
