//+------------------------------------------------------------------+
//|                                                    MainPanel.mqh    |
//|                                                          RexiBG    |
//|                                             2025-03-04 00:50:15    |
//+------------------------------------------------------------------+
#property copyright "RexiBG"

#include "TradePanel.mqh"

class CMainPanel
{
private:
   CTradePanel*      m_tradePanel;
   string            m_panelName;
   int               m_x;
   int               m_y;
   int               m_width;
   int               m_height;
   bool              m_isVisible;
   bool              m_tradePanelVisible;
   
   // Основни бутони в main панела
   SButton           m_tradeBtn;     // Бутон за търговия
   SButton           m_levelsBtn;    // Бутон за нива
   SButton           m_ordersBtn;    // Бутон за поръчки
   SButton           m_historyBtn;   // Бутон за история
   SButton           m_settingsBtn;  // Бутон за настройки

   void CreatePanel()
   {
      if(!ObjectCreate(0, m_panelName, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      {
         Print("Error creating main panel: ", GetLastError());
         return;
      }
      
      ObjectSetInteger(0, m_panelName, OBJPROP_XDISTANCE, m_x);
      ObjectSetInteger(0, m_panelName, OBJPROP_YDISTANCE, m_y);
      ObjectSetInteger(0, m_panelName, OBJPROP_XSIZE, m_width);
      ObjectSetInteger(0, m_panelName, OBJPROP_YSIZE, m_height);
      ObjectSetInteger(0, m_panelName, OBJPROP_BGCOLOR, clrWhiteSmoke);
      ObjectSetInteger(0, m_panelName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, m_panelName, OBJPROP_BORDER_COLOR, clrGray);
      ObjectSetInteger(0, m_panelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, m_panelName, OBJPROP_SELECTABLE, true);
   }
   
   void CreateButtons()
   {
      int btnWidth = 70;
      int btnHeight = 20;
      int btnSpace = 5;
      int startX = m_x + 10;
      int startY = m_y + 10;
      
      m_tradeBtn.Init("main", "TradeBtn", "Trade", 
                      startX, startY, 
                      btnWidth, btnHeight,
                      m_tradePanelVisible ? clrLightGray : clrWhite, clrBlack);
                      
      m_levelsBtn.Init("main", "LevelsBtn", "Levels",
                       startX + btnWidth + btnSpace, startY,
                       btnWidth, btnHeight,
                       clrWhite, clrBlack);
                       
      m_ordersBtn.Init("main", "OrdersBtn", "Orders",
                       startX + (btnWidth + btnSpace) * 2, startY,
                       btnWidth, btnHeight,
                       clrWhite, clrBlack);
                       
      m_historyBtn.Init("main", "HistoryBtn", "History",
                        startX + (btnWidth + btnSpace) * 3, startY,
                        btnWidth, btnHeight,
                        clrWhite, clrBlack);
                        
      m_settingsBtn.Init("main", "SettingsBtn", "Settings",
                         startX + (btnWidth + btnSpace) * 4, startY,
                         btnWidth, btnHeight,
                         clrWhite, clrBlack);
   }

public: CMainPanel()
   {
      m_panelName = "MainPanel";
      m_x = 20;
      m_y = 20;
      m_width = 400;
      m_height = 300;
      m_isVisible = false;
      m_tradePanelVisible = false;
      
      // Създаваме TradePanel с конкретни координати
      m_tradePanel = new CTradePanel(m_x + 10, m_y + 40);
   }

                    ~CMainPanel()
   {
      Hide();
      if(m_tradePanel != NULL)
      {
         delete m_tradePanel;
         m_tradePanel = NULL;
      }
   }
   
   void Show()
   {
      if(!m_isVisible)
      {
         CreatePanel();
         CreateButtons();
         m_isVisible = true;
         
         // Ако търговският панел е бил видим, показваме го отново
         if(m_tradePanelVisible && m_tradePanel != NULL)
         {
            m_tradePanel.Move(m_x + 10, m_y + 40);
            m_tradePanel.Show();
         }
      }
   }
   
   void Hide()
   {
      if(m_isVisible)
      {
         ObjectDelete(0, m_panelName);
         m_tradeBtn.Delete();
         m_levelsBtn.Delete();
         m_ordersBtn.Delete();
         m_historyBtn.Delete();
         m_settingsBtn.Delete();
         if(m_tradePanel != NULL)
            m_tradePanel.Hide();
         m_isVisible = false;
      }
   }
   
   void Move(int x, int y)
   {
      int dx = x - m_x;
      int dy = y - m_y;
      
      m_x = x;
      m_y = y;
      
      if(m_isVisible)
      {
         ObjectSetInteger(0, m_panelName, OBJPROP_XDISTANCE, m_x);
         ObjectSetInteger(0, m_panelName, OBJPROP_YDISTANCE, m_y);
         
         // Преместване на бутоните
         m_tradeBtn.Move(m_tradeBtn.x + dx, m_tradeBtn.y + dy);
         m_levelsBtn.Move(m_levelsBtn.x + dx, m_levelsBtn.y + dy);
         m_ordersBtn.Move(m_ordersBtn.x + dx, m_ordersBtn.y + dy);
         m_historyBtn.Move(m_historyBtn.x + dx, m_historyBtn.y + dy);
         m_settingsBtn.Move(m_settingsBtn.x + dx, m_settingsBtn.y + dy);
         
         // Преместване на търговския панел заедно с главния
         if(m_tradePanel != NULL && m_tradePanelVisible)
         {
            m_tradePanel.Move(m_x + 10, m_y + 40);
         }
      }
   }
   
   bool ProcessEvent(const int id,
                    const long &lparam,
                    const double &dparam,
                    const string &sparam)
   {
      if(!m_isVisible) return false;
      
      // Обработка на преместването на главния панел
      if(id == CHARTEVENT_OBJECT_DRAG)
      {
         if(sparam == m_panelName)
         {
            int x = (int)ObjectGetInteger(0, m_panelName, OBJPROP_XDISTANCE);
            int y = (int)ObjectGetInteger(0, m_panelName, OBJPROP_YDISTANCE);
            Move(x, y);
            return true;
         }
      }
      
      // Обработка на кликовете по бутоните
      if(id == CHARTEVENT_OBJECT_CLICK)
      {
         if(sparam == m_tradeBtn.name)
         {
            if(m_tradePanel != NULL)
            {
               m_tradePanelVisible = !m_tradePanelVisible;
               if(m_tradePanelVisible)
               {
                  m_tradePanel.Move(m_x + 10, m_y + 40);
                  m_tradePanel.Show();
                  m_tradeBtn.Init("main", "TradeBtn", "Trade", 
                                m_tradeBtn.x, m_tradeBtn.y,
                                m_tradeBtn.width, m_tradeBtn.height,
                                clrLightGray, clrBlack);
               }
               else
               {
                  m_tradePanel.Hide();
                  m_tradeBtn.Init("main", "TradeBtn", "Trade", 
                                m_tradeBtn.x, m_tradeBtn.y,
                                m_tradeBtn.width, m_tradeBtn.height,
                                clrWhite, clrBlack);
               }
            }
            return true;
         }
      }
      
      // Передаем события в торговую панель
      if(m_tradePanel != NULL && m_tradePanelVisible)
         return m_tradePanel.ProcessEvent(id, lparam, dparam, sparam);
         
      return false;
   }
   
   void Update()
   {
      if(m_tradePanel != NULL && m_tradePanelVisible)
         m_tradePanel.Update();
   }
};