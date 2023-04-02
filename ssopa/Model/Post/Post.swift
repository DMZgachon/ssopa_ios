//
//  Post.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import Foundation


struct Post_Data:  Codable{
    let status: Int
    let message: String
    let data: [Post]
    
    struct Post:Hashable, Codable,Identifiable{
        var id: Int
        var title: String
        var writer: String
        var content: String
        var view_cnt: Int
        var noticeYn: Bool
        var modified_date: Array<Int>

    }
}



