//
//  Util.h
//  TableViewTest01
//
//  Created by 小池恵嗣 on 2014/11/28.
//  Copyright (c) 2014年 YoshitsuguKoike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DataManager,MessageJAJP;

@interface Util : NSObject

-(float)s:(NSString *)number;
-(float)f:(float)number;
-(float)d:(int)number;
-(float)getFloat:(float)value;
-(int)getInt:(int)value;
-(NSMutableDictionary *)getUserInfo;
-(CGRect)getStatusRect;
-(CGRect)getNavigationRect:(UIViewController *)viewcontroller;
-(CGRect)getTabRect:(UIViewController *)viewcontroller;
-(CGRect)getAvailableRect:(UIViewController *)viewcontroller;
-(CGRect)getScreenRect;

//各種マネージャー
-(void)setMyAlbumList:(NSMutableArray *)albums;
-(NSMutableArray *)getMyAlbumList;

//日付操作関係
-(NSString*)dateFromUnixTimeStamp:(NSString*)dateByUnixTimpStampStr;

//メッセージ取得
-(NSString *)getMessage:(int)code;

//メインカラーを返す
-(UIColor *)getMainColor;

//parser
-(NSDictionary *)getHash:(NSDictionary *)data;
-(NSMutableDictionary *)getHash:(NSDictionary *)hash withKey:(NSString *)key;
-(NSMutableDictionary *)parseUserProfile:(NSDictionary *)userinfo;
-(NSMutableDictionary *)getHashFromArray:(NSMutableArray *)arr withKey:(NSString *)key byValue:(NSString *)value;
-(NSMutableArray *)getArray:(NSDictionary *)hash withKey:(NSString *)key;

//Singleton requirement..
+(Util *)instance;

@end