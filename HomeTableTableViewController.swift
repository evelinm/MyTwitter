//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Maria Evelin Anda-Murillo on 2/17/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {
    
    
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    let myRefreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    
    
    
    
    @objc func loadTweet(){
    
        numberOfTweet = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count":  numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
            
            self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("could not retrienve tweet")
        })
        
        
        
        
    }
    
    
    
    func loadMoreTweet(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweet = numberOfTweet + 20
        
        let myParams = ["count":  numberOfTweet]
        
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
           
            
        }, failure: { (Error) in
            print("could not retrienve tweet")
        })
        
        
        
        
        
        
        
        func tableView(tableView: UITableView, willDisplay cell: UITableView , forRowAt indexPath : IndexPath) {
            loadTweet()
        }

        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey:"userLoggedIn" )
        print("out")
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        
        let data = try? Data (contentsOf: imageUrl! )
        
        if let imageData = data {
            
            cell.profileimageView.image = UIImage(data:imageData)
        }
            
            
            
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        
        
        
        return cell
    }

    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

  
    
    
    
}
