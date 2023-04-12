import UIKit

// MARK: - Properties and viewDidLoad()
final class OnboardingViewController: UIViewController {

    private lazy var firstView = generateOnboardingView(textLabel: "Hello! I'll help to choose a movie!", descriprionLabel: "Going to enjoy Movie Night? Don't know which movie will like your friends? I'll solve this problem easily!")
    private lazy var secondView = generateOnboardingView(textLabel: "Choose genres that you preer the most!", descriprionLabel: "Pick your favorite genres, and relevant movies will be included to the voting list. Tune your preferences in Profile")
    private lazy var  thirdView = generateOnboardingView(textLabel: "Discover and vote on movies!", descriprionLabel: "Explore a curated list of movies based on your favorite genres. Vote on the movies you want to watch and enjoy a personalized movie night!")
    
    lazy var views = [firstView, secondView, thirdView]
    
    private let mainImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "onboarding"))
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let whiteBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
               scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
               scrollView.isPagingEnabled = true
               scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height)
               for i in 0..<views.count {
                   scrollView.addSubview(views[i])
                   views[i].translatesAutoresizingMaskIntoConstraints = false
                   views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width / 2 , height: view.frame.height / 2)
                   NSLayoutConstraint.activate([
                       views[i].topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                       views[i].bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
                       views[i].widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                       views[i].leadingAnchor.constraint(equalTo: i == 0 ? scrollView.leadingAnchor : views[i - 1].trailingAnchor),
                       views[i].heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                   ])
               }
        scrollView.trailingAnchor.constraint(equalTo: views.last!.trailingAnchor).isActive = true
               scrollView.delegate = self
               return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .CustomColor().mainBlue
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .CustomColor().mainBlue
        button.layer.cornerRadius = 16
        button.setTitle("Continue", for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
    }
}


// MARK: - setUpView()
extension OnboardingViewController {
    private func setUpView() {
        view.backgroundColor = .CustomColor().mainBlue
        view.addSubview(mainImage)
        view.addSubview(whiteBackgroundView)
        whiteBackgroundView.addSubview(scrollView)
        whiteBackgroundView.addSubview(continueButton)
        whiteBackgroundView.addSubview(pageControl)
    }
}


// MARK: - setUpConstraints()
extension OnboardingViewController {
    private func setUpConstraints() {
        scrollView.edgeTo(view: whiteBackgroundView)
        NSLayoutConstraint.activate([
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainImage.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            whiteBackgroundView.topAnchor.constraint(equalTo: mainImage.bottomAnchor),
            whiteBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height / 14)),
            whiteBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.height / 24)),
            whiteBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.height / 24)),
            
            pageControl.topAnchor.constraint(equalTo: whiteBackgroundView.topAnchor, constant: 20),
            pageControl.centerXAnchor.constraint(equalTo: whiteBackgroundView.centerXAnchor),
            
            continueButton.centerXAnchor.constraint(equalTo: whiteBackgroundView.centerXAnchor),
            continueButton.widthAnchor.constraint(equalTo: whiteBackgroundView.widthAnchor, multiplier: 0.66),
            continueButton.bottomAnchor.constraint(equalTo: whiteBackgroundView.bottomAnchor, constant: -20),
        ])
    }
}

// MARK: - OnboardingViewController()
extension OnboardingViewController {
    private func generateOnboardingView(textLabel: String, descriprionLabel: String) -> OnboardingView {
        let onboardingView = OnboardingView()
        onboardingView.titleLabel.text = textLabel
        onboardingView.descriptionLabel.text = descriprionLabel
        return onboardingView
    }
}

// MARK: - scrollViewDidScroll()
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

// MARK: - pageControlTapHandler()
extension OnboardingViewController {
    @objc func pageControlTapHandler(sender: UIPageControl) {
        scrollView.scrollTo(horizotalPage: sender.currentPage, animated: true)
    }
}

// MARK: - nextButtonTapped()
extension OnboardingViewController {
    @objc func nextButtonTapped() {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        if Int(pageIndex) < views.count - 1 {
            scrollView.scrollTo(horizotalPage: Int(pageIndex) + 1, animated: true)
        } else {
            let signInVC = SignInViewController()
            signInVC.modalPresentationStyle = .fullScreen
            signInVC.modalTransitionStyle = .crossDissolve
            present(signInVC, animated: true)
        }
    }
}
