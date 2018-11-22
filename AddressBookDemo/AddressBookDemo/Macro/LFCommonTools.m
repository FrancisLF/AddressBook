//
//  LFCommonTools.m
//  sijidou
//
//  Created by useradmin on 2018/7/20.
//  Copyright © 2018年 org.quasar. All rights reserved.
//

#import "LFCommonTools.h"
#include <stdio.h>

@implementation LFCommonTools

- (NSString *)transChinese:(NSString *)stri{
    if (stri.length < 1) {
        return @"";
    }
    NSMutableString *pinyin = [stri mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSString * aSting = nil;
    aSting = stri;
//    //先转换为带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
//    //再转换为不带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray * chinacese = @[@"区",@"查",@"曾",@"晟",@"单",@"乐",@"仇",@"尉",@"沈"];
    NSArray * pinYin = @[@"OU",@"ZHA",@"ZENG",@"CHENG",@"SHAN",@"YUE",@"QIU",@"YU",@"SHEN"];
    for (NSInteger chineseNum = 0; chineseNum < chinacese.count; chineseNum++) {
        if( [[aSting substringToIndex:1] compare:chinacese[chineseNum]] == NSOrderedSame){
            NSArray * arr = [[pinyin uppercaseString] componentsSeparatedByString:@" "];
            NSMutableArray * midArray = [[NSMutableArray alloc] initWithArray:arr];
            [midArray replaceObjectAtIndex:0 withObject:pinYin[chineseNum]];
            return [midArray componentsJoinedByString:@" "];
        }
    }
    return [pinyin uppercaseString];
}

- (NSInteger)getNumWithChar:(NSString *)target{
    char targetChar = [self transStringToChar:target];
    if(targetChar>='A' && targetChar<='Z')
        
    {
        //        printf("%d  ",targetChar-64);  // ASCII码转成数字
        
        //            sum+=(c-64);
        return targetChar-64;
        
    }
    return -1;
}

- (char)transStringToChar:(NSString *)target{
    if ([target isEqualToString:@"A"]) {return 'A';}else if ([target isEqualToString:@"B"]){return 'B';}else if ([target isEqualToString:@"C"]){return 'C';}else if ([target isEqualToString:@"D"]){return 'D';}else if ([target isEqualToString:@"E"]){return 'E';}else if ([target isEqualToString:@"F"]){return 'F';}else if ([target isEqualToString:@"G"]){return 'G';}else if ([target isEqualToString:@"H"]){return 'H';}else if ([target isEqualToString:@"I"]){return 'I';}else if ([target isEqualToString:@"J"]){return 'J';}else if ([target isEqualToString:@"K"]){return 'K';}else if ([target isEqualToString:@"L"]){return 'L';}else if ([target isEqualToString:@"M"]){return 'M';}else if ([target isEqualToString:@"N"]){return 'N';}else if ([target isEqualToString:@"O"]){return 'O';}else if ([target isEqualToString:@"P"]){return 'P';}
    else if ([target isEqualToString:@"Q"]){return 'Q';}else if ([target isEqualToString:@"R"]){return 'R';}else if ([target isEqualToString:@"S"]){return 'S';}else if ([target isEqualToString:@"T"]){return 'T';}else if ([target isEqualToString:@"U"]){return 'U';}else if ([target isEqualToString:@"V"]){return 'V';}else if ([target isEqualToString:@"W"]){return 'W';}else if ([target isEqualToString:@"X"]){return 'X';}else if ([target isEqualToString:@"Y"]){return 'Y';}else if ([target isEqualToString:@"Z"]){return 'Z';}
    return 'Z';
}

- (NSString *)getStringWith:(NSInteger)num{
    if (num > 0 && num <= 26) {
        if (num == 1) {return @"A";}else if (num == 2){return @"B";}else if (num == 3){return @"C";}else if (num == 4){return @"D";}else if (num == 5){return @"E";}else if (num == 6){return @"F";}else if (num == 7){return @"G";}else if (num == 8){return @"H";}else if (num == 9){return @"I";}else if (num == 10){return @"J";}else if (num == 11){return @"K";}else if (num == 12){return @"L";}else if (num == 13){return @"M";}else if (num == 14){return @"N";}else if (num == 15){return @"O";}else if (num == 16){return @"P";}else if (num == 17){return @"Q";}else if (num == 18){return @"R";}else if (num == 19){return @"S";}else if (num == 20){return @"T";}else if (num == 21){return @"U";}else if (num == 22){return @"V";}else if (num == 23){return @"W";}else if (num == 24){return @"X";}else if (num == 25){return @"Y";}else if (num == 26){return @"Z";}
        return @"#";
    }else{
        return @"";
    }
}
@end
