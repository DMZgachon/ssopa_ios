//
//  request.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import UIKit

// 1
enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

enum HTTPError: Error{
    case unknown
}
// 2
class HTTPClient {
    
   static let shared = HTTPClient()
   static var deviceToken: String? = nil
    
    
    func forwardTokenToServer(_ tokenString: String){
        HTTPClient.deviceToken = tokenString
        print("Registering Token: \(tokenString)")
        
        let url = URL.forRegisterToken(tokenString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        
        URLSession.shared.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                // Handle the error
                return
            }
            guard response != nil else {
                // Handle empty response
                return
            }
            guard data != nil else {
                // Handle empty data
                return
            }
            
            
            print("Register Token Complete: \(tokenString)")
            print("Response: \(String(describing: data))")
            // Handle data
        }.resume()
        
    
    }
    
    func syncTokenToServer(_ accessToken: String){
        
        
        let tokenString: String = HTTPClient.deviceToken!
        
        print("Syncing Token")
        
        let url = URL.forSyncToken(tokenString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(accessToken))", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return
            }
            guard response != nil else {
                // Handle empty response
                return
            }
            guard data != nil else {
                // Handle empty data
                return
            }
            print("Response: \(String(describing: response))")
            
            return
            
        
            // Handle data
        }.resume()
        
        
        
        print("SyncToken Token Complete")
        
        
    }
    
    func sendPushNotice(_ notice: String) -> Bool{
        
        let keychain = KeyChain()
        
        let url = URL.forPush(notice: notice)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return
            }
            guard response != nil else {
                // Handle empty response
                return
            }
            guard data != nil else {
                // Handle empty data
                return
            }
            print("Response: \(String(describing: response))")
            
            return
            
        
            // Handle data
        }.resume()
        
        return true
        
    }
    
    func sendSignUpRequest(request: signUpRequest, completion: @escaping (Result<signUpResponse, Error>) -> Void) {
        
        guard let url = URL.forSignUp() else {
            
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(request) else { return }
        urlRequest.httpBody = jsonData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            if let error = error {
                DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                            return
            }
            
            
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "Error", code: 0, userInfo: nil)))
                            }
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseObj = try jsonDecoder.decode(signUpResponse.self, from: data)
                print(responseObj)
                DispatchQueue.main.async {
                                completion(.success(responseObj))
                            }
            } catch {
                DispatchQueue.main.async {
                                completion(.failure(error))
                            }
            }
        }
        
        task.resume()
        

    }
    
    func sendLoginRequest(request: loginRequest, completion: @escaping (Result<loginResponse, Error>) -> Void) {
        
        
        guard let url = URL.forLogin() else {
            
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(request) else { return }
        urlRequest.httpBody = jsonData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            if let error = error {
                DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                            return
            }
            
            
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "Error", code: 0, userInfo: nil)))
                            }
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseObj = try jsonDecoder.decode(loginResponse.self, from: data)
                print(responseObj)
                DispatchQueue.main.async {
                                self.syncTokenToServer(responseObj.data.accessToken)
                                completion(.success(responseObj))
                            }
            } catch {
                DispatchQueue.main.async {
                                completion(.failure(error))
                            }
            }
        }
        
        task.resume()
        

    }
    
    
    
    // 3
    func checkDuplicatedEmail(_ email: String,completion: @escaping (Result<CheckDuplicateEmailResponse, NetworkError>) -> Void) {
        // 4
        guard let url = URL.forCheckDuplicatedEmail(email) else {
            
            return completion(.failure(.badURL))
        }
        // 5
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 6
            guard let data = data, error == nil else {
                
                return completion(.failure(.noData))
            }
            // 7
            guard let isDuplicatedResponse = try? JSONDecoder().decode(CheckDuplicateEmailResponse.self, from: data) else {
            
                return completion(.failure(.decodingError))
            }
            // 8
            completion(.success(isDuplicatedResponse))
            
        }.resume()
        
    }
    
    func loadPost(_ id: Int ,completion: @escaping (Result<Post_Data, NetworkError>) -> Void) {
        // 4
        guard let url = URL.forLoadPost(id) else {
            return completion(.failure(.badURL))
        }
        // 5
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 6
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            // 7
            guard let posts = try? JSONDecoder().decode(Post_Data.self, from: data) else {
                return completion(.failure(.decodingError))
            }
            // 8
            completion(.success(posts))
            
        }.resume()
        
    }
    
    func loadPost(_ id: Int) async throws -> PostResponse {
        do {
            let keychain = KeyChain()
            let url = URL.forLoadPost(id)!
            var request = URLRequest(url: url)
            request.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 401 else {
                // JWT token is expired, try refreshing token
                try await refreshToken()
                // Try loading posts again
                return try await loadPost(id)
            }
            return try JSONDecoder().decode(PostResponse.self, from: data)
        } catch {
            //fatalError("Unable to parse data: \(error)")
            let post: PostResponse = PostResponse(status: 404, message: "notfound", data: PostResponse.Post.defaultPost)
            return post
           
        }
    }
    
    func getNickname(_ email: String,completion: @escaping (Result<getNicknameResponse, NetworkError>) -> Void) {
        // 4
        guard let url = URL.forGetNickname(email) else {
            
            return completion(.failure(.badURL))
        }
        // 5
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 6
            guard let data = data, error == nil else {
                
                return completion(.failure(.noData))
            }
            // 7
            guard let response = try? JSONDecoder().decode(getNicknameResponse.self, from: data) else {
                
                return completion(.failure(.decodingError))
            }
            // 8
            completion(.success(response))
            
        }.resume()
        
    }
    
    func sendSms(_ number: String, completion: @escaping (Result<sendSmsResponse,NetworkError>)-> Void){
        guard let url = URL.forSendSmsCode(number) else {
            
            return completion(.failure(.badURL))
        }
        // 5
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 6
            guard let data = data, error == nil else {
                
                return completion(.failure(.noData))
            }
            // 7
            guard let response = try? JSONDecoder().decode(sendSmsResponse.self, from: data) else {
                
                return completion(.failure(.decodingError))
            }
            // 8
            completion(.success(response))
            
        }.resume()
    }
    
    func checkSmsCode(_ number: String, _ code: String, completion: @escaping (Result<sendSmsResponse,NetworkError>)-> Void){
        guard let url = URL.forCheckSmsCode(number, code) else {
            
            return completion(.failure(.badURL))
        }
        // 5
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 6
            guard let data = data, error == nil else {
                
                return completion(.failure(.noData))
            }
            // 7
            guard let response = try? JSONDecoder().decode(sendSmsResponse.self, from: data) else {
                
                return completion(.failure(.decodingError))
            }
            // 8
            completion(.success(response))
            
        }.resume()
    }
    
    func logout(completion: @escaping (Bool)-> Void){
        let keychain = KeyChain()
        keychain.deleteItem(key: "email")
        keychain.deleteItem(key: "password")
        keychain.deleteItem(key: "accessToken")
        keychain.deleteItem(key: "refreshToken")
        
        return completion(true)
    }
    
    func loadposts(_ category: String, _ page: Int) async throws -> Post_Data {
        do {
            let keychain = KeyChain()
            let url = URL.forLoadPosts(page, category)!
            var request = URLRequest(url: url)
            request.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 401 else {
                // JWT token is expired, try refreshing token
                try await refreshToken()
                // Try loading posts again
                return try await loadposts(category, page)
            }
            return try JSONDecoder().decode(Post_Data.self, from: data)
        } catch {
            let post: Post_Data = Post_Data(status: 404, message: "not found", data: [])
            return post
            fatalError("Unable to parse data: \(error)")
           
        }
    }
    
    
    func loadHotposts() async throws -> Post_Data {
        do {
            let keychain = KeyChain()
            let url = URL.forLoadHotPost()!
            var request = URLRequest(url: url)
            request.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 401 else {
                // JWT token is expired, try refreshing token
                try await refreshToken()
                // Try loading posts again
                return try await loadHotposts()
            }
            return try JSONDecoder().decode(Post_Data.self, from: data)
        } catch {
            // Handle other errors
            fatalError("Unable to parse data: \(error)")
           
        }
    }
    
    
    
    
    func loadMessages(_ roomId: String, _ page: Int) async throws -> ChatMessageResponse {
        do {
            let keychain = KeyChain()
            let url = URL.forLoadMessages(roomId,page)!
            var request = URLRequest(url: url)
            request.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 401 else {
                // JWT token is expired, try refreshing token
                try await refreshToken()
                // Try loading posts again
                return try await loadMessages(roomId, page)
            }
            return try JSONDecoder().decode(ChatMessageResponse.self, from: data)
        } catch {
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                print("Request was cancelled")
                return ChatMessageResponse(status: 999, message: "canceled", data: [])
            }
            // Handle other errors
            //fatalError("Unable to parse data: \(error)")
            return ChatMessageResponse(status: 999, message: "canceled", data: [])
        }
    }
    
    
    func loadChats() async throws -> [Chat] {
        do {
            let keychain = KeyChain()
            let url = URL.forLoadChats()!
            var request = URLRequest(url: url)
            request.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 401 else {
                // JWT token is expired, try refreshing token
                try await refreshToken()
                // Try loading posts again
                return try await loadChats()
            }
            return try JSONDecoder().decode([Chat].self, from: data)
        } catch {
            // Handle other errors
            fatalError("Unable to parse data: \(error)")
        }
    }
    
    
    func refreshToken() async throws {
        do {
            let keychain = KeyChain()
            let url = URL.forRefreshToken()!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let jsonEncoder = JSONEncoder()
            guard let jsonData = try? jsonEncoder.encode(refreshTokenRequest(accessToken: "Bearer \(keychain.getItem(key: "accessToken") ?? "none")", refreshToken: "Bearer \(keychain.getItem(key: "refreshToken") ?? "none")")) else { return }
            request.httpBody = jsonData
            
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "com.example.app", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])
            }
            if httpResponse.statusCode == 200 {
                // Refresh token succeeded, update access token
                let tokens = try JSONDecoder().decode(loginResponse.self, from: data)
                if(keychain.updateItem(value: tokens.data.accessToken, key: "accessToken")){
                    
                }
                if(keychain.updateItem(value: tokens.data.refreshToken, key: "refreshToken")){
                    
                }
            } else if httpResponse.statusCode == 500 {
                // Refresh token expired, call login function
                sendLoginRequest(request: loginRequest(email: keychain.getItem(key: "email") as! String, password: keychain.getItem(key: "password") as! String)){result in
                        switch result {
                        case .success(let response):
                            
                            DispatchQueue.main.async {
                                print("Response message: \(response)")
                                keychain.updateItem(value: response.data.refreshToken, key: "refreshToken")
                                keychain.updateItem(value: response.data.accessToken, key: "accessToken")
                                
                                    }
                            
                        case .failure(let error):
                           
                            print("Error: \(error.localizedDescription)")
                        
                        }
                    }
                }
                
                                     
            else {
                throw NSError(domain: "com.example.app", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Refresh token failed"])
            }
        } catch {
            // Handle errors
            throw NSError(domain: "com.example.app", code: 500, userInfo: [NSLocalizedDescriptionKey: "Refresh token failed: \(error)"])
        }
    }
    
    
    
    func writePost(request: postRequest, completion: @escaping (Result<PostResponse, Error>) -> Void) {
        
        let keychain = KeyChain()
        
        guard let url = URL.forWritePost() else {
            
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(request) else { return }
        urlRequest.httpBody = jsonData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            if let error = error {
                DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                            return
            }
            
            
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "Error", code: 0, userInfo: nil)))
                            }
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseObj = try jsonDecoder.decode(PostResponse.self, from: data)
                print(responseObj)
                DispatchQueue.main.async {
                                completion(.success(responseObj))
                            }
            } catch {
                DispatchQueue.main.async {
                                completion(.failure(error))
                            }
            }
        }
        
        task.resume()
        

    }
    
    
    func getProfile (completion: @escaping (Result<profileResponse, Error>) -> Void) {
        
        let keychain = KeyChain()
        
        guard let url = URL.forGetProfile() else {
            
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")

        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
        
            if let error = error {
                DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                            return
            }
            
            
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "Error", code: 0, userInfo: nil)))
                            }
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseObj = try jsonDecoder.decode(profileResponse.self, from: data)
                print(responseObj)
                DispatchQueue.main.async {
                                completion(.success(responseObj))
                            }
            } catch {
                DispatchQueue.main.async {
                                completion(.failure(error))
                            }
            }
        }
        
        task.resume()
        

    }
    
    
    func sendLike(_ postId: Int, completion: @escaping (Result<likeResponse,NetworkError>)-> Void){
        
        let keychain = KeyChain()
        guard let url = URL.forSendLike(postId) else {
            
            return completion(.failure(.badURL))
        }
        
      
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
        // 5
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // 6
            guard let data = data, error == nil else {
                
                return completion(.failure(.noData))
            }
            // 7
            
            guard let response = try? JSONDecoder().decode(likeResponse.self, from: data) else {
                
                return completion(.failure(.decodingError))
            }
            // 8
            completion(.success(response))
            
        }.resume()
    }
    
    
    func uploadProfileImage(_ image: UIImage) {
        let keychain = KeyChain()
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        let url = URL(string: "https://yourserver.com/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
            
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let fieldName = "profileImage"
        let filename = "profile.jpg"
        let mimeType = "image/jpeg"

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Handle server response here
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            }
        }

        task.resume()
       
    }
}
