//
//  calcButton.swift
//  calculator
//
//  Created by Niklas Nordin on 2020-05-28.
//

import UIKit

@IBDesignable
class calcButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
// #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    let bgColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    let textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    let tntColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    func calcButtonSettings()
    {
        layer.cornerRadius = frame.height / 4
        showsTouchWhenHighlighted = true
        //var bounds = UIScreen.main.bounds
        //var width = 70
        //frame.size = CGSize(width: 60, height: 40)
        self.backgroundColor = bgColor
        self.setTitleColor(textColor, for: UIControl.State.normal)
        self.tintColor = tntColor
        
        self.layer.shadowColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 1.0
        
        //let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialLight))
        //self.insertSubview(blur, at: 0)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addTarget(self, action: #selector(feedback), for: .touchUpInside)
    }
    
    @objc func feedback()
    {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    @IBInspectable var active: Bool = false {
        didSet {
            if active {
                calcButtonSettings()
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if active {
            calcButtonSettings()
        }
    }

}
