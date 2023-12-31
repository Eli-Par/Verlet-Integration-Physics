public class Ball
{
  //Rendering
  private float ballSize = 10;
  
  private Point lastPos;
  private Point pos;
  
  //Physics parameters
  private float gravity = 0.1;
  private float bounceDampening = 0.9;
  private float ballRadius = 5;
  
  private boolean isPinned = false;
  
  public Ball()
  {
    this(0, 0);
  }
  
  public Ball(float x, float y)
  {
    pos = new Point(x, y);
    lastPos = new Point(pos);
  }
  
  public Ball(float x, float y, boolean pinned)
  {
    pos = new Point(x, y);
    lastPos = new Point(pos);
    isPinned = pinned;
  }
  
  public Ball(float x, float y, float dx, float dy)
  {
    pos = new Point(x, y);
    lastPos = new Point(pos.x + dx, pos.y + dy);
  }
  
  public float getBallSize()
  {
    return ballSize;
  }
  
  public void update()
  {
    if(isPinned) return;
    
    //Calculate the difference between the previous and current position
    float xVel = pos.x - lastPos.x;
    float yVel = pos.y - lastPos.y;
    
    //Set the old position to the current position
    lastPos.setPoint(pos);
    
    //Add the change in position between frames to the current position
    pos.x += xVel;
    pos.y += yVel;
    
    //Add gravity to the current position
    pos.y += gravity;
    
    bounceEdge(xVel, yVel);
  }
  
  //If the ball is on the edge of the screen, have it bounce. Snap the position to the edge of the screen and mirror the old position across to change directions.
  private void bounceEdge(float xVel, float yVel)
  {
    
    if(pos.x <= ballRadius) 
    {
      pos.x = ballRadius;
      lastPos.x = pos.x + xVel * bounceDampening;
    }
    else if(pos.x >= width - ballRadius)
    {
      pos.x = width - ballRadius;
      lastPos.x = pos.x + xVel * bounceDampening;
    }
    
    if(pos.y <= ballRadius)
    {
      pos.y = ballRadius;
      lastPos.y = pos.y + yVel * bounceDampening;
    }
    else if(pos.y >= height - ballRadius)
    {
      pos.y = height - ballRadius;
      lastPos.y = pos.y + yVel * bounceDampening;
    }
  }
  
  public void render()
  {
    //If the ball is pinned, make it red
    //Otherwise make it white
    if(isPinned) 
    {
      fill(255, 0, 0);
    }
    else
    {
      fill(255);
    }
    
    //If the ball is selected in edit mode, make it green
    if(this == prevStickClick && !simRunning)
    {
      fill(0, 255, 0);
    }
    
    ellipse(pos.x, pos.y, ballSize, ballSize);
    
  }
  
  public Point getPos()
  {
    return pos;
  }
  
  public Point getLastPos()
  {
    return lastPos;
  }
  
  public boolean isPinned()
  {
    return isPinned;
  }
  
  //Toggles if the ball is pinned
  public void togglePin()
  {
    isPinned = !isPinned;
  }
  
  //Calculate the distance between two balls
  public float distance(Ball b)
  {
    return pos.distance(b.getPos());
  }
  
}
