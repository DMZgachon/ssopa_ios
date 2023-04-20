//
//  profileDetail.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/04/12.
//

import SwiftUI

struct profileDetail: View {
    
    
    func getProfile() -> UserProfile{
        if let userData = UserDefaults.standard.data(forKey: "userProfile") {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserProfile.self, from: userData)
                return user
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
                return UserProfile.defaultProfile
            }
        } else {
            print("No user data found in UserDefaults")
            return UserProfile.defaultProfile
        }
    }
    
    func sendPush(_ pushMsg: String)-> Bool{
        if(HTTPClient.shared.sendPushNotice(pushMsg)){
            return true
        }else{
            return false
        }
    }
 
    

    
    
    var profile: UserProfile
    
    
    @State private var pushMsg : String = ""
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?

    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack{
                    profileImage(profile: profile, showFullScreenProfileImage: .constant(false))
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Text("프로필 사진 변경")
                            .font(.callout)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    if(profile.authority==UserProfile.Authority.ROLE_ADMIN){
                        Text("관리자")
                            .font(Font.largeTitle)
                            .fontWeight(Font.Weight.bold)
                    }
                    
                }.sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage)
                        .onChange(of: selectedImage) { newImage in
                            if let newImage = newImage {
                                HTTPClient.shared.uploadProfileImage(newImage)
                            }
                        }
                }
                HStack {
                    Text(profile.nickname)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                
                HStack {
                    Text("Email:")
                        .font(.title2)
                        .bold()
                    Text(profile.email)
                        .font(.title2)
                }
                
                if(profile.authority==UserProfile.Authority.ROLE_ADMIN){
                    
                    HStack{
                        TextField(LocalizedStringKey("푸시 메세지"), text: $pushMsg)
                        Button("푸시 보내기") {
                            if(sendPush(pushMsg)==true){
                                pushMsg=""
                            }
                        }
                        .frame(width: 140,height: 30)
                        .overlay{
                            RoundedRectangle(cornerRadius: 6.0).stroke(.gray,lineWidth: 0.5)
                        }
                        .font(.title3)
                        .fontWeight(Font.Weight.bold)
                        .foregroundColor(Color.white)
                        .background(Color.ssopa_orange)
                        .cornerRadius(6.0)
                    }
                }
                
                Spacer()
            }
        .padding()
        .navigationBarTitle("Profile Details", displayMode: .inline)
        
    }
}

struct profileDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        let profile1 = UserProfile.defaultProfile
        let profile2 = UserProfile(email: "ssohye", nickname: "ssohye", profileImage: UserProfile.defaultProfile.profileImage, authority: UserProfile.Authority.ROLE_ADMIN)
        
        ForEach([profile1,profile2], id: \.self) { pro in
            profileDetail(profile: pro)
                .previewDisplayName(pro.authority.rawValue)
                }
    }
}
