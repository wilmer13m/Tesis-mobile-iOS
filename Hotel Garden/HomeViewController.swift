//
//  ViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 26/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit
import StretchHeader

class HomeViewController: UITableViewController {

    let cellId1 = "cellId1"
    let cellId2 = "cellID2"
    
    let prefs:UserDefaults = UserDefaults.standard

    
    var header : StretchHeader!

    let settings: [Setting] = {
        return [Setting(name: "Consumos",imageName : "servicios",color: UIColor.azul(),descripcion: "Revise sus consumos aqui"),Setting(name: "Servicios",imageName : "reservas",color: UIColor.verde(),descripcion:"Informacion de servicios"),Setting(name: "Galeria",imageName : "galeria",color: UIColor.morado(),descripcion:"conozca nuestras instalaciones")]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        
        //SETTING TABLEVIEW
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        
        tableView.register(HomeTableViewCell1.self, forCellReuseIdentifier: cellId1)
       // tableView.register(HomeTableViewCell2.self, forCellReuseIdentifier: cellId2)
        
       navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"logout")?.withRenderingMode(.alwaysTemplate) , style: .done, target: self, action: #selector(self.logOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        //VIENDO SI EL USUARIO YA HA INICIADO SESION PREVIAMENTE
        print("\(prefs.integer(forKey: "ISLOGGEDIN") as Int)")
        
     

        
        setupHeaderView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
        
        switch isLoggedIn {
            
        case 1:
            
            print("Ya inicio sesion lo dejo en el main Screen")
            
        default:
            
            let loginViewController = LoginViewController()
            present(loginViewController, animated: false, completion: nil)
            print("lo mande al login porque no ha iniciado sesion")
            break
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: TABLEVIEW METHODS DELEGATES
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellId1) as! HomeTableViewCell1
        
            cell1.setting = settings[indexPath.row]
            return cell1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let consumoViewController = ConsumoViewController(style: .plain)
            self.navigationController?.pushViewController(consumoViewController, animated: true)
            
            break
            
        case 1:
            
            let servicioViewController = ServicioViewController(style: .plain)
            self.navigationController?.pushViewController(servicioViewController, animated: true)

            break
            
            
        case 2:
            
            let mantenimientos = MantenimientosViewController(style: .plain)
            self.navigationController?.pushViewController(mantenimientos, animated: true)
            
            break
            
            
        default:
            break
        }
        
    }

    
    //MARK: METODO PARA SETEAR EL HEADER DE LA TABLA
    func setupHeaderView() {
        
        let options = StretchHeaderOptions()
        options.position = .underNavigationBar
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 220),
                                 imageSize: CGSize(width: view.frame.size.width, height: 220),
                                 controller: self,
                                 options: options)
        
        header.imageView.image = UIImage(named: "hotel")
        header.imageView.contentMode = .scaleToFill
        header.imageView.layer.masksToBounds = true
        tableView.tableHeaderView = header
    }
    
    
    // MARK: - ScrollView Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
        
    }
    
    //MARK: METODO PARA DESLOGUEARSE
    func logOut(){
    
        let alertController = UIAlertController(title: "Logout", message: "¿Esta seguro que desea cerrar sesion?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .destructive) {
            (result : UIAlertAction) -> Void in
            
            let prefs:UserDefaults = UserDefaults.standard
            prefs.set(0, forKey: "ISLOGGEDIN") //asigando el valor 0 porque el cliente se deslogueo
            let loginVc = LoginViewController()
            
            self.present(loginVc, animated: true, completion: nil)
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("cancel")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    
    }



}

