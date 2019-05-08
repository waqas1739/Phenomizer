//
//  StaticValues.m
//  ThePhenomizer
//
//  Created by SE15 UniB on 20/01/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

#import "StaticValues.h"

static NSArray *allFeatureNames;
static NSDictionary *allFeatures;
static NSDictionary *allDiseaseFeatures;
static NSArray *allDiseaseNames;
static NSDictionary *allDiseases;

@implementation StaticValues
+ (NSArray *) allFeatureNames {return allFeatureNames;}
+ (NSDictionary *) allFeatures {return allFeatures;}
+ (NSDictionary *) allDiseaseFeatures {return allDiseaseFeatures;}
+ (NSArray *) allDiseaseNames {return allDiseaseNames;}
+ (NSDictionary *) allDiseases {return allDiseases;}

+ (void) setAllFeatureNames : (NSArray *) allFeatureNames {
    self.allFeatureNames = [[NSArray alloc] init];
    self.allFeatureNames = allFeatureNames;
}
+ (void) setAllFeatures : (NSDictionary *) aFeatures {
    self.allFeatures = [[NSDictionary alloc] init];
    self.allFeatures = aFeatures;
}
+ (void) setAllDiseaseFeatures : (NSDictionary *) allDiseaseFeatures {self.allDiseaseFeatures = allDiseaseFeatures;}
+ (void) setAllDiseaseNames : (NSArray *) allDiseaseNames {self.allDiseaseNames = allDiseaseNames;}
+ (void) setAllDiseases : (NSDictionary *) allDiseases {self.allDiseases = allDiseases;}
@end
