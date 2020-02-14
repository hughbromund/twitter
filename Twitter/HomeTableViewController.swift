//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Hugh Bromund on 2/6/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadTweets()
    }
    
    
    func loadTweets() {
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count":10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets!!")
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLogedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweetArray[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        
        cell.usernameLabel.text = (user["name"] as! String)
        cell.tweetContent.text = (tweet["text"] as! String)
        cell.handelLabel.text = ("@" + (user["screen_name"] as! String))
        
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        let maskView = UIView(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
        maskView.backgroundColor = .blue
        maskView.layer.cornerRadius = 20
        cell.imageView?.mask = maskView
        
        let isFavorited = tweet["favorited"] as! Bool
        
        cell.setFavorite(isFavorited)
        
        cell.tweetID = tweet["id"] as! Int
        
        return cell
    }
    

}
