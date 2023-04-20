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
    

    
    
    var body: some View {
        if(keychain.getItem(key: "email") != nil&&keychain.getItem(key: "password") != nil){
            PostList()
        }else{
            LoginMain()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(postViewModel())
    }
}
