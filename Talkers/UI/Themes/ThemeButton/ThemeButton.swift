//
//  ThemeButton.swift
//  Talkers
//
//  Created by Natalia Kazakova on 05.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

@IBDesignable class ThemeButton: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messagesWrapper: UIView!
    @IBOutlet weak var incomingMessage: UIView!
    @IBOutlet weak var outgoingMessage: UIView!
    
    @IBInspectable var incomingColor: UIColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1) {
        didSet {
            incomingMessage.backgroundColor = incomingColor
        }
    }
    
    @IBInspectable var outgoingColor: UIColor = #colorLiteral(red: 0.862745098, green: 0.968627451, blue: 0.7725490196, alpha: 1) {
        didSet {
            outgoingMessage.backgroundColor = outgoingColor
        }
    }
    
    @IBInspectable var chatBackgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 0.9294117647, alpha: 1) {
        didSet {
            messagesWrapper.backgroundColor = chatBackgroundColor
        }
    }
    
    @IBInspectable var labelColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            titleLabel.textColor = labelColor
        }
    }
    
    @IBInspectable var labelText: String = "Classic" {
        didSet {
            titleLabel.text = labelText
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
        messagesWrapper.layer.cornerRadius = 8.0
    }
    
    func initMessageBoxes() {
        incomingMessage.layer.cornerRadius = 8.0
        outgoingMessage.layer.cornerRadius = 8.0
    }
}
