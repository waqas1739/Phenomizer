//
//  FeaturesSelectedViewController.h
//  ThePhenomizer
//
//  Created by SE15 UniB on 07/01/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface FeaturesSelectedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addFeaturesButton;
@property (nonatomic, strong) NSMutableDictionary *selectedFeatures; // selected feature name, selected feature hpo id
@property (nonatomic, strong) NSMutableArray *selectedFeatureKeys;  // selected feature names
@property (weak, nonatomic) IBOutlet UITableView *table;
- (void)diagnosisCompleted : (NSArray *) diagResults;
@property (weak, nonatomic) IBOutlet UIButton *fakeButton;
@property (weak, nonatomic) NSArray *diagnosisResults;

@property UINavigationController *currentNVC;
@property (weak, nonatomic) IBOutlet UIButton *getDiagnosisButton;

- (BOOL)connected;  // this function checks network connection

@end
