//
//  ContentView.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 29/04/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @FocusState var focusState: Bool
    @FocusState var focusCategories: Bool
    @FocusState var focusTodoList: Bool
    
    @State private var expandCategory: Bool = false
    @State private var textInput: String = ""
    @State private var searchedFocus: [Focus] = []
    @State private var selectedCategory: Category = Category(title: "", color: Color.black)
    @State private var selectedFocus: Focus = Focus(title: "")
    @State private var todoList: [Todo] = []
    
    @State private var selectionCategory: Int = 0
    @State private var selectionFocus: Int = 0
    @State private var selectionTodoList: Int? = nil
    
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
        .background(Color.baseGray)
        .navigationBarBackButtonHidden()
    }
    
    private func fieldsView() -> some View {
        ZStack(alignment: .top) {
            VStack {
                pickerCategoryView()
                
                textFieldView()
                
                todoListsView()
            }
            
            if focusState && !searchedFocus.isEmpty {
                expandFocusView()
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
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        ForEach(categories.indices, id: \.self) { index in
                            CategoryItemView(selection: $selectionCategory, index: index, category: categories[index])
                                .onTapGesture {
                                    selectCategory(index)
                                }
                                .id(index)
                                .focusable()
                                .focusEffectDisabled()
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                focusCategories = true
                            }
                        }
                        .focused($focusCategories)
                        .onKeyPress(.upArrow) {
                            selectionCategory = selectionCategory > 1 ? selectionCategory - 1 : 0
                            return .handled
                        }
                        .onKeyPress(.downArrow) {
                            selectionCategory = selectionCategory < categories.count-1 ? selectionCategory + 1 : 0
                            return .handled
                        }
                        .onKeyPress(.return) {
                            selectCategory(selectionCategory)
                            return .handled
                        }
                        .onKeyPress(.escape) {
                            expandCategory = false
                            return .handled
                        }
                    }
                    .padding()
                    .onChange(of: selectionCategory) { id in
                        withAnimation {
                            proxy.scrollTo(id)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 260)
        .offset(y: 60)
    }
    
    private func expandFocusView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
            
            ScrollView(showsIndicators: false) {
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        ForEach(searchedFocus.indices, id: \.self) { index in
                            FocusItemView(selection: $selectionFocus, index: index, focus: searchedFocus[index])
                                .onTapGesture {
                                    selectFocus(index)
                                }
                                .id(index)
                                .focusable()
                                .focusEffectDisabled()
                        }
                        .focused($focusState)
                        .onKeyPress(.upArrow) {
                            selectionFocus = selectionFocus > 1 ? selectionFocus - 1 : 0
                            return .handled
                        }
                        .onKeyPress(.downArrow) {
                            selectionFocus = selectionFocus < searchedFocus.count-1 ? selectionFocus + 1 : 0
                            return .handled
                        }
                        .onKeyPress(.return) {
                            selectFocus(selectionFocus)
                            return .handled
                        }
                        .onKeyPress(.escape) {
                            focusState = false
                            return .handled
                        }
                    }
                    .padding()
                    .onChange(of: selectionFocus) { id in
                        withAnimation {
                            proxy.scrollTo(id)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 260)
        .offset(y: 120)
    }
    
    private func textFieldView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("", text: $textInput)
                    .placeholder(when: textInput.isEmpty) {
                        Text("What's your focus?")
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)
                    .foregroundColor(Color.black)
                    .autocorrectionDisabled()
                    .focused($focusState)
                    .textFieldStyle(.plain)
                    .onChange(of: textInput, initial: false) {
                        doSearchFocus()
                        
                        if textInput.contains("@") {
                            withAnimation {
                                focusState = false
                                expandCategory.toggle()
                            }
                        }
                    }
                    .onChange(of: focusState, initial: false) {
                        if focusState {
                            doSearchFocus()
                        }
                    }
                
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
            .onKeyPress(.upArrow) {
                selectionFocus = selectionFocus > 1 ? selectionFocus - 1 : 0
                return .handled
            }
            .onKeyPress(.downArrow) {
                selectionFocus = selectionFocus < searchedFocus.count-1 ? selectionFocus + 1 : 0
                return .handled
            }
            .onKeyPress(.return) {
                if searchedFocus.isEmpty {
                    selectedFocus = Focus(title: textInput)
                    appendTodoList()
                } else {
                    selectFocus(selectionFocus)
                }
                return .handled
            }
            .onKeyPress(.escape) {
                focusState = false
                return .handled
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
    
    private func todoListsView() -> some View {
        VStack {
            ForEach(todoList.indices, id: \.self) { index in
                TodoItemView(selection: $selectionTodoList, index: index, todo: todoList[index])
                    .id(index)
                    .focusable()
                    .focusEffectDisabled()
                    .onTapGesture {
                        selectionTodoList = index
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focusTodoList = true
                }
            }
            .focused($focusTodoList)
            .onKeyPress(.upArrow) {
                selectionTodoList = selectionTodoList ?? 0 > 1 ? (selectionTodoList ?? 0) - 1 : 0
                return .handled
            }
            .onKeyPress(.downArrow) {
                selectionTodoList = selectionTodoList ?? 0 < todoList.count-1 ? (selectionTodoList ?? 0) + 1 : 0
                return .handled
            }
            .onKeyPress(.return) {
                return .handled
            }
            .onKeyPress(.escape) {
                focusTodoList = false
                return .handled
            }
        }
        .padding(.top)
    }
    
    private func appendTodoList() {
        if !selectedFocus.title.isEmpty {
            let todo = Todo(focus: selectedFocus, category: selectedCategory)
            todoList.append(todo)
            
            // reset
            selectedCategory = Category(title: "", color: Color.clear)
            selectedFocus = Focus(title: "")
            focusCategories = false
            focusState = false
            selectionCategory = 0
            selectionFocus = 0
            textInput.removeAll()
        } else if !selectedCategory.title.isEmpty && selectedFocus.title.isEmpty {
            focusState = true
        }
    }
    
    private func doSearchFocus() {
        if textInput.isEmpty {
            searchedFocus = focusItem
        } else {
            searchedFocus = searchFocus(for: textInput)
        }
    }
    
    private func searchFocus(for keyword: String) -> [Focus] {
        return focusItem.filter { focus in
            let lowercaseName = focus.title.lowercased()
            return lowercaseName.contains(keyword)
        }
    }
    
    private func selectCategory(_ index: Int) {
        if index <= categories.count-1 {
            selectedCategory = categories[index]
            expandCategory = false
            appendTodoList()
            
            if textInput.last == "@" {
                textInput.removeLast()
            }
        }
    }
    
    private func selectFocus(_ index: Int) {
        if index <= searchedFocus.count-1 {
            selectedFocus = searchedFocus[index]
            //focusState = false
            textInput.removeAll()
            searchedFocus.removeAll()
            appendTodoList()
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension Color {
    static let baseGray = Color.init(hex: "#BCBCBC")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


#Preview {
    ContentView()
}
