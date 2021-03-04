//
//  User.swift
//  DiffableDataSourceSampleProject
//
//  Created by Denys Danyliuk on 04.03.2021.
//

import Foundation

struct User: Hashable {
    
    var name: String
    var age: Int
    let uuid = UUID()
}

// MARK: - generateUsers

extension User {
    
    static func generateUsers(count: Int) -> [User] {
        
        let names: [String] = [
            "Brooks",
            "Rachel",
            "Edwards",
            "Christopher",
            "Perez",
            "Thomas",
            "Baker",
            "Sara",
            "Moore",
            "Chris",
            "Bailey",
            "Roger",
            "Johnson",
            "Marilyn",
            "Thompson",
            "Anthony",
            "Evans",
            "Julie",
            "Hall",
            "Paula",
            "Phillips",
            "Annie",
            "Hernandez",
            "Dorothy",
            "Murphy",
            "Alice",
            "Howard",
            "Harry",
            "Ross",
            "Bruce",
            "Cook",
            "Carolyn",
            "Morgan",
            "Albert",
            "Walker",
            "Randy",
            "Reed",
            "Larry",
            "Barnes",
            "Lois",
            "Wilson",
            "Jesse",
            "Campbell",
            "Ernest",
            "Rogers",
            "Theresa",
            "Patterson",
            "Henry",
            "Simmons",
            "Michelle",
            "Perry",
            "Frank",
            "Butler",
            "Shirley"
        ]
        
        var result: [User] = []
        (0..<count).forEach { _ in
            result.append(User(name: names[Int.random(in: (0..<names.count))],
                               age: Int.random(in: (5...100))))
        }
        
        return result
    }
}
