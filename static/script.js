import init, { Universe } from './game_of_life.js';

// Get the canvas element
const canvas = document.getElementById('game-of-life-canvas');
const ctx = canvas.getContext('2d');

// Set the canvas dimensions
const width = 800;
const height = 600;
canvas.width = width;
canvas.height = height;

let universe;

// Render the universe
function renderUniverse() {
    ctx.clearRect(0, 0, width, height);

    const cellsPtr = universe.cells();
    const cells = new Uint8Array(universe.cells.buffer, cellsPtr, width * height);

    ctx.beginPath();
    for (let row = 0; row < height; row++) {
        for (let col = 0; col < width; col++) {
            const idx = row * width + col;
            if (cells[idx] === 1) {
                ctx.fillRect(col, row, 1, 1);
            }
        }
    }
    ctx.stroke();
}

// Animation loop
function animate() {
    universe.tick();
    renderUniverse();
    requestAnimationFrame(animate);
}

// Initialize the WebAssembly module and start the animation
async function main() {
    await init();

    // Initialize the universe
    universe = Universe.new(width, height);

    // Start the animation
    requestAnimationFrame(animate);
}

main();

