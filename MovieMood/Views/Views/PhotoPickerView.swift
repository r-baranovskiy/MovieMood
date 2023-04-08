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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        
        addSubview(titleLabel)
        addSubview(separator)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
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
    }
}

final class TestVC: UIViewController {
    
    let testView = PhotoPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.addSubview(testView)
        
        NSLayoutConstraint.activate([
            testView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            testView.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 1.4/3
            ),
            testView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 24
            ),
            testView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -24
            )
        ])
    }
}

import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let listVC = TestVC()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) -> TestVC {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) {
        }
    }
}
