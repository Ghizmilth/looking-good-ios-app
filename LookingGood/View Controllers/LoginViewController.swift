//
//  LoginViewController.swift
//  LookingGood
//
//  Created by Hidaner Ferrer on 12/20/19.
//  Copyright © 2019 Hidaner Ferrer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: ViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    override func setUpElements() {
        //Hide the error label
        errorLabel.alpha = 0
           
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func validateLoginFields() -> String? {
        
        // Validate that all fields are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please, fill in all fields."
        }
        
        return nil
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate the text fields
        let error = validateLoginFields()
        
        if error != nil {
            //There is something wrong with the fields, show error message
            showError(error!)
        }
        else {
            // Create cleaned versions of the data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)


        
        
        // Sign in the user
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
              
                if error != nil {
                    // Show error
                    self.showError(error! as! String)
                }
                else {
                    //Transition to the HOme Screen
                    self.transitionToHome()
                }
                
            }
      
         }
    }
    
    func showError(_ message:String) {
            //
        errorLabel.text = message
        errorLabel.alpha = 1
    }
        

    func transitionToHome() {
            
            let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
            
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
            
        }
    }
