//
//  CategoryItemView.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 29/04/24.
//

import SwiftUI

struct CategoryItemView: View {
    @Binding var selection: Int
    
    var index: Int
    var category: Category
    
    var body: some View {
        HStack {
            Circle()
                .fill(selection == index ? Color.white : category.color)
                .scaledToFit()
                .frame(width: 9)
            
            Text(category.title)
                .font(.subheadline.weight(.regular))
                .foregroundColor(selection == index ? Color.white : Color.black.opacity(0.8))
            
            Spacer()
        }
        .padding()
        .background(selection == index ? Color.blue : Color.white)
    }
}

#Preview {
    CategoryItemView(selection: .constant(1), index: 1, category: Category(title: "Design", color: Color.red))
}
