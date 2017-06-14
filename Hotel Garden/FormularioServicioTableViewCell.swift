//
//  FormularioServicioTableViewCell.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 4/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class FormularioServicioTableViewCell: UITableViewCell {

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none // para que no se vea el el color gris cuando se seleccione esa celda
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let labelTitle : UILabel = {
        
        let label = UILabel()
        label.text = "Lugar: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        return label
    }()
    
    
    let imageIconPlace : UIImageView = {
        
        let icon = UIImageView()
        icon.clipsToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(named: "place")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = UIColor.naranjaGarden()
        return icon
    }()
    
    
    let textfieldLocation : UITextField = {
    
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    
    let separatorView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.separatorCell()
        return view
        
    }()
    

    
    let descripcionTextview : UITextView = {
        
        let descripcion = UITextView()
        descripcion.translatesAutoresizingMaskIntoConstraints = false
        descripcion.font = UIFont.systemFont(ofSize: 15)
        descripcion.autocorrectionType = .no
        descripcion.text = "Descripcion"
        descripcion.textColor = UIColor.lightGray
        return descripcion
    }()
    
    
    let separatorView2 : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.separatorCell()
        return view
        
    }()
    
    
    func setupViews(){
        
        addSubview(labelTitle)
        addSubview(imageIconPlace)
        addSubview(textfieldLocation)
        addSubview(separatorView)
        addSubview(separatorView2)
//
        
        addConstraint(NSLayoutConstraint(item: labelTitle, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: labelTitle, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        
        addConstraint(NSLayoutConstraint(item: imageIconPlace, attribute: .top, relatedBy: .equal, toItem: labelTitle, attribute: .bottom, multiplier: 1, constant: 3))
        addConstraint(NSLayoutConstraint(item: imageIconPlace, attribute: .leading, relatedBy: .equal, toItem: labelTitle, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageIconPlace, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        addConstraint(NSLayoutConstraint(item: imageIconPlace, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        
        addConstraint(NSLayoutConstraint(item: textfieldLocation, attribute: .top, relatedBy: .equal, toItem: labelTitle, attribute: .bottom, multiplier: 1, constant: 3))
        addConstraint(NSLayoutConstraint(item: textfieldLocation, attribute: .leading, relatedBy: .equal, toItem: imageIconPlace, attribute: .trailing, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: textfieldLocation, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10))

        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .top, relatedBy: .equal, toItem: textfieldLocation, attribute: .bottom, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .leading, relatedBy: .equal, toItem: textfieldLocation, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        
    
        
    }
    

}


class ContinueTableViewCell: UITableViewCell {
   
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        selectionStyle = .none // para que no se vea el el color gris cuando se seleccione esa celda
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let enviarButton : UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Enviar", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .azul()
        button.layer.cornerRadius = 3
        
        return button
        
    }()
    
    func setupViews(){
    
        addSubview(enviarButton)
        
        
        addConstraint(NSLayoutConstraint(item: enviarButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: enviarButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: enviarButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint(item: enviarButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45))

    
    }
    
}


class TextViewDescripCell : UITableViewCell {


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none // para que no se vea el el color gris cuando se seleccione esa celda
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let labelTitle : UILabel = {
        
        let label = UILabel()
        label.text = "Descripcion: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        return label
    }()
    
    
    let imageIconDescrip : UIImageView = {
        
        let icon = UIImageView()
        icon.clipsToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(named: "reservas")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = UIColor.naranjaGarden()
        return icon
    }()
    
    let descripcionTextview : UITextView = {
        
        let descripcion = UITextView()
        descripcion.translatesAutoresizingMaskIntoConstraints = false
        descripcion.font = UIFont.systemFont(ofSize: 15)
        descripcion.autocorrectionType = .no
        return descripcion
    }()
    
    
    let separatorView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.separatorCell()
        return view
        
    }()

    
    func setupViews(){
    
        addSubview(labelTitle)
        addSubview(imageIconDescrip)
        addSubview(descripcionTextview)
        addSubview(separatorView)
        
        
        addConstraint(NSLayoutConstraint(item: labelTitle, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: labelTitle, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        
        
        addConstraint(NSLayoutConstraint(item: imageIconDescrip, attribute: .top, relatedBy: .equal, toItem: labelTitle, attribute: .bottom, multiplier: 1, constant: 3))
        addConstraint(NSLayoutConstraint(item: imageIconDescrip, attribute: .leading, relatedBy: .equal, toItem: labelTitle, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageIconDescrip, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        addConstraint(NSLayoutConstraint(item: imageIconDescrip, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        
        addConstraint(NSLayoutConstraint(item: descripcionTextview, attribute: .top, relatedBy: .equal, toItem: labelTitle, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: descripcionTextview, attribute: .leading, relatedBy: .equal, toItem: imageIconDescrip, attribute: .trailing, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: descripcionTextview, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint(item: descripcionTextview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))

        
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .leading, relatedBy: .equal, toItem: descripcionTextview, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        
    
    }


}

