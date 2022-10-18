//
//  BaseVIew.swift
//  testMap
//
//  Created by Даниил Ермоленко on 18.10.2022.
//

import UIKit

class InfoView: UIView {
    // MARK: - Properties
    let nameLabel: UILabel = {
        let label = EdgeInsetLabel()
        label.textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        label.textColor = Colors.darkBlue.uiColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = Colors.darkBlue.uiColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .medium))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var infoStackView = UIStackView()
    // MARK: - init
    required init(name: String) {
        self.nameLabel.text = name
        super.init(frame: .zero)
        
        setupViews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - setupViews
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        translatesAutoresizingMaskIntoConstraints = false
        
        infoStackView = UIStackView(arrangedSubviews: [nameLabel,
                                                       valueLabel],
                                    axis: .vertical,
                                    spacing: 10)
        infoStackView.distribution = .fillEqually
        addSubview(infoStackView)
    }
    // MARK: - setConstraints
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
