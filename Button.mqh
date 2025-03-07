struct SButton
{
   string            name;
   int               x;
   int               y;
   int               width;
   int               height;
   color             bgColor;
   color             textColor;
   
   void Init(string prefix, string btnName, string text, 
            int xPos, int yPos, int w, int h,
            color bg=clrWhite, color txt=clrBlack,
            bool isEdit=false)
   {
      name = prefix + btnName;
      x = xPos;
      y = yPos;
      width = w;
      height = h;
      bgColor = bg;
      textColor = txt;
      
      ObjectDelete(0, name);
      
      if(!ObjectCreate(0, name, isEdit ? OBJ_EDIT : OBJ_BUTTON, 0, 0, 0))
      {
         Print("Error creating button: ", name, " Error code: ", GetLastError());
         return;
      }
      
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
      ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
   }
   
   void Move(int newX, int newY)
   {
      x = newX;
      y = newY;
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   }
   
   void SetText(string text)
   {
      ObjectSetString(0, name, OBJPROP_TEXT, text);
   }
   
   string GetText()
   {
      return ObjectGetString(0, name, OBJPROP_TEXT);
   }
   
   void Delete()  // Добавляем метод Delete
   {
      ObjectDelete(0, name);
   }
};