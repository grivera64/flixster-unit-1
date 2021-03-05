//
//  MovieViewController.swift
//  flixster
//
//  Created by grivera64 on 2/24/21.
//

import UIKit
import AlamofireImage

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //array of dictionary
    var movies = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set 3
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        print("hello")
        
        
        //set 1
        //Error here for some reason (Still loads after aborting run and using simulation
        //afterwards
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!


        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]


            print(dataDictionary)
//
            //                                 cast as
            self.movies = dataDictionary["results"] as! [[String: Any]]

            //this gives errors
            self.tableView.reloadData()

              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }

            
            //this gives errors
            self.tableView.reloadData()

        }
        
        task.resume()
        
    }
    
    //set 2
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        //return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        //let cell = UITableViewCell()
        
        let movie = movies[indexPath.row]
        
        //type casting
        let title = movie["title"] as! String
        
        //swift optionals
        //cell.textLabel!.text = title
        cell.titleLabel!.text = title
        
        let synopsis = movie["overview"] as! String
        cell.synopsisLabel!.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading up the details screen")
        
        //find the selected movie
        
        //pass the selected movie
        let cell = sender as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)!
        
        let movie = movies[indexPath.row]
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

}
