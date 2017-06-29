//
//  HomeViewController.swift
//  Instagram
//
//  Created by Annabel Strauss on 6/27/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var postsTableView: UITableView!
    var allPosts: [PFObject]?
    var refreshControl: UIRefreshControl!
    var isMoreDataLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        //this is for dynamic cell height
        postsTableView.rowHeight = UITableViewAutomaticDimension
        postsTableView.estimatedRowHeight = 500
        
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
        
        //this is so view jumps back up to top
        let count = allPosts?.count ?? 0
        if (count > 0){
            postsTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        
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
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        if let date = post["timestamp"]{
            cell.dateLabel.text = date as! String
        } else {
            cell.dateLabel.text = "No Date"
        }
        
        //set the photo image
        photo.getDataInBackground { (imageData: Data!, error: Error?) in
            cell.photoImageView.image = UIImage(data:imageData)
        }
        
        //set the profile picture image only if it exists
        if let profPic = user["portrait"] as? PFFile {
            profPic.getDataInBackground { (imageData: Data!, error: Error?) in
                cell.profilePicImageView.image = UIImage(data:imageData)
            }
        }
        
        return cell
    }
    
    //====== GET THE DATA FROM THE CLOUD =======
    func fetchData() {
        // construct query
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
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
            //update flag for infinite scrolling
            self.isMoreDataLoading = false
        }
    }
    
    //====== GET MORE DATA FOR INFINITE SCROLLING =======
    func fetchMoreData() {
        // construct query
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.skip = (self.allPosts?.count)!
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                // do something with the array of object returned by the call
                self.allPosts?.append(contentsOf: posts)
                self.postsTableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
            //update flag for infinite scrolling
            self.isMoreDataLoading = false
        }
    }

    
    //====== PULL TO REFRESH =======
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    //====== INFINITE SCROLL =======
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the position of one screen length before the bottom of the results
        let scrollViewContentHeight = postsTableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - postsTableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && postsTableView.isDragging) {
            
            // ... Code to load more data ...
            if(!self.isMoreDataLoading){
                fetchMoreData()
                NSLog("hi")
            }
            
            isMoreDataLoading = true
        }
    }
    
    /*
     * This makes the grey selection go away when you go back to table view
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postsTableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    
    
    
    
    
    
    
}//close class
