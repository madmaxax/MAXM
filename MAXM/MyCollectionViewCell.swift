//
//  MyCollectionViewCell.swift
//  MAXM
//
//  Created by Max on 09.01.18.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayText: UITextField!
    @IBOutlet weak var dayDate: UITextField!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.layer.borderWidth = 5.0
            } else {
                self.transform = CGAffineTransform.identity
                self.layer.borderWidth = 2.0
            }
        }
    }
}
