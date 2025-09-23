import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var sendResponseButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentResponse: String = ""
    private var isUISetup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfessionalUI()
    }
    
    private func setupProfessionalUI() {
        guard !isUISetup else { return }
        
        setupBlackBackground()
        setupCustomTextField()
        setupProfessionalButtons()
        setupResponseTextView()
        
        // Create stack view with adaptive layout
        let stack = UIStackView(arrangedSubviews: [
            questionTextField,
            askButton,
            responseTextView,
            sendResponseButton
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .fill
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        // Constraints that work in both compact and expanded modes
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        // Fixed heights for essential elements
        NSLayoutConstraint.activate([
            questionTextField.heightAnchor.constraint(equalToConstant: 44),
            askButton.heightAnchor.constraint(equalToConstant: 44),
            sendResponseButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Flexible height for response view with priorities
        let minHeightConstraint = responseTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        minHeightConstraint.priority = UILayoutPriority(999)
        minHeightConstraint.isActive = true
        
        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: responseTextView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: responseTextView.centerYAnchor)
        ])
        
        activityIndicator.style = .medium
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        
        isUISetup = true
    }
    
    private func setupBlackBackground() {
        view.backgroundColor = .black
    }
    
    private func setupCustomTextField() {
        // Placeholder with gray and more visible
        let placeholderText = NSAttributedString(
            string: "Ask me anything...",
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ]
        )
        questionTextField.attributedPlaceholder = placeholderText
        
        questionTextField.font = UIFont.systemFont(ofSize: 16)
        questionTextField.borderStyle = .none
        questionTextField.backgroundColor = .white
        questionTextField.textColor = .black
        questionTextField.layer.cornerRadius = 12
        questionTextField.layer.borderWidth = 1
        questionTextField.layer.borderColor = UIColor.systemGray4.cgColor
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
        questionTextField.leftView = paddingView
        questionTextField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
        questionTextField.rightView = rightPaddingView
        questionTextField.rightViewMode = .always
        
        questionTextField.delegate = self
        
        // Auto-capitalization and correction
        questionTextField.autocapitalizationType = .sentences
        questionTextField.autocorrectionType = .yes
        questionTextField.spellCheckingType = .yes
    }
    
    private func setupProfessionalButtons() {
        // Ask button
        askButton.setTitle("✨ Ask LukAI", for: .normal)
        askButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        askButton.backgroundColor = .systemBlue
        askButton.setTitleColor(.white, for: .normal)
        askButton.layer.cornerRadius = 12
        
        // Send button
        sendResponseButton.setTitle("📋 Copy Response", for: .normal)
        sendResponseButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        sendResponseButton.backgroundColor = .systemGreen
        sendResponseButton.setTitleColor(.white, for: .normal)
        sendResponseButton.layer.cornerRadius = 12
        sendResponseButton.isEnabled = false
        
        updateSendButtonState()
    }
    
    private func setupResponseTextView() {
        responseTextView.font = UIFont.systemFont(ofSize: 15)
        responseTextView.backgroundColor = .white
        responseTextView.textColor = .black
        responseTextView.layer.cornerRadius = 12
        responseTextView.layer.borderWidth = 1
        responseTextView.layer.borderColor = UIColor.systemGray4.cgColor
        responseTextView.isEditable = false
        responseTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        responseTextView.isScrollEnabled = true
        responseTextView.showsVerticalScrollIndicator = true
    }
    
    private func updateSendButtonState() {
        if sendResponseButton.isEnabled {
            sendResponseButton.alpha = 1.0
            sendResponseButton.transform = .identity
        } else {
            sendResponseButton.alpha = 0.6
            sendResponseButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @IBAction func askButtonTapped(_ sender: UIButton) {
        // Hide keyboard
        questionTextField.resignFirstResponder()
        
        guard let question = questionTextField.text, !question.isEmpty else { return }
        
        // Button animation
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
        
        askAI(question: question)
        
        // Debug info
        print("🔧 Build Configuration: \(BuildConfiguration.current)")

        print("🌐 Using Proxy: \(AppConfig.shouldUseProxy)")

        print("📡 Server URL: \(AppConfig.serverURL)")
    }
    
    @IBAction func sendResponseButtonTapped(_ sender: UIButton) {
        guard !currentResponse.isEmpty else { return }
        
        let question = questionTextField.text ?? ""
        copyResponse(question: question, answer: currentResponse)
    }
    
    private func askAI(question: String) {
        activityIndicator.startAnimating()
        askButton.isEnabled = false
        sendResponseButton.isEnabled = false
        updateSendButtonState()
        responseTextView.text = "🤔 LukAI is thinking..."
        
        AIServiceManager.shared.generateResponse(for: question) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.askButton.isEnabled = true
                
                switch result {
                case .success(let response):
                    self?.currentResponse = response
                    self?.responseTextView.text = response
                    self?.sendResponseButton.isEnabled = true
                    self?.updateSendButtonState()
                    
                    // Scroll to top of response
                    self?.responseTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
                    
                    print("📏 Response length: \(response.count) characters")
                    
                case .failure(let error):
                    self?.responseTextView.text = "❌ Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func copyResponse(question: String, answer: String) {
        let beautifulMessage = createBeautifulMessage(question: question, answer: answer)
        UIPasteboard.general.string = beautifulMessage
        showSuccessAnimation()
        requestPresentationStyle(.compact)
        clearForm()
    }
    
    private func createBeautifulMessage(question: String, answer: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let timestamp = formatter.string(from: Date())
        
        return """
        ┌─────────────────────────────────────┐
        │           🤖 LukAI Response         │
        │              \(timestamp)                │
        └─────────────────────────────────────┘
        
        ❓ Question:
        \(question)
        
        ✨ LukAI Answer:
        \(answer)
        
        ─────────────────────────────────────
        Generated by LukAI Assistant 🚀
        """
    }
    
    private func showSuccessAnimation() {
        let checkmark = UILabel()
        checkmark.text = "✅"
        checkmark.font = UIFont.systemFont(ofSize: 40)
        checkmark.textAlignment = .center
        checkmark.frame = CGRect(x: view.center.x - 20, y: view.center.y - 20, width: 40, height: 40)
        checkmark.alpha = 0
        
        view.addSubview(checkmark)
        
        UIView.animate(withDuration: 0.3, animations: {
            checkmark.alpha = 1
            checkmark.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                checkmark.alpha = 0
                checkmark.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                checkmark.removeFromSuperview()
            }
        }
    }
    
    private func clearForm() {
        questionTextField.text = ""
        responseTextView.text = ""
        currentResponse = ""
        sendResponseButton.isEnabled = false
        updateSendButtonState()
    }
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        setupProfessionalUI()
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        // Don't rebuild UI on presentation changes
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        // Keep UI static regardless of presentation style
    }
}

// MARK: - UITextFieldDelegate
extension MessagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == questionTextField {
            askButtonTapped(askButton)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            textField.layer.borderColor = UIColor.systemBlue.cgColor
            textField.layer.borderWidth = 2
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            textField.layer.borderColor = UIColor.systemGray4.cgColor
            textField.layer.borderWidth = 1
        }
    }
}
