# Raymarching Godot

This is my attempt to create a
[Raymarching Renderer](http://jamie-wong.com/2016/07/15/ray-marching-signed-distance-functions/)
in Godot Game engine. I'm
using a fullscreen ColorRect node with a custom fragment shader.

This is more of a reference project for those of you interested in learning this amazing
rendering technique. I also have
[series of blog posts](http://cgmathprog.home.blog/2019/08/29/raymarching-from-scratch-part-0/) 
that cover raymarching in a greater detail.

This demo supports FPS style camera with WASD as movement keys and QE as up/down keys.
Press ESC to exit mouse capture mode. There is a slider on the left top corner to change the
FOV of camera.

You can navigate between tags to get code for each chapter in my tutorial.
For example, `git checkout part3-fov` will get you code for the final chapter in part3.


## Screenshots

![Screenshot](https://i.ibb.co/4TFsSjg/Godot-v3-1-1-stable-win64-39a-QBNrv-OR.png)

## Build

Clone this repository.

Download [Godot](https://godotengine.org/download) Game Engine (Standard version).

Run Godot and import this project

That's it! Just run it in editor or export to the platform of your choise.
