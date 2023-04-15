import UIKit

final class ProfileImageView: UIImageView {
    
    private let profileImage: UIImage
    
    init(_ image: UIImage) {
        self.profileImage = image
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        image = profileImage
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
}
