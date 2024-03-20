import SwiftUI

struct CommentView: View {
    let comment: Comment
    let isSingleLineText: Bool

    @State private var animationAmount: CGFloat = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(comment.user)
                    .font(.title3)
                Spacer()
                Text(comment.timeString)
                    .font(.title3)
                Button {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.8)) {
                        self.animationAmount += 0.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeIn(duration: 1)) {
                            self.animationAmount = 1
                        }
                    }
                } label: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 20, height: 20)
                        .scaleEffect(animationAmount)
                }
            }
            Text(comment.text)
                .lineLimit(isSingleLineText ? 1 : nil)
                .font(.system(.body, design: .monospaced))
            Text(comment.ratingString)
                .font(.headline)
        }
    }
}
