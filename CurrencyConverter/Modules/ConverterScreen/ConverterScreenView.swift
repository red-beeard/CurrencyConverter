//
//  ConverterScreenView.swift
//  CurrencyConverter
//
//  Created by Red Beard on 24.12.2021.
//

import UIKit

protocol IConverterScreenView: UIView {
    
}

final class ConverterScreenView: UIView {
    
    private enum Constants {
        static let spacing = CGFloat(20)
    }
    
    private let firstCurrencyView: ICurrencyView = CurrencyView()
    private let secondCurrencyView: ICurrencyView = CurrencyView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuireView()
        self.configuireViewLayout()
    }
    
    
    
}

//MARK: Configuire view
private extension ConverterScreenView {
    
    func configuireView() {
        self.backgroundColor = .systemBackground
        
        self.configuireCurrencyView(self.firstCurrencyView)
        self.configuireCurrencyView(self.secondCurrencyView)
    }
    
    func configuireCurrencyView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

//MARK: Configuire view
private extension ConverterScreenView {
    
    func configuireViewLayout() {
        let vStack = UIStackView(arrangedSubviews: [self.firstCurrencyView, self.secondCurrencyView])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = Constants.spacing
        vStack.alignment = .fill
        
        self.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.spacing),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.spacing),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.spacing),
        ])
    }
    
}

extension ConverterScreenView: IConverterScreenView {
    
}
