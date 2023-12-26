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
        
        fill(255);
        
        int xCount = round(max((x2 - x1) * 1.0 / editor.pixelsPerDot, 0));
        int yCount = round(max((y2 - y1) * 1.0 / editor.pixelsPerDot, 0));
        
        float xWidth = (x2 - x1) * 1.0 / xCount;
        float yWidth = (y2 - y1) * 1.0 / yCount;
        
        //Loop through the count for each dimension and draw a fake ball at the corresponding position
        for(int yNum = 0; yNum <= yCount; yNum++)
        {
          for(int xNum = 0; xNum <= xCount; xNum++)
          {
            ellipse(x1 + xNum * xWidth, y1 + yNum * yWidth, 10, 10);
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
