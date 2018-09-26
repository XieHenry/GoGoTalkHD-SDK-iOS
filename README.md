# GoGoTalkHD-iOS


//WARK:拓课替换SDK--------上线版必须使用release版本。（替换前先备份相关sdk，再进行替换）

1.
_choosePicBtn = [self createCommonButtonWithFrame:CGRectMake(_takePhotoBtn.rightX + kMargin, self.height - kBtnHeight - kMargin, btnWidth, kBtnHeight) title:MTLocalized(@"UploadPhoto.FromGallery") backgroundColor:UIColorRGB(0xed9f3b)  selector:@selector(choosePicturesAction:)];
改为：
_choosePicBtn = [self createCommonButtonWithFrame:CGRectMake(_takePhotoBtn.x + _takePhotoBtn.width + kMargin, self.height - kBtnHeight - kMargin, btnWidth, kBtnHeight) title:MTLocalized(@"UploadPhoto.FromGallery") backgroundColor:UIColorRGB(0xed9f3b)  selector:@selector(choosePicturesAction:)];

2.
[self.iRightView addSubview:self.iClassBeginAndOpenAlumdView]; 注释


3.常用语修改，可以搜索RoomController.m中的常用语，都有注释。

4.如果麦克风或者照相机没开权限，进入教室，会提醒开权限，使用的是他们的本地文件，拓课云允许访问麦克风等，严格来说，需要改变他们的本地文件，可以自己搜索修改。------非必要
