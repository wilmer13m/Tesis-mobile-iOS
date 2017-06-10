//
//  LoginViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 27/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    var loginView : LoginView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //SETTING LOGINVIEW
         loginView = LoginView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        self.view.addSubview(loginView!)
        loginView?.userTextField.delegate = self
        loginView?.passwordTextfield.delegate = self
        
        loginView?.loginButton.addTarget(self, action: #selector(makeLogin), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: funcion para ocultar el teclado cuando se haga tap sobre el view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    
    //MARK: METODOS DEL TEXTFIELD
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //MARK: METODO PARA HACER LOGIN
    func makeLogin(){
        
        if validateFields() == true{
            let homeViewController = HomeViewController(style: .plain)
        
            let nav : UINavigationController = UINavigationController(rootViewController: homeViewController as HomeViewController)
        
            
            //guardando el client id en el prefs
            let prefs:UserDefaults = UserDefaults.standard
            
            prefs.set(1, forKey: "ID_CLIENTE")
            prefs.set(1, forKey: "ISLOGGEDIN") //asigando el valor 1 porque el login fue success
            prefs.synchronize()
            
            
            self.present(nav, animated: true, completion: nil)
            
            
            
        }else{
        
            let alertController = UIAlertController(title: "!Error¡", message: "por favor no dejar campos vacios", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                (result : UIAlertAction) -> Void in
                
            }
            
            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)
            
            
           
                    
        }
    
    }
    
    
    //MARK: METODO PARA
    func validateFields() -> Bool{
        
        if loginView?.userTextField.text != "" && loginView?.passwordTextfield.text != ""{
            
            return true
            
        }else {
        
            return false
        }
    
    }
    
    
}
