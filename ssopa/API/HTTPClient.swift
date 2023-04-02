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
            // Handle other errors
            fatalError("Unable to parse data: \(error)")
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
}
