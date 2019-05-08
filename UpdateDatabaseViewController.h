//
//  UpdateDatabaseViewController.h
//  ThePhenomizer
//
//  Created by SE15 UniB on 01/12/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface UpdateDatabaseViewController : UIViewController

- (BOOL)connected;  // this function checks network connection

@property (weak, nonatomic) IBOutlet UIButton *minimumUpdateButton;
@property (weak, nonatomic) IBOutlet UIButton *fullUpdateButton;

@end
