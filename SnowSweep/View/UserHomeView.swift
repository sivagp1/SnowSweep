import SwiftUI
import Firebase
import Combine
import FirebaseStorage
import URLImage



struct UserHomeView: View {
    @State private var adImage: UIImage? = nil
    @State private var adImage1: UIImage? = nil
    @State private var streetAddress = ""
    @State private var city = ""
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
    @Binding var isUser: Bool
    
    @State private var weather: WeatherResponse?
        @State private var isLoading = false
    
    var body: some View {
        VStack {
            //RequestDetailView(email: $email, isUser: $isUser, onFetch: { self.fetchRequests() })
            Picker(selection: $pickerSelection, label: Text("")) {
                Text("My Requests").tag(0)
                Text("Create Request").tag(1)
                Text("Weather").tag(2)
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
                    print(requests.capacity)
                    fetchRequests()
                }
            }
            .onAppear {
                pickerSelection = 0 // Set the pickerSelection to 0 when the view appears
            }


                        
            if pickerSelection == 0 {
                
                    NavigationView{
                        
                        VStack {
                            
                            List {
                                ForEach(requests.filter {
                                    print("fetched email:",email)
                                    print("email from req:",$0.email)
                                    return $0.email == email }) { request in // Filter the requests based on email
                                        NavigationLink(
                                            destination: RequestDetailView(request: request, email: $email, isUser: $isUser){
                                                //fetchRequests()
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
                Spacer()
                ScrollView{
                    
                VStack(spacing: 10) {
                    if let adImage = adImage {
                        Image(uiImage: adImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    }
                    HStack(spacing: 10) {
                        Button(action: {
                            currentImageIndex = 0
                            showingImagePicker = true
                        }) {
                            Text(selectedImages[0] == nil ? "Upload Image 1" : "Change Image 1")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            currentImageIndex = 1
                            showingImagePicker = true
                        }) {
                            Text(selectedImages[1] == nil ? "Upload Image 2" : "Change Image 2")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            currentImageIndex = 2
                            showingImagePicker = true
                        }) {
                            Text(selectedImages[2] == nil ? "Upload Image 3" : "Change Image 3")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            currentImageIndex = 3
                            showingImagePicker = true
                        }) {
                            Text(selectedImages[3] == nil ? "Upload Image 4" : "Change Image 4")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                    }
                    
                }
                .onAppear {
                    fetchRandomAdImage { image in
                        adImage = image
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePickerModel(selectedImage: $selectedImages[currentImageIndex])
                    
                }
                
                VStack(spacing: 10) {
                    TextField("Street Address", text: $streetAddress)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        )
                    
                    TextField("City", text: $city)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        )
                    
                    TextField("State", text: $state)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        )
                    
                    TextField("PIN", text: $pin)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        )
                    
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        )
                        .foregroundColor(Color.gray)
                        .opacity(description.isEmpty ? 0.5 : 1)
                        .overlay(
                            Text("Write a description")
                                .padding(.leading, 4)
                                .foregroundColor(Color.gray)
                                .opacity(description.isEmpty ? 1 : 0)
                        )
                    Picker(selection: $serviceType, label: Text("Service Type")) {
                        Text("Shoveling").tag("Shoveling")
                        Text("Salting").tag("Salting")
                        Text("Snow Hauling").tag("Snow Hauling")
                        Text("Plowing").tag("Plowing")
                        Text("Ice Dam Removal").tag("Ice Dam Removal")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    )
                    
                    TextField("Estimated Hourly Rate $/hr", text: $hourlyRate)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        )
                    
                }
                
                
                Button(action: {
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    
                    var imageURLs: [String] = ["", "", "", ""]
                    let dispatchGroup = DispatchGroup()
                    
                    guard selectedImages.contains(where: { $0 != nil }) else {
                            // Display an alert indicating that at least one image must be selected
                            alertMessage = "Please select at least one image"
                            isShowingAlert = true
                            return
                        }
                    
                    for (index, image) in selectedImages.enumerated() {
                        if let image = image, let imageData = image.jpegData(compressionQuality: 0.1) {
                            dispatchGroup.enter()
                            let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
                            imageRef.putData(imageData, metadata: nil) { _, error in
                                if let error = error {
                                    print("Error uploading image: \(error)")
                                    dispatchGroup.leave()
                                } else {
                                    imageRef.downloadURL { url, error in
                                        if let error = error {
                                            print("Error getting download URL: \(error)")
                                        } else if let url = url {
                                            imageURLs[index] = url.absoluteString
                                        }
                                        dispatchGroup.leave()
                                    }
                                }
                            }
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        let request = RequestModel(
                            myID: "",
                            streetAddress: streetAddress,
                            city: city,
                            state: state,
                            pin: pin,
                            serviceType: serviceType,
                            hourlyRate: hourlyRate,
                            image1: imageURLs[0],
                            image2: imageURLs[1],
                            image3: imageURLs[2],
                            image4: imageURLs[3],
                            email: email,
                            description: description,
                            employee: "0",
                            status: "0",
                            user2: ""
                        )
                        
                        let db = Firestore.firestore()
                        let mirror = Mirror(reflecting: request)
                        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map { (label: String?, value: Any) -> (String, Any)? in
                            guard let label = label else { return nil }
                            return (label, value)
                        }.compactMap { $0 })
                        
                        do {
                            let _ = try db.collection("Requests").addDocument(data: dict)
                            // Reset all fields and images after the request is created
                            
                            streetAddress = ""
                            city = ""
                            state = ""
                            pin = ""
                            serviceType = "Shoveling"
                            hourlyRate = ""
                            selectedImages = [nil, nil, nil, nil]
                            // email = ""
                            description = ""
                            alertMessage = "Request created"
                            isShowingAlert = true
                        } catch let error {
                            print("Error adding document: \(error)")
                        }
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        
                        Text("Create")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    )
                }
                
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text(alertMessage))
                }
            }
            }
            if pickerSelection == 2 {
                ScrollView{
                ZStack {
                    Color(.systemGray6) // Assuming you want a near white color
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        if let adImage = adImage {
                            Image(uiImage: adImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                        }
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(2)
                        } else if let weather = weather {
                            VStack {
                                Text("Syracuse")
                                    .font(.system(size: 40, weight: .heavy))
                                    .foregroundColor(.white)
                                
                                Text(weather.weather.first?.main ?? "")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Description: \(weather.weather.first?.description.capitalized ?? "")")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Temperature")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("Feels Like")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("Humidity")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("Wind Speed")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 8) {
                                        Text("\(weather.main.temp, specifier: "%.1f")°K")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                        Text("\(weather.main.feels_like, specifier: "%.1f")°K")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                        Text("\(weather.main.humidity)%")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                        Text("\(weather.wind.speed, specifier: "%.1f") m/s")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(20)
                            .padding()
                        } else {
                            Text("No weather data available")
                                .foregroundColor(.white)
                        }
                        if let adImage = adImage1 {
                            Image(uiImage: adImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                        }
                    }
                }
                //                .onAppear(perform: fetchWeather)
                .onAppear {
                    fetchRandomAdImage { image in
                        adImage1 = image
                    }
                    fetchRandomAdImage { image in
                        adImage = image
                    }
                    fetchWeather()
                }
            }
            }

//picker 2
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



    
    func fetchWeather() {
        isLoading = true
        let apiKey = ""
        let city = "New York City"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=New%20York%20City&appid=apiKey"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.weather = weatherData
                        self.isLoading = false
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    isLoading = false
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                isLoading = false
            }
        }
        task.resume()
    }

    
}


struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
    
    struct Weather: Codable, Identifiable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
}
