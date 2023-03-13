//
//  buttonStyle.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import Foundation
import SwiftUI



struct SignUpButtonStyle: TextFieldStyle {
  
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.text
            .frame(width: 160, height: 48)
            .font(.title3)
            .fontWeight(Font.Weight.bold)
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(6.0)
            .overlay{
                RoundedRectangle(cornerRadius: 6.0).stroke(.gray, lineWidth: 0.5)
               
            }
            
    }
}
