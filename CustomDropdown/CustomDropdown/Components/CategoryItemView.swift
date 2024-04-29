//
//  CategoryItemView.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 29/04/24.
//

import SwiftUI

struct CategoryItemView: View {
    var category: Category
    
    var body: some View {
        HStack {
            Circle()
                .fill(category.color)
                .scaledToFit()
                .frame(width: 9)
            
            Text(category.title)
                .font(.subheadline.weight(.regular))
                .foregroundColor(Color.black.opacity(0.8))
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
}

#Preview {
    CategoryItemView(category: Category(title: "Design", color: Color.red))
}
