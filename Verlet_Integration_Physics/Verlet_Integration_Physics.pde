import java.util.*;
import java.awt.geom.Line2D;

ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<Stick> sticks = new ArrayList<Stick>();

Renderer renderer = new Renderer();
Editor editor = new Editor();

//Physics
boolean simRunning = false;
int constraintIterations = 10;

//Edit mode
enum EditState {BALLS, STICKS, PINS, GRID}

EditState editState = EditState.BALLS; 

Ball prevStickClick = null;

void setup()
{
  size(800, 600);
  background(220);  
}

void draw()
{
  //Clear the screen
  background(220);
  
  //If stick editing is not active due to changing modes or the sim running, unselect the ball
  if(editState != EditState.STICKS || simRunning)
  {
    prevStickClick = null;
  }
  
  if(editState != EditState.GRID || simRunning)
  {
    editor.isGridBeingSelected = false;
  }
  
  if(simRunning)
  {
    //Update all physics
    updatePhysics();
    
    //When right click is held, delete sticks it passes over
    if(mouseButton == RIGHT)
    {
      editor.removeClickedStick(true);
    }
    
  }
  else
  {
    //If the physics are not running, stick edit mode is selected and right click is held, delete sticks it passes over
    if(editState == EditState.STICKS && mouseButton == RIGHT)
    {
      editor.removeClickedStick();
    }
  }
  
  //Draw everything to the screen
  renderer.render();
  
  //if(balls.size() > 0 && ballIndex < balls.size()) println((balls.get(ballIndex).getPos().x - balls.get(ballIndex).getLastPos().x) + ", " + (balls.get(ballIndex).getPos().y - balls.get(ballIndex).getLastPos().y));
  
  //Updates the previous location of the mouse
  editor.updatePrevMouse();

}

void keyPressed()
{
  
  //Toggle if physics are running with space
  if(key == ' ')
  {
    simRunning = !simRunning;
  }
  
  //Change edit mode state based on the key pressed if the physics are not running
  if(key == 'b' && !simRunning)
  {
    editState = EditState.BALLS;
  }
  else if(key == 'p' && !simRunning)
  {
    editState = EditState.PINS;
  }
  else if(key == 's' && !simRunning)
  {
    editState = EditState.STICKS;
  }
  else if(key == 'g' && !simRunning)
  {
    editState = EditState.GRID;
  }
  else if(key == 'c' && !simRunning)
  {
    //Remove all balls and sticks
    balls.clear();
    sticks.clear();
  }
  
}

void mousePressed()
{
  //If physics are running and the left mouse is pressed, toggle the clicked ball being pinned
  if(simRunning)
  {
    if(mouseButton == LEFT)
    {
      editor.editPins();
    }
  }
  else //If physics are off, run the logic relating to the current edit mode
  {
    if(editState == EditState.BALLS)
    {
      editor.editBalls();
    }
    else if(editState == EditState.PINS)
    {
      editor.editPins();
    }
    else if(editState == EditState.STICKS)
    {
      editor.editSticks();
    }
    else if(editState == EditState.GRID)
    {
      editor.startGrid();
    }
  }
  
}

void mouseReleased()
{
  if(editState == EditState.STICKS && mouseButton == LEFT)
  {
    editor.editSticksEndPoint(false);
  }
  else if(editState == EditState.GRID)
  {
    editor.endGrid();
  }
}

void mouseWheel(MouseEvent event) 
{
  //If in grid edit mode, change the spacing between balls using based on the scroll wheel
  if(editState == EditState.GRID)
  {
    float e = event.getCount();
    editor.pixelsPerDot += (int) e * -5;
    if(editor.pixelsPerDot < 20) editor.pixelsPerDot = 20;
    if(editor.pixelsPerDot > 100) editor.pixelsPerDot = 100;
  }
}

void updatePhysics()
{
  //Update all ball physics
  for(int i = 0; i < balls.size(); i++)
  {
    balls.get(i).update();
  }
  
  //Update all stick contraints
  for(int k = 0; k < constraintIterations; k++)
  {
    for(int i = 0; i < sticks.size(); i++)
    {
      sticks.get(i).update();
    }
  }
  
}
