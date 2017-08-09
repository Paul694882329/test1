//
//  PhotoCell.m
//  test1
//
//  Created by 刘智诚 on 2017/8/7.
//  Copyright © 2017年 刘智诚. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _btnCheck.imageEdgeInsets = UIEdgeInsetsMake(5, 8, 8, 5);
}
- (IBAction)click:(UIButton *)sender {
    
    _btnCheck.selected = !_btnCheck.selected;
    
    
}

@end
