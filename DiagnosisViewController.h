//
//  DiagnosisViewController.h
//  ThePhenomizer
//
//  Created by SE15 UniB on 06/01/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiagnosisViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *selectedFeatures; // selected feature hpo id, selected features name
@property (nonatomic, strong) NSMutableArray *selectedFeatureKeys;  // selected feature hpo id
@property (nonatomic, strong) NSArray *diagnosisResults; // array of arrays

+ (void)diagnosisCompleted : (NSArray *) diagResults;

@end
