import SwiftUI

struct ProductOfTheDayView: View {
    var body: some View {
        VStack(spacing: 5) {

            HStack {
                Image(systemName: "laurel.leading")
                    .font(.system(size: 80))
                    .font(.system(size: 80))
                    .foregroundColor(Color(UIColor.darkGray))
                
                VStack {
                    
                    Text("Product of the day")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.darkGray))
                    
                    Text("2nd")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color(UIColor.darkGray))
                }
                
                Image(systemName: "laurel.trailing")
                    .font(.system(size: 80))
                    .foregroundColor(Color(UIColor.darkGray))
            }
        }
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(10)
    }
}


struct ProductOfTheDayView_Previews: PreviewProvider {
    static var previews: some View {
        ProductOfTheDayView()
    }
}
