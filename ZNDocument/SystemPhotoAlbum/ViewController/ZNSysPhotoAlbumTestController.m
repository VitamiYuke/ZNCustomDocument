//
//  ZNSysPhotoAlbumTestController.m
//  ZNDocument
//
//  Created by 张楠 on 16/12/28.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNSysPhotoAlbumTestController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"
#import "JKImagePickerController.h"
#import "ZNRecordVideoController.h"
#import "ZNSmallVideoPlayView.h"


@interface ZNSysPhotoAlbumTestController ()<JKImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;

@property (strong,nonatomic)NSMutableArray *assetsArray;//类似微博的已选相册

@property(nonatomic, strong)UIImageView *coverImage;
@property(nonatomic, strong)ZNOutputVideoModel *videoModel;

@end

@implementation ZNSysPhotoAlbumTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakify(self);
    ZNTestButton *previewAction = [[ZNTestButton alloc] initWithFrame:CGRectMake(50, 50, 100, 60) title:@"浏览" action:^{
        [weakSelf lookLocalPhotoAlbum];
    }];
    [self.view addSubview:previewAction];
    
    
    ZNTestButton *photoAlbumAction = [[ZNTestButton alloc] initWithFrame:CGRectMake(50, 120, 100, 60) title:@"相册" action:^{
        [weakSelf lookPhotoAlbum];
    }];
    [self.view addSubview:photoAlbumAction];
    
    
    ZNTestButton *weiboAlbumAction = [[ZNTestButton alloc] initWithFrame:CGRectMake(160, 50, 100, 60) title:@"类似微博" action:^{
        [weakSelf lookWeiBoPhotoAlbum];
    }];
    [self.view addSubview:weiboAlbumAction];
    
    
    ZNTestButton *weichatAlbumAction = [[ZNTestButton alloc] initWithFrame:CGRectMake(160, 120, 150, 60) title:@"类似微信朋友圈" action:^{
        [weakSelf getAlbumLikeWX];
    }];
    [self.view addSubview:weichatAlbumAction];
    
    [self.view addSubview:self.coverImage];
    
}


- (void)lookLocalPhotoAlbum
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] initWithIsHaveSmallVideo:YES];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 3;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;
    weakify(self);
    [actionSheet showPreviewPhotoWithSender:self animate:YES lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
        strongify(weakSelf);
        strongSelf.lastSelectMoldels = selectPhotoModels; //用来标记已选的图片

    }];
}


// 创建
- (void)lookPhotoAlbum
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] initWithIsHaveSmallVideo:NO];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 3;
    weakify(self);    
    [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
        strongify(weakSelf);
        strongSelf.lastSelectMoldels = selectPhotoModels; //用来标记已选的图片
        MyLog(@"%@",selectPhotos);
    }];
    
    actionSheet.finishSucc = ^(ZNOutputVideoModel * _Nonnull outPutModel) {
        strongify(weakSelf);
        MyLog(@"时间长度:%d",outPutModel.video_time);
        MyLog(@"存储地址:%@",outPutModel.outputPath);
        MyLog(@"封面地址:%@",outPutModel.cover);
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.videoModel = outPutModel;
            strongSelf.coverImage.image = outPutModel.cover;
        });
    };
    
    
    
    
}

//累死微博的相册
- (void)lookWeiBoPhotoAlbum{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;//最小选取照片数
    imagePickerController.maximumNumberOfSelection = 3;//最大选取照片数
    imagePickerController.selectedAssetArray =self.assetsArray;//已经选择了的照片
    UINavigationController*navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - 代理
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.assetsArray=[assets mutableCopy];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
    for (JKAssets *asset in assets) {
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//                NSData *imageData = UIImageJPEGRepresentation(image,0.5);
                MyLog(@"选择的照片:%@",image);
                
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}





#pragma mark - 蕾丝微信朋友圈
- (void)getAlbumLikeWX{
    
    
    znWeakSelf(self);
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        
        
        if (buttonIndex == 1) {
            MyLog(@"手机拍摄");
        }
        
        
        
        if (buttonIndex == 2) {
            
            [weakSelf lookPhotoAlbum];
            
            
        }
        
        
    } otherButtonTitles:@"拍摄",@"从手机相册中选择", nil];
    [sheet show];
}




- (UIImageView *)coverImage{
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 190, 100, 160)];
        _coverImage.userInteractionEnabled = YES;
        //        _coverImage.image = [UIImage imageNamed:@"gradual_index_01txt"];
        [_coverImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)]];
    }
    return _coverImage;
}


- (void)playVideo{
    
    if (self.videoModel.outputPath) {
        //        [[[UIApplication sharedApplication] keyWindow] addSubview:self.playView];
        //
        //        self.playView.videoUrl = [NSURL fileURLWithPath:self.videoModel.outputPath];
        [ZNSmallVideoPlayView showWithVideoUrl:[NSURL fileURLWithPath:self.videoModel.outputPath] sourceImageView:self.coverImage];
        
    }
    
    //    [ZNSmallVideoPlayView showWithVideoUrl:nil sourceImageView:self.coverImage];
    
    
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
