//
//  CheckDupliatedEmailViewModel.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import Foundation
import SwiftUI

class CheckDuplicatedEmailViewModel: ObservableObject {
    
    @Published var emailResponse: CheckDuplicateEmailResponse?
    
    var httpClient = HTTPClient()
    
    init(emailResponse: CheckDuplicateEmailResponse? = nil) {
        self.emailResponse = emailResponse
    }
    
    func checkDuplicated(_ email: String) {
        httpClient.checkDuplicatedEmail(email) { result in
            switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.emailResponse = response
                    }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var isDuplicated: Bool {
        self.emailResponse?.data.duplicated ?? false
    }
    
   
    
}
