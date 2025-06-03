public struct ErrorViewModel {
    public let message: String
    public let buttonText: String
    public let action: (() -> Void)?
    
    init(
        message: String,
        buttonText: String = AlertButtonTitle.ok,
        action: (() -> Void)? = nil
    ) {
        self.message = message
        self.buttonText = buttonText
        self.action = action
    }
}
