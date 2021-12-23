//
//  SelectCurrencyScreenTableAdapter.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

protocol ISelectCurrencyScreenTableAdapter: AnyObject {
    var tableView: UITableView? { get set }
}

final class SelectCurrencyScreenTableAdapter {
    
//    private var
    weak var tableView: UITableView?
    
}

extension SelectCurrencyScreenTableAdapter: ISelectCurrencyScreenTableAdapter {
    
}
