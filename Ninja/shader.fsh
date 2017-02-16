// Noise ---------------------------------------------------------------

// Hashing function, use sin instead of table with permutations
// n : Real value
float hash( float n )
{
    return fract(sin(n)*43758.5453123);
}

// Noise
// x : Point in space
float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f*f*(3.0-2.0*f);
    
    float n = p.x + p.y*157.0 + 113.0*p.z;
    return mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                   mix( hash(n+157.0), hash(n+158.0),f.x),f.y),
               mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                   mix( hash(n+270.0), hash(n+271.0),f.x),f.y),f.z);
}

// Rotation ------------------------------------------------------------

// Rotation around y axis
// v : Vector
// a : Angle
vec3 rotate(in vec3 v,in float a)
{
    return vec3(v.x*cos(a)+v.z*sin(a),v.y,-v.x*sin(a)+v.z*cos(a));
}

// Textures ------------------------------------------------------------

const vec3 blue=vec3(0.05,0.35,0.65);
const vec3 green=vec3(0.15,0.95,0.75);

// Checker
// p : Point on object
// n : Normal at point
vec3 checker(in vec3 p,in vec3 n)
{
    float v=mod(floor(p.x)+floor(p.y)+floor(p.z),2.0);
    return mix(blue,green,v);
}

// Turbulence
// p : Point
// n : Normal
float turbulence(in vec3 p,in vec3 n)
{
    // Add scaled noises
    float t=noise(p);
    t+=0.25*noise(2.0*p);
    t+=0.125*noise(5.0*p);
    t+=0.025*noise(13.0*p);
    // Scale
    t/=(1.0+0.25+0.125+0.025);
    return t;
}

// Turbulence with color
vec3 scaled(in vec3 p,in vec3 n)
{
    // Add scaled noises
    float t=turbulence(p,n);
    
    return mix(blue,green,t);
}

// Marble
// p : Point
// n : Normal
vec3 marble(in vec3 p,in vec3 n)
{
    // Add scaled noises
    float t=turbulence (7.0*p,n);
    t=1.0-pow((1.0-t*t),4.0);
    t=0.5+abs(t-0.5);
    t=1.0-pow((1.0-t*t),2.0);
    return mix(blue,green,t);
}

// Warped checker
// p : Point
// n : Normal
// a : amount of warping
vec3 warped(in vec3 p,in vec3 n,in float a)
{
    return checker(p+a*noise(2.0*p),n);
}

// Color wood
vec3 wood(in vec3 p,in vec3 n)
{
    
    vec3 ret;
    vec3 pa=p-vec3(1.0,1.0,1.0);
    pa = pa + noise(0.4*p);
    float d = sqrt((p.y*p.y)+(p.z*p.z));
    float v = 0.3*(1.0 + cos(2.0*(d + pa.x)));
    ret = mix(vec3(0.4,0.2,0.0),vec3(0.65,0.35,0.0),1.3*v);
    return ret;
}
// Objects --------------------------------------------------------------

// Intersection between a ray and a sphere
// o : Ray origin
// d : Ray direction
// c : Center of sphere
// r : Radius
// t : Intersection depth
// n : Normal at intersection point
bool sphere(in vec3 o,in vec3 d,in vec3 c,in float r,out float t,out vec3 n)
{
    vec3 oc = o-c;
    
    float b=dot(d,oc);
    float k = dot(oc,oc)-r*r;
    t=b*b-k;
    
    if (t<=0.0) return false;
    
    t=-b-sqrt(t);
    if (t<0.0) return false;
    
    // Normal
    n=(o+t*d-c)/r;
    
    return true;
}

// Lighting -------------------------------------------------------------

// Background color
// r : Ray direction
vec3 background(in vec3 r)
{
    return mix(vec3(0.2, 0.3, 0.4), vec3(0.7, 0.8, 1.0), r.y*0.5+0.5);
}

// p : Point on object
// n : normal at point
vec3 shade(in vec3 p,in vec3 n)
{
    // Point light
    const vec3 lightPos = vec3(1.0, 1.0,-5.0);
    const vec3 lightColor = vec3(0.95, 0.95,0.95);
    
    vec3 l = normalize(lightPos - p);
    
    // Not even Phong shading, use weighted cosine instead for smooth transitions
    float diff = 0.5*(1.0+dot(n, l));
    
    // Change call to Texture there : apply either color() or sine() or checker() or whatever texture you wish
    vec3 c = 0.2*background(n)+1.5*wood(25.0*p,n)*diff*lightColor;
    
    return c;
}

// Vignetting
// c : Color
// p : Point in screen space
vec4 Vignetting(in vec4 c,in vec2 p)
{
    return c * ( 0.5 + 0.5*pow( (p.x+1.0)*(p.y+1.0)*(p.x-1.0)*(p.y-1.0), 0.1 ) );
}

// Main -----------------------------------------------------------------

void main( out vec4 gl_FragColor, in vec2 v_tex_coord )
{
    vec2 xy = -1.0 + 2.0*v_tex_coord.xy/u_sprite_size.xy;
    vec2 uv = xy * vec2(u_sprite_size.x/u_sprite_size.y, 1.0);
    
    // Ray origin and direction
    vec3 o = vec3(0.0, 0.0, -2.0);
    vec3 d = normalize(vec3(uv, 1.0));
    
    o=rotate(o,0.5*u_time);
    d=rotate(d,0.5*u_time);
    
    vec3 n;
    float t;
    
    // Default background color
    gl_FragColor=vec4(background(d),1.0);
    if (sphere(o, d, vec3(0.0, 0.0, 0.0), 1.2, t, n))
    {
        gl_FragColor = vec4( mix(background(d), shade(o+d*t,n), step(0.0, t)), 1.0 );
    }
    gl_FragColor=Vignetting(gl_FragColor,xy);
}
