import pbox2d.*;
import oscP5.*;
import netP5.*;

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

OscP5 oscP5;
NetAddress broadcastLocation;

String ip = "127.0.0.1";
int port = 9002;
int incoming_port = 12312;

PBox2D box2d;

ArrayList<Box> boxes;

void setup() { 
  size(600, 600);
  frameRate(60);
  oscP5 = new OscP5(this, incoming_port);
  broadcastLocation = new NetAddress(ip, port);
  sendMsg("/vol", 0.5);
  sendMsg("/bypass", 1);

  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -5);

  boxes = new ArrayList<Box>();
} 

void sendMsg(String label, float data) {
  OscMessage msg = new OscMessage(label);
  msg.add(data);
  oscP5.send(msg, broadcastLocation);
}

void draw() {
  background(102, 240, 0);
  line(25, 25, mouseX, mouseY);

  box2d.step();
  for (Box b:boxes) {
    b.display();
  }
} 

void mousePressed() {
  Box box = new Box(mouseX, mouseY);
  boxes.add(box);
  sendMsg("/freq", width - mouseX + 400);
  sendMsg("/vol", (float)(float)(height - mouseY)/(float) height);
  sendMsg("/bang", 1);
}

// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A rectangular box
class Box {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;

  // Constructor
  Box(float x, float y) {
    w = random(4, 16);
    h = random(4, 16);
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h);
  }

  // This function removes the box from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the box ready for deletion?
  boolean done() {
    // Let's find the screen position of the box
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    float r = ((width-pos.x)/width) * 255;
    float g = 102;
    float b = 102;
    fill(r, g, b);
    stroke(0);
    rect(0, 0, w, h);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}

