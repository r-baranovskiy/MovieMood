import UIKit

final class DetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        imageView.image = UIImage(named: "mock-film-two")
        return imageView
    }()
    
    private let nameMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 0
        
        label.text = "Luck"
        return label
    }()
    
    // Date
    private let dateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "calendar-icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.471, green: 0.51, blue: 0.541, alpha: 1)
        
        label.text = "17 Sep 2021"
        return label
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // Time
    private let timeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clock-icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.471, green: 0.51, blue: 0.541, alpha: 1)
        
        label.text = "148 minutes"
        return label
    }()
    
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // Genre
    private let genreImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "film-icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.471, green: 0.51, blue: 0.541, alpha: 1)
        
        label.text = "Action"
        return label
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private let horizontalInformationStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.contentMode = .center
        return stackView
    }()
    
    // Stars
    
    //
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .center
        return stackView
    }()
    
    // Story Line
    private let storyLineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Story Line"
        return label
    }()
    
    private let textView: UILabel = {
        let text = UILabel()
        text.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More"
        text.numberOfLines = 0
        return text
    }()
    
    // Cast and Crew
    
    
    // Button
    private let watchButton: BlueButton = {
        let button = BlueButton(withStyle: .ation)
        button.setTitle("Watch now", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        dateStackView.addArrangedSubview(dateImageView)
        dateStackView.addArrangedSubview(dateLabel)
        
        timeStackView.addArrangedSubview(timeImageView)
        timeStackView.addArrangedSubview(timeLabel)
        
        genreStackView.addArrangedSubview(genreImageView)
        genreStackView.addArrangedSubview(genreLabel)
        
        horizontalInformationStack.addArrangedSubview(dateStackView)
        horizontalInformationStack.addArrangedSubview(timeStackView)
        horizontalInformationStack.addArrangedSubview(genreStackView)
        
        informationStackView.addArrangedSubview(nameMovieLabel)
        informationStackView.addArrangedSubview(horizontalInformationStack)
        //informationStackView.addArrangedSubview(starsView)
        
        scrollView.addSubview(mainView)
        
        view.addSubview(scrollView)
        
        let subviews = [movieImageView,
                        informationStackView,
                        storyLineLabel,
                        textView,
                        // cast and Crew,
                        watchButton]
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            movieImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 40),
            movieImageView.heightAnchor.constraint(equalToConstant: 300),
            movieImageView.widthAnchor.constraint(equalToConstant: 225),
            movieImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            
            informationStackView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 24),
            informationStackView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 30),
            informationStackView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -30),
            
            storyLineLabel.topAnchor.constraint(equalTo: informationStackView.bottomAnchor, constant: 30),
            storyLineLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 24),
            //storyLineLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -40),
            
            textView.topAnchor.constraint(equalTo: storyLineLabel.bottomAnchor, constant: 16),
            textView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 24),
            textView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -24),
            
            // Cast and Crew Constraint
            
            watchButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 30),
            watchButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            watchButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -20)
        ])
    }
}
