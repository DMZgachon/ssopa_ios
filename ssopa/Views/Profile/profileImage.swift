//
//  profileImage.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/04/02.
//

import SwiftUI

import SwiftUI

struct profileImage: View {
    var profile: UserProfile
    @Binding var showFullScreenProfileImage: Bool
    
    var body: some View {
        AsyncImage(url: profile.profileImage) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .accessibility(hidden: false)
                    .frame(width:60,height: 60)
                    .clipShape(Circle())
                    .padding(.all, 5)
            }  else if phase.error != nil  {
                VStack {
                    Image("person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .accessibility(hidden: false)
                        .frame(width:60,height: 60)
                        .padding(.all, 5)
                    Text("Please try again.")
                        .font(.title3)
                }
                
            } else {
                ProgressView()
            }
        }.onTapGesture {
            showFullScreenProfileImage.toggle()
        }
    }
}



struct profileImage_Previews: PreviewProvider {
    static var previews: some View {
        profileImage(profile: UserProfile.defaultProfile, showFullScreenProfileImage: .constant(false))
    }
}
