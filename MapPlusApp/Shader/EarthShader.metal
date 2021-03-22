//
//  EarthShader.metal
//  MapPlusApp
//
//  Created by Daeho Kim on 11.03.21.
//

#include <metal_stdlib>
using namespace metal;


struct Vertex {
    float2 position;
    float2 tex;
};

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

struct Uniform {
    float4x4 mvp;
};

vertex VertexOut earthVertex(const device Vertex* vert [[buffer(0)]],
                          const device Uniform& uniform [[buffer(1)]],
                          unsigned int vid [[vertex_id]]) {
    
    VertexOut out;
    out.position = uniform.mvp * float4(vert[vid].position, 1.0, 1.0);
    out.uv = vert[vid].tex;
    
    return out;
};

fragment float4 earthFragment(VertexOut in [[stage_in]],
                                 const device Uniform& uniform [[buffer(1)]],
                                 texture2d<float> surface [[ texture(0)]]) {
    
    constexpr sampler sampler2D(coord::normalized,
                                filter::linear,
                                min_filter::linear,
                                mip_filter::linear,
                                mag_filter::linear,
                                address::clamp_to_edge);
    
    float2 uv = in.uv;
    float4 color = surface.sample(sampler2D, uv);
    
    return color;
};
