//
//  LoginViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 27/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var loginView : LoginView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         loginView = LoginView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        self.view.addSubview(loginView!)
        
        loginView?.loginButton.addTarget(self, action: #selector(makeLogin), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: METODO PARA HACER LOGIN
    func makeLogin(){
        
        if validateFields() == true{
            let homeViewController = HomeViewController(style: .plain)
        
            let nav : UINavigationController = UINavigationController(rootViewController: homeViewController as HomeViewController)
        
            self.present(nav, animated: true, completion: nil)
            
        }else{
        
            print("llene todos los campos")
        
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
