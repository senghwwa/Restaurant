//
//  MenuController.swift
//  Restaurant
//
//  Created by Seng Hwwa on 18/02/2019.
//  Copyright © 2019 Seng Hwwa. All rights reserved.
//

import Foundation
import UIKit

class MenuController {
	
	static var errorMessage: String = ""
	static let shared = MenuController()
	static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
	var order = Order() {
		didSet {
		NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
		}
	}
	var categories: [String] {
		get {
			return itemsByCategory.keys.sorted()
		}
	}
	
	private var itemsByID = [Int:MenuItem]()
	private var itemsByCategory = [String:[MenuItem]]()
	
	static let menuDataUpdateNotification = Notification.Name("MenuController.menuDataUpdated")

	let baseURL = URL(string: "http://localhost:8090/")!
	
	/*
	func fetchCategories(completion: @escaping ([String]?) -> Void)
	{
		MenuController.errorMessage = ""
		let categoryURL = baseURL.appendingPathComponent("categories")
		let task = URLSession.shared.dataTask(with: categoryURL)
		{ (data, response, error) in
			if let data = data,
			let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
				let categories = jsonDictionary?["categories"] as? [String] {
				completion(categories)
			} else {
				MenuController.errorMessage = error!.localizedDescription
				print("Error in fetchCategories")
				completion(nil)
			}
		}
		task.resume()
	}
	*/
	
	/*
	func fetchMenuItems(forCategory categoryName: String, completion: @escaping ([MenuItem]?) -> Void)
	{
		MenuController.errorMessage = ""
		let initialMenuURL = baseURL.appendingPathComponent("menu")
		var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
		components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
		let menuURL = components.url!
		let task = URLSession.shared.dataTask(with: menuURL)
		{ (data, response, error) in
			let jsonDecoder = JSONDecoder()
			if let data = data,
				let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
				completion(menuItems.items)
			} else {
				MenuController.errorMessage = error!.localizedDescription
				print("Error in fetchMenuItems")
				completion(nil)
			}
		}
		task.resume()
	}
	*/
	
	func submitOrder(forMenuIds menuIds: [Int], completion: @escaping (Int?) -> Void)
	{
		MenuController.errorMessage = ""
		let orderURL = baseURL.appendingPathComponent("orders")
		
		var request = URLRequest(url: orderURL)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		let data: [String: [Int]] = ["menuIds": menuIds]
		let jsonEncoder = JSONEncoder()
		let jsonData = try? jsonEncoder.encode(data)
		
		request.httpBody = jsonData
		let task = URLSession.shared.dataTask(with: request)
		{ (data, response, error) in
			let jsonDecoder = JSONDecoder()
			if let data = data,
				let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
				completion(preparationTime.prepTime)
			} else {
				MenuController.errorMessage = error!.localizedDescription
				print("Error in submitOrder")
				completion(nil)
			}
		}
		task.resume()
	}
	
	func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
		MenuController.errorMessage = ""
		let task = URLSession.shared.dataTask(with: url) {
			(data, reponse, error) in
			if let data = data,
				let image = UIImage(data: data) {
				completion(image)
			} else {
				MenuController.errorMessage = error!.localizedDescription
				print("Error in fetchImage")
				completion(nil)
			}
		}
		task.resume()
	}
	
	// My innovation to generically disoplay alert from UIView and UITableView Controllers.
	// Relies on the fact that UITableViewController inherits from UIVieController
	// Example of call is below and is called within a UIView/UITableView Controller class
	// MenuController.shared.showError(controller: self, errorTitle: "Error title")

	func showError(controller: UIViewController, errorTitle: String) {
		if !MenuController.errorMessage.isEmpty {
			let alert = UIAlertController(title: errorTitle, message: MenuController.errorMessage, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
			controller.present(alert, animated: true, completion: nil)
		}
		print("Shared error message is \(MenuController.errorMessage)")
	}
	
	func loadOrder() {
		let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let orderFileURL = documentsDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
		
		guard let data = try? Data(contentsOf: orderFileURL)
			else {
				return
		}
		order = (try? JSONDecoder().decode(Order.self, from: data)) ?? Order(menuItems: [])
	}
	
	func saveOrder() {
		let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let orderFileURL = documentsDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
		
		if let data = try? JSONEncoder().encode(order) {
			try? data.write(to: orderFileURL)
		}
	}

	func item(withID itemID: Int) -> MenuItem? {
		return itemsByID[itemID]
	}
	
	func items(forCategory category: String) -> [MenuItem]? {
		return itemsByCategory[category]
	}
	
	private func process(_ items: [MenuItem]) {
		itemsByID.removeAll()
		itemsByCategory.removeAll()
		
		for item in items {
			itemsByID[item.id] = item
			itemsByCategory[item.category, default: []].append(item)
		}
		
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: MenuController.menuDataUpdateNotification, object: nil)
		}
	}
	
	func loadRemoteData() {
		let initialMenuURL = baseURL.appendingPathComponent("menu")
		let components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
		let menuURL = components.url!
		
		let task = URLSession.shared.dataTask(with: menuURL) {
			(data, _, _) in
			let jsonDecoder = JSONDecoder()
			if let data = data,
				let menuItems = try?
					jsonDecoder.decode(MenuItems.self, from: data)
			{
				self.process(menuItems.items)
			}
		}
		task.resume()
	}
	
	func loadItems() {
		let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let menuItemsFileURL = documentDirectoryURL.appendingPathComponent("menuItems").appendingPathExtension("json")
		
		guard let data = try? Data(contentsOf: menuItemsFileURL)
			else {
				return
		}
		let items = (try? JSONDecoder().decode([MenuItem].self, from: data)) ?? []
		process(items)
		}

	func saveItems() {
		let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let menuItemsFileURL = documentDirectoryURL.appendingPathComponent("menuItems").appendingPathExtension("json")
		
		let items = Array(itemsByID.values)
		if let data = try? JSONEncoder().encode(items) {
			try? data.write(to: menuItemsFileURL)
		}
	}
	
}
