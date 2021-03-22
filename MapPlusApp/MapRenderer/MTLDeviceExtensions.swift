//
//  MTLDeviceExtensions.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 11.03.21.
//

import Foundation
import Metal
import MetalKit

public extension MTLDevice {
    
    func getTexture(from image: UIImage) -> MTLTexture? {
        
        let imageOptions: [MTKTextureLoader.Option : Any] = [
            MTKTextureLoader.Option.SRGB : true,
            MTKTextureLoader.Option.generateMipmaps : true,
            MTKTextureLoader.Option.origin : MTKTextureLoader.Origin.bottomLeft
        ]
        
        do {
            if let cgImage = image.cgImage {
                let textureLoader = MTKTextureLoader(device: self)
                return try textureLoader.newTexture(cgImage: cgImage, options: imageOptions)
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        return nil 
    }
    
}
