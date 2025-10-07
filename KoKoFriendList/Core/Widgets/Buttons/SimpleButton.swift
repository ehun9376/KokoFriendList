import UIKit

class SimpleButton: UIButton {
    
    private var actionClosure: (() -> Void)?
    private var tintColors: [UInt: UIColor] = [:] // 儲存每個 state 對應的 tintColor
    private var fonts: [UInt: UIFont] = [:]
    
    override var isHighlighted: Bool {
        didSet {
            self.updateTintColor()
            self.updateFont()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.updateTintColor()
            self.updateFont()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            self.updateTintColor()
            self.updateFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButton()
    }

    private func setupButton() {
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action Closure
    
    func setActionClosure(_ closure: (() -> Void)?) {
        self.actionClosure = closure
    }
    
    @objc private func buttonTapped() {
        self.actionClosure?()
    }
    
    // MARK: - Background Color
    
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        guard let color = color else {
            self.setBackgroundImage(nil, for: state)
            return
        }
        let backgroundImage = self.createImageWithColor(color)
        self.setBackgroundImage(backgroundImage, for: state)
    }

    private func createImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        color.setFill()
        UIRectFill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    func setFont(_ font: UIFont?, for state: UIControl.State) {
        if let font = font {
            self.fonts[state.rawValue] = font
        } else {
            self.fonts.removeValue(forKey: state.rawValue)
        }
    }
    
    private func updateFont() {
        // 根據目前狀態更新顏色（優先順序：disabled > selected > highlighted > normal）
        if !self.isEnabled, let font = self.fonts[UIControl.State.disabled.rawValue] {
            self.titleLabel?.font = font
        } else if self.isHighlighted, let font = self.fonts[UIControl.State.highlighted.rawValue] {
            self.titleLabel?.font = font
        } else if self.isSelected, let font = self.fonts[UIControl.State.selected.rawValue] {
            self.titleLabel?.font = font
        } else if let font = self.fonts[UIControl.State.normal.rawValue] {
            self.titleLabel?.font = font
        }
    }

    // MARK: - Tint Color 管理
    
    func setTintColor(_ color: UIColor?, for state: UIControl.State) {
        if let color = color {
            self.tintColors[state.rawValue] = color
        } else {
            self.tintColors.removeValue(forKey: state.rawValue)
        }
        self.updateTintColor()
    }
    
    private func updateTintColor() {
        // 根據目前狀態更新顏色（優先順序：disabled > selected > highlighted > normal）
        if !self.isEnabled, let color = self.tintColors[UIControl.State.disabled.rawValue] {
            self.tintColor = color
        } else if self.isHighlighted, let color = self.tintColors[UIControl.State.highlighted.rawValue] {
            self.tintColor = color
        } else if self.isSelected, let color = self.tintColors[UIControl.State.selected.rawValue] {
            self.tintColor = color
        } else if let color = self.tintColors[UIControl.State.normal.rawValue] {
            self.tintColor = color
        } else {
            self.tintColor = .systemBlue // fallback 顏色
        }
    }
    
    
}
