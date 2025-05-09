import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    private var imageView: UIImageView?
    private var scrollView: UIScrollView?
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            
            imageView?.image = image
            imageView?.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        addScrollView()
        addImageView()
        addBackwardButton()
        addSharingButton()
        
        guard let image else { return }
        imageView?.image = image
        imageView?.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
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
    
    // MARK: - Private Methods
    
    private func setView() {
        view.backgroundColor = .ypBlack
    }
    
    private func addScrollView() {
        let scrollView = UIScrollView()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        
        scrollView.delegate = self
        
        self.scrollView = scrollView
    }
    
    private func addImageView() {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView?.addSubview(imageView)
        
        self.imageView = imageView
    }
    
    private func addBackwardButton() {
        let backwardButton = UIButton(type: .custom)
        
        backwardButton.setImage(UIImage(named: "BackwardButtonIcon"), for: .normal)
        backwardButton.addTarget(self, action: #selector(self.didTapBackButton), for: .touchUpInside)
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backwardButton)
        
        NSLayoutConstraint.activate([
            backwardButton.widthAnchor.constraint(equalToConstant: 44),
            backwardButton.heightAnchor.constraint(equalTo: backwardButton.widthAnchor),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backwardButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func addSharingButton() {
        let sharingButton = UIButton(type: .custom)
        
        sharingButton.setImage(UIImage(named: "SharingButtonIcon"), for: .normal)
        sharingButton.backgroundColor = .ypBlack
        sharingButton.addTarget(self, action: #selector(self.didTapShareButton), for: .touchUpInside)
        sharingButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sharingButton)
        
        NSLayoutConstraint.activate([
            sharingButton.widthAnchor.constraint(equalToConstant: 50),
            sharingButton.heightAnchor.constraint(equalTo: sharingButton.widthAnchor),
            sharingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sharingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -51)
        ])
        
        sharingButton.layer.masksToBounds = true
        sharingButton.layer.cornerRadius = 25
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        guard let scrollView else { return }
        
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
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let imageViewSize = imageView?.frame.size else { return }
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}
