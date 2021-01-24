//
//  ItemCellViewModel.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 20.01.2021.
//

import Foundation

class ItemCellViewModel {
    public var item: Decodable
    
    init(item: Decodable) {
        self.item = item
    }
}
