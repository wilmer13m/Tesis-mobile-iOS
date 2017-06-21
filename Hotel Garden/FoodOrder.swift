//
//  FoodOrder.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 17/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class FoodOrder: NSObject {
    
    var id = Int()
    var reservation_id = String()
    var client_id = String()
    var user_id = Int()
    var roomId = Int()
    var location_id = Int()
    var origin_id = Int()
    var estatus = String()
    var fecha_orden = String()
    var hora_orden = String()
    var created_at = String()
    var updated_at = String()
    var operation_id = String()
    var details = [Detail]()
    var articles = [ArticleList]()
        
}
