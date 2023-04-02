//
//  LoginMain.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

struct LoginMain: View {
    
    @State private var isAnimating = false
    
    
    
    
    var body: some View {
        
        
        
        
        VStack {
            Spacer()
            Text("SSOPA 와 함께하는 학교 생활!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.ssopa_orange)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                .opacity(isAnimating ? 1.0 : 0.0) // add an animation effect
            
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
            
            
        }.onAppear{
            withAnimation(.easeInOut(duration: 1.0)) {
                self.isAnimating = true
            }
        }
    }
}

struct LoginMain_Previews: PreviewProvider {
    static var previews: some View {
        LoginMain()
    }
}
