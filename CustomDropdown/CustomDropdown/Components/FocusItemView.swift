//
//  FocusItemView.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 29/04/24.
//

import SwiftUI

struct FocusItemView: View {
    var focus: Focus
    
    var body: some View {
        HStack {
            Text(focus.title)
                .font(.subheadline.weight(.regular))
                .foregroundColor(Color.black.opacity(0.8))
            
            Spacer()
        }
        .padding(.vertical, 6)
        .padding(.horizontal)
    }
}

#Preview {
    FocusItemView(focus: Focus(title: "Programming"))
}
