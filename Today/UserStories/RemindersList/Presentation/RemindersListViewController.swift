//
//  RemindersListViewController.swift
//  Today
//
//  Created by Иван Гребенюк on 24.03.2024.
//

import UIKit
import SnapKit

class RemindersListViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSource: DataSource?
    
    // MARK: - UI
    
    private lazy var collection: UICollectionView = {
        let listLayout = listLayout()
            
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: listLayout
        )
        
        let cellRegistration = UICollectionView.CellRegistration {(cell: UICollectionViewListCell, indexPath: IndexPath, _: String) in
            let reminder = Reminder.sampleData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
        }
        
        // Register cell
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        
        return collectionView
    }()
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpUI()
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        view.addSubview(collection)
        setUpConstraints()
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .systemBackground
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func setUpCollectionView() {
        
        // Cell registration
        let cellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath: IndexPath, _: String) in
            let reminder = Reminder.sampleData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
        }
        
        // Initialize dataSource
        dataSource = DataSource(collectionView: collection) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        // Apply Snapshot
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map { $0.title })
        guard let dataSource else { return }
        dataSource.apply(snapshot)
        
        // Set dataSource for the collection view
        collection.dataSource = dataSource
    }
}

// MARK: - Autolyaout Constraints

private extension RemindersListViewController {
    
    func setUpConstraints() {
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
