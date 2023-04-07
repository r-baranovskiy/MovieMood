import UIKit

final class GenderView: UIView {
    
    private var maleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Male", for: .normal)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "check-on-icon"), for: .selected)
        button.setImage(UIImage(named: "check-off-icon"), for: .normal)
        return button
    }()
    
    private var femaleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "check-on-icon"), for: .selected)
        button.setImage(UIImage(named: "check-off-icon"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
