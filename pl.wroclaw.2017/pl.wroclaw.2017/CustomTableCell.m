//
//  CusomTableCell.m
//  pl.wroclaw.2017
//
//  Created by Szy Mas on 14/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell

@synthesize title, imageView,shortText,date;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
