import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let currentUser: UserRealm
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel = UILabel(
        font: .systemFont(ofSize: 18, weight: .semibold),
        textAlignment: .left, color: .label
    )
    
    private let emailLabel = UILabel(
        font: .systemFont(ofSize: 14, weight: .medium),
        textAlignment: .left, color: .gray)
    
    private let titleLabel = UILabel(
        font: .systemFont(ofSize: 18, weight: .bold),
        textAlignment: .center, color: .label
    )
    
    private let logOutButton = BlueButton(withStyle: .logout)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
                        title: "Profile", imageName: "person-icon",
                        type: .next, handler: {
                            self.showProfileVC()
                        }
                    )
                ]
            ),
            SettingsSection(
                title: "Security", options: [
                    SettingsOption(
                        title: "Change Password", imageName: "lock-icon", handler: {
                            self.showChangePasswordVC()
                        }
                    ),
                    SettingsOption(
                        title: "Forgot Password", imageName: "unlock-icon", handler: {
                            print("Forgot")
                        }
                    ),
                    SettingsOption(
                        title: "Dark Mode", imageName: "activity-icon",
                        type: .darkMode, handler: {
                            print("Dark")
                        }
                    )
                ]
            )
        ]
    }()
    
    // MARK: - Init
    
    init(user: UserRealm) {
        currentUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTargets()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
    
    private func setTargets() {
        logOutButton.addTarget(self, action: #selector(didTapLogOut),
                               for: .touchUpInside)
    }
    
    private func updateUser() {
        nameLabel.text = currentUser.firstName != "" ? currentUser.firstName : "Guest"
        if currentUser.lastName != "" {
            nameLabel.text?.append(" \(currentUser.lastName)")
        }
        emailLabel.text = currentUser.email
        if let userImageData = currentUser.userImageData {
            avatarImageView.image = UIImage(data: userImageData)
        } else {
            avatarImageView.image = UIImage(named: "mock-person")
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapLogOut() {
        AuthManager.shared.logOut { [weak self] result in
            switch result {
            case .success(let success):
                if success {
                    let signInVC = SignInViewController()
                    signInVC.modalTransitionStyle = .crossDissolve
                    signInVC.modalPresentationStyle = .fullScreen
                    self?.present(signInVC, animated: true)
                }
            case .failure(let error):
                let alert = UIAlertController.createAlert(
                    title: "Error", message: error.localizedDescription
                )
                self?.present(alert, animated: true)
            }
        }
    }
    
    private func showProfileVC() {
        let profileVC = ProfileViewController(user: currentUser)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    private func showChangePasswordVC() {
        let changePasswordVC = ChangePasswordViewController()
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
}

extension SettingsViewController: SettingTableViewCellDelegate {
    func didChangeDarkMode(_ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: OptionType.darkMode.rawValue)
        view.window?.overrideUserInterfaceStyle = isOn ? .dark : .light
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
        let option = sections[indexPath.section].options[indexPath.row]
        option.handler()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        let headerSectionView = HeaderSectionView(sectionTitle: section.title)
        return headerSectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.identifier,
            for: indexPath
        ) as? SettingTableViewCell else { return UITableViewCell() }
        
        let option = sections[indexPath.section].options[indexPath.row]
        cell.delegate = self
        cell.configure(imageName: option.imageName,
                       title: option.title,
                       optionType: option.type)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        
        view.addSubviewWithoutTranslates(
            titleLabel, avatarImageView, profileStack, tableView, logOutButton
        )
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10
            )
        ])
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 56),
            avatarImageView.widthAnchor.constraint(equalToConstant: 56),
            avatarImageView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 30
            ),
            avatarImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 24
            )
        ])
        
        NSLayoutConstraint.activate([
            profileStack.centerYAnchor.constraint(
                equalTo: avatarImageView.centerYAnchor
            ),
            profileStack.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor, constant: 12)
            
        ])
        
        NSLayoutConstraint.activate([
            logOutButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17
            ),
            logOutButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 24
            ),
            logOutButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -24
            )
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor, constant: 10
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 24
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -24
            ),
            tableView.bottomAnchor.constraint(
                equalTo: logOutButton.topAnchor, constant: -20
            )
        ])
    }
}
