import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    let firstCells = [
        [UIImage(named: "person-icon")!, "Profile"]
    ]
    
    let secondCells = [
        [UIImage(named: "lock-icon")!, "Change Password"],
        [UIImage(named: "unlock-icon")!, "Forgot Password"],
        [UIImage(named: "activity-icon")!, "Dark Mode"]
    ]
    
    private let currentUser: MovieUser
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mock-person")
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel = UILabel(
        text: "Maxim Shantsev", font: .systemFont(ofSize: 18, weight: .semibold),
        textAlignment: .left, color: .black
    )
    
    private let emailLabel = UILabel(
        text: "test2@gmail.com", font: .systemFont(ofSize: 14, weight: .medium),
        textAlignment: .left, color: .gray)
    
    private let titleLabel = UILabel(
        text: "Settings", font: .systemFont(ofSize: 18, weight: .bold),
        textAlignment: .center, color: .label
    )
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Init
    
    init(user: MovieUser) {
        currentUser = user
        super.init(nibName: nil, bundle: nil)
        guard let firstName = currentUser.firstName else { return }
        guard let lastName = currentUser.lastName else { return }
        nameLabel.text = "\(firstName) \(lastName)"
        emailLabel.text = currentUser.email
        if let imageUrl = currentUser.avatarImageUrl {
            avatarImageView.sd_setImage(with: imageUrl)
        } else {
            avatarImageView.image = UIImage(named: "mock-person")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Present ProfileViewController
        if indexPath.section == 0 && indexPath.row == 0 {
            let profileVC = ProfileViewController(user: currentUser)
            profileVC.modalPresentationStyle = .fullScreen
            present(profileVC, animated: true)
        }
        
        /// Change Password
        if indexPath.section == 1 && indexPath.row == 0 {
            print("Change Password")
        }
        /// Forgot Password
        if indexPath.section == 1 && indexPath.row == 1 {
            print("Forgot Password")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSectionView = HeaderSectionView()
        if section == 0 {
            headerSectionView.sectionTitle = "Personal Info"
        } else {
            headerSectionView.sectionTitle = "Security"
        }
        return headerSectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingTableViewCell
        if indexPath.section == 0 {
            let image = firstCells[indexPath.row][0] as! UIImage
            let title = firstCells[indexPath.row][1] as! String
            cell.configure(image: image, title: title)
            return cell
        } else {
            let image = secondCells[indexPath.row][0] as! UIImage
            let title = secondCells[indexPath.row][1] as! String
            cell.configure(image: image, title: title)
            return cell
        }
    }
}

// MARK: - Setup View

extension SettingsViewController {
    
    private func setupView() {
        view.backgroundColor = .custom.mainBackground
        let profileStack = UIStackView(
            subviews: [nameLabel, emailLabel], axis: .vertical,
            spacing: 2, aligment: .fill, distribution: .fillEqually
        )
        
        view.addSubviewWithoutTranslates(titleLabel, avatarImageView, profileStack, tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10
            )
        ])
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 56),
            avatarImageView.widthAnchor.constraint(equalToConstant: 56),
            avatarImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            profileStack.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            profileStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
        ])
    }
}
