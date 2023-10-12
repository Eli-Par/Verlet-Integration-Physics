public class Point
{
  public float x;
  public float y;
  
  public Point()
  {
    x = 0;
    y = 0;
  }
  
  public Point(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  public Point(Point p)
  {
    this(p.x, p.y);
  }
  
  public void setPoint(Point p)
  {
    x = p.x;
    y = p.y;
  }
  
  //Calculate the distance between two points
  public float distance(Point p)
  {
    float dx = x - p.x;
    float dy = y - p.y;
    return sqrt(dx * dx + dy * dy);
  }
  
}
