import SwiftUI

struct DeleteHistoryButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        
        Button(action: {
            action() // Execute the passed action
        }) {
            HStack(alignment: .center) {
                Spacer()
                
                HStack(spacing: 8) { // HStack for icon and text
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.fontTitle)
                    
                    Text(title)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.fontTitle)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.navbar)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.fontTitle, lineWidth: 2)
                )
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)

    }
}
