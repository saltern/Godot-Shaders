//	Godot 4 Advanced Palette Shader (MultiPal ver.)

shader_type canvas_item;
#pragma disable_preprocessor

uniform vec4		modulate: source_color = vec4(1.0);

group_uniforms		palette;
uniform sampler2D	paletteTexture: filter_nearest;
uniform float		paletteNumber: hint_range(-1, 100, 1);

group_uniforms		cycling;
uniform int			cycleMode: hint_range(0, 2, 1);
uniform float		cycleRate: hint_range(-120, 120, 1);
uniform float		cycleOffset: hint_range(0, 256, 0.01);
uniform bool		colorBlending;

vec4 applyPalette(vec4 sprTex)
{	// Palette data
	ivec2	palSize	 = textureSize(paletteTexture, 0);
	
	// Color channel data
	float idxPalette = floor(sprTex.r * 256.00);	// Color index
	float idxCycEnds = floor(sprTex.g * 256.00);	// Color cycle end index
	float idxCycLeng = floor(sprTex.b * 256.00);	// Color cycle length
	
	// Cycling
	float idxCycle	 = cycleOffset + TIME * cycleRate;	// Cycle frame
	float idxCycNext = idxPalette;
	
	// Ignore index #0
	if (idxPalette > 0.0)
	{
		switch (cycleMode)
		{
			case 1:		// Localized color cycling
				if (idxCycEnds * idxCycLeng > 0.0)
				{
					idxPalette = floor(idxPalette + mod(idxCycle, idxCycLeng));
					idxCycNext = idxPalette + 1.0;
					
					// Wrap indices around if they exceed end of cycle
					if (idxPalette > idxCycEnds)
						idxPalette -= idxCycLeng;

					if (idxCycNext > idxCycEnds)
						idxCycNext -= idxCycLeng;
				}
				break;

			case 2:		// Palette-wide color cycling
				idxPalette = floor(idxPalette + idxCycle);
				idxCycNext = idxPalette + 1.0;
				
				
				
				break;
		}
		// Wrap indices back within palette bounds, skipping index 0
		idxPalette = mod(idxPalette - 1.0, float(palSize.x - 1)) + 1.0;
		idxCycNext = mod(idxCycNext - 1.0, float(palSize.x - 1)) + 1.0;
	}
	
	// Multiple palettes
	float palAdd = mod(floor(paletteNumber), float(palSize.y));
	
	// Sample palette from center of pixel (maximum result accuracy)
	float xUV = idxPalette / float(palSize.x) + (0.5 / float(palSize.x));
	float yUV = palAdd / float(palSize.y) + (0.5 / float(palSize.y));
	vec2 palUV = vec2(xUV, yUV);
	
	if (!colorBlending)
	{
		// Unblended result
		return texture(paletteTexture, palUV);
	}
	else
	{
		// Next cycle step sampler UV
		float nyxUV = idxCycNext / float(palSize.x);
		
		// Center next index sampler
		float nxUV = idxCycNext / float(palSize.x) + (0.5 / float(palSize.x));
		float nyUV = palAdd / float(palSize.y) + (0.5 / float(palSize.y));
		vec2 nxtUV = vec2(nxUV, nyUV);
		
		// Blend result
		vec4 pixel	= texture(paletteTexture, palUV);
		vec4 next	= texture(paletteTexture, nxtUV);
		return mix(pixel, next, fract(idxCycle));
	}
}

void fragment()
{
	if (paletteNumber > -1.0)
	{
		COLOR = applyPalette(texture(TEXTURE, UV)) * modulate;
	}
}