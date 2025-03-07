//+------------------------------------------------------------------+
//|                                                  Calculator2.mqh    |
//|                                                          RexiBG    |
//|                                             2025-03-04 20:15:43    |
//+------------------------------------------------------------------+
#property copyright "RexiBG"

class CCalculator2
{
private:
    double            m_defaultSLPips;
    double            m_defaultTPPips;
    double            m_minLot;
    double            m_maxLot;
    double            m_lotStep;
    double            m_tickSize;
    double            m_tickValue;
    double            m_point;
    int               m_digits;
    
public:
                     CCalculator2();
                    ~CCalculator2() {}
    
    // Инициализация
    void             Init();
    
    // Основни калкулации
    double           CalcLotFromRiskPercent(double riskPercent, double slPoints);
    double           CalcLotFromRiskMoney(double riskMoney, double slPoints);
    double           CalcMoneyFromPips(double lot, double pips);
    double           CalcPipsFromMoney(double lot, double money);
    double           CalcSLPrice(bool isBuy, double entryPrice, double pips);
    double           CalcTPPrice(bool isBuy, double entryPrice, double pips);
    double           CalcPipsFromPrices(double price1, double price2);
    
    // Форматиране и нормализация
    double           NormalizeLot(double lot);
    double           NormalizeMoney(double money);
    double           NormalizePips(double pips);
    double           NormalizePrice(double price);
    
    // Валидация
    bool             IsValidLot(double lot);
    bool             IsValidMoney(double money);
    bool             IsValidPips(double pips);
    bool             IsValidPrice(double price);
    
    // Getters
    double           GetMinLot() const { return m_minLot; }
    double           GetMaxLot() const { return m_maxLot; }
    double           GetLotStep() const { return m_lotStep; }
    double           GetTickSize() const { return m_tickSize; }
    double           GetTickValue() const { return m_tickValue; }
    double           GetPoint() const { return m_point; }
    int              GetDigits() const { return m_digits; }
    double           GetDefaultSLPips() const { return m_defaultSLPips; }
    double           GetDefaultTPPips() const { return m_defaultTPPips; }
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CCalculator2::CCalculator2()
{
    m_defaultSLPips = 50;
    m_defaultTPPips = 100;
    Init();
}

//+------------------------------------------------------------------+
//| Initialize calculator with current symbol parameters               |
//+------------------------------------------------------------------+
void CCalculator2::Init()
{
    m_minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    m_maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    m_lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    m_tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    m_tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    m_point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    m_digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
}

//+------------------------------------------------------------------+
//| Calculate lot size from risk percent                              |
//+------------------------------------------------------------------+
double CCalculator2::CalcLotFromRiskPercent(double riskPercent, double slPoints)
{
    if(riskPercent <= 0 || slPoints <= 0) return m_minLot;
    
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskMoney = balance * riskPercent / 100.0;
    
    return CalcLotFromRiskMoney(riskMoney, slPoints);
}

//+------------------------------------------------------------------+
//| Calculate lot size from risk money                                |
//+------------------------------------------------------------------+
double CCalculator2::CalcLotFromRiskMoney(double riskMoney, double slPoints)
{
    if(riskMoney <= 0 || slPoints <= 0) return m_minLot;
    
    double lot = riskMoney / (slPoints * m_tickValue);
    return NormalizeLot(lot);
}

//+------------------------------------------------------------------+
//| Calculate money from pips                                         |
//+------------------------------------------------------------------+
double CCalculator2::CalcMoneyFromPips(double lot, double pips)
{
    if(!IsValidLot(lot) || pips <= 0) return 0;
    
    return NormalizeMoney(lot * pips * m_tickValue);
}

//+------------------------------------------------------------------+
//| Calculate pips from money                                         |
//+------------------------------------------------------------------+
double CCalculator2::CalcPipsFromMoney(double lot, double money)
{
    if(!IsValidLot(lot) || money <= 0) return 0;
    
    return NormalizePips(money / (lot * m_tickValue));
}

//+------------------------------------------------------------------+
//| Calculate SL price                                                |
//+------------------------------------------------------------------+
double CCalculator2::CalcSLPrice(bool isBuy, double entryPrice, double pips)
{
    if(!IsValidPrice(entryPrice) || pips <= 0) return 0;
    
    double points = pips * m_point;
    return NormalizePrice(isBuy ? entryPrice - points : entryPrice + points);
}

//+------------------------------------------------------------------+
//| Calculate TP price                                                |
//+------------------------------------------------------------------+
double CCalculator2::CalcTPPrice(bool isBuy, double entryPrice, double pips)
{
    if(!IsValidPrice(entryPrice) || pips <= 0) return 0;
    
    double points = pips * m_point;
    return NormalizePrice(isBuy ? entryPrice + points : entryPrice - points);
}

//+------------------------------------------------------------------+
//| Calculate pips between two prices                                 |
//+------------------------------------------------------------------+
double CCalculator2::CalcPipsFromPrices(double price1, double price2)
{
    if(!IsValidPrice(price1) || !IsValidPrice(price2)) return 0;
    
    return NormalizePips(MathAbs(price1 - price2) / m_point);
}

//+------------------------------------------------------------------+
//| Normalize lot size                                                |
//+------------------------------------------------------------------+
double CCalculator2::NormalizeLot(double lot)
{
    if(lot < m_minLot) return m_minLot;
    if(lot > m_maxLot) return m_maxLot;
    
    return NormalizeDouble(MathFloor(lot / m_lotStep) * m_lotStep, 2);
}

//+------------------------------------------------------------------+
//| Normalize money amount                                            |
//+------------------------------------------------------------------+
double CCalculator2::NormalizeMoney(double money)
{
    return NormalizeDouble(money, 2);
}

//+------------------------------------------------------------------+
//| Normalize pips value                                              |
//+------------------------------------------------------------------+
double CCalculator2::NormalizePips(double pips)
{
    return NormalizeDouble(pips, 1);
}

//+------------------------------------------------------------------+
//| Normalize price                                                   |
//+------------------------------------------------------------------+
double CCalculator2::NormalizePrice(double price)
{
    return NormalizeDouble(price, m_digits);
}

//+------------------------------------------------------------------+
//| Validate lot size                                                 |
//+------------------------------------------------------------------+
bool CCalculator2::IsValidLot(double lot)
{
    return (lot >= m_minLot && lot <= m_maxLot);
}

//+------------------------------------------------------------------+
//| Validate money amount                                             |
//+------------------------------------------------------------------+
bool CCalculator2::IsValidMoney(double money)
{
    return (money > 0);
}

//+------------------------------------------------------------------+
//| Validate pips value                                               |
//+------------------------------------------------------------------+
bool CCalculator2::IsValidPips(double pips)
{
    return (pips > 0);
}

//+------------------------------------------------------------------+
//| Validate price                                                    |
//+------------------------------------------------------------------+
bool CCalculator2::IsValidPrice(double price)
{
    return (price > 0);
}