import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
boolean gameOver = false;
int unmarkedBombs = NUM_BOMBS;
int unclickedTiles = (NUM_ROWS*NUM_COLS)-(NUM_BOMBS);

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int numRows = 0; numRows < NUM_ROWS; numRows++)
    for (int numCols = 0; numCols < NUM_COLS; numCols++)
      buttons[numRows][numCols] = new MSButton(numRows, numCols);
  for (int bomb = 0; bomb < NUM_BOMBS; bomb++)
    setBombs();
}
public void setBombs()
{
  int bombRow = (int)(Math.random()*NUM_ROWS);
  int bombCol = (int)(Math.random()*NUM_COLS);
  if (!bombs.contains(buttons[bombRow][bombCol]))
    bombs.add(buttons[bombRow][bombCol]);
  else
    setBombs();
}

public void draw ()
{
  if (gameOver == false)
  {
    background(255);
    textSize(18);
  }
  if (isWon())
    displayWinningMessage();
}
public boolean isWon()
{
  if (unclickedTiles == 0) return true;
  else if (unmarkedBombs != 0) return false;
  else if (unmarkedBombs == 0)
  {
    for (int i = 0; i < bombs.size(); i++)
      if (!bombs.get(i).isMarked())
        return false;
  }
  return true;
}
public void displayLosingMessage()
{
  for (int i = 0; i < bombs.size(); i++)
    if (bombs.get(i).isMarked() == false)
      bombs.get(i).clicked = true;
  fill(255);
  rect(0, 0, 400, 50);
  fill(0);
  textSize(20);
  text("You lose!", 200, 30);
  gameOver = true;
}
public void displayWinningMessage()
{
  fill(255);
  rect(0, 0, 400, 50);
  fill(0);
  textSize(20);
  text("You win!", 200, 30);
  gameOver = true;
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }

  public void mousePressed () 
  {
    if (gameOver == false)
    {
      if (mouseButton == LEFT && marked == false)
      {
        clicked = true;
        unclickedTiles--;
      }
      if (mouseButton == RIGHT && clicked == false)
      {
        marked = !marked;
        if (!isMarked())
          unmarkedBombs++;
        else if (isMarked())
          unmarkedBombs--;
      } 
      else if (bombs.contains( this ) && marked == false)
        displayLosingMessage();
      else if (countBombs(r, c)>0)
        setLabel(str(countBombs(r, c)));
      else
        for (int i = -1; i <= 1; i++)
          for (int j = -1; j <= 1; j++)
            if (isValid(r+i, c+j) && !buttons[r+i][c+j].isClicked())
              buttons[r+i][c+j].mousePressed();
    }
  }

  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    textSize(12);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    for (int i = -1; i <= 1; i++)
      for (int j = -1; j <= 1; j++)
        if (isValid(row+i, col+j) && bombs.contains(buttons[row+i][col+j]))
          numBombs++;
    return numBombs;
  }
}
