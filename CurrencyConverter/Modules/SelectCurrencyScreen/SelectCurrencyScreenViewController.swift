//
//  SelectCurrencyScreenViewController.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

protocol ISelectCurrencyScreenViewController: UIViewController {
    
}

final class SelectCurrencyScreenViewController: UIViewController {
    
    private let presenter: ISelectCurrencyScreenPresenter
    private let selectScreenView: ISelectCurrencyScreenView
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(presenter: ISelectCurrencyScreenPresenter) {
        self.presenter = presenter
        self.selectScreenView = SelectCurrencyScreenView()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        self.presenter.loadView(controller: self, view: self.selectScreenView)
    }
    
    override func viewDidLoad() {
        self.view = self.selectScreenView
        self.title = "Title"
    }
    
}

extension SelectCurrencyScreenViewController: ISelectCurrencyScreenViewController {
    
}

