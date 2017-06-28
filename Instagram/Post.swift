//
//  Post.swift
//  Instagram
//
//  Created by Annabel Strauss on 6/27/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withTimestamp timestamp: Date?, withCompletion completion: PFBooleanResultBlock?) {
        //Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let date = dateFormatter.string(from: timestamp!)
        
        //Add relevant fields to the object
        post["media"] = getPFFileFromImage(image: image) //PFFile column type
        post["author"] = PFUser.current() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        post["timestamp"] = date
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    
    }//close postUserImage function
    
    /**
     Method to convert UIImage to PFFile
     - parameter image: Image that the user wants to upload to parse
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        //check if image is not nil
        if var image = image {
            //resize image
            image = resize(image: image, newSize: CGSize(width: 1000, height: 1000))
            //get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }//close getPFFileFromImage function
    
    class func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    

}//close Post class
