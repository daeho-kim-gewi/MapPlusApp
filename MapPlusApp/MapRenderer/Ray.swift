//
//  Ray.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 17.03.21.
//

import Foundation
import simd

public struct Ray {
    var origin: float3
    var direction: float3
	
	public static func *(transform: float4x4, ray: Ray) -> Ray {
		let originT = (transform * float4(ray.origin, 1)).xyz
		let directionT = (transform * float4(ray.direction, 0)).xyz
		return Ray(origin: originT, direction: directionT)
	}
	
}
