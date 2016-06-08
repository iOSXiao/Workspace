//
//  AppDetailModel.h
//  LimitFree
//
//  Created by Chaosky on 16/5/17.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDetailModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *fileSize;

@property (nonatomic, copy) NSString *itunesUrl;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *applicationId;

@property (nonatomic, copy) NSString *lastPrice;

@property (nonatomic, copy) NSString *ratingOverall;

@property (nonatomic, copy) NSString *releaseNotes;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *downloads;

@property (nonatomic, copy) NSString *releaseDate;

@property (nonatomic, copy) NSString *slug;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *appurl;

@property (nonatomic, copy) NSString *sellerId;

@property (nonatomic, copy) NSString *sellerName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *starCurrent;

@property (nonatomic, copy) NSString *starOverall;

@property (nonatomic, copy) NSString *priceTrend;

@property (nonatomic, copy) NSString *expireDatetime;

@property (nonatomic, copy) NSString *newversion;

@property (nonatomic, copy) NSString *currentPrice;

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, copy) NSString *description_long;

@property (nonatomic, copy) NSString *systemRequirements;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString *currentVersion;

@end
@interface AppDetailPhotoModel : NSObject

@property (nonatomic, copy) NSString *smallUrl;

@property (nonatomic, copy) NSString *originalUrl;

@end

