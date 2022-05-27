const pi: f32 = 3.14159265359879;

struct VertexOutput {
    [[builtin(position)]] clip_position: vec4<f32>;
};

// Vert
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

// Consts
const g: f32 = 9.806;
const m1: f32 = 1.0;
const m2: f32 = 1.0;
const l1: f32 = 1.0;
const l2: f32 = 1.0;

fn calc_w_dot(vec2<f32> theta, vec2<f32> w) {
    let w_dot = vec2<f32>(0);
    w_dot.x = -g*(2*m1 + m2) * sin(theta.x) - m2*g*sin(theta.x - 2*theta.y) - 2*sin(theta.x - theta.y)*m2*(w.y*w.y*l2 + w.x*w.x*l1*cos(theta.x - theta.y));
    w_dot.x = w_dot.x / (l1 * (2*m1 + m2 - m2*cos(2*theta.x - 2*theta.y)));
    w_dot.y = 2*sin(theta.x - theta.y)*(w.x*w.x*l1*(m1 + m2) + g(m1+m2)cos(theta.x)+w.y*w.y*l2*m2*cos(theta.x - theta.y));
    w_dot.y = w_dot.y / (l2 * (2*m1 + m2 - m2*cos(2*theta.x - 2*theta.y)));
}

fn iterate(vec2<f32> theta, vec2<f32> w) -> vec4<f32> {
    let step = 1.0;

    let w1 = w;
    let w_dot1 = calc_w_dot(theta, w);
    let w2 = w + 0.5 * step * w1;
    let w_dot2 = calc_w_dot(theta + 0.5 * step * w1, w + 0.5 * step * w_dot1);
    let w3 = w + 0.5 * step * w2;
    let w_dot3 = calc_w_dot(theta + 0.5 * step * w2, w + 0.5 * step * w_dot2);
    let w4 = w + step * w3;
    let w_dot4 = calc_w_dot(theta + step * w3, w + step * w_dot3);

    let theta_new = theta + (step / 6.0) * (w1 + 2*w2 + 2*w3 + w4);
    let w_new = w + (step / 6.0) * (w_dot1 + 2*w_dot2 + 2*w_dot3 + w_dot4);

    return vec4<f32>(theta_new, w_new);
}

[[stage(fragment)]]
fn fs_main([[builtin(position)]] coord: vec4<f32>) -> [[location(0)]] vec4<f32> {
    // c ~ 0, 1
    let c = coord.xy / vec2<f32>(800.0, 600.0);
    // theta ~ -pi, pi




    return vec4<f32>(c.xy, 0.0, 1.0);
}
