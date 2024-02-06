import SwiftUI
import Firebase

struct ReviewView: View {
    @State private var employeeEmail: String = ""
    @State private var description: String = ""
    @State private var reviews: [ReviewModel] = []
    @Binding var email: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Employee Email")
                            .font(.headline)
                        TextField("Enter employee email", text: $employeeEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 10)
                        
                        Text("Description")
                            .font(.headline)
                        TextField("Enter description", text: $description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 10)
                        
                        Button(action: {
                            postReview()
                        }) {
                            Text("Post Review")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    reviewListView
                        .padding(.horizontal)
                }
                .padding(.vertical, 20)
                .padding(.horizontal)
            }
            .navigationBarTitle("Reviews")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                fetchReviews()
            }
        }
    }

    
    var reviewListView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(reviews) { review in
                VStack(alignment: .leading, spacing: 5) {
                    Text("User: \(review.email)")
                        .font(.headline)
                    Text("Employee Email: \(review.employeeEmail)")
                    Text("Description: \(review.description)")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
    
    func fetchReviews() {
        let db = Firestore.firestore()
        db.collection("reviews").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching reviews: \(error.localizedDescription)")
            } else if let documents = snapshot?.documents {
                reviews = documents.compactMap { document in
                    let data = document.data()
                    let email = data["email"] as? String ?? ""
                    let employeeEmail = data["employeeEmail"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    return ReviewModel(email: email, employeeEmail: employeeEmail, description: description)
                }
            }
        }
    }
    
    func postReview() {
        let db = Firestore.firestore()
        let reviewData = [
            "email": email,
            "employeeEmail": employeeEmail,
            "description": description
        ]
        
        db.collection("reviews").addDocument(data: reviewData) { error in
            if let error = error {
                print("Error posting review: \(error.localizedDescription)")
            } else {
                print("Review posted successfully!")
                employeeEmail = ""
                description = ""
                fetchReviews()
            }
        }
    }
}
