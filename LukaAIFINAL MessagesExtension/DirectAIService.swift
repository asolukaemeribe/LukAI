import Foundation

class DirectAIService {
    static let shared = DirectAIService()
    private init() {}
    
    // Groq API - Free and much faster than OpenAI
    private let apiKey = AppConfig.groqAPIKey ?? ""
    private let baseURL = "https://api.groq.com/openai/v1/chat/completions"
    
    func generateResponse(for question: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !apiKey.isEmpty else {
            completion(.failure(NSError(domain: "DirectAIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "API key not configured"])))
            return
        }
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "DirectAIService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        print("🚀 Making API request to Groq...")
        print("📝 Question: \(question)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "llama-3.1-8b-instant",
            "messages": [
                [
                    "role": "system",
                    "content": "You are LukAI, a helpful AI assistant. Provide clear and helpful answers."
                ],
                [
                    "role": "user",
                    "content": question
                ]
            ],
            "max_tokens": 4000,
            "temperature": 0.7,
            "top_p": 1.0,
            "stream": false
            // Removed the "stop": nil line that was causing the error
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "DirectAIService", code: 3, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            print("📊 HTTP Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DirectAIService", code: 4, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Raw response length: \(responseString.count) characters")
            }
            
            if httpResponse.statusCode != 200 {
                do {
                    let errorResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let error = errorResponse?["error"] as? [String: Any],
                       let message = error["message"] as? String {
                        completion(.failure(NSError(domain: "DirectAIService", code: 5, userInfo: [NSLocalizedDescriptionKey: "API Error: \(message)"])))
                        return
                    }
                } catch {}
                completion(.failure(NSError(domain: "DirectAIService", code: 6, userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode)"])))
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                if let choices = jsonResponse?["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    
                    print("✅ Success: \(content.count) characters")
                    completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else {
                    completion(.failure(NSError(domain: "DirectAIService", code: 7, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
