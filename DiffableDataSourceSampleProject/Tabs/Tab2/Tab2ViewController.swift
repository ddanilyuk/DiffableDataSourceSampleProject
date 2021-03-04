//
//  Tab2ViewController.swift
//  DiffableDataSourceSampleProject
//
//  Created by Denys Danyliuk on 04.03.2021.
//

import UIKit

final class Tab2ViewController: UIViewController, UITableViewDelegate {
    
    typealias UserDataSource = TableDiffableDataSource<Section, User>
    typealias UserSnapshot = NSDiffableDataSourceSnapshot<Section, User>

    enum Section: String {
        case under18 = "Under 18"
        case from18to30 = "18...30"
        case from30to60 = "30...60"
        case above60 = "More than 60"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    
    private var dataSoure: UserDataSource?
    private var users: [User] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        users = User.generateUsers(count: 50)
        groupUsersByAge()
    }
    
    private func setupTableView() {
        
        tableView.register(UINib(nibName: String(describing: UserTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: UserTableViewCell.self))
        tableView.delegate = self
        configureDataSource()
    }
    
    @IBAction func groupByNamesAction(_ sender: UIButton) {
        
    }
    
    @IBAction func groupByAgeAction(_ sender: UIButton) {
        
        groupUsersByAge()
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
    }
    
    func groupUsersByAge() {
        
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

}
