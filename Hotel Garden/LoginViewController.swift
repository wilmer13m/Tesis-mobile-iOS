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
    let loadingView = LoadingView(message: "Cargando...")

    
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
            
            loadingView.showMenuLoad()
            let homeViewController = HomeViewController(style: .plain)
        
            let nav : UINavigationController = UINavigationController(rootViewController: homeViewController as HomeViewController)
        
            let email = loginView?.userTextField.text
            let password = loginView?.passwordTextfield.text
            
            var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/login")!)
            request.httpMethod = "POST"
            let postString = "contra=\(password!)&email=\(email!)"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error!)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response!)")
                
                
                
                }else{
                    
                    do{
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:AnyObject] {
                            
                            let estatus = json["estatus"] as! Bool
                            
                            if estatus == true{
                            
                                let clientData = json["cliente"] as! [String:AnyObject]
                                
                                let client = Client()
                                client.id = clientData["id"] as! Int
                                client.email = clientData["email"] as! String
                                
                                
                                let prefs:UserDefaults = UserDefaults.standard
                                
                                prefs.set(client.id, forKey: "ID_CLIENTE")
                                prefs.set(client.email, forKey: "EMAIL_CLIENTE")
                                prefs.set(1, forKey: "ISLOGGEDIN") //asigando el valor 1 porque el login fue success
                                prefs.synchronize()
                                
                                DispatchQueue.main.async(execute: {
                                    self.loadingView.hideLoadingView()
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    self.present(nav, animated: true, completion: nil)
                                })
                                
                                
                            }else{
                            
                                let alertController = UIAlertController(title: "Error", message: "email ó contraseña incorrectos", preferredStyle: UIAlertControllerStyle.alert)
                                
                                let okAction = UIAlertAction(title: "Ok", style: .default) {
                                    (result : UIAlertAction) -> Void in
                                    
                                }
                                
                                alertController.addAction(okAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                                
                                
                                DispatchQueue.main.async(execute: {
                                    self.loadingView.hideLoadingView()
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    self.present(nav, animated: true, completion: nil)
                                })


                            
                            }
                            
                            
                            
                        }
                        
                    } catch let jsonError {
                        print("error en el json: \(jsonError)")
                        self.loadingView.hideLoadingView()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false

                        
                    }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString!)")
                }

        }
            
        task.resume()
            
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
