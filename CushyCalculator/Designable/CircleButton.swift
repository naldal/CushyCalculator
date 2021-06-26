//
//  CircleButton.swift
//  CushyCalculator
//
//  Created by 송하민 on 2021/06/25.
//

import Foundation
import UIKit

@IBDesignable
class CircleButton: UIButton {
    
    
    // IBInspectable 인스펙터 패널에서 사용될 수 있도록 설정
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
