//
//  ChattingView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI

import SwiftUI
import Firebase

struct ChattingView: View {
    @State private var chats: [ChatModel] = []
    @State private var message: String = ""
    @Binding var email: String
    let user1: () -> String
    let user2: () -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            let filteredChats = chats.filter { chat in
                ((chat.user1 == user1() && chat.user2 == user2()) || (chat.user2 == user1() && chat.user1 == user2()))
                                                                   
            }
            List(filteredChats) { chat in
                ChatRowView(chat: chat)
            }
            
            TextField("Enter your message", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Send") {
                guard !message.isEmpty else { return }
                
                let db = Firestore.firestore()
                let chatRef = db.collection("chats").document()
                
                let timestamp = Timestamp()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                let time = timeFormatter.string(from: timestamp.dateValue())

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                let date = dateFormatter.string(from: timestamp.dateValue())
    
                let chat = ChatModel(user1: user1(), user2: user2(), message: message, time: time, date: date)

                let chatData = chat.toDict()
                
                chatRef.setData(chatData) { error in
                    if let error = error {
                        print("Error adding chat: \(error)")
                    } else {
                        message = ""
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.top)
        }//vstack
        .onAppear {
            let db = Firestore.firestore()
            db.collection("chats").addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.chats = documents.compactMap { queryDocumentSnapshot -> ChatModel? in
                    let data = queryDocumentSnapshot.data()
                    let user1 = data["user1"] as? String ?? ""
                    let user2 = data["user2"] as? String ?? ""
                    let message = data["message"] as? String ?? ""
                    let time = data["time"] as? String ?? ""
                    let date = data["date"] as? String ?? ""

                    return ChatModel(user1: user1, user2: user2, message: message, time: time, date: date)

                }
                .sorted{$0.date > $1.date || ($0.date == $1.date && $0.time > $1.time)}
                
                
            }
        }//VSTACK
    }
}



