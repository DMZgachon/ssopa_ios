//
//  ProfileSummary.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

import SwiftUI

struct ProfileSummary: View {
    var userprofile: UserProfile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(userprofile.nickname)
                    .bold()
                    .font(.title)

             
                Text("역할: \(userprofile.Role.rawValue)")
                
            }
        }
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(userprofile: UserProfile.default)
    }
}
