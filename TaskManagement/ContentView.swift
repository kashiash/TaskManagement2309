//
//  ContentView.swift
//  TaskManagement
//
//  Created by Jacek Kosinski U on 26/09/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.BG)
            .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
