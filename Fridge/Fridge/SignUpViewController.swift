//
//  SignUpViewController.swift
//  Fridge
//
//  Created by Carlo Rene Sarangaya Casalme on 10/7/17.
//  Copyright © 2017 Carlo Rene Sarnagaya Casalme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    @IBOutlet weak var textFieldLoginName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    // Image picker initialized
    let picker = UIImagePickerController()
    
    // Firebase storage variables initialized
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Make profile picture a circle frame
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        // not sure what this does lmao
        picker.delegate = self
        
        // Handle Firebase storage references
        let storage = Storage.storage().reference(forURL: "gs://fridge-2c6c7.appspot.com/")
        ref = Database.database().reference()
        userStorage = storage.child("users")
        
    }
    
    // Switch between Set Up and Log In Screens
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        performSegue(withIdentifier: "SignupToLogin", sender: nil)
    }
    
    // Let users load an image into the ImageView from their photo library
    @IBAction func selectImagePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Create a new user account in Firebase, saving user information in database
    // Make sure user has input an email, password, and name
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
        if textFieldLoginEmail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else if textFieldLoginName.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a name", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    if let user = user {
                        
                        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                        changeRequest.displayName = self.textFieldLoginName.text!
                        changeRequest.commitChanges(completion: nil)
                        
                        let imageRef = self.userStorage.child("\(user.uid).jpg")
                        
                        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                        
                        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
                            if err != nil {
                                print(err!.localizedDescription)
                            }
                            
                            imageRef.downloadURL(completion: { (url, er) in
                                if er != nil {
                                    print(er!.localizedDescription)
                                }
                                
                                if let url = url {
                                    
                                    let userInfo: [String: Any] = ["uid": user.uid,
                                                                   "name": self.textFieldLoginName.text!,
                                                                   "urlToImage": url.absoluteString]
                                    
                                    self.ref.child("users").child(user.uid).setValue(userInfo)
                                    
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarView")
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                            })
                        })
                        
                        uploadTask.resume()
                        
                        
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
}

