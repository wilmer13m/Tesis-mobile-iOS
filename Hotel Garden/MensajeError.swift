//
//  MensajeError.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 4/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class MensajeError: NSObject {
    
    var imageError : UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var labelTitulo : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelMensaje : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = label.font.withSize(18)
        return label
    }()
    
    let reloadButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Recargar", for: .normal)
        button.setTitleColor(UIColor.naranjaGarden(), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.naranjaGarden().cgColor
        return button
    }()
    
    
    init(ImageName name: String, Titulo titulo: String, Mensaje mensaje: String) {
        imageError.image = UIImage(named: name)
        labelTitulo.text = titulo
        labelMensaje.text = mensaje
    }
    
    
    func showView(){
        setupViews()
    }
    
    
    private func setupViews(){
        
        if let window = UIApplication.shared.keyWindow{
            
            //AÑADIENDO LAS VISTAS A LA VENTANA
            window.addSubview(imageError)
            window.addSubview(labelTitulo)
            window.addSubview(labelMensaje)
            window.addSubview(reloadButton)
            window.backgroundColor = .white
            
            //ADDING CONSTRAINTS
            let CenterXConstraintImage = NSLayoutConstraint(item: imageError, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
            let CenterYConstraintImage = NSLayoutConstraint(item: imageError, attribute: .centerY, relatedBy: .equal, toItem: window, attribute: .centerY, multiplier: 1, constant: 0)
            let WidthImageConstraint = NSLayoutConstraint(item: imageError, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 168)
            let HeightImageConstraint = NSLayoutConstraint(item: imageError, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 168)
            
            let LeadingConstraintLabelTitulo = NSLayoutConstraint(item: labelTitulo, attribute: .top, relatedBy: .equal, toItem: imageError, attribute: .bottom, multiplier: 1, constant: 3)
            let CenterXConstraintLabelTitulo = NSLayoutConstraint(item: labelTitulo, attribute: .centerX, relatedBy: .equal, toItem: imageError, attribute: .centerX, multiplier: 1, constant: 0)
            
            let LeadingConstraintLabelMensaje = NSLayoutConstraint(item: labelMensaje, attribute: .top, relatedBy: .equal, toItem: labelTitulo, attribute: .bottom, multiplier: 1, constant: 1)
            let CenterXConstraintLabelMensaje = NSLayoutConstraint(item: labelMensaje, attribute: .centerX, relatedBy: .equal, toItem: labelTitulo, attribute: .centerX, multiplier: 1, constant: 0)
            
            let TopConstraintButton = NSLayoutConstraint(item: reloadButton, attribute: .top, relatedBy: .equal, toItem: labelMensaje, attribute: .bottom, multiplier: 1, constant: 5)
            
            let CenterXConstraintButton = NSLayoutConstraint(item: reloadButton, attribute: .centerX, relatedBy: .equal, toItem: labelMensaje, attribute: .centerX, multiplier: 1, constant: 0)
            
            let WidthButtonConstraint = NSLayoutConstraint(item: reloadButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 110)
            let HeightButtonConstraint = NSLayoutConstraint(item: reloadButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
            
            NSLayoutConstraint.activate([CenterXConstraintImage,CenterYConstraintImage,WidthImageConstraint, HeightImageConstraint, LeadingConstraintLabelTitulo, CenterXConstraintLabelTitulo,LeadingConstraintLabelMensaje, CenterXConstraintLabelMensaje,TopConstraintButton,CenterXConstraintButton,WidthButtonConstraint,HeightButtonConstraint])
            
        }
        
    }
    
    func hideElements(){
        imageError.isHidden = true
        labelTitulo.isHidden = true
        labelMensaje.isHidden = true
        labelTitulo.isHidden = true
        reloadButton.isHidden = true
    }
    
    
    func showElements(){
        
        imageError.isHidden = false
        labelTitulo.isHidden = false
        labelMensaje.isHidden = false
        labelTitulo.isHidden = false
        reloadButton.isHidden = false
        
        
     }

}

