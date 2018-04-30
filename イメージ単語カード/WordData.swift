//
//  WordData.swift
//  イメージ単語カード
//
//  Created by 青山聡一郎 on 2018/01/25.
//  Copyright © 2018年 S.Aoyama. All rights reserved.
//

import Foundation
import RealmSwift

class WordData: Object {
    @objc dynamic var wordName = ""
    @objc dynamic var translation1 = ""
    @objc dynamic var translation2 = ""
    @objc dynamic var translation3 = ""
    @objc dynamic var imageUrl = ""
    
    override static func primaryKey() -> String? {
        return "wordName"
    }
}

