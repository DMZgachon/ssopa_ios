//
//  FullSizeImageView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/04/06.
//

import SwiftUI

struct FullSizeImageView: View {
    @State var image_url : URL
    @Binding var showFullScreenProfileImage: Bool
    var body: some View {
        if showFullScreenProfileImage{
            ZStack {
                Color.black
                    .opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    AsyncImage(url: image_url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .accessibility(hidden: false)
                        } else if phase.error != nil {
                            Text("Please try again.")
                                .font(.title3)
                        } else {
                            ProgressView()
                        }
                    }
                    Spacer()
                }
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showFullScreenProfileImage.toggle()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct FullSizeImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullSizeImageView(image_url: UserProfile.defaultProfile.profileImage!, showFullScreenProfileImage: .constant(true))
    }
}
