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
    
    
    @IBOutlet weak var userHeightTextField: UITextField!
    
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
     errorLabel.alpha = 0
        
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
    
    
    func isValidWeight(_ weight:Float) -> Bool {
        if weight <= 0 {
            return false
        } else {
            return true
        }
    }
    
    func validateFields() -> String? {
           
           // Validate that all fields are filled in
        if userAgeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || currentWeightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || leanBodyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || bodyFatTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || userHeightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
               return "Please, fill in all fields."
        }
          
        let ageRange = Int(userAgeTextField.text!)
           // Check if age is valid
        if ageRange! < 1 || ageRange! > 100 {
               return "Sorry, type a valid age between 1 and 100"
        }
        
//        let currentWeight = (currentWeightTextField.text! as NSString).floatValue
        
        if isValidWeight((currentWeightTextField.text! as NSString).floatValue) == false {
            return "Enter a valid value for Current Weight"
        }
        
        if isValidWeight((leanBodyTextField.text! as NSString).floatValue) == false {
            return "Enter a valid value for Lean Body Weight"
        }
        
        if isValidWeight((bodyFatTextField.text! as NSString).floatValue) == false {
            return "Enter a valid value for Body Fat Goal"
        }
        
        if ((userHeightTextField.text! as NSString).floatValue) < 1.00 || ((userHeightTextField.text! as NSString).floatValue) > 7.11 {
                   return "Enter a valid value for Height"
               }
           
        return nil
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        let error = validateFields()
        
        if error != nil {
                   //There is something wrong with the fields, show error message
                   showError(error!)
               }
               else {
                   // Create cleaned versions of the data
                    let userAge = (userAgeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                    let currentWeight = (currentWeightTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) as NSString).floatValue
                    let leanWeight = (leanBodyTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) as NSString).floatValue
                    let bodyFat = (bodyFatTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) as NSString).floatValue
                    let userHeight = (userHeightTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) as NSString).floatValue


            
                   //Save data
                    let db = Firestore.firestore()
//
            let data = ["age":userAge, "weight":[currentWeight], "leanBodyWeight":leanWeight, "bodyFat":[bodyFat], "height":userHeight] as [String : Any]
                        
                        
                    db.collection("users").document(email).setData(data) {(err) in
                         if err != nil {
                         // Show error message
                         self.showError("Error saving user data")
                         }

                    }
                                       
                    //Transition to the HOme Screen
                    self.transitionToInfoView()
                   }
      }
    
    
    
    func showError(_ message:String) {
           errorLabel.text = message
           errorLabel.alpha = 1
       }
    
    func transitionToInfoView() {
        
        let infoViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.infoViewController) as? InfoViewController
        
        view.window?.rootViewController = infoViewController
        view.window?.makeKeyAndVisible()
    }
    
}
