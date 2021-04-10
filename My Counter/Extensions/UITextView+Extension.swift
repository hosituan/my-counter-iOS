//
//  UITextView+Extension.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 11/04/2021.
//

import Foundation
import UIKit

extension UITextView {
    private class PlaceholderLabel: UILabel { }
    
    private var placeholderLabel: PlaceholderLabel {
        if let label = getPlaceholderLabel() {
            return label
        } else {
            textStorage.delegate = self
            
            let label = PlaceholderLabel()
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = font
            label.textAlignment = textAlignment
            label.textColor = placeholderColor ?? .lightGray
            
            addSubview(label)
            
            var textContainerView = self.subviews.first
            let containerView = "UI" + "Text" + "Container" + "View"
            
            for v in self.subviews {
                if v.description.contains(containerView) {
                    textContainerView = v
                    break
                }
            }
            
            let contentView = textContainerView ?? self
            
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: textContainerInset.left).isActive = true
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -textContainerInset.right).isActive = true
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textContainerInset.top).isActive = true
            _ = label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -textContainerInset.bottom)
            
            return label
        }
    }
    
    var placeholderColor: UIColor? {
        get {
            return getPlaceholderLabel()?.textColor
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.textColor = newValue
        }
    }
    
    var placeholder: String? {
        get {
            return getPlaceholderLabel()?.text
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
        }
    }
    
    private func getPlaceholderLabel() -> PlaceholderLabel? {
        return subviews.compactMap( { $0 as? PlaceholderLabel }).first
    }
    
    func applyCharacterSpacing(_ spacing: CGFloat) {
        guard let text = self.text else  { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
    func applyLineSpacing(_ spacing: CGFloat, alignment: NSTextAlignment) {
        guard let text = self.text else  { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.lineHeightMultiple = 0
        paragraphStyle.alignment = alignment
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}

extension UITextView: NSTextStorageDelegate {
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}
