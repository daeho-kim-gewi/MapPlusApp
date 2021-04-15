//
//  AreaFillShader.metal
//  MapPlusApp
//
//  Created by Daeho Kim on 30.03.21.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float2 position;
};

struct Uniform {
    float4x4 mvp;
    float4 color;
};

vertex float4 areaFillVertex(const device Vertex* vert [[buffer(0)]],
                             const device Uniform& uniform [[buffer(1)]],
                             unsigned int vid [[vertex_id]]) {
    return uniform.mvp * float4(vert[vid].position, 1.0, 1.0);
};

fragment float4 areaFillFragment(float4 vc [[stage_in]],
                                 const device Uniform& uniform [[buffer(1)]]) {
    return uniform.color;
};


