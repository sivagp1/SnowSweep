//
//  ChatModel.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import Foundation

struct ChatModel: Codable, Identifiable {
    var id = UUID()
    var user1: String
    var user2: String
    var message: String
    var time: String
    var date: String

    enum CodingKeys: String, CodingKey {
        case user1
        case user2
        case message
        case time
        case date
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user1, forKey: .user1)
        try container.encode(user2, forKey: .user2)
        try container.encode(message, forKey: .message)
        try container.encode(time, forKey: .time)
        try container.encode(date, forKey: .date)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user1 = try container.decode(String.self, forKey: .user1)
        user2 = try container.decode(String.self, forKey: .user2)
        message = try container.decode(String.self, forKey: .message)
        time = try container.decode(String.self, forKey: .time)
        date = try container.decode(String.self, forKey: .date)
    }

    init(user1: String, user2: String, message: String, time: String, date: String) {
        self.user1 = user1
        self.user2 = user2
        self.message = message
        self.time = time
        self.date = date
    }
    
    func toDict() -> [String: Any] {
        return [
            "user1": user1,
            "user2": user2,
            "message": message,
            "time": time,
            "date": date
        ]
    }
}

