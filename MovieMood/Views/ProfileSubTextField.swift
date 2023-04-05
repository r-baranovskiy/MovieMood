import UIKit

final class ProfileSubTextFiled: UILabel {
    
    private let labelStyle: ProfileFieldStyle
    
    init(style: ProfileFieldStyle) {
        self.labelStyle = style
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        text = labelStyle.rawValue
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 14)
        textColor = .gray
    }
    
}
