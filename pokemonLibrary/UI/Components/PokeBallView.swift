import SwiftUI

// 精灵球视图
struct PokeBallView: View {
    var rotation: Double
    
    var body: some View {
        ZStack {
            // 上半部分（红色）
            Circle()
                .fill(Color.red)
                .frame(width: 150, height: 150)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 5)
                )
                .mask(
                    Rectangle()
                        .frame(width: 150, height: 75)
                        .offset(y: -37.5)
                )
            
            // 下半部分（白色）
            Circle()
                .fill(Color.white)
                .frame(width: 150, height: 150)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 5)
                )
                .mask(
                    Rectangle()
                        .frame(width: 150, height: 75)
                        .offset(y: 37.5)
                )
            
            // 中间的分割线
            Rectangle()
                .fill(Color.black)
                .frame(width: 150, height: 5)
            
            // 中间的按钮
            Circle()
                .fill(Color.white)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 5)
                )
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
        }
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

struct PokeBallView_Previews: PreviewProvider {
    static var previews: some View {
        PokeBallView(rotation: 0)
            .previewLayout(.sizeThatFits)
            .padding()
    }
} 