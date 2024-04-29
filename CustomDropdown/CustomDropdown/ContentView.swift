//
//  ContentView.swift
//  CustomDropdown
//
//  Created by Dani Anggara on 29/04/24.
//

import SwiftUI

struct ContentView: View {
    @FocusState var focusState: Bool
    
    @State private var expandCategory: Bool = false
    @State private var textInput: String = ""
    @State private var searchedFocus: [Focus] = []
    
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
                fieldsView()
                
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
            }
               
            if !searchedFocus.isEmpty {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(searchedFocus, id: \.id) { focus in
                                Button {
                                    
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
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(categories, id: \.id) { category in
                                Button {
                                    
                                } label: {
                                    CategoryItemView(category: category)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .frame(maxHeight: 260)
                .offset(y: 60)
            }
        }
    }
    
    private func pickerCategoryView() -> some View {
        Button {
            withAnimation {
                focusState = false
                expandCategory.toggle()
            }
        } label: {
            HStack {
                Circle()
                    .fill(Color.green)
                    .scaledToFit()
                    .frame(width: 9)
                
                Text("Categories")
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
    
    private func textFieldView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("What's your focus?", text: $textInput)
                    .font(.subheadline)
                    .foregroundColor(Color.black)
                    .autocorrectionDisabled()
                    .focused($focusState)
                    .textFieldStyle(.plain)
                    .onChange(of: textInput) { _ in
                        if textInput.contains("@") {
                            withAnimation {
                                focusState = false
                                expandCategory.toggle()
                            }
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
        .onChange(of: textInput, perform: { value in
            searchFocusItem()
        })
    }
    
    private func searchFocusItem() {
        let searchKey = textInput.lowercased()
        searchedFocus = focusItem.filter({ $0.title.contains(searchKey) })
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
