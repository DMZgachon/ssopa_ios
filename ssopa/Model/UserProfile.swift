//
//  UserProfile.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import Foundation

struct UserProfile: Identifiable,Codable,Hashable{
    
    var email: String
    var nickname: String
    var profileImage: URL?
    var authority: Authority
    
    var id: String {
            return email
        }


    static let defaultProfile = UserProfile(email: "ssohye@icloud.com", nickname: "행복한 물고기",profileImage: URL(string: "https://cdn.mhns.co.kr/news/photo/202212/539489_655354_1316.jpg"), authority: UserProfile.Authority.ROLE_USER)
    
    
    enum Authority: String,Codable{
        case ROLE_ADMIN
        case ROLE_USER
    }
        
                        

   
}
