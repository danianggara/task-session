//
//  FocusItemView.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 29/04/24.
//

import SwiftUI

struct FocusItemView: View {
    @Binding var selection: Int
    
    var index: Int
    var focus: Focus
    
    var body: some View {
        HStack {
            Text(focus.title)
                .font(.subheadline.weight(.regular))
                .foregroundColor(selection == index ? Color.white : Color.black.opacity(0.8))
            
            Spacer()
        }
        .padding()
        .background(selection == index ? Color.blue : Color.white)
        .cornerRadius(5)
    }
}

#Preview {
    FocusItemView(selection: .constant(1), index: 1, focus: Focus(title: "Programming"))
}
