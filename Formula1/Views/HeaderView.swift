//
//  HeaderView.swift
//  Formula1
//
//  Created by Helen Stepaniuk on 26.01.2021.
//

import UIKit

class HeaderView: UIView {

    var topLabelText: String? {
        didSet {
            topLabel.text = topLabelText
        }
    }
    
    var bottomLabelText: String? {
        didSet {
            bottomLabel.text = bottomLabelText
        }
    }
    
    private let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let bottomLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "arrow")
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.tintColor = .clear
        return iv
    }()
    
    private func layout() {
        
        backgroundColor = .white
        
        let verticalStackView = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
        verticalStackView.distribution = .fillEqually
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(verticalStackView)
        
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let horizontalStackView = UIStackView(arrangedSubviews: [verticalStackView, imageView])
        horizontalStackView.distribution = .fill
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 9
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            horizontalStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

