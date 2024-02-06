//
//  RequestModel.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//
import Combine
import Foundation

struct RequestModel: Identifiable, Codable {
    var id: String
    var myID: String
    var streetAddress: String
    var city: String
    var state: String
    var pin: String
    var serviceType: String
    var hourlyRate: String
    var image1: String?
    var image2: String?
    var image3: String?
    var image4: String?
    var email: String
    var description: String?
    var employee: String?
    var status: String?
    var user2: String?
    
    init(id: String = UUID().uuidString,
         myID: String,
         streetAddress: String,
         city: String,
         state: String,
         pin: String,
         serviceType: String,
         hourlyRate: String,
         image1: String? = nil,
         image2: String? = nil,
         image3: String? = nil,
         image4: String? = nil,
         email: String,
         description: String,
         employee: String? = nil,
         status: String? = nil,
         user2: String? = nil) {
        
        self.id = id
        self.myID = myID
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.pin = pin
        self.serviceType = serviceType
        self.hourlyRate = hourlyRate
        self.image1 = image1
        self.image2 = image2
        self.image3 = image3
        self.image4 = image4
        self.email = email
        self.description = description
        self.employee = employee
        self.status = status
        self.user2 = user2
    }
}
