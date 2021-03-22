//
//  MetalRenderer.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 02.03.21.
//

import Foundation
import Metal
import MetalKit
import simd
import MapTiles

class MetalRenderer: NSObject, MTKViewDelegate {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue!
    var renderNodes: [MetalRenderNode]
    var mapCamera: MapCamera = MapCamera()
    
    
    init(device: MTLDevice) {
        self.device = device
        self.renderNodes = []
        
        super.init()
        self.commandQueue = device.makeCommandQueue()
        
        register(node: EarthSurfaceNode())
    }
    
    func register(node: MetalRenderNode) {
        node.setup(device: self.device)
        self.renderNodes.append(node)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.mapCamera.set(viewport: size)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        self.mapCamera.update()
        
        if let commandBuffer = commandQueue.makeCommandBuffer(),
           let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
            
            for node in self.renderNodes {
                node.render(for: commandEncoder, device: self.device, camera: self.mapCamera)
            }
            
            commandEncoder.endEncoding()
            commandBuffer.present(drawable)
            
            commandBuffer.commit()
        }
    }
    
    // zoom move etc... methods
    func zoomIn(_ location: CGPoint) {
        self.mapCamera.zoomIn(location)
    }
    
    func zoomOut(_ location: CGPoint) {
        self.mapCamera.zoomOut(location)
    }
    
    func move(from: CGPoint, to: CGPoint) {
        self.mapCamera.move(from: from, to: to)
    }
 
    func pinchLocation(_ location: CGPoint) {
        self.mapCamera.pinchLocation(location)
    }
    
    func pinchScaleBigger() {
        self.mapCamera.pinchScaleBigger()
    }
    
    func pinchScaleSmaller() {
        self.mapCamera.pinchScaleSmaller()
    }
    
}
