//
//  ItemBadgeReusableView.swift
//  DiffableComposotionalLayout
//
//  Created by Sujeet.Kumar on 22/12/20.
//

import UIKit

class badgeReusableView:UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: badgeReusableView.self)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(
            ofSize: 8)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        addSubview(titleLabel)
        
        self.titleLabel.centerYAnchor.anchorWithOffset(to: self.centerYAnchor)
        self.titleLabel.centerXAnchor.anchorWithOffset(to: self.centerXAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
