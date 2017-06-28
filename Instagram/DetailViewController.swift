//
//  DetailViewController.swift
//  Instagram
//
//  Created by Annabel Strauss on 6/28/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    var post: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            let user = post["author"] as! PFUser
            usernameLabel.text = user.username //send over the username
            captionLabel.text = post["caption"] as! String
            if var date = post["timestamp"]{
                timestampLabel.text = date as! String
            } else {
                timestampLabel.text = "No Date"
            }
            let photo = post["media"] as! PFFile
            photo.getDataInBackground { (imageData: Data!, error: Error?) in
                self.photoImageView.image = UIImage(data:imageData)
            }
        }
    }//close viewDidLoad
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}//close class
