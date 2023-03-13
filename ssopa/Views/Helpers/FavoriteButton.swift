//
//  FavoriteButton.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    var body: some View {
        Button{
            isSet.toggle()
        }label: {
            Label("Toggle Favorite",systemImage: isSet ? "star.fill": "star")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .yellow: .gray)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([true,false], id: \.self) { isSet in
            FavoriteButton(isSet: .constant(isSet))
                .previewDisplayName(String(isSet))
                }
    }
}
