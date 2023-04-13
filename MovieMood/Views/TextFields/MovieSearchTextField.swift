import UIKit

protocol MovieSearchTextFieldDelegate: AnyObject {
    func didTapCrossButton()
    func didTapFilterButton()
}

final class MovieSearchTextField: UITextField {
    
    weak var searchFieldDelegate: MovieSearchTextFieldDelegate?
    
    // MARK: - Views
    
    private let crossButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cross")?
            .withTintColor(.label), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 10).isActive = true
        button.widthAnchor.constraint(equalToConstant: 10).isActive = true
        return button
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "filter")?
            .withTintColor(.label), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 13).isActive = true
        button.widthAnchor.constraint(equalToConstant: 13).isActive = true
        return button
    }()
    
    private let searchImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "search")?
            .withTintColor(.secondaryLabel))
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()
    
    private let padding = UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 75)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
        setTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Behaviour
    
    private func setTargets() {
        filterButton.addTarget(self, action: #selector(didTapFilterButton),
                               for: .touchUpInside)
        crossButton.addTarget(self, action: #selector(didTapCrossButton),
                              for: .touchUpInside)
    }
    
    @objc
    private func didTapFilterButton() {
        searchFieldDelegate?.didTapFilterButton()
    }
    
    @objc
    private func didTapCrossButton() {
        searchFieldDelegate?.didTapCrossButton()
    }
    
    //MARK: - Ovverade Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    //MARK: - Setup TextField
    private func setupTextField() {
        autocorrectionType = .no
        attributedPlaceholder = NSAttributedString(
            string: "Search movie", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.custom.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ])
        heightAnchor.constraint(equalToConstant: 52).isActive = true
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.custom.mainBlue.cgColor
        backgroundColor = .clear
        
        addSubviewWithoutTranslates(crossButton, filterButton, searchImageView)
        NSLayoutConstraint.activate([
            crossButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -55
            ),
            crossButton.centerYAnchor.constraint(
                equalTo: self.centerYAnchor
            ),
            
            filterButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -19
            ),
            filterButton.centerYAnchor.constraint(
                equalTo: self.centerYAnchor
            ),
            
            searchImageView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 18
            ),
            searchImageView.centerYAnchor.constraint(
                equalTo: self.centerYAnchor
            )
        ])
    }
}
