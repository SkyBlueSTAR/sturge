import processing.net.*; 
import javax.swing.*; 
import java.awt.*; 
import java.awt.event.*; 
import javax.swing.JFrame; 

Client client;
PFont textfont;

void setup() {
    fullscreen();
    textfont = loadFont(PFont.list()[107],24);
    textSize(40);
    try{
        client = new Client(this,"172.29.178.7",57834);
    } catch (Exception e) {
        text("conection lost.",width/2-140,height/2+20)
    }
}

void draw() {
    
}
