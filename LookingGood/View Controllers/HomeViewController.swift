//
//  HomeViewController.swift
//  LookingGood
//
//  Created by Hidaner Ferrer on 12/20/19.
//  Copyright © 2019 Hidaner Ferrer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: ViewController {
    

    let db = Firestore.firestore()
    var uid = ""
    var email = ""

    @IBOutlet weak var userNameDisplay: UILabel!
    
    @IBOutlet weak var userAgeTextField: UITextField!
    
    @IBOutlet weak var currentWeightTextField: UITextField!
    
    @IBOutlet weak var leanBodyTextField: UITextField!
    
    @IBOutlet weak var bodyFatTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//       Auth.auth().addStateDidChangeListener { auth, user in
//         guard let user = user else { return }
//         self.user = User(authData: user)
//       }
        
//
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          uid = user.uid
          email = user.email ?? ""
         
        }
        
         setUpElements()
         authenticateUser()
    }
    

    override func setUpElements() {
     //Hide the error label
     userNameDisplay.alpha = 0
        
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser != nil {
            print(uid)
            
            
            let ref = db.collection("users").document(email)
            ref.getDocument { (snapshot, err) in
                if let data = snapshot?.data() {
                    print(data["firstname"]!)
                    self.showName(data["firstname"]! as! String)
                } else {
                    print("Couldn't find the document")
                }
            }
            
        } else {
                 // No user is signed in.
                 // ...
        }
    }
    
    
    func showName(_ user:String){
        userNameDisplay.text = "Welcome, \(user)"
        userNameDisplay.alpha = 1
    }
    
    func showWeight(){
        
    }
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func validateFields() -> String? {
           
           // Validate that all fields are filled in
           if userAgeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || currentWeightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || leanBodyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || bodyFatTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
               return "Please, fill in all fields."
           }
           
           // Check if age is valid
        if Int(userAgeTextField.text) < 1 && Int(userAgeTextField.text) > 100 {
               return "Sorry, type a valid age between 1 and 100"
           } else {
               // Check if the weight is valid
               let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               if isValidPassword(testStr: cleanedPassword) == false {
                   // Password isn;t secure enough
                   return "Pleae, make sure your password is at least 8 characters, contains a special character and a number."
               }
           }
           
           return nil
       }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        
        
    }
    
}
