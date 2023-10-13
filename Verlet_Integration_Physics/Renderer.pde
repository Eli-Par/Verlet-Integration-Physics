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
      if(editor.isCreatingGrid())
      {       
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
        
        fill(255);
        
        for(int by = y1; by <= y2 + editor.pixelsPerDot / 2; by += editor.pixelsPerDot)
        {
          for(int bx = x1; bx <= x2 + editor.pixelsPerDot / 2; bx += editor.pixelsPerDot)
          {
            ellipse(bx, by, 10, 10);
          }
        }
        
      }
      
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
      else if(editState == EditState.GRID)
      {
        text("Edit Grid: " + editor.pixelsPerDot, 20, height - 20); 
      }
    }
    
  }
}
