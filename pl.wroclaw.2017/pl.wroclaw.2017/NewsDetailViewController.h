//
//  NewsDetailViewController.h
//  pl.wroclaw.2017
//
//  Created by Adam Mateja on 17.10.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *newsLabel;
@property (nonatomic, strong) NSString *newsName;
@property (weak, nonatomic) IBOutlet UIImageView *newsDetailPhoto;
@property (nonatomic, strong) NSString *photoName;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) NSString *dateValue;
@property (weak, nonatomic) IBOutlet UITextView *textContent;
@property (nonatomic, strong) NSString *textValue;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@end
