//
//  SelectCurrencyScreenViewController.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

protocol ISelectCurrencyScreenViewController: UIViewController {
    var cancelButtonTappedHandler: (() -> Void)? { get set }
    func setTitle(_ title: String)
    func setSearchPlaceholder(_ placeholder: String)
    func showAlert(title: String, message: String)
}

final class SelectCurrencyScreenViewController: UIViewController {
    
    private let presenter: ISelectCurrencyScreenPresenter
    private let selectScreenView: ISelectCurrencyScreenView
    private var searchController: UISearchController
    
    var cancelButtonTappedHandler: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(presenter: ISelectCurrencyScreenPresenter) {
        self.presenter = presenter
        self.selectScreenView = SelectCurrencyScreenView()
        self.searchController = UISearchController(searchResultsController: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        self.presenter.loadView(controller: self, view: self.selectScreenView)
    }
    
    override func viewDidLoad() {
        self.view = self.selectScreenView
        self.configuireSearchController()
        self.addCancelButton()
    }
    
    private func configuireSearchController() {
        self.searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
    }
    
    private func addCancelButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func cancelButtonTapped() {
        self.cancelButtonTappedHandler?()
    }
    
    
}

extension SelectCurrencyScreenViewController: ISelectCurrencyScreenViewController {
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setSearchPlaceholder(_ placeholder: String) {
        self.searchController.searchBar.placeholder = placeholder
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

extension SelectCurrencyScreenViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.presenter.filteredCurrencies(searchController.searchBar.text)
    }
    
}

