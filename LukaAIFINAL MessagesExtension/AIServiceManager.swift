import Foundation

class AIServiceManager {
    static let shared = AIServiceManager()
    private init() {}
    
    private lazy var directService = DirectAIService.shared
    private lazy var proxyService = ProxyAIService()
    
    func generateResponse(for question: String, completion: @escaping (Result<String, Error>) -> Void) {
        if AppConfig.shouldUseProxy {
            print("🌐 Using proxy service (Production mode)")
            proxyService.generateResponse(for: question, completion: completion)
        } else {
            print("🔑 Using direct API (Development mode)")
            directService.generateResponse(for: question, completion: completion)
        }
    }
}
