import java.util.*;
import java.awt.geom.Line2D;

ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<Stick> sticks = new ArrayList<Stick>();

//Physics
boolean simRunning = false;
int constraintIterations = 5;

//Edit mode
enum EditState {BALLS, STICKS, PINS}

EditState editState = EditState.BALLS; 

Ball prevStickClick = null;

int prevMouseX = 0;
int prevMouseY = 0;

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
  
  if(simRunning)
  {
    //Update all physics
    updatePhysics();
    
    //When right click is held, delete sticks it passes over
    if(mouseButton == RIGHT)
    {
      removeClickedStick(true);
    }
    
  }
  else
  {
    //If the physics are not running, stick edit mode is selected and right click is held, delete sticks it passes over
    if(editState == EditState.STICKS && mouseButton == RIGHT)
    {
      removeClickedStick();
    }
  }
  
  //Draw everything to the screen
  render();
  
  //If the mouse moved at least 2 pixels, update the old position
  if(abs(mouseX - prevMouseX) > 2) prevMouseX = mouseX;
  if(abs(mouseY - prevMouseY) > 2) prevMouseY = mouseY;
  
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
      editPins();
    }
  }
  else //If physics are off, run the logic relating to the current edit mode
  {
    if(editState == EditState.BALLS)
    {
      editBalls();
    }
    else if(editState == EditState.PINS)
    {
      editPins();
    }
    else if(editState == EditState.STICKS)
    {
      editSticks();
    }
  }
  
}

void editBalls()
{
  //On left click add a ball where they clicked
  if(mouseButton == LEFT)
  {
    balls.add(new Ball(mouseX, mouseY));
  }
  
  //On right click remove the ball that was clicked on
  if(mouseButton == RIGHT)
  {
    int index = clickedBallIndex(); 
    if(index != -1) 
    {
      //Find all sticks that connect to the ball that is going to be removed and remove them
      int i = 0;
      while(i < sticks.size())
      {
        if(sticks.get(i).doesAttachTo(balls.get(index)))
        {
          sticks.remove(i);
        }
        else
        {
          i++;
        }
      }
      
      //Remove the ball
      balls.remove(index);
    }
  }  
}

void editPins()
{
  //Find the pin that is clicked on and toggle it's pinned state
  int index = clickedBallIndex(); 
  if(index != -1) balls.get(index).togglePin();
}

void editSticks()
{
  if(mouseButton == LEFT)
  {
    //If there is no previously selected ball, find the ball that was clicked on and make it the previously clicked ball
    if(prevStickClick == null)
    {
      int index = clickedBallIndex();
      if(index != -1)
      {
        prevStickClick = balls.get(index);
      }
      
    }
    else //If there was a previously clicked ball
    {
      //Find the ball that was clicked on
      int index = clickedBallIndex();
      
      //If there is a ball that was clicked and it's not the same ball as the previously clicked one, add a stick between it and reset the previously clicked ball to null
      if(index != -1 && balls.get(index) != prevStickClick)
      {
        sticks.add(new Stick(prevStickClick, balls.get(index)));
        prevStickClick = null;
      }
      else //If you don't click a ball or click the same ball again, unselect it
      {
        prevStickClick = null;
      }
      
    }
  }
  
}

void removeClickedStick()
{
  removeClickedStick(false);
}

void removeClickedStick(boolean removeUnattachedBalls)
{
  //If right clicking in stick edit mode, unselect the selected ball
  prevStickClick = null;
  
  //Create a line between the mouse and where the mouse used to be
  Line2D line1 = new Line2D.Float(mouseX, mouseY, prevMouseX, prevMouseY);
  
  //Loop through all sticks
  int i = 0;
  while(i < sticks.size())
  {
    //Get the end points of the stick
    Point p1 = sticks.get(i).getBall1().getPos();
    Point p2 = sticks.get(i).getBall2().getPos();
    
    //Create a line between the points
    Line2D line2 = new Line2D.Float(p1.x, p1.y, p2.x, p2.y);
    
    //If the stick intersects the mouse, remove the stick
    if(line2.intersectsLine(line1))
    {
      //If unattached balls should be removed, check is the balls the stick that will be removed constrained will still be constrained without it.
      //If they aren't, remove the ball
      if(removeUnattachedBalls)
      {
        if(!isBallConstrained(sticks.get(i).getBall1(), sticks.get(i)))
        {
          balls.remove(sticks.get(i).getBall1());
        }
        
        if(!isBallConstrained(sticks.get(i).getBall2(), sticks.get(i)))
        {
          balls.remove(sticks.get(i).getBall2());
        }
      }
      
      //Remove the stick
      sticks.remove(i);
    }
    else
    {
      //Increment if a stick was not removed
      i++;
    }
  }
}

//Returns true if a ball is constrained by any stick other than the one specified
boolean isBallConstrained(Ball b, Stick s)
{
  for(int i = 0; i < sticks.size(); i++)
  {
    if(sticks.get(i).doesAttachTo(b) && s != sticks.get(i)) 
    {
      return true;
    }
  }
  
  return false;
}

int clickedBallIndex()
{
  //Find the ball that is clicked on by checking if the distance between the mouse and the center is small enough
  Point p = new Point(mouseX, mouseY);
  
  for(int i = 0; i < balls.size(); i++)
  {
    if(balls.get(i).getPos().distance(p) < balls.get(i).ballSize) //Check double the size to make clicking easier
    {
      return i;
    }
  }  
  
  return -1;
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

void render()
{
  //Render all sticks
  for(int i = 0; i < sticks.size(); i++)
  {
    sticks.get(i).render();
  }
  
  //If there is a selected ball and in edit stick mode, draw a line from the ball to the mouse
  if(prevStickClick != null && editState == EditState.STICKS)
  {
    line(prevStickClick.getPos().x, prevStickClick.getPos().y, mouseX, mouseY);
  }
  
  //Render all balls
  for(int i = 0; i < balls.size(); i++)
  {
    balls.get(i).render();
  }
  
  //If the sim is not running, display the current edit mode
  if(!simRunning)
  {
    textSize(20);
    fill(0);
    if(editState == EditState.BALLS)
    {
      text("Edit Balls", 20, height - 20); 
    }
    else if(editState == EditState.PINS)
    {
      text("Edit Pins", 20, height - 20); 
    }
    else if(editState == EditState.STICKS)
    {
      text("Edit Sticks", 20, height - 20); 
    }
  }
  
}
