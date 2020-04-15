//
//  SignUpViewController.swift
//  LookingGood
//
//  Created by Hidaner Ferrer on 12/20/19.
//  Copyright © 2019 Hidaner Ferrer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpViewController: ViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
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
    
    //Check the fields and validate that the data is correct. If correct, this method returns nil. Otherwisem it returns the erros message
    
    
    // Validate an email for the right format
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    // Validate the password for the right format
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }

        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    func validateFields() -> String? {
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        // Validate that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please, fill in all fields."
        }
        
        // Check if password is the same one as the confirmed
        if passwordTextField.text != confirmPasswordTextField.text {
            return "Sorry, passwords don't match!"
        } else {
            // Check if the password is secure
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if isValidPassword(testStr: cleanedPassword) == false {
                // Password isn;t secure enough
                return "Please, make sure your password is at least 8 characters, contains a special character and a number."
            }
        }
        
        return nil
    }
    
    

  
    @IBAction func signUpTapped(_ sender: Any) {
        //Validtae a field
        let error = validateFields()
        
        if error != nil {
            //There is something wrong with the fields, show error message
            showError(error!)
        }
        else {
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)


            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
                // Check for errors
                            if err != nil {
                                // There was an error
                                self.showError("Error creating user")
                            }
                            else {
                                //User was created succesfully, now store the information on the database
                                let db = Firestore.firestore()
                                
                                let data = ["firstname":firstName, "lastname":lastName, "email":email]
                                
                                db.collection("users").document(email).setData(data) {(err) in
                                    if err != nil {
                                        // Show error message
                                        self.showError("Error saving user data")
                                    }
                                
                                }
                                
                                //Transition to the HOme Screen
                                self.transitionToHome()
                                
                            }
            }
            //Transition to the HOME screen
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
