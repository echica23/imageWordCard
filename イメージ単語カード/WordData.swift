//
//  WordData.swift
//  イメージ単語カード
//
//  Created by 青山聡一郎 on 2018/01/25.
//  Copyright © 2018年 S.Aoyama. All rights reserved.
//

import Foundation
import RealmSwift

/// 単語データ(Realmに保存）
class WordData: Object {
    
    // 単語名
    @objc dynamic var wordName = ""
    
    // 訳１〜３
    @objc dynamic var translation1 = ""
    @objc dynamic var translation2 = ""
    @objc dynamic var translation3 = ""
    
    // 画像URL
    @objc dynamic var imageUrl = ""
    
    // チェック
    @objc dynamic var isCheck = false
    
    // 作成日時
    @objc dynamic var updated: Double = Date().timeIntervalSince1970
    
    // 単語名がprimaryKey
    override static func primaryKey() -> String? {
        return "wordName"
    }
}

