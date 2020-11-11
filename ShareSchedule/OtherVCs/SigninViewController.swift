//
//  SigninViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SigninViewController: UIViewController, GIDSignInDelegate, UITextFieldDelegate {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
          return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                                  accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            print(error)
            return
          }
            let navigationController = self.presentingViewController as! UINavigationController
            let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! MainTableViewController
            
            prevVC.reloadCompletely()
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("test fin")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passTextField.delegate = self
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
          // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func normalSignin(){
        
        if emailTextField.text == nil || emailTextField.text == "" || passTextField.text == nil || passTextField.text == ""{
            let alertController = UIAlertController(title: "入力に不備があります", message: "再度確認してください", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if emailTextField.text == "asobishare.a@gmail.com"{
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passTextField.text!) { [weak self] authResult, error in
                if authResult?.user == nil{
                    let alertController = UIAlertController(title: "サインインできません", message: "メールアドレス・パスワードを確認してください", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(action)
                    self!.present(alertController, animated: true, completion: nil)
                    return
                }
                guard let strongSelf = self else { return }
                
                let navigationController = self?.presentingViewController as! UINavigationController
                let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! MainTableViewController
                
                prevVC.reloadCompletely()
                
                self?.dismiss(animated: true, completion: nil)
            }
            
            return
        }
        
        
        
        
        emailTextField.text = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if emailTextField.text?.suffix(10) == "@gmail.com"{
            let alertController = UIAlertController(title: "Googleアカウントでサインインしてください", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passTextField.text!) { [weak self] authResult, error in
            if authResult?.user == nil{
                let alertController = UIAlertController(title: "サインインできません", message: "メールアドレス・パスワードを確認してください", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self!.present(alertController, animated: true, completion: nil)
                return
            }
            guard let strongSelf = self else { return }
            
            let navigationController = self?.presentingViewController as! UINavigationController
            let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! MainTableViewController
            
            prevVC.reloadCompletely()
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func createUser(){
        
//        if emailTextField.text == "asobishare.a@gmail.com"{
//            let alertController = UIAlertController(title: "入力に不備があります", message: "このアカウント名は利用できません", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(action)
//            self.present(alertController, animated: true, completion: nil)
//            return
//        }
        
        
        if emailTextField.text == nil || emailTextField.text == "" || passTextField.text == nil || passTextField.text == ""{
            let alertController = UIAlertController(title: "入力に不備があります", message: "テキストフィールドの中を記入してください", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if passTextField.text!.count < 5{
            let alertController = UIAlertController(title: "入力に不備があります", message: "パスワードは5文字以上にしてください。", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for s in passTextField.text!{
            if !(letters.contains(s)){
                let alertController = UIAlertController(title: "入力に不備があります", message: "パスワードは英数字のみを使ってください", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        if passTextField.text!.count < 5{
            let alertController = UIAlertController(title: "入力に不備があります", message: "パスワードは5文字以上にしてください。", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
//        if emailTextField.text?.prefix(10) == "@gmail.com"{
//            let alertController = UIAlertController(title: "Googleアカウントでサインインしてください", message: "", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(action)
//            self.present(alertController, animated: true, completion: nil)
//            return
//        }
        
        let alertController = UIAlertController(title: "このアドレスでアカウントを作成します", message: emailTextField.text!, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { Void in
            Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passTextField.text!) { authResult, error in
                
                print(authResult?.user)
                
                if authResult?.user != nil{
                        let navigationController = self.presentingViewController as! UINavigationController
                       let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! MainTableViewController
                       
                       prevVC.reloadCompletely()
                       
                       self.dismiss(animated: true, completion: nil)
                }
                
               
            
            }
        })
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func signin(){
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}
