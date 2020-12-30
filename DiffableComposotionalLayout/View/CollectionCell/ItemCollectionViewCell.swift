//
//  ItemCollectionViewCell.swift
//  DiffableComposotionalLayout
//
//  Created by Sujeet.Kumar on 21/12/20.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet weak var itemSubTitle: UILabel!
    
    @IBOutlet weak var itemstatus: UILabel! {
        didSet {
            itemstatus.text = "progress"
        }
    }
    
    @IBOutlet weak var itemButton: UIButton! {
        didSet {
            
        }
    }
}
