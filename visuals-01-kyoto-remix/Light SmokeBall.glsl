/*{
 "CREDIT": "Mixvibes",
 "DESCRIPTION": "Smokey ball bouncing to the bpm",
 "INPUTS": [
 {
 "NAME": "Zoom",
 "TYPE": "float",
 "DEFAULT": 2.,
 "MIN": 0.0,
 "MAX": 3.0
 },
 {
 "NAME": "Shift",
 "TYPE": "float",
 "DEFAULT": 0.5,
 "MIN": 0.0,
 "MAX": 1.0
 },
 {
 "NAME": "Size",
 "TYPE": "float",
 "DEFAULT": 1.0,
 "MIN": 1.0,
 "MAX": 2.0
 },
 {
 "NAME": "Glow",
 "TYPE": "float",
 "DEFAULT": 0.0,
 "MIN": 0.0,
 "MAX": 1.0
 }
 ]
 }*/

#pragma autoreload;
#pragma shadertoy;// Using shadertoy's formalism for non-specific uniforms

#define PI 3.1415926
#define bpm 16.*PI*cycleClock


/*UNIFORMS*/
uniform float   cycleClock; // Specific to remixvideo
uniform float   barClock; // Specific to remixvideo

/*METHODS*/

/** @brief              2D Rotation matrix. Apply the transformation on a vec2 by multiplying by this matrix
 *  @param angle        Angle of the rotation (rad)
 */
mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

/** @brief          Random function
 *  @param st       2D seed
 *  @return         Random float number
 *  @see            https://thebookofshaders.com/10/
 */
float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
                 43758.5453123);
}

/** @brief          Noise function based on Morgan McGuire method
 *  @param st       2D seed
 *  @return         Float value for the noise
 *  @see            https://thebookofshaders.com/11/
 */
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    
    return mix(a, b, u.x) +
    (c - a)* u.y * (1.0 - u.x) +
    (d - b) * u.x * u.y;
}

//Define number of octaves for the fbm function
#define OCTAVES 6

/** @brief          Fractal brownian motion. Type of noise.
 *  @param st       2D seed
 *  @return         Float value for the fbm
 *  @see            https://thebookofshaders.com/13/
 */
float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;//0.1*noise(vec2(.1*iGlobalTime));
    float amplitud = .6+.1*sin(iGlobalTime);
    float frequency = 0.;
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitud*noise(st);
        st *= 2.;
        amplitud *= .5;
    }
    return value;
}

/** @brief  Entry point
 */
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
    vec2 uv = -1.+2.*fragCoord.xy / iResolution.xy;
    uv.x *= iResolution.x/iResolution.y;
    
    float radius = length(uv)*2.0;
    float angle = atan(uv.y,uv.x);
    
    vec3 color = vec3(0.);
    
    uv *=Zoom;
    
    float r = 1.-smoothstep(noise(uv+Shift),noise(sin(uv+iGlobalTime))+Size,radius+.2*abs(sin(bpm)));
    float g = 1.-smoothstep(noise(uv+2.*Shift),noise(sin(uv+iGlobalTime))+Size,radius+.2*abs(sin(bpm)));
    float b = 1.-smoothstep(noise(uv),noise(sin(uv+iGlobalTime)*cos(uv.x))+Size,radius+.2*abs(sin(bpm)));

    
    color = vec3(r,g,b);
    color = mix(color,(color*color*2.),Glow);

    
    
    fragColor = vec4(color,1.);
    
}