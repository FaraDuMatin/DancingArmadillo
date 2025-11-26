// Create shared variable. The value is given as the interpolation between normals computed in the vertex shader
in vec3 interpolatedNormal;
/* HINT: YOU WILL NEED A DIFFERENT SHARED VARIABLE TO COLOR ACCORDING TO POSITION OF REMOTE */
uniform sampler2D fft;
in vec3 vPosition;
uniform vec3 remotePosition0;
uniform vec3 remotePosition1;
uniform vec3 remotePosition2;


void main() {
	float fft_middle_raw = texture(fft, vec2(0.25, 0.0)).x;
	float fft_treble_raw = texture(fft, vec2(0.5, 0.0)).x;
	
    float middleController = 0.1 + (remotePosition1.y / 4.0) * 1.8;
	float trebleController = 0.1 + (remotePosition2.y / 4.0) * 1.8;


	float fft_middle = fft_middle_raw * middleController;
	float fft_treble = fft_treble_raw * trebleController;





    vec3 baseColor = normalize(interpolatedNormal);
    baseColor.r += fft_middle;  
    baseColor.g -= fft_treble;  
    baseColor.b += (fft_middle + fft_treble);  


    // Les valeurs rgb en glsl sont entre 0 et 1
    baseColor = clamp(baseColor, 0.0, 1.0);
    gl_FragColor = vec4(baseColor, 1.0);
}
  
