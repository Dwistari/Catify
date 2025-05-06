//
//  BreedFilterViewController.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import UIKit


protocol BreedFilterDelegate: AnyObject {
    func didSelectBreed(_ breed: Breed)
}

class BreedFilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var breeds: [Breed] = []
    weak var delegate: BreedFilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension BreedFilterViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let breed = breeds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = breed.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBreed = breeds[indexPath.row]
        delegate?.didSelectBreed(selectedBreed)
        dismiss(animated: true)
    }
}
