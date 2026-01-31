@tool
extends TextureRect

var _noise : FastNoiseLite:
	get: return (texture as NoiseTexture2D).noise


@export var fractal_lacunarity : float:
	get: return _noise.fractal_lacunarity
	set(val): _noise.fractal_lacunarity = val

@export var fractal_gain : float:
	get: return _noise.fractal_gain
	set(val): _noise.fractal_gain = val


@export var cellular_jitter: float:
	get: return _noise.cellular_jitter
	set(val): _noise.cellular_jitter = val
