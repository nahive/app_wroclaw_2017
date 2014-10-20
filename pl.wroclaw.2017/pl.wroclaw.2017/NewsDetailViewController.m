//
//  NewsDetailViewController.m
//  pl.wroclaw.2017
//
//  Created by Adam Mateja on 17.10.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize newsLabel, newsName, newsDetailPhoto, photoName, dateLabel, dateValue, textValue, textContent, scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    newsLabel.text = newsName;
    newsDetailPhoto.image = [UIImage imageNamed:photoName];
    dateLabel.text = dateValue;
    textContent.text = textValue;
    
    scrollView.contentSize = CGSizeMake(320, 1700);
}

- (void)viewDidAppear:(BOOL)animated {
    CGRect frame = textContent.frame;
    frame.size.height = textContent.contentSize.height;
    textContent.frame = frame;   
    
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
