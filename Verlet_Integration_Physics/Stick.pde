public class Stick
{
  private Ball b1;
  private Ball b2;
  private float leng;
  
  public Stick(Ball b1, Ball b2)
  {
    this.b1 = b1;
    this.b2 = b2;
    
    //Automatically set the sticks length
    leng = b1.distance(b2);
  }
  
  public void update()
  {
    //Get the positions of the two balls
    Point p1 = b1.getPos();
    Point p2 = b2.getPos();
    
    //Calculate the x and y difference between them and the distance
    float dx = p1.x - p2.x;
    float dy = p1.y - p2.y;
    float dist = sqrt(dx * dx + dy * dy);
    
    //Calculate the percentage of the distance that each ball needs to move to maintain length
    float percentDiff = (dist - leng) / dist / 2;
    
    //Calculate the x and y offsets that the balls need to move to maintain the length
    float xOffset = dx * percentDiff;
    float yOffset = dy * percentDiff;
    
    //If the ball isn't pinned, move it by the offsets
    //Othewise multiply the offsets by 2 to account for this ball not moving
    if(!b1.isPinned())
    {
      p1.x -= xOffset;
      p1.y -= yOffset;      
    }
    else
    {
      //xOffset *= 2;
      //yOffset *= 2;
    }

    //If the ball isn't pinned, move it by the offsets
    if(!b2.isPinned())
    {
      p2.x += xOffset;
      p2.y += yOffset;
    }
    
  }
  
  public Ball getBall1()
  {
    return b1;
  }
  
  public Ball getBall2()
  {
    return b2;
  }
  
  //Return true if either ball the stick attaches is the ball specified
  public boolean doesAttachTo(Ball b)
  {
    return b1 == b || b2 == b;
  }
  
  public void render()
  {
    Point p1 = b1.getPos();
    Point p2 = b2.getPos();
    line(p1.x, p1.y, p2.x, p2.y);
  }
}
