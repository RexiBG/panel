//+------------------------------------------------------------------+
//|                                                         Main.mq5    |
//|                                                          RexiBG    |
//|                                             2025-03-03 23:41:13    |
//+------------------------------------------------------------------+
#property copyright "RexiBG"
#property link      ""
#property version   "1.00"
#property strict

#include "Base.mqh"

// Глобална променлива за основния клас
CBase* Program = NULL;

//+------------------------------------------------------------------+
//| Expert initialization function                                      |
//+------------------------------------------------------------------+
int OnInit()
{
   // Създаване на основния обект
   Program = new CBase();
   
   // Проверка за успешно създаване
   if(Program == NULL)
   {
      Print("Error: Failed to create program");
      return INIT_FAILED;
   }
   
   // Инициализация
   if(!Program.Init())
   {
      Print("Error: Failed to initialize program");
      delete Program;
      Program = NULL;
      return INIT_FAILED;
   }
   
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(Program != NULL)
   {
      Program.Deinit();
      delete Program;
      Program = NULL;
   }
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
   if(Program != NULL)
      Program.OnTick();
}

//+------------------------------------------------------------------+
//| ChartEvent function                                                |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(Program != NULL)
      Program.OnChartEvent(id, lparam, dparam, sparam);
}