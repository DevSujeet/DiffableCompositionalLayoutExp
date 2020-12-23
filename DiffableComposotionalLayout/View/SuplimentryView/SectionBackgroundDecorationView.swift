//
//  SectionBackgroundDecorationView.swift
//  DiffableComposotionalLayout
//
//  Created by Sujeet.Kumar on 23/12/20.
//

import UIKit

class SectionBackgroundDecorationView : UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: SectionBackgroundDecorationView.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemYellow
        self.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
