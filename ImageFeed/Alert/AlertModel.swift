struct AlertModel {
    struct AlertButton {
        let title: String
        let action: (() -> Void)?
    }
    
    let title: String
    let message: String
    let actionButton: AlertButton?
    let cancelButton: AlertButton
}

extension AlertModel {
    init(from errorModel: ErrorViewModel) {
        title = "Что-то пошло не так("
        message = errorModel.message
        
        if let action = errorModel.action {
            actionButton = AlertButton(title: errorModel.buttonText, action: action)
            cancelButton = AlertButton(title: AlertButtonConstants.cancel, action: nil)
        } else {
            actionButton = nil
            cancelButton = AlertButton(title: errorModel.buttonText, action: nil)
        }
    }
}
