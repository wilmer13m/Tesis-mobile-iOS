//
//  CambiarPasswordCellTableViewCell.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 25/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class CambiarPasswordCellTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none // para que no se vea el el color gris cuando se seleccione esa celda
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let imageIconPlace : UIImageView = {
        
        let icon = UIImageView()
        icon.clipsToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(named: "lock")?.withRenderingMode(.alwaysTemplate)
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
    
    
    func setupViews(){
    
        addSubview(imageIconPlace)
        addSubview(textfieldLocation)
        addSubview(separatorView)
        
        
        
        addConstraint(NSLayoutConstraint(item: imageIconPlace, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: imageIconPlace, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: textfieldLocation, attribute: .leading, relatedBy: .equal, toItem: imageIconPlace, attribute: .trailing, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: textfieldLocation, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))

    
    
    }
    
    
    
    

}
