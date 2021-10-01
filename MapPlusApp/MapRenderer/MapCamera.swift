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
import SwiftUI

public class MapCameraState {
    public var cameraDistance: Float = 100.0
    public var position: GeoPosition = GeoPosition(x: 12.1, y: 52.0).toMercator()
    public var rotation: simd_quatf = simd_quatf(angle: 0.0, axis: float3.zAxis)
}


public class MapCamera: ObservableObject {
    @Published public var cameraState: MapCameraState = MapCameraState()
    private let fovDegrees: Double = 70
    // viewport size as native resolution in physical pixels!!
    private var viewportSize: CGSize = CGSize(width: 2.0, height: 1.0)
    private let near: Float = 0.01
    private let cameraDistanceRange = 0.012...200.0

    private var animations = [Animation]()
    
    public init() {    }
    
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
         
            let scale = Double(UIScreen.main.nativeScale)
            let dx = Double(mp1.x - mp2.x) / MapTileConstants.FACTOR * scale
            let dy = Double(mp1.y - mp2.y) / MapTileConstants.FACTOR * scale
            
            self.cameraState.position = GeoPosition(x: self.cameraState.position.X - dx,
                                                    y: self.cameraState.position.Y - dy)
            
        }
    }
    
    private func scaleFocusDistance(_ fac: Float, _ location: float3) {
        let dist = cameraState.cameraDistance * fac
        
//        if cameraDistanceRange.contains(Double(dist)) {
//            animations.append(CameraDistanceAnimation(from: cameraState.cameraDistance,
//                                                  to: dist,
//                                                  duration: 0.5, start: Date()))
        
        let scale = Double(UIScreen.main.nativeScale)
        let x: Double = (self.cameraState.position.X + Double(location.x)) / MapTileConstants.FACTOR * scale
        let y: Double = (self.cameraState.position.Y + Double(location.y)) / MapTileConstants.FACTOR * scale

//        let x: Double = self.cameraState.position.X / MapTileConstants.FACTOR * scale
//        let y: Double = self.cameraState.position.Y / MapTileConstants.FACTOR * scale
        
        
        
        // from old CameraPosition to new CameraPosition
        // how to get Pure New Position?
        if cameraDistanceRange.contains(Double(dist)) {
            animations.append(CameraFocusAnimation(from: cameraState.cameraDistance, to: dist,
                                                   fromLocation: cameraState.position,
                                                   toLocation: GeoPosition(x: x, y: y),
                                                   duration: 0.5, start: Date()))
        
        } else {
            print(self.cameraState.cameraDistance)
        }
    }
    
    public func zoomIn(_ location: CGPoint) {
        if let location = self.unproject(point: location) {
            scaleFocusDistance(0.5, location)
        }
    }
    
    public func zoomOut(_ location: CGPoint) {
        if let center = self.unproject(point: location) {
            scaleFocusDistance(2.0, center)
        }
    }
    
    private func scaleDistance(_ fac: Float) {
        let dist = cameraState.cameraDistance * fac
        if cameraDistanceRange.contains(Double(dist)) {
            animations.append(CameraDistanceAnimation(from: cameraState.cameraDistance,
                                                  to: dist, duration: 0.5, start: Date()))
        } else {
            print(self.cameraState.cameraDistance)
        }
    }
    
    public func zoomIn() {
        scaleDistance(0.5)
    }
    
    public func zoomOut() {
        scaleDistance(2.0)
    }
        
    public func pinchLocation(_ location: CGPoint) {
        
    }
    
    private func clamp(_ p: GeoPosition) -> GeoPosition {
        let x = max(min(p.X, 180.0), -180.0)
        let y = max(min(p.Y, 90.0), -90.0)
        
        return GeoPosition(x: x, y: y)
    }
    
    private func toWGS84Position(_ p: float3?) -> GeoPosition {
        var x: Double = 0.0
        var y: Double = 0.0
        
        if p != nil {
            x = Double(p!.x) / MapTileConstants.FACTOR
            y = Double(p!.y) / MapTileConstants.FACTOR
        }

        return clamp(GeoPosition(x: x, y: y).toWGS84())
    }
    
    private func getViewCorners() -> [GeoPosition] {
        let p1 = toWGS84Position(self.unproject(point: CGPoint(x: 0.0,
                                                               y: 0.0)))
        let p2 = toWGS84Position(self.unproject(point: CGPoint(x: Double(self.viewportSize.width),
                                                               y: 0.0)))
        let p3 = toWGS84Position(self.unproject(point: CGPoint(x: 0.0,
                                                               y: Double(self.viewportSize.height))))
        let p4 = toWGS84Position(self.unproject(point: CGPoint(x: Double(self.viewportSize.width),
                                                               y: Double(self.viewportSize.height))))
        
        return [p3, p4, p2, p1]
    }
    
    public func getVisibleRectangle() -> VMapTileRect {
        let corners = getViewCorners()
        let minX = corners.min{ $0.X < $1.X }!
        let maxX = corners.max{ $0.X < $1.X }!
        let minY = corners.min{ $0.Y < $1.Y }!
        let maxY = corners.max{ $0.Y < $1.Y }!
        
        return VMapTileRect(north: min(90.0, maxY.Y),
                            west: max(-180.0, minX.X),
                            south: max(-90.0, minY.Y),
                            east: min(180.0, maxX.X))
        
        
//        // get the currently visible rectangle of the map
//        let center = self.cameraState.position.toWGS84()
//        let fov = 0.5 * fovDegrees * Double.pi/180.0
//        let radius = Double(cameraState.cameraDistance) * tan(fov)
//
//        let north = min(center.Y + radius, 90.0)
//        let south = max(center.Y - radius, -90.0)
//        let east = min(center.X + radius, 180.0)
//        let west = max(center.X - radius, -180.0)
//
//        return VMapTileRect(north: north, west: west, south: south, east: east)
    }
    
    
    public func getMapTiles(tileManager: MapTileManager) -> [VMapTile] {
        let rect: VMapTileRect = getVisibleRectangle()
		
        return tileManager.getMapTiles(for: rect)
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
        return float4x4(eye: float3(0, 0, -Float(cameraState.cameraDistance)),
                        center: float3.zero, up: float3.yAxis)
        
    }
    
    var worldMatrix: float4x4 {
        let FAC: Float = Float(1.0/MapTileConstants.FACTOR)
        let scale = float4x4(scaling: float3(FAC, FAC, 1.0))
        
        let translate = float4x4(translation: float3(-Float(self.cameraState.position.X),
                                                     -Float(self.cameraState.position.Y), 0.0))
        let rotation = float4x4(self.cameraState.rotation)
        
        return translate * scale * rotation
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
        let inverseViewMatrix = self.viewMatrix.inverse
		let inverseWorldMatrix = self.worldMatrix.inverse
		
        var eyeRayDir = inverseProjectionMatrix * clipCoords
        eyeRayDir.z = -1
        eyeRayDir.w = 0
        
        var worldRayDir = (inverseViewMatrix * eyeRayDir).xyz
        worldRayDir = normalize(worldRayDir)
        
        let eyeRayOrigin = float4(x: 0, y: 0, z: 0, w: 1)
        let worldRayOrigin = (inverseViewMatrix * eyeRayOrigin).xyz
        
		let ray = inverseWorldMatrix * Ray(origin: worldRayOrigin, direction: worldRayDir)
        
        if let p = MapPlane().intersect(ray: ray) {
			return p
        }
        
        return nil
    }
    
}
