//
//  pressureDataCell.m
//  ACONApp
//
//  Created by Ken on 16/1/12.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "pressureDataCell.h"

@implementation pressureDataCell

+(NSString *)ID
{
    return @"pressureDataCell";
}

+(id)createPressureDataCell

{
    
    
        return [[NSBundle mainBundle] loadNibNamed:@"pressureDataCell" owner:nil options:nil][0];
}




@end
