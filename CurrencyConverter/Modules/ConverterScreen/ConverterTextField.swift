//
//  ConverterTextField.swift
//  CurrencyConverter
//
//  Created by Red Beard on 26.12.2021.
//

import UIKit

final class ConverterTextField: UITextField {
    
    private enum Constants {
        static let heightBorderline = CGFloat(2)
        static let spacingToLine = CGFloat(5)
        static let bottomInset = Constants.heightBorderline + Constants.spacingToLine
    }
    
    private let borderline = CALayer()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuireView()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func configuireView() {
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.keyboardType = .decimalPad
        
        self.borderStyle = .none
        self.backgroundColor = UIColor.clear
        self.textAlignment = .right
    }
    
}
