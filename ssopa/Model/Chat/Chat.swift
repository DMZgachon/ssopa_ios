//
//  Chat.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/31.
//

import Foundation

struct Chat:  Codable,Identifiable{
    
    var roomId: String
    var roomName: String
    var founder_id: Int
    var created_Date: Array<Int>
    
    var id: String{
        return roomId
    }
}



