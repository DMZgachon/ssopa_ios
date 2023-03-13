//
//  LoginMain.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

struct LoginMain: View {
    
    
    
    var body: some View {
    
        
        
    
            VStack {
                Spacer()
                Text("SSOPA 와 함께하는 학교 생활")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.ssopa_orange)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                
                Spacer()
                
                VStack {
                    HStack{
                        
                        LoginButton()
                        
                        signupButton()
                    
                        
                    }
                    
                    .padding(70)
                    Link(destination: URL(string:"https://ssopa02.com")!) {
                        Text("Copyright 2023, DMZ All rights reserved")
                            .font(.caption2)
                            .foregroundColor(Color.black)
                    }
                }
                
                
            }
        }
    
}

struct LoginMain_Previews: PreviewProvider {
    static var previews: some View {
        LoginMain()
    }
}
