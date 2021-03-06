//
//  Password+Convenience.swift
//  RememBasket
//
//  Created by Dongwoo Pae on 12/1/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

extension Password {
    convenience init(title: String, username: String, password: String, notes: String?, timestamp: Date = Date(), modifiedDate: Date? = nil, openBasket: Bool = false, imageURLString: String?, logoViewbgColor: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.username = username
        self.password = password
        self.notes = notes
        self.timestamp = timestamp
        self.modifiedDate = modifiedDate
        self.openBasket = openBasket
        self.imageURLString = imageURLString
        self.logoViewbgColor = logoViewbgColor
    }
}
