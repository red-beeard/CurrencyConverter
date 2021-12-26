//
//  CurrencyView.swift
//  CurrencyConverter
//
//  Created by Red Beard on 24.12.2021.
//

import UIKit

protocol ICurrencyView: UIView {
    
}

final class CurrencyView: UIView {
    
    private enum Constants {
        static let spacingInStack = CGFloat(10)
        static let spacingBetweenLabels = CGFloat(0)
        static let spacingToBorder = CGFloat(10)
        static let spacingToTextField = CGFloat(5)
        
        static let heightBorderline = CGFloat(2)
        
        static let cornerRadius = CGFloat(10)
        static let chevronImage = UIImage(systemName: "chevron.right")
        
        static let currencyCodeFontSize = CGFloat(20)
        static let currencyNameFontSize = CGFloat(14)
        static let valueTextFieldFontSize = CGFloat(30)
    }
    
    private let flagImageView = UIImageView()
    private let currencyCode = UILabel()
    private let currencyName = UILabel()
    private let chevronImageView = UIImageView(image: Constants.chevronImage)
    private let valueTextField = ConverterTextField()
    private let borderline = UIView()
    
    private let currencyStack = UIStackView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuireView()
        self.configuireViewLayout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
}

//MARK: Configuire view
private extension CurrencyView {
    
    func configuireView() {
        self.backgroundColor = .systemFill
        self.layer.cornerRadius = Constants.cornerRadius
        
        self.configuireCurrencyStackView()
        self.configuireTextField()
        self.configuireBorderline()
    }
    
    func configuireCurrencyStackView() {
        self.currencyStack.translatesAutoresizingMaskIntoConstraints = false
        self.currencyStack.axis = .horizontal
        self.currencyStack.alignment = .center
        self.currencyStack.spacing = Constants.spacingInStack
        self.currencyStack.distribution = .fill
        
        self.configuireFlagImageView()
        self.configuireCurrencyCode()
        self.configuireCurrencyName()
        self.configuireChevronImageView()
    }
    
    func configuireFlagImageView() {
        self.flagImageView.translatesAutoresizingMaskIntoConstraints = false
        self.flagImageView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        self.flagImageView.contentMode = .scaleAspectFit
        
        self.flagImageView.image = UIImage(named: "usd")
    }
    
    func configuireCurrencyCode() {
        self.currencyCode.translatesAutoresizingMaskIntoConstraints = false
        self.currencyCode.textAlignment = .left
        self.currencyCode.font = UIFont.boldSystemFont(ofSize: Constants.currencyCodeFontSize)
        
        self.currencyCode.text = "USD"
    }
    
    func configuireCurrencyName() {
        self.currencyName.translatesAutoresizingMaskIntoConstraints = false
        self.currencyName.textAlignment = .left
        self.currencyName.font = UIFont.systemFont(ofSize: Constants.currencyNameFontSize)
        self.currencyName.textColor = .secondaryLabel
        
        self.currencyName.text = "American Dollar"
    }
    
    func configuireChevronImageView() {
        self.chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        self.chevronImageView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        self.tintColor = .systemGray
    }
    
    func configuireTextField() {
        self.valueTextField.translatesAutoresizingMaskIntoConstraints = false
        self.valueTextField.font = UIFont.systemFont(ofSize: Constants.valueTextFieldFontSize)
        
        self.valueTextField.placeholder = "0.0"
    }
    
    func configuireBorderline() {
        self.borderline.translatesAutoresizingMaskIntoConstraints = false
        self.borderline.backgroundColor = UIColor.secondarySystemFill
    }
    
}

//MARK: Configuire view layout
private extension CurrencyView {
    
    func configuireViewLayout() {
        self.configuireCurrencyStackViewLayout()
        self.configuireTextFieldLayout()
        self.configuireBorderlineLayout()
    }
    
    func configuireCurrencyStackViewLayout () {
        let labelsStack = UIStackView(arrangedSubviews: [self.currencyCode, self.currencyName])
        labelsStack.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.axis = .vertical
        labelsStack.spacing = Constants.spacingBetweenLabels
        
        self.currencyStack.addArrangedSubview(self.flagImageView)
        self.currencyStack.addArrangedSubview(labelsStack)
        self.currencyStack.addArrangedSubview(self.chevronImageView)
        
        self.addSubview(self.currencyStack)
        NSLayoutConstraint.activate([
            self.currencyStack.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.spacingToBorder),
            self.currencyStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.spacingToBorder),
            self.currencyStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.spacingToBorder),
        ])
    }
    
    func configuireTextFieldLayout() {
        self.addSubview(self.valueTextField)
        
        NSLayoutConstraint.activate([
            self.valueTextField.topAnchor.constraint(equalTo: self.currencyStack.bottomAnchor, constant: Constants.spacingToTextField),
            self.valueTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.spacingToBorder),
            self.valueTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.spacingToBorder),
        ])
    }
    
    func configuireBorderlineLayout() {
        self.addSubview(self.borderline)
        
        NSLayoutConstraint.activate([
            self.borderline.topAnchor.constraint(equalTo: self.valueTextField.bottomAnchor, constant: Constants.spacingToTextField),
            self.borderline.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.spacingToBorder),
            self.borderline.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.spacingToBorder),
            self.borderline.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.spacingToBorder),
            self.borderline.heightAnchor.constraint(equalToConstant: Constants.heightBorderline)
        ])
    }
    
}

extension CurrencyView: ICurrencyView {
    
}
