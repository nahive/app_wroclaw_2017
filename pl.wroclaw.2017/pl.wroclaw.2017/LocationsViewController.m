//
//  LocationsViewController.m
//  pl.wroclaw.2017
//
//  Created by nahive on 14/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

#import "LocationsViewController.h"
#import "SWRevealViewController.h"
@interface LocationsViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self customSetup];
    // Do any additional setup after loading the view.
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
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
