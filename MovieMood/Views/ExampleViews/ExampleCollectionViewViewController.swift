//
//  ExampleCollectionViewViewController.swift
//  MovieMood
//
//  Created by иван Бирюков on 05.04.2023.
//

import UIKit

class ExampleCollectionViewViewController: UIViewController {
    
    var films : [Movie] = [Movie]()
    
    fileprivate let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ReusableCollectionViewCell.self , forCellWithReuseIdentifier: "cell")
        
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        createMovieArray()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: view.topAnchor , constant: 50).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -10).isActive = true
    }
    
    func createMovieArray() {
        films.append(Movie(movieName: "Drifting Home", movieImage: UIImage(named: "mock-film-one")!, movieCategory: "none", movieDuration: "200 minuts", dateCreating: "17 sep 2002"))
        films.append(Movie(movieName: "Luck", movieImage: UIImage(named: "mock-film-two")!, movieCategory: "none", movieDuration: "148 minuts", dateCreating: "21 oct 2013"))
        films.append(Movie(movieName: "Fistful", movieImage: UIImage(named: "mock-film-three")!, movieCategory: "none", movieDuration: "130 minuts", dateCreating: "14 sen 2021"))
        films.append(Movie(movieName: "Jurassik World", movieImage: UIImage(named: "mock-film-four")!, movieCategory: "none", movieDuration: "156 minuts", dateCreating: "11 dec 2010"))
        films.append(Movie(movieName: "Drifting Home", movieImage: UIImage(named: "ivan")!, movieCategory: "none", movieDuration: "200 minuts", dateCreating: "17 sep 2002"))
        films.append(Movie(movieName: "Luck", movieImage: UIImage(named: "mock-film-two")!, movieCategory: "none", movieDuration: "148 minuts", dateCreating: "21 oct 2013"))
        films.append(Movie(movieName: "Fistful", movieImage: UIImage(named: "mock-film-three")!, movieCategory: "none", movieDuration: "130 minuts", dateCreating: "14 sen 2021"))
        films.append(Movie(movieName: "Jurassik World", movieImage: UIImage(named: "mock-film-four")!, movieCategory: "none", movieDuration: "156 minuts", dateCreating: "11 dec 2010"))
    }
   
}

extension ExampleCollectionViewViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReusableCollectionViewCell
        cell.film = films[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = collectionView.bounds.width
        return CGSize(width: widthPerItem, height: 160)
    }
    
}
