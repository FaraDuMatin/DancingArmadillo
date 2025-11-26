uniform int tvChannel;
uniform vec3 remotePosition;
uniform sampler2D fft;

void main() {
    float y = remotePosition.y;    
    int section = int(floor(y));   
    float t = fract(y);         

    vec3 color;

    switch (section) {
        case 0:
            // Rouge (1,0,0) → Jaune (1,1,0)
            color = mix(vec3(1,0,0), vec3(1,1,0), t);
            break;
        case 1:
            // Jaune (1,1,0) → Vert (0,1,0)
            color = mix(vec3(1,1,0), vec3(0,1,0), t);
            break;
        case 2:
            // Vert (0,1,0) → Cyan (0,1,1)
            color = mix(vec3(0,1,0), vec3(0,1,1), t);
            break;
        case 3:
            // Cyan (0,1,1) → Bleu (0,0,1)
            color = mix(vec3(0,1,1), vec3(0,0,1), t);
            break;
        case 4:
            // Bleu (0,0,1)
            color = vec3(0,0,1);
            break;
        default:
            color = vec3(1,0,0); 
            break;
    }

    gl_FragColor = vec4(color, 1.0);
}