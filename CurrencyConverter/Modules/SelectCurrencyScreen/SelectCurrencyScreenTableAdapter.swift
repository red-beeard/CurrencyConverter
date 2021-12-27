//
//  SelectCurrencyScreenTableAdapter.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

//MARK: Protocols
protocol ISelectCurrencyScreenTableAdapter: AnyObject {
    var tableView: UITableView? { get set }
    var delegate: SelectCurrencyScreenTableAdapterDelegate? { get set }
    func update(_ currencies: TableViewData)
}

protocol SelectCurrencyScreenTableAdapterDelegate: AnyObject {
    func onItemSelect(currencyCode: String)
}

//MARK: SelectCurrencyScreenTableAdapter
final class SelectCurrencyScreenTableAdapter: NSObject {
    
    private var currencies = Dictionary<SectionIdenfier, [SelectCurrencyScreenViewModel]>()
    private var dataSource: DiffableDataSource?
    weak var delegate: SelectCurrencyScreenTableAdapterDelegate?
    
    weak var tableView: UITableView? {
        didSet {
            guard let tableView = tableView else {
                return
            }
            
            let dataSource = makeDataSource(for: tableView)
            self.dataSource = dataSource
            self.tableView?.dataSource = dataSource
            self.tableView?.delegate = self
            self.tableView?.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.indentifier)
        }
    }
    
}

//MARK: ISelectCurrencyScreenTableAdapter
extension SelectCurrencyScreenTableAdapter: ISelectCurrencyScreenTableAdapter {
    
    func update(_ currencies: TableViewData) {
        self.currencies = currencies
        applySnapshot(animatingDifferences: false)
    }
    
}

//MARK: Diffable data source
extension SelectCurrencyScreenTableAdapter {
    
    private func makeDataSource(for tableView: UITableView) -> DiffableDataSource {
        let dataSource = DiffableDataSource(tableView: tableView) { tableView, indexPath, itemViewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.indentifier, for: indexPath)
            
            if let cell = cell as? CurrencyCell {
                cell.update(viewModel: itemViewModel)
            }
            
            return cell
        }
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections(SectionIdenfier.allCases)
        for section in SectionIdenfier.allCases {
            snapshot.appendItems(self.currencies[section] ?? [], toSection: section)
        }
    
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

extension SelectCurrencyScreenTableAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = SectionIdenfier.allCases[indexPath.section]
        let currenciesInSection = self.currencies[section]
        let currency = currenciesInSection?[indexPath.row]
        
        if let currency = currency {
            self.delegate?.onItemSelect(currencyCode: currency.currencyCode)
        }
    }

}

