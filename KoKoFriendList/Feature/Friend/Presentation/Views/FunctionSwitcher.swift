//
//  FunctionSwitcher.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//
import UIKit

class FunctionSwitcher: UIView {
    
    // MARK: - Properties
    private var tabs: [FriendListTab] = []
    private var onTabSelected: ((FriendListTab) -> ())?
    
    private var stackView = UIStackView()
    
    private var slider = UIView()
    
    private var sliderLeadingConstraint: NSLayoutConstraint?
    private var tabButtons: [FriendListTab: TabButton] = [:]
    
    let offset: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .grayFCFCFC
        
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.stackView.alignment = .center
        self.stackView.spacing = 30
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.slider.backgroundColor = .pinkEC008C
        self.slider.layer.cornerRadius = 2
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.stackView)
        self.addSubview(self.slider)
        
        let trailingConstraint = self.stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -self.offset)
        trailingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.offset),
            trailingConstraint,
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            self.slider.heightAnchor.constraint(equalToConstant: 4),
            self.slider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.slider.widthAnchor.constraint(equalToConstant: 30)
        ])

        self.sliderLeadingConstraint = self.slider.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.sliderLeadingConstraint?.isActive = true
    }
    
    func configure(tabs: [FriendListTab], currentTab: FriendListTab, onTabSelected: ((FriendListTab) -> ())?) {
        self.onTabSelected = onTabSelected
        
        self.stackView.removeAllArrangedSubviews()
        self.tabButtons.removeAll()
        
        for tab in tabs {
            let button = TabButton(title: tab.title, action: { [weak self] in
                guard let self = self else { return }
                self.updateSelection(tab: tab, animated: true)
                self.onTabSelected?(tab)
            })
            self.stackView.addArrangedSubview(button)
            self.tabButtons[tab] = button
        }
        
        // 先選中按鈕
        self.tabButtons[currentTab]?.simpleButton.isSelected = true
        
        // 在下一個 run loop 中計算 slider 位置，確保 layout 已完成
        DispatchQueue.main.async { [weak self] in
            self?.updateSliderPosition(for: currentTab, animated: false)
        }
    }
    
    func setBadge(for tab: FriendListTab, count: Int?) {
        self.tabButtons[tab]?.setBadge(count: count)
    }
    
    private func updateSelection(tab: FriendListTab, animated: Bool) {
        for button in self.tabButtons.values {
            button.simpleButton.isSelected = false
        }
        
        self.tabButtons[tab]?.simpleButton.isSelected = true
        
        self.updateSliderPosition(for: tab, animated: animated)
    }
    
    private func updateSliderPosition(for tab: FriendListTab, animated: Bool) {
        guard let targetButton = self.tabButtons[tab]?.simpleButton else { return }
        
        self.layoutIfNeeded()
        
        let buttonCenterInSwitcher = targetButton.convert(CGPoint(x: targetButton.bounds.midX, y: 0), to: self)
        
        let sliderHalfWidth: CGFloat = 15.0
        let sliderOffset = buttonCenterInSwitcher.x - sliderHalfWidth
        
        self.sliderLeadingConstraint?.constant = sliderOffset
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
}
