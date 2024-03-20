import Foundation
import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: View
    @IBOutlet weak var postView: PostView!

    // MARK: Configuration cell
    func configure(post: RedditPost) {
        self.selectionStyle = .none
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        postView?.configure(post: post)
    }
}
