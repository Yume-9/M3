#include <AFMotor.h>

// Motores
AF_DCMotor motorE(3);  
AF_DCMotor motorD(4);

// Sensores
#define pinSD A9  // Direito
#define pinSE A8  // Esquerdo

int limite = 300;   // ajuste conforme sensor
int baseSpeed = 190; // velocidade base segura

void setup() {
  motorE.setSpeed(baseSpeed);
  motorD.setSpeed(baseSpeed);
}

// Função que lê várias vezes e retorna verdadeiro se detectar preto
bool detectaPreto(int pin) {
  for (int i = 0; i < 10; i++) {          // lê 10 vezes rapidamente
    if (analogRead(pin) > limite) return true;
  }
  return false;
}

void loop() {
  // leitura reforçada e ultra-rápida
  bool pretoE = detectaPreto(pinSE);
  bool pretoD = detectaPreto(pinSD);

  // Bang-Bang ultra-rápido simétrico
  if (!pretoE && !pretoD) {
    // Ambos brancos → segue reto
    motorE.setSpeed(baseSpeed);
    motorD.setSpeed(baseSpeed);
  } 
  else if (pretoE && !pretoD) {
    // Esquerdo preto → roda esquerda para imediatamente
    motorE.setSpeed(0);
    motorD.setSpeed(baseSpeed);
  } 
  else if (!pretoE && pretoD) {
    // Direito preto → roda direita para imediatamente
    motorE.setSpeed(baseSpeed);
    motorD.setSpeed(0);
  } 
  else if (pretoE && pretoD) {
    // Ambos preto → segue reto
    motorE.setSpeed(baseSpeed);
    motorD.setSpeed(baseSpeed);
  }

  // aplica direção
  motorE.run(FORWARD);
  motorD.run(FORWARD);
}
