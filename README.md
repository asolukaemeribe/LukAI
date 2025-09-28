# LukAI - AI Chatbot iMessage Extension

- An advanced AI-powered iMessage extension that brings conversational AI directly into your Messages app. Built with Swift and powered by multiple AI providers with intelligent routing and context awareness.

- Built to be convenient: using LLMs has never been this easy; users can launch LukAI straight from their iMessage Extensions Menu, send LukAI a message, and have the query sent in an aesthetic format straight to a one-on-one message thread or group chat

**🚀 Instant Access** - No app switching, available wherever you text
**👥 Easy Sharing** - Copy responses directly to any chat
**📱 Native Experience** - Feels like texting a smart friend
**🔒 Privacy First** - Secure, personal AI assistant in your pocket

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![AI](https://img.shields.io/badge/AI-GPT--4%20%7C%20Claude%20%7C%20Groq-purple.svg)

## Features

### **Core AI Capabilities**
- **Multi-Provider AI Integration** - Groq, OpenAI, Claude with intelligent routing
- **Smart Response Formatting** - Beautiful, structured responses optimized for iMessage
- **Real-time Streaming** - Live response generation with typing indicators

### 📱 **User Experience**
- **Native iMessage Integration** - Seamless Messages app experience
- **Adaptive UI** - Works in both compact and expanded modes
- **Copy-to-Chat** - One-tap response sharing
- **Offline Support** - Core ML models for internet-free usage

## 🏗️ **Architecture**

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   iMessage      │    │   AI Service     │    │   AI Providers  │
│   Extension     │◄──►│   Manager        │◄──►│   (Groq/OpenAI) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                                              │
         ▼                                              ▼
┌─────────────────┐                            ┌─────────────────┐
│   Local UI      │                            │   Vercel Proxy  │
│   Components    │                            │   Server        │
└─────────────────┘                            └─────────────────┘
```

### **Development vs Production**
- **Debug Mode**: Direct API calls with environment variables
- **Release Mode**: Secure proxy server deployment via Vercel
- **Automatic Switching**: Build configuration determines API routing

## **Future Plans**

While the current version delivers a robust iMessage AI experience, I'm excited about expanding into advanced AI/ML capabilities:

### **Advanced AI Features**
- **Multi-Modal AI** - Image analysis and voice processing integration
- **Conversation Memory** - Semantic search through chat history using embeddings
- **Intelligent Model Routing** - Automatic AI provider selection based on query type
- **Sentiment Analysis** - Emotion-aware responses that adapt to user mood
- **Personalization Engine** - AI that learns user preferences and communication style

### **ML Engineering & Performance**
- **Local AI Fallback** - On-device Core ML models for offline functionality
- **A/B Testing Framework** - Data-driven response optimization
- **Predictive Caching** - ML-powered performance improvements
- **Custom Model Training** - Fine-tuned models on conversation data
- **Analytics Dashboard** - Conversation insights and performance metrics

### **Enhanced User Experience**
- **Voice Input/Output** - Hands-free interaction capabilities
- **Real-time Collaboration** - Multi-user conversation features
- **External API Integration** - Connect with calendars, notes, and productivity apps
- **Advanced Response Formatting** - Rich media and interactive message components



