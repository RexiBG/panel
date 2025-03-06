//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 15:45:36 |
//+------------------------------------------------------------------+

// ЧАСТ 1 - ДЕКЛАРАЦИИ И КОНСТРУКТОР
#property copyright "RexiBG"


#include "Button.mqh"
#include "TrendLines.mqh"
#include "RadioGroup.mqh"
#include "Calculator2.mqh"

class CTradePanel
{
private:
    // Panel parameters
    string      m_prefix;
    int         m_magic;
    int         m_x;
    int         m_y; 
    int         m_width;
    int         m_height;
    color       m_bgColor;
    bool        m_isVisible;
    string      m_symbol;
    
    CButton     m_riskPercentEdit;
    CButton     m_riskMoneyEdit;
    
    CButton     m_buyBtn;
    CButton     m_sellBtn;
    CButton     m_closeBtn;
    CButton     m_buyLineBtn;
    CButton     m_sellLineBtn;
    
    CButton     m_lotEdit;
    CButton     m_lotUpBtn;
    CButton     m_lotDownBtn;
    
    CButton     m_slPipsEdit;
    CButton     m_slMoneyEdit;
    CButton     m_slShowBtn;
    CButton     m_slActiveBtn;
    CButton     m_slHedgeBtn;
    
    CButton     m_tpPipsEdit;
    CButton     m_tpMoneyEdit;
    CButton     m_tpShowBtn;
    CButton     m_tpActiveBtn;
    CButton     m_tpHedgeBtn;

    CRadioGroup m_slTypeRadio;
    CRadioGroup m_tpTypeRadio;
    CRadioGroup m_riskTypeRadio;
    CRadioGroup m_lotTypeRadio;
    
    // Visual lines
    STrendLine  m_buyLine;
    STrendLine  m_sellLine;
    STrendLine  m_slLine;
    STrendLine  m_tpLine;
    
    // Stop loss buttons
    CButton     m_slPipsEdit;
    CButton     m_slMoneyEdit;
    CButton     m_slShowBtn;
    CButton     m_slActiveBtn;
    CButton     m_slHedgeBtn;
    
    // Take profit buttons
    CButton     m_tpPipsEdit;
    CButton     m_tpMoneyEdit;
    CButton     m_tpShowBtn;
    CButton     m_tpActiveBtn;
    CButton     m_tpHedgeBtn;
    
    // Trading calculator
    CCalculator2 m_calculator;
    
    // Trading parameters
    double      m_lotSize;
    double      m_slPips;
    double      m_slMoney;
    double      m_tpPips;
    double      m_tpMoney;
    double      m_riskPercent;
    double      m_riskMoney;
    
    // States
    bool        m_slShow;
    bool        m_slActive;
    bool        m_slHedge;
    bool        m_tpShow;
    bool        m_tpActive;
    bool        m_tpHedge;

public:
    CTradePanel()
    {
        m_isVisible = true;
        m_bgColor = clrWhiteSmoke;
        m_symbol = Symbol();
        
        m_lotSize = 0.1;
        m_slPips = 50;
        m_slMoney = 50;
        m_tpPips = 100;
        m_tpMoney = 100;
        m_riskPercent = 1;
        m_riskMoney = 100;
        
        m_slShow = false;
        m_slActive = false;
        m_slHedge = false;
        m_tpShow = false;
        m_tpActive = false;
        m_tpHedge = false;
    }
    
    bool Create(string prefix, int magic, int x, int y)
    {
        m_prefix = prefix;
        m_magic = magic;
        m_x = x;
        m_y = y;
        m_width = 200;
        m_height = 400;
        
        // Инициализация на калкулатора
        m_calculator.Init(m_symbol);
        
        CreateBackground();
        CreateButtons();
        CreateRadioGroups();
        CreateTrendLines();
        
        return true;
    }
    
    void Delete()
    {
        DeleteBackground();
        DeleteButtons();
        DeleteRadioGroups();
        DeleteTrendLines();
    }
    
    void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
    {
        if(id == CHARTEVENT_OBJECT_CLICK)
        {
            ProcessButtonClick(sparam);
        }
        else if(id == CHARTEVENT_OBJECT_DRAG)
        {
            ProcessLineDrag(sparam);
        }
    }

private:
    void CreateBackground()
    {
        string name = m_prefix + "BG";
        ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_x);
        ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_y);
        ObjectSetInteger(0, name, OBJPROP_XSIZE, m_width);
        ObjectSetInteger(0, name, OBJPROP_YSIZE, m_height);
        ObjectSetInteger(0, name, OBJPROP_BGCOLOR, m_bgColor);
        ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
        ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    }
    
    void CreateButtons()
    {
        // Buy/Sell buttons
        m_buyBtn.Create(m_prefix+"Buy", "Buy", m_x+10, m_y+10, 80, 30);
        m_sellBtn.Create(m_prefix+"Sell", "Sell", m_x+110, m_y+10, 80, 30);
        
        // Close button
        m_closeBtn.Create(m_prefix+"Close", "Close", m_x+60, m_y+50, 80, 30);
        
        // Buy/Sell line buttons
        m_buyLineBtn.Create(m_prefix+"BuyLine", "Buy Line", m_x+10, m_y+90, 80, 20);
        m_sellLineBtn.Create(m_prefix+"SellLine", "Sell Line", m_x+110, m_y+90, 80, 20);
        
        // Risk management buttons
        m_riskPercentEdit.Create(m_prefix+"RiskPercent", "1%", m_x+10, m_y+120, 60, 20);
        m_riskMoneyEdit.Create(m_prefix+"RiskMoney", "$100", m_x+80, m_y+120, 60, 20);
        
        // Lot management buttons
        m_lotEdit.Create(m_prefix+"Lot", "0.1", m_x+10, m_y+150, 60, 20);
        m_lotUpBtn.Create(m_prefix+"LotUp", "+", m_x+80, m_y+150, 30, 20);
        m_lotDownBtn.Create(m_prefix+"LotDown", "-", m_x+120, m_y+150, 30, 20);
        
        // Stop loss buttons
        m_slPipsEdit.Create(m_prefix+"SLPips", "50p", m_x+10, m_y+180, 60, 20);
        m_slMoneyEdit.Create(m_prefix+"SLMoney", "$50", m_x+80, m_y+180, 60, 20);
        m_slShowBtn.Create(m_prefix+"SLShow", "Show", m_x+150, m_y+180, 40, 20);
        m_slActiveBtn.Create(m_prefix+"SLActive", "Active", m_x+10, m_y+210, 60, 20);
        m_slHedgeBtn.Create(m_prefix+"SLHedge", "Hedge", m_x+80, m_y+210, 60, 20);
        
        // Take profit buttons
        m_tpPipsEdit.Create(m_prefix+"TPPips", "100p", m_x+10, m_y+240, 60, 20);
        m_tpMoneyEdit.Create(m_prefix+"TPMoney", "$100", m_x+80, m_y+240, 60, 20);
        m_tpShowBtn.Create(m_prefix+"TPShow", "Show", m_x+150, m_y+240, 40, 20);
        m_tpActiveBtn.Create(m_prefix+"TPActive", "Active", m_x+10, m_y+270, 60, 20);
        m_tpHedgeBtn.Create(m_prefix+"TPHedge", "Hedge", m_x+80, m_y+270, 60, 20);
    }
    
    void CreateRadioGroups()
    {
        // SL type radio group
        m_slTypeRadio.Create(m_prefix+"SLType", m_x+10, m_y+300, 180, 40);
        m_slTypeRadio.AddItems("Pips", "Money");
        
        // TP type radio group
        m_tpTypeRadio.Create(m_prefix+"TPType", m_x+10, m_y+350, 180, 40);
        m_tpTypeRadio.AddItems("Pips", "Money");
        
        // Risk type radio group
        m_riskTypeRadio.Create(m_prefix+"RiskType", m_x+10, m_y+400, 180, 40);
        m_riskTypeRadio.AddItems("Percent", "Fixed");
        
        // Lot type radio group
        m_lotTypeRadio.Create(m_prefix+"LotType", m_x+10, m_y+450, 180, 40);
        m_lotTypeRadio.AddItems("Risk", "Fixed");
    }
    
    void CreateTrendLines()
    {
        m_buyLine.Create(m_prefix+"BuyLine", clrBlue);
        m_sellLine.Create(m_prefix+"SellLine", clrRed);
        m_slLine.Create(m_prefix+"SLLine", clrOrange);
        m_tpLine.Create(m_prefix+"TPLine", clrGreen);
    }
    
    void DeleteBackground()
    {
        ObjectDelete(0, m_prefix+"BG");
    }
    
    void DeleteButtons()
    {
        m_buyBtn.Delete();
        m_sellBtn.Delete();
        m_closeBtn.Delete();
        m_buyLineBtn.Delete();
        m_sellLineBtn.Delete();
        m_riskPercentEdit.Delete();
        m_riskMoneyEdit.Delete();
        m_lotEdit.Delete();
        m_lotUpBtn.Delete();
        m_lotDownBtn.Delete();
        m_slPipsEdit.Delete();
        m_slMoneyEdit.Delete();
        m_slShowBtn.Delete();
        m_slActiveBtn.Delete();
        m_slHedgeBtn.Delete();
        m_tpPipsEdit.Delete();
        m_tpMoneyEdit.Delete();
        m_tpShowBtn.Delete();
        m_tpActiveBtn.Delete();
        m_tpHedgeBtn.Delete();
    }
    
    void DeleteRadioGroups()
    {
        m_slTypeRadio.Delete();
        m_tpTypeRadio.Delete();
        m_riskTypeRadio.Delete();
        m_lotTypeRadio.Delete();
    }
    
    void DeleteTrendLines()
    {
        m_buyLine.Delete();
        m_sellLine.Delete();
        m_slLine.Delete();
        m_tpLine.Delete();
    }
    

    CTradePanel(string prefix="RexiBG_")
    {
        m_prefix = prefix;
        m_x = 20;
        m_y = 60;
        m_width = 700;
        m_height = 600;
        m_bgColor = clrWhiteSmoke;
        m_isVisible = false;
        
        m_calculator.Init();
        
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
        
        m_symbol = Symbol();
        
        ClearAllPanelObjects();
    }

// ЧАСТ 2 - ОСНОВНИ МЕТОДИ ЗА ПАНЕЛА
    void ClearAllPanelObjects()
    {
        Print("=== Изтриване на всички trade panel обекти ===");
        ObjectsDeleteAll(0, m_prefix);
        ChartRedraw(0);
        Sleep(100);
    }

    void CreatePanel()
    {
        Print("=== Започва създаване на панел ===");
        
        ClearAllPanelObjects();
        
        if(!m_isVisible)
        {
            Print("Panel is not visible, stopping creation");
            return;
        }
        
        m_panelName = m_prefix + "Panel";
        
        if(ObjectFind(0, m_panelName) >= 0)
        {
            ObjectDelete(0, m_panelName);
        }
        
        if(!ObjectCreate(0, m_panelName, OBJ_RECTANGLE_LABEL, 0, 0, 0))
        {
            Print("Error creating panel: ", GetLastError());
            return;
        }
        
        ObjectSetInteger(0, m_panelName, OBJPROP_XDISTANCE, m_x);
        ObjectSetInteger(0, m_panelName, OBJPROP_YDISTANCE, m_y);
        ObjectSetInteger(0, m_panelName, OBJPROP_XSIZE, m_width);
        ObjectSetInteger(0, m_panelName, OBJPROP_YSIZE, m_height);
        ObjectSetInteger(0, m_panelName, OBJPROP_BGCOLOR, m_bgColor);
        ObjectSetInteger(0, m_panelName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
        ObjectSetInteger(0, m_panelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, m_panelName, OBJPROP_ZORDER, 0);

        CreateButtons();
        CreateLabels();
        CreateTrendLines();
        CreateRadioButtons();
    }

// ЧАСТ 3 - МЕТОДИ ЗА СЪЗДАВАНЕ НА БУТОНИ
    void CreateButtons()
    {
        int x = m_x + 10;
        int y = m_y + 10;
        int btnWidth = 60;
        int btnHeight = 20;
        
        // Основни бутони за търговия
        m_buyBtn.Create(m_prefix+"Buy", "Buy", x, y, 
                        btnWidth, btnHeight, 
                        clrWhite, clrDodgerBlue);
        
        x += btnWidth + 5;
        m_sellBtn.Create(m_prefix+"Sell", "Sell", x, y, 
                         btnWidth, btnHeight, 
                         clrWhite, clrCrimson);
        
        x += btnWidth + 5;
        m_closeBtn.Create(m_prefix+"Close", "Close", x, y, 
                          btnWidth, btnHeight, 
                          clrWhite, clrDimGray);
        
        x = m_x + 10;
        y += btnHeight + 5;
        
        m_buyLineBtn.Create(m_prefix+"BLine", "B line", x, y, 
                            btnWidth, btnHeight, 
                            clrWhite, clrDodgerBlue);
        
        x += btnWidth + 5;
        m_sellLineBtn.Create(m_prefix+"SLine", "S line", x, y, 
                             btnWidth, btnHeight, 
                             clrWhite, clrCrimson);
    }

//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 14:58:44 |
//+------------------------------------------------------------------+

// ЧАСТ 4 - МЕТОДИ ЗА СЪЗДАВАНЕ НА ЕТИКЕТИ И ЛИНИИ

void CreateLabels()
{
    int x = m_x + m_width - 150;
    int y = m_y + 10;
    
    // Създаване на информационни етикети
    CreateLabel(m_symbolLabel, m_prefix+"Symbol", "Symbol: "+_Symbol, x, y);
    y += 20;
    CreateLabel(m_bidLabel, m_prefix+"Bid", "Bid: ", x, y);
    y += 20;
    CreateLabel(m_askLabel, m_prefix+"Ask", "Ask: ", x, y);
    y += 20;
    CreateLabel(m_spreadLabel, m_prefix+"Spread", "Spread: ", x, y);
}

void CreateLabel(string &label, string name, string text, int x, int y)
{
    label = name;
    if(ObjectFind(0, label) >= 0)
        ObjectDelete(0, label);
        
    if(!ObjectCreate(0, label, OBJ_LABEL, 0, 0, 0))
    {
        Print("Error creating label: ", GetLastError());
        return;
    }
    
    ObjectSetString(0, label, OBJPROP_TEXT, text);
    ObjectSetInteger(0, label, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, label, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, label, OBJPROP_COLOR, clrBlack);
    ObjectSetInteger(0, label, OBJPROP_CORNER, CORNER_LEFT_UPPER);
}

void CreateTrendLines()
{
    // Инициализация на Buy линия
    m_buyLine.Init(m_prefix, "BuyLine", clrDodgerBlue);
    
    // Инициализация на Sell линия
    m_sellLine.Init(m_prefix, "SellLine", clrCrimson);
    
    // Инициализация на SL линия
    m_slLine.Init(m_prefix, "SLLine", clrFireBrick);
    
    // Инициализация на TP линия
    m_tpLine.Init(m_prefix, "TPLine", clrForestGreen);
}

void CreateRadioButtons()
{
    int x = m_x + 10;
    int y = m_y + 130;
    int btnWidth = 60;
    int btnHeight = 20;
    
    // SL тип (пипс/сума)
    m_slTypeRadio.Create(m_prefix+"SLType", "Pips|Money", x, y, btnWidth*2, btnHeight);
    m_slTypeRadio.state1 = true;  // По подразбиране избираме пипсове
    
    // TP тип (пипс/сума)
    x += btnWidth*2 + 20;
    m_tpTypeRadio.Create(m_prefix+"TPType", "Pips|Money", x, y, btnWidth*2, btnHeight);
    m_tpTypeRadio.state1 = true;  // По подразбиране избираме пипсове
    
    // Risk тип (процент/сума)
    y += btnHeight + 5;
    x = m_x + 10;
    m_riskTypeRadio.Create(m_prefix+"RiskType", "%|$", x, y, btnWidth*2, btnHeight);
    m_riskTypeRadio.state1 = true;  // По подразбиране избираме процент
    
    // Lot тип (риск/фиксиран)
    x += btnWidth*2 + 20;
    m_lotTypeRadio.Create(m_prefix+"LotType", "Risk|Fixed", x, y, btnWidth*2, btnHeight);
    m_lotTypeRadio.state1 = true;  // По подразбиране избираме риск
}
//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 14:59:51 |
//+------------------------------------------------------------------+

// ЧАСТ 5 - МЕТОДИ ЗА ОБНОВЯВАНЕ И СЪБИТИЯ

void UpdateLabels()
{
    if(!m_isVisible) return;
    
    // Обновяване на цените
    double bid = SymbolInfoDouble(m_symbol, SYMBOL_BID);
    double ask = SymbolInfoDouble(m_symbol, SYMBOL_ASK);
    double spread = (ask - bid) / _Point;
    
    // Форматиране на текста с правилния брой десетични знаци
    int digits = (int)SymbolInfoInteger(m_symbol, SYMBOL_DIGITS);
    string bidStr = DoubleToString(bid, digits);
    string askStr = DoubleToString(ask, digits);
    
    // Обновяване на етикетите
    ObjectSetString(0, m_symbolLabel, OBJPROP_TEXT, "Symbol: " + m_symbol);
    ObjectSetString(0, m_bidLabel, OBJPROP_TEXT, "Bid: " + bidStr);
    ObjectSetString(0, m_askLabel, OBJPROP_TEXT, "Ask: " + askStr);
    ObjectSetString(0, m_spreadLabel, OBJPROP_TEXT, "Spread: " + DoubleToString(spread, 1));
}

void UpdateLineStates()
{
    if(!m_isVisible) return;
    
    // Обновяване на видимостта на линиите според бутоните
    m_buyLine.SetVisible(m_buyLineBtn.GetState());
    m_sellLine.SetVisible(m_sellLineBtn.GetState());
    m_slLine.SetVisible(m_slShowBtn.GetState());
    m_tpLine.SetVisible(m_tpShowBtn.GetState());
    
    // Обновяване на активността на линиите
    m_slLine.SetActive(m_slActiveBtn.GetState());
    m_tpLine.SetActive(m_tpActiveBtn.GetState());
}

bool OnEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
    // Проверка за натиснат бутон
    if(id == CHARTEVENT_OBJECT_CLICK)
    {
        if(StringFind(sparam, m_prefix) == 0)
        {
            ProcessButtonClick(sparam);
            return true;
        }
    }
    
    // Проверка за движение на линия
    if(id == CHARTEVENT_OBJECT_DRAG)
    {
        if(StringFind(sparam, m_prefix) == 0)
        {
            ProcessLineDrag(sparam);
            return true;
        }
    }
    
    return false;
}

void ProcessButtonClick(string clickedObject)
{
    // Buy бутон
    if(clickedObject == m_prefix+"Buy")
    {
        ExecuteBuy();
        return;
    }
    
    // Sell бутон
    if(clickedObject == m_prefix+"Sell")
    {
        ExecuteSell();
        return;
    }
    
    // Close бутон
    if(clickedObject == m_prefix+"Close")
    {
        CloseAllPositions();
        return;
    }
    
    // Buy Line бутон
    if(clickedObject == m_prefix+"BLine")
    {
        m_buyLineBtn.Toggle();
        UpdateLineStates();
        return;
    }
    
    // Sell Line бутон
    if(clickedObject == m_prefix+"SLine")
    {
        m_sellLineBtn.Toggle();
        UpdateLineStates();
        return;
    }
}
//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 15:00:29 |
//+------------------------------------------------------------------+

// ЧАСТ 6 - МЕТОДИ ЗА ТЪРГОВСКИ ОПЕРАЦИИ

void ExecuteBuy()
{
    double entry = SymbolInfoDouble(m_symbol, SYMBOL_ASK);
    double sl = 0, tp = 0;
    
    // Изчисляване на SL ако е активен
    if(m_slActive)
    {
        if(m_slTypeRadio.state1)  // Пипсове
        {
            sl = entry - m_slPips * _Point;
        }
        else  // Пари
        {
            sl = m_calculator.CalculateBuyStopLoss(entry, m_slMoney, m_lotSize);
        }
    }
    
    // Изчисляване на TP ако е активен
    if(m_tpActive)
    {
        if(m_tpTypeRadio.state1)  // Пипсове
        {
            tp = entry + m_tpPips * _Point;
        }
        else  // Пари
        {
            tp = m_calculator.CalculateBuyTakeProfit(entry, m_tpMoney, m_lotSize);
        }
    }
    
    // Изпращане на поръчката
    MqlTradeRequest request = {};
    request.action = TRADE_ACTION_DEAL;
    request.symbol = m_symbol;
    request.volume = m_lotSize;
    request.type = ORDER_TYPE_BUY;
    request.price = entry;
    request.sl = sl;
    request.tp = tp;
    request.deviation = 5;
    request.magic = m_magic;
    request.comment = m_prefix+"Buy";
    request.type_filling = ORDER_FILLING_FOK;
    
    MqlTradeResult result = {};
    bool success = OrderSend(request, result);
    
    if(!success)
    {
        Print("Buy order failed. Error: ", GetLastError());
        return;
    }
    
    // Ако поръчката е успешна и имаме активен hedge
    if(success && m_slHedge && m_slActive)
    {
        PlaceHedgeOrder(true, entry, sl);
    }
}

void ExecuteSell()
{
    double entry = SymbolInfoDouble(m_symbol, SYMBOL_BID);
    double sl = 0, tp = 0;
    
    // Изчисляване на SL ако е активен
    if(m_slActive)
    {
        if(m_slTypeRadio.state1)  // Пипсове
        {
            sl = entry + m_slPips * _Point;
        }
        else  // Пари
        {
            sl = m_calculator.CalculateSellStopLoss(entry, m_slMoney, m_lotSize);
        }
    }
    
    // Изчисляване на TP ако е активен
    if(m_tpActive)
    {
        if(m_tpTypeRadio.state1)  // Пипсове
        {
            tp = entry - m_tpPips * _Point;
        }
        else  // Пари
        {
            tp = m_calculator.CalculateSellTakeProfit(entry, m_tpMoney, m_lotSize);
        }
    }
    
    // Изпращане на поръчката
    MqlTradeRequest request = {};
    request.action = TRADE_ACTION_DEAL;
    request.symbol = m_symbol;
    request.volume = m_lotSize;
    request.type = ORDER_TYPE_SELL;
    request.price = entry;
    request.sl = sl;
    request.tp = tp;
    request.deviation = 5;
    request.magic = m_magic;
    request.comment = m_prefix+"Sell";
    request.type_filling = ORDER_FILLING_FOK;
    
    MqlTradeResult result = {};
    bool success = OrderSend(request, result);
    
    if(!success)
    {
        Print("Sell order failed. Error: ", GetLastError());
        return;
    }
    
    // Ако поръчката е успешна и имаме активен hedge
    if(success && m_slHedge && m_slActive)
    {
        PlaceHedgeOrder(false, entry, sl);
    }
}
//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 15:03:04 |
//+------------------------------------------------------------------+

// ЧАСТ 7 - СПОМАГАТЕЛНИ МЕТОДИ ЗА ТЪРГОВИЯ

void PlaceHedgeOrder(bool isBuy, double entryPrice, double stopPrice)
{
    double hedgeLot = m_lotSize;
    
    MqlTradeRequest request = {};
    request.action = TRADE_ACTION_DEAL;
    request.symbol = m_symbol;
    request.volume = hedgeLot;
    request.type = isBuy ? ORDER_TYPE_SELL_STOP : ORDER_TYPE_BUY_STOP;
    request.price = stopPrice;
    request.deviation = 5;
    request.magic = m_magic;
    request.comment = m_prefix + (isBuy ? "HedgeSell" : "HedgeBuy");
    request.type_filling = ORDER_FILLING_FOK;
    
    MqlTradeResult result = {};
    bool success = OrderSend(request, result);
    
    if(!success)
    {
        Print("Hedge order failed. Error: ", GetLastError());
    }
}

void CloseAllPositions()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionSelectByTicket(PositionGetTicket(i)))
        {
            if(PositionGetString(POSITION_SYMBOL) == m_symbol && 
               PositionGetInteger(POSITION_MAGIC) == m_magic)
            {
                MqlTradeRequest request = {};
                request.action = TRADE_ACTION_DEAL;
                request.symbol = m_symbol;
                request.volume = PositionGetDouble(POSITION_VOLUME);
                request.type = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? 
                             ORDER_TYPE_SELL : ORDER_TYPE_BUY;
                request.price = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? 
                              SymbolInfoDouble(m_symbol, SYMBOL_BID) : 
                              SymbolInfoDouble(m_symbol, SYMBOL_ASK);
                request.deviation = 5;
                request.magic = m_magic;
                request.position = PositionGetTicket(i);
                request.comment = m_prefix+"Close";
                
                MqlTradeResult result = {};
                OrderSend(request, result);
            }
        }
    }
    
    // Отмяна на всички отворени поръчки
    for(int i = OrdersTotal() - 1; i >= 0; i--)
    {
        if(OrderSelect(OrderGetTicket(i)))
        {
            if(OrderGetString(ORDER_SYMBOL) == m_symbol && 
               OrderGetInteger(ORDER_MAGIC) == m_magic)
            {
                MqlTradeRequest request = {};
                request.action = TRADE_ACTION_REMOVE;
                request.order = OrderGetTicket(i);
                
                MqlTradeResult result = {};
                OrderSend(request, result);
            }
        }
    }
}

void ProcessLineDrag(string draggedObject)
{
    // Buy линия
    if(draggedObject == m_prefix+"BuyLine")
    {
        if(m_buyLine.IsVisible())
        {
            UpdateOrdersFromLine(true);
        }
        return;
    }
    
    // Sell линия
    if(draggedObject == m_prefix+"SellLine")
    {
        if(m_sellLine.IsVisible())
        {
            UpdateOrdersFromLine(false);
        }
        return;
    }
    
    // SL линия
    if(draggedObject == m_prefix+"SLLine")
    {
        if(m_slLine.IsVisible() && m_slLine.IsActive())
        {
            UpdateStopLoss();
        }
        return;
    }
    
    // TP линия
    if(draggedObject == m_prefix+"TPLine")
    {
        if(m_tpLine.IsVisible() && m_tpLine.IsActive())
        {
            UpdateTakeProfit();
        }
        return;
    }
}
//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 15:03:44 |
//+------------------------------------------------------------------+

// ЧАСТ 8 - МЕТОДИ ЗА ОБНОВЯВАНЕ НА ПОРЪЧКИ

void UpdateOrdersFromLine(bool isBuy)
{
    double price = isBuy ? m_buyLine.GetPrice() : m_sellLine.GetPrice();
    
    // Търсим съществуващи поръчки със същия тип
    for(int i = OrdersTotal() - 1; i >= 0; i--)
    {
        if(OrderSelect(OrderGetTicket(i)))
        {
            if(OrderGetString(ORDER_SYMBOL) == m_symbol && 
               OrderGetInteger(ORDER_MAGIC) == m_magic)
            {
                ENUM_ORDER_TYPE type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
                if((isBuy && (type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_BUY_LIMIT)) ||
                   (!isBuy && (type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_SELL_LIMIT)))
                {
                    ModifyOrder(OrderGetTicket(i), price);
                    return;
                }
            }
        }
    }
    
    // Ако няма съществуваща поръчка, създаваме нова
    PlacePendingOrder(isBuy, price);
}

void ModifyOrder(ulong ticket, double price)
{
    MqlTradeRequest request = {};
    request.action = TRADE_ACTION_MODIFY;
    request.order = ticket;
    request.price = price;
    
    MqlTradeResult result = {};
    if(!OrderSend(request, result))
    {
        Print("Order modify failed. Error: ", GetLastError());
    }
}

void PlacePendingOrder(bool isBuy, double price)
{
    double currentPrice = isBuy ? 
                         SymbolInfoDouble(m_symbol, SYMBOL_ASK) : 
                         SymbolInfoDouble(m_symbol, SYMBOL_BID);
    
    ENUM_ORDER_TYPE orderType;
    if(isBuy)
    {
        orderType = price > currentPrice ? ORDER_TYPE_BUY_STOP : ORDER_TYPE_BUY_LIMIT;
    }
    else
    {
        orderType = price < currentPrice ? ORDER_TYPE_SELL_STOP : ORDER_TYPE_SELL_LIMIT;
    }
    
    MqlTradeRequest request = {};
    request.action = TRADE_ACTION_PENDING;
    request.symbol = m_symbol;
    request.volume = m_lotSize;
    request.type = orderType;
    request.price = price;
    request.deviation = 5;
    request.magic = m_magic;
    request.comment = m_prefix + (isBuy ? "BuyPending" : "SellPending");
    request.type_filling = ORDER_FILLING_FOK;
    
    if(m_slActive)
    {
        double sl = isBuy ? price - m_slPips * _Point : price + m_slPips * _Point;
        request.sl = sl;
    }
    
    if(m_tpActive)
    {
        double tp = isBuy ? price + m_tpPips * _Point : price - m_tpPips * _Point;
        request.tp = tp;
    }
    
    MqlTradeResult result = {};
    if(!OrderSend(request, result))
    {
        Print("Pending order placement failed. Error: ", GetLastError());
    }
}
//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 15:04:24 |
//+------------------------------------------------------------------+

// ЧАСТ 9 - МЕТОДИ ЗА ОБНОВЯВАНЕ НА SL/TP

void UpdateStopLoss()
{
    double slPrice = m_slLine.GetPrice();
    
    // Обновяване на SL за отворени позиции
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionSelectByTicket(PositionGetTicket(i)))
        {
            if(PositionGetString(POSITION_SYMBOL) == m_symbol && 
               PositionGetInteger(POSITION_MAGIC) == m_magic)
            {
                ModifyPosition(PositionGetTicket(i), slPrice, PositionGetDouble(POSITION_TP));
            }
        }
    }
    
    // Обновяване на SL за чакащи поръчки
    for(int i = OrdersTotal() - 1; i >= 0; i--)
    {
        if(OrderSelect(OrderGetTicket(i)))
        {
            if(OrderGetString(ORDER_SYMBOL) == m_symbol && 
               OrderGetInteger(ORDER_MAGIC) == m_magic)
            {
                ModifyOrder(OrderGetTicket(i), OrderGetDouble(ORDER_PRICE), slPrice, OrderGetDouble(ORDER_TP));
            }
        }
    }
}

void UpdateTakeProfit()
{
    double tpPrice = m_tpLine.GetPrice();
    
    // Обновяване на TP за отворени позиции
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionSelectByTicket(PositionGetTicket(i)))
        {
            if(PositionGetString(POSITION_SYMBOL) == m_symbol && 
               PositionGetInteger(POSITION_MAGIC) == m_magic)
            {
                ModifyPosition(PositionGetTicket(i), PositionGetDouble(POSITION_SL), tpPrice);
            }
        }
    }
    
    // Обновяване на TP за чакащи поръчки
    for(int i = OrdersTotal() - 1; i >= 0; i--)
    {
        if(OrderSelect(OrderGetTicket(i)))
        {
            if(OrderGetString(ORDER_SYMBOL) == m_symbol && 
               OrderGetInteger(ORDER_MAGIC) == m_magic)
            {
                ModifyOrder(OrderGetTicket(i), OrderGetDouble(ORDER_PRICE), OrderGetDouble(ORDER_SL), tpPrice);
            }
        }
    }
}

void ModifyPosition(ulong ticket, double sl, double tp)
{
    MqlTradeRequest request = {};
    request.action = TRADE_ACTION_SLTP;
    request.symbol = m_symbol;
    request.sl = sl;
    request.tp = tp;
    request.position = ticket;
    
    MqlTradeResult result = {};
    if(!OrderSend(request, result))
    {
        Print("Position modify failed. Error: ", GetLastError());
    }
}

void ModifyOrder(ulong ticket, double price, double sl, double tp)
{
    MqlTradeRequest request = {};
    request.action = TRADE_ACTION_MODIFY;
    request.order = ticket;
    request.price = price;
    request.sl = sl;
    request.tp = tp;
    
    MqlTradeResult result = {};
    if(!OrderSend(request, result))
    {
        Print("Order modify failed. Error: ", GetLastError());
    }
}
//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 15:05:00 |
//+------------------------------------------------------------------+

// ЧАСТ 10 - МЕТОДИ ЗА УПРАВЛЕНИЕ НА ПАНЕЛА И ИНТЕРФЕЙСА

void Show()
{
    m_isVisible = true;
    CreatePanel();
}

void Hide()
{
    m_isVisible = false;
    ClearAllPanelObjects();
}

void Move(int x, int y)
{
    m_x = x;
    m_y = y;
    if(m_isVisible)
    {
        CreatePanel();
    }
}

void Resize(int width, int height)
{
    m_width = width;
    m_height = height;
    if(m_isVisible)
    {
        CreatePanel();
    }
}

void SetSymbol(string symbol)
{
    if(SymbolSelect(symbol, true))
    {
        m_symbol = symbol;
        if(m_isVisible)
        {
            UpdateLabels();
        }
    }
}

void SetLotSize(double lotSize)
{
    double minLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MAX);
    double stepLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);
    
    // Нормализиране на размера на лота
    lotSize = MathRound(lotSize / stepLot) * stepLot;
    
    // Проверка за граници
    if(lotSize < minLot) lotSize = minLot;
    if(lotSize > maxLot) lotSize = maxLot;
    
    m_lotSize = lotSize;
}

void IncreaseLot()
{
    double step = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);
    SetLotSize(m_lotSize + step);
}

void DecreaseLot()
{
    double step = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);
    SetLotSize(m_lotSize - step);
}

void CalculateRiskLot()
{
    if(!m_slActive) return;
    
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount;
    
    if(m_riskTypeRadio.state1)  // Процент
    {
        riskAmount = accountBalance * m_riskPercent / 100.0;
    }
    else  // Фиксирана сума
    {
        riskAmount = m_riskMoney;
    }
    
    // Изчисляване на лота базирано на риска
    if(m_slTypeRadio.state1)  // Пипсове
    {
        m_lotSize = m_calculator.CalculateLotSize(m_symbol, m_slPips, riskAmount);
    }
    else  // Пари
    {
        m_lotSize = m_calculator.CalculateLotSizeByMoney(m_symbol, m_slMoney, riskAmount);
    }
    
    SetLotSize(m_lotSize);  // Нормализиране на стойността
}
//+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 15:05:34 |
//+------------------------------------------------------------------+

// ЧАСТ 11 - МЕТОДИ ЗА ДОСТЪП И ПРОМЯНА НА ПАРАМЕТРИ

public:
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
    
    bool IsSLActive() const { return m_slActive; }
    bool IsTPActive() const { return m_tpActive; }
    bool IsSLHedge() const { return m_slHedge; }
    bool IsTPHedge() const { return m_tpHedge; }
    
    // Setters
    void SetSLPips(double pips) { m_slPips = pips; }
    void SetSLMoney(double money) { m_slMoney = money; }
    void SetTPPips(double pips) { m_tpPips = pips; }
    void SetTPMoney(double money) { m_tpMoney = money; }
    void SetRiskPercent(double percent) { m_riskPercent = percent; }
    void SetRiskMoney(double money) { m_riskMoney = money; }
    void SetMagic(int magic) { m_magic = magic; }
    
    void SetSLActive(bool active) { m_slActive = active; }
    void SetTPActive(bool active) { m_tpActive = active; }
    void SetSLHedge(bool hedge) { m_slHedge = hedge; }
    void SetTPHedge(bool hedge) { m_tpHedge = hedge; }

    // Методи за достъп до линиите
    double GetBuyLinePrice() const { return m_buyLine.GetPrice(); }
    double GetSellLinePrice() const { return m_sellLine.GetPrice(); }
    double GetSLLinePrice() const { return m_slLine.GetPrice(); }
    double GetTPLinePrice() const { return m_tpLine.GetPrice(); }
    
    bool IsBuyLineVisible() const { return m_buyLine.IsVisible(); }
    bool IsSellLineVisible() const { return m_sellLine.IsVisible(); }
    bool IsSLLineVisible() const { return m_slLine.IsVisible(); }
    bool IsTPLineVisible() const { return m_tpLine.IsVisible(); }
    
    // Методи за управление на панела
    void ToggleVisibility() { m_isVisible ? Hide() : Show(); }
    void ToggleSLActive() { m_slActive = !m_slActive; }
    void ToggleTPActive() { m_tpActive = !m_tpActive; }
    void ToggleSLHedge() { m_slHedge = !m_slHedge; }
    void ToggleTPHedge() { m_tpHedge = !m_tpHedge; }
    
    // Методи за обновяване на изгледа
    void Update()
    {
        if(!m_isVisible) return;
        
        UpdateLabels();
        UpdateLineStates();
        
        if(m_lotTypeRadio.state1)  // Ако е избран режим на риск
        {
            CalculateRiskLot();
        }
    }
    //+------------------------------------------------------------------+
//|                                                    TradePanel.mqh |
//|                                                           RexiBG |
//|                                           2025-03-06 15:06:14 |
//+------------------------------------------------------------------+

// ЧАСТ 12 - КОНСТРУКТОР И ДЕСТРУКТОР

public:
    CTradePanel(string prefix="RexiBG_", int magic=12345)
    {
        m_prefix = prefix;
        m_magic = magic;
        m_x = 20;
        m_y = 60;
        m_width = 700;
        m_height = 600;
        m_bgColor = clrWhiteSmoke;
        m_isVisible = false;
        m_symbol = Symbol();
        
        // Инициализация на калкулатора
        m_calculator.Init();
        
        // Инициализация на стойностите
        InitializeDefaults();
    }
    
    ~CTradePanel()
    {
        Hide();  // Изчистване на всички обекти при унищожаване
    }

private:
    void InitializeDefaults()
    {
        // Търговски параметри
        m_lotSize = 0.01;
        m_slPips = 50;
        m_slMoney = 100;
        m_tpPips = 100;
        m_tpMoney = 200;
        m_riskPercent = 1.0;
        m_riskMoney = 100;
        
        // Състояния
        m_slShow = false;
        m_slActive = false;
        m_slHedge = false;
        m_tpShow = false;
        m_tpActive = false;
        m_tpHedge = false;
        
        // Проверка и корекция на минималния лот
        double minLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
        if(m_lotSize < minLot)
            m_lotSize = minLot;
    }

    // Проверка на валидността на параметрите
    bool ValidateParameters()
    {
        if(m_lotSize <= 0) return false;
        if(m_slPips < 0) return false;
        if(m_slMoney < 0) return false;
        if(m_tpPips < 0) return false;
        if(m_tpMoney < 0) return false;
        if(m_riskPercent < 0 || m_riskPercent > 100) return false;
        if(m_riskMoney < 0) return false;
        
        return true;
    }
};

//+------------------------------------------------------------------+
//| Край на класа CTradePanel                                         |
//+------------------------------------------------------------------+
