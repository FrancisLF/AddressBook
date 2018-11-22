//
//  LFCommonTools.h
//  sijidou
//
//  Created by useradmin on 2018/7/20.
//  Copyright © 2018年 org.quasar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFCommonTools : NSObject
- (NSInteger)getNumWithChar:(NSString *)targetChar;
- (NSString *)getStringWith:(NSInteger)num;
- (NSString *)transChinese:(NSString *)str;
@end
