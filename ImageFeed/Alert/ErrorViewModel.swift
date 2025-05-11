struct ErrorViewModel {
    enum ButtonTextType: String {
        case ok = "ОК"
    }
    
    let message: String
    let buttonText: ButtonTextType
    let completion: (() -> Void)?
    
    init(message: String, buttonText: ButtonTextType, completion: (() -> Void)?) {
        self.message = message
        self.buttonText = buttonText
        self.completion = completion
    }
    
    init(message: String) {
        self.init(message: message, buttonText: .ok, completion: nil)
    }
}
