import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class sketch extends PApplet {

public void setup(){ 
	size(200,200); 
} 
 
public void draw(){ 
	ellipse(50,50,80,80); 
} 
    static public void main(String args[]) {
        PApplet.main(new String[] { "--bgcolor=#ECE9D8", "sketch" });
    }
}
