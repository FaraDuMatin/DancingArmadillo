// Create shared variable for the vertex and fragment shaders
out vec3 interpolatedNormal;
out vec3 vPosition;  
uniform int time;
uniform sampler2D fft;
uniform vec3 remotePosition0;
uniform vec3 remotePosition1;
uniform vec3 remotePosition2;


void main() {
    interpolatedNormal = normal;
	
	float fft_bass_raw = texture(fft, vec2(0.1, 0.0)).x;
	float fft_middle_raw = texture(fft, vec2(0.25, 0.0)).x;
	float fft_treble_raw = texture(fft, vec2(0.5, 0.0)).x;
	
	float bassController = 0.1 + (remotePosition0.y / 4.0) * 2.0;
	float middleController = 0.1 + (remotePosition1.y / 4.0) * 0.9;
	float trebleController = 0.1 + (remotePosition2.y / 4.0) * 0.9;
	
	float fft_bass = fft_bass_raw * bassController;
	float fft_middle = fft_middle_raw * middleController;
	float fft_treble = fft_treble_raw * trebleController;
	
	
	


	// Direction selon le temps
	float dir = (time % 2 == 0) ? 1.0 : -1.0;
	


	// Changement de hauteur selon fft_bass
    float liftY  = fft_bass * 0.5;
	// Changement de position latérale selon fft_bass et direction
	float shiftX = fft_bass * 2.0 * dir;
	// Changement de profondeur selon le temps
	float stepZ = (fft_bass == 0.0) ? 0.0 : (time % 3 == 0) ? 0.0 : (time % 3 == 1) ? 1.0 : (time % 3 == 2) ? -1.0 : 0.0;

	vec3 newPos;
	if(remotePosition0.y < 3.0){
		newPos = position + vec3(shiftX, liftY, stepZ);
	} 
	else {
		float rotationScale = 6.28318; 
		float angle = fft_bass * rotationScale * dir;
		
		mat3 rotationY = mat3(
			cos(angle), 0.0, sin(angle),
			0.0, 1.0, 0.0,
			-sin(angle), 0.0, cos(angle)
		);
		vec3 rotatedPos = rotationY * position;
		newPos = rotatedPos + vec3(shiftX, liftY, stepZ);
	}
    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPos, 1.0);

}
