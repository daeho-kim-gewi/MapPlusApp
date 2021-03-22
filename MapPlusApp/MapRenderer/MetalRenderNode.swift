//
//  MetalRenderNode.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 02.03.21.
//

import Foundation
import Metal

protocol MetalRenderNode {
    
    func setup(device: MTLDevice)
    
    func render(for commandEncoder: MTLRenderCommandEncoder, device: MTLDevice,
                camera: MapCamera)
}
