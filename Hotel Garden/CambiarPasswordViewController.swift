//
//  CambiarPasswordViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 25/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class CambiarPasswordViewController: UITableViewController,UITextFieldDelegate,SweetAlertDelegate {

    let cellId1 = "cellId1"
    let cellId2 = "cellId2"

    var textField1 = UITextField()
    var textField2 = UITextField()
    var textField3 = UITextField()
    
    let loadingView = LoadingView(message: "Cargando...")
    let prefs:UserDefaults = UserDefaults.standard
    
    var sweetAlert = SweetAlert()



    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Cambiar contraseña"
        
        //SETTING TABLEVIEW
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        
        //NAVBAR SETTING
        navigationController?.navigationBar.tintColor = .white        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atras", style:UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        tableView.register(CambiarPasswordCellTableViewCell.self, forCellReuseIdentifier: cellId1)
        tableView.register(ContinueTableViewCell.self, forCellReuseIdentifier: cellId2)
        
        sweetAlert.sweetDelegate = self

        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:METODOS DEL TABLEVIEW
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellId1) as! CambiarPasswordCellTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: cellId2) as! ContinueTableViewCell
        
        cell1.textfieldLocation.isSecureTextEntry = true
        cell1.textfieldLocation.delegate = self

        if indexPath.row == 0{
            cell1.textfieldLocation.tag = 0
            cell1.textfieldLocation.placeholder = "Contraseña actual"
        
        }else if indexPath.row == 1 {
            
            cell1.textfieldLocation.tag = 1
            cell1.textfieldLocation.placeholder = "Nueva contraseña"
            return cell1
        
        }else if indexPath.row == 2{
            cell1.textfieldLocation.tag = 2
            cell1.textfieldLocation.placeholder = "Confirmar Contraseña"
            
        }else{
            
            cell2.enviarButton.addTarget(self, action: #selector(self.cambiarPassword), for: .touchUpInside)
            return cell2
        
        }
        
        return cell1
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
        
            return 88
        
        }else{
        
            return 44
        
        }
         
    }
    
    
    
    //MARK:METODOS DEL TEXTFIELD 
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 0:
            
            textField1.text = textField.text
            break
        case 1:
            
            textField2.text = textField.text
            break
            
        case 2:
            
            textField3.text = textField.text
            break
            
        default:
            break
        }
        
    }
    
    
    //MARK: METODO PARA VALIDAR LOS TEXTFIELD
    func validar()->Bool{
    
        if (textField1.text == "") || (textField2.text == "") || (textField3.text == ""){
        
            let alertController = UIAlertController(title: "¡Error!", message: "rellene todos los campos del formulario", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                (result : UIAlertAction) -> Void in
                
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            
            return false
        
        }
        
        if textField2.text != textField3.text {
            
            let alertController = UIAlertController(title: "¡Error!", message: "El campo de nueva contraseña y confirmación de contraseña deben ser iguales", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                (result : UIAlertAction) -> Void in
                
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)

            
            return false
        
        }
        
        
        return true
    
    }
    
    
    //MARK: METODO PARA CAMBIAR LA CONTRASEÑA
    func cambiarPassword(){
    
        if validar() == true{
            
            
            loadingView.showMenuLoad()
            let homeViewController = HomeViewController(style: .plain)
            
            let nav : UINavigationController = UINavigationController(rootViewController: homeViewController as HomeViewController)
            
            let email : String = prefs.value(forKey: "EMAIL_CLIENTE") as! String
            let password = textField1.text
            
            var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/login")!)
            request.httpMethod = "POST"
            let postString = "contra=\(password!)&email=\(email)"
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
                                
                                DispatchQueue.main.async(execute: {
                                    self.loadingView.hideLoadingView()
                                    self.newPassword()
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                })
                                
                                
                            }else{
                                
                                let alertController = UIAlertController(title: "Error", message: "contraseña incorrecta", preferredStyle: UIAlertControllerStyle.alert)
                                
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
        
            print("no pase la validacion")
    
        }
    }
    
    
    
    func newPassword(){
        
        let clientId : Int = prefs.integer(forKey: "ID_CLIENTE") as Int

        
        var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/clients/\(clientId)")!)
        
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        let postString = "pass=\(textField2.text!)"
        print(postString)
        
        
        request.httpBody = postString.data(using: .ascii)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{ // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
                
                
                DispatchQueue.main.async(execute: {
                    self.loadingView.hideLoadingView()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Por favor revise su conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                })
                
            }else{
            
            //Todo salio bn
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.loadingView.hideLoadingView()
                    _ = self.sweetAlert.showAlert("Completado!", subTitle: "Su solicitud de cambio de contraseña fue exitosa", style: AlertStyle.success)
                
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString!)")
                
                })
            
            }
            
            //aqui poner el sweet alert de error
        }
        
        task.resume()
        

        
    }
    
    
    //MARK:METODO DEL PROTOCOLO DE SWEETALERT
    func sweetAlertOkButtonPressed() {
        
        navigationController?.popViewController(animated: true)
        
    }

    

}
