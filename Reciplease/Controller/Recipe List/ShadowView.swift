import UIKit

/// UIView class for ShadowView for adding gradient. 
class ShadowView: UIView {
    
    private var gradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGradient()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        self.gradientLayer = gradientLayer
        gradientLayer.frame = frame
        
        let bottomColor = UIColor.black.withAlphaComponent(0.8).cgColor
        
        gradientLayer.colors = [UIColor.clear.cgColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = frame
    }
}
