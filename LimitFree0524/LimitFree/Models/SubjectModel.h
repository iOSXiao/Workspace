//
//  SubjectModel.h
//  LimitFree
//
//  Created by Chaosky on 16/5/13.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *desc_img;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *applications;

@property (nonatomic, copy) NSString *date;

@end
@interface SubjectAppModel : NSObject

@property (nonatomic, copy) NSString *starOverall;

@property (nonatomic, copy) NSString *applicationId;

@property (nonatomic, copy) NSString *downloads;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *ratingOverall;

@end

