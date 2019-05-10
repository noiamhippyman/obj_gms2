//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColor;

void main()
{
    gl_FragColor = v_vColor * texture2D( gm_BaseTexture, v_vTexcoord );
}
