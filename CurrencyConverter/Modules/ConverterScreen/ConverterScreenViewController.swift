//
//  ConverterScreenViewController.swift
//  CurrencyConverter
//
//  Created by Red Beard on 24.12.2021.
//

import UIKit

protocol IConverterScreenViewController: UIViewController {
    func setTitle(_ title: String)
    func showAlert(title: String, message: String)
}

final class ConverterScreenViewController: UIViewController {
    
    private let presenter: IConverterScreenPresenter
    private let converterScreenView: IConverterScreenView
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(presenter: IConverterScreenPresenter) {
        self.presenter = presenter
        self.converterScreenView = ConverterScreenView()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        self.presenter.loadView(controller: self, view: self.converterScreenView)
    }
    
    override func viewDidLoad() {
        self.view = self.converterScreenView
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

extension ConverterScreenViewController: IConverterScreenViewController {
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alertVC.addAction(okAction)
        
        self.present(alertVC, animated: true)
    }
    
}
