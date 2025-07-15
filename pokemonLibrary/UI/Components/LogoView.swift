import SwiftUI

struct LogoView: View {
    var size: CGFloat = 200
    
    var body: some View {
        ZStack {
            // 皮卡丘
            PikachuView()
                .frame(width: size * 0.9, height: size * 0.9)
                .offset(x: size * 0.2, y: -size * 0.05)
                .zIndex(0)
            
            // 精灵球
            PokeBallView(rotation: 0)
                .frame(width: size * 0.8, height: size * 0.8)
                .offset(x: -size * 0.2, y: size * 0.1)
                .zIndex(1)
        }
        .frame(width: size, height: size)
    }
}

// 皮卡丘视图
struct PikachuView: View {
    var body: some View {
        ZStack {
            // 皮卡丘的身体（黄色）
            Circle()
                .fill(Color.yellow)
                .frame(width: 100, height: 100)
            
            // 皮卡丘的脸
            VStack(spacing: 0) {
                // 眼睛
                HStack(spacing: 30) {
                    // 左眼
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 4, height: 4)
                            .offset(x: 2, y: -2)
                    }
                    
                    // 右眼
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 4, height: 4)
                            .offset(x: 2, y: -2)
                    }
                }
                .offset(y: -10)
                
                // 鼻子
                Circle()
                    .fill(Color.black)
                    .frame(width: 6, height: 6)
                    .offset(y: -5)
                
                // 嘴巴（微笑）
                Path { path in
                    path.move(to: CGPoint(x: -15, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 15, y: 0), control: CGPoint(x: 0, y: 15))
                }
                .stroke(Color.black, lineWidth: 2)
                .offset(y: 5)
            }
            
            // 耳朵
            HStack(spacing: 70) {
                // 左耳
                Triangle()
                    .fill(Color.yellow)
                    .frame(width: 30, height: 45)
                    .rotationEffect(.degrees(-30))
                    .offset(x: -5, y: -45)
                
                // 右耳
                Triangle()
                    .fill(Color.yellow)
                    .frame(width: 30, height: 45)
                    .rotationEffect(.degrees(30))
                    .offset(x: 5, y: -45)
            }
            
            // 耳朵黑色尖端
            HStack(spacing: 70) {
                // 左耳尖
                Triangle()
                    .fill(Color.black)
                    .frame(width: 20, height: 15)
                    .rotationEffect(.degrees(-30))
                    .offset(x: -5, y: -60)
                
                // 右耳尖
                Triangle()
                    .fill(Color.black)
                    .frame(width: 20, height: 15)
                    .rotationEffect(.degrees(30))
                    .offset(x: 5, y: -60)
            }
            
            // 腮红
            HStack(spacing: 70) {
                // 左腮红
                Circle()
                    .fill(Color.red.opacity(0.6))
                    .frame(width: 18, height: 18)
                    .offset(x: 5, y: 0)
                
                // 右腮红
                Circle()
                    .fill(Color.red.opacity(0.6))
                    .frame(width: 18, height: 18)
                    .offset(x: -5, y: 0)
            }
        }
    }
}

// 三角形形状
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.orange.opacity(0.3).edgesIgnoringSafeArea(.all)
            LogoView()
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
} 