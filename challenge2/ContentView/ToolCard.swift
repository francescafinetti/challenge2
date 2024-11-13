import SwiftUI

struct ToolCard: View {
    var iconName: String
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) { // Center align VStack
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
                .multilineTextAlignment(.center) // Center text in multiple lines
                .frame(maxWidth: .infinity, alignment: .center) // Center align subtitle
        }
        .frame(width: 135, height: 240)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

