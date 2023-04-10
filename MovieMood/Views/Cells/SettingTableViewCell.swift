import UIKit

protocol SettingTableViewCellDelegate: AnyObject {
    func didChangeDarkMode(_ isOn: Bool)
}

final class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    weak var delegate: SettingTableViewCellDelegate?
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel = UILabel(
        font: .systemFont(ofSize: 16, weight: .bold),
        textAlignment: .left, color: .label
    )
    
    private let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .custom.mainBlue
        switcher.isHidden = true
        //switcher.isOn = UserDefaults.standard.bool(forKey: "save_video")
        return switcher
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didChangeSwitchValue(_ sender: UISwitch) {
        delegate?.didChangeDarkMode(sender.isOn)
    }
    
    private func setupView() {
        contentView.addSubviewWithoutTranslates(iconImageView, titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            iconImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor, constant: 16
            ),
        ])
    }
    
    func configure(imageName: String, title: String, optionType: OptionType = .simple) {
        iconImageView.image = UIImage(named: imageName)?.withTintColor(.label)
        titleLabel.text = title
        
        if optionType == .next {
            tintColor = .systemGreen
            accessoryType = .disclosureIndicator
        }
        
        if optionType == .darkMode {
            switcher.isHidden = false
            switcher.isOn = UserDefaults.standard.bool(forKey: optionType.rawValue)
            switcher.addTarget(self, action: #selector(didChangeSwitchValue),
                               for: .valueChanged)
            contentView.addSubviewWithoutTranslates(switcher)
            
            NSLayoutConstraint.activate([
                switcher.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor, constant: -5
                ),
                switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    }
}
