import SwiftUI

struct AppIconView: View {
    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Logo
            LogoView(size: 250)
                .padding(20)
        }
        .frame(width: 1024, height: 1024)
        .cornerRadius(180)
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView()
            .previewLayout(.sizeThatFits)
            .frame(width: 300, height: 300)
    }
} 