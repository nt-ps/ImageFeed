struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}

extension AlertModel {
    init(from errorModel: ErrorViewModel) {
        title = "Что-то пошло не так("
        message = errorModel.message
        buttonText = errorModel.buttonText.rawValue
        completion = errorModel.completion
    }
}
