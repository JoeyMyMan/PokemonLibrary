import SwiftUI

struct AppIconPreview: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("宝可梦图鉴应用图标")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // 大尺寸图标预览
            AppIconView()
                .frame(width: 200, height: 200)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // 不同尺寸的图标
            HStack(spacing: 20) {
                AppIconView()
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                
                AppIconView()
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                
                AppIconView()
                    .frame(width: 100, height: 100)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
            
            // 导出说明
            VStack(alignment: .leading, spacing: 10) {
                Text("导出图标说明:")
                    .font(.headline)
                
                Text("1. 在Xcode中运行预览")
                Text("2. 右键点击图标，选择\"Export as Image\"")
                Text("3. 保存到您的电脑")
                Text("4. 在Xcode的Assets.xcassets中替换AppIcon")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
    }
}

struct AppIconPreview_Previews: PreviewProvider {
    static var previews: some View {
        AppIconPreview()
    }
} 