//
//  URLExtensions.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import Foundation

extension URL{
    
    static func forCheckDuplicatedNumber(_ number: String) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/auth/check/duplicatedNumber?phonenumber=\(number)")
    }
    
    static func forCheckDuplicatedEmail(_ email: String) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/auth/check/duplicatedEmail?email=\(email)")
    }
    
    static func forLoadPost(_ id: Int) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/post/loadinfo/\(id)")
    }
    
    
    static func forLoadPosts(_ page: Int,_ category: String) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/post/load/\(category)/\(page)")
    }
    
    static func forGetNickname(_ email: String) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/auth/get/nickname?email=\(email)")
    }
    
    static func forSendSmsCode(_ number: String) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/auth/check/sendSMS?to=\(number)")
    }
    
    static func forCheckSmsCode(_ number: String, _ code: String) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/auth/check/verifySMS?to=\(number)&code=\(code)")
    }
    
    static func forSignUp() -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/auth/signup")
    }
    
    
    static func forLogin() -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/auth/login")
    }
    
    static func forWritePost() -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/post/add")
    }
    
    static func forRefreshToken() -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/auth/reissue")
    }
    
    static func forLoadChats() -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/chat/rooms")
    }
    
    static func forLoadHotPost() -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/post/hot")
    }
    
    static func forGetProfile() -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/member/me")
    }
    
    static func forLoadMessages(_ roomId: String, _ page: Int) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/chat/load/room/\(roomId)/\(page)")
    }
    
    static func forSendLike(_ postId: Int) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/post/heart/\(postId)")
    }
    
    static func forRegisterToken(_ token: String) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/auth/registertoken?deviceToken=\(token)")
    }
    

    static func forPush(notice: String) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/member/push?notice=\(notice)".encodeUrl()!)
    }
    
    static func forSyncToken(_ token: String) -> URL? {
        return URL(string: "https://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/member/synctoken?deviceToken=\(token)")
    }
    


    
    
    
    
    
    
}
