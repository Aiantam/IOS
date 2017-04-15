//
//  StringExtension.swift
//  QuickNote
//
//  Created by dev7 on 1/12/17.
//  Copyright © 2017 dev7. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
