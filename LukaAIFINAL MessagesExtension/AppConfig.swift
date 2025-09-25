import Foundation

enum BuildConfiguration {
    case debug
    case release
    
    static var current: BuildConfiguration {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }
}

struct AppConfig {
    // Server URLs for different environments
    static let productionServerURL = "https://lukai-server-m174aizrq-asolukaemeribes-projects.vercel.app"
    static let developmentServerURL = "http://localhost:3000/api/chat"
    
    static var shouldUseProxy: Bool {
        switch BuildConfiguration.current {
        case .debug:
            // Use direct API in debug mode
            return false
        case .release:
            // Always use proxy in production
            return true
        }
    }
    
    static var serverURL: String {
        switch BuildConfiguration.current {
        case .debug:
            return developmentServerURL
        case .release:
            return productionServerURL
        }
    }
    
    static var groqAPIKey: String? {
        // Only return API key in debug mode
        guard BuildConfiguration.current == .debug else { return nil }
        
        // Try environment variables first
        if let envKey = ProcessInfo.processInfo.environment["GROQ_API_KEY"] {
            return envKey
        }
        
        // Try plist file (development only)
        guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["GROQ_API_KEY"] as? String else {
            return nil
        }
        
        return key
    }
}
