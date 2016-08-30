//
//  EMMW3FolderManager.m
//  EMMKitDemo
//
//  Created by Chenly on 16/7/25.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "EMMW3FolderManager.h"
#import "ZipArchive.h"
#import "AFNetworking.h"

@interface EMMW3FolderManager ()

@property (nonatomic, strong) NSMutableDictionary *wwwFolders;

@end

@implementation EMMW3FolderManager

static NSString * const kMainW3FolderName = @"www";
static NSString * const kMainW3FolderVersion = @"1.0";

// 存放 www 目录与 appid 映射关系到 UserDefault 中所用的 key
static NSString * const kUserDefaultKeyOfW3Folders = @"kUserDefaultKeyOfW3Folders";

// 在 Document文件夹中简历一个用于存放 www 应用的目录。
static NSString * const kW3ApplicationsDir = @"www_applications";

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static EMMW3FolderManager *sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[EMMW3FolderManager alloc] init];
        [sSharedInstance initW3FolderIfNeed];
    });
    return sSharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initW3FolderIfNeed];
    }
    return self;
}

- (NSDictionary *)wwwFolders {
    
    if (!_wwwFolders) {
        
        NSDictionary *wwwFolders = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserDefaultKeyOfW3Folders];
        _wwwFolders = wwwFolders ? [wwwFolders mutableCopy] : [NSMutableDictionary dictionary];
    }
    return [_wwwFolders copy];
}

/**
 *  获取 key 对应的 www 目录名
 */
- (NSString *)absoluteW3FolderForKey:(NSString *)key {
    
    NSString *path = key ? self.wwwFolders[key] : self.mainW3Folder;
    return [NSURL fileURLWithPath:path].absoluteString;
}

/**
 *  设置 key 对应的 www 目录名
 */
- (void)setW3Folder:(id)value forKey:(NSString *)key {
    _wwwFolders[key] = value;
    [self synchronize];
}

- (void)synchronize {
    [[NSUserDefaults standardUserDefaults] setObject:self.wwwFolders forKey:kUserDefaultKeyOfW3Folders];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  将 www 目录从 resourcePath（无权限更改）中拷贝到 Document(有权限) 目录下
 */
- (void)initW3FolderIfNeed {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *resourceDir = [[NSBundle mainBundle] resourcePath];
    NSString *sourcePath = [resourceDir stringByAppendingPathComponent:kMainW3FolderName];
    if (![fileManager fileExistsAtPath:sourcePath]) {
        return;
    }
    
    NSString *toPath = [NSString pathInDocumentDirWithW3FolderName:kMainW3FolderName];
    
    BOOL needInit = YES;
    if ([fileManager fileExistsAtPath:toPath]) {
        
        NSString *folderVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"kW3FolderVersion"];
        if (folderVersion && [folderVersion compare:kMainW3FolderVersion] != NSOrderedAscending) {
            needInit = NO;
        }
    }
    if (needInit) {
        [fileManager copyItemAtPath:sourcePath toPath:toPath error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:kMainW3FolderVersion forKey:@"kW3FolderVersion"];
    }
}

- (NSString *)mainW3Folder {
    return [NSString pathInDocumentDirWithW3FolderName:kMainW3FolderName];
}

- (NSString *)absolutePathWithStartPage:(NSString *)startPage inW3FolderOfKey:(NSString *)key {
    
    NSString *wwwFolder = key ? self.wwwFolders[key] : self.mainW3Folder;
    if (!wwwFolder) {
        return nil;
    }
    NSString *path = [wwwFolder stringByAppendingPathComponent:startPage];
    return [NSURL fileURLWithPath:path].absoluteString;
}

- (void)downloadW3FolderWithURL:(NSString *)URLString
                            key:(NSString *)key
                        version:(NSString *)version
                     completion:(void (^)(BOOL success, id result))completion {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            NSLog(@"下载 www 应用失败：%@", error.localizedDescription);
            completion(NO, error);
        }
        else {
            NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *wwwFolder = [NSString stringWithFormat:@"%@/%@/%@", kW3ApplicationsDir, key, version];
            NSString *toDirectory = [documentDir stringByAppendingPathComponent:wwwFolder];
            NSError *zipError;
            BOOL zipSucceed = [[EMMW3FolderManager sharedInstance] unZip:filePath.path
                                                             toDirectory:toDirectory
                                                                   error:&zipError];
            if (zipSucceed) {
                NSString *lastW3Folder = self.wwwFolders[key];
                if ([[NSFileManager defaultManager] fileExistsAtPath:lastW3Folder]) {
                    // 删除历史版本
                    [[NSFileManager defaultManager] removeItemAtPath:lastW3Folder error:nil];
                }
                [self setW3Folder:toDirectory forKey:key];
                completion(YES, nil);
            }
            else {
                NSLog(@"解压 zip 包失败:%@", zipError.localizedDescription);
                completion(NO, zipError);
            };
        }
    }];
    [downloadTask resume];
}

/**
 *  解压
 */
- (BOOL)unZip:(NSString *)zipFile toDirectory:(NSString *)toDirectory error:(NSError **)error {
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    [zip UnzipOpenFile:zipFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *fileContents = [zip getZipFileContents];
    NSMutableArray *baks = [NSMutableArray array];
    // 备份
    for (NSString *fileContent in fileContents) {
        
        NSString *toPath = [toDirectory stringByAppendingPathComponent:fileContent];
        if ([fileManager fileExistsAtPath:toPath]) {
            
            NSString *bak = [fileContent stringByAppendingString:@".bak"];
            [fileManager moveItemAtPath:toPath toPath:bak error:error];
            [baks addObject:bak];
        }
    }
    
    if([zip UnzipFileTo:toDirectory overWrite:YES]) {
        // 成功，删除备份
        if (baks.count > 0) {
            for (NSString *bak in baks) {
                [fileManager removeItemAtPath:bak error:error];
            }
        }
    }
    else {
        // 失败，还原备份
        for (NSString *bak in baks) {
            
            NSString *sourcePath = [bak substringToIndex:bak.length - 4];
            if ([fileManager fileExistsAtPath:sourcePath]) {
                [fileManager removeItemAtPath:sourcePath error:error];
            }
            [fileManager moveItemAtPath:bak toPath:sourcePath error:error];
        }
    }
    // 删除下载的 zip 包
    [fileManager removeItemAtPath:zipFile error:error];
    return *error == nil;
}

@end


@implementation NSString (EMMW3FolderManager)

+ (NSString *)pathInDocumentDirWithW3FolderName:(NSString *)folderName {
    
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [documentDir stringByAppendingPathComponent:folderName];
}

@end