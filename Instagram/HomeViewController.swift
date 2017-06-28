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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        // Initialize a Refresh Control
        let refreshControl = UIRefreshControl()
        
        fetchData()
        postsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        postsTableView.reloadData()
        postsTableView.setContentOffset(CGPoint(x: 0, y: 0), animated:true) //jumps tableView back up to the top
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
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
}//close class
