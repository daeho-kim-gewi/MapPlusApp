//
//  MapPlane.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 17.03.21.
//

import Foundation
import simd

public struct MapPlane {
    private let origin = float3.zero
    private let normal = float3.zAxis

    // p0 = ray.origin, p1 = ray.direction, p_co = origin, p_no = normal
    public func intersect(ray: Ray) -> float3? {
        let u = simd_dot(self.normal, ray.direction)
        if u != 0.0 {
			let p = self.origin - ray.origin
			let t = simd_dot(p, self.normal) / u
			return ray.origin + ray.direction * t
			
//            let t = (simd_dot(self.normal, self.origin) - simd_dot(self.normal, ray.origin)) / u
//            return ray.origin + ray.direction * t
        }
       
        return nil
    }
    
    
}

