//
//  Util.m
//  TableViewTest01
//
//  Created by 小池恵嗣 on 2014/11/28.
//  Copyright (c) 2014年 YoshitsuguKoike. All rights reserved.
//

#import "Util.h"
#import "DataManager.h"
#import "MessageJAJP.h"

static Util * _sharedInstance = nil;

@interface Util ()
{
    float _width,_height;
    DataManager *_dm;
    NSMutableArray *_draftList,*_myAlbumList;
}
@end

@implementation Util

-(id)init
{
    self = [super init];
    if(self)
    {
        _width = [[UIScreen mainScreen] bounds].size.width;
        _height = [[UIScreen mainScreen] bounds].size.height;
        _myAlbumList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSString *)getMessage:(int)code
{
    NSString *message = @"";
    //言語の判定をする。
    if(YES)
    {
        NSLog(@"MESSAGE____!!!!_____%d",code);
        //とりあえず日本語のみ
        MessageJAJP *_mes = [[MessageJAJP alloc] init];
        message = [_mes getMessage:code];
    }
    return message;
}

-(void)setMyAlbumList:(NSMutableArray *)albums
{
    _myAlbumList = albums;
}
-(NSMutableArray *)getMyAlbumList
{
    return _myAlbumList;
}

-(float)s:(NSString *)number
{
    return [self getFloat:[number floatValue]];
}

-(float)f:(float)number
{
    return [self getFloat:number];
}

-(float)d:(int)number
{
    return [self getFloat:(float)number];
}

-(float)getFloat:(float)value
{
    float _diff = _width / 320;
    return value * _diff;
}

-(int)getInt:(int)value
{
    float _diff = _width / 320;
    return (int)value * _diff;
}

-(CGRect)getStatusRect
{
    CGRect rect = [UIApplication sharedApplication].statusBarFrame;
    return rect;
}

-(CGRect)getNavigationRect:(UIViewController *)viewcontroller
{
    CGRect rect;
    if(viewcontroller.navigationController.navigationBar)
    {
        rect = viewcontroller.navigationController.navigationBar.frame;
    }
    else
    {
        CGRect statusBar = [self getStatusRect];
        rect = CGRectMake(0, statusBar.size.height, statusBar.size.width, [self f:50]);
    }
    return rect;
}

-(CGRect)getTabRect:(UIViewController *)viewcontroller
{
    CGRect rect;
    if(viewcontroller.tabBarController.tabBar)
    {
        rect = viewcontroller.tabBarController.tabBar.frame;
    }
    else
    {
        CGRect screen = [[UIScreen mainScreen] bounds];
        rect = CGRectMake(0, screen.size.height - [self f:50], screen.size.width, [self f:50]);
    }
    return rect;
}

-(CGRect)getScreenRect
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    return screen;
}

-(CGRect)getAvailableRect:(UIViewController *)viewcontroller
{
    CGRect rect,naviBar,tabBar;
    naviBar = [self getNavigationRect:viewcontroller];
    tabBar = [self getTabRect:viewcontroller];
    
    rect = CGRectMake(0, (naviBar.origin.y + naviBar.size.height), naviBar.size.width, (tabBar.origin.y - (naviBar.origin.y + naviBar.size.height)));
    
    return rect;
}
#pragma mark - 日付　unixtimestamp->date
-(NSString*)dateFromUnixTimeStamp:(NSString*)dateByUnixTimpStampStr
{
    NSTimeInterval dateByUnixTimpStamp = [dateByUnixTimpStampStr doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970: dateByUnixTimpStamp];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone: [NSTimeZone defaultTimeZone]];
    [dateFormatter setDateFormat: @"yyyy年MM月dd日 HH時mm分"];
    NSString* formattedDate = [dateFormatter stringFromDate: date];
    return formattedDate;
}
#pragma mark - HUSHの分解
-(NSDictionary *)getHash:(NSDictionary *)data
{
    NSMutableDictionary *_data = [[NSMutableDictionary alloc] init];
    NSArray *_keys = [data allKeys];
    int inum = (int)[_keys count];
    for (int i=0;i<inum; i++)
    {
        if([data objectForKey:[_keys objectAtIndex:i]] && ![[data objectForKey:[_keys objectAtIndex:i]] isKindOfClass:[NSNull class]])
        {
            [_data setObject:[data objectForKey:[_keys objectAtIndex:i]] forKey:[_keys objectAtIndex:i]];
        }
        else
        {
            [_data setObject:@"" forKey:[_keys objectAtIndex:i]];
        }
    }
    return [[NSDictionary alloc] initWithDictionary:_data];
}

#pragma mark - Parser
-(NSMutableDictionary *)getHash:(NSDictionary *)hash withKey:(NSString *)key
{
    NSMutableDictionary *_res = nil;
    NSArray *_keys = [hash allKeys];
    for (id _key in _keys) {
        if(![_key isKindOfClass:[NSString class]])
        {
            continue;
        }
        if([_key isEqualToString:key])
        {
            _res = [hash objectForKey:key];
        }
    }
    if(!_res)
    {
        NSMutableDictionary *_dic = nil;
        for (id item in hash) {
            if(!_dic)
            {
                _dic = [self getHash:[hash objectForKey:item] withKey:key];
            }
        }
        _res = _dic;
    }
    return _res;
}

-(NSMutableDictionary *)getHashFromArray:(NSMutableArray *)arr withKey:(NSString *)key byValue:(NSString *)value
{
    NSMutableDictionary *_res = nil;
    for (id _dic in arr) {
        if(![_dic isKindOfClass:[NSDictionary class]])
        {
            continue;
        }
        NSMutableDictionary *__dic = [self getHash:_dic withKey:key];
        if(__dic && [[_dic objectForKey:key] isEqualToString:value])
        {
            _res = _dic;
            break;
        }
    }
    return _res;
}

-(NSMutableArray *)getArray:(NSDictionary *)hash withKey:(NSString *)key
{
    NSMutableArray *_res = nil;
    NSMutableDictionary *_dic = [self getHash:hash withKey:key];
    if(_dic && [_dic isKindOfClass:[NSArray class]])
    {
        _res = [[NSMutableArray alloc] init];
        for (id __dic in _dic) {
            if(![__dic isKindOfClass:[NSDictionary class]])
            {
                continue;
            }
            [_res addObject:__dic];
        }
    }
    return _res;
}

#pragma mark - UserInfo
-(NSMutableDictionary *)getUserInfo
{
    NSMutableDictionary *_userinfo;
    _dm = [DataManager instance];
    NSMutableArray *_func = [_dm getCoreData:@"UserInfo" conditions:nil sortting:nil limitation:[NSNumber numberWithInt:1] offset:[NSNumber numberWithInt:0]];
    if([_func count] > 0)
    {
        _userinfo = [_func objectAtIndex:0];
    }
    return _userinfo;
}

//ユーザープロフィールの分解
-(NSMutableDictionary *)parseUserProfile:(NSDictionary *)userinfo
{
    NSMutableDictionary *_userinfo = [[NSMutableDictionary alloc] init];
    for (NSString *key in userinfo)
    {
        if([userinfo objectForKey:key] && ![key isEqualToString:@"images"])
        {
            [_userinfo setObject:[userinfo objectForKey:key] forKey:key];
        }
    }
    [_userinfo setObject:@"NO_IMAGE" forKey:@"image_path"];
    if([userinfo objectForKey:@"images"])
    {
        NSArray *_images = [userinfo objectForKey:@"images"];
        for (id _image in _images)
        {
            if(![_image isKindOfClass:[NSDictionary class]])
            {
                continue;
            }
            if([[_image objectForKey:@"image_tag"] isEqualToString:@"PROFILE"])
            {
                [_userinfo setObject:[_image objectForKey:@"image_path"] forKey:@"image_path"];
            }
        }
    }
    return _userinfo;
}

-(UIColor *)getMainColor
{
    return [UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1.0];
}


#pragma mark - Singleton Requirement
+(Util *)instance
{
    if(!_sharedInstance)
    {
        _sharedInstance = [[Util alloc] init];
    }
    return _sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;  // 最初の割り当てで代入し、返す
        }
    }
    return nil; // 以降の割り当てではnilを返すようにする
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end
