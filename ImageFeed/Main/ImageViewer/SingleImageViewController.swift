import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = minZoomScale
        scrollView.maximumZoomScale = maxZoomScale
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
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            if isViewLoaded {
                setImage()
            }
        }
    }
    
    // MARK: - UI Properties
    
    private let backwardButtonIconName: String = "BackwardButtonIcon"
    private let backwardButtonSize: Double = 44
    
    private let sharingButtonIconName: String = "SharingButtonIcon"
    private let sharingButtonSize: Double = 50
    
    private let minZoomScale: Double = 0.1
    private let maxZoomScale: Double = 1.25
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        view.addSubviews(scrollView, backwardButton, sharingButton)
        scrollView.addSubviews(imageView)
        setConstraints()
        
        scrollView.delegate = self
        
        setImage()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapShareButton() {
        guard let image else { return }
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - UI Updates
    
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
    
    private func setImage() {
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        if imageSize.width > 0 && imageSize.height > 0 {
            let hScale = visibleRectSize.width / imageSize.width
            let vScale = visibleRectSize.height / imageSize.height
            let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
            scrollView.minimumZoomScale = scale
            scrollView.setZoomScale(scale, animated: false)
        }
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
