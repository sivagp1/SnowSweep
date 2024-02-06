//
//  EmployeeHomeView.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct EmployeeHomeView: View {
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var myID = ""
    @State private var state = ""
    @State private var pin = ""
    @State private var serviceType = "Shoveling"
    @State private var hourlyRate = ""
    @State private var description = ""
    @State private var pickerSelection = 0
    
    @State private var isShowingContentView = false
    @State private var selectedImages: [UIImage?] = [nil, nil, nil, nil]
    @State private var showingImagePicker = false
    @State private var currentImageIndex = 0
    
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    @State private var requests: [RequestModel] = []
    
    @Binding var email: String
    @Binding var isEmployee: Bool
    
    @State private var adImage: UIImage? = nil
    @State private var adImage1: UIImage? = nil

    
    var body: some View {
        VStack {
            Picker(selection: $pickerSelection, label: Text("Select Action")) {
                Text("All Requests").tag(0)
                Text("My Jobs").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .font(.headline)
            .onChange(of: pickerSelection) { newValue in
                if newValue == 0 {
                    fetchRequests()
                }
            }
            .onAppear {
                pickerSelection = 0 // Set the pickerSelection to 0 when the view appears
            }

                        
            if pickerSelection == 0 {
              
                    NavigationView {
                                                    VStack{
                                List {
                                    ForEach(requests.filter { $0.user2 == "" }) { request in
                                        NavigationLink(
                                            destination: RequestDetailView(request: request, email: $email, isUser: $isEmployee){
                                                fetchRequests()
                                            }
                                        ) {
                                            RequestRowView(request: request)
                                        }
                                    }
                                }
                            }
                            
            
                        
                    
                }

            }


            if pickerSelection == 1 {
                NavigationView{
                    VStack {
                        
                        List {
                            ForEach(requests.filter { $0.user2 == email }) { request in
                                NavigationLink(
                                    destination: RequestDetailView(request: request, email: $email, isUser: $isEmployee){
                                        fetchRequests()
                                    }
                                ) {
                                    RequestRowView(request: request)
                                }
                            }
                        }
                    }
                    
                }

            }//picker
        }
        .onAppear {
                pickerSelection = 0
            fetchRequests()// Set the pickerSelection to 0 when the view appears
            }
        .padding()
        .navigationBarTitle("Snow Removal Requests")
    }
    func fetchRequests() {
        let db = Firestore.firestore()
        let requestsRef = db.collection("Requests")

        requestsRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var fetchedRequests: [RequestModel] = []

                for document in querySnapshot!.documents {
                    let data = document.data()
                    let myID = document.documentID

                    let streetAddress = data["streetAddress"] as? String ?? ""
                    let city = data["city"] as? String ?? ""
                    let state = data["state"] as? String ?? ""
                    let pin = data["pin"] as? String ?? ""
                    let serviceType = data["serviceType"] as? String ?? ""
                    let hourlyRate = data["hourlyRate"] as? String ?? ""
                    let image1 = data["image1"] as? String
                    let image2 = data["image2"] as? String
                    let image3 = data["image3"] as? String
                    let image4 = data["image4"] as? String
                    let email = data["email"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let employee = data["employee"] as? String ?? ""
                    let status = data["status"] as? String ?? ""
                    let user2 = data["user2"] as? String ?? ""

                    let request = RequestModel( myID: myID, streetAddress: streetAddress, city: city, state: state, pin: pin, serviceType: serviceType, hourlyRate: hourlyRate, image1: image1, image2: image2, image3: image3, image4: image4, email: email, description: description,employee: employee,status: status,user2: user2)

                    fetchedRequests.append(request)
                }
                self.requests = fetchedRequests
            }
        }
    }
    func fetchRandomAdImage(completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let adsRef = storageRef.child("Ads")
        
        adsRef.listAll { (result, error) in
            if let error = error {
                print("Error fetching ads:", error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let result = result else {
                print("No ad images found")
                completion(nil)
                return
            }
            
            let items = result.items
            guard !items.isEmpty else {
                print("No ad images found")
                completion(nil)
                return
            }
            
            // Get a random image
            let randomIndex = Int.random(in: 0..<items.count)
            let randomImageRef = items[randomIndex]
            
            randomImageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Error fetching ad image data:", error.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let imageData = data, let image = UIImage(data: imageData) else {
                    print("Error creating ad image")
                    completion(nil)
                    return
                }
                
                completion(image)
            }
        }
    }

}

//struct EmployeeHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmployeeHomeView()
//    }
//}
