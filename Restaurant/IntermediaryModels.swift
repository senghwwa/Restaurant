//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Seng Hwwa on 18/02/2019.
//  Copyright © 2019 Seng Hwwa. All rights reserved.
//

import Foundation

struct PreparationTime: Codable {
	let prepTime: Int
	
	enum CodingKeys: String, CodingKey {
		case prepTime = "preparation_time"
	}
}

