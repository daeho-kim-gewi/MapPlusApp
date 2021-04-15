//
//  Animatable.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 19.03.21.
//

import Foundation
import MapTiles

public protocol Interpolatable: Numeric {
    static func interpolate(t: Double, a: Self, b: Self) -> Self
}

extension Float: Interpolatable {
    public static func interpolate(t: Double, a: Float, b: Float) -> Float {
        return Float(Double(a) + t * Double(b - a))
    }
}

extension Double: Interpolatable {
    public static func interpolate(t: Double, a: Double, b: Double) -> Double {
        return a + t * (b - a)
    }
}


public protocol Animatable {
    associatedtype T: Interpolatable
    
    var start: Date { get set }
    var duration: TimeInterval { get set }
    var fromValue: T { get set }
    var toValue: T { get set }
    
}


fileprivate func clamp(_ v: Double, min vmi: Double, max vma: Double) -> Double {
    return max(min(v, vma), vmi)
}

public extension Animatable {
    func current() -> T {
        let diff = abs(start.distance(to: Date()))
        let t = clamp(Double(diff) / Double(duration), min: 0.0, max: 1.0)
        return T.interpolate(t: t, a: fromValue, b: toValue)
    }
    
    func isEnded() -> Bool {
        let now = Date()
        let diff = now.distance(to: start)
        return diff > duration
    }
    
}

public class Animation {
    
    public func animate(camera: MapCameraState) -> MapCameraState {
        return camera 
    }
    
    public func isCompleted() -> Bool {
        return true
    }
}

public class GeoPositionAnimation: Animation {
    public typealias T = GeoPosition
    
    public init(from: GeoPosition, to: GeoPosition, duration: Double = 0.5, start: Date = Date()) {
        self.start = start
        self.fromValue = from
        self.toValue = to
        self.duration = duration
    }
    
    public override func animate(camera: MapCameraState) -> MapCameraState {
        
        let diff = abs(start.distance(to: Date()))
        let t = clamp(Double(diff) / Double(duration), min: 0.0, max: 1.0)
        let pos = interpolate(t: t, a: self.fromValue, b: self.toValue)
        
        camera.position = pos
        return camera
    }
    
    public override func isCompleted() -> Bool {
        let now = Date()
        let diff = now.distance(to: start)
        return diff > duration
    }
    
    private func interpolate(t: Double, a: GeoPosition, b: GeoPosition) -> GeoPosition {
        let xx = a.X + t * (b.X - a.X)
        let yy = a.Y + t * (b.Y - a.Y)
        
        return GeoPosition(x: xx, y: yy)
    }
    
    public var start: Date
    public var duration: TimeInterval
    public var fromValue: GeoPosition
    public var toValue: GeoPosition
}

public class DoubleValueAnimation: Animation, Animatable {
    public typealias T = Double
    
    public init(from: Double, to: Double, duration: Double = 0.5, start: Date = Date()) {
        self.start = start
        self.fromValue = from
        self.toValue = to
        self.duration = duration
    }
    
    
    public var start: Date
    public var duration: TimeInterval
    public var fromValue: Double
    public var toValue: Double
}

public class CameraDistanceValueAnimation: Animation, Animatable {
    public typealias T = Float
    
    public init(from: Float, to: Float, duration: Double = 0.5, start: Date = Date()) {
        self.start = start
        self.fromValue = from
        self.toValue = to
        self.duration = duration
    }
    
    public override func animate(camera: MapCameraState) -> MapCameraState {
        let c = self.current()
        camera.cameraDistance = c
        return camera
    }
    
    public override func isCompleted() -> Bool {
        return self.isEnded()
    }
    
    public var start: Date
    public var duration: TimeInterval
    public var fromValue: Float
    public var toValue: Float
}
