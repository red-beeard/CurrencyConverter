//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

protocol ICurrencyCell {
    static var indentifier: String { get }
    func update(viewModel: SelectCurrencyScreenViewModel)
}

final class CurrencyCell: UITableViewCell {
    
    static let indentifier = "CurrencyCell"
    
    private enum Constants {
        static let flagCountryCornerRadius = CGFloat(3)
        static let currencyCodeFontSize = CGFloat(16)
        static let currencyNameFontSize = CGFloat(12)
        
        static let spacingToScreen = CGFloat(20)
        static let spacingInCell = CGFloat(10)
        static let spacingInStack = CGFloat(0)
        
        static let noFlagImageName = "flag.slash.circle"
    }
    
    let flagImageView = UIImageView()
    let currencyCode = UILabel()
    let currencyName = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configuireView()
        self.configuireViewLayout()
    }
    
}

//MARK: Configuire view
private extension CurrencyCell {
    
    func configuireView() {
        self.configuireFlagCountry()
        self.configuireCurrencyCode()
        self.configuireCurrencyName()
    }
    
    func configuireFlagCountry() {
        self.flagImageView.translatesAutoresizingMaskIntoConstraints = false
        self.flagImageView.clipsToBounds = true
        self.flagImageView.layer.cornerRadius = Constants.flagCountryCornerRadius
        self.flagImageView.contentMode = .scaleAspectFit
    }
    
    func configuireCurrencyCode() {
        self.currencyCode.translatesAutoresizingMaskIntoConstraints = false
        self.currencyCode.textAlignment = .left
        self.currencyCode.font = UIFont.boldSystemFont(ofSize: Constants.currencyCodeFontSize)
        self.currencyCode.textColor = .label
    }
    
    func configuireCurrencyName() {
        self.currencyName.translatesAutoresizingMaskIntoConstraints = false
        self.currencyName.textAlignment = .left
        self.currencyName.font = UIFont.boldSystemFont(ofSize: Constants.currencyNameFontSize)
        self.currencyName.textColor = .secondaryLabel
    }
    
}

//MARK: Configuire view layout
private extension CurrencyCell {
    
    func configuireViewLayout() {
        self.configuireFlagCountryLayout()
        self.configuireCurrencyCodeNameLayout()
    }
    
    func configuireFlagCountryLayout() {
        self.contentView.addSubview(self.flagImageView)
        
        NSLayoutConstraint.activate([
            self.flagImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Constants.spacingToScreen),
            self.flagImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constants.spacingInCell),
            self.flagImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Constants.spacingInCell),
            self.flagImageView.widthAnchor.constraint(equalTo: self.flagImageView.heightAnchor)
        ])
    }
    
    func configuireCurrencyCodeNameLayout() {
        let vStack = UIStackView(arrangedSubviews: [self.currencyCode, self.currencyName])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = Constants.spacingInStack
        
        self.contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: self.flagImageView.trailingAnchor, constant: Constants.spacingInCell),
            vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Constants.spacingToScreen),
            vStack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
}

extension CurrencyCell: ICurrencyCell {
    
    func update(viewModel: SelectCurrencyScreenViewModel) {
        self.currencyCode.text = viewModel.currencyCode
        self.currencyName.text = viewModel.currencyName
        
        if let data = viewModel.image, let image = UIImage(data: data) {
            self.flagImageView.image = image
        } else {
            let image = UIImage(systemName: Constants.noFlagImageName)?.withTintColor(.systemGray)
            self.flagImageView.image = image
        }
    }
    
}
