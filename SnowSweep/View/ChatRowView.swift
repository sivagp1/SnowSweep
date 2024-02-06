//
//  ChatRowView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI

struct ChatRowView: View {
    let chat: ChatModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(chat.user1)
                    .font(.headline)
                Spacer()
                Text(chat.time)
                    .font(.subheadline)
                Spacer()
                Text(chat.date)
                    .font(.caption)
            }
            
            Text(chat.message)
                .font(.subheadline)
        }
        .padding(.vertical, 8)
    }
}

//struct ChatRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRowView()
//    }
//}
