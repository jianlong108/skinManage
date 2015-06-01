//
//  JLSkinManager.m
//  PKResManager
//
//  Created by jianlong on 15/5/27.
//
//

#import "JLSkinManager.h"
#import "UIColor+HexString.h"
#define NormalSkin @"JLDefaultSkin"

NSString *const JLSkinManagerDidChangeThemes = @"JLskinchangeNotification";


@interface JLSkinManager ()

/**@property bundle路径*/
@property (nonatomic,retain)NSString *bundlePath;

/**@property 字体和颜色的字典*/
@property (nonatomic,strong)NSMutableDictionary *attributesDic;

@end

@implementation JLSkinManager


+ (instancetype)sharedManager{
    static JLSkinManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
        
        manager.skinStyle = NormalSkin;
        
        
    });
    return manager;
}

- (void)dealloc{
    [_skinStyle release];
    [_bundlePath release];
    [_attributesDic release];
    [super dealloc];
}


- (UIImage *)imageWithimageKey:(NSString *)key{
    
    
    NSBundle *skinBundle = [NSBundle bundleWithPath:self.bundlePath];
    
    /*因为自定义的bundle,使用此方法时给定子目录,所以bundle中的resource文件夹中存在一个Images子目录.
     ps:可以使用修改后缀名创建bundle,但使用工程打包bundle节省一半内存.两种方式使用folders reference 的引用方式,引用资源.可以保证加载图片的最简化
     */
    NSString *imagePath = [skinBundle pathForResource:key ofType:@"png"inDirectory:@"Images"];
    return [UIImage imageWithContentsOfFile:imagePath];
}


- (UIFont *)fontForKey:(NSString*)sizekey FontKey:(NSString *)fontKey{
    NSString *size = self.attributesDic[sizekey];
    NSString *fontName = self.attributesDic[@"textstyle01"];
    if (fontKey) {
        if (self.attributesDic[fontKey]) {
            fontName = self.attributesDic[fontKey];
        }
    }
    if (size) {
        return [UIFont fontWithName:fontName size:size.floatValue];
    }
    return nil;
}


- (UIColor *)colorWithColorKey:(NSString *)key{
    NSString *hexString = self.attributesDic[key];
    
    while (self.attributesDic[hexString]) {
        hexString = self.attributesDic[hexString];
    }
    if (hexString) {
        return [UIColor colorWithHexString:hexString];
    }
    return [UIColor blackColor];
    
}


- (void)setSkinStyle:(NSString *)skinStyle{
    if (_skinStyle != skinStyle) {
        [_skinStyle release];
        _skinStyle = [skinStyle retain];
        
        [self changeSkinStyle:_skinStyle];
    }
}



- (void)changeSkinStyle:(NSString *)styleName{
    
    //发送通知
    if (_attributesDic != nil)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:JLSkinManagerDidChangeThemes object:nil];
    }
    
    //获得bundle路径
    NSString *path = [self bundlePathWithBundleName:styleName];
    self.bundlePath = path;
    
    [self.attributesDic removeAllObjects];
    //生成图片字典和属性字典,并保存
    [self creatDictionaryWithBundlePath:path];
}
#pragma mark private


/**
 *  根据bundle名称返回对应bundle的路径
 *
 *  @param name bundle名称
 *
 *  @return bundle路径
 */
- (NSString *)bundlePathWithBundleName:(NSString *)bundleName{
    
    
    //1.先去mainbundle中去找对应的bundle文件
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:bundleName ofType:@"bundle"];
    if (bundlePath) {
        return bundlePath;
    }
    //2.去下载的目录中寻找
    //    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //
    //    NSString *fileName = [bundleName stringByAppendingString:@".bundle"];
    //
    //   bundlePath = [self targetFile:fileName InDirectoryWithPath:document];
    return self.skinBundlePath;
}


/*
 *  给定一个搜索目录,返回指定的文件所在的路径
 *
 *  @param fileName 指定文件
 *  @param path     搜索目录
 *
 *  @return 指定文件所在的目录
 
 //- (NSString *)targetFile:(NSString *)fileName InDirectoryWithPath:(NSString *)path{
 //
 //    NSArray *directoryArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
 //    NSString *targetPath = nil;
 //    if (directoryArray != nil) {
 //        for (NSString *subPath in directoryArray) {
 //
 //            if ([fileName isEqualToString:subPath]) {
 //
 //                return [path stringByAppendingPathComponent:subPath];
 //            }
 //        }
 //
 //        for (NSString *subpath in directoryArray) {
 //            path = [path stringByAppendingPathComponent:subpath];
 //            if([self targetFile:fileName InDirectoryWithPath:path]){
 //                targetPath = [self targetFile:fileName InDirectoryWithPath:path];
 //            }
 //           path = [path substringWithRange:NSMakeRange(0, path.length-subpath.length-1)];
 //        }
 //
 //    }
 //
 //    return targetPath;
 //}
 */

/**
 *  生成bundle中的资源文件对应的字典
 *
 *  @param bundlePath bundle路径
 */
- (void)creatDictionaryWithBundlePath:(NSString *)bundlePath{
    NSBundle *sourceBundle = [NSBundle bundleWithPath:bundlePath];
    if (sourceBundle) {
        
        /*
         生成图片字典
         NSString *subPath = [sourceBundle pathForResource:@"Images" ofType:nil];
         NSArray *ImageArray = [[NSFileManager defaultManager] subpathsAtPath:subPath];
         NSMutableDictionary *tempImageDic = [[NSMutableDictionary alloc]initWithCapacity:ImageArray.count];
         [ImageArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
         if (![str containsString:@"@2x"]){//取出@2x的图片
         
         if([str hasSuffix:@"png"]){//取出图片
         
         NSString *name = [str lastPathComponent];
         NSString *name1 = [name substringToIndex:name.length-4];
         [tempImageDic setObject:[subPath stringByAppendingPathComponent:str] forKey:name1];
         }
         }
         }];
         self.imagesDic = tempImageDic;
         [tempImageDic release];
         */
        
        //生成属性字典
        
        NSString *tempStr = [NSString stringWithFormat:@"%@.plist",_skinStyle];
        NSString *plistPath = [sourceBundle.resourcePath stringByAppendingPathComponent:tempStr];
        
        NSMutableDictionary *tempAttDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
        [tempAttDic enumerateKeysAndObjectsUsingBlock:^(NSString *key,NSDictionary *obj, BOOL *stop) {
            
            if (![key isEqualToString:@"img"]) {
                [obj enumerateKeysAndObjectsUsingBlock:^(NSString *key1,NSDictionary *obj1, BOOL *stop) {
                    
                    [obj enumerateKeysAndObjectsUsingBlock:^(NSString *key2, NSDictionary *obj2, BOOL *stop) {
                        [obj2 enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSString *obj3, BOOL *stop) {
                            [temp setObject:obj3 forKey:name];
                        }];
                    }];
                }];
            }
        }];
        
        self.attributesDic = temp;
        
        [temp release];
    }
}

@end
