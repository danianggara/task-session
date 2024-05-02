//
//  TodoItemView.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 29/04/24.
//

import SwiftUI

struct TodoItemView: View {
    @Binding var selection: Int
    
    var index: Int
    
    var todo: Todo
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "square")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .font(.headline.weight(.bold))
                .foregroundColor(selection == index ? Color.white : Color.black.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.focus.title)
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(selection == index ? Color.white : Color.black.opacity(0.8))
                
                if todo.category?.title.isEmpty == false {
                    HStack {
                        Circle()
                            .fill((selection == index ? Color.white : todo.category?.color) ?? .green)
                            .scaledToFit()
                            .frame(width: 9)
                        
                        Text(todo.category?.title ?? "")
                            .font(.footnote)
                            .foregroundColor(selection == index ? Color.white : Color.black.opacity(0.6))
                        
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(selection == index ? Color.blue : Color.white)
        .cornerRadius(5)
    }
}

#Preview {
    TodoItemView(selection: .constant(1), index: 1, todo: Todo(focus: Focus(title: "Designing app"), category: Category(title: "Design", color: Color.green)))
}
