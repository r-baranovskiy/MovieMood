import UIKit

final class TransformView: UIView {
    
    // MARK: - Properties
    
    private let transformLayer = CATransformLayer()
    private var currentAngle: CGFloat = 0
    private var currentOffset: CGFloat = 0
    
    private let imageArray: [UIImage]
    private let imageSize: CGSize
    private let viewSize: CGSize
    
    // MARK: - Init
    
    init(images: [UIImage], imageSize: CGSize, viewSize: CGSize) {
        self.imageArray = images
        self.imageSize = imageSize
        self.viewSize = viewSize
        super.init(frame: .zero)
        setupView()
        addTargets()
        for image in imageArray {
            addImageCard(image: image)
        }
        
        turnCarousel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTargets() {
        let panRecognizer = UIPanGestureRecognizer()
        panRecognizer.addTarget(self, action: #selector(performPanAction(recognizer:)))
        self.addGestureRecognizer(panRecognizer)
    }
    
    // MARK: - Actions
    
    @objc
    private func performPanAction(recognizer: UIPanGestureRecognizer) {
        let xOffSet = recognizer.translation(in: self).x
        
        if recognizer.state == .began {
            currentOffset = 0
        }
        
        let xDiff = xOffSet * 0.05 - currentOffset
        currentAngle += xDiff
        
        turnCarousel()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        transformLayer.frame = self.bounds
        self.layer.addSublayer(transformLayer)
    }
    
    private func addImageCard(image: UIImage?) {
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(
            x: viewSize.width / 2 - imageSize.width / 2,
            y: viewSize.height / 2 - imageSize.height / 2,
            width: imageSize.width, height: imageSize.height
        )
        imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        guard let imageCardImage = image?.cgImage else { return }
        imageLayer.contents = imageCardImage
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.masksToBounds = true
        imageLayer.isDoubleSided = true
        imageLayer.borderColor = UIColor.label.withAlphaComponent(0.5).cgColor
        imageLayer.borderWidth = 5
        imageLayer.cornerRadius = 10
        transformLayer.addSublayer(imageLayer)
    }
    
    private func turnCarousel() {
        guard let transformSublayers = transformLayer.sublayers else { return }
        
        let segmentForImageCard = CGFloat(360 / transformSublayers.count)
        
        var angleOffset = currentAngle
        
        for layer in transformSublayers {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            transform = CATransform3DRotate(
                transform, CGFloat.degreeToRadians(deg: angleOffset), 0, 1, 0
            )
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            
            CATransaction.setAnimationDuration(0)
            
            layer.transform = transform
            
            angleOffset += segmentForImageCard
        }
    }
}
