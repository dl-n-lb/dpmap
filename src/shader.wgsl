// Vert

struct VertexOutput {
    [[builtin(position)]] clip_position: vec4<f32>;
};

[[stage(vertex)]]
fn vs_main([[builtin(vertex_index)]] in_vertex_index: u32) -> VertexOutput
{
    var out: VertexOutput;
    let x = f32(1 - i32(in_vertex_index)) * 0.5;
    let y = f32(i32(in_vertex_index & 1u) * 2 - 1) * 0.5;
    out.clip_position = vec4<f32>(x, y, 0.0, 1.0);
    return out;
}


// Frag
[[stage(fragment)]]
fn fs_main([[builtin(position)]] coord: vec4<f32>) -> [[location(0)]] vec4<f32> {
    let c = coord.xy / vec2<f32>(800.0, 600.0);
    return vec4<f32>(c.xy, 0.0, 1.0);
}
