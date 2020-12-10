/*{
 "CREDIT": "Mixvibes",
 "DESCRIPTION": "Concentric dots growing with the history of the audio level",
 "INPUTS": [
 {
 "NAME": "Palette",
 "TYPE": "float",
 "DEFAULT": 0.0,
 "MIN": 0.0,
 "MAX": 5.0
 },
 {
 "NAME": "Bounce",
 "TYPE": "float",
 "DEFAULT": 0.0,
 "MIN": 0.0,
 "MAX": 1.0
 },
 {
 "NAME": "Lighting",
 "TYPE": "float",
 "DEFAULT": 0.0,
 "MIN": 0.0,
 "MAX": 1.0
 },
 {
 "NAME": "Contour",
 "TYPE": "float",
 "DEFAULT": 0.5,
 "MIN": 0.025,
 "MAX": 0.5
 }
 ]
 }*/

#pragma autoreload;
#pragma shadertoy;// Using shadertoy's formalism for non-specific uniforms

#define PI 3.1415926
#define bpm 4.*PI*cycleClock

uniform float   cycleClock;


float circle(vec2 uv, vec2 pos, float radius){
    return smoothstep(0.0,0.002,radius-length(uv + pos));
}

float circleContour(vec2 uv, vec2 pos, float radius, float thickness){
    return circle(uv, pos, radius) - circle(uv, pos, radius-thickness);
}
float circleContourGlow(vec2 uv, vec2 pos, float radius, float thickness){
    return smoothstep(-thickness,thickness,radius-length(uv + pos))-smoothstep(-thickness,thickness,radius-length(uv + pos)-.0025);
}

uniform float   audioLevelHistory[512];
uniform float   audioLevel;

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = -1. + 2.*fragCoord.xy / iResolution.xy;
    uv.y *= iResolution.y/iResolution.x;
    vec3 color = vec3(0.);
    
    vec3 A1 = mix(mix(mix(mix(mix(vec3(.90,.12,.33),vec3(.52,.26,.84),clamp(Palette,0.,1.)),vec3(.86,.35,.21),clamp(Palette-1.,0.,1.)),vec3(.76,.13,.75),clamp(Palette-2.,0.,1.)),vec3(.86,.25,.18),clamp(Palette-3.,0.,1.)),vec3(1.,1.,1.),clamp(Palette-4.,0.,1.));
    vec3 A2 = mix(mix(mix(mix(mix(vec3(.95,.80,.06),vec3(.15,.80,.41),clamp(Palette,0.,1.)),vec3(.91,.78,.18),clamp(Palette-1.,0.,1.)),vec3(.13,.77,.58),clamp(Palette-2.,0.,1.)),vec3(.26,.31,.53),clamp(Palette-3.,0.,1.)),vec3(1.,1.,1.),clamp(Palette-4.,0.,1.));
    vec3 A3 = mix(mix(mix(mix(mix(vec3(.26,.55,.88),vec3(.27,.79,.87),clamp(Palette,0.,1.)),vec3(.54,.78,.33),clamp(Palette-1.,0.,1.)),vec3(1.,.68,.0),clamp(Palette-2.,0.,1.)),vec3(1.,.87,.51),clamp(Palette-3.,0.,1.)),vec3(1.,1.,1.),clamp(Palette-4.,0.,1.));

    uv =abs(uv);


    float r = mix(1.,audioLevel,Bounce);
    float r1 =audioLevelHistory[511];
    float r2 =audioLevelHistory[509];
    float r3 =audioLevelHistory[507];
    float r4 =audioLevelHistory[505];

    
    
    
    color += vec3(circleContour(uv,vec2(0.,0.),0.1*r1,r1*Contour))*A1*mix(1.,r1,Lighting);

    color += vec3(circleContour(uv,vec2(cos(PI),sin(PI))*.25*r,0.1*r2,r2*Contour))*A2*mix(1.,r2,Lighting);
    color += vec3(circleContour(uv,vec2(cos(4.*PI/3.),sin(4.*PI/3.))*.25*r,0.1*r2,r2*Contour))*A2*mix(1.,r2,Lighting);
    
    color += vec3(circleContour(uv,vec2(cos(PI),sin(PI))*.5*r,0.1*r3,r3*Contour))*A3*mix(1.,r3,Lighting);
    color += vec3(circleContour(uv,vec2(cos(7.*PI/6.),sin(7.*PI/6.))*.5*r,0.1*r3,r3*Contour))*A3*mix(1.,r3,Lighting);
    color += vec3(circleContour(uv,vec2(cos(8.*PI/6.),sin(8.*PI/6.))*.5*r,0.1*r3,r3*Contour))*A3*mix(1.,r3,Lighting);
    color += vec3(circleContour(uv,vec2(cos(9.*PI/6.),sin(9.*PI/6.))*.5*r,0.1*r3,r3*Contour))*A3*mix(1.,r3,Lighting);

    color += vec3(circleContour(uv,vec2(cos(PI),sin(PI))*.8*r,0.1*r4,r4*Contour))*A1*mix(1.,r4,Lighting);
    color += vec3(circleContour(uv,vec2(cos(13.*PI/12.),sin(13.*PI/12.))*.8*r,0.1*r4,r4*Contour))*A1*mix(1.,r4,Lighting);
    color += vec3(circleContour(uv,vec2(cos(14.*PI/12.),sin(14.*PI/12.))*.8*r,0.1*r4,r4*Contour))*A1*mix(1.,r4,Lighting);
    color += vec3(circleContour(uv,vec2(cos(15.*PI/12.),sin(15.*PI/12.))*.8*r,0.1*r4,r4*Contour))*A1*mix(1.,r4,Lighting);
    color += vec3(circleContour(uv,vec2(cos(16.*PI/12.),sin(16.*PI/12.))*.8*r,0.1*r4,r4*Contour))*A1*mix(1.,r4,Lighting);
    color += vec3(circleContour(uv,vec2(cos(17.*PI/12.),sin(17.*PI/12.))*.8*r,0.1*r4,r4*Contour))*A1*mix(1.,r4,Lighting);
    color += vec3(circleContour(uv,vec2(cos(18.*PI/12.),sin(18.*PI/12.))*.8*r,0.1*r4,r4*Contour))*A1*mix(1.,r4,Lighting);

    
    
    
    fragColor = vec4(color,1.0);
    
}