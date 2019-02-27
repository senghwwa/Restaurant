//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Seng Hwwa on 18/02/2019.
//  Copyright © 2019 Seng Hwwa. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
		
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!

    var menuItem: MenuItem?

    override func viewDidLoad() {
        super.viewDidLoad()

		addToOrderButton.layer.cornerRadius = 5.0
        updateUI()
        
    }
	
	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		guard let menuItem = menuItem else { return }
		coder.encode(menuItem.id, forKey: "menuItemId")
	}
	
	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)

		let menuItemID = Int(coder.decodeInt32(forKey: "menuItemId"))
		if MenuController.shared.item(withID: menuItemID) != nil {
			menuItem = MenuController.shared.item(withID: menuItemID)!
			updateUI()
		}
	}
    
	func updateUI() {
		guard let menuItem = menuItem else { return }
		titleLabel.text = menuItem.name
		priceLabel.text = String(format: "$%.2f", menuItem.price)
		detailTextLabel.text = menuItem.detailText
		MenuController.shared.fetchImage(url: menuItem.imageURL)
		{ (image) in
			guard let image = image
				else { MenuController.shared.showError(controller: self, errorTitle: "Error retrieving image")

					return }
			DispatchQueue.main.async {
				self.imageView.image = image
			}
			
		}
	}

	// MARK: - Navigation
	
    @IBAction func orderButtonTapped(_ sender: UIButton) {
		guard let menuItem = menuItem else { return }
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        }
		MenuController.shared.order.menuItems.append(menuItem)
    }
	    
}
