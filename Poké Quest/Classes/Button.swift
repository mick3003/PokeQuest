//
//  Button.swift
//  Poké Quest
//
//  Created by Miguel Estévez on 2/11/17.
//  Copyright © 2017 Miguel Estévez. All rights reserved.
//

import UIKit

class Button: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        var size = self.titleLabel?.frame.size
        size?.width = self.bounds.width
        size?.height = self.bounds.height
        self.titleLabel?.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size!)
        self.titleLabel?.textAlignment = .center
    }

}
