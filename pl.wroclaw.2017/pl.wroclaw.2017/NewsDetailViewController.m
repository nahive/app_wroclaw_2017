//
//  NewsDetailViewController.m
//  pl.wroclaw.2017
//
//  Created by Szy Mas on 21/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize newsContent,newsDate,newsTitle,imageView,titleValue,dateValue,contentValue,photoValue, scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    newsTitle.text = titleValue;
    newsDate.text = dateValue;
    newsContent.text = contentValue;
    imageView.image = [UIImage imageNamed:photoValue];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated  {
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    scrollViewHeight -= 50;
    [scrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
