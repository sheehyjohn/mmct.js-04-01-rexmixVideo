/*{
 "CREDIT": "Mixvibes",
 "DESCRIPTION": "Two groups of four orbiting and bouncing dots around a central dot",
 "INPUTS": [
 {
 "NAME": "Palette",
 "TYPE": "float",
 "DEFAULT": 0.0,
 "MIN": 0.0,
 "MAX": 5.0
 },
 {
 "NAME": "Contour",
 "TYPE": "float",
 "DEFAULT": 1.0,
 "MIN": 0.1,
 "MAX": 1.0
 },
 {
 "NAME": "Movement",
 "TYPE": "float",
 "DEFAULT": 0.0,
 "MIN": 0.0,
 "MAX": 1.0
 },
 {
 "NAME": "Shape",
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
#define bpm 8.*PI*cycleClock

/*UNIFORMS*/

uniform float   cycleClock;
uniform float   barClock;

/*METHODS*/

float circle(vec2 uv, vec2 pos, float radius){
    return smoothstep(0.0,0.002,radius-length(uv + pos));
}

float circleContour(vec2 uv, vec2 pos, float radius, float thickness){
    return circle(uv, pos, radius) - circle(uv, pos, radius-thickness);
}

float square(vec2 uv, vec2 pos, float size){
    vec2 bl = step(vec2(1.-size),1.0+(uv+pos));
    float pct = bl.x * bl.y;
    vec2 tr = step(vec2(1.-size),1.0-(uv+pos));
    pct *= tr.x * tr.y;
    return pct;
}

float squareContour(vec2 uv, vec2 pos, float size, float thickness){
    return square(uv, pos, size)-square(uv, pos, size-thickness);
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

mat2 rotate2db(float _angle){
    return mat2(cos(_angle),-2.*sin(_angle),
                2.*sin(_angle),cos(_angle));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
    vec3 color = vec3(0.);
    
    /*COLOR SELECTION*/
    
    vec3 A1 = mix(mix(mix(mix(mix(vec3(.90,.12,.33),vec3(.52,.26,.84),clamp(Palette,0.,1.)),vec3(.86,.35,.21),clamp(Palette-1.,0.,1.)),vec3(.76,.13,.75),clamp(Palette-2.,0.,1.)),vec3(.86,.25,.18),clamp(Palette-3.,0.,1.)),vec3(1.,1.,1.),clamp(Palette-4.,0.,1.));
    vec3 A2 = mix(mix(mix(mix(mix(vec3(.95,.80,.06),vec3(.15,.80,.41),clamp(Palette,0.,1.)),vec3(.91,.78,.18),clamp(Palette-1.,0.,1.)),vec3(.13,.77,.58),clamp(Palette-2.,0.,1.)),vec3(.26,.31,.53),clamp(Palette-3.,0.,1.)),vec3(1.,1.,1.),clamp(Palette-4.,0.,1.));
    vec3 A3 = mix(mix(mix(mix(mix(vec3(.26,.55,.88),vec3(.27,.79,.87),clamp(Palette,0.,1.)),vec3(.54,.78,.33),clamp(Palette-1.,0.,1.)),vec3(1.,.68,.0),clamp(Palette-2.,0.,1.)),vec3(1.,.87,.51),clamp(Palette-3.,0.,1.)),vec3(1.,1.,1.),clamp(Palette-4.,0.,1.));
    
    vec2 uv = 1. - 2.*fragCoord.xy / iResolution.xy;
    uv.y *= iResolution.y/iResolution.x;
    vec3 col = vec3(1.);
    
    
    
    vec2 uvb = uv;
    uv*=rotate2d(iGlobalTime+Movement*sin(.5*bpm));
    uvb*=rotate2d(iGlobalTime+PI/4.+Movement*sin(.5*bpm));

    
    vec3 c1 = vec3(0.);
    vec3 c2 = vec3(0.);
    c1 +=circleContour(uv,vec2(+.2,-.2)*abs(sin(bpm+PI/2.)),.1,.1*Contour)*A1;
    c1 +=circleContour(uv,vec2(-.2,+.2)*abs(sin(bpm+PI/2.)),.1,.1*Contour)*A1;
    c1 +=circleContour(uv,vec2(+.2,+.2)*abs(sin(bpm+PI/2.)),.1,.1*Contour)*A1;
    c1 +=circleContour(uv,vec2(-.2,-.2)*abs(sin(bpm+PI/2.)),.1,.1*Contour)*A1;
    
    c1 +=circleContour(uvb,vec2(+.3,-.3)*abs(sin(bpm)),.075,.075*Contour)*A2;
    c1 +=circleContour(uvb,vec2(-.3,+.3)*abs(sin(bpm)),.075,.075*Contour)*A2;
    c1 +=circleContour(uvb,vec2(+.3,+.3)*abs(sin(bpm)),.075,.075*Contour)*A2;
    c1 +=circleContour(uvb,vec2(-.3,-.3)*abs(sin(bpm)),.075,.075*Contour)*A2;
    
    c2 +=circleContour(uv,vec2(+.2,-.2),.1+.1*abs(sin(1.5*bpm)),(.1+.1*abs(sin(1.5*bpm)))*Contour)*A1;
    c2 +=circleContour(uv,vec2(-.2,+.2),.1+.1*abs(sin(1.5*bpm)),(.1+.1*abs(sin(1.5*bpm)))*Contour)*A1;
    c2 +=circleContour(uv,vec2(+.2,+.2),.1+.1*abs(sin(1.5*bpm)),(.1+.1*abs(sin(1.5*bpm)))*Contour)*A1;
    c2 +=circleContour(uv,vec2(-.2,-.2),.1+.1*abs(sin(1.5*bpm)),(.1+.1*abs(sin(1.5*bpm)))*Contour)*A1;
    
    c2 +=circleContour(uvb,vec2(+.3,-.3),.075,.075*Contour)*A2;
    c2 +=circleContour(uvb,vec2(-.3,+.3),.075,.075*Contour)*A2;
    c2 +=circleContour(uvb,vec2(+.3,+.3),.075,.075*Contour)*A2;
    c2 +=circleContour(uvb,vec2(-.3,-.3),.075,.075*Contour)*A2;
    
    if(Shape > .5){
        color = mix(c1,c2,floor(2.*abs(sin(.5*bpm))));
    }else{
        color = c1;
    }
    
    color +=circleContour(uv,vec2(0.),.075,.075*Contour)*A3;
    //color *=circle(uv,vec2(0.),.1+.5*abs(sin(.5*bpm)));

    
    
    //color-= 1.*circle(uv,vec2(0.0),.35);
    // color-= 1.*circle(uv,vec2(0.0),.15);
    
    
    
    fragColor = vec4(color,1.0);
    
}