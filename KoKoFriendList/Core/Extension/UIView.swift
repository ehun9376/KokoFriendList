//
//  UIView.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

import UIKit

extension UIView {
    
    static var grayOverlayLayerName = "grayOverlayNameLayer"
    static var grayOverlayLayerNameBG = "grayOverlayLayerNameBG"
    
    func addFlashLayer(frame: CGRect? = nil, backgroundColor: UIColor = .white, cornerRadius: CGFloat = 4) {
        // 檢查是否已經存在灰色圖層，避免重複添加
        if layer.sublayers?.contains(where: { $0.name == UIView.grayOverlayLayerName || $0.name == UIView.grayOverlayLayerNameBG }) == true {
            return
        }
        
        let grayOverlayLayerBG = CALayer()
        grayOverlayLayerBG.name = UIView.grayOverlayLayerNameBG
        if let frame = frame {
            grayOverlayLayerBG.frame = frame
        } else {
            grayOverlayLayerBG.frame = bounds
        }
        grayOverlayLayerBG.backgroundColor = backgroundColor.cgColor
        grayOverlayLayerBG.opacity = 1
        grayOverlayLayerBG.cornerRadius = cornerRadius
        
        layer.addSublayer(grayOverlayLayerBG)
        
        let grayOverlayLayer = CALayer()
        grayOverlayLayer.name = UIView.grayOverlayLayerName
        if let frame = frame {
            grayOverlayLayer.frame = frame
        } else {
            grayOverlayLayer.frame = bounds
        }
        grayOverlayLayer.backgroundColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        grayOverlayLayer.opacity = 0.0
        grayOverlayLayer.cornerRadius = cornerRadius
        
        layer.addSublayer(grayOverlayLayer)
        
        // 添加閃爍動畫
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0.0
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.duration = 1
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.beginTime = fadeInAnimation.duration
        fadeOutAnimation.duration = 1
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        let flickerAnimation = CAAnimationGroup()
        flickerAnimation.animations = [fadeInAnimation, fadeOutAnimation]
        flickerAnimation.duration = fadeInAnimation.duration + fadeOutAnimation.duration
        flickerAnimation.repeatCount = .infinity
        
        grayOverlayLayer.add(flickerAnimation, forKey: "flickerAnimation")
    }
    
    func removeFlashLayer() {
        if let grayOverlayLayer = layer.sublayers?.first(where: { $0.name == UIView.grayOverlayLayerName }){
            grayOverlayLayer.removeAnimation(forKey: "flickerAnimation")
            grayOverlayLayer.removeFromSuperlayer()
        }
        
        if let grayOverlayLayerBG = layer.sublayers?.first(where: { $0.name == UIView.grayOverlayLayerNameBG }){
            grayOverlayLayerBG.removeFromSuperlayer()
        }
        
    }
}
