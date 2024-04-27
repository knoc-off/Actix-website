use noise::{NoiseFn, Perlin};
use wasm_bindgen::prelude::*;
use web_sys::{CanvasRenderingContext2d, ImageData};
use wasm_bindgen::Clamped;

#[wasm_bindgen]
pub fn generate_noise(ctx: &CanvasRenderingContext2d, width: u32, height: u32, scale: f64) {
    let seed = (js_sys::Math::random() * 10000.0) as u32;
    let perlin = Perlin::new(seed);
    let mut data = Vec::new();

    for y in 0..height {
        for x in 0..width {
            let value = perlin.get([x as f64 / scale, y as f64 / scale]) as f32;
            let color = ((value + 1.0) * 128.0) as u8;
            data.push(color);
            data.push(color);
            data.push(color);
            data.push(255);
        }
    }

    let clamped_array = Clamped(data.as_slice());
    let image_data = ImageData::new_with_u8_clamped_array(clamped_array, width).unwrap();
    ctx.put_image_data(&image_data, 0.0, 0.0).unwrap();
}

