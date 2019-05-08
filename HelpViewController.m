//
//  HelpViewController.m
//  ThePhenomizer
//
//  Created by SE15 UniB on 01/12/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize helpWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *websiteUrl = [NSURL URLWithString:@"https://docs.google.com/document/d/1-odVrZwNFdBtYTW5424BKDD9aZA4ECdf_5jkCoawexg/pub"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [helpWebView loadRequest:urlRequest];
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
