//
//  HomeViewController.swift
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

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var textFieldIngredient: UITextField!
    @IBOutlet weak var expirationDate: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    
    // Firebase storage variables initialized
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Handle Firebase storage references
        let storage = Storage.storage().reference(forURL: "gs://fridge-2c6c7.appspot.com/")
        ref = Database.database().reference()
        userStorage = storage.child("users")
        
        fieldsNotEmpty()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Add ingredient to Firebase Database
    @IBAction func addPressed(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //format style. you can change according to yours
        let dateString = dateFormatter.string(from: expirationDate.date)
        
        let ingredientInfo: [String: String] = ["name": textFieldIngredient.text ?? "blank",
                                             "expiration_date": dateString]
        
        self.ref.child("users").child(user!.uid).child("ingredients").childByAutoId().setValue(ingredientInfo)
    }
    
    func fieldsNotEmpty() {
        addButton.isHidden = true
        textFieldIngredient.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
    }
    
    func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let name = textFieldIngredient.text, !name.isEmpty
            else
        {
            self.addButton.isHidden = true
            return
        }
        // enable okButton if all conditions are met
        addButton.isHidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
