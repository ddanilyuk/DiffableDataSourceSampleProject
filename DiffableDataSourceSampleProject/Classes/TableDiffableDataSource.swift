//
//  TableDiffableDataSource.swift
//  DiffableDataSourceSampleProject
//
//  Created by Denys Danyliuk on 04.03.2021.
//

import UIKit

final class TableDiffableDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
    
    // MARK: - Closure properties
    
    var didDeleteItem: ((ItemIdentifierType) -> Void)?
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete,
           let model = itemIdentifier(for: indexPath) {
            
            var snapshot = self.snapshot()
            snapshot.deleteItems([model])
            apply(snapshot)
            didDeleteItem?(model)
        }
    }
}
