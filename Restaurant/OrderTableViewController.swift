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

    var orderMinutes = 0
    
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
		MenuController.shared.fetchImage(url: menuItem.imageURL)
		{ (image) in
			guard let image = image else { return }
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
	
	
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue" {
            let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
            orderConfirmationViewController.minutes = orderMinutes
        }
    }
    

	@IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "DismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
		
	}
	
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0)
        { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        let formattedOrder = String(format: "$%.2f", orderTotal)
        
        let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedOrder)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in self.uploadOrder()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        }
    
    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        MenuController.shared.submitOrder(forMenuIds: menuIds)
        { (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            }
            
        }
    }

}



