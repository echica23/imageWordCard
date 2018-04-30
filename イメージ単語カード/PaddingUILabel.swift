//
//  PaddingUILabel.swift
//  イメージ単語カード
//
//  Created by 青山聡一郎 on 2018/01/26.
//  Copyright © 2018年 S.Aoyama. All rights reserved.
//

import UIKit

class PaddingUILabel : UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
        
}
