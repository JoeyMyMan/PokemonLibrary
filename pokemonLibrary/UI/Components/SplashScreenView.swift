import SwiftUI

struct SplashScreenView: View {
    // 动画状态
    @State private var isAnimating = false
    @State private var logoRotation = 0.0
    @State private var logoScale: CGFloat = 0.1
    @State private var logoOpacity = 0.0
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
                
                // Logo动画
                ZStack {
                    // 外部光环
                    if showRing {
                        Circle()
                            .stroke(Color.white.opacity(0.8), lineWidth: 8)
                            .scaleEffect(ringScale)
                            .opacity(ringOpacity)
                    }
                    
                    // Logo
                    LogoView(size: 180)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .rotationEffect(.degrees(logoRotation))
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
        
        // 显示Logo
        withAnimation(.easeOut(duration: 0.8)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        // 旋转Logo
        withAnimation(.easeInOut(duration: 3.0).repeatCount(2)) {
            logoRotation = 360
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

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(onFinished: {})
    }
} 