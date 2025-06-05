import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        return scrollView
    } ()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    } ()
    
    private lazy var backwardButton: UIButton = {
        let backwardButton = UIButton(type: .custom)
        backwardButton.setImage(UIImage(named: backwardButtonIconName), for: .normal)
        backwardButton.addTarget(self, action: #selector(self.didTapBackButton), for: .touchUpInside)
        backwardButton.accessibilityIdentifier = "BackwardButton"
        return backwardButton
    } ()
    
    private lazy var sharingButton: UIButton = {
        let sharingButton = UIButton(type: .custom)
        sharingButton.setImage(UIImage(named: sharingButtonIconName), for: .normal)
        sharingButton.backgroundColor = .ypBlack
        sharingButton.addTarget(self, action: #selector(self.didTapShareButton), for: .touchUpInside)
        sharingButton.layer.masksToBounds = true
        sharingButton.layer.cornerRadius = sharingButtonSize / 2
        return sharingButton
    } ()
    
    // MARK: - UI Properties
    
    private let backwardButtonIconName: String = "BackwardButtonIcon"
    private let backwardButtonSize: Double = 44
    
    private let sharingButtonIconName: String = "SharingButtonIcon"
    private let sharingButtonSize: Double = 50
    
    private let maxZoomScale: Double = 1.25
    
    // MARK: - Alert
    
    private var alertPresenter: AlertPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        scrollView.addSubviews(imageView)
        view.addSubviews(scrollView, backwardButton, sharingButton)
        setConstraints()
        
        scrollView.delegate = self
        
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapShareButton() {
        guard let image = imageView.image else { return }
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - UI Updates
    
    func setImage(from photo: Photo, placeholder: UIImage) {
        setUserInteraction(to: false)
        rescaleAndCenterImageInScrollView(imageSize: placeholder.size)
        
        guard let url = URL(string: photo.largeImageURL) else { return }
        loadImage(url: url, placeholder: placeholder)
    }
    
    private func loadImage(url: URL, placeholder: UIImage) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: placeholder) { [weak self] result in
            switch result{
            case .success(let data):
                self?.setUserInteraction(to: true)
                self?.rescaleAndCenterImageInScrollView(imageSize: data.image.size)
            case .failure(let error):
                print("[\(#function)] Failed to download full image: \(error.localizedDescription).")
                
                let errorViewModel = ErrorViewModel(
                    message: "Не удалось загрузить фотографию. Попробовать ещё раз?",
                    buttonText: AlertButtonTitle.again
                ) { [weak self] in
                    self?.loadImage(url: url, placeholder: placeholder)
                }
                
                self?.show(error: errorViewModel)
            }
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            backwardButton.widthAnchor.constraint(equalToConstant: backwardButtonSize),
            backwardButton.heightAnchor.constraint(equalTo: backwardButton.widthAnchor),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backwardButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            sharingButton.widthAnchor.constraint(equalToConstant: sharingButtonSize),
            sharingButton.heightAnchor.constraint(equalTo: sharingButton.widthAnchor),
            sharingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sharingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -51)
        ])
    }
    
    private func rescaleAndCenterImageInScrollView(imageSize: CGSize) {
        if imageSize.width > 0 && imageSize.height > 0 {
            imageView.frame.size = imageSize
            view.layoutIfNeeded()
            let visibleRectSize = scrollView.bounds.size
            let hScale = visibleRectSize.width / imageSize.width
            let vScale = visibleRectSize.height / imageSize.height
            let scale = min(hScale, vScale)
            scrollView.minimumZoomScale = scale
            scrollView.maximumZoomScale = max(scale, maxZoomScale)
            scrollView.setZoomScale(scale, animated: false)
        }
    }
    
    private func setUserInteraction(to value: Bool) {
        scrollView.isUserInteractionEnabled = value
        sharingButton.isUserInteractionEnabled = value
    }
    
    private func show(error model: ErrorViewModel) {
        let alertModel = AlertModel(from: model)
        alertPresenter?.show(alert: alertModel)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
    }
}


extension SingleImageViewController: AlertPresenterDelegate {
    func didReceiveAlert(alert: UIAlertController?) {
        guard let alert else { return }
        present(alert, animated: true, completion: nil)
    }
}
