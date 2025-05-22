struct ErrorViewModel {
    let message: String
    let buttonText: String
    let action: (() -> Void)?
    
    init(
        message: String,
        buttonText: String = AlertButtonConstants.ok,
        action: (() -> Void)? = nil
    ) {
        self.message = message
        self.buttonText = buttonText
        self.action = action
    }
}
