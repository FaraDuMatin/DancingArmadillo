// The uniform variable is set up in the javascript code and the same for all vertices
uniform vec3 remotePosition;
uniform float xoff;
uniform sampler2D fft;
uniform int time;

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

void main() {
    float fft_bass_raw = texture(fft, vec2(0.1, 0.0)).x;
    float fft_middle_raw = texture(fft, vec2(0.25, 0.0)).x;
    float fft_treble_raw = texture(fft, vec2(0.5, 0.0)).x;
    float fft_intensity = (fft_bass_raw + fft_middle_raw + fft_treble_raw);
    
 
    // Génération du bruit pour la déformation
    float angle = atan(position.z, position.x);
    vec2 noiseInput = vec2(angle * 2.0, position.y * 3.0);
    float noiseValue = rand(noiseInput);
    


    // Déformation basé sur la musique ou le temps
    float displacement;
    if (fft_intensity > 0.1) {
        displacement = 1.0 + noiseValue * fft_intensity;
    } else {
        float intensity = (time % 2 == 0) ? 1.0 : 0.0;
        displacement = 1.0 + noiseValue * intensity;
    }
    

    vec3 displacedPosition = position * displacement;
    vec3 finalPosition = displacedPosition + vec3(xoff, remotePosition.y, 0.0);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(finalPosition, 1.0);
}
