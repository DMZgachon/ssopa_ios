//
//  getNicknameViewModel.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import Foundation
import SwiftUI

class getNicknameViewModel: ObservableObject {
    
    @Published var response: getNicknameResponse?
    
    var httpClient = HTTPClient()
    
    init(Response: getNicknameResponse? = nil) {
        self.response = Response
    }
    
    func getNickname(_ email: String) {
        httpClient.getNickname(email) { result in
            switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.response = response
                    }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var nickname: String {
        self.response?.data.nickname ?? "닉네임 로딩 실패"
    }
    
   
    
}
