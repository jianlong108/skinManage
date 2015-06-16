//
//  JLCircleBtn.h
//  vehicle
//
//  Created by 王建龙 on 15/6/13.
//  
//

#import "JLCircleBtn.h"
#import <math.h>

@interface JLCircleBtn ()
/**类型*/
@property (nonatomic, assign)AntimationType type;
@property (nonatomic, assign) CGFloat percent;
/**名称*/
@property (nonatomic, copy)NSString *name;
/**定时器*/
@property (nonatomic, strong)CADisplayLink *linker;

/**度数*/
@property (nonatomic, assign)CGFloat angels;
@end

@implementation JLCircleBtn

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
    self.backgroundColor = [UIColor clearColor];
}
- (void)showAnimationWithType:(AntimationType)type percent:(CGFloat)percent{
   if (percent>=100) {
        percent = 100;
    }
    if (percent <=0) {
        percent = 0;
    }
    if (percent >=60&&percent<=100) {
        if (_fgColor == nil) {
            
            self.fgColor = self.qualifiedColor;
        }
        
    }else if(percent <60 && percent>0){
        if (_fgColor == nil) {
           self.fgColor = self.unqualifiedColor;
        }
        
    }
    _type = type;
    self.percent = percent;
   CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(beginAnimation)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.linker = link;
    
}
- (void)beginAnimation{
    self.angels +=1.0f;
    NSString *text = [NSString stringWithFormat:@"%d",(int)self.angels];
    
    self.titleLabel.contentMode = UIViewContentModeCenter;
    
    self.contentMode = UIViewContentModeCenter;
    if (_type == AntimationTypePercent&&self.angels!=0) {
        self.titleLabel.font = [UIFont systemFontOfSize:9];
        [self setTitle:[text stringByAppendingString:@"%"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.lineWidth = 3;
        [self setTitleColor:self.contenColor forState:UIControlStateNormal];
    }else if (_type == AntimationTypeScore&&self.angels!=0){
//        [self setTitle:text forState:UIControlStateNormal];
//        self.titleLabel.font = self.textFont;
//        [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        self.lineWidth = 5;
        _name = text;
    }
    if (self.angels >= self.percent) {
        [self.linker removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [self.linker invalidate];
    }
    [self setNeedsDisplay];
}
- (UIColor *)contenColor{
    if (_contenColor == nil) {
        return [UIColor orangeColor];
    }
    return _contenColor;
}
- (UIColor *)qualifiedColor{
    if (_qualifiedColor == nil) {
        return  [UIColor colorWithRed:22/255.0 green:167/255.0 blue:137/255.0 alpha:1.0];
    }
    return _qualifiedColor;
}
- (UIColor *)unqualifiedColor{
    if (_unqualifiedColor == nil) {
        return  [UIColor redColor];
    }
    return _unqualifiedColor;
}
- (UIFont *)textFont{
    if (_textFont == nil) {
        return [UIFont boldSystemFontOfSize:35];
    }else{
        
        return _textFont;
    }
}


- (UIColor *)bgColor{
    if (_bgColor == nil) {
        return [UIColor colorWithRed:59/255.0 green:62/255.0 blue:68/255.0 alpha:1.0];
    }else{
        return _bgColor;
    }
}

- (void)drawRect:(CGRect)rect
{
    float radius = MIN(rect.size.width, rect.size.height)*0.5 - 3;
    float start = -M_PI/2;
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    
    if (self.angels<100&&self.angels!=0) {
        CGFloat end =   2 * M_PI + start;
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
        
        bgPath.lineWidth = self.lineWidth;
        bgPath.lineCapStyle = kCGLineCapRound;
        
        [self.bgColor setStroke];
        [bgPath stroke];
        
    }
    CGFloat end =  self.angels/100* 2 * M_PI + start;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    
    path.lineWidth = self.lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    
    [self.fgColor setStroke];
    [path stroke];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeFont] = self.textFont;
    textAttrs[UITextAttributeTextColor] = [UIColor colorWithRed:231/255.0 green:85/255.0 blue:25/255.0 alpha:1.0];
   CGRect textRect = [_name boundingRectWithSize:CGSizeMake(30, 30) options:NSStringDrawingUsesFontLeading attributes:textAttrs context:nil];
    CGFloat textW = textRect.size.width;
    CGFloat textH = textRect.size.height;
//    CGFloat textX = self.titleLabel.frame.origin.x;
//    CGFloat textY = self.titleLabel.frame.origin.y;
    CGFloat textX = self.center.x - textW/2;
    CGFloat textY = self.center.y - textH/2;
    [_name drawAtPoint:CGPointMake(textX, textY) withAttributes:textAttrs];
    
    if (self.type == AntimationTypeScore) {
        NSMutableDictionary *nameAtt = [NSMutableDictionary dictionary];
        nameAtt[UITextAttributeFont] = [UIFont systemFontOfSize:11];
        nameAtt[UITextAttributeTextColor] = [UIColor lightGrayColor];
        
        CGFloat nameX = textW + textX;
        CGFloat nameY = textY + textH - 20;
        [@"分" drawAtPoint:CGPointMake(nameX, nameY) withAttributes:nameAtt];
    }
}

- (void)refreshMessageWithPercent:(CGFloat)percent{
    if (percent == 0) {
        percent = self.percent;
    }
    
    [self showAnimationWithType:self.type percent:percent];
}

@end
