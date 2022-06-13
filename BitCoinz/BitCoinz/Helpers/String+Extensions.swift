//
//  String+Extensions.swift
//  BitCoinz
//
//  Created by Olivier Butler on 13/06/2022.
//

import UIKit

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
