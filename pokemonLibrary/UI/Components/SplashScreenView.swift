import SwiftUI

struct SplashScreenView: View {
    // 动画状态
    @State private var isAnimating = false
    @State private var pokeBallRotation = 0.0
    @State private var pokeBallScale: CGFloat = 0.1
    @State private var pokeBallOpacity = 0.0
    @State private var titleScale: CGFloat = 0.5
    @State private var titleOpacity = 0.0
    @State private var showRing = false
    @State private var ringScale: CGFloat = 0.1
    @State private var ringOpacity = 0.0
    @State private var isFinished = false
    @State private var gradientProgress: CGFloat = 0.0
    
    // 完成回调
    var onFinished: () -> Void
    
    // 初始化
    init(onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
    }
    
    // 背景颜色渐变
    var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.orange]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {
            // 背景颜色
            backgroundGradient
                .opacity(gradientProgress)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // 标题
                VStack(spacing: 8) {
                    Text("宝可梦图鉴")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)
                    
                    Text("Pokémon Library")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)
                }
                .padding(.top, 80)
                
                Spacer()
                
                // 精灵球动画
                ZStack {
                    // 外部光环
                    if showRing {
                        Circle()
                            .stroke(Color.white.opacity(0.8), lineWidth: 8)
                            .scaleEffect(ringScale)
                            .opacity(ringOpacity)
                    }
                    
                    // 精灵球
                    PokeBallView(rotation: pokeBallRotation)
                        .frame(width: 150, height: 150)
                        .scaleEffect(pokeBallScale)
                        .opacity(pokeBallOpacity)
                        .rotationEffect(.degrees(pokeBallRotation))
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    // 开始动画序列
    private func startAnimation() {
        // 背景渐变动画
        withAnimation(.easeIn(duration: 1.0)) {
            gradientProgress = 1.0
        }
        
        // 显示精灵球
        withAnimation(.easeOut(duration: 0.8)) {
            pokeBallOpacity = 1.0
            pokeBallScale = 1.0
        }
        
        // 旋转精灵球
        withAnimation(.easeInOut(duration: 3.0).repeatCount(2)) {
            pokeBallRotation = 720
        }
        
        // 显示标题
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                titleOpacity = 1.0
                titleScale = 1.0
            }
        }
        
        // 显示光环
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showRing = true
            withAnimation(.easeOut(duration: 0.8)) {
                ringOpacity = 1.0
                ringScale = 2.0
            }
            
            // 光环消失
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeIn(duration: 0.5)) {
                    ringOpacity = 0.0
                }
            }
        }
        
        // 动画结束后调用完成回调
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isFinished = true
            }
            
            // 调用完成回调
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onFinished()
            }
        }
    }
}

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

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(onFinished: {})
    }
} 