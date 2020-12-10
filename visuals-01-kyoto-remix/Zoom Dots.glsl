/*{
 "CREDIT": "Mixvibes",
 "DESCRIPTION": "Zooming Dot Circles",
 "INPUTS": [
 {
 "NAME": "Palette",
 "TYPE": "float",
 "DEFAULT": 0.0,
 "MIN": 0.0,
 "MAX": 5.0
 },
 {
 "NAME": "Width",
 "TYPE": "float",
 "DEFAULT": 0.0,
 "MIN": 0.0,
 "MAX": 0.1
 },
 {
 "NAME": "Blink",
 "TYPE": "float",
 "DEFAULT": 0.0,
 "MIN": 0.0,
 "MAX": 1.0
 },
 {
 "NAME": "Rotate",
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
#define bpm 4.*PI*cycleClock

/*UNIFORMS*/
uniform float   barClock;
uniform float   cycleClock;

/** @brief      Draws a white circle at position pos, and of size size.
 *  @param uv   Space (contains the pixels coordinates of the screen)
 *  @param pos  Position of the center of the circle (Space must be mapped between -1 and 1).
 *  @param size Size of the square
 *  @return     The float value of each pixel of the screen. Will be 1. if the pixel is inside the circle, 0. if outside.
 */
float circle(vec2 uv, vec2 pos, float radius){
    return smoothstep(0.0,0.002,radius-length(uv + pos));
}

/** @brief              Draws a line circle at position pos, and of size size.
 *  @param uv           Space (contains the pixels coordinates of the screen)
 *  @param pos          Position of the center of the circle (Space must be mapped between -1 and 1).
 *  @param size         Size of the square
 *  @param thickness    Thickness of the line
 *  @return             The float value of each pixel of the screen. Will be 1. if the pixel is inside the circle line, 0. if outside.
 */
float circleContour(vec2 uv, vec2 pos, float radius){
    return circle(uv, pos, radius) - circle(uv, pos, radius-.01);
}

/** @brief          Matrix operation for a two dimensional rotation.
 *  @param angle    Rotation angle
 *  @return         The rotation matrix for a rotation operation with the given angle
 *  @see            https://thebookofshaders.com/08/
 */
mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

/** @brief  Entry point
 */
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
    vec2 uv = -1. + 2.*fragCoord.xy / iResolution.xy;// Remap the space to [-1;1]
    uv.y *= iResolution.y/iResolution.x;// Aspect ratio correction (y*y square)
    vec3 color = vec3(0.);// Default background color to black
    vec2 pos;
    vec3 col = vec3(1.);
    
    
    /*PARAMETERS*/
    //REMOVE WHEN IFS IS IMPLEMENTED
    /*  float palette = 2.;// Color parameter
     float displace = .35;
     float fragment=.8;*/
    float radius =.3;//*abs(sin(bpm));
    float animate = mix(1.,abs(sin(bpm)),Blink);
    float animate2 = mix(1.,abs(cos(bpm)),Blink);

    /*COLOR SELECTION*/
    
    vec3 A1 = mix(mix(mix(mix(mix(vec3(.90,.12,.33),vec3(.52,.26,.84),clamp(Palette,0.,1.)),vec3(.86,.35,.21),clamp(Palette-1.,0.,1.)),vec3(.76,.13,.75),clamp(Palette-2.,0.,1.)),vec3(.86,.25,.18),clamp(Palette-3.,0.,1.)),vec3(1.,1.,1.),clamp(Palette-4.,0.,1.));
    vec3 A2 = mix(mix(mix(mix(mix(vec3(.95,.80,.06),vec3(.15,.80,.41),clamp(Palette,0.,1.)),vec3(.91,.78,.18),clamp(Palette-1.,0.,1.)),vec3(.13,.77,.58),clamp(Palette-2.,0.,1.)),vec3(.26,.31,.53),clamp(Palette-3.,0.,1.)),vec3(1.,1.,1.),clamp(Palette-4.,0.,1.));
    vec3 A3 = mix(mix(mix(mix(mix(vec3(.26,.55,.88),vec3(.27,.79,.87),clamp(Palette,0.,1.)),vec3(.54,.78,.33),clamp(Palette-1.,0.,1.)),vec3(1.,.68,.0),clamp(Palette-2.,0.,1.)),vec3(1.,.87,.51),clamp(Palette-3.,0.,1.)),vec3(1.,1.,1.),clamp(Palette-4.,0.,1.));
    
    float r1 = 2.*fract(cycleClock);
    float r2 = 2.*fract(cycleClock+.25);
    float r3 = 2.*fract(cycleClock+.5);
    float r4 = 2.*fract(cycleClock+.75);
    
    for(float i=0.;i<18.;i+=2.){
        if(i==0.||i == 6.||i==12.){
            col = A1;
        }//if
        if(i==2.||i == 8.||i==14.){
            col = A2;
        }//if
        if(i==4.||i == 10.||i==16.){
            col = A3;
        }//if
        
        color+= circle(uv*rotate2d(Rotate*-bpm), vec2(r1*cos(i*PI*.111),r1*sin(i*PI*.111)), .1*animate*r1+Width)*col;
        color+= circle(uv*rotate2d(Rotate*bpm+PI*.5), vec2(r2*cos(i*PI*.111),r2*sin(i*PI*.111)), .1*animate2*r2)*col;
        color+= circle(uv*rotate2d(Rotate*-bpm+PI), vec2(r3*cos(i*PI*.111),r3*sin(i*PI*.111)), .1*animate*r3+Width)*col;
        color+= circle(uv*rotate2d(Rotate*bpm+1.5*PI), vec2(r4*cos(i*PI*.111),r4*sin(i*PI*.111)), .1*animate2*r4)*col;

        
    }// for
    fragColor = vec4(color,1.0);
    
}