//
//  Button.swift
//  TetrisAR
//
//  Created by Kenny Cohen on 6/24/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import Foundation
import UIKit

class Button {
    private let button: UIButton
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, text: String) {
        button = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let buttonText = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        buttonText.textAlignment = .center
        buttonText.textColor = UIColor.white
        buttonText.font = .boldSystemFont(ofSize: 20.0)
        buttonText.text = text
        button.addSubview(buttonText)
    }
    
    func getButton() -> UIButton {
        return button
    }
    
    
}
