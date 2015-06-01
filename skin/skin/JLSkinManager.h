//
//  JLSkinManager.h
//  PKResManager
//
//  Created by jianlong on 15/5/27.
//
//

#import <UIKit/UIKit.h>
#import "JLSkinConfig.h"
//#define JLSkinManagerDidChangeThemes @"JLskinchangeNotification"

extern NSString *const JLSkinManagerDidChangeThemes;

@interface JLSkinManager : NSObject

/**@property 皮肤包搜索路径*/
@property (nonatomic, retain)NSString *skinBundlePath;

/**@property 皮肤样式*/
@property (nonatomic, retain, readonly) NSString *skinStyle;

/**
 *  @method:创建单例对象
 *
 *  @return 创建好的皮肤管理器
 */
+ (instancetype)sharedManager;


/**
 *  @method:根据图片key返回UIImage对象
 *
 *  @param key 每一个图片对应的key
 *
 *  @return 返回的image对象
 */
- (UIImage *)imageWithimageKey:(NSString *)key;


/**
 *  @method:根据字体key返回对应的字体
 *
 *  @param key 字体key
 *
 *  @return 返回的字体
 */
- (UIFont *)fontForKey:(NSString*)sizekey FontKey:(NSString *)fontKey;


/**
 *  @method:返回的颜色
 *
 *  @param  颜色key
 *
 *  @return 返回的颜色
 */
- (UIColor *)colorWithColorKey:(NSString *)key;


/**
 *  @method:改变当前的皮肤模式
 *
 *  @param styleName
 */
- (void)changeSkinStyle:(NSString *)styleName;

@end

