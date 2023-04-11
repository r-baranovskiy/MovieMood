import UIKit

final class SearchViewController: UIViewController {
    
    //MARK: - Private Properties
    private let searchMovie = MovieSearchTextField()
    private let crossButton = CrossButton()
    private let filterButton = FilterButton()
    private let searchImageView = SearchView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchUI()
        addAction()
    }
    
    private func addAction() {
        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    @objc private func crossButtonTapped() {
        
    }
    
    @objc private func filterButtonTapped() {
        
    }
    
}

//MARK: - SetupUI
extension SearchViewController {
    
    private func setupSearchUI() {
        view.addSubview(searchMovie)
        view.addSubview(crossButton)
        view.addSubview(filterButton)
        view.addSubview(searchImageView)
        
        searchMovie.translatesAutoresizingMaskIntoConstraints = false
        crossButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchMovie.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 35),
            searchMovie.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            searchMovie.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            filterButton.rightAnchor.constraint(equalTo: searchMovie.rightAnchor, constant: -19),
            filterButton.centerYAnchor.constraint(equalTo: searchMovie.centerYAnchor),
            
            crossButton.rightAnchor.constraint(equalTo: searchMovie.rightAnchor, constant: -55),
            crossButton.centerYAnchor.constraint(equalTo: searchMovie.centerYAnchor),
            
            searchImageView.leftAnchor.constraint(equalTo: searchMovie.leftAnchor, constant: 18),
            searchImageView.centerYAnchor.constraint(equalTo: searchMovie.centerYAnchor)
        ])
    }
}


