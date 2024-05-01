//
//  Models.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 30/04/24.
//

import Foundation
import SwiftUI

struct Category: Identifiable {
    var id = UUID().uuidString
    var title: String
    var color: Color
}

struct Focus: Identifiable {
    var id = UUID().uuidString
    var title: String
}

struct Todo: Identifiable {
    var id = UUID().uuidString
    var focus: Focus
    var category: Category?
}
