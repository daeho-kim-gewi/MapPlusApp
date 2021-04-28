//
//  ViewRectangleRenderNode.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 28.04.21.
//


import Foundation
import simd
import Metal
import MapTiles

fileprivate struct Uniform {
    var mvp: float4x4
    var color: float4
}


public class ViewRectangleRenderNode: MetalRenderNode  {
    private var uniform: Uniform = Uniform(mvp: float4x4(scaling: float3(1.0/180.0 * 3.0, 1.0/180.0, 1.0)),
                                           color: float4(0.25, 0, 0.0, 0.25))
    
    private var renderPipelineState: MTLRenderPipelineState?
    private var depthStencilState: MTLDepthStencilState?
    private var vertices: [float2] = []
    private var indices: [UInt32] = [0, 1, 2, 3, 4, 5]
    private var indexBuffer: MTLBuffer?
    
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
                colorAttachments.sourceAlphaBlendFactor = .sourceAlpha
                colorAttachments.destinationAlphaBlendFactor = .oneMinusSourceAlpha
                colorAttachments.rgbBlendOperation = .add
                colorAttachments.isBlendingEnabled = true
            }
            
            let depthStencilDesc = MTLDepthStencilDescriptor()
            depthStencilDesc.depthCompareFunction = .never
            depthStencilDesc.isDepthWriteEnabled = false
            
            
            self.indexBuffer = device.makeBuffer(bytes: &self.indices, length: 6 * MemoryLayout<UInt32>.stride, options: [])
            
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
        
        if let rps = self.renderPipelineState, let dss = self.depthStencilState, let ib = self.indexBuffer {
            self.uniform.mvp = camera.modelViewProjection
            
			let rect = camera.getVisibleRectangle().toMercator()
            self.vertices = [
                float2(Float(rect.bottomRight.X * MapTileConstants.FACTOR), Float(rect.bottomRight.Y * MapTileConstants.FACTOR)),
                float2(Float(rect.topRight.X * MapTileConstants.FACTOR), Float(rect.topRight.Y * MapTileConstants.FACTOR)),
                float2(Float(rect.topLeft.X * MapTileConstants.FACTOR), Float(rect.topLeft.Y * MapTileConstants.FACTOR)),
                float2(Float(rect.topLeft.X * MapTileConstants.FACTOR), Float(rect.topLeft.Y * MapTileConstants.FACTOR)),
                float2(Float(rect.bottomLeft.X * MapTileConstants.FACTOR), Float(rect.bottomLeft.Y * MapTileConstants.FACTOR)),
                float2(Float(rect.bottomRight.X * MapTileConstants.FACTOR), Float(rect.bottomRight.Y * MapTileConstants.FACTOR)),
            ]
            
            commandEncoder.setCullMode(.none)
            
            
            commandEncoder.setRenderPipelineState(rps)
            commandEncoder.setDepthStencilState(dss)
                                            
            
            commandEncoder.setVertexBytes(&self.vertices, length: 6 * MemoryLayout<float2>.stride, index: 0)
            commandEncoder.setVertexBytes(&self.uniform, length: MemoryLayout<Uniform>.stride, index: 1)
            commandEncoder.setFragmentBytes(&self.uniform, length: MemoryLayout<Uniform>.stride, index: 1)
            
            commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: 6, indexType: .uint32,
                                                 indexBuffer: ib, indexBufferOffset: 0)
            
        }
    }
}

