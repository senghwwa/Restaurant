//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Seng Hwwa on 18/02/2019.
//  Copyright © 2019 Seng Hwwa. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

	//let menuController = MenuController()
	var menuItems = [MenuItem]()
	var category: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = category.capitalized
		MenuController.shared.fetchMenuItems(forCategory: category, completion:
		//menuController.fetchMenuItems(forCategory: category, completion:
			{(menuItems) in
				if let menuItems = menuItems {
					self.updateUI(with: menuItems)
				} else {
					MenuController.shared.showError(controller: self, errorTitle: "Error retrieving menu items")

				}
			}
		)
    }

	func updateUI(with menuItems: [MenuItem]) {
		DispatchQueue.main.async {
			self.menuItems = menuItems
			self.tableView.reloadData()
		}
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

		return 1
		
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return menuItems.count
		
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)

		configure(cell, forItemAt: indexPath)
		
        return cell
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}


	func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
		let menuItem = menuItems[indexPath.row]
		cell.textLabel?.text = menuItem.name
		cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
		MenuController.shared.fetchImage(url: menuItem.imageURL)
		{ (image) in
			guard let image = image
				else {
					MenuController.shared.showError(controller: self, errorTitle: "Error retrieving image")
					return
			}
			DispatchQueue.main.async {
				if let currentIndexPath = self.tableView.indexPath(for: cell),
					currentIndexPath != indexPath {
					return
				}
				cell.imageView?.image = image
				cell.setNeedsLayout()
			}
		}
	}

	
    // MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	
			if segue.identifier == "MenuDetailSegue" {
				let menuItemDetailViewController = segue.destination as! MenuItemDetailViewController
				let index = tableView.indexPathForSelectedRow!.row
				menuItemDetailViewController.menuItem = menuItems[index]
			}
    }
	
}
