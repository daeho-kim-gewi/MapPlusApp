//
//  AreaFillRenderNode.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 25.03.21.
//

import Foundation
import simd
import Metal
import MapTiles

fileprivate struct Uniform {
    var mvp: float4x4
    var color: float4
}


public class AreaFillRenderNode: MetalRenderNode  {
	private var uniform: Uniform = Uniform(mvp: float4x4.identity(),
                                           color: float4(0, 0, 1.0, 1.0))
    
    private var renderPipelineState: MTLRenderPipelineState?
    private var depthStencilState: MTLDepthStencilState?

    
    func setup(device: MTLDevice) {
        if let library = device.makeDefaultLibrary() {
            let vertexFunc = library.makeFunction(name: "areaFillVertex") 
            let fragmentFunc = library.makeFunction(name: "areaFillFragment")
            
            let rpld = MTLRenderPipelineDescriptor()
            rpld.vertexFunction = vertexFunc
            rpld.fragmentFunction = fragmentFunc
            rpld.depthAttachmentPixelFormat = .invalid
            
            if let colorAttachments = rpld.colorAttachments[0] {
                colorAttachments.pixelFormat = .bgra8Unorm
                colorAttachments.isBlendingEnabled = false
            }
            
            let depthStencilDesc = MTLDepthStencilDescriptor()
            depthStencilDesc.depthCompareFunction = .never
            depthStencilDesc.isDepthWriteEnabled = false
            
            self.depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDesc)
            
            do {
                try self.renderPipelineState = device.makeRenderPipelineState(descriptor: rpld)
            } catch let error {
                print("AreaFillRenderNode(setup): \(error)")
            }
        }
    }
    
    func render(for commandEncoder: MTLRenderCommandEncoder, device: MTLDevice,
                camera: MapCamera, tiles: [VMapTile],
                appearance: MapNetworkAppearance) {
        
        if let rps = self.renderPipelineState, let dss = self.depthStencilState {
            self.uniform.mvp = camera.modelViewProjection
            
            commandEncoder.setRenderPipelineState(rps)
            commandEncoder.setDepthStencilState(dss)
            
            // Get areas from map tiles
            for tile in tiles {
                if let drawing = tile.DrawingData {        
                    let areaData = drawing.areaData
                    for areaSubType in areaData.getKeys() {

                        let zoomLevel = Int(VMapTileId.getMapTileSize(tileId: tile.TileId).rawValue)
                        
                        if let areaAppearance = appearance.getAppearance(area: areaSubType),
                           let zoomLevelAppearance = areaAppearance.getZoomLevelAppearance(for: zoomLevel) {

                            // zoomLevelAppearance.drawings erst mal nur das erste element des array verwenden
                            if let fillAreaDrawing = zoomLevelAppearance.drawings.first,
                               let areaFillColor = fillAreaDrawing.fillColor,
                               let fillColor = float4.getColor(hex: areaFillColor) {

                                // get colors from appearance
                                self.uniform.color = float4(fillColor)
                                                                
                                if let data = areaData.getAreaData(for: areaSubType) {
                                    commandEncoder.setVertexBuffer(data.vertexBuffer, offset: 0, index: 0)
                                    commandEncoder.setVertexBytes(&self.uniform, length: MemoryLayout<Uniform>.stride, index: 1)
                                    commandEncoder.setFragmentBytes(&self.uniform, length: MemoryLayout<Uniform>.stride, index: 1)
                                    
                                    // draw each one
                                    commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: data.indexCount,
                                                                         indexType: .uint32, indexBuffer: data.indexBuffer,
                                                                         indexBufferOffset: 0)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
