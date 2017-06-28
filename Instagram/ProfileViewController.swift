//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Annabel Strauss on 6/27/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var myPosts: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        //nameLabel.text = PFUser.current()?.username
        //make profile pic circular
        //profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2;
        //profilePicImageView.clipsToBounds = true;
        
        //the next few lines lay out the items in the collection view nicely
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        let numCellsPerLine: CGFloat = 3
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (numCellsPerLine - 1)
        let width = collectionView.frame.size.width / numCellsPerLine - interItemSpacingTotal / numCellsPerLine
        layout.itemSize = CGSize(width: width, height: width)
        
        fetchMyPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMyPosts()
        //numPostsLabel.text = myPosts?.count as! String
        print(myPosts?.count)
        collectionView.contentOffset = CGPoint(x: 0, y: 0) //jumps collectionView back up to the top
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let post = myPosts![indexPath.item]
        let photo = post["media"] as! PFFile
        
        //set the photo image
        photo.getDataInBackground { (imageData: Data!, error: Error?) in
            cell.photoImageView.image = UIImage(data:imageData)
        }
        
        return cell
    }
    
    //====== GET THE DATA FROM THE CLOUD =======
    func fetchMyPosts() {
        // construct query
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                // do something with the array of object returned by the call
                self.myPosts = posts
                self.collectionView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }//close fetchMyPosts
    
    //====== SEGUE TO DETAIL VIEW =======
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {//get this to find the actual post
            let post = myPosts![indexPath.item] //get the current post
            let detailViewController = segue.destination as! DetailViewController //tell it its destination
            detailViewController.post = post
        }
    }
    
    //====== FOR HEADER THING =======
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
        return headerView
    }
    

}
