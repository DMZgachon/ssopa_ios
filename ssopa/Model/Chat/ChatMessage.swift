//
//  ChatMessage.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/31.
//

import Foundation




struct ChatMessage: Codable,Identifiable{
    
    var message_id: Int
    var type: MessageType
    var roomId: String?
    var sender: String?
    var message: String?
    var time: Array<Int>?
    
    
    var id: Int{
        return message_id
    }
    
    enum CodingKeys: String, CodingKey {
            case message_id
            case type
            case roomId
            case sender
            case message
            case time
        }
    
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            message_id = try container.decodeIfPresent(Int.self, forKey: .message_id) ?? 1
            type = try container.decode(MessageType.self, forKey: .type)
            roomId = try container.decodeIfPresent(String.self, forKey: .roomId)
            sender = try container.decodeIfPresent(String.self, forKey: .sender)
            message = try container.decodeIfPresent(String.self, forKey: .message)
            time = try container.decodeIfPresent([Int].self, forKey: .time) ?? getCurrentTime()
        }
        
        func getCurrentTime() -> [Int] {
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: now)
            
            return [components.year!, components.month!, components.day!, components.hour!, components.minute!, components.second!, components.nanosecond!]
        }

    
    
    
}

enum MessageType: String,Codable {
    case enter = "ENTER"
    case talk = "TALK"
    
    
    func description() -> String {
            switch self {
            case .enter:
                    return "ENTER"
            case .talk:
                    return "TALK"
            }
        }
}


struct ChatMessageResponse: Codable {
    let status: Int
    let message: String
    let data: [ChatMessage]
    
}
