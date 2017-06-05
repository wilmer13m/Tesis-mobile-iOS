//
//  DetailConsumoTableViewCell.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 29/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class DetailConsumoTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none // para que no se vea el el color gris cuando se seleccione esa celda
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let labelNUmeroOrden : UILabel = {
    
        let label = UILabel()
        label.text = "Nro de orden:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()
    
    let labelAnombreDe : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "A nombre de:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()
    
    let labelCantidad : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "A nombre de:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()
    
    let labelDescrip : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "Desc. :"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()
    
    let labelPrecioUnit : UILabel = {
        
        let label = UILabel()
        label.text = "Precio unit."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()

    
    let labelPrecioTotalItem : UILabel = {
        
        let label = UILabel()
        label.text = "total:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()
    
    let labelTotal : UILabel = {
        
        let label = UILabel()
        label.text = "Total:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()

    
    func setupViews(){
    
        addSubview(labelNUmeroOrden)
        addSubview(labelAnombreDe)
        addSubview(labelCantidad)
        addSubview(labelDescrip)
        addSubview(labelPrecioUnit)
        addSubview(labelPrecioTotalItem)
        addSubview(labelTotal)
        
        
        addConstraint(NSLayoutConstraint(item: labelNUmeroOrden, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: labelNUmeroOrden, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        
        addConstraint(NSLayoutConstraint(item: labelAnombreDe, attribute: .top, relatedBy: .equal, toItem: labelNUmeroOrden, attribute: .bottom, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: labelAnombreDe, attribute: .leading, relatedBy: .equal, toItem: labelNUmeroOrden, attribute: .leading, multiplier: 1, constant: 0))
    
    }
}
