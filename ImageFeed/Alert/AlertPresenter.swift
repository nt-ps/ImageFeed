import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func show(alert model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        if let actionButton = model.actionButton {
            let action = UIAlertAction(title: actionButton.title, style: .default) { _ in
                guard let completion = actionButton.action else { return }
                completion()
            }
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: model.cancelButton.title, style: .cancel) { _ in
            guard let completion = model.cancelButton.action else { return }
            completion()
        }
        alert.addAction(cancel)
        
        delegate?.didReceiveAlert(alert: alert)
    }
}
