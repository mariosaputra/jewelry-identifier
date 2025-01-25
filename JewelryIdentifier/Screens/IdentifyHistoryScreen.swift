import SwiftUI
import SwiftData

struct IdentifyHistoryScreen: View {
    @Query(sort: \IdentifyHistory.timestamp, order: .reverse) var histories: [IdentifyHistory]
    @State private var currentAlert: AlertType?
    @State private var isDeletionConfirmationPresented: Bool = false
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Group {
                if histories.isEmpty {
                    VStack {
                        Text("No identification history yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(histories) { history in
                        NavigationLink(destination: JewelryInfoView(jewelryInfo: history.jewelryInfo!, inputImage: UIImage(data: history.imageData!)!, isFromHistory: true)) {
                            HStack {
                                if let imageData = history.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                }
                                VStack(alignment: .leading) {
                                    Text(history.jewelryInfo?.name ?? "Unknown Type")
                                        .font(.headline)
                                        .lineLimit(1)
                                        .foregroundColor(.fontTitle)
                                    Text(history.timestamp.formatted(date: .long, time: .shortened))
                                        .font(.subheadline)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    .alert(item: $currentAlert) { alertType in
                        switch alertType {
                        case .resetConfirmation:
                            return Alert(
                                title: Text("Are you sure?"),
                                message: Text("This will permanently delete all identification history. This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    resetAllData()
                                },
                                secondaryButton: .cancel()
                            )
                        case .deletionCompleted:
                            return Alert(
                                title: Text("Data Deleted"),
                                message: Text("All identification history has been successfully deleted."),
                                dismissButton: .default(Text("Got it!"))
                            )
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.navbar, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("History")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.fontTitle)
                }
                
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
            
            if !histories.isEmpty {
                DeleteHistoryButton(title: "Delete History") {
                    currentAlert = .resetConfirmation
                }
            }
        }
    }
    
    func resetAllData() {
        do {
            try context.delete(model: IdentifyHistory.self)
            currentAlert = .deletionCompleted
        } catch {
            // Handle error if needed
        }
    }
}

#Preview {
    IdentifyHistoryScreen()
}
