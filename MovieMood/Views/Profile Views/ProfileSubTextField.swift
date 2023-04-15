import UIKit

final class ProfileSubTextFiled: UILabel {
    
    private let labelText: String
    
    init(withText text: String) {
        self.labelText = text
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        text = labelText
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 14)
        textColor = .gray
    }
    
}
