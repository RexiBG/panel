//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh   |
//|                                                          RexiBG    |
//|                                             2025-03-03 22:46:46    |
//+------------------------------------------------------------------+
#property copyright "RexiBG"

#include "Button.mqh"
#include "TrendLines.mqh"
#include "RadioGroup.mqh"


class CTradePanel
{
private:
   string            m_prefix;
      
   string            m_panelName;
   int               m_x;
   int               m_y;
   int               m_width;
   int               m_height;
   color            m_bgColor;
   bool              m_isVisible;
   
   
   // Основни бутони
   SButton           m_buyBtn;
   SButton           m_sellBtn;
   SButton           m_closeBtn;
   SButton           m_buyLineBtn;    // Нов бутон за B line
   SButton           m_sellLineBtn;   // Нов бутон за S line
   
   // LOT контроли
   SButton           m_lotEdit;
   SButton           m_lotUpBtn;
   SButton           m_lotDownBtn;
   
   // Radio бутони
   SRadioGroup       m_slTypeRadio;    // SL: пипс/сума
   SRadioGroup       m_tpTypeRadio;    // TP: пипс/сума
   SRadioGroup       m_riskTypeRadio;  // Risk: процент/сума
   SRadioGroup       m_lotTypeRadio;   // Lot: риск/фиксиран
   
   // Тренд линии
   STrendLine        m_buyLine;        // Линия за buy вход
   STrendLine        m_sellLine;       // Линия за sell вход
   STrendLine        m_slLine;         // Линия за stop loss
   STrendLine        m_tpLine;         // Линия за take profit
   
   // SL контроли
   SButton           m_slPipsEdit;     // SL в пипсове
   SButton           m_slMoneyEdit;    // SL сума
   SButton           m_slShowBtn;      // Покажи SL
   SButton           m_slActiveBtn;    // Активирай SL
   SButton           m_slHedgeBtn;     // Хедж SL
   
   // TP контроли
   SButton           m_tpPipsEdit;     // TP в пипсове
   SButton           m_tpMoneyEdit;    // TP сума
   SButton           m_tpShowBtn;      // Покажи TP
   SButton           m_tpActiveBtn;    // Активирай TP
   SButton           m_tpHedgeBtn;     // Хедж TP
   
   // Risk и Money контроли
   SButton           m_riskPercentEdit; // Risk процент
   SButton           m_riskMoneyEdit;   // Risk сума
   SButton           m_magicEdit;       // Magic number
   
   // Информационни полета
   string            m_symbolLabel;     // Символ
   string            m_bidLabel;        // Bid цена
   string            m_askLabel;        // Ask цена
   string            m_spreadLabel;     // Spread
   
   // Съхранени стойности
   double            m_lotSize;
   double            m_slPips;
   double            m_slMoney;
   double            m_tpPips;
   double            m_tpMoney;
   double            m_riskPercent;
   double            m_riskMoney;
   int               m_magic;
   bool              m_slShow;
   bool              m_slActive;
   bool              m_slHedge;
   bool              m_tpShow;
   bool              m_tpActive;
   bool              m_tpHedge;
      //--- Private методи
   void CreatePanel()
   {
      m_panelName = m_prefix + "TradePanel";
      
      if(!ObjectCreate(0, m_panelName, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      {
         Print("Error creating trade panel: ", GetLastError());
         return;
      }
      
      ObjectSetInteger(0, m_panelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, m_panelName, OBJPROP_XDISTANCE, m_x);
      ObjectSetInteger(0, m_panelName, OBJPROP_YDISTANCE, m_y);
      ObjectSetInteger(0, m_panelName, OBJPROP_XSIZE, m_width);
      ObjectSetInteger(0, m_panelName, OBJPROP_YSIZE, m_height);
      ObjectSetInteger(0, m_panelName, OBJPROP_BGCOLOR, m_bgColor);
      ObjectSetInteger(0, m_panelName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, m_panelName, OBJPROP_BORDER_COLOR, clrGray);
      ObjectSetInteger(0, m_panelName, OBJPROP_HIDDEN, false);
      ObjectSetInteger(0, m_panelName, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, m_panelName, OBJPROP_SELECTED, true);
      ObjectSetInteger(0, m_panelName, OBJPROP_ZORDER, 0);
   }

   void CreateTrendLines()
   {
      m_buyLine.Init(m_prefix, "BuyLine", clrBlue);
      m_sellLine.Init(m_prefix, "SellLine", clrRed);
      m_slLine.Init(m_prefix, "SLLine", clrOrange);
      m_tpLine.Init(m_prefix, "TPLine", clrGreen);
   }
   
   void CreateRadioButtons()
   {
      int btnWidth = 40;
      int btnHeight = 20;
      int startY = m_y + 45;
      
      // Radio groups init
      m_slTypeRadio.Init(m_prefix, "SLType", "Pips", "Money", 
                        m_x + 200, startY + (btnHeight + 5) * 3, 
                        btnWidth, btnHeight);
                        
      m_tpTypeRadio.Init(m_prefix, "TPType", "Pips", "Money",
                        m_x + 200, startY + (btnHeight + 5) * 4,
                        btnWidth, btnHeight);
                        
      m_riskTypeRadio.Init(m_prefix, "RiskType", "%", "$",
                          m_x + 200, startY + (btnHeight + 5) * 2,
                          btnWidth, btnHeight);
                          
      m_lotTypeRadio.Init(m_prefix, "LotType", "Risk", "Fixed",
                         m_x + 200, startY + (btnHeight + 5),
                         btnWidth, btnHeight);
   }
      void CreateButtons()
   {
      int btnWidth = 60;
      int btnHeight = 20;
      int btnSpace = 5;
      int startX = 10;
      int startY = 25;
      int smallBtnWidth = 20;
      
      // Основни бутони
      m_buyBtn.Init(m_prefix, "BuyBtn", "BUY", 
                    m_x + startX, 
                    m_y + startY, 
                    btnWidth, btnHeight,
                    clrLightGreen, clrBlack);
      
      m_sellBtn.Init(m_prefix, "SellBtn", "SELL", 
                     m_x + startX + btnWidth + btnSpace, 
                     m_y + startY,
                     btnWidth, btnHeight,
                     clrLightPink, clrBlack);
      
      m_closeBtn.Init(m_prefix, "CloseBtn", "CLOSE", 
                      m_x + startX + (btnWidth + btnSpace) * 2,
                      m_y + startY,
                      btnWidth, btnHeight,
                      clrLightGray, clrBlack);
                      
      // Line бутони
      m_buyLineBtn.Init(m_prefix, "BuyLineBtn", "B line", 
                       m_x + startX + (btnWidth + btnSpace) * 3,
                       m_y + startY,
                       btnWidth, btnHeight,
                       clrLightBlue, clrBlack);
                       
      m_sellLineBtn.Init(m_prefix, "SellLineBtn", "S line",
                        m_x + startX + (btnWidth + btnSpace) * 4,
                        m_y + startY,
                        btnWidth, btnHeight,
                        clrLightPink, clrBlack);
      
      // LOT контроли
      m_lotEdit.Init(m_prefix, "LotEdit", DoubleToString(m_lotSize, 2), 
                     m_x + startX, 
                     m_y + startY + btnHeight + btnSpace,
                     40, btnHeight,
                     clrWhite, clrBlack, true);
                     
      m_lotUpBtn.Init(m_prefix, "LotUpBtn", "+", 
                      m_x + startX + 45,
                      m_y + startY + btnHeight + btnSpace,
                      btnHeight, btnHeight,
                      clrWhite, clrBlack);
      
      m_lotDownBtn.Init(m_prefix, "LotDownBtn", "-", 
                        m_x + startX + 45 + btnHeight + 5,
                        m_y + startY + btnHeight + btnSpace,
                        btnHeight, btnHeight,
                        clrWhite, clrBlack);
      
      // Risk контроли
      m_riskPercentEdit.Init(m_prefix, "RiskPercentEdit", DoubleToString(m_riskPercent, 1), 
                             m_x + startX, 
                             m_y + startY + (btnHeight + btnSpace) * 2,
                             40, btnHeight,
                             clrWhite, clrBlack, true);
                             
      m_riskMoneyEdit.Init(m_prefix, "RiskMoneyEdit", DoubleToString(m_riskMoney, 2), 
                           m_x + startX + 100, 
                           m_y + startY + (btnHeight + btnSpace) * 2,
                           60, btnHeight,
                           clrWhite, clrBlack, true);
                                 // SL контроли
      m_slPipsEdit.Init(m_prefix, "SLPipsEdit", DoubleToString(m_slPips, 0), 
                        m_x + startX, 
                        m_y + startY + (btnHeight + btnSpace) * 3,
                        40, btnHeight,
                        clrWhite, clrBlack, true);
                        
      m_slMoneyEdit.Init(m_prefix, "SLMoneyEdit", DoubleToString(m_slMoney, 2), 
                         m_x + startX + 45, 
                         m_y + startY + (btnHeight + btnSpace) * 3,
                         40, btnHeight,
                         clrWhite, clrBlack, true);
                         
      m_slShowBtn.Init(m_prefix, "SLShowBtn", "S", 
                       m_x + startX + 90,
                       m_y + startY + (btnHeight + btnSpace) * 3,
                       smallBtnWidth, btnHeight,
                       clrWhite, clrBlack);
                       
      m_slActiveBtn.Init(m_prefix, "SLActiveBtn", "A", 
                         m_x + startX + 90 + smallBtnWidth + 2,
                         m_y + startY + (btnHeight + btnSpace) * 3,
                         smallBtnWidth, btnHeight,
                         clrWhite, clrBlack);
                         
      m_slHedgeBtn.Init(m_prefix, "SLHedgeBtn", "H", 
                        m_x + startX + 90 + (smallBtnWidth + 2) * 2,
                        m_y + startY + (btnHeight + btnSpace) * 3,
                        smallBtnWidth, btnHeight,
                        clrWhite, clrBlack);
      
      // TP контроли
      m_tpPipsEdit.Init(m_prefix, "TPPipsEdit", DoubleToString(m_tpPips, 0), 
                        m_x + startX, 
                        m_y + startY + (btnHeight + btnSpace) * 4,
                        40, btnHeight,
                        clrWhite, clrBlack, true);
                        
      m_tpMoneyEdit.Init(m_prefix, "TPMoneyEdit", DoubleToString(m_tpMoney, 2), 
                         m_x + startX + 45, 
                         m_y + startY + (btnHeight + btnSpace) * 4,
                         40, btnHeight,
                         clrWhite, clrBlack, true);
                         
      m_tpShowBtn.Init(m_prefix, "TPShowBtn", "S", 
                       m_x + startX + 90,
                       m_y + startY + (btnHeight + btnSpace) * 4,
                       smallBtnWidth, btnHeight,
                       clrWhite, clrBlack);
                       
      m_tpActiveBtn.Init(m_prefix, "TPActiveBtn", "A", 
                         m_x + startX + 90 + smallBtnWidth + 2,
                         m_y + startY + (btnHeight + btnSpace) * 4,
                         smallBtnWidth, btnHeight,
                         clrWhite, clrBlack);
                         
      m_tpHedgeBtn.Init(m_prefix, "TPHedgeBtn", "H", 
                        m_x + startX + 90 + (smallBtnWidth + 2) * 2,
                        m_y + startY + (btnHeight + btnSpace) * 4,
                        smallBtnWidth, btnHeight,
                        clrWhite, clrBlack);
      
      // Magic number
      m_magicEdit.Init(m_prefix, "MagicEdit", IntegerToString(m_magic), 
                       m_x + startX + 140,
                       m_y + startY + (btnHeight + btnSpace) * 3,
                       50, btnHeight,
                       clrWhite, clrBlack, true);
   }
      void CreateLabels()
   {
      m_symbolLabel = m_prefix + "SymbolLabel";
      m_bidLabel = m_prefix + "BidLabel";
      m_askLabel = m_prefix + "AskLabel";
      m_spreadLabel = m_prefix + "SpreadLabel";
      
      CreateLabel(m_symbolLabel, _Symbol, m_y + 5, m_x + 10);
      CreateLabel(m_bidLabel, "", m_y + 5, m_x + 90);
      CreateLabel(m_askLabel, "", m_y + 5, m_x + 170);
      CreateLabel(m_spreadLabel, "", m_y + m_height - 15, m_x + m_width - 60);
   }
   
   void CreateLabel(string name, string text, int y, int x)
   {
      if(!ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0))
      {
         Print("Error creating label: ", name, " code #", GetLastError());
         return;
      }
      
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
   }
   
   void UpdateLines()
   {
      if(m_buyLine.visible)
      {
         double price = m_buyLine.GetPrice();
         CalculateTradeParams(true, price);
      }
      
      if(m_sellLine.visible)
      {
         double price = m_sellLine.GetPrice();
         CalculateTradeParams(false, price);
      }
   }
   
   void CalculateTradeParams(bool isBuy, double entryPrice)
   {
      double slPrice = m_slLine.GetPrice();
      double tpPrice = m_tpLine.GetPrice();
      
      // Калкулиране на пипсове
      double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      double slPips = MathAbs(entryPrice - slPrice) / pipValue;
      double tpPips = MathAbs(entryPrice - tpPrice) / pipValue;
      
      // Актуализиране на полетата
      m_slPipsEdit.SetText(DoubleToString(slPips, 0));
      m_tpPipsEdit.SetText(DoubleToString(tpPips, 0));
      
      // Калкулиране на лота според риска
      if(m_lotTypeRadio.state1) // Risk based
      {
         double riskAmount;
         if(m_riskTypeRadio.state1) // Risk %
            riskAmount = AccountInfoDouble(ACCOUNT_BALANCE) * StringToDouble(m_riskPercentEdit.GetText()) / 100.0;
         else // Risk $
            riskAmount = StringToDouble(m_riskMoneyEdit.GetText());
         
         double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
         double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
         
         if(slPips > 0 && tickValue > 0)
         {
            double lot = NormalizeDouble(riskAmount / (slPips * tickValue), 2);
            lot = MathFloor(lot / lotStep) * lotStep;
            m_lotEdit.SetText(DoubleToString(lot, 2));
         }
      }
   }
   
   
      void UpdateSLTPLines()
   {
      if(!m_buyLine.visible && !m_sellLine.visible) return;
      
      double entryPrice = m_buyLine.visible ? m_buyLine.GetPrice() : m_sellLine.GetPrice();
      bool isBuy = m_buyLine.visible;
      
      double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      
      // Изчисляване на SL
      if(m_slShow)
      {
         double slDistance = m_slTypeRadio.state1 ? 
            m_slPips * _Point : // В пипсове
            m_slMoney / (tickValue * m_lotSize); // В пари
            
         double slPrice = isBuy ? entryPrice - slDistance : entryPrice + slDistance;
         m_slLine.SetPrice(slPrice);
         m_slLine.SetVisible(true);
      }
      
      // Изчисляване на TP
      if(m_tpShow)
      {
         double tpDistance = m_tpTypeRadio.state1 ? 
            m_tpPips * _Point : // В пипсове
            m_tpMoney / (tickValue * m_lotSize); // В пари
            
         double tpPrice = isBuy ? entryPrice + tpDistance : entryPrice - tpDistance;
         m_tpLine.SetPrice(tpPrice);
         m_tpLine.SetVisible(true);
      }
   }
   
  
      
      public:
      
               CTradePanel(int x=20, int y=40)
   {
      m_panelName = "TradePanel";
      m_x = x;
      m_y = y;
      m_width = 380;
      m_height = 200;
      m_bgColor = clrWhiteSmoke;
      m_isVisible = false;
      
      // Правильная инициализация линий
      m_buyLine.Init("trade", "BuyLine", clrBlue);
      m_sellLine.Init("trade", "SellLine", clrRed);
      m_tpLine.Init("trade", "TPLine", clrGreen);
      m_slLine.Init("trade", "SLLine", clrRed);
      
      // Настройка начальных значений
      m_lotSize = 0.1;
      m_slPips = 10;
      m_tpPips = 20;
      m_slMoney = 100;
      m_tpMoney = 200;
      m_slShow = false;
      m_tpShow = false;
   }
   
   
   // Добавим геттеры для координат
   int GetX() const { return m_x; }
   int GetY() const { return m_y; }

                     CTradePanel(string prefix="zr")
   {
      m_prefix = prefix;
      m_x = 20;
      m_y = 60;
      m_width = 380;  // Увеличена ширина
      m_height = 200; // Увеличена височина
      m_bgColor = clrWhiteSmoke;
      m_isVisible = false;
      
      // Инициализация на стойностите
      m_lotSize = 0.01;
      m_slPips = 50;
      m_slMoney = 100;
      m_tpPips = 100;
      m_tpMoney = 200;
      m_riskPercent = 1.0;
      m_riskMoney = 100;
      m_magic = 12345;
      m_slShow = false;
      m_slActive = false;
      m_slHedge = false;
      m_tpShow = false;
      m_tpActive = false;
      m_tpHedge = false;
   }
   
                    ~CTradePanel() { Hide(); }
   
   void Show()
   {
      if(!m_isVisible)
      {
         CreatePanel();
         CreateButtons();
         CreateLabels();
         CreateTrendLines();
         CreateRadioButtons();
         m_isVisible = true;
      }
   }
   
   void Hide()
   {
      if(m_isVisible)
      {
         // Удаляем все объекты
         ObjectDelete(0, m_panelName);
         
         // Удаляем линии
         m_buyLine.Delete();
         m_sellLine.Delete();
         m_slLine.Delete();
         m_tpLine.Delete();
         
         // Удаляем radio groups
         m_slTypeRadio.Delete();
         m_tpTypeRadio.Delete();
         m_riskTypeRadio.Delete();
         m_lotTypeRadio.Delete();
         
         // Удаляем кнопки
         ObjectDelete(0, m_buyBtn.name);
         ObjectDelete(0, m_sellBtn.name);
         ObjectDelete(0, m_closeBtn.name);
         ObjectDelete(0, m_buyLineBtn.name);
         ObjectDelete(0, m_sellLineBtn.name);
         ObjectDelete(0, m_lotEdit.name);
         ObjectDelete(0, m_lotUpBtn.name);
         ObjectDelete(0, m_lotDownBtn.name);
         ObjectDelete(0, m_riskPercentEdit.name);
         ObjectDelete(0, m_riskMoneyEdit.name);
         ObjectDelete(0, m_slPipsEdit.name);
         ObjectDelete(0, m_slMoneyEdit.name);
         ObjectDelete(0, m_slShowBtn.name);
         ObjectDelete(0, m_slActiveBtn.name);
         ObjectDelete(0, m_slHedgeBtn.name);
         ObjectDelete(0, m_tpPipsEdit.name);
         ObjectDelete(0, m_tpMoneyEdit.name);
         ObjectDelete(0, m_tpShowBtn.name);
         ObjectDelete(0, m_tpActiveBtn.name);
         ObjectDelete(0, m_tpHedgeBtn.name);
         ObjectDelete(0, m_magicEdit.name);
         ObjectDelete(0, m_symbolLabel);
         ObjectDelete(0, m_bidLabel);
         ObjectDelete(0, m_askLabel);
         ObjectDelete(0, m_spreadLabel);
         
         m_isVisible = false;
      }
   }
   
   bool ProcessEvent(const int id,
                    const long &lparam,
                    const double &dparam,
                    const string &sparam)
   {
      
      
      
      
      if(!m_isVisible) return false;
      
      // Обработка движения линий
      if(id == CHARTEVENT_OBJECT_DRAG)
      {
         if(sparam == m_buyLine.name || 
            sparam == m_sellLine.name || 
            sparam == m_slLine.name || 
            sparam == m_tpLine.name)
         {
            UpdateLines();
            UpdateSLTPLines();  // Добавете тук
            return true;
         }
      }
      
      if(id == CHARTEVENT_OBJECT_CLICK)
      {
         // Radio groups
         m_slTypeRadio.Toggle(sparam);
         m_tpTypeRadio.Toggle(sparam);
         m_riskTypeRadio.Toggle(sparam);
         m_lotTypeRadio.Toggle(sparam);
         
         // Line buttons
         if(sparam == m_buyLineBtn.name)
         {
            m_buyLine.SetPrice(SymbolInfoDouble(_Symbol, SYMBOL_ASK));
            m_buyLine.SetVisible(true);
            m_sellLine.SetVisible(false);
            UpdateSLTPLines();  // Добавете тук
            return true;
         }
         
         if(sparam == m_sellLineBtn.name)
         {
            m_sellLine.SetPrice(SymbolInfoDouble(_Symbol, SYMBOL_BID));
            m_sellLine.SetVisible(true);
            m_buyLine.SetVisible(false);
            UpdateSLTPLines();  // Добавете тук
            return true;
         }
         
         // Остальные кнопки
         if(sparam == m_buyBtn.name) return OnBuyClick();
         if(sparam == m_sellBtn.name) return OnSellClick();
         if(sparam == m_closeBtn.name) return OnCloseClick();
         
         if(sparam == m_lotUpBtn.name)
         {
            double lot = StringToDouble(m_lotEdit.GetText());
            lot = NormalizeDouble(lot + 0.01, 2);
            m_lotEdit.SetText(DoubleToString(lot, 2));
            m_lotSize = lot;
            return true;
         }
         
         if(sparam == m_lotDownBtn.name)
         {
            double lot = StringToDouble(m_lotEdit.GetText());
            if(lot > 0.01)
            {
               lot = NormalizeDouble(lot - 0.01, 2);
               m_lotEdit.SetText(DoubleToString(lot, 2));
               m_lotSize = lot;
            }
            return true;
         }
         
         // SL/TP toggle buttons
         if(sparam == m_slShowBtn.name)
         {
            m_slShow = !m_slShow;
            m_slShowBtn.SetText(m_slShow ? "S+" : "S");
            m_slLine.SetVisible(m_slShow);
            UpdateSLTPLines();  // Добавете тук
            return true;
         }
         
         if(sparam == m_slActiveBtn.name)
         {
            m_slActive = !m_slActive;
            m_slActiveBtn.SetText(m_slActive ? "A+" : "A");
            return true;
         }
         
         if(sparam == m_slHedgeBtn.name)
         {
            m_slHedge = !m_slHedge;
            m_slHedgeBtn.SetText(m_slHedge ? "H+" : "H");
            return true;
         }
         
         if(sparam == m_tpShowBtn.name)
         {
            m_tpShow = !m_tpShow;
            m_tpShowBtn.SetText(m_tpShow ? "S+" : "S");
            m_tpLine.SetVisible(m_tpShow);
            UpdateSLTPLines();  // Добавете тук
            return true;
         }
         
         if(sparam == m_tpActiveBtn.name)
         {
            m_tpActive = !m_tpActive;
            m_tpActiveBtn.SetText(m_tpActive ? "A+" : "A");
            return true;
         }
         
         if(sparam == m_tpHedgeBtn.name)
         {
            m_tpHedge = !m_tpHedge;
            m_tpHedgeBtn.SetText(m_tpHedge ? "H+" : "H");
            return true;
         }
      }
      
      if(id == CHARTEVENT_OBJECT_ENDEDIT)
      {
         // Запазване на въведените стойности
         if(sparam == m_lotEdit.name)
            m_lotSize = StringToDouble(m_lotEdit.GetText());
            
         if(sparam == m_slPipsEdit.name)
         {
            m_slPips = StringToDouble(m_slPipsEdit.GetText());
            UpdateSLTPLines();  // Добавете тук
         }
            
         if(sparam == m_slMoneyEdit.name)
         {
            m_slMoney = StringToDouble(m_slMoneyEdit.GetText());
            UpdateSLTPLines();  // Добавете тук
         }
            
         if(sparam == m_tpPipsEdit.name)
         {
            m_tpPips = StringToDouble(m_tpPipsEdit.GetText());
           UpdateSLTPLines();  // Добавете тук
         }
            
         if(sparam == m_tpMoneyEdit.name)
         {
            m_tpMoney = StringToDouble(m_tpMoneyEdit.GetText());
            UpdateSLTPLines();  // Добавете тук
         }
            
         if(sparam == m_magicEdit.name)
            m_magic = (int)StringToInteger(m_magicEdit.GetText());
            
         if(sparam == m_riskPercentEdit.name)
         {
            m_riskPercent = StringToDouble(m_riskPercentEdit.GetText());
           UpdateSLTPLines();  // Добавете тук
         }
            
         if(sparam == m_riskMoneyEdit.name)
         {
            m_riskMoney = StringToDouble(m_riskMoneyEdit.GetText());
            UpdateSLTPLines();  // Добавете тук
         }
            
         return true;
      }
      
      return false;
   }
   
   void Update()
   {
      if(!m_isVisible) return;
      
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double spread = ask - bid;
      
      ObjectSetString(0, m_bidLabel, OBJPROP_TEXT, "Bid: " + DoubleToString(bid, _Digits));
      ObjectSetString(0, m_askLabel, OBJPROP_TEXT, "Ask: " + DoubleToString(ask, _Digits));
      ObjectSetString(0, m_spreadLabel, OBJPROP_TEXT, "Spread: " + DoubleToString(spread/_Point, 1));
      
      UpdateLines();
   }
   
      void Move(int x, int y)
   {
      m_x = x;
      m_y = y;
      
      if(m_isVisible)
      {
         ObjectSetInteger(0, m_panelName, OBJPROP_XDISTANCE, m_x);
         ObjectSetInteger(0, m_panelName, OBJPROP_YDISTANCE, m_y);
         
         // Обновяване позициите на бутоните
         int btnWidth = 60;
         int btnHeight = 20;
         int btnSpace = 5;
         int startX = 10;
         int startY = 25;
         int smallBtnWidth = 20;
         
         // Обновяване на бутоните
         m_buyBtn.Move(m_x + startX, m_y + startY);
         m_sellBtn.Move(m_x + startX + btnWidth + btnSpace, m_y + startY);
         m_closeBtn.Move(m_x + startX + (btnWidth + btnSpace) * 2, m_y + startY);
         m_buyLineBtn.Move(m_x + startX + (btnWidth + btnSpace) * 3, m_y + startY);
         m_sellLineBtn.Move(m_x + startX + (btnWidth + btnSpace) * 4, m_y + startY);
         
         // Обновяване на радио бутоните
         int radioStartY = m_y + 45;
         m_slTypeRadio.Move(m_x + 200, radioStartY + (btnHeight + 5) * 3);
         m_tpTypeRadio.Move(m_x + 200, radioStartY + (btnHeight + 5) * 4);
         m_riskTypeRadio.Move(m_x + 200, radioStartY + (btnHeight + 5) * 2);
         m_lotTypeRadio.Move(m_x + 200, radioStartY + (btnHeight + 5));
         
         // Обновяване на лейбълите
         ObjectSetInteger(0, m_symbolLabel, OBJPROP_XDISTANCE, m_x + 10);
         ObjectSetInteger(0, m_symbolLabel, OBJPROP_YDISTANCE, m_y + 5);
         ObjectSetInteger(0, m_bidLabel, OBJPROP_XDISTANCE, m_x + 90);
         ObjectSetInteger(0, m_bidLabel, OBJPROP_YDISTANCE, m_y + 5);
         ObjectSetInteger(0, m_askLabel, OBJPROP_XDISTANCE, m_x + 170);
         ObjectSetInteger(0, m_askLabel, OBJPROP_YDISTANCE, m_y + 5);
         ObjectSetInteger(0, m_spreadLabel, OBJPROP_XDISTANCE, m_x + m_width - 60);
         ObjectSetInteger(0, m_spreadLabel, OBJPROP_YDISTANCE, m_y + m_height - 15);
         
         // Обновяване на останалите контроли
         // ... можем да добавим и останалите контроли по същия начин
      }
   }
   
   
   
   // Getters
   bool IsVisible() const { return m_isVisible; }
   double GetLotSize() const { return m_lotSize; }
   double GetSLPips() const { return m_slPips; }
   double GetSLMoney() const { return m_slMoney; }
   double GetTPPips() const { return m_tpPips; }
   double GetTPMoney() const { return m_tpMoney; }
   double GetRiskPercent() const { return m_riskPercent; }
   double GetRiskMoney() const { return m_riskMoney; }
   int GetMagic() const { return m_magic; }
   bool IsSLShow() const { return m_slShow; }
   bool IsSLActive() const { return m_slActive; }
   bool IsSLHedge() const { return m_slHedge; }
   bool IsTPShow() const { return m_tpShow; }
   bool IsTPActive() const { return m_tpActive; }
   bool IsTPHedge() const { return m_tpHedge; }
   
   // Virtual методи за търговия
   virtual bool OnBuyClick() { return true; }
   virtual bool OnSellClick() { return true; }
   virtual bool OnCloseClick() { return true; }
};
   
   