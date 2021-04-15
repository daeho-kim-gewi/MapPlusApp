//
//  TestNode.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 12.04.21.
//

import Foundation
import simd
import Metal
import MapTiles

fileprivate struct Uniform {
    var mvp: float4x4
    var color: float4
}

public class TestRenderNode: MetalRenderNode  {
    private var uniform: Uniform = Uniform(mvp: float4x4(scaling: float3.zero),
                                           color: float4(0, 0, 1.0, 1.0))
    
    private var renderPipelineState: MTLRenderPipelineState?
    private var depthStencilState: MTLDepthStencilState?

    private var vertexBuffer: MTLBuffer?
    private var vertexCount: Int = 4
    private var indicesBuffer: MTLBuffer?
    private var indexCount: Int = 6
    
    
    func setup(device: MTLDevice) {
        if let library = device.makeDefaultLibrary() {
            let vertexFunc = library.makeFunction(name: "areaFillVertex")
            let fragmentFunc = library.makeFunction(name: "areaFillFragment")
            
            let FAC: Float = Float(MapTileConstants.FACTOR)
            var vertices: [float2] = [
                float2(-180.0, 180.0) * FAC, // 0
                float2(-180.0, -180.0) * FAC, // 1
                float2(180.0, -180.0) * FAC,  // 2
                float2(180.0, 180.0) * FAC,    // 3
            ]
            
            var indices: [UInt16] = [
                0, 1, 3, 1, 2, 3
            ]
            
            
            self.vertexBuffer = device.makeBuffer(bytes: &vertices,
                                                  length: MemoryLayout<float2>.stride * vertices.count, options: [])
            
            self.indicesBuffer = device.makeBuffer(bytes: &indices,
                                                   length: MemoryLayout<UInt16>.stride * indices.count, options: [])
            
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
        
        if let rps = self.renderPipelineState, let dss = self.depthStencilState,
           let vb = self.vertexBuffer,
           let ib = self.indicesBuffer {
            self.uniform.mvp = camera.modelViewProjection
            
            commandEncoder.setRenderPipelineState(rps)
            commandEncoder.setDepthStencilState(dss)
         
            self.uniform.color = float4(0, 0, 1, 1)
                                                                
              
            commandEncoder.setVertexBuffer(vb, offset: 0, index: 0)
            commandEncoder.setVertexBytes(&self.uniform, length: MemoryLayout<Uniform>.stride, index: 1)
            commandEncoder.setFragmentBytes(&self.uniform, length: MemoryLayout<Uniform>.stride, index: 1)
                                    
                                    // draw each one
            commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.indexCount,
                                                                         indexType: .uint16, indexBuffer: ib,
                                                                         indexBufferOffset: 0)
        }
    }
}
