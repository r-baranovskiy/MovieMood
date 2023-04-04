

import UIKit

class ExampleTableView: UITableViewController  {
    
    let cellId = "cellId"
    var movies : [Movie] = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMovieArray()
        tableView.register(ReusableCell.self, forCellReuseIdentifier: cellId)
        self.tableView.separatorColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReusableCell
        
        let currentLastItem = movies[indexPath.row]
        cell.movie = currentLastItem
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func createMovieArray() {
        movies.append(Movie(movieName: "Jurasic Park", movieImage: UIImage(named: "mock-film-four")!, movieCategory: "Action", movieDuration: "148 minutes"))
        movies.append(Movie(movieName: "Atomic Heart", movieImage: UIImage(named: "mock-film-three")!, movieCategory: "Game", movieDuration: "222 minuts", movieRating: 4.8, movieRatingVoits: 33))
        
    }
}
