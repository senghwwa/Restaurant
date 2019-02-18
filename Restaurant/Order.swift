//
//  Order.swift
//  Restaurant
//
//  Created by Seng Hwwa on 18/02/2019.
//  Copyright © 2019 Seng Hwwa. All rights reserved.
//

import Foundation

struct Order: Codable {
	var menuItems: [MenuItem]
	
	init(menuItems: [MenuItem] = []) {
		self.menuItems = menuItems
	}
	
}
