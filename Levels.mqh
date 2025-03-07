//+------------------------------------------------------------------+
//|                                                        Levels.mqh   |
//|                                                          RexiBG    |
//|                                             2025-03-03 20:44:07    |
//+------------------------------------------------------------------+
#property copyright "RexiBG"

#include <Object.mqh>

enum ENUM_LEVEL_TYPE
{
   LEVEL_SL,         // Stop Loss
   LEVEL_TP,         // Take Profit
   LEVEL_HEDGE       // Hedge линия
};

struct SLevel
{
   double            points;         // Разстояние в пипсове
   double            money;          // Сума в долари
   double            percent;        // Процент
   bool              isVisible;      // Показване на графиката
   bool              isActive;       // Активност
   string            name;           // Име на нивото
   color            clr;            // Цвят на линията
   int              line;           // Идентификатор на линията
   
   void Init(string prefix, string levelName, color levelColor)
   {
      points = 0;
      money = 0;
      percent = 0;
      isVisible = false;
      isActive = false;
      name = prefix + levelName;
      clr = levelColor;
      line = 0;
      
      // Създаваме линията
      if(!ObjectCreate(0, name, OBJ_HLINE, 0, 0, 0))
      {
         Print("Error: can't create ", name, " line! code #", GetLastError());
         return;
      }
      
      // Настройваме линията
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, 0);
      
      // Скриваме линията първоначално
      HideObject();
   }
   
   void ShowObject(bool show)
   {
      ObjectSetInteger(0, name, OBJPROP_TIMEFRAMES, show ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
   }
   
   void HideObject()
   {
      ShowObject(false);
   }
};

class CLevels
{
private:
   SLevel            m_sl;           // Stop Loss
   SLevel            m_tp;           // Take Profit
   SLevel            m_hedge;        // Hedge линия
   string            m_prefix;       // Префикс за обекти
   
   // Помощни методи
   double            PointsToPrice(double points) 
   {
      return points * Point();
   }
   
   double            CalculateLevel(double basePrice, double points, bool isAbove)
   {
      double offset = PointsToPrice(points);
      return isAbove ? basePrice + offset : basePrice - offset;
   }
   
   void              UpdateLevel(SLevel &level, double points, double money, double percent, bool isAbove)
   {
      level.points = points;
      level.money = money;
      level.percent = percent;
      
      if(level.isActive && level.isVisible)
      {
         double price = CalculateLevel(SymbolInfoDouble(_Symbol, SYMBOL_BID), points, isAbove);
         ObjectSetDouble(0, level.name, OBJPROP_PRICE, price);
      }
   }
   
public:
                     CLevels(string prefix="zr")
   {
      m_prefix = prefix;
      m_sl.Init(prefix, "SL", clrRed);
      m_tp.Init(prefix, "TP", clrGreen);
      m_hedge.Init(prefix, "HD", clrBlue);
   }
                    ~CLevels()
   {
      // Изтриваме обектите при край
      ObjectDelete(0, m_sl.name);
      ObjectDelete(0, m_tp.name);
      ObjectDelete(0, m_hedge.name);
   }
   
   void              UpdateSL(double points, double money, double percent)
   {
      UpdateLevel(m_sl, points, money, percent, false);
   }
   
   void              UpdateTP(double points, double money, double percent)
   {
      UpdateLevel(m_tp, points, money, percent, true);
   }
   
   void              UpdateHedge(double points, double money, double percent)
   {
      UpdateLevel(m_hedge, points, money, percent, true);
   }
   
   void              ShowLevel(ENUM_LEVEL_TYPE levelType, bool visible)
   {
      switch(levelType)
      {
         case LEVEL_SL:    
            m_sl.isVisible = visible;
            m_sl.ShowObject(visible);
            break;
         case LEVEL_TP:    
            m_tp.isVisible = visible;
            m_tp.ShowObject(visible);
            break;
         case LEVEL_HEDGE: 
            m_hedge.isVisible = visible;
            m_hedge.ShowObject(visible);
            break;
      }
   }
   
   void              ActivateLevel(ENUM_LEVEL_TYPE levelType, bool active)
   {
      switch(levelType)
      {
         case LEVEL_SL:    m_sl.isActive = active;    break;
         case LEVEL_TP:    m_tp.isActive = active;    break;
         case LEVEL_HEDGE: m_hedge.isActive = active; break;
      }
   }
};