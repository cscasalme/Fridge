//
//  ProfileViewController.swift
//  Fridge
//
//  Created by Carlo Rene Sarangaya Casalme on 10/7/17.
//  Copyright © 2017 Carlo Rene Sarnagaya Casalme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    @IBOutlet weak var textFieldLoginName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //make image circle
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let storage = Storage.storage().reference(forURL: "gs://fridge-2c6c7.appspot.com/")
        
        ref = Database.database().reference()
        userStorage = storage.child("users")
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            textFieldLoginName.text = user.displayName
            textFieldLoginEmail.text = user.email
            
            let imageRef = self.userStorage.child("\(user.uid).jpg")
            
            imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    let myImage: UIImage! = UIImage(data: data!)
                    self.imageView.image = myImage
                }
            }
            
        }
    }
    
    // Log out user and take user back to login screen
    @IBAction func didTapLogOut(_ sender: AnyObject) {
        
        print("sign out button tapped")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "logout", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        } catch {
            print("Unknown error.")
        }
        
    }
    // Log out user and take user back to login screen
    @IBAction func didTapAbout(_ sender: AnyObject) {
        
        print("sign out button tapped")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "logout", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        } catch {
            print("Unknown error.")
        }
        
    }
    
    // MARK: Actions
    // Switch between Set Up and Log In Screens
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        performSegue(withIdentifier: "aboutscreen", sender: nil)
    }
    
}

