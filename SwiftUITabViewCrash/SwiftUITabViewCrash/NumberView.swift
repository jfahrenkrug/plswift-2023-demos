//
//  NumberView.swift
//  SwiftUITabViewCrash
//
//  Created by Johannes Fahrenkrug on 5/29/23.
//

import SwiftUI

/// View that displays a given number in the center of
/// a rounded rect with a random background color
struct NumberView: View {
    /// The number to display
    let number: Int
    var body: some View {
        let randomColor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
        Text("\(number)")
            .font(.system(size: 70))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(randomColor)
            .cornerRadius(30)
            .padding(20)
    }
}

struct NumberView_Previews: PreviewProvider {
    static var previews: some View {
        NumberView(number: 3)
    }
}
