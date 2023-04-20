//
//  FavoriteButton.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    let httpclient = HTTPClient.shared
    @Binding var post: Post_Data.Post
    // Add this state property to control the alert presentation
    @State private var showAlert = false
    
    
    var body: some View {
        Button{
            isSet.toggle()
            showAlert.toggle()
            httpclient.sendLike(post.id) { result in
                switch result {
                    case .success(let response):
                        DispatchQueue.main.async {
                            print(response)
                        }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }label: {
            Label("Toggle Favorite",systemImage: isSet ? "heart.fill": "heart")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? Color.ssopa_orange: .gray)
        }.alert(isPresented: $showAlert) { // Add this modifier to show the alert
            Alert(
                title: Text("좋아요 요청"),
                message: Text("The API call was successful."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        @State var post = Post_Data.Post.defaultPost
        ForEach([true,false], id: \.self) { isSet in
            FavoriteButton(isSet: .constant(isSet), post: $post)
                .previewDisplayName(String(isSet))
                }
    }
}
