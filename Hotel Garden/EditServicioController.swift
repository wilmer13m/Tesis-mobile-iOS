//
//  EditMantenimientoViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 6/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class EditServicioViewController: UITableViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate,SweetAlertDelegate {

    //var que traigo del controlador anterior
    var descrip = String()
    var lugarNombre = String()
    var lugarId = Int()
    var idSolicitud = Int()
    var idMaintenances = Int()
    
    
    let cellId1 = "cellId"
    let cellId2 = "cellId2"
    let cellId3 = "cellId3"
    
    
    let mensajeError = MensajeError(ImageName: "sin_conexion", Titulo: "Oops!", Mensaje: "No hay conexion a internet")
    let loadingView = LoadingView(message: "Cargando...")
    
    let prefs:UserDefaults = UserDefaults.standard
    
    var locations : [Location]?
    
    var pickerOption = [(String,Int)]()
    var pickerLocation = UIPickerView()
    
    var myTextField = UITextField()
    
    var fieldText = String()
    var fieldTextId = Int()
    var myTextview = String()
    
    var field = UITextField()
    var textView = UITextView()
    
    var sweetAlert = SweetAlert()
    
    var band = Int()
    
    var crearMantDelegate : CrearServicioDelegate?

    var nombreSitio = String()
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        fetchingLocations()
        
        tableView.reloadData()
        
        fieldText = String()
        myTextview = String()
        print("este es fieldtext: \(fieldText)")
        print("este es el id: \(idSolicitud)")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("entre al viewdidload")
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
        navigationItem.title = "Editar orden"
        navigationController?.navigationBar.tintColor = .white
        
        print("la descripcion q pase ES \(descrip) y el id del lugar es: \(lugarId)")
        
        
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
            cell1.textfieldLocation.text = nombreSitio
            cell1.textfieldLocation.delegate = self
            cell1.textfieldLocation.inputView = pickerLocation
            return cell1
            
        case 1:
            
            myTextview = cell2.descripcionTextview.text
            cell2.descripcionTextview.text = descrip
            cell2.descripcionTextview.delegate = self
            return cell2
            
        default:
            
            cell3.enviarButton.setTitle("Editar", for: .normal)
            cell3.enviarButton.addTarget(self, action: #selector(self.editarMantenimiento), for: .touchUpInside)
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
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
            
        }else if text != "\n"{
            
            guard let text = textView.text else {
                
                return true
            }
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            
            let numberOfChars = newText.characters.count
            return numberOfChars <= 70
        }
        
        
        return true
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        myTextview = textView.text
    }
    
    
    //MARK: METODOS DEL TEXTFIELD
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        fieldText = textField.text!
        
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
        
        fieldTextId = pickerOption[row].1
    }
    
        
    
    
    //MARK:FETCHING All LOCATIONS
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
                    self.pickerOption.removeAll()
                    
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
                        
                        let locat = self.locations!.filter({$0.id == self.lugarId})
                        
                        self.nombreSitio = locat[0].nombre
                        
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

    
    
    //MARK:METODO PARA EDITAR EL REGISTRO
    func editarMantenimiento(){
    
        if  (validarCampos() == true) {
            
            var lugar_id = String()
            var descripPut = String()
            
            if fieldText != ""{
                lugar_id = "\(fieldTextId)"
            }else{
                lugar_id = "\(lugarId)"
            }
            
            if myTextview != ""{
                
                descripPut = self.myTextview
            
            }else{
                
                descripPut = descrip
            
            }
            
            let clientId : Int = prefs.integer(forKey: "ID_CLIENTE") as Int
        
            loadingView.showMenuLoad()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            
            var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/clients/\(clientId)/maintenances/\(idSolicitud)")!)
            
            
            request.httpMethod = "PUT"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            let postString = "location_id=\(lugar_id)&descripcion_mant=\(descripPut)"
            request.httpBody = postString.data(using: .utf8)

            print(postString)
            
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
                        
                        let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Por favor revise su conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    })
                    
                }
                
                //Todo salio bn
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.loadingView.hideLoadingView()
                    _ = self.sweetAlert.showAlert("Completado!", subTitle: "Su orden de mantenimiento ha sido editada con exito", style: AlertStyle.success)
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString!)")
                    
                })
                
                
                //aqui poner el sweet alert de error
            }
            
            task.resume()
    
        
        }else{
        
            print("no pase alguna validacion")
            
            let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Debe modificar al menos un campo para completar el proceso de edicion", preferredStyle: UIAlertControllerStyle.alert)
            
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
        
        }
    
    }
    
    
    //MARK:METODO PARA VALIDAR QUE LOS CAMPOS NO QUEDEN VACIOS
    func validarCampos() -> Bool{
        
        if fieldText != "" || myTextview != ""{
            
            return true
        }
        
        return false
        
    }
    
    
    
    //MARK: METODO DEL PROTOCOLO SWEETALERT
    func sweetAlertOkButtonPressed() {
        
        band = 1
        
        crearMantDelegate?.pasarDataDelegate(x: band)
        navigationController?.popViewController(animated: true)
        
    }



}
