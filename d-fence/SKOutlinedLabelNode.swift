//
//  SKOutlinedLabelNode.swift
//
//  aka MKOutlinedLabelNode.swift
//
//  Created by Mario Klaver on 13-8-2015.
//  Copyright (c) 2015 Endpoint ICT. All rights reserved.
//
//  Upgraded by Hendrik Ulbrich on 01-05-2018.
//
import UIKit
import SpriteKit

class SKOutlinedLabelNode: SKLabelNode {
    
    // MARK: Label Node with Border Component
    
    var borderColor: UIColor = UIColor.black
    var borderWidth: CGFloat = 8.0
    var borderOffset : CGPoint = CGPoint(x: 0, y: 0)
    
    enum borderStyleType {
        case over
        case under
    }
    var borderStyle = borderStyleType.under
    
    // Redraw the label each time the outlined text changes.
    var outlinedText: String! {
        didSet { drawText() }
    }
    
    var border: SKShapeNode?
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override init() { super.init() }
    
    init(fontNamed fontName: String!, fontSize: CGFloat) {
        super.init(fontNamed: fontName)
        self.fontSize = fontSize
    }
    
    func drawText() {
        if let borderNode = border {
            borderNode.removeFromParent()
            border = nil
        }
        
        if let text = outlinedText {
            self.text = text
            if let path = createBorderPathForText() {
                let border = SKShapeNode()
                
                border.strokeColor = borderColor
                border.lineWidth = borderWidth;
                border.path = path
                border.position = positionBorder(border: border)
                
                switch self.borderStyle {
                case borderStyleType.over:
                    border.zPosition = 10
                    break
                default:
                    border.zPosition = -10
                }
                
                addChild(border)
                
                self.border = border
            }
        }
    }
    
    // Get each character from the text
    private func getTextAsCharArray() -> [UniChar] {
        var chars = [UniChar]()
        
        for codeUnit in (text?.utf16)! {
            chars.append(codeUnit)
        }
        return chars
    }
    
    // Render the border as a separate node
    private func createBorderPathForText() -> CGPath? {
        let chars = getTextAsCharArray()
        let borderFont = CTFontCreateWithName((self.fontName as CFString?)!, self.fontSize, nil)
        
        var glyphs = Array<CGGlyph>(repeating: 0, count: chars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(borderFont, chars, &glyphs, chars.count)
        
        if gotGlyphs {
            var advances = Array<CGSize>(repeating: CGSize(), count: chars.count)
            CTFontGetAdvancesForGlyphs(borderFont, CTFontOrientation.horizontal, glyphs, &advances, chars.count);
            
            let letters = CGMutablePath()
            var xPosition = 0 as CGFloat
            for index in 0...(chars.count - 1) {
                let letter = CTFontCreatePathForGlyph(borderFont, glyphs[index], nil)
                let t = CGAffineTransform(translationX: xPosition , y: 0)
                if let l = letter {
                    letters.addPath(l, transform: t)
                }
                xPosition = xPosition + advances[index].width
            }
            
            return letters
        } else {
            return nil
        }
    }
    
    // Print the border with an offset
    private func positionBorder(border: SKShapeNode) -> CGPoint {
        let sizeText = self.calculateAccumulatedFrame()
        let sizeBorder = border.calculateAccumulatedFrame()
        let offsetX = sizeBorder.width - sizeText.width
        
        switch self.horizontalAlignmentMode {
        case SKLabelHorizontalAlignmentMode.center:
            return CGPoint(x: -(sizeBorder.width / 2) + offsetX/2.0 + self.borderOffset.x, y: 1 + self.borderOffset.y)
        case SKLabelHorizontalAlignmentMode.left:
            return CGPoint(x: sizeBorder.origin.x - self.borderWidth*2 + offsetX + self.borderOffset.x, y: 1 + self.borderOffset.y)
        default:
            return CGPoint(x: sizeBorder.origin.x - sizeText.width - self.borderWidth*2 + offsetX + self.borderOffset.x, y: 1 + self.borderOffset.y)
        }
    }
}
