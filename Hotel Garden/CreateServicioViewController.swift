//
//  CreateMantenimientoViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 4/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//


protocol CrearServicioDelegate {
    
    func pasarDataDelegate(x: Int)
}

import UIKit

class CreateServicioViewController: UITableViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate,SweetAlertDelegate {

    let cellId1 = "cellId1"
    let cellId2 = "cellId2"
    let cellId3 = "cellId3"
    
   // let urlLocal = "http://192.168.43.120/api"
    
    let mensajeError = MensajeError(ImageName: "sin_conexion", Titulo: "Oops!", Mensaje: "No hay conexion a internet")
    let loadingView = LoadingView(message: "Cargando...")
    
    let prefs:UserDefaults = UserDefaults.standard
    
    var locations : [Location]?
    
    var pickerOption = [(String,Int)]()
    var pickerLocation = UIPickerView()
    
    var myTextField = UITextField()
    
    var fieldText = String()
    var myTextview = String()
    
    var field = UITextField()
    var textView = UITextView()
    
    var sweetAlert = SweetAlert()
    
    var band = Int()

    var crearMantDelegate : CrearServicioDelegate?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //FETHING LOCATIONS INFO
        fetchingLocations()
        
        sweetAlert.sweetDelegate = self
        
        //SETTING TABLEVIEW
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        
        tableView.register(FormularioServicioTableViewCell.self, forCellReuseIdentifier: cellId1)
        tableView.register(TextViewDescripCell.self, forCellReuseIdentifier: cellId2)
        tableView.register(ContinueTableViewCell.self, forCellReuseIdentifier: cellId3)
        
        //SETTING PICKER
        pickerLocation.delegate = self
        pickerLocation.dataSource = self
        
        //SETTING NAVBAR
        navigationItem.title = "Nueva orden"
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:METODOS DEL TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellId1) as! FormularioServicioTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: cellId2) as! TextViewDescripCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: cellId3) as! ContinueTableViewCell
        
        
        switch indexPath.row {
        case 0:
            
            myTextField = cell1.textfieldLocation
            field = cell1.textfieldLocation
            cell1.textfieldLocation.delegate = self
            cell1.textfieldLocation.inputView = pickerLocation
            return cell1
            
        case 1:
            
            textView = cell2.descripcionTextview
            cell2.descripcionTextview.delegate = self
            return cell2
            
        default:
            
            cell3.enviarButton.addTarget(self, action: #selector(self.crearMantenimiento), for: .touchUpInside)
            return cell3
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case 0:
            
            return 55
        case 1:
            
            return 85
            
        default:
            
            return 120
        }
       
    }
    
    
    //MARK: METODOS DEL TEXTVIEW
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 100
            
    
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        myTextview = textView.text
    }
    
    
    //MARK:METODOS DEL PICKER
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerOption.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOption[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myTextField.text = pickerOption[row].0
        
        fieldText = "\(pickerOption[row].1)"
    }
    
    
    //MARK:METODOS DEL TEXTFIELD
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
    
    
    //MARK:FETCHING LOCATIONS
    func fetchingLocations(){
        
        print("entre al fetching")
        
        mensajeError.hideElements()
        loadingView.showMenuLoad()
        
        
        let url = URL(string: "\(HttpRuta.ruta)/locations")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard data != nil else {
                print("error de data: \(error!)")
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingView.hideLoadingView()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Por favor revise su conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                        
                        if self.locations?.count == nil{
                            //run your function here
                            
                            self.mensajeError.showElements()
                            self.mensajeError.showView()
                            self.mensajeError.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchDown)
                            self.tableView.isHidden = true
                        }
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                })
                
                return
                
            }
            
            
            do{
                
                if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [[String:Any]] {
                    
                    //     print(json)
                    
                    self.locations = [Location]()
                    
                    print(json.count)
                    
                    for x in json{
                        
                        let location = Location()
                        
                        
                        location.id = x["id"] as! Int
                        location.nombre = x["nombre"] as! String
                        location.descripcion = x["descripcion"] as! String
                        
                        self.locations?.append(location)
                        
                        self.pickerOption.append((location.nombre,location.id))
                    }
                    
                    
                    //recargo la data del collectionView de manera asincrona
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                        self.loadingView.hideLoadingView()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        

                        
                        
                    })
                    
                }
                
            } catch let jsonError {
                print("error en el json: \(jsonError)")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loadingView.hideLoadingView()
                self.mensajeError.showElements()
                self.mensajeError.showView()
                self.mensajeError.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchDown)
                self.tableView.isHidden = true
                
            }
            
        }.resume()
        
    }

    
    func reloadData(){
    
        fetchingLocations()

    }
    
    
    
    //MARK: METODO PARA CREAR MANTENIMIENTO
    func crearMantenimiento(){
        
        
        print("toque el boton")
        
        let location_id : NSString = fieldText as NSString
        let estatus : NSString = "Por procesar"
        let descripcion : NSString = myTextview as NSString
        let clientId : Int = prefs.integer(forKey: "ID_CLIENTE") as Int
        let user_ID = 1
        let client_name = "wilmer"
        let ejecutor = "N/A"
        let prioridad = "N/A"
        let origen = "Movil"
        let fecha_emision = "N/A"
        let fecha_ejecucion = "N/A"

        
        if validarCampos() == true{
        
            loadingView.showMenuLoad()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            
            var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/clients/\(clientId)/maintenances")!)
            request.httpMethod = "POST"
            let postString = "location_id=\(location_id)&user_id=\(user_ID)&client_id=\(clientId)&client_name=\(client_name)&ejecutor=\(ejecutor)&estatus=\(estatus)&descripcion_mant=\(descripcion)&prioridad=\(prioridad)&origen=\(origen)&fecha_emision=\(fecha_emision)&fecha_ejecucion=\(fecha_ejecucion)"
            
            print(postString)
            
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(error!)")
                    return
                }
            
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
                    
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.loadingView.hideLoadingView()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Error 500", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    })
                    
                }
                
                //Todo salio bn
                else{
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.loadingView.hideLoadingView()
                        _ = self.sweetAlert.showAlert("Completado!", subTitle: "Su orden de mantenimiento ha sido enviada con exito", style: AlertStyle.success)
                    
                        let responseString = String(data: data, encoding: .utf8)
                        print("responseString = \(responseString!)")
                    
                    })
                
                }
                //aqui poner el sweet alert de error
            }
            
            task.resume()
    
        }else{
            
            loadingView.hideLoadingView()
        
            let alertController = UIAlertController(title: "Error", message: "Por favor llene todos los campos", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        
        }
        
    
    }
    
    
    
    //MARK:METODO PARA VALIDAR QUE LOS CAMPOS NO QUEDEN VACIOS
    func validarCampos() -> Bool{
            
        if fieldText != "" && myTextview != ""{
                
            return true
        }
            
        return false
        
    }
    
    
    func sweetAlertOkButtonPressed() {
        
        band = 1
        
        crearMantDelegate?.pasarDataDelegate(x: band)
        navigationController?.popViewController(animated: true)
        
    }
    
    
 
}

