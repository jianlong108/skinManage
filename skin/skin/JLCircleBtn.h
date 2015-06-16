//
//  JLCircleBtn.h
//  vehicle
//
//  Created by 王建龙 on 15/6/13.
//  
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS (NSUInteger,AntimationType){
    AntimationTypePercent = 1,
    AntimationTypeScore
};

@interface JLCircleBtn : UIButton

/**线宽*/
@property (nonatomic, assign)CGFloat lineWidth;
@property (nonatomic, strong) UIColor *bgColor;//背景圈色,默认红色
@property (nonatomic, strong) UIColor *fgColor;//前景圈色，默认灰色
@property (nonatomic, strong) UIColor *qualifiedColor;//合格颜色
@property (nonatomic, strong) UIColor *unqualifiedColor;//不合格颜色
@property (nonatomic, strong) UIColor *contenColor;//字体颜色

/**说明*/
@property (nonatomic, strong)UIFont *textFont;
/**
 *  根据指定动画和比例进行界面绘制
 *
 *  @param type    显示类型
 *  @param percent 比例
 */
- (void)showAnimationWithType:(AntimationType)type percent:(CGFloat)percent;
/**
 *  根据新的percent  重新绘制界面
 *
 *  @param percent 比例
 */
- (void)refreshMessageWithPercent:(CGFloat)percent;
@end