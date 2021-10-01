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
import SwiftUI

class MetalRenderer: NSObject, MTKViewDelegate {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue!
    var renderNodes: [MetalRenderNode]
    var mapCamera: MapCamera
    var mapTileManager: MapTileManager
    var appearanceMapTileManager: Appearance = Appearance.light
    
    init(device: MTLDevice, mapCamera: MapCamera) {
        self.device = device
        self.renderNodes = []
        self.mapTileManager = MapTileManager(device: device)
        self.mapCamera = mapCamera
        
        super.init()
        self.commandQueue = device.makeCommandQueue()
    
//        register(node: TestRenderNode())
        register(node: AreaFillRenderNode())
//        register(node: ViewRectangleRenderNode())
//        register(node: EarthSurfaceNode())
        
        self.mapTileManager.setup()
    }
    
    func register(node: MetalRenderNode) {
        node.setup(device: self.device)
        self.renderNodes.append(node)
    }
        
    private func getAppearance() -> MapNetworkAppearance? {
        return mapTileManager.get(appearance: self.appearanceMapTileManager)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.mapCamera.set(viewport: size)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        guard let mapNetworkAppearance = getAppearance() else {
            return
        }
                
        self.mapCamera.update()
        let mapTiles = self.mapCamera.getMapTiles(tileManager: self.mapTileManager)
        if (mapTiles.count > 0) {
            
            if let commandBuffer = commandQueue.makeCommandBuffer(),
               let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
                
                for node in self.renderNodes {
                    node.render(for: commandEncoder, device: self.device, camera: self.mapCamera,
                                tiles: mapTiles,
                                appearance: mapNetworkAppearance)
                
                }
                
                
                commandEncoder.endEncoding()
                commandBuffer.present(drawable)
                
                commandBuffer.commit()
            }
        }
    }
    
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
}
