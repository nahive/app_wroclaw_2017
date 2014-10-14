//
//  CusomTableCell.h
//  pl.wroclaw.2017
//
//  Created by Szy Mas on 14/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel *title;
@property (strong,nonatomic) IBOutlet UILabel *date;
@property (strong,nonatomic) IBOutlet UILabel *shortText;
@property (strong,nonatomic) IBOutlet UIImageView *imageView;
@end
