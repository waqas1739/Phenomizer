//
//  UpdateDatabaseViewController.m
//  ThePhenomizer
//
//  Created by SE15 UniB on 01/12/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//

#import "UpdateDatabaseViewController.h"
#import "ThePhenomizer-Swift.h"

@interface UpdateDatabaseViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation UpdateDatabaseViewController
@synthesize minimumUpdateButton, fullUpdateButton;

- (IBAction)minUpdateClicked:(id)sender {
    if (![self connected]) {
        NSLog(@"no internet connection!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connection"
                                                        message:@"Please check your internet connection, and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        NSLog(@"internet connection available");
        [self downloadMinUpdate:false];
    }
}

- (IBAction)fullUpdateClicked:(id)sender {
    if (![self connected]) {
        NSLog(@"no internet connection!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connection"
                                                        message:@"Please check your internet connection, and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        NSLog(@"internet connection available");
        [self downloadFullUpdate];
    }
}

// Minimum update of DB - just features
- (void)downloadMinUpdate:(BOOL)fullUpdate {
    Downloader *downloader = [[Downloader alloc] init];
    
    if (fullUpdate) {
        [downloader download:^{}];
    } else {
        [self.minimumUpdateButton setEnabled:NO];
        [self.indicator startAnimating];
        [downloader download:^{
            [self.indicator stopAnimating];
            [self.minimumUpdateButton setEnabled:YES];
        }];
    }
}

// Full update of DB - features and diseases
- (void)downloadFullUpdate {
    [self.fullUpdateButton setEnabled:NO];
    [self.indicator startAnimating];
    [self downloadMinUpdate:true];
    AnnotationDownloader *annoDownloader = [[AnnotationDownloader alloc] init];
    [annoDownloader download:^{
        [self.indicator stopAnimating];
        [self.fullUpdateButton setEnabled:YES];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
