public class Editor
{
  //Tracks the previous position of the mouse
  private int prevMouseX = 0;
  private int prevMouseY = 0;
  
  private boolean isGridBeingSelected = false;
  
  private int selectStartCornerX;
  private int selectStartCornerY;
  
  private int pixelsPerDot = 40;
  
  public boolean isCreatingGrid()
  {
    return isGridBeingSelected;
  }
  
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
        editSticksEndPoint(true);
      }
    }
    
  }
  
  public void editSticksEndPoint(boolean calledFromClick)
  {
    if(prevStickClick == null) return;
    
    //Find the ball that was clicked on
    int index = clickedBallIndex();
    
    //If there is a ball that was clicked and it's not the same ball as the previously clicked one and there is not a stick connecting them already, 
    //add a stick between it and reset the previously clicked ball to null
    if(index != -1 && balls.get(index) != prevStickClick && isUniqueConnection(prevStickClick, balls.get(index)))
    {
      sticks.add(new Stick(prevStickClick, balls.get(index)));
      prevStickClick = null;
    }
    else if(index == -1 || !isUniqueConnection(prevStickClick, balls.get(index)) || calledFromClick) //If you don't click a ball or select a ball that already has an identical connection or click the same ball twice (called from a click, not a release), unselect it
    {
      prevStickClick = null;
    }
  }
  
  //Returns true if and only if no existing stick connects b1 to b2
  private boolean isUniqueConnection(Ball b1, Ball b2)
  {
    for(Stick s : sticks)
    {
      if(s.getBall1() == b1 && s.getBall2() == b2) return false;
      if(s.getBall1() == b2 && s.getBall2() == b1) return false;
    }
    return true;
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
  
  public void startGrid()
  {
    //Set the corner that the grid starts from
    selectStartCornerX = mouseX;
    selectStartCornerY = mouseY;
    
    //Mark that grid is being selected
    isGridBeingSelected = true;
  }
  
  public void endGrid()
  {    
    if(!isGridBeingSelected) return;
    
    //Set x1 and y1 to be the top left corner and x2 and y2 to be the bottom right corner
    //The selection is from the selection start variable to the mouse position
    int x1 = editor.selectStartCornerX;
    int x2 = mouseX;
    if(mouseX < x1) 
    {
      x1 = mouseX;
      x2 = editor.selectStartCornerX;
    }
    
    int y1 = editor.selectStartCornerY;
    int y2 = mouseY;
    if(mouseY < y1) 
    {
      y1 = mouseY;
      y2 = editor.selectStartCornerY;
    }
    
    //Store the number of balls in the scene before the grid is created
    int originalSize = balls.size();
    
    int xCount = round(max((x2 - x1) * 1.0 / editor.pixelsPerDot, 0));
    int yCount = round(max((y2 - y1) * 1.0 / editor.pixelsPerDot, 0));
    
    float xWidth = (x2 - x1) * 1.0 / xCount;
    float yWidth = (y2 - y1) * 1.0 / yCount;
    
    //Loop through the count for each dimension and add a ball at the corresponding position
    for(int yNum = 0; yNum <= yCount; yNum++)
    {
      for(int xNum = 0; xNum <= xCount; xNum++)
      {
        balls.add(new Ball(x1 + xNum * xWidth, y1 + yNum * yWidth));
      }
    }
    
    //Loop through all new balls and add sticks between them in a grid
    for(int i = originalSize; i < balls.size() - 1; i++)
    {
      //Connect horizontal rows
      if((i - originalSize + 1) % (xCount + 1) != 0) 
      {
        sticks.add(new Stick(balls.get(i), balls.get(i+1)));
      }
      
      //Connect vertical columns
      if(i + xCount + 1 < balls.size())
      {
        sticks.add(new Stick(balls.get(i), balls.get(i + xCount + 1)));
      }
    }
    
    isGridBeingSelected = false;
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
      if(balls.get(i).getPos().distance(p) < balls.get(i).getBallSize()) //Check double the size to make clicking easier
      {
        return i;
      }
    }  
    
    return -1;
  }  
}
