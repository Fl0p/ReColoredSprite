#ifdef GL_ES
precision lowp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

uniform vec3 u_color1;
uniform vec3 u_color2;
uniform vec3 u_color3;

void main()
{
    //vec4 texColor = texture2D(u_texture, v_texCoord);
    //vec4 maskColor = texture2D(u_mask, v_texCoord);
    //vec4 finalColor = vec4(texColor.r, texColor.g, texColor.b, maskColor.a * texColor.a);
	//gl_FragColor = v_fragmentColor * finalColor;

    vec4 color = v_fragmentColor * texture2D(u_texture, v_texCoord);
    
	mat4 matrix = mat4(
	   u_color1.r, u_color1.g, u_color1.b, 0.0, // first column 
	   u_color2.r, u_color2.g, u_color2.b, 0.0, // second column 
	   u_color3.r, u_color3.g, u_color3.b, 0.0, // third column 
   	   0.0, 0.0, 0.0, 1.0  // adds column
	);
    
	gl_FragColor = matrix * color;
	//gl_FragColor = color;

}
