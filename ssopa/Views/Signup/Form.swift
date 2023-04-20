//
//  Form.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

struct Form: View {
    @State private var email = ""
    @State var showAlert: Bool = false
    @State var AlertTitle: String  = ""
    let httpClient = HTTPClient()
//    @ObservedObject private var DuplicatedVM: CheckDuplicatedEmailViewModel

    
//    init() {
//        self.DuplicatedVM = CheckDuplicatedEmailViewModel()
//    }
    
    var body: some View {
        
           
        
            VStack {
                    Spacer()
                    //Text(DuplicatedVM.isDuplicated ? "중복":"비중복")
                    Text("이메일을 입력해주세요.")
                        .font(.system(size: 26))
                        .fontWeight(.bold)
                        .frame(alignment: Alignment.center)
                        .alert(AlertTitle, isPresented: $showAlert) {
                                    Button("Ok") {}
                                } message: {
                                   
                                }
                    
                    HStack {
                        Image(systemName: textIsAppropriate() ? "mail.fill" : "mail")

                            
                        Spacer()
                        TextField("이메일", text: $email)
                            .autocorrectionDisabled()
                        .keyboardType(UIKeyboardType.emailAddress)
                    }.padding()
                        .padding(.vertical, 10)
                        .overlay(Rectangle().frame(height: 2).padding(.top, 45))
                        .foregroundColor(Color.ssopa_orange)
                        .padding(10)
                    
                
                
                  
                
                    
                Spacer()
                    Button(action: {
                        continue_register()
                        hideKeyboard()
                    }, label: {
                        Text("다음")
                            .padding()
                            .foregroundColor(.black)
                            .edgesIgnoringSafeArea(Edge.Set.bottom)
                            .font(.title3)
                            .frame(width: UIScreen.main.bounds.width,height: 60)
                            .overlay{
                                RoundedRectangle(cornerRadius: 6.0).stroke(.gray,lineWidth: 0.5)
                            }
                            .fontWeight(Font.Weight.bold)
                            .foregroundColor(Color.white)
                            .background(textIsAppropriate() ? Color.ssopa_orange : Color.gray)
                            .cornerRadius(6.0)
                        
                    })
            }
        
            
            
        

    }
    
    func continue_register() {
        if textIsAppropriate()==true{
            checkDuplicated(email){response in
                if response{
                    self.switchToPasswordForm_Login()
                }else{
                    self.switchToPasswordForm_Signup(email: email)
                }
            }
        }
        
    }
    
    func checkDuplicated(_ email: String,completion: @escaping (Bool) -> Void){
        httpClient.checkDuplicatedEmail(email) { result in
            switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        if(response.data.duplicated==true){
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

    func textIsAppropriate() -> Bool {
        
        if checkEmail(str: email){
            return true
        }
        else{
            AlertTitle = "올바른 형식의 이메일을 작성해주세요."
            showAlert.toggle()
            return false
        }
          
    }
    
    func checkEmail(str: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
    
    func getAlert() -> Alert {
            Alert(title: Text(AlertTitle))
        }
    
    func switchToPasswordForm_Login() {
        let newView = passwordForm_Login(email: email)
        let rootView = UIHostingController(rootView: newView)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }
    
    func switchToPasswordForm_Signup(email: String) {
          let newView = passwordForm_Signup(email: email)
        let rootView = UIHostingController(rootView: newView)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }
}

struct passwordForm_Login: View {
    
    

    @State private var nickname = ""
    @State private var OriginNickname : getNicknameResponse
    @ObservedObject private var getNicknameVM: getNicknameViewModel
    @State private var password = ""
    var email: String
    let httpclient = HTTPClient.shared
    
    
    init(email: String) {
        self.email=email
        self.getNicknameVM = getNicknameViewModel()
        self.OriginNickname = getNicknameResponse(status: 404, message: "not Found", data: getNicknameResponse.ResponseData(nickname: ""))
        
    }
    
    
    func switchToMain() {
        

        let newView = PostList().environmentObject(postViewModel())
        let rootView = UIHostingController(rootView: newView)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }
    
    func saveProfile(){
        httpclient.getProfile(){result in
            switch result {
            case .success(let response):
                
                
                DispatchQueue.main.async {
                    
                    print("Response message: \(response)")

                    do {
                        let encoder = JSONEncoder()
                        let userData = try encoder.encode(response.data)
                        UserDefaults.standard.set(userData, forKey: "userProfile")
                        switchToMain()
                    } catch {
                        print("Error encoding user: \(error.localizedDescription)")
                    }
                        }
                
            case .failure(let error):
               
                print("Error: \(error.localizedDescription)")
            
            }
            
        }

    }
    
    
    
    func sendLogin(_ email: String,_ password: String){
        let request = loginRequest(email: email, password: password)
        let keychain = KeyChain()// jwt 저장을 위한 keychain 클래스
        httpclient.sendLoginRequest(request: request) { result in
            switch result {
            case .success(let response):
                
                
                DispatchQueue.main.async {
                    if(keychain.addItem(key: "email", pwd: email)&&keychain.addItem(key: "password", pwd: password)){
                        
                    }

                    
                    print("Response message: \(response)")
                    if(keychain.addItem(key: "refreshToken", pwd: response.data.refreshToken) == true && keychain.addItem(key: "accessToken", pwd: response.data.accessToken)){
                        saveProfile()
                        
                    }
                        }
                
            case .failure(let error):
               
                print("Error: \(error.localizedDescription)")
            
            }
        }
    
        
    }

    
    
    func textIsAppropriate() -> Bool {

        
        if checkPassword(str: password){
            
            return true
        }
        else{
            
            return false
        }
          
    }
    
    func fetchData() async {
            do {
                let url = URL.forGetNickname(email)!
                let (data, _) = try await URLSession.shared.data(from: url)
                OriginNickname = try JSONDecoder().decode(getNicknameResponse.self, from: data)
                self.nickname=OriginNickname.data.nickname
            } catch {
                
            }
        }
    
    
    
    func checkPassword(str: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자
        return  NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
    
   var body: some View {
       
           VStack {
                   Spacer()
               VStack{
                   Text("비밀번호를 입력해주세요.")
                       .font(.system(size: 26))
                       .fontWeight(.bold)
                       .frame(alignment: Alignment.center)
                   
                   Text("\(nickname) 님 다시 만나서 반가워요!")
                       
               }
                   
                   HStack {
                       Image(systemName: textIsAppropriate() ? "lock.open.fill" : "lock")
                       Spacer()
                       SecureField("비밀번호", text: $password)
                   }.padding()
                       .padding(.vertical, 10)
                       .overlay(Rectangle().frame(height: 2).padding(.top, 45))
                       .foregroundColor(Color.ssopa_orange)
                       .padding(10)
               
               
                 
               
                   
               Spacer()
                   Button(action: {
                       sendLogin(email, password)
                   }, label: {
                       Text("로그인 하기")
                           .padding()
                           .foregroundColor(.black)
                           .edgesIgnoringSafeArea(Edge.Set.bottom)
                           .font(.title3)
                           .frame(width: UIScreen.main.bounds.width,height: 60)
                           .overlay{
                               RoundedRectangle(cornerRadius: 6.0).stroke(.gray,lineWidth: 0.5)
                           }
                           .fontWeight(Font.Weight.bold)
                           .foregroundColor(Color.white)
                           .background(textIsAppropriate() ? Color.ssopa_orange : Color.gray)
                           .cornerRadius(6.0)
                       
                   })
           }
       .task() {
                     await fetchData()
                 }
                   
   }
}


struct passwordForm_Signup: View {
    
    @State private var password = ""
    var email: String
    
    func textIsAppropriate() -> Bool {
        
        if checkPassword(str: password){
            return true
        }
        else{
            
            return false
        }
          
    }
    
    func checkPassword(str: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자
        return  NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
    
    func switchToNumberForm(email: String, password: String ) {
        
    
          let newView = numberForm_Signup(email: email, password: password)
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
       
           VStack {
                   Spacer()
                   Text("비밀번호를 입력해주세요.")
                       .font(.system(size: 26))
                       .fontWeight(.bold)
                       .frame(alignment: Alignment.center)
                    Text("SSOPA에 회원가입하고 같이 만나요!")
                   
                   HStack {
                       
                       Image(systemName: textIsAppropriate() ? "lock.fill" : "lock")
                       Spacer()
                       SecureField("비밀번호", text: $password)
                           
                       Spacer()
                       
                   }.padding()
                       .padding(.vertical, 10)
                       .overlay(Rectangle().frame(height: 2).padding(.top, 45))
                       .foregroundColor(Color.ssopa_orange)
                       .padding(10)
               
               
                
                   
               Spacer()
                   Button(action: {
                       self.switchToNumberForm(email: email, password: password)
                   }, label: {
                       Text("다음")
                           .padding()
                           .foregroundColor(.black)
                           .edgesIgnoringSafeArea(Edge.Set.bottom)
                           .font(.title3)
                           .frame(width: UIScreen.main.bounds.width,height: 60)
                           .overlay{
                               RoundedRectangle(cornerRadius: 6.0).stroke(.gray,lineWidth: 0.5)
                           }
                           .fontWeight(Font.Weight.bold)
                           .foregroundColor(Color.white)
                           .background(textIsAppropriate() ? Color.ssopa_orange : Color.gray)
                           .cornerRadius(6.0)
                       
                   })
           }
       }
   }


struct numberForm_Signup: View {
    
    func switchToVerificationCode(email: String, password: String , number: String) {
        
    
          let newView = verification_Signup(email: email, password: password, number: number)
        let rootView = UIHostingController(rootView: newView)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }

    
    @State private var number = ""
    var email: String
    var password: String
   
    
    func textIsAppropriate() -> Bool {
        
        if checkNumber(str: number){
            return true
        }
        else{
            
            return false
        }
          
    }
    
    func checkNumber(str: String) -> Bool {
        let regex = "^01[0-1, 7][0-9]{7,8}$"
        return  NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
    
    func sendSms(_ number: String) {
        let httpClient = HTTPClient.shared
        httpClient.sendSms(number) { result in
            switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        print(response)
                    }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
     
    
   var body: some View {
       
       
       
       
           VStack {
                   Spacer()
                   Text("핸드폰 번호를 입력해주세요")
                       .font(.system(size: 26))
                       .fontWeight(.bold)
                       .frame(alignment: Alignment.center)
                    Text("SSOPA에 회원가입하고 같이 만나요!")
                   
                   HStack {
                       
                       Image(systemName: textIsAppropriate() ? "lock.fill" : "lock")
                       Spacer()
                       TextField("핸드폰 번호", text: $number)
                           .keyboardType(UIKeyboardType.numberPad)
                           
                       Spacer()
                       
                   }.padding()
                       .padding(.vertical, 10)
                       .overlay(Rectangle().frame(height: 2).padding(.top, 45))
                       .foregroundColor(Color.ssopa_orange)
                       .padding(10)
               
               
                
                   
               Spacer()
                   Button(action: {
                       sendSms(number)
                       self.switchToVerificationCode(email: email, password: password, number: number)
                   }, label: {
                       Text("다음")
                           .padding()
                           .foregroundColor(.black)
                           .edgesIgnoringSafeArea(Edge.Set.bottom)
                           .font(.title3)
                           .frame(width: UIScreen.main.bounds.width,height: 60)
                           .overlay{
                               RoundedRectangle(cornerRadius: 6.0).stroke(.gray,lineWidth: 0.5)
                           }
                           .fontWeight(Font.Weight.bold)
                           .foregroundColor(Color.white)
                           .background(textIsAppropriate() ? Color.ssopa_orange : Color.gray)
                           .cornerRadius(6.0)
                       
                   })
           }
       }
   }


struct verification_Signup: View {
    
    @State private var code = ""
    @State var showAlert: Bool = false
    @State var AlertTitle: String  = ""
    var email: String
    var password: String
    var number: String
   
    
    func switchToNameForm(email: String, password: String , number: String) {
        
    
          let newView = name_Signup(code: code, email: email, password: password, number: number)
        let rootView = UIHostingController(rootView: newView)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }
    
    
    func checkCode(_ number: String,_ code: String) {
        let httpClient = HTTPClient.shared
        httpClient.checkSmsCode(number,code) { result in
            switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        if(response.data.success==true){
                            switchToNameForm(email: email, password: password, number: number)
                        }else{
                            AlertTitle = "인증번호가 올바르지 않습니다."
                            showAlert.toggle()
                        }
                    }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
     
    
   var body: some View {
       
       
       
       
           VStack {
                   Spacer()
                   Text("인증번호를 입력해주세요")
                       .font(.system(size: 26))
                       .fontWeight(.bold)
                       .frame(alignment: Alignment.center)
                    Text("거의 다 왔어요!")
                    Text(AlertTitle)
                   
            
                   
                   HStack {
                       
                       Image(systemName: "lock")
                       Spacer()
                       TextField("인증 번호", text: $code)
                           .keyboardType(UIKeyboardType.numberPad)
                           
                       Spacer()
                       
                   }.padding()
                       .padding(.vertical, 10)
                       .overlay(Rectangle().frame(height: 2).padding(.top, 45))
                       .foregroundColor(Color.ssopa_orange)
                       .padding(10)
               
               
                
                   
               Spacer()
                   Button(action: {
                       checkCode(number,code)
                   }, label: {
                       Text("다음")
                           .padding()
                           .foregroundColor(.black)
                           .edgesIgnoringSafeArea(Edge.Set.bottom)
                           .font(.title3)
                           .frame(width: UIScreen.main.bounds.width,height: 60)
                           .overlay{
                               RoundedRectangle(cornerRadius: 6.0).stroke(.gray,lineWidth: 0.5)
                           }
                           .fontWeight(Font.Weight.bold)
                           .foregroundColor(Color.white)
                           .background(Color.ssopa_orange)
                           .cornerRadius(6.0)
                       
                   })
           }
           .alert(AlertTitle, isPresented: $showAlert) {
                       Button("Ok") {}
                   } message: {
                      
                   }
       }
   }

struct name_Signup: View {
    
    var code : String
    var email: String
    var password: String
    var number: String
    @State var showAlert: Bool = false
    @State var AlertTitle: String  = ""
    @State private var name = ""
    let httpclient = HTTPClient.shared
   
    
    
    func sendSignup(_ phonenumber: String,_ email: String,_ password: String,_ name: String){
        let request = signUpRequest(email: email, password: password, name: name, phonenumber: phonenumber)
        
        httpclient.sendSignUpRequest(request: request) { result in
            switch result {
            case .success(let response):
                
                
                DispatchQueue.main.async {
                    AlertTitle = "회원가입에 성공 했습니다."
                    showAlert.toggle()
                    print("Response message: \(response)")
                            sendLogin(email, password)
                        }
                
            case .failure(let error):
                AlertTitle = "회원가입에 실패 했습니다."
                showAlert.toggle()
                print("Error: \(error.localizedDescription)")
               
            }
        }
    
        
    }
    
    
    
    func switchToMain() {
        

        let newView = PostList()
        let rootView = UIHostingController(rootView: newView)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }
    
    
    
    func sendLogin(_ email: String,_ password: String){
        let request = loginRequest(email: email, password: password)
        let keychain = KeyChain()// jwt 저장을 위한 keychain 클래스
        httpclient.sendLoginRequest(request: request) { result in
            switch result {
            case .success(let response):
                
                
                DispatchQueue.main.async {
                    
                    print("Response message: \(response)")
                    if(keychain.addItem(key: "refreshToken", pwd: response.data.refreshToken) == true && keychain.addItem(key: "accessToken", pwd: response.data.accessToken)){
                        switchToMain()
                    }
                        }
                
            case .failure(let error):
               
                print("Error: \(error.localizedDescription)")
                
            }
        }
    
        
    }
    

    
    
    
     
    
   var body: some View {
       
       
       
       
           VStack {
                   Spacer()
                   Text("이름을 입력해주세요")
                       .font(.system(size: 26))
                       .fontWeight(.bold)
                       .frame(alignment: Alignment.center)
                    Text("마지막이에요!")
            
                   
                   HStack {
                       
                       Image(systemName: "lock")
                       Spacer()
                       TextField("이름", text: $name)
                           .keyboardType(UIKeyboardType.default)
                           
                       Spacer()
                       
                   }.padding()
                       .padding(.vertical, 10)
                       .overlay(Rectangle().frame(height: 2).padding(.top, 45))
                       .foregroundColor(Color.ssopa_orange)
                       .padding(10)
               
               
                
                   
               Spacer()
                   Button(action: {
                       sendSignup(number, email, password, name)
                   }, label: {
                       Text("다음")
                           .padding()
                           .foregroundColor(.black)
                           .edgesIgnoringSafeArea(Edge.Set.bottom)
                           .font(.title3)
                           .frame(width: UIScreen.main.bounds.width,height: 60)
                           .overlay{
                               RoundedRectangle(cornerRadius: 6.0).stroke(.gray,lineWidth: 0.5)
                           }
                           .fontWeight(Font.Weight.bold)
                           .foregroundColor(Color.white)
                           .background(Color.ssopa_orange)
                           .cornerRadius(6.0)
                       
                   })
           }
       }
   }







struct Form_Previews: PreviewProvider {
    static var previews: some View {
        Form().previewDisplayName("email")
        passwordForm_Login(email: "ssohye@icloud.com").previewDisplayName("password_login")
        passwordForm_Signup(email:"ssohye@icloud.com").previewDisplayName("password_Singup")
        numberForm_Signup(email:"ssohye@icloud.com",password:"jiho0304").previewDisplayName("number_signup")
        verification_Signup(email: "ssohye@icloud.com",password: "jiho0304",number: "01028686435")
            .previewDisplayName("verification_signup")
        name_Signup(code: "1213", email: "ssohye@icloud.com", password: "jiho0304", number: "01028686435")
            .previewDisplayName("name_signup")

    }
}


