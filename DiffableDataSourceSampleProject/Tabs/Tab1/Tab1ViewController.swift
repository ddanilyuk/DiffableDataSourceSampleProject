//
//  Tab1ViewController.swift
//  DiffableDataSourceSampleProject
//
//  Created by Denys Danyliuk on 04.03.2021.
//

import UIKit

final class Tab1ViewController: UIViewController, UITableViewDelegate {
    
    enum Section: String {
        case all = "Main"
        case under18 = "Under 18"
        case from18to30 = "18...30"
        case from30to60 = "30...60"
        case above60 = "More than 60"
    }

    // MARK: - Typealiases
    
    typealias UserDataSource = TableDiffableDataSource<Section, User>
    typealias UserSnapshot = NSDiffableDataSourceSnapshot<Section, User>
    
    // MARK: - IBOutelts
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var groupButton: UIButton!
    
    // MARK: - Private properties

    private var dataSoure: UserDataSource?
    private var users: [User] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        users = User.generateUsers(count: 50)
        applySnapshot(with: users)
    }
    
    private func setupSearch() {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = dataSoure?.itemIdentifier(for: indexPath) else {
            return
        }
        
        print("Selected user: ", item)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionOb = dataSoure?.snapshot().sectionIdentifiers[section]
        print("Section: \(sectionOb?.rawValue) \(section)")
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.text = sectionOb?.rawValue
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func groupUsers() {
        
        let usersLessThan18 = users.filter { $0.age < 18 }
        let users18to30 = users.filter { $0.age >= 18 && $0.age < 30 }
        let users30to60 = users.filter { $0.age >= 30 && $0.age < 60 }
        let usersMoreThan60 = users.filter { $0.age >= 60 }

        var snapshot = UserSnapshot()
        
        snapshot.appendSections([.under18, .from18to30, .from30to60, .above60])
        snapshot.appendItems(usersLessThan18, toSection: .under18)
        snapshot.appendItems(users18to30, toSection: .from18to30)
        snapshot.appendItems(users30to60, toSection: .from30to60)
        snapshot.appendItems(usersMoreThan60, toSection: .above60)

        dataSoure?.apply(snapshot)
    }
    
    @IBAction func shuffleAction(_ sender: UIButton) {
        
        users.shuffle()
        applySnapshot(with: users)
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        
        users.sort { $0.age < $1.age }
        applySnapshot(with: users)
    }
    
    @IBAction func groupAction(_ sender: UIButton) {
        groupUsers()
    }
}
