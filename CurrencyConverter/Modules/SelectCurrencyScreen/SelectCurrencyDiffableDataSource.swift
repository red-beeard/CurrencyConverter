//
//  SelectCurrencyDiffableDataSource.swift
//  CurrencyConverter
//
//  Created by Red Beard on 25.12.2021.
//

import UIKit

//MARK: SectionIdenfier
enum SectionIdenfier: String, CaseIterable {
    case country = "Country"
    case crypro = "Crypto"
    case metal = "Metal"
}


//MARK: Typealias snapshot
typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdenfier, SelectCurrencyScreenViewModel>
typealias TableViewData = Dictionary<SectionIdenfier, [SelectCurrencyScreenViewModel]>

final class DiffableDataSource: UITableViewDiffableDataSource<SectionIdenfier, SelectCurrencyScreenViewModel> {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionIdenfier.allCases[section].rawValue
    }
    
}
