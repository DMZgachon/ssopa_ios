//
//  ProfileSummary.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

import SwiftUI

struct ProfileSummary: View {
    
    var profile : UserProfile
    @Binding var showFullScreenProfileImage: Bool

    var body: some View {
            HStack{
                profileImage(profile: profile,showFullScreenProfileImage: $showFullScreenProfileImage)
                VStack(alignment: .leading){
                    Text("\(profile.nickname)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.trailing, 5)
                    
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

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: UserProfile.defaultProfile, showFullScreenProfileImage: .constant(false))
    }
}
