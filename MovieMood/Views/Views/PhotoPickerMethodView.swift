import UIKit

final class PhotoPickerMethodView: UIView {
    
    enum MethodStyle: String {
        case camera = "Take a photo"
        case album = "Choose from your file"
        case trashcan = "Delete photo"
        
        var imageName: String {
            switch self {
            case .camera:
                return "calendar-icon"
            case .album:
                return "albumIcon"
            case .trashcan:
                return "trashcanIcon"
            }
        }
    }
    
    private let style: MethodStyle
    
    init(withStyle style: MethodStyle) {
        self.style = style
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let label = UILabel(
            text: style.rawValue, font: .systemFont(ofSize: 14, weight: .bold),
            textAlignment: .left,
            color: style == .trashcan ? .systemRed : .label
        )
        
        let image = UIImage(named: style.imageName)
        let imageView = UIImageView(image: image)
        
        let stack = UIStackView(
            subviews: [imageView, label], axis: .horizontal, spacing: 20,
            aligment: .fill, distribution: .equalSpacing)
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 18)
        ])
    }
}
