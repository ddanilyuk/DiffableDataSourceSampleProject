//
//  MainViewController.swift
//  DiffableDataSourceSampleProject
//
//  Created by Denys Danyliuk on 04.03.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    enum Section: String {
        case all = "All"
        case under18 = "<18"
        case from18to30 = "18..<30"
        case from30to60 = "30..<60"
        case above60 = ">=60"
    }
    
    enum State {
        case plain
        case grouped
    }
    
    // MARK: - Typealiases
    
    typealias UserDataSource = TableDiffableDataSource<Section, User>
    typealias UserSnapshot = NSDiffableDataSourceSnapshot<Section, User>
    
    // MARK: - IBOutelts
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var groupButton: UIButton!
    
    // MARK: - Private properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var dataSoure: UserDataSource?
    private var users: [User] = []
    private var state: State = .plain
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearch()
        
        users = User.generateUsers(count: 50)
        applySnapshot(with: users)
    }
    
    private func setupSearch() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search users"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        
        tableView.register(UINib(nibName: String(describing: UserTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: UserTableViewCell.self))
        tableView.delegate = self
        configureDataSource()
    }
    
    private func configureDataSource() {
        
        dataSoure = UserDataSource(tableView: tableView) { (tableView: UITableView,
                                                            indexPath: IndexPath,
                                                            user: User) in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserTableViewCell.self)) as! UserTableViewCell
            cell.configure(with: user)
            return cell
        }
        
        dataSoure?.didDeleteItem = { [weak self] item in
            self?.users.removeAll { $0 == item }
        }
        
        dataSoure?.defaultRowAnimation = .fade
    }
    
    private func applySnapshot(with users: [User]) {
        
        var snapshot = UserSnapshot()
        
        snapshot.appendSections([.all])
        snapshot.appendItems(users, toSection: .all)
        
        dataSoure?.apply(snapshot, animatingDifferences: true)
    }
    
    func applyGrroupedSnapshot(users: [User]) {
        
        let usersUnder18 = users.filter { $0.age < 18 }
        let usersFrom18to30 = users.filter { $0.age >= 18 && $0.age < 30 }
        let usersFrom30to60 = users.filter { $0.age >= 30 && $0.age < 60 }
        let usersAbove60 = users.filter { $0.age >= 60 }
        
        var snapshot = UserSnapshot()
        
        snapshot.appendSections([.under18, .from18to30, .from30to60, .above60])
        snapshot.appendItems(usersUnder18, toSection: .under18)
        snapshot.appendItems(usersFrom18to30, toSection: .from18to30)
        snapshot.appendItems(usersFrom30to60, toSection: .from30to60)
        snapshot.appendItems(usersAbove60, toSection: .above60)
        
        dataSoure?.apply(snapshot)
    }
    
    private func applyNeededSnapshot(with users: [User]) {
        
        switch state {
        case .plain:
            applySnapshot(with: users)
        case .grouped:
            applyGrroupedSnapshot(users: users)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func shuffleAction(_ sender: UIButton) {
        
        state = .plain
        users.shuffle()
        applySnapshot(with: users)
    }
    
    @IBAction func sortAction(_ sender: UIButton) {
        
        state = .plain
        users.sort { $0.age < $1.age }
        applySnapshot(with: users)
    }
    
    @IBAction func groupAction(_ sender: UIButton) {
        
        state = .grouped
        applyGrroupedSnapshot(users: users)
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = dataSoure?.itemIdentifier(for: indexPath) else {
            return
        }
        
        print("Selected user: ", item)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionOb = dataSoure?.snapshot().sectionIdentifiers[section]
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.text = sectionOb?.rawValue
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text,
              !searchText.isEmpty else {
            
            applyNeededSnapshot(with: users)
            return
        }
        
        let filteredUsers = users.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        applyNeededSnapshot(with: filteredUsers)
    }
}
