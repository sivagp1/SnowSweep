//
//  RequestRowView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI
import URLImage

import SwiftUI
import URLImage

struct RequestRowView: View {
    let request: RequestModel
    
    var body: some View {
        Spacer()
        HStack {
            if let urlString = request.image1, let imageURL = URL(string: urlString) {
                URLImage(imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 75)
                        .clipped()
                }
                .padding(.trailing, 10)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 75)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(request.serviceType)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .shadow(color: .white, radius: 2, x: 0, y: 0)
                                    
                Text("Hourly Rate: $\(request.hourlyRate)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                
                if let city = request.city {
                    Text("City: \(city)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 8)
            
            Spacer()
        }
    }
}





//struct RequestRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestRowView(request: <#RequestModel#>)
//    }
//}
