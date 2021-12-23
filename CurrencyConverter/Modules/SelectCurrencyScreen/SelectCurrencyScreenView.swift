//
//  SelectCurrencyScreenView.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

protocol ISelectCurrencyScreenView: UIView {
    
}

final class SelectCurrencyScreenView: UIView {
    
    private let tableView = UITableView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuireView()
    }
    
}

//MARK: Configuire view
private extension SelectCurrencyScreenView {
    
    func configuireView() {
        self.backgroundColor = .systemBackground
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
}

extension SelectCurrencyScreenView: ISelectCurrencyScreenView {
    
}
