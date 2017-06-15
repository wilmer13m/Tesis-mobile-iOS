//
//  OrderConsumoTableViewCell.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 14/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class OrderConsumoTableViewCell: UITableViewCell {

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none // para que no se vea el el color gris cuando se seleccione esa celda
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let titleLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    
    }()
    
    let cantidadLabel : UILabel = {
    
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    
    }()
    
    
    func setupViews(){
        
        addSubview(titleLabel)
        addSubview(cantidadLabel)
    
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        
        addConstraint(NSLayoutConstraint(item: cantidadLabel, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: cantidadLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10))
    
    }
    
}
