//
//  ReviewModel.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/7/23.
//

import SwiftUI

struct ReviewModel: Identifiable {
    let id = UUID()
    let email: String
    let employeeEmail: String
    let description: String
}
