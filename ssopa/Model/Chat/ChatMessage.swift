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
    var time: Array<Int>
    
    
    var id: Int{
        return message_id
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
