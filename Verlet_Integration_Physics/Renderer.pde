public class Renderer
{
  
  public void render()
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
}
