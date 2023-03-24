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
    
    // json을 Post_data 타입으로 파싱
    func loadposts (_ category: String, _ page: Int) async throws -> Post_Data {
            do {
                let keychain = KeyChain()
                let url = URL.forLoadPosts(page, category)!
                var request = URLRequest(url: url)
                request.addValue("Bearer \(keychain.getItem(key: "accessToken") ?? "null")", forHTTPHeaderField: "Authorization")
                let (data, _) = try await URLSession.shared.data(for: request)
                return try JSONDecoder().decode(Post_Data.self, from: data)
            } catch {
                fatalError("Unable to parse data : \(error)")
            }
        }
}
