//
//  ContentView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/09.
//

import SwiftUI

struct ContentView: View {
    @State var isLoading: Bool = true
    let keychain = KeyChain()// keychain 클래스
    let httpclient = HTTPClient.shared
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var chatmsgvm: chatMessageViewModel
    
    

    
    func saveProfile(){
        httpclient.getProfile(){result in
            switch result {
            case .success(let response):
                
                
                DispatchQueue.main.async {
                    
                    print("Response message: \(response)")

                    do {
                        let encoder = JSONEncoder()
                        let userData = try encoder.encode(response.data)
                        UserDefaults.standard.set(userData, forKey: "userProfile")
                    } catch {
                        print("Error encoding user: \(error.localizedDescription)")
                    }
                        }
                
            case .failure(let error):
               
                print("Error: \(error.localizedDescription)")
            
            }
            
        }

    }
    
    
    
    func sendLogin(_ email: String,_ password: String){
        let request = loginRequest(email: email, password: password)
        let keychain = KeyChain()// jwt 저장을 위한 keychain 클래스
        httpclient.sendLoginRequest(request: request) { result in
            switch result {
            case .success(let response):
                
                
                DispatchQueue.main.async {
                    if(keychain.addItem(key: "email", pwd: email)&&keychain.addItem(key: "password", pwd: password)){
                        
                    }

                    
                    print("Response message: \(response)")
                    if(keychain.addItem(key: "refreshToken", pwd: response.data.refreshToken) == true && keychain.addItem(key: "accessToken", pwd: response.data.accessToken)){
                        saveProfile()
                       // chatmsgvm.registerSocket()
                        
                    }
                        }
                
            case .failure(let error):
               
                print("Error: \(error.localizedDescription)")
            
            }
        }
    
        
    }

    
    
    var body: some View {
        if(keychain.getItem(key: "email") != nil&&keychain.getItem(key: "password") != nil){
            PostList()
                .onAppear(){
                    sendLogin(keychain.getItem(key: "email") as! String , keychain.getItem(key: "password") as! String)
                }
        }else{
            LoginMain()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       
        Group {
            ContentView()
                .environmentObject(postViewModel())
                .environmentObject(chatMessageViewModel())
                .colorScheme(.dark) // HERE
            
            ContentView()
                .environmentObject(postViewModel())
                .environmentObject(chatMessageViewModel())
                .colorScheme(.light) // HERE
        }
        
    }
}
