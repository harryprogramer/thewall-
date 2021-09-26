#version 400 core

in vec3 position;
in vec2 textureCoordinates;
in vec3 normal;

out vec2 pass_textureCoordinates;
out vec3 surfaceNormal;
out vec3 toLightVector;
out vec3 toCameraVector;
out float visiblity;

uniform mat4 transformationMatrix;
uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform vec3 lightPosition;

const float density = 0.0025;
const float gradient = 5.0;

void main(void){

    vec4 worldPosition = transformationMatrix * vec4(position,1.0);
    vec4 positionRelactiveToCam = viewMatrix * worldPosition;
    gl_Position = projectionMatrix * positionRelactiveToCam;
    pass_textureCoordinates = textureCoordinates * 2.0;

    surfaceNormal = (transformationMatrix * vec4(normal,0.0)).xyz;
    toLightVector = lightPosition - worldPosition.xyz;
    toCameraVector = (inverse(viewMatrix) * vec4(0.0,0.0,0.0,1.0)).xyz - worldPosition.xyz;

    float distance = length(positionRelactiveToCam.xyz);
    visiblity = exp(-pow((distance * density), gradient));
    visiblity = clamp(visiblity, 0.0, 1.0);
}