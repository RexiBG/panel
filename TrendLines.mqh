struct STrendLine
{
   string            name;
   bool              visible;
   double            price;
   
   void Init(string prefix, string lineName, color lineColor=clrBlue)
   {
      name = prefix + lineName;
      visible = false;
      price = 0.0;
      
      if(ObjectFind(0, name) >= 0)
         ObjectDelete(0, name);
         
      if(!ObjectCreate(0, name, OBJ_HLINE, 0, 0, 0))
      {
         Print("Error creating line: ", GetLastError());
         return;
      }
      
      ObjectSetInteger(0, name, OBJPROP_COLOR, lineColor);
      ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, name, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);  // Показва се на всички времеви графики
      SetVisible(false);
   }
   
   void SetVisible(bool show)
   {
      visible = show;
      ObjectSetInteger(0, name, OBJPROP_TIMEFRAMES, show ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
   }
   
   void SetPrice(double newPrice)
   {
      price = newPrice;
      ObjectSetDouble(0, name, OBJPROP_PRICE, price);
   }
   
   double GetPrice()
   {
      return ObjectGetDouble(0, name, OBJPROP_PRICE);
   }
   
   void Delete()
   {
      ObjectDelete(0, name);
   }
};