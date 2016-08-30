//
//  EMMW3FolderManager.h
//  EMMKitDemo
//
//  Created by Chenly on 16/7/25.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMMW3FolderManager : NSObject

@property (nonatomic, readonly) NSString *mainW3Folder;     // 项目目录下的 www 目录
@property (nonatomic, readonly) NSDictionary *wwwFolders;

+ (instancetype)sharedInstance;

/**
 *  解压一个 zip 文件到指定目录下
 */
- (BOOL)unZip:(NSString *)zipFile toDirectory:(NSString *)toDirectory error:(NSError **)error;

/**
 *  获取 key 对应的 www 目录名
 */
- (NSString *)absoluteW3FolderForKey:(NSString *)key;

/**
 *  获取 www 文件夹在 Document 目录下的完整路径，key 传空表示 mainW3Folder 目录。
 */
- (NSString *)absolutePathWithStartPage:(NSString *)startPage inW3FolderOfKey:(NSString *)key;

/**
 *  下载一个 www 应用，key = appid;
 */
- (void)downloadW3FolderWithURL:(NSString *)URLString
                            key:(NSString *)key
                        version:(NSString *)version
                     completion:(void (^)(BOOL success, id result))completion;

@end

@interface NSString (EMMW3FolderManager)

/**
 *  获取 www 文件夹在 Document 目录下的完整路径
 */
+ (NSString *)pathInDocumentDirWithW3FolderName:(NSString *)folderName;

@end