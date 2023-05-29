//
//  ContentView.swift
//  SwiftUITabViewCrash
//
//  Created by Johannes Fahrenkrug on 5/29/23.
//

import SwiftUI

struct ContentView: View {
    /// The numbers to display
    @State private var numbers: [Int] = []
    
    var body: some View {
        TabView {
            ForEach(numbers, id: \.self) { number in
                NumberView(number: number)
            }
        }
        .frame(height: 400)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            /// Asynchronously set the numbers
            Task {
                self.numbers = [1, 2, 3, 4]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
