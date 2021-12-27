//
//  ConverterScreenView.swift
//  CurrencyConverter
//
//  Created by Red Beard on 24.12.2021.
//

import UIKit

protocol IConverterScreenView: UIView {
    var firstSelectCurrencyTappedHandler: (() -> Void)? { get set }
    var secondSelectCurrencyTappedHandler: (() -> Void)? { get set }
    
    var firstCurrencyValueChanged: ((String?) -> Void)? { get set }
    var secondCurrencyValueChanged: ((String?) -> Void)? { get set }
    
    func updateFirstCurrencyView(viewModel: ConverterCurrencyViewModel)
    func updateSecondCurrencyView(viewModel: ConverterCurrencyViewModel)
    
    func updateFirstTextField(_ text: String?)
    func updateSecondTextField(_ text: String?)
    
    func clearTextFields()
}

final class ConverterScreenView: UIView {
    
    private enum Constants {
        static let spacing = CGFloat(16)
    }
    
    private let firstCurrencyView: ICurrencyView = CurrencyView()
    private let secondCurrencyView: ICurrencyView = CurrencyView()
    
    var firstSelectCurrencyTappedHandler: (() -> Void)? {
        didSet {
            self.firstCurrencyView.selectCurrencyTappedHandler = self.firstSelectCurrencyTappedHandler
        }
    }
    var secondSelectCurrencyTappedHandler: (() -> Void)? {
        didSet {
            self.secondCurrencyView.selectCurrencyTappedHandler = self.secondSelectCurrencyTappedHandler
        }
    }
    var firstCurrencyValueChanged: ((String?) -> Void)? {
        didSet {
            self.firstCurrencyView.textFieldValueChanged = self.firstCurrencyValueChanged
        }
    }
    var secondCurrencyValueChanged: ((String?) -> Void)? {
        didSet {
            self.secondCurrencyView.textFieldValueChanged = self.secondCurrencyValueChanged
        }
    }
    
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
        
        self.firstCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        self.secondCurrencyView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

//MARK: Configuire view layout
private extension ConverterScreenView {
    
    func configuireViewLayout() {
        let vStack = UIStackView(arrangedSubviews: [self.firstCurrencyView, self.secondCurrencyView])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = Constants.spacing
        vStack.alignment = .fill
        
        self.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.spacing),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.spacing),
        ])
    }
    
}

extension ConverterScreenView: IConverterScreenView {

    func updateFirstCurrencyView(viewModel: ConverterCurrencyViewModel) {
        self.firstCurrencyView.update(viewModel: viewModel)
    }
    
    func updateSecondCurrencyView(viewModel: ConverterCurrencyViewModel) {
        self.secondCurrencyView.update(viewModel: viewModel)
    }
    
    func updateFirstTextField(_ text: String?) {
        self.firstCurrencyView.updateTextField(text)
    }
    
    func updateSecondTextField(_ text: String?) {
        self.secondCurrencyView.updateTextField(text)
    }
    
    func clearTextFields() {
        self.firstCurrencyView.clearTextField()
        self.secondCurrencyView.clearTextField()
    }
}
