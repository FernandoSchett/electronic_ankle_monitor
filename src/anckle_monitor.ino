#include <WiFi.h>
#include <WiFiClient.h>

// Configurações de internet
const char* ssid = "Celular";
const char* password = "senhasenha";
const char* host = "google.com";   // Um endereço conhecido para verificar a conexão

// Pinos no ESP-32
const int ledPin = 2; // Pino GPIO2
const int buzzerPin = 23; // Pino GPIO23
const int pushButton = 4; // Pino GPIO4

// Senha de desativação do buzzer
const int senha = 3;
int senha_tentativa = 0;

// Estado do botão (pressionado ou não)
int estado_botao;

// Frequência para o buzzer em Hz
const int frequencia_buzzer = 3000;

void setup() {
  Serial.begin(9600); // Configura a taxa de transmissão de dados em bps
  pinMode(buzzerPin, OUTPUT);
 
  WiFi.begin(ssid, password);
  pinMode(ledPin, OUTPUT); // Configura o pino do LED como saída
  pinMode(pushButton, INPUT); // Configura o pino do botão como entrada
  
  while(WiFi.status() != WL_CONNECTED) {
    Serial.print("Tentando...\n");
    digitalWrite(ledPin, LOW); // Desliga a LED  
    delay(1000);
    digitalWrite(ledPin, HIGH); // Liga a LED  
    delay(1000); 
  }
  
  Serial.print("Conectou!!!\n");
}

void loop() {

  estado_botao = digitalRead(pushButton); // Recebe o estado do botão (pressionado = 1;não pressionado = 0)
  
  if(estado_botao) senha_tentativa += 1; // Apertar o botão para inserir a senha
  
  Serial.print("Botao: ");
  Serial.println(estado_botao);
  Serial.print("Senha Atual: ");
  Serial.println(senha_tentativa);
  Serial.print("Senha: ");
  Serial.println(senha);
  
  if (WiFi.isConnected()) {
    Serial.print("Conectado ao WIFI: ");
    Serial.println(ssid); // Mostra o nome do WIFI
    noTone(buzzerPin);
    digitalWrite(ledPin, HIGH); // Liga a LED
  }else{
     Serial.print("Nao conectado!\n");
     digitalWrite(ledPin, LOW);

     if(senha_tentativa != senha) // Senha de desativação do buzzer
      tone(buzzerPin, frequencia_buzzer); // Define a frequência do buzzer para 1000
     else
      noTone(buzzerPin); // Desativa o buzzer
  }

  delay(1000); // Aguardar um curto período antes de verificar novamente

}
