#include <WiFi.h>
#include <Wire.h>
#include "DHT.h"
#define DHTTYPE DHT11 // tip dht senzorja
#define DELAY 500 // delay med meritvam
#define VIN 5 // voltaža(fotoupor)
#define R 10000 //upor(fotoupor)
const int sensorPin = 2;
int sensorVal; // vrednost senzorja
int lux; 
uint8_t DHTPin = 4; 
DHT dht(DHTPin, DHTTYPE);// inicializacija za dht
float Temperature;
float Humidity;
const char* ssid = "linksys"; // ime
const char* password = ""; //geslo
WiFiServer server(60105); // port
IPAddress local_IP(192,168,1,130); //ip za dostop je 93.103.218.133:60105
IPAddress gateway(192,168,1,1);//prehod
IPAddress subnet(255, 255, 255, 0);
IPAddress primaryDNS(84,255,209,79); 
IPAddress secondaryDNS(84,255,210,79);

void setup() {
Serial.begin(115200);
pinMode(DHTPin, INPUT);
dht.begin();

// This part of code will try create static IP address
if (!WiFi.config(local_IP, gateway, subnet, primaryDNS, secondaryDNS)) {
Serial.println("configuracija ni uspela");
}
Serial.print("povezujem se na ");
Serial.println(ssid);
WiFi.begin(ssid, password);
while (WiFi.status() != WL_CONNECTED) {
delay(500);
Serial.print(".");
// print lokalni ip
Serial.println("");
Serial.println("WiFi povezan.");
Serial.println("IP address: ");
Serial.println(WiFi.localIP());
server.begin();

void loop()
{
  sensorVal = analogRead(sensorPin);
  lux=sensorRawToPhys(sensorVal);
  delay(DELAY);
  
Temperature = dht.readTemperature(); //dobi podatke o temperaturi
Humidity = dht.readHumidity(); // dobi podatke o vlažnosti

WiFiClient client = server.available();
if (client) 
{ 

String request = client.readStringUntil('\r'); 
client.println("HTTP/1.1 200 OK");
client.println("Content-type:text/html");
client.println("Connection: close");
client.println();

// html
client.println("<!DOCTYPE html><html>");
client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
client.println("<link rel=\"icon\" href=\"data:,\">");
client.println("<meta http-equiv=\"refresh\" content=\"2\">");
client.println("<script>\n");
client.println("setInterval(loadDoc,200);\n");
client.println("function loadDoc() {\n");
client.println("var xhttp = new XMLHttpRequest();\n");
client.println("xhttp.onreadystatechange = function() {\n");
client.println("if (this.readyState == 4 && this.status == 200) {\n");
client.println("document.getElementById(\"webpage\").innerHTML =this.responseText}\n");
client.println("};\n");
client.println("xhttp.open(\"GET\", \"/\", true);\n");
client.println("xhttp.send();\n");
client.println("}\n");
client.println("</script>\n)"); 
// CSS

client.println("<style>body { text-align: center; font-family: \"Arial\", Arial;}");
client.println("table { border-collapse: collapse; width:40%; margin-left:auto; margin-right:auto;border-spacing: 2px;background-color: white;border: 4px solid green; }");
client.println("th { padding: 20px; background-color: #008000; color: white; }");
client.println("tr { border: 5px solid green; padding: 2px; }");
client.println("tr:hover { background-color:yellow; }");
client.println("td { border:4px; padding: 12px; }");
client.println(".sensor { color:white; font-weight: bold; background-color: #bcbcbc; padding: 1px; }"); 

// heading
client.println("</style></head><body><h1>Arduino IoT Projekt</h1>");
client.println("<table><tr><th>MEASUREMENT</th><th>VALUE</th></tr>");
client.println("<tr><td>Temp. Celsius</td><td><span class=\"sensor\">");
client.println(dht.readTemperature());
client.println(" *C</span></td></tr>");
client.println("<tr><td>Humidity</td><td><span class=\"sensor\">");
client.println(dht.readHumidity());
client.println(" %</span></td></tr>"); 
client.println("<script>\n");
client.println();
Serial.println("Client disconnected.");
Serial.println("");
}
}
int sensorRawToPhys(int raw){ // izračun za fotoupor
  // Conversion rule
  float Vout = float(raw) * (VIN / float(1023));// Conversion analog to voltage
  float RLDR = (R * (VIN - Vout))/Vout; // Conversion voltage to resistance
  int phys=500/(RLDR/1000); // Conversion resitance to lumen
  return phys;
}
