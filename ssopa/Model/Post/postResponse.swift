//
//  postResponse.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/25.
//

import Foundation


struct PostResponse:  Codable{
    let status: Int
    let message: String
    let data: Post
    
    struct Post :Hashable, Codable,Identifiable{
        var id: Int
        var title: String
        var content: String
        var created_date: Array<Int>
        var modified_date: Array<Int>
        var view_cnt: Int
        var noticeYn: Bool
        var like_cnt: Int
        var writer: String
        var category: String
        var deleteYn: Bool
        var likeYn: Bool
        
        
        static let defaultPost = Post(id: 1, title: "d", content: "s", created_date: [2022,02,03,01,01,233333], modified_date: [2022,03,01,01,233333], view_cnt: 4, noticeYn: false, like_cnt: 4, writer: "뀨", category: "FREE",deleteYn: false,likeYn: true)

    }
}
