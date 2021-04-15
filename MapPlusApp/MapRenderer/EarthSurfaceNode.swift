//
//  EarthSurfaceNode.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 11.03.21.
//

import Foundation
import Metal
import simd
import MapTiles
import UIKit



fileprivate struct Vertex  {
    var position: float2
    var tex: float2
}


fileprivate struct Uniform {
    var mvp: float4x4
}


public class EarthSurfaceNode: MetalRenderNode  {
    private var uniform: Uniform = Uniform(mvp: float4x4(scaling: float3(1.0/180.0 * 3.0, 1.0/180.0, 1.0)))
    
    private var vertexBuffer: MTLBuffer?
    private var vertexCount: Int = 4
    private var indicesBuffer: MTLBuffer?
    private var indexCount: Int = 6
    private var texture: MTLTexture?
    private var renderPipelineState: MTLRenderPipelineState?
    private var depthStencilState: MTLDepthStencilState?
    
    func setup(device: MTLDevice) {
        let FAC: Float = Float(MapTileConstants.FACTOR)
        var vertices: [Vertex] = [
            Vertex(position: float2(-180.0, 90.0) * FAC, tex: float2(0, 1)), // 0
            Vertex(position: float2(-180.0, -90.0) * FAC, tex: float2(0, 0)),// 1
            Vertex(position: float2(180.0, -90.0) * FAC, tex: float2(1, 0)), // 2
            Vertex(position: float2(180.0, 90.0) * FAC, tex: float2(1, 1))   // 3
        ]
        
        var indices: [UInt16] = [
            0, 1, 3, 1, 2, 3
        ]
        
        self.texture = device.getTexture(from: UIImage(named: "Earth")!)
        
        self.vertexBuffer = device.makeBuffer(bytes: &vertices,
                                              length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
        
        self.indicesBuffer = device.makeBuffer(bytes: &indices,
                                               length: MemoryLayout<UInt16>.stride * indices.count, options: [])
        
        if let library = device.makeDefaultLibrary() {
            let vertexFunc = library.makeFunction(name: "earthVertex")
            let fragmentFunc = library.makeFunction(name: "earthFragment")
                         
            let rpld = MTLRenderPipelineDescriptor()
            rpld.vertexFunction = vertexFunc
            rpld.fragmentFunction = fragmentFunc
            rpld.depthAttachmentPixelFormat = .invalid
            
            if let colorAttachments = rpld.colorAttachments[0] {
                colorAttachments.pixelFormat = .bgra8Unorm
                colorAttachments.isBlendingEnabled = false
            }
          
            let depthStencilDesc = MTLDepthStencilDescriptor()
            depthStencilDesc.depthCompareFunction = .always
            depthStencilDesc.isDepthWriteEnabled = false

            self.depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDesc)
            
            do {
                try self.renderPipelineState = device.makeRenderPipelineState(descriptor: rpld)
            } catch let error {
                print("\(error)")
            }
        }
    }
    
    
    func render(for commandEncoder: MTLRenderCommandEncoder, device: MTLDevice, camera: MapCamera,
                tiles: [VMapTile], appearance: MapNetworkAppearance) {
        if let rps = self.renderPipelineState, let dss = self.depthStencilState,
           let vb = self.vertexBuffer, let ib = self.indicesBuffer,
           let tex = self.texture {
            
            self.uniform.mvp = camera.modelViewProjection
                        
            commandEncoder.setRenderPipelineState(rps)
            commandEncoder.setDepthStencilState(dss)
            
            // set vertexbuffer
            commandEncoder.setVertexBuffer(vb, offset: 0, index: 0)
            commandEncoder.setVertexBytes(&self.uniform, length: MemoryLayout<Uniform>.stride, index: 1)
            commandEncoder.setFragmentBytes(&self.uniform, length: MemoryLayout<Uniform>.stride, index: 1)
            commandEncoder.setFragmentTexture(tex, index: 0)
            
            commandEncoder.drawIndexedPrimitives(type: .triangle,
                                                 indexCount: self.indexCount,
                                                 indexType: .uint16,
                                                 indexBuffer: ib,
                                                 indexBufferOffset: 0)
        }
    }
    
}
