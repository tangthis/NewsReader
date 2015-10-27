//
//  UrlDefines.h
//  NewsReader
//
//  Created by 唐有欢 on 15/10/11.
//  Copyright © 2015年 tangtech. All rights reserved.
//

// 0正式版，1测试版
#define ProductType 1

// 正式版自动使用正式环境
#ifdef OFFICIAL
#undef ProductType
#define ProductType 0
#endif


#if ProductType == 0
#define BaseHost    @"http://www.tangtech.com"
#define BasePort    @""
#else
#define BaseHost    @"http://127.0.0.1"
#define BasePort    @":80"
#endif

#define BaseServer  BaseHost BasePort
#define BaseURLPath "/NewsReader/"
#define BaseURL     BaseServer BaseURLPath
#define BaseServer2 @"http://c.m.163.com/nc/article/"

#define LoginURL    BaseURL "login.json"
#define AdvertURL   BaseURL "advert.json?width=%ld&height=%ld"
#define ColumnURL   BaseURL "column.json"
#define NewsURLFmt  BaseURL "news_%@.json"
#define DetailURLFmt BaseServer2 "%@/full.html"
#define ChartURL    BaseURL "chart.json"
#define H5URL       BaseURL "H5/content.html"

#define CityCodeURLFmt  @"http://apistore.baidu.com/microservice/cityinfo?cityname=%@"

// k78 URL
#define WeatherFmt      @"&format=json"
#define WeatherKey      @"10003"
#define WeatherSign     @"b59bc3ef6191eb9f747dd4e83c99f2a4"
#define WeatherHost     @"http://api.k780.com:88/"
#define WeatherRealFmt  WeatherHost "?app=weather.today&weaid=%@&appkey=" WeatherKey "&sign=" WeatherSign WeatherFmt

