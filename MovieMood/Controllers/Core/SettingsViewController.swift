import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let currentUser: MovieUser
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mock-person")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel = UILabel(
        font: .systemFont(ofSize: 18, weight: .semibold),
        textAlignment: .left, color: .black
    )
    
    private let emailLabel = UILabel(
        font: .systemFont(ofSize: 14, weight: .medium),
        textAlignment: .left, color: .gray)
    
    private let titleLabel = UILabel(
        font: .systemFont(ofSize: 18, weight: .bold),
        textAlignment: .center, color: .label
    )
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: SettingTableViewCell.identifier
        )

        return tableView
    }()
    
    // MARK: - Sections
    
    private lazy var sections: [SettingsSection] = {
        [
            SettingsSection(
                title: "Personal Info", options: [
                    SettingsOption(
                        title: "Profile", imageName: "person-icon", handler: {
                            self.showProfileVC()
                        }
                    )
                ]
            ),
            SettingsSection(
                title: "Security", options: [
                    SettingsOption(
                        title: "ChangePassword", imageName: "lock-icon", handler: {
                            print("Change")
                        }
                    ),
                    SettingsOption(
                        title: "Forgot Password", imageName: "unlock-icon", handler: {
                            print("Forgot")
                        }
                    ),
                    SettingsOption(
                        title: "Dark Mode", imageName: "activity-icon", handler: {
                            print("Dark")
                        }
                    )
                ]
            )
        ]
    }()
    
    // MARK: - Init
    
    init(user: MovieUser) {
        currentUser = user
        super.init(nibName: nil, bundle: nil)
        guard let firstName = currentUser.firstName else { return }
        guard let lastName = currentUser.lastName else { return }
        nameLabel.text = "\(firstName) \(lastName)"
        emailLabel.text = currentUser.email
        avatarImageView.sd_setImage(with: currentUser.avatarImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    private func showProfileVC() {
        let profileVC = ProfileViewController(user: currentUser)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.identifier,
            for: indexPath
        ) as? SettingTableViewCell else { return UITableViewCell() }
        
        let option = sections[indexPath.section].options[indexPath.row]
        
        cell.configure(imageName: option.imageName, title: option.title)
        
        return cell
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
