struct ErrorViewModel {
    enum ButtonTextType: String {
        case ok = "ОК"
    }
    
    let message: String
    let buttonText: ButtonTextType
    let completion: (() -> Void)?
    
    init(message: String, buttonText: ButtonTextType = .ok, completion: (() -> Void)? = nil) {
        self.message = message
        self.buttonText = buttonText
        self.completion = completion
    }
}
