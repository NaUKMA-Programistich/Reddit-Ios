import UIKit
import SwiftUI

class PostDetailsViewController: UIViewController {
    enum Constants: String {
        case seque = "PostDetailSeque"
    }

    // MARK: View
    @IBOutlet private weak var postView: PostView!
    @IBOutlet private weak var commentsView: UIView!

    // MARK: Configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        postView.shareDelegate = self

    }

    func config(post: RedditPost) {
        postView?.configure(post: post)

        let swiftUI = CommentListScreen(post: post) { comment in
            let swiftUIController = UIHostingController(rootView: CommentScreen(comment: comment))
            self.navigationController?.pushViewController(swiftUIController, animated: true)
        }
        let swiftUIController = UIHostingController(rootView: swiftUI)
        let swifUIView: UIView = swiftUIController.view

        self.commentsView.addSubview(swifUIView)
        swifUIView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            swifUIView.topAnchor.constraint(equalTo: self.commentsView.topAnchor),
            swifUIView.trailingAnchor.constraint(equalTo: self.commentsView.trailingAnchor),
            swifUIView.bottomAnchor.constraint(equalTo: self.commentsView.bottomAnchor),
            swifUIView.leadingAnchor.constraint(equalTo: self.commentsView.leadingAnchor),
        ])
        swiftUIController.didMove(toParent: self)
    }
}
