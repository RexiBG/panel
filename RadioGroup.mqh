//+------------------------------------------------------------------+
//|                                                   RadioGroup.mqh    |
//|                                                          RexiBG    |
//|                                             2025-03-04 00:47:43    |
//+------------------------------------------------------------------+
#property copyright "RexiBG"

#include "Button.mqh"

struct SRadioGroup
{
   string            name;
   SButton           button1;
   SButton           button2;
   bool              state1;    // true = первая кнопка, false = вторая
   int               x;
   int               y;
   
   void Init(string prefix, string groupName, 
            string text1, string text2,  // Добавлены параметры для текста кнопок
            int xPos, int yPos,
            int btnWidth, int btnHeight)
   {
      name = prefix + groupName;
      x = xPos;
      y = yPos;
      state1 = true;
      
      // Инициализация первой кнопки
      button1.Init(prefix, groupName + "Btn1", text1,
                  x, y,
                  btnWidth, btnHeight,
                  state1 ? clrLightGray : clrWhite);
                  
      // Инициализация второй кнопки
      button2.Init(prefix, groupName + "Btn2", text2,
                  x + btnWidth + 2, y,
                  btnWidth, btnHeight,
                  !state1 ? clrLightGray : clrWhite);
   }
   
   void Toggle(string clickedButton)
   {
      if(clickedButton == button1.name)
      {
         state1 = true;
         button1.Init(StringSubstr(button1.name, 0, StringLen(button1.name)-4), 
                     StringSubstr(button1.name, StringLen(button1.name)-4), 
                     button1.GetText(),
                     button1.x, button1.y,
                     button1.width, button1.height,
                     clrLightGray);
                     
         button2.Init(StringSubstr(button2.name, 0, StringLen(button2.name)-4), 
                     StringSubstr(button2.name, StringLen(button2.name)-4), 
                     button2.GetText(),
                     button2.x, button2.y,
                     button2.width, button2.height,
                     clrWhite);
      }
      else if(clickedButton == button2.name)
      {
         state1 = false;
         button1.Init(StringSubstr(button1.name, 0, StringLen(button1.name)-4), 
                     StringSubstr(button1.name, StringLen(button1.name)-4), 
                     button1.GetText(),
                     button1.x, button1.y,
                     button1.width, button1.height,
                     clrWhite);
                     
         button2.Init(StringSubstr(button2.name, 0, StringLen(button2.name)-4), 
                     StringSubstr(button2.name, StringLen(button2.name)-4), 
                     button2.GetText(),
                     button2.x, button2.y,
                     button2.width, button2.height,
                     clrLightGray);
      }
   }
   
   void Move(int newX, int newY)
   {
      x = newX;
      y = newY;
      button1.Move(x, y);
      button2.Move(x + button1.width + 2, y);
   }
   
   void Delete()
   {
      button1.Delete();
      button2.Delete();
   }
};