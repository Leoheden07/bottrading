//+------------------------------------------------------------------+
//|                                                      SimpleEA.mq5 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   static datetime lastBarTime = 0;
   
   if (lastBarTime != iTime(Symbol(), 0, 0)) {
      lastBarTime = iTime(Symbol(), 0, 0);
      
      double ma = iMA(Symbol(), PERIOD_CURRENT, 14, 0, MODE_SMA, PRICE_CLOSE);
      
      MqlTradeRequest request;
      MqlTradeResult result;
      
      ZeroMemory(request);
      
      request.symbol = Symbol();
      request.volume = 0.01;
      request.deviation = 10;
      request.magic = 123456;
      
      double lastClose = iClose(Symbol(), PERIOD_CURRENT, 1);
      
      if (lastClose > ma) {
         request.action = TRADE_ACTION_DEAL;
         request.type = ORDER_TYPE_BUY;
         request.price = NormalizeDouble(SymbolInfoDouble(Symbol(), SYMBOL_ASK), _Digits);
         if(!OrderSend(request, result))
         {
            Print("OrderSend failed with error ",GetLastError());
         }
      } else if (lastClose < ma) {
         request.action = TRADE_ACTION_DEAL;
         request.type = ORDER_TYPE_SELL;
         request.price = NormalizeDouble(SymbolInfoDouble(Symbol(), SYMBOL_BID), _Digits);
         if(!OrderSend(request, result))
         {
            Print("OrderSend failed with error ",GetLastError());
         }
      }
   }
}
