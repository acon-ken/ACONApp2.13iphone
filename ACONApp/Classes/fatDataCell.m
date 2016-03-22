//
//  fatDataCell.m
//  ACONApp
//
//  Created by Ken on 16/1/12.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "fatDataCell.h"

@implementation fatDataCell
@synthesize fatdateLabel;
@synthesize fatTimeLabel;
@synthesize cholesterolLabel;
@synthesize triglycerideLabel;
@synthesize highdensityLipoproteinLabel;

@synthesize lowdensityLipoproteinLabel;






+ (NSString *)ID{
    
  return  @"fatDataCell";
    
}
+ (id)createFatDataCell
{
    
    return [[NSBundle mainBundle] loadNibNamed:@"fatDataCell" owner:nil options:nil][0];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
