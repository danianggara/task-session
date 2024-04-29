//
//  ContentView.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 29/04/24.
//

import Foundation
import SwiftUI
import AppKit

struct ContentView: View {
  @FocusState var focusState: Bool

  @State private var expandCategory: Bool = false
  @State private var textInput: String = ""
  @State private var searchedFocus: [Focus] = []
  @State private var selectedCategory: Category = Category(title: "", color: Color.black)
  @State private var selectedFocus: Focus = Focus(title: "")
  @State private var todoList: [Todo] = []
  @State private var selection: Int = 0
  @State private var keyMonitor: Any?

  let categories = [
    Category(title: "Design", color: .red),
    Category(title: "Programming", color: .orange),
    Category(title: "Marketing", color: .green),
    Category(title: "Finance", color: .blue),
    Category(title: "Support", color: .yellow),
    Category(title: "Sleep", color: .purple)
  ]

  let focusItem = [
    Focus(title: "Analyze"),
    Focus(title: "Bake"),
    Focus(title: "Designer"),
    Focus(title: "Developer"),
    Focus(title: "Debussy"),
    Focus(title: "Declarative"),
    Focus(title: "Design"),
    Focus(title: "Decorondum"),
    Focus(title: "Cheer")
  ]

  let dummyTodo = [
    Todo(focus: Focus(title: "Designing UI"), category: Category(title: "Design", color: Color.green)),
    Todo(focus: Focus(title: "Testing UI"), category: Category(title: "Testing", color: Color.red)),
    Todo(focus: Focus(title: "Programming UI"), category: Category(title: "Programming", color: Color.blue))
  ]

  var body: some View {
    VStack {
      VStack {
        ScrollView(showsIndicators: false) {
          fieldsView()
        }
      }
      .padding()
      .frame(maxHeight: .infinity, alignment: .top)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.3))
    .navigationBarBackButtonHidden()
  }

  private func fieldsView() -> some View {
    ZStack(alignment: .top) {
      VStack {
        pickerCategoryView()

        textFieldView()

        VStack {
          ForEach(todoList, id: \.id) { todo in
            TodoItemView(todo: todo)
          }
        }
        .padding(.top)
      }

      if focusState && !searchedFocus.isEmpty {
        ZStack {
          RoundedRectangle(cornerRadius: 5)
            .fill(Color.white)

          ScrollView(showsIndicators: false) {
            VStack {
              ForEach(searchedFocus, id: \.id) { focus in
                Button {
                  selectedFocus = focus
                  focusState = false
                  textInput.removeAll()
                  searchedFocus.removeAll()
                  appendTodoList()
                } label: {
                  FocusItemView(focus: focus)
                }
                .buttonStyle(.plain)
              }
            }
            .padding(.vertical)
          }
        }
        .frame(maxHeight: 260)
        .offset(y: 120)
      }

      if expandCategory {
        expandCategoriesView()
      }
    }
  }

  private func pickerCategoryView() -> some View {
    Button {
      withAnimation {
        focusState = false
        searchedFocus.removeAll()
        expandCategory.toggle()
      }
    } label: {
      HStack {
        Circle()
          .fill(selectedCategory.title.isEmpty ? Color.green : selectedCategory.color)
          .scaledToFit()
          .frame(width: 9)

        Text(selectedCategory.title.isEmpty ? "Categories" : selectedCategory.title)
          .font(.subheadline.weight(.regular))
          .foregroundColor(Color.black.opacity(0.8))

        Spacer()

        Image(systemName: expandCategory ? "chevron.up" : "chevron.down")
          .font(.subheadline.weight(.semibold))
          .foregroundColor(Color.gray)
          .rotationEffect(.degrees(180))
      }
      .padding()
      .background(Color.white)
      .cornerRadius(5)
    }
    .buttonStyle(.plain)
  }

  private func expandCategoriesView() -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .fill(Color.white)

      ScrollView(showsIndicators: false) {
        VStack(spacing: 0) {
          ForEach(categories.indices, id: \.self) { index in
            Button {
              selectedCategory = categories[index]
              expandCategory = false
              appendTodoList()
            } label: {
              CategoryItemView(selection: $selection, index: index, category: categories[index])
                .tag(index)
            }
            .buttonStyle(.plain)
          }
        }
        .padding(.vertical)
      }
      .onAppear {
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { nsevent in
          if nsevent.keyCode == 125 {
            selection = selection < categories.count ? selection + 1 : 0
          } else {
            if nsevent.keyCode == 126 {
              selection = selection > 1 ? selection - 1 : 0
            }
          }
          return nsevent
        }
      }
      .onDisappear {
        if keyMonitor != nil {
          NSEvent.removeMonitor(keyMonitor!)
          keyMonitor = nil
        }
      }
    }
    .frame(maxHeight: 260)
    .offset(y: 60)
  }

  private func textFieldView() -> some View {
    VStack(alignment: .leading) {
      HStack {
        TextField("What's your focus?", text: $textInput)
          .font(.subheadline)
          .foregroundColor(Color.black)
          .autocorrectionDisabled()
          .focused($focusState)
          .textFieldStyle(.plain)
          .onChange(of: focusState, perform: { value in
            if focusState {
              searchedFocus = searchFocusItem()
            }
          })
          .onChange(of: textInput, perform: { value in
            searchedFocus = searchFocusItem()

            if textInput.contains("@") {
              withAnimation {
                focusState = false
                expandCategory.toggle()
              }
            }
          })

        if textInput.isEmpty == false {
          Button {
            textInput = ""
          } label: {
            Image(systemName: "xmark")
              .foregroundColor(.black)
          }
          .buttonStyle(.plain)
        }
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(5)
    .overlay {
      if focusState {
        RoundedRectangle(cornerRadius: 5)
          .strokeBorder(Color.blue, lineWidth: 2.5)
      }
    }
  }

  private func appendTodoList() {
    if !selectedCategory.title.isEmpty && !selectedFocus.title.isEmpty {
      let todo = Todo(focus: selectedFocus, category: selectedCategory)
      todoList.append(todo)
    } else if selectedCategory.title.isEmpty && !selectedFocus.title.isEmpty {
      expandCategory.toggle()
    } else if !selectedCategory.title.isEmpty && selectedFocus.title.isEmpty {
      searchedFocus = searchFocusItem()
      focusState = true
    }
  }

  private func searchFocusItem() -> [Focus] {
    if textInput.isEmpty {
      return focusItem
    } else {
      return focusItem.filter { focus in
        focus.title.lowercased().contains(textInput.lowercased())
      }
    }
  }
}

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
  var category: Category
}

#Preview {
  ContentView()
}
