//
//  MetalView.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 02.03.21.
//

import SwiftUI
import Metal
import MetalKit
import MapTiles

struct MetalKitView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    public var wrappedView: UIView
    private var handleUpdateUIView: ((UIView, Context) -> Void)?
    
    
    init(view: () -> UIView, update: ((UIView, Context) -> Void)? = nil) {
        wrappedView = view()
        handleUpdateUIView = update
    }
    
    func makeUIView(context: Context) -> UIView {
        return wrappedView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        handleUpdateUIView?(uiView, context)
    }
}

class MetalUIKitView : MTKView, ObservableObject {
    private var renderer: MetalRenderer!
    private var lastLocation: CGPoint? = nil
    private var mapCamera: MapCamera
    private var scheme: Appearance = .light
    
    init(mapCamera: MapCamera) {
        self.mapCamera = mapCamera
        super.init(frame: .zero, device: MTLCreateSystemDefaultDevice())
        
        guard let defaultDevice = device else {
            fatalError("Could not create Metal device!")
        }
        
        colorPixelFormat = .bgra8Unorm
        clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        self.renderer = MetalRenderer(device: defaultDevice, mapCamera: mapCamera)
        self.delegate = self.renderer
        
        
        set(scheme: scheme)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(scheme: Appearance) {
        if scheme == .light {
            clearColor = MTLClearColor(red: 0xEB/255.0, green: 0xE9/255.0, blue: 0xE6/255.0, alpha: 1.0)
        } else {
            clearColor = MTLClearColor(red: 0x1E/255.0, green: 0x1E/255.0, blue: 0x1E/255.0, alpha: 1.0)
        }
    }
    
    public func getAppearance() -> Appearance {
        return scheme
    }
    
    func setupGestures() {
        // setup gestures
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(gesture:)))
        self.addGestureRecognizer(pinchGesture)
        
        // zoom per double tap
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(doubleTapGesture)
        
        // zoom per double tap
        let twoFingersDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTwoFingersDoubleTap(gesture:)))
        twoFingersDoubleTapGesture.numberOfTapsRequired = 2
        twoFingersDoubleTapGesture.numberOfTouchesRequired = 2
        
        self.addGestureRecognizer(twoFingersDoubleTapGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSingleTap(gesture:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        singleTapGesture.require(toFail: doubleTapGesture)
        self.addGestureRecognizer(singleTapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(gesture:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func onSingleTap(gesture: UITapGestureRecognizer) {
        // single click... ???
//        let fingerPosition = gesture.location(in: self)
//        print(fingerPosition)
    }
    
    @objc private func onDoubleTap(gesture: UITapGestureRecognizer) {
        // double tapped with one finger ... zoom in
        let location = gesture.location(in: self)
        renderer.zoomIn(location)
    }
    
    @objc private func onTwoFingersDoubleTap(gesture: UITapGestureRecognizer) {
        // double tapped with two fingers... zoom out
        // TODO: Daeho
        let tapped = gesture.location(in: self)
        renderer.zoomOut(tapped)
    }
    
    
    @objc private func onPinch(gesture: UIPinchGestureRecognizer) {
        // zoom in or out with two fingers or rotate the map
        let scale = gesture.scale
        
        if gesture.state == .began {
            self.lastLocation = gesture.location(in: self)
            self.transform.scaledBy(x: scale, y: scale)
        } else if gesture.state == .changed {
            
            // process this scale, zoom the map....
            
            // zoom for position "pinchLocation"
            renderer.pinchLocation(lastLocation!)
            
            
        } else if gesture.state == .ended {
            // no more changes
            self.lastLocation = nil
        }
        
        // for the next pinch action
        gesture.scale = 1.0
    }
    
    
    
    @objc private func onPan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        if gesture.state == .began {
            self.lastLocation = location
        } else if gesture.state == .changed, let lastPos = self.lastLocation {
            renderer.move(from: lastPos, to: location)
            self.lastLocation = location
        } else if gesture.state == .ended || gesture.state == .cancelled {
            self.lastLocation = nil
        }
    }
}

struct MetalView: View {
    var mapCamera: MapCamera
    
    var body: some View {
        MetalKitView {
            MetalUIKitView(mapCamera: mapCamera)
        } update: { (view, context) in
            if let mtkView = view as? MetalUIKitView  {
                mtkView.setupGestures()
            }
        }
    }
}

