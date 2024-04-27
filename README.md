# Webserver using WASM + Actix


This is a very messy example i threw together.

## instructions on how to get this to run/ compile it yourself:
The webserver itself is extremely simple. just servers the index.html from the static Dir.
to get this to run, you can either use `cargo run`, or `nix run`.
to quickly get into a dev enviroment, use `nix develop`


## wasm part
the wasm code i struggled packaging with nix, but i will update this if i get it working.
using nix:
cd to `wasm`
run `nix develop`
cd to `wasm/app` (ill consolidate these directories into one)
and use `wasm-pack build --target web`
then `cp pkg/* ../../static/`

It's not pretty but it works.



