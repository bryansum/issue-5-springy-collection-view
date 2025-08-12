//
//  SpringSettingsViewController.swift
//  ASHSpringyCollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

import UIKit

protocol SpringSettingsDelegate: AnyObject {
    func settingsDidChange(damping: CGFloat, frequency: CGFloat, resistance: CGFloat)
}

class SpringSettingsViewController: UIViewController {
    
    weak var delegate: SpringSettingsDelegate?
    
    private var dampingSlider: UISlider!
    private var frequencySlider: UISlider!
    private var resistanceSlider: UISlider!
    
    private var dampingLabel: UILabel!
    private var frequencyLabel: UILabel!
    private var resistanceLabel: UILabel!
    
    // Current values
    var currentDamping: CGFloat = 0.8
    var currentFrequency: CGFloat = 1.0
    var currentResistance: CGFloat = 1500.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateLabels()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Spring Settings"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Damping section
        let dampingTitleLabel = UILabel()
        dampingTitleLabel.text = "Damping"
        dampingTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dampingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dampingTitleLabel)
        
        dampingLabel = UILabel()
        dampingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        dampingLabel.textColor = UIColor.secondaryLabel
        dampingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dampingLabel)
        
        dampingSlider = UISlider()
        dampingSlider.minimumValue = 0.1
        dampingSlider.maximumValue = 1.0
        dampingSlider.value = Float(currentDamping)
        dampingSlider.addTarget(self, action: #selector(dampingChanged(_:)), for: .valueChanged)
        dampingSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dampingSlider)
        
        // Frequency section
        let frequencyTitleLabel = UILabel()
        frequencyTitleLabel.text = "Frequency"
        frequencyTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        frequencyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frequencyTitleLabel)
        
        frequencyLabel = UILabel()
        frequencyLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        frequencyLabel.textColor = UIColor.secondaryLabel
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frequencyLabel)
        
        frequencySlider = UISlider()
        frequencySlider.minimumValue = 0.5
        frequencySlider.maximumValue = 3.0
        frequencySlider.value = Float(currentFrequency)
        frequencySlider.addTarget(self, action: #selector(frequencyChanged(_:)), for: .valueChanged)
        frequencySlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frequencySlider)
        
        // Resistance section
        let resistanceTitleLabel = UILabel()
        resistanceTitleLabel.text = "Scroll Resistance"
        resistanceTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resistanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resistanceTitleLabel)
        
        resistanceLabel = UILabel()
        resistanceLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        resistanceLabel.textColor = UIColor.secondaryLabel
        resistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resistanceLabel)
        
        resistanceSlider = UISlider()
        resistanceSlider.minimumValue = 500.0
        resistanceSlider.maximumValue = 3000.0
        resistanceSlider.value = Float(currentResistance)
        resistanceSlider.addTarget(self, action: #selector(resistanceChanged(_:)), for: .valueChanged)
        resistanceSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resistanceSlider)
        
        // Preset buttons
        let presetsLabel = UILabel()
        presetsLabel.text = "Presets"
        presetsLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        presetsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(presetsLabel)
        
        let originalButton = createPresetButton(title: "Original", action: #selector(originalPreset))
        let iMessageButton = createPresetButton(title: "iMessage", action: #selector(iMessagePreset))
        let bouncyButton = createPresetButton(title: "Bouncy", action: #selector(bouncyPreset))
        let stiffButton = createPresetButton(title: "Stiff", action: #selector(stiffPreset))
        
        let buttonStack = UIStackView(arrangedSubviews: [originalButton, iMessageButton, bouncyButton, stiffButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        
        // Done button
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        doneButton.backgroundColor = UIColor.systemBlue
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 12
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dampingTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            dampingTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            dampingLabel.topAnchor.constraint(equalTo: dampingTitleLabel.topAnchor),
            dampingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dampingSlider.topAnchor.constraint(equalTo: dampingTitleLabel.bottomAnchor, constant: 8),
            dampingSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dampingSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            frequencyTitleLabel.topAnchor.constraint(equalTo: dampingSlider.bottomAnchor, constant: 30),
            frequencyTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            frequencyLabel.topAnchor.constraint(equalTo: frequencyTitleLabel.topAnchor),
            frequencyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            frequencySlider.topAnchor.constraint(equalTo: frequencyTitleLabel.bottomAnchor, constant: 8),
            frequencySlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            frequencySlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resistanceTitleLabel.topAnchor.constraint(equalTo: frequencySlider.bottomAnchor, constant: 30),
            resistanceTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            resistanceLabel.topAnchor.constraint(equalTo: resistanceTitleLabel.topAnchor),
            resistanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resistanceSlider.topAnchor.constraint(equalTo: resistanceTitleLabel.bottomAnchor, constant: 8),
            resistanceSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resistanceSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            presetsLabel.topAnchor.constraint(equalTo: resistanceSlider.bottomAnchor, constant: 40),
            presetsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            buttonStack.topAnchor.constraint(equalTo: presetsLabel.bottomAnchor, constant: 12),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 44),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 120),
            doneButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func createPresetButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func updateLabels() {
        dampingLabel.text = String(format: "%.2f", currentDamping)
        frequencyLabel.text = String(format: "%.2f", currentFrequency)
        resistanceLabel.text = String(format: "%.0f", currentResistance)
    }
    
    private func notifyDelegate() {
        delegate?.settingsDidChange(damping: currentDamping, frequency: currentFrequency, resistance: currentResistance)
    }
    
    // MARK: - Slider Actions
    
    @objc private func dampingChanged(_ slider: UISlider) {
        currentDamping = CGFloat(slider.value)
        updateLabels()
        notifyDelegate()
    }
    
    @objc private func frequencyChanged(_ slider: UISlider) {
        currentFrequency = CGFloat(slider.value)
        updateLabels()
        notifyDelegate()
    }
    
    @objc private func resistanceChanged(_ slider: UISlider) {
        currentResistance = CGFloat(slider.value)
        updateLabels()
        notifyDelegate()
    }
    
    // MARK: - Preset Actions
    
    @objc private func originalPreset() {
        setValues(damping: 0.8, frequency: 1.0, resistance: 1500.0)
    }
    
    @objc private func iMessagePreset() {
        setValues(damping: 0.6, frequency: 1.8, resistance: 1200.0)
    }
    
    @objc private func bouncyPreset() {
        setValues(damping: 0.4, frequency: 2.2, resistance: 1000.0)
    }
    
    @objc private func stiffPreset() {
        setValues(damping: 0.9, frequency: 0.8, resistance: 2000.0)
    }
    
    private func setValues(damping: CGFloat, frequency: CGFloat, resistance: CGFloat) {
        currentDamping = damping
        currentFrequency = frequency
        currentResistance = resistance
        
        dampingSlider.value = Float(damping)
        frequencySlider.value = Float(frequency)
        resistanceSlider.value = Float(resistance)
        
        updateLabels()
        notifyDelegate()
    }
    
    @objc private func donePressed() {
        dismiss(animated: true)
    }
}