//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Seng Hwwa on 18/02/2019.
//  Copyright © 2019 Seng Hwwa. All rights reserved.
//

import UIKit

//var order = Order()

class OrderTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = editButtonItem
		NotificationCenter.default.addObserver(tableView, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
		configure(cell, forItemAt: indexPath)

        return cell
    }

	func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
		let menuItem = MenuController.shared.order.menuItems[indexPath.row]
		cell.textLabel?.text = menuItem.name
		cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
	}
	
	
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
	

	
    // Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			MenuController.shared.order.menuItems.remove(at: indexPath.row)
			// Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
			
        }
    }
	

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
