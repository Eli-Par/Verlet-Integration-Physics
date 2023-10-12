public class Editor
{
  //Tracks the previous position of the mouse
  private int prevMouseX = 0;
  private int prevMouseY = 0;
  
  public void updatePrevMouse()
  {
    //If the mouse moved at least 2 pixels, update the old position
    if(abs(mouseX - prevMouseX) > 2) prevMouseX = mouseX;
    if(abs(mouseY - prevMouseY) > 2) prevMouseY = mouseY;    
  }
  
  public void editBalls()
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
  
  public void editPins()
  {
    //Find the pin that is clicked on and toggle it's pinned state
    int index = clickedBallIndex(); 
    if(index != -1) balls.get(index).togglePin();
  }
  
  public void editSticks()
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
  
  public void removeClickedStick()
  {
    removeClickedStick(false);
  }
  
  public void removeClickedStick(boolean removeUnattachedBalls)
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
  public boolean isBallConstrained(Ball b, Stick s)
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
  
  public int clickedBallIndex()
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
}
