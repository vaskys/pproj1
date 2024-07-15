//
//  AutoriView.swift
//  Leech
//
//  Created by Samo Vaský on 10/05/2023.
//

import SwiftUI

struct AutoriView: View {
    @EnvironmentObject var lib_vm: LibVM
    var body: some View {
        List {
            ForEach(Array(lib_vm.autori.keys).sorted(), id: \.self) { key in
                NavigationLink {
                    LibAutorVidea(autor_name: key)
                } label: {
                    Text(key)
                }
            }
        }
        .navigationTitle("Autori")
    }
}

struct AutoriView_Previews: PreviewProvider {
    static var previews: some View {
        AutoriView()
    }
}
