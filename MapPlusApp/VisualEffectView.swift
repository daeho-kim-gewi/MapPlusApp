//
//  VisualEffectView.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 20.04.21.
//


import Foundation
import SwiftUI
import UIKit

struct VisualEffectView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .systemThinMaterial) {
        self.style = style
    }
    
    
    func makeUIView(context: UIViewRepresentableContext<VisualEffectView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<VisualEffectView>) {
        
        
    }
    
}
