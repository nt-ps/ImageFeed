public struct AlertModel {    
    public let title: String
    public let message: String
    public let actionButton: AlertButton?
    public let cancelButton: AlertButton
}

extension AlertModel {
    init(from errorModel: ErrorViewModel) {
        title = "Что-то пошло не так("
        message = errorModel.message
        
        if let action = errorModel.action {
            actionButton = AlertButton(title: errorModel.buttonText, action: action)
            cancelButton = AlertButton(title: AlertButtonTitle.cancel, action: nil)
        } else {
            actionButton = nil
            cancelButton = AlertButton(title: errorModel.buttonText, action: nil)
        }
    }
}
