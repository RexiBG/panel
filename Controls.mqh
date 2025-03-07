//+------------------------------------------------------------------+
//|                                                      Controls.mqh   |
//|                                                          RexiBG    |
//|                                             2025-03-03 20:51:08    |
//+------------------------------------------------------------------+
#property copyright "RexiBG"

#include "Levels.mqh"

// Структура за един бутон
struct SButton
{
   string            name;           // Име на бутона
   string            text;           // Текст на бутона
   int              x;              // X координата
   int              y;              // Y координата
   int              width;          // Ширина
   int              height;         // Височина
   color            bgColor;        // Цвят на фона
   color            textColor;      // Цвят на текста
   
   void Init(string prefix, string btnName, string btnText, 
             int posX, int posY, int w=60, int h=20,
             color bg=clrDimGray, color txt=clrWhite)
   {
      name = prefix + btnName;
      text = btnText;
      x = posX;
      y = posY;
      width = w;
      height = h;
      bgColor = bg;
      textColor = txt;
      
      Create();
   }
   
   void Create()
   {
      if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
      {
         Print("Error creating button: ", name, " code #", GetLastError());
         return;
      }
      
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
   }
   
   void SetText(string newText)
   {
      text = newText;
      ObjectSetString(0, name, OBJPROP_TEXT, text);
   }
   
   void SetColor(color bg)
   {
      bgColor = bg;
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
   }
};

// Класс для управления контролями
class CControls
{
private:
   string            m_prefix;
   CLevels          *m_levels;
   
   // Бутони за управление
   SButton           m_btnSL;        // SL бутон
   SButton           m_btnTP;        // TP бутон
   SButton           m_btnHedge;     // Hedge бутон
   
   // Състояние на бутоните
   bool              m_slVisible;
   bool              m_tpVisible;
   bool              m_hedgeVisible;
   
public:
                     CControls(string prefix, CLevels *levels)
   {
      m_prefix = prefix;
      m_levels = levels;
      
      m_slVisible = false;
      m_tpVisible = false;
      m_hedgeVisible = false;
      
      // Създаваме бутоните
      m_btnSL.Init(prefix, "BtnSL", "SL", 10, 10, 60, 20, clrDarkRed);
      m_btnTP.Init(prefix, "BtnTP", "TP", 10, 35, 60, 20, clrDarkGreen);
      m_btnHedge.Init(prefix, "BtnHedge", "HD", 10, 60, 60, 20, clrDarkBlue);
   }
   
                    ~CControls()
   {
      // Изтриваме бутоните
      ObjectDelete(0, m_btnSL.name);
      ObjectDelete(0, m_btnTP.name);
      ObjectDelete(0, m_btnHedge.name);
   }
   
   // Обработка на събития
   bool              ProcessEvent(const int id,
                                const long &lparam,
                                const double &dparam,
                                const string &sparam)
   {
      // Проверяваме само за кликване на бутони
      if(id != CHARTEVENT_OBJECT_CLICK) return false;
      
      // Проверяваме кой бутон е кликнат
      if(sparam == m_btnSL.name)
      {
         m_slVisible = !m_slVisible;
         m_levels.ShowLevel(LEVEL_SL, m_slVisible);
         m_btnSL.SetColor(m_slVisible ? clrRed : clrDarkRed);
         return true;
      }
      
      if(sparam == m_btnTP.name)
      {
         m_tpVisible = !m_tpVisible;
         m_levels.ShowLevel(LEVEL_TP, m_tpVisible);
         m_btnTP.SetColor(m_tpVisible ? clrGreen : clrDarkGreen);
         return true;
      }
      
      if(sparam == m_btnHedge.name)
      {
         m_hedgeVisible = !m_hedgeVisible;
         m_levels.ShowLevel(LEVEL_HEDGE, m_hedgeVisible);
         m_btnHedge.SetColor(m_hedgeVisible ? clrBlue : clrDarkBlue);
         return true;
      }
      
      return false;
   }
};