import Foundation
import UIKit

class ProxyAIService {
    func generateResponse(for question: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: AppConfig.serverURL) else {
            completion(.failure(AIError.invalidURL))
            return
        }
        
        print("🌐 Making proxy request to: \(AppConfig.serverURL)")
        print("📝 Question: \(question)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        let requestBody: [String: Any] = [
            "question": question,
            "userId": UIDevice.current.identifierForVendor?.uuidString ?? "anonymous",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Proxy error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(AIError.noData))
                return
            }
            
            print("📊 Proxy Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                completion(.failure(AIError.noData))
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                if let answer = jsonResponse?["answer"] as? String {
                    print("✅ Proxy Success: \(answer.count) characters")
                    completion(.success(answer.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else if let error = jsonResponse?["error"] as? String {
                    completion(.failure(AIError.apiError(error)))
                } else {
                    completion(.failure(AIError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum AIError: Error, LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .invalidResponse:
            return "Invalid response format"
        case .apiError(let message):
            return "API Error: \(message)"
        }
    }
}
