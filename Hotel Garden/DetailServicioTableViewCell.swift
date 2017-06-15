//
//  DetailServicioTableViewCell.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 14/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class DetailServicioTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let titleLabel : UILabel = {
    
        let label = UILabel()
        label.text = "Lugar: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let descripLabel : UILabel = {
        
        let label = UILabel()
        label.text = "se daño el aire"
        label.numberOfLines = 3
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    func setupViews(){
    
        addSubview(titleLabel)
        addSubview(descripLabel)
    
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        
        addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 2))
        addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -5))
        
    }
    
    
    
    
    
    
}
