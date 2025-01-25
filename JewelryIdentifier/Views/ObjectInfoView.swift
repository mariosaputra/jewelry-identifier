import SwiftUI

struct JewelryInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    let jewelryInfo: JewelryInfo
    let inputImage: UIImage?
    let isFromHistory: Bool
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 24) {
                        infoBanner
                        jewelryImage(width: geometry.size.width)
                        typeView
                        rarityView
                        detailsCard
                        if let notes = jewelryInfo.notes, !notes.isEmpty {
                            notesCard
                        }
                    }
                    .padding(.vertical, 24)
                }
                .background(Color(.systemBackground))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.navbar, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Jewelry Details")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.fontTitle)
                }
                
                if isFromHistory {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.fontTitle)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var infoBanner: some View {
        Text("ℹ️ Information is for reference only. Always verify jewelry details with a professional.")
            .font(.footnote)
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Color.navbar
                    .cornerRadius(10)
            )
            .padding(.horizontal)
    }
    
    private func jewelryImage(width: CGFloat) -> some View {
        Group {
            if let inputImage = inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .frame(width: max(width - 32, 0)) // Ensure width is never negative
                    .cornerRadius(20)
                    .clipped()
                    .shadow(radius: 10)
            }
        }
    }
    
    private var typeView: some View {
        Text(jewelryInfo.name ?? "Unknown Type")
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [.fontTitle, .fontTitle.opacity(0.6), .fontTitle],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }
    
    private var rarityView: some View {
        HStack {
            Image(systemName: getRarityIcon())
                .foregroundColor(getRarityColor())
            Text("Rarity: \(jewelryInfo.rarity ?? "Unknown")")
                .font(.headline)
                .foregroundColor(.fontTitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
    
    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            infoRow(title: "Type", value: jewelryInfo.type ?? "Unknown", icon: "suit.diamond.fill")
            
            Divider()
                .background(.white.opacity(0.5))
            
            infoRow(title: "Material", value: jewelryInfo.material ?? "Unknown", icon: "circle.hexagongrid.fill")
            
            Divider()
                .background(.white.opacity(0.5))
            
            infoRow(title: "Gemstone", value: jewelryInfo.gemstone ?? "Unknown", icon: "diamond.fill")
            Divider()
                .background(.white.opacity(0.5))
            infoRow(title: "Carat Weight", value: jewelryInfo.gemstoneCarat ?? "Unknown", icon: "scalemass.fill")
            Divider()
                .background(.white.opacity(0.5))
            infoRow(title: "Jewelry Weight", value: jewelryInfo.jewelryWeight ?? "Unknown", icon: "scalemass")
            Divider()
                .background(.white.opacity(0.5))
            infoRow(title: "Origin", value: jewelryInfo.origin ?? "Unknown", icon: "flag.fill")
            Divider()
                .background(.white.opacity(0.5))
            infoRow(title: "Era", value: jewelryInfo.era ?? "Unknown", icon: "clock.fill")
            Divider()
                .background(.white.opacity(0.5))
            infoRow(title: "Estimated Value", value: jewelryInfo.estimatedValue ?? "Unknown", icon: "dollarsign.circle.fill")
            Divider()
                .background(.white.opacity(0.5))
            if let description = jewelryInfo.designDescription, !description.isEmpty {
                infoRow(title: "Design Description", value: description, icon: "paintbrush.fill")
                Divider()
                .background(.white.opacity(0.5))
            }
            infoRow(title: "Historical Significance", value: jewelryInfo.historicalSignificance ?? "Unknown", icon: "book.fill")
            if let confidence = jewelryInfo.confidence {
                Divider()
                .background(.white.opacity(0.5))
                infoRow(title: "AI Confidence", value: "\(confidence)%", icon: "checkmark.seal.fill")
            }
        }
        .padding()
        .background(Color("Color1").opacity(0.8))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Additional Notes")
                .font(.headline)
                .foregroundColor(.navbar)
            Text(jewelryInfo.notes ?? "")
                .font(.body)
                .foregroundStyle(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("Color1").opacity(0.8))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private func infoRow(title: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.navbar)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.navbar)
                Text(value)
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
    }
    
    private func getRarityIcon() -> String {
        switch jewelryInfo.rarity?.lowercased() {
        case "common": return "circle.fill"
        case "uncommon": return "diamond.fill"
        case "rare": return "star.fill"
        default: return "questionmark.circle.fill"
        }
    }
    
    private func getRarityColor() -> Color {
        switch jewelryInfo.rarity?.lowercased() {
        case "common": return .green
        case "uncommon": return .blue
        case "rare": return .red
        default: return .gray
        }
    }
}
