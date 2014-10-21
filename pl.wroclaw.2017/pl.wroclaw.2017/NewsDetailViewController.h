//
//  NewsDetailViewController.h
//  pl.wroclaw.2017
//
//  Created by Szy Mas on 21/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsDate;
@property (weak, nonatomic) IBOutlet UILabel *newsContent;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) NSString* photoValue;
@property (weak, nonatomic) NSString* dateValue;
@property (weak,nonatomic) NSString* titleValue;
@property (weak,nonatomic) NSString* contentValue;
@end
