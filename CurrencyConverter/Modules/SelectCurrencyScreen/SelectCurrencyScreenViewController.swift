//
//  SelectCurrencyScreenViewController.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

protocol ISelectCurrencyScreenViewController: UIViewController {
    func setTitle(_ title: String)
    func setSearchPlaceholder(_ placeholder: String)
}

final class SelectCurrencyScreenViewController: UIViewController {
    
    private let presenter: ISelectCurrencyScreenPresenter
    private let selectScreenView: ISelectCurrencyScreenView
    private var searchController: UISearchController
    
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
    }
    
    private func configuireSearchController() {
        self.searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
    }
    
}

extension SelectCurrencyScreenViewController: ISelectCurrencyScreenViewController {
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setSearchPlaceholder(_ placeholder: String) {
        self.searchController.searchBar.placeholder = placeholder
    }
    
}

extension SelectCurrencyScreenViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.presenter.filteredCurrencies(searchController.searchBar.text)
    }
    
}

