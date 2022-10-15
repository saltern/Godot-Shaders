# Godot Engine Shaders Repository
A repository for custom Godot shaders, updated as I write new ones I think might be useful.

### Advanced Palette ###
A shader enabling the use of 256-color palettes, featuring color cycling with optional blending.
Has versions for Godot 3 and 4.

* Godot 3: AdvancedPalette_Godot3.gdshader
* Godot 4: AdvancedPalette_Godot4.gdshader

An alternative version is also provided, which allows for multiple palettes in a single PNG.

Key differences:

* Each row in a palette image file is now considered to be a separate palette.
* Parameter added: "Palette Number". Use it to select palettes from the provided file.
* Parameter removed: "Disable Processing". Replaced by setting "Palette Number" to -1.

To adapt pre-existing palette images, make sure all of the colors for a single palette are on the same row.
You can still swap out the image file for another with either single or multiple different palettes.
If you need to switch between palettes with different numbers of colors, you will have to either use different textures with the correct sizes, or repeat colors as necessary. Transparent pixels are still counted as colors in the palette!
Godot 3 and 4 files are provided for this variant as well.

* Godot 3: AdvancedMultiPal_Godot3.gdshader
* Godot 4: AdvancedMultiPal_Godot4.gdshader