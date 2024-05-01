//
//  TodoItemView.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 29/04/24.
//

import SwiftUI

struct TodoItemView: View {
  var todo: Todo

  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "square")
        .resizable()
        .scaledToFit()
        .frame(width: 20)
        .font(.headline.weight(.bold))
        .foregroundColor(Color.black.opacity(0.3))

      VStack(alignment: .leading, spacing: 4) {
        Text(todo.focus.title)
          .font(.subheadline.weight(.regular))
          .foregroundColor(Color.black.opacity(0.8))

        HStack {
          Circle()
            .fill(todo.category?.color ?? .green)
            .scaledToFit()
            .frame(width: 9)

          Text(todo.category?.title ?? "")
            .font(.footnote)
            .foregroundColor(Color.black.opacity(0.6))

          Spacer()
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding()
    .background(Color.white)
    .cornerRadius(5)
  }
}

#Preview {
  TodoItemView(todo: Todo(focus: Focus(title: "Designing app"), category: Category(title: "Design", color: Color.green)))
}
