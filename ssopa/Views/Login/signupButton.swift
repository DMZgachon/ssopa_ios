//
//  signupButton.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

struct signupButton: View {
    
    func switchToLoginRegister() {
        let newView = Form()
        let rootView = UIHostingController(rootView: newView)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }
    
    var body: some View {
        Button("회원가입"){
            switchToLoginRegister()
        }
            .font(.title3)
            .frame(width: 160,height: 48)
            .overlay{
                RoundedRectangle(cornerRadius: 6.0).stroke(.gray,lineWidth: 0.5)
            }
            .fontWeight(Font.Weight.bold)
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(6.0)
    }
}

struct signupButton_Previews: PreviewProvider {
    static var previews: some View {
        signupButton()
    }
}
