//
//  SearchBar.swift
//  Leech
//
//  Created by Samo Vaský on 09/05/2023.
//


// HNUSNE


import SwiftUI

struct SearchBar: View {
    @Binding var search_string: String
    @EnvironmentObject var inv_api: IApi
    
    @State var edit = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("Hľadaj", text: $search_string)
                    .onChange(of: search_string) { c in
                        inv_api.get_search_sugg(text: search_string)
                    }
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        edit = true
                    }
                    .overlay() {
                            ZStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 12)
                                if edit {
                                    if let sug = inv_api.search_suggestion {
                                        if sug.suggestions.count > 2 {
                                            VStack(alignment: .leading) {
                                                ForEach(1..<5) { i in
                                                    if i < sug.suggestions.count - 1 {
                                                        Button{
                                                            search_string = sug.suggestions[i]
                                                            inv_api.reset_search()
                                                            inv_api.search(name: sug.suggestions[i])
                                                            edit = false
                                                        } label: {
                                                            HStack {
                                                                Text(sug.suggestions[i])
                                                                    .foregroundColor(.primary)
                                                                    .multilineTextAlignment(.leading)
                                                                    .padding(.leading,30)
                                                                Spacer()
                                                            }
                                                        }
                                                    }
                                                    else {
                                                        Text("")
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: .infinity)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                            .padding(.horizontal,10)
                                            .offset(y:CGFloat(60))
                                        }
                                    }
                                }
                                
                            }
                    }
                    .onSubmit {
                        print("SUBMIT")
                        edit = false
                        inv_api.reset_search()
                        inv_api.search(name: search_string)
                    }
            }
        }
        .zIndex(1000)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(search_string: .constant(""))
    }
}
