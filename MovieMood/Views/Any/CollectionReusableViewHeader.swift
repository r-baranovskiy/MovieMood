import UIKit

class CollectionReusableViewHeader: UICollectionReusableView {
    
    static let identifier = "CollectionReusableViewHeader"
    
    private var label = CustomLabel(withText: "", style: .head)

    
    public func configure() {
        addSubview(label)
    }
    
    public func setupLabel(text: String) {
        label.text = text
        label.textAlignment = .center
        label.frame = bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    
}
