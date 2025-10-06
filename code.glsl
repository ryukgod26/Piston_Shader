vec3 palette( in float t )
{

    vec3 a = vec3(0.520, 0.608, 0.608);
    vec3 b = vec3(0.219, 0.478, 0.480);
    vec3 c = vec3(0.750, 0.539, -1.929);
    vec3 d = vec3(-1.372, -1.038, -0.705);


    return a + b*cos( 6.283185*(c*t+d) );
}

float piston(vec2 p, float width , float height){
p.x = abs(p.x) - width;
p.y -= height;
return length(max(p,0.0)) + min(0.0,max(p.x,p.y));

}

float scene(vec2 p){

float center = floor(p.x) + .5;
p.x = fract(p.x) - 0.5;

float height = sin(iTime+center)*2.2;
float width = 0.3;

return piston(p,width,height);
}

vec3 shaderDistance(float d){
float dist = d*100.;
float banding = max(sin(dist),0.0);
float strength = sqrt(1. - exp(-abs(d)*2.));
float pattern = mix(strength,banding, (0.6-abs(strength-0.5))*0.3);

vec3 col = vec3(pattern);

col *= d > 0. ? vec3(1.0,0.56,0.4) : vec3(0.4,0.9,1.0);
col = palette(pattern);
return col;

}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord - .5*iResolution.xy) / iResolution.y;
    vec2 mouse = (iMouse.xy - .5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(0);
    uv *= 5.;
    mouse *= 5.;
    
    float mouseDist = scene(mouse);
    col = shaderDistance(scene(uv));
    
if (distance(mouse,uv) < abs(mouseDist) && iMouse.z >0.) col *= 0.5;
   // float d = length(uv);
    //uv= fract(uv);
    //vec3 col = palette(mouseDist);
    
    fragColor = vec4(col,1.0);
}
