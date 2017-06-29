//
//  CaptureViewController.swift
//  Instagram
//
//  Created by Annabel Strauss on 6/27/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.layer.cornerRadius = 10; // this value vary as per your desire
        shareButton.clipsToBounds = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func didPressShare(_ sender: Any) {
        let caption = captionTextField.text
        let image = photoImageView.image
        Post.postUserImage(image: image, withCaption: caption, withTimestamp: Date()) { (success: Bool, error: Error?) in
            print("post was created!")
            print(success)
            self.tabBarController?.selectedIndex = 0 //move to Home once post is created
        }
        //sets the photo and caption back to default (aka nothing)
        photoImageView.image = nil
        captionTextField.text = nil
    }
    

}
