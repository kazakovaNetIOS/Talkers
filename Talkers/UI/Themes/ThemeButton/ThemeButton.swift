//
//  ThemeButton.swift
//  Talkers
//
//  Created by Natalia Kazakova on 05.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

@IBDesignable class ThemeButton: UIView {
    
    var themeSettings = ThemeSettings()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messagesWrapper: UIView!
    @IBOutlet weak var incomingMessage: UIView!
    @IBOutlet weak var outgoingMessage: UIView!
    
    @IBInspectable var incomingColor: UIColor = ThemeSettings.defaultIncomingColor {
        didSet {
            incomingMessage.backgroundColor = incomingColor
            themeSettings.incomingColor = incomingColor
        }
    }
    
    @IBInspectable var outgoingColor: UIColor = ThemeSettings.defaultOutgoingColor {
        didSet {
            outgoingMessage.backgroundColor = outgoingColor
            themeSettings.outgoingColor = outgoingColor
        }
    }
    
    @IBInspectable var chatBackgroundColor: UIColor = ThemeSettings.defaultChatBackgroundColor {
        didSet {
            messagesWrapper.backgroundColor = chatBackgroundColor
            themeSettings.chatBackgroundColor = chatBackgroundColor
        }
    }
    
    @IBInspectable var labelColor: UIColor = ThemeSettings.defaultLabelColor {
        didSet {
            titleLabel.textColor = labelColor
            themeSettings.labelColor = labelColor
        }
    }
    
    @IBInspectable var labelText: String = ThemeSettings.defaultLabelText {
        didSet {
            titleLabel.text = labelText
            themeSettings.labelText = labelText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Private

private extension ThemeButton {
    func commonInit() {
        guard let view = loadFromNib() else { return }
        
        view.frame = self.bounds
        
        self.addSubview(view)
        
        initMessageWrapperView()
        initMessageBoxes()
    }
    
    func loadFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: ThemeButton.self), bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func initMessageWrapperView() {
        messagesWrapper.layer.cornerRadius = 14.0
        messagesWrapper.layer.borderWidth = 1.0
        messagesWrapper.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    }
    
    func initMessageBoxes() {
        incomingMessage.layer.cornerRadius = 8.0
        outgoingMessage.layer.cornerRadius = 8.0
    }
}

// MARK: - Public

extension ThemeButton {
    func isSelected(_ selected: Bool) {
        messagesWrapper.layer.borderWidth = selected ? 3.0 : 1.0
        messagesWrapper.layer.borderColor = selected ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    }
}
