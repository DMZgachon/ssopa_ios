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
        var like_cnt: Int
        
        static let defaultPost = Post(id: 1, title: "테스트글", writer: "관리자", content: "없어용", view_cnt: 4, noticeYn: false, modified_date: [2022,03,04,02,14,333333], like_cnt: 5)

    }
}



