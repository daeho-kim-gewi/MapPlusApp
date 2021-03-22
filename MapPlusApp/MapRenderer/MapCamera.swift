//
//  MapCamera.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 11.03.21.
//

import Foundation
import simd
import MetalKit
import MapTiles

public class MapCameraState {
    public var cameraDistance: Float = 100.0
    public var position: GeoPosition = GeoPosition(x: 12.1, y: 52.0)
    public var rotation: simd_quatf = simd_quatf(angle: 0.0, axis: float3.zAxis)
}


public class MapCamera {
    
    private var cameraState: MapCameraState = MapCameraState()
    
    private let fovDegrees: Double = 70
    private var viewportSize: CGSize = CGSize(width: 2.0, height: 1.0)
    private let near: Float = 0.01
    
    private let cameraDistanceRange = 0.00001...200.0
    
    private var animations = [Animation]()
    
    public init() {
    }
    
    public func set(viewport: CGSize) {
        self.viewportSize = viewport
    }
    
    public func update() {
        for animation in self.animations {
            self.cameraState = animation.animate(camera: self.cameraState)
        }
        
        animations.removeAll(where: { $0.isCompleted() })
    }
    
    public func move(from p1: CGPoint, to p2: CGPoint) {
        if let mp1 = self.unproject(point: p1),
           let mp2 = self.unproject(point: p2) {
            
            let dx = Double(mp1.x - mp2.x)
            let dy = Double(mp1.y - mp2.y)
            
            self.cameraState.position = GeoPosition(x: self.cameraState.position.X - dx,
                                                    y: self.cameraState.position.Y - dy)
        }
    }
    
    private func scaleDistance(_ fac: Float) -> Bool {
        let dist = self.cameraState.cameraDistance * fac
        if cameraDistanceRange.contains(Double(dist)) {
            animations.append(CameraDistanceValueAnimation(from: self.cameraState.cameraDistance,
                                                  to: dist,
                                                  duration: 0.5, start: Date()))
            
            return true
        }
        return false
    }
    
    public func zoomIn(_ location: CGPoint) {
        if let center = self.unproject(point: location) {
            if scaleDistance(0.5) {
//                let centerPosition = GeoPosition(x: Double(center.x), y: Double(center.y))
//
//                animations.append(GeoPositionAnimation(from: self.cameraState.position,
//                                                      to: centerPosition,
//                                                      duration: 0.5, start: Date()))
            }
            
        }
    }
    
    public func zoomOut(_ location: CGPoint) {
        // location = center
        if let center = self.unproject(point: location) {
            if scaleDistance(2.0) {
//                let centerPosition = GeoPosition(x: Double(center.x), y: Double(center.y))
//
//                animations.append(GeoPositionAnimation(from: self.cameraState.position,
//                                                       to: centerPosition,
//                                                       duration: 0.5, start: Date()))
            }
        }
    }
    
    public func pinchLocation(_ location: CGPoint) {
        
    }
    
    public func pinchScaleBigger() {
        if self.cameraState.cameraDistance > 21 {
            self.cameraState.cameraDistance -= 1
        }
    }
    
    public func pinchScaleSmaller() {
        if self.cameraState.cameraDistance < 120 {
            self.cameraState.cameraDistance += 1
        }
    }
    
    var aspect: Float {
        Float(viewportSize.width/viewportSize.height)
    }
    
    var projectionMatrix: float4x4 {
        return float4x4(projectionFov: Float(fovDegrees * Constants.RAD),
                        near: near, far: cameraState.cameraDistance + 10.0,
                        aspect: aspect)
    }
    
    var viewMatrix: float4x4 {
        return float4x4(eye: float3(0, 0, -Float(self.cameraState.cameraDistance)),
                        center: float3.zero, up: float3.yAxis)
        
    }
    
    var worldMatrix: float4x4 {
        let translate = float4x4(translation: float3(-Float(self.cameraState.position.X),
                                                     -Float(self.cameraState.position.Y), 0.0))
        let rotation = float4x4(self.cameraState.rotation)
        
        return translate * rotation
    }
}

public extension MapCamera {
    
    var modelView: float4x4 {
        return self.viewMatrix * self.worldMatrix
    }
    
    var modelViewProjection: float4x4 {
        return self.projectionMatrix * self.viewMatrix * self.worldMatrix
    }
    
    var modelViewProjectionInverse: float4x4 {
        return self.modelViewProjection.inverse
    }
    
    func unproject(point p: CGPoint) -> float3? {
        
        let clipX = (2 * Float(p.x)) / Float(self.viewportSize.width) - 1
        let clipY = 1 - (2 * Float(p.y)) / Float(self.viewportSize.height)
        let clipCoords = float4(clipX, clipY, 0, 1)
        
        let inverseProjectionMatrix = self.projectionMatrix.inverse
        let inverseViewMatrix = self.modelView.inverse
        
        var eyeRayDir = inverseProjectionMatrix * clipCoords
        eyeRayDir.z = -1
        eyeRayDir.w = 0
        
        var worldRayDir = (inverseViewMatrix * eyeRayDir).xyz
        worldRayDir = normalize(worldRayDir)
        
        let eyeRayOrigin = float4(x: 0, y: 0, z: 0, w: 1)
        let worldRayOrigin = (inverseViewMatrix * eyeRayOrigin).xyz
        
        let ray = Ray(origin: worldRayOrigin, direction: worldRayDir)
        
        if let p = MapPlane().intersect(ray: ray) {
            return float3(p.x, p.y, p.z)
        }
        
        return nil
    }
    
}
