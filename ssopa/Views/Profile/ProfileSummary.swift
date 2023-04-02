//
//  ProfileSummary.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

import SwiftUI

struct ProfileSummary: View {

    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading){
                    Text("하이하이")
                    
                }
                .padding(EdgeInsets.init(top: 0, leading:10, bottom: 0, trailing: 0))
                Spacer()
                
                HStack{
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.ssopa_orange)
                    
                    
                }
                
            }
        }
        
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary()
    }
}
