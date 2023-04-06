import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - Variables
    
    private let filmCovers: [UIImage] = [
        UIImage(named: "mock-film-one")!,
        UIImage(named: "mock-film-two")!,
        UIImage(named: "mock-film-three")!,
        UIImage(named: "mock-film-four")!
    ]
    
    private let labelsView: UIStackView = {
        let labelsSV = UIStackView()
        labelsSV.axis = NSLayoutConstraint.Axis.vertical
        labelsSV.distribution = .fill
        labelsSV.alignment = .leading
        labelsSV.spacing = 2
        return labelsSV
    }()
    
    private let upperView: UIStackView = {
        let upSV = UIStackView()
        upSV.axis = NSLayoutConstraint.Axis.horizontal
        upSV.distribution = .fill
        upSV.alignment = .leading
        upSV.spacing = 15
        return upSV
    }()
    
    private let userImageView: UIImageView = {
        let userIV = UIImageView()
        userIV.contentMode = .scaleAspectFit
        userIV.image = UIImage(named: "mock-person")
        return userIV
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        let userName = "Nikolai"
        label.textColor = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "PlusJakartaSans-Bold", size: 18)
        label.text = "Hi, \(userName)"
        return label
    }()
    
    private let additionalInfoLabel: UILabel = {
        let label = UILabel()
        let additionalInfo = "only streaming movie lovers"
        label.textColor = UIColor(red: 0.612, green: 0.643, blue: 0.671, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "PlusJakartaSans-Bold", size: 12)
        label.text = additionalInfo
        return label
    }()
    
    private lazy var topView: UIView = {
        return TransformView(
            images: filmCovers, imageSize: CGSize(width: 100, height: 150),
            viewSize: CGSize(width: view.frame.width, height: 150)
        )
    }()
    
    private func setupUI() {
        view.addSubview(topView)
        view.addSubview(upperView)
        upperView.addArrangedSubview(userImageView)
        upperView.addArrangedSubview(labelsView)
        labelsView.addArrangedSubview(userNameLabel)
        labelsView.addArrangedSubview(additionalInfoLabel)
        
        
        upperView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            
            upperView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            upperView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            upperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 24),
            upperView.heightAnchor.constraint(equalToConstant: 40),
            
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            userImageView.heightAnchor.constraint(equalToConstant: 40),
            
            topView.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 100),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 150)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    
}



//MARK: - Preview
import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let listVC = HomeViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) -> HomeViewController {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) {
        }
    }
}
