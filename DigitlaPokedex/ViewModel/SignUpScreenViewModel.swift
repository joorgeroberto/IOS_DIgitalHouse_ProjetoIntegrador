//
//  SignUpScreenViewModel.swift
//  DigitlaPokedex
//
//  Created by Jorge Carvalho on 05/01/21.
//

import Foundation
import UIKit
import Firebase

class SignUpScreenViewModel {
    private var navigationController: UINavigationController!
    var screen: SignUpScreenViewController!
    
    func setupNavigationController(navigationController: UINavigationController!, screen: SignUpScreenViewController!) {
        self.navigationController = navigationController
        self.screen = screen
    }
    
    func isConnected() -> Bool {
        let isConnected = Reachability.isConnectedToNetwork()
        if(!isConnected) { showAlert(isConnectionAlert: true) }
        
        return isConnected
    }
    
    func showAlert(isConnectionAlert: Bool) {
        let title = isConnectionAlert ? "No internet connection!" : "Invalid email or password"
        let message = isConnectionAlert ? "Please check your network settings and try again." : "Please, try again."
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            if (isConnectionAlert) { self.toPreviousScreen() }
        }))
        screen.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmailAndPassword(_ email: String, _ password: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let isInvalidEmail = email == "" || !emailPred.evaluate(with: email)
        let isInvalidPassword = password == "" || password.count < 6
        
        if(isInvalidEmail || isInvalidPassword) {
            showAlert(isConnectionAlert: false)
            return false
        }
        
        return true
    }
    
    func toInitialFavoritesRegistrationScreen() {
        let viewController = UIStoryboard(name: "InitialFavoritesRegistration", bundle: nil).instantiateInitialViewController() as! InitialFavoritesRegistrationViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func toPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    func saveUserOnFirebase() {
        var ref: DatabaseReference!
        //rootRef.child("users").childByAutoId().setValue("hey", forKey: "yo")
        ref = Database.database().reference()
        //ref.child("users").childByAutoId().setValue("username", forKey: "yo")
        ref.child("users").child("64raU3Ex74YwcDkVsZ6a1cIzzBt2").setValue(["username": "Jorge"])
        //ref.child("users").child("64raU3Ex74YwcDkVsZ6a1cIzzBt2")
        ref.child("users/64raU3Ex74YwcDkVsZ6a1cIzzBt2/favorites").setValue(["0": "pikachu", "1": "bulbasaur"])
    }
    
    func saveButtonAction(email: String, password: String) {
        self.saveUserOnFirebase()
        if(isConnected() && isValidEmailAndPassword(email, password)) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if((authResult != nil) && error == nil) {
                    self.toInitialFavoritesRegistrationScreen()
                } else {
                    self.showAlert(isConnectionAlert: false)
                }
            }
        }
    }
}
