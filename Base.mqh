//+------------------------------------------------------------------+
//|                                                          Base.mqh   |
//|                                                          RexiBG    |
//|                                             2025-03-03 21:27:45    |
//+------------------------------------------------------------------+
#property copyright "RexiBG"

#include <Trade\Trade.mqh>
#include <Trade\DealInfo.mqh>
#include "Levels.mqh"
#include "MainPanel.mqh"

class CBase
{
private:
   CTrade*           m_trade;
   CMainPanel*       m_mainPanel;
   
   string            m_symbol;
   ENUM_TIMEFRAMES   m_timeframe;
   
public:
                     CBase();
                    ~CBase();
   
   // Основни методи
   bool              Init();
   void              Deinit();
   void              OnTick();  // Декларация на OnTick метода
   
   // Event handlers
   void              OnChartEvent(const int id,
                                const long &lparam,
                                const double &dparam,
                                const string &sparam);
                                
   // Getters/Setters
   string            GetSymbol() const { return m_symbol; }
   ENUM_TIMEFRAMES   GetTimeframe() const { return m_timeframe; }
};

// Конструктор
CBase::CBase()
{
   m_trade = NULL;
   m_mainPanel = NULL;
   m_symbol = _Symbol;
   m_timeframe = PERIOD_CURRENT;
}

// Деструктор
CBase::~CBase()
{
   Deinit();
}

// Инициализация
bool CBase::Init()
{
   // Създаване на обектите
   m_trade = new CTrade();
   if(m_trade == NULL) return false;
   
   m_mainPanel = new CMainPanel();
   if(m_mainPanel == NULL) return false;
   
   // Показване на панела
   m_mainPanel.Show();  // Добавяме този ред
   
   return true;
}


// Деинициализация
void CBase::Deinit()
{
   if(m_trade != NULL)
   {
      delete m_trade;
      m_trade = NULL;
   }
   
   if(m_mainPanel != NULL)
   {
      delete m_mainPanel;
      m_mainPanel = NULL;
   }
}

// OnTick имплементация
void CBase::OnTick()
{
   if(m_mainPanel != NULL)
      m_mainPanel.Update();
}

// OnChartEvent имплементация
void CBase::OnChartEvent(const int id,
                        const long &lparam,
                        const double &dparam,
                        const string &sparam)
{
   if(m_mainPanel != NULL)
      m_mainPanel.ProcessEvent(id, lparam, dparam, sparam);
}

