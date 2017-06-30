//
//  CaptureViewController.swift
//  Instagram
//
//  Created by Annabel Strauss on 6/27/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit
import Sharaku

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SHViewControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    //@IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rounded edges for share button
        shareButton.layer.cornerRadius = 10; // this value vary as per your desire
        shareButton.clipsToBounds = true;
        
        //rounded edges for filter button
        filterButton.layer.cornerRadius = 10; // this value vary as per your desire
        filterButton.clipsToBounds = true;
        
        //Put fancy instagram script in nav bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "InstaText")
        imageView.image = #imageLiteral(resourceName: "instaText")
        navigationItem.titleView = imageView
        
        captionTextView.delegate = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //====== MAKES KEYBOARD GO AWAY WHEN USER TAPS "RETURN" =======
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /* 
    * This is the delegate method
    */
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        photoImageView.image = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func choosePhoto() {
        // Instantiate a UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true

        //allow user to pick between photo library or camera
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //Present the camera or photo library depending on what the user picked
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onTapPhotoOpener(_ sender: Any) {
        choosePhoto()
    }
    
    @IBAction func onTapFilterButton(_ sender: Any) {
        let imageToBeFiltered = photoImageView.image
        let vc = SHViewController(image: imageToBeFiltered!)
        vc.delegate = self
        self.present(vc, animated:true, completion: nil)
    }
    
    //========FOR FILTERS===========
    func shViewControllerImageDidFilter(image: UIImage) {
        // Filtered image will be returned here.
        photoImageView.image = image
    }
    
    //========FOR FILTERS===========
    func shViewControllerDidCancel() {
        // This will be called when you cancel filtering the image.
    }
    
    @IBAction func didPressShare(_ sender: Any) {
        
        // Start the activity indicator
        activityIndicator.startAnimating()
        
        let caption = captionTextView.text
        let image = photoImageView.image
        Post.postUserImage(image: image, withCaption: caption, withTimestamp: Date()) { (success: Bool, error: Error?) in
            print("post was created!")
            print(success)
            self.tabBarController?.selectedIndex = 0 //move to Home once post is created
            self.activityIndicator.stopAnimating() //stop activity indicator
        }
        //sets the photo and caption back to default (aka nothing)
        photoImageView.image = nil
        captionTextView.text = nil
    }

    
    
}
