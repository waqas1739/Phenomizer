//
//  FeaturesViewController.h
//  ThePhenomizer
//
//  Created by SE15 UniB on 01/12/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeaturesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *features;   // feature hpo id, feature name
@property (nonatomic, strong) NSArray *featureValues; // feature names
@property (nonatomic, strong) NSMutableDictionary *selectedFeatures; // selected feature hpo id, selected features name
@property (nonatomic, strong) NSMutableArray *selectedFeatureKeys;  // selected feature hpo id
@property (weak, nonatomic) IBOutlet UILabel *numOfSelectedFeaturesLabel;

@property int numOfSelectedFeatures; // count of features selected



@end
