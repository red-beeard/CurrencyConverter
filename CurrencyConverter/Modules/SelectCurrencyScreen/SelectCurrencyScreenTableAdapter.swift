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
    func update(_ currencies: [SelectCurrencyScreenViewModel])
}


//MARK: SectionIdenfier
enum SectionIdenfier: String, CaseIterable {
    case country = "Country"
    case crypro = "Crypto"
    case metal = "Metal"
}


//MARK: Typealias diffable data source
typealias DiffableDataSource = UITableViewDiffableDataSource<SectionIdenfier, SelectCurrencyScreenViewModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdenfier, SelectCurrencyScreenViewModel>


//MARK: SelectCurrencyScreenTableAdapter
final class SelectCurrencyScreenTableAdapter: NSObject {
    
    private enum Constants {
        static let heightForHeaderInSection = CGFloat(45)
        static let headerFontSize = CGFloat(16)
    }
    
    private var currencies = [SelectCurrencyScreenViewModel]()
    private var dataSource: DiffableDataSource?
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
    
    func update(_ currencies: [SelectCurrencyScreenViewModel]) {
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
        for currency in self.currencies {
            switch currency.countryCode {
            case SectionIdenfier.crypro.rawValue:
                snapshot.appendItems([currency], toSection: .crypro)
            case SectionIdenfier.metal.rawValue:
                snapshot.appendItems([currency], toSection: .metal)
            default:
                snapshot.appendItems([currency], toSection: .country)
            }
        }
        
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

extension SelectCurrencyScreenTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: Constants.headerFontSize)
        headerLabel.textColor = .secondaryLabel
        headerLabel.text = SectionIdenfier.allCases[section].rawValue
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.heightForHeaderInSection
    }
}
