import UIKit

protocol PhotoPickerViewDelegate: AnyObject {
    func didChangePhotoAlbum()
    func didChangeCamera()
    func didChangeDelete()
}

final class PhotoPickerView: UIView {
    
    weak var delegate: PhotoPickerViewDelegate?
    
    // MARK: - Properties
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
}
