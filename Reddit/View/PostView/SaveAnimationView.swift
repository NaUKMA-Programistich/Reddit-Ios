import UIKit

class SaveAnimationView: UIView {
    static let width = 50.0
    static let height = 100.0

    var path: UIBezierPath!


    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        path = UIBezierPath()

        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height - 30))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.systemYellow.cgColor
        self.layer.addSublayer(shapeLayer)


        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(
              withDuration: 0.8,
              delay: 0.0,
              usingSpringWithDamping: 0.2,
              initialSpringVelocity: 0.4,
              options: .curveEaseOut,
              animations: {
                  self.transform = CGAffineTransform(scaleX: 1, y: 1)
              },
              completion: {_ in
                  self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
              }
        )
    }

}
