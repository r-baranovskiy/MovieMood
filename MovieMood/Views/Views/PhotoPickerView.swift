import UIKit

protocol PhotoPickerViewDelegate: AnyObject {
    func didChangePhotoAlbum()
    func didChangeCamera()
    func didChangeDelete()
}

final class PhotoPickerView: UIView {
    
    weak var delegate: PhotoPickerViewDelegate?
    
    // MARK: - Properties
    
    private let titleLabel = UILabel(
        text: "Change your picture",
        font: .systemFont(ofSize: 20, weight: .bold),
        textAlignment: .center, color: .label
    )
    
    private let cameraView = PhotoPickerMethodView(withStyle: .camera)
    private let galleryView = PhotoPickerMethodView(withStyle: .album)
    private let trashcanView = PhotoPickerMethodView(withStyle: .trashcan)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Behaviour
    
    private func setRecognizers() {
        cameraView.isUserInteractionEnabled = true
        galleryView.isUserInteractionEnabled = true
        trashcanView.isUserInteractionEnabled = true
        
        let cameraRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapCamera)
        )
        
        let galleryRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapAlbum)
        )
        
        let trashcanRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapTrashcan)
        )
        
        cameraView.addGestureRecognizer(cameraRecognizer)
        galleryView.addGestureRecognizer(galleryRecognizer)
        trashcanView.addGestureRecognizer(trashcanRecognizer)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapCamera() {
        delegate?.didChangeCamera()
    }
    
    @objc
    private func didTapAlbum() {
        delegate?.didChangePhotoAlbum()
    }
    
    @objc
    private func didTapTrashcan() {
        delegate?.didChangeDelete()
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        backgroundColor = .custom.mainBackground
        layer.cornerRadius = 12
        
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        
        let stack = UIStackView(
            subviews: [
                cameraView, galleryView, trashcanView
            ],
            axis: .vertical, spacing: 20, aligment: .fill,
            distribution: .fillEqually
        )
        
        addSubviewWithoutTranslates(titleLabel, separator, stack)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor, constant: 32
            ),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 20
            ),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cameraView.heightAnchor.constraint(
                equalTo: heightAnchor, multiplier: 1/6)
        ])
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(
                equalTo: separator.bottomAnchor, constant: 20
            ),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16
            ),
            stack.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16
            )
        ])
    }
}
