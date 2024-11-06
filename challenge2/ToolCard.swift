import SwiftUI

struct ToolCard: View {
    var iconName: String
    var title: String
    var subtitle: String
    var action: () -> Void // Add action as a parameter
    
    var body: some View {
        Button(action: action) { // Wrap VStack in a Button
            VStack(alignment: .center, spacing: 5) {
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
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: 135, height: 260)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling
    }
}
