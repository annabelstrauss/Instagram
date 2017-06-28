//
//  HomeViewController.swift
//  Instagram
//
//  Created by Annabel Strauss on 6/27/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postsTableView: UITableView!
    var allPosts: [PFObject]?
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        // Initialize a Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        postsTableView.insertSubview(refreshControl, at: 0)
        
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        postsTableView.contentOffset = CGPoint(x: 0, y: 0) //jumps tableView back up to the top
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts?.count ?? 0
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = allPosts![indexPath.row]
        let caption = post["caption"]
        let photo = post["media"] as! PFFile
        
        cell.captionLabel.text = caption as? String //set the caption text
        
        //set the photo image
        photo.getDataInBackground { (imageData: Data!, error: Error?) in
            cell.photoImageView.image = UIImage(data:imageData)
        }
        
        return cell
    }
    
    func fetchData() {
        // construct query
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                // do something with the array of object returned by the call
                self.allPosts = posts
                self.postsTableView.reloadData()
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    
    //THIS IS PULL TO REFRESH
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
}//close class
