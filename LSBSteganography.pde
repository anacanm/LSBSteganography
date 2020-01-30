import java.util.*; //<>// //<>//
PImage carrier, burden, stegan, extracted;                         // image variable
int r, g, b, rFin, gFin, bFin;                      // red, green, blue floating point values //<>//
String rString, gString, bString, lsb, rCon, gCon, bCon,y;
String[] extraBits = new String[240000];
 String[] burdenBits = new String[240000];  //makes an array burdenPixels with length 240000, there will be one String bit at each index                this holds the bit values of the pixels(colors) of the burden image
void setup()
{
  size(640, 520);               // sets window 
  extracted = loadImage("pic4.png");
  extracted.loadPixels();
  burden = loadImage("pic2.png");  //100x100 pixels   beach someting pic
  
  
  
  burden.loadPixels(); //creates burden.pixels[] array
  
  stegan = loadImage("pic3.png");   // bee picture
  stegan.loadPixels();
  

 
  
  int burdenBitsIndex = 0;              
  for (int pixelCount = 0; pixelCount< 10000; pixelCount++)                             //this gives you a String array of all the bits in the burden image
  {
    color burnColor = burden.pixels[pixelCount];  //gets color from burden's pixels array at burdenCount
    String burnBinary = binary(burnColor,24);         // turns the color(burnColor) at burdenCount into a binary string, length 24
    for(int counter = 0; counter<24; counter++)
    {
       burdenBits[burdenBitsIndex] = burnBinary.substring(counter,counter+1);         //sets the string value at the index to the counterTH(n-th) bit of the 24bit string burnBinary
       //System.out.println(burdenBits[burdenBitsIndex]);
       burdenBitsIndex++;                         //increments index of burdenPixels
    }
      //System.out.println(burdenBitsIndex + " burdenPixelsIndex");
      //System.out.println(pixelCount + " pixelCount");
  }
  
  carrier = loadImage("pic1.png");  //800x800 pixels     dog
  carrier.loadPixels(); //creates carrier.pixels[] array
  
  
  image(carrier,0,10);
  textSize(15);
  fill(0);
  text("carrier",0,10);
  int syrup = 0;                           //syrup is a counter for the index of burdenBits
  for(int waffle = 0; waffle<80000; waffle++)
  {
    
  r = int(red(carrier.pixels[waffle]));      //gives int value representing red of the pixel at waffle...yes, waffle
  rString = binary(r,8);      //converts int value to binary String
  StringBuilder sr = new StringBuilder(rString);
  sr = sr.replace(7,8,burdenBits[syrup]); //System.out.println(burdenBits[syrup]);   //changes the last bit in the r binary string to a bit at
  rString = sr.toString();                   //converts StringBuilder back to Strings
  r = unbinary(rString);                           //converts String back to new int value, this int value is the changed original r value with the LSB changed to the burden bit
  syrup++;                                        //increments counter
  
  g = int(green(carrier.pixels[waffle]));
  gString = binary(g,8);
  StringBuilder sg = new StringBuilder(gString);
  sg = sg.replace(7,8,burdenBits[syrup]);
  gString = sg.toString();
  g = unbinary(gString);
  syrup++;
  
  b = int(blue(carrier.pixels[waffle]));
  bString = binary(b,8);
  StringBuilder sb = new StringBuilder(bString);
  sb = sb.replace(7,8,burdenBits[syrup]);
  bString = sb.toString();
  b = unbinary(bString);
  syrup++;
  
  //System.out.println(syrup + "syrup"); System.out.println(waffle+"waffle");
  color stegColor = color(r,g,b);
  stegan.pixels[waffle] = stegColor;
  
  }
  stegan.updatePixels();
  text("stegan",320,10);
  image(stegan,320,10);
}

void draw()
{
  
  if(mousePressed){
   int counter = 0;
   stegan.loadPixels();
   for(int pixelCount = 0;pixelCount<80000;pixelCount++)             //when finished, extraBits will be a full array of String bits of the extracted bits
   { 
     r=int(red(stegan.pixels[pixelCount]));    //gets r g and b int values at current pixel
     g=int(green(stegan.pixels[pixelCount]));
     b=int(blue(stegan.pixels[pixelCount]));
     
     rString = binary(r,8);         //gets binary string equivalent of int r
     gString = binary(g,8);
     bString = binary(b,8);
     lsb="";
     lsb = rString.substring(rString.length()-1); //last bit in String form of rString
     extraBits[counter] = lsb;     //adds the last bit to the extracted bits array
     counter++;                    //increments extracted bit counter
     lsb = gString.substring(gString.length()-1);
     extraBits[counter] = lsb;
     counter++;
     lsb = bString.substring(bString.length()-1);
     extraBits[counter] = lsb;
     counter++;
   }

   rCon = "";
   gCon= "";
   bCon = "";
   int i = 0;
   int finalCount = 0;
   //int x = 0;
   
  /* while(x<240000)
   {y=extraBits[x];
     System.out.println(y + " " + x%24); //<>//
   x++;
   }*/
   while(i<240000)
   {
    for(int a = 0; a<8; a++){              //this makes rCon a string of length 8 that contains 8 bits
      rCon+=extraBits[i]; 
      i++;}
      //System.out.println(rCon);
    for(int b = 0; b<8; b++){              //this makes gCon a string of length 8 that contains 8 bits
      gCon+=extraBits[i];
      i++; }
      //System.out.println(gCon);
      for(int c = 0; c<8; c++){              //this makes bCon a string of length 8 that contains 8 bits
      bCon+=extraBits[i];
      i++; }
     
      
      
      rFin = unbinary(rCon);// System.out.println(rFin+"r");               //int red value
      gFin = unbinary(gCon);// System.out.println(gFin+"g");
      bFin = unbinary(bCon);// System.out.println(bFin+"b");
      

      color extColor = color(rFin,gFin,bFin);
      extracted.pixels[finalCount] = extColor;
      
      finalCount++;
      rCon="";
      gCon="";
      bCon="";
   }
   text("burden",0,290);
   image(burden,0,300);
     extracted.updatePixels();
     text("extracted",300,290);
     image(extracted, 300,300);
  }
  
}