//
//  ContentView.swift
//  challenge2
//
//  Created by Francesca Finetti on 04/11/24.
//

import SwiftUI

struct ToolCard: View {
    var iconName: String
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: iconName)
                .font(.system(size: 100))
                .foregroundColor(Color.blue)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading) 
        }
        .frame(width: 135, height: 260)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

