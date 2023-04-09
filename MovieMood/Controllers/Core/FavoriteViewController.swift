import UIKit

final class FavoriteViewController: UIViewController {
    
}
  /*
    var films : [Movie] = [Movie]()
    
    fileprivate let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        // registr collectionView cell
        cv.register(ReusableCollectionViewCell.self , forCellWithReuseIdentifier: "ReusableCollectionViewCell")

        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        createMovieArray()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionViewConstraintsSetup()
    }
    
    
    func createMovieArray() {
        films.append(Movie(movieName: "Drifting Home", movieImage: UIImage(named: "mock-film-one")!, movieCategory: "none", movieDuration: "200 minuts", dateCreating: "17 sep 2002"))
        films.append(Movie(movieName: "Luck", movieImage: UIImage(named: "mock-film-two")!, movieCategory: "none", movieDuration: "148 minuts", dateCreating: "21 oct 2013"))
        films.append(Movie(movieName: "Fistful", movieImage: UIImage(named: "mock-film-three")!, movieCategory: "none", movieDuration: "130 minuts", dateCreating: "14 sen 2021"))
        films.append(Movie(movieName: "Jurassik World", movieImage: UIImage(named: "mock-film-four")!, movieCategory: "none", movieDuration: "156 minuts", dateCreating: "11 dec 2010"))
        films.append(Movie(movieName: "Drifting Home", movieImage: UIImage(named: "mock-film-three")!, movieCategory: "none", movieDuration: "200 minuts", dateCreating: "17 sep 2002"))
        films.append(Movie(movieName: "Luck", movieImage: UIImage(named: "mock-film-two")!, movieCategory: "none", movieDuration: "148 minuts", dateCreating: "21 oct 2013"))
        films.append(Movie(movieName: "Fistful", movieImage: UIImage(named: "mock-film-three")!, movieCategory: "none", movieDuration: "130 minuts", dateCreating: "14 sen 2021"))
        films.append(Movie(movieName: "Jurassik World", movieImage: UIImage(named: "mock-film-four")!, movieCategory: "none", movieDuration: "156 minuts", dateCreating: "11 dec 2010"))
    }
    
}

// MARK: - CollectionView constrains settup

extension FavoriteViewController {
    func collectionViewConstraintsSetup() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

    // MARK: - CollectionView Delegate Methods

extension FavoriteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // setup amount of cells in collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    //setup data in cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCollectionViewCell", for: indexPath) as! ReusableCollectionViewCell
        cell.delegate = self
        cell.film = films[indexPath.row]
        return cell
    }
    
    //setup size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = collectionView.bounds.width
        return CGSize(width: widthPerItem, height: 160)
    }
    
    // Setting up Collection View Header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height:  70)
    }
}

// MARK: - Cell Delegate Methods

extension FavoriteViewController: ReusableCollectionViewCellDelegate{
    
    func didTapAction() {
        print("action button pressed")
    }
    
    func didTapLike() {
        print("like button pressed")
    }
    
}
*/
