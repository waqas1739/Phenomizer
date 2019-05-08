//
//  WelcomeViewController.m
//  ThePhenomizer
//
//  Created by SE15 UniB on 01/12/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ThePhenomizer-Swift.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dbOldVersionLabel;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkDbVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkDbVersion {
    // Check if the DB on this device is the most up to date version
    HTTPRequest *http = [[HTTPRequest alloc] init];
    [http setOldVersionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dbOldVersionLabel setHidden:NO];
        });
    }];
    [http setUpToDateVersionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dbOldVersionLabel setHidden:YES];
        });
    }];
    [http sendVersionQueryAndCompare];
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
