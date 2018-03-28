//
//  AboutViewController.swift
//  Fridge
//
//  Created by Carlo Rene Sarangaya Casalme on 10/7/17.
//  Copyright © 2017 Carlo Rene Sarnagaya Casalme. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    // Switch between Set Up and Log In Screens
    @IBAction func backDidTouch(_ sender: AnyObject) {
        performSegue(withIdentifier: "aboutback", sender: nil)
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
