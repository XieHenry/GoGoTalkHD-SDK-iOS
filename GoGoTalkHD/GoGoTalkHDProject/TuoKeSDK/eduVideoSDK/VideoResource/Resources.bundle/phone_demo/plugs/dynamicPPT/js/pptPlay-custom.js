var GLOBAL = GLOBAL || {} ;
var Presentation = Presentation || null ;
var AynamicPPT = function(options){
	this.options = options || {};
	var that = this ;
	this.isResized =  false ;
	this.sendMessagePermission = this.options.sendMessagePermission ||  false ; //发送数据的权限
    this.recvRemoteDataing = this.options.recvRemoteDataing ||  false ; //接收远端数据，则不需要发送信令
    this.isOpenPptFile = false ;
	GLOBAL.aynamicPPT ={
		that:that
	}
	this.aynamicPptData = {
	  old:{
	      slide:null ,
          step:null ,
          fileid:null
      } ,
	  now:{
          slide:null ,
          step:null ,
          fileid:null
      }
    };

    this.recvAynamicPptData = {
        slide:null ,
        step:null ,
        fileid:null
    };
    this.recvCount = 0 ;
};

AynamicPPT.prototype = {
	constructor:AynamicPPT,
    clearAll:function () {
	    var that = this ;
        that.stop();
        that.isResized =  false ;
        that.isOpenPptFile = false ;
        Presentation = null ;
        that.sendMessagePermission = this.options.sendMessagePermission ||  false ; //发送数据的权限
        that.recvRemoteDataing = this.options.recvRemoteDataing ||  false ; //接收远端数据，则不需要发送信令
        that.contentHolder = null;
        that.contentHolderParent =  null ;
        that.pptVesselElemnt =   null;
        that.pptZoomElemnt =  null;
        that.lcToolContainer =   null;
        that.presSettings = {};
        that.aynamicPptData = {
            old:{
                slide:null ,
                step:null ,
                fileid:null
            } ,
            now:{
                slide:null ,
                step:null ,
                fileid:null
            }
        };
        that.resetRecvAynamicPptData();
        that.recvCount = 0 ;
    },
	stop:function () {
       if(Presentation && Presentation.stop){
           Presentation.Pause();
       }
    },
	resetParameter:function(options){ //重置参数
        this.options = options || this.options  || {};
		this.rPathAddress = options.rPathAddress || "data/" ;
		this.PresAddress = options.PresAddress || 'pres/' ;
        this.fileid = options.fileid ||  null ;
		this.remoteSlide = options.remoteSlide ||  null ;
        this.remoteStep = options.remoteStep ||  null ;
        this.currScale = 1 ;
        this.recvCount = 0 ;
        this.isOpenPptFile = false ;
        this.aynamicPptData = {
            old:{
                slide:null ,
                step:null ,
                fileid:null
            } ,
            now:{
                slide:null ,
                step:null ,
                fileid:null
            }
        };

        this.resetRecvAynamicPptData();
		this.formatedTotalTime = null ;
		this.presSettings = {} ;
		this.firstLoaded = false ;
		this.isTouchDevice = null ;
		this.ipadKeyPadFlg = null ;
		this.isPlaying = false ;
		Presentation = null;
	},
	eventsHandler:function(){ //事件处理
		var that = GLOBAL.aynamicPPT.that ;
		this.OnLoadingStart = function() {
			//Do stuff to handle loading of slides.
            that.loading.LoadingStart();
		};
		this.OnLoadingEnd = function() {
            //Do stuff to handle loading of slides
            var that = GLOBAL.aynamicPPT.that ;
            // if(  that.remoteSlide!=null || that.remoteStep != null ){
             //    that.jumpToAnim(that.remoteSlide ,that.remoteStep );
             //    that.remoteSlide = null ;
             //    that.remoteStep = null ;
			// }
			that.loading.loadingEnd();
		};
		this.OnSlideChange = function(slideNo) {
            // console.error("OnSlideChange", slideNo , arguments ,  Presentation.CurrentStatus());
            // console.error(Presentation.GetFormatedNotes(slideNo));
			//Do stuff to handle change of slide.
            if(that.isOpenPptFile) {
                that.OnSlideChangeTimer = that.OnSlideChangeTimer || null;
                clearTimeout(that.OnSlideChangeTimer);
                that.OnSlideChangeTimer = setTimeout(function () {
                    try {
                        // if(that.recvCount >0){
                        //     that.recvCount--;
                        // }
                        that.changeAynamicPptData();
                        that.playerControlClass.HandleSlideChange(slideNo);
                        that.changeFileElementProperty();
                        that.sendMessageToRemote({action: "slide"});
                    } catch (e) {
                        console.error("OnSlideChange", e);
                    }
                }, 0);
            }
		};
		this.OnSlideEnd = function (slideIndex) {
			//Do stuff to handle end of slide.
            // console.error(Presentation);
            // Presentation.stop();
    	};
		this.OnMovToNxtAnim = function() {
        	// Do stuff to handle move next animation
            // console.log("OnMovToNxtAnim",arguments ,  Presentation.CurrentStatus());
            if(that.isOpenPptFile) {
                that.OnMovToNxtAnimTimer = that.OnMovToNxtAnimTimer || null;
                clearTimeout(that.OnMovToNxtAnimTimer);
                that.OnMovToNxtAnimTimer = setTimeout(function () {
                    try {
                        // if(that.recvCount >0){
                        //     that.recvCount--;
                        // }
                        that.changeAynamicPptData();
                        that.changeFileElementProperty();
                        that.sendMessageToRemote({action: "step"});
                    } catch (e) {
                        console.error("OnMovToNxtAnim", e);
                    }
                }, 0);
            }
    	};
		this.OnMovToPrvAnim = function() {
        	//Do stuff to handle move to previous animation
            // console.log("OnMovToPrvAnim",arguments);
            if(that.isOpenPptFile) {
                that.OnMovToPrvAnimTimer = that.OnMovToPrvAnimTimer || null;
                clearTimeout(that.OnMovToPrvAnimTimer);
                that.OnMovToPrvAnimTimer = setTimeout(function () {
                    try {
                        // if(that.recvCount >0){
                        //     that.recvCount--;
                        // }
                        that.changeAynamicPptData();
                        that.changeFileElementProperty();
                        that.sendMessageToRemote({action: "step"});
                    } catch (e) {
                        console.error("OnMovToPrvAnim", e);
                    }
                }, 0);
            }
    	};
		this.OnPlayingStart = function() {
			//Do stuff to handle start of playing of animation or transition
			that.isPlaying = true;
        	that.playerControlClass.HandlePlayAndPause(that.isPlaying);
		};
		this.OnPlayingEnd = function() {
			//Do stuff to handle end of playing of animation or transition
			that.isPlaying = false;
        	that.playerControlClass.HandlePlayAndPause(that.isPlaying);
		};
		this.OnProgressChange = function(t) {
			//Gives progress of presentation in time
			that.playerControlClass.HandleProgress(t);
		};
		this.InitaliseSettings = function(o) {
			//initialises presentation details.
			that.presSettings = o ;
			that.onInitaliseSettingsHandler();
			$(document).trigger("updateLcScaleWhenAynicPPTInit" , [that.presSettings]); //更新动态ppt的白板尺寸
			$(window).trigger("resize");
		};
	},
    changeAynamicPptData:function () {
	    var that = this ;
        var data = Presentation.CurrentStatus() ;
        if(!data){
            console.error("动态PPT的data没有数据");
            return ;
        }else{
            for (var key in that.aynamicPptData.now){
                that.aynamicPptData.old[key] = that.aynamicPptData.now[key]  ;
            }
            that.aynamicPptData.now.fileid = that.fileid ;
            that.aynamicPptData.now.slide = data.slide;
            that.aynamicPptData.now.step = data.step ;
        }
    },
    changeRecvAynamicPptData:function (data) {
        this.recvAynamicPptData = {
            slide:data.slide ,
            step:data.step ,
            fileid:data.fileid
        };
    },
    resetRecvAynamicPptData:function () {
        this.recvAynamicPptData = {
            slide:null ,
            step:null ,
            fileid:null
        };
    },
    setSendMessagePermission:function (value) {
        var that = GLOBAL.aynamicPPT.that ;
        that.sendMessagePermission = value ;
    },
    changeFileElementProperty:function () {
        var that = GLOBAL.aynamicPPT.that ;
        var data = Presentation.CurrentStatus() ;
        if(!data){
            console.error("动态PPT的data没有数据");
            return ;
        }
        $("#big_literally_vessel , #file_list_"+that.fileid )
			.attr("data-ppt-step" ,data.step );
    },
    sendMessageToRemote:function (action , isGetData) {
        var that = GLOBAL.aynamicPPT.that ;
        isGetData = isGetData!=undefined ?isGetData :true ;
        if(that.sendMessagePermission){
        	// if(!that.recvRemoteDataing){
                // that.sendTimer = that.sendTimer!=undefined?that.sendTimer:null ;
                // clearTimeout(that.sendTimer);
                // that.sendTimer = setTimeout(function () {
                    var data = {} ;
                    if(isGetData){
                        var data = Presentation.CurrentStatus() ;
                        if(!data){
                            console.error("动态PPT的data没有数据");
                            return ;
                        }
                    }
                    for(var x in action){
                        data[x] = action[x];
                    }
                    data["total"] = that.presSettings.TotalSlides ;
                    $(document).trigger("sendPPTMessageEvent",[data]);
                // },0);
			// }
		}
    },
	newDopPresentation:function(options , loadUrl){ //初始化PPT对象
		var that = GLOBAL.aynamicPPT.that ;
		that.options = options || that.options  ;
		that.resetParameter(that.options);
		if (!(document.createElement('canvas').getContext)) {
			$("#resizer").html("");
	        console.error('Oops! Your browser does not support HTML5. You need to upgrade your browser to view this content.');
	        return;
	    }
		//initialize presentation.
		Presentation = new DopPresentation(new that.eventsHandler() , {width:50});
		if(loadUrl){
            Presentation.SetRPath(that.rPathAddress);
            var slideIndex = that.options.slideIndex || 1 ;
            Presentation.LoadPres(that.PresAddress,slideIndex);
            
		}
    	if(!that.isResized){
    		that.resizeUpdatePPT(that);
			that.isResized = true ;
		}
    	return that ;
	} ,
	autoChangePptSize:function(that){
		that = that || this ;
        if(Presentation && that.presSettings){
            setTimeout(function(){
                that.contentHolder = that.contentHolder || $("#contentHolder") ;
                that.contentHolderParent =  that.contentHolderParent || $("#aynamic_ppt") ;
                that.pptVesselElemnt =   that.pptVesselElemnt ||  $("#ppt_vessel");
                that.pptZoomElemnt =   that.pptZoomElemnt ||  $("#ppt_zoom_container");
                that.lcToolContainer =    that.lcToolContainer  || $("#lc_tool_container");
                var whRatio = that.presSettings.Width / that.presSettings.Height ;

                var w , h ;
                // var scale = that.currScale ;
                var scale = 1 ;
                if(that.contentHolderParent.height() * whRatio < that.contentHolderParent.width()  ){
                    that.scale = that.contentHolderParent.height() / that.presSettings.Height ;
                    w = that.contentHolder.width() * that.scale * scale ;
                    h = that.contentHolder.height() * that.scale  * scale;
                    that.pptVesselElemnt.add(that.pptZoomElemnt).css({
                        width:w+"px" ,
                        height:h+"px"
                    });
                    // that.pptVesselElemnt.add(that.pptZoomElemnt).css({"margin-top":"0px" , "margin-left":-that.pptVesselElemnt.width()/2+"px" , "top":"0px" , "left":"50%" });
                }else {
                    that.scale = that.contentHolderParent.width() / that.presSettings.Width ;
                    w = that.contentHolder.width() * that.scale * scale ;
                    h = that.contentHolder.height() * that.scale * scale ;
                    that.pptVesselElemnt.add(that.pptZoomElemnt).css({
                        width:w+"px" ,
                        height:h+"px"
                    });
                    // that.pptVesselElemnt.add(that.pptZoomElemnt).css({"margin-left":"0px" , "margin-top":-that.pptVesselElemnt.height()/2+"px" , "left":"0px" , "top":"50%"  });
                }
                that.pptVesselElemnt.css({
                    width:w+"px" ,
                    height:h+"px"
                });
                that.contentHolder.css({
                    "transform":"scale("+that.scale* scale+")" ,
                    "margin-top":(h/2 - that.presSettings.Height/2) + "px" ,
                    "margin-left":(w/2 - that.presSettings.Width/2 - w/2  ) + "px" ,
                });
                // if(that.isOpenPptFile){
                 //    if(scale > 1){
                 //        that.pptVesselElemnt.removeClass("custom-scroll-bar").addClass("custom-scroll-bar");
                 //        if(  that.contentHolderParent.width()  - that.pptVesselElemnt.width() < that.lcToolContainer.width() ){
                 //            that.lcToolContainer.css({"right":"0.15rem"});
                 //        }else{
                 //            that.lcToolContainer.css({"right":""});
                 //        }
                 //    }else{
                 //        that.pptVesselElemnt.removeClass("custom-scroll-bar");
                 //        that.lcToolContainer.css({"right":""});
                 //    }
				// }
            },0);
        }
	},
	resizeUpdatePPT:function(that){
        that.scale  = 1 ;
        $(window).resize(function(){
        	if(that.isOpenPptFile){
                that.autoChangePptSize(that);
			}
        });
        $(window).trigger("resize");
	},
	setRPathAndPres:function(options){
		var that = GLOBAL.aynamicPPT.that ;
		options = options || {};
		that.rPathAddress = options.rPathAddress || "data/" ;
		that.PresAddress = options.PresAddress || 'pres/' ;
        that.fileid = options.fileid ||  null ;
    	var slideIndex = options.slideIndex || 1 ;
        var stepIndex = options.stepIndex || 0 ;
        that.remoteSlide = slideIndex;
        that.remoteStep = stepIndex;
        that.currScale = 1 ;
        Presentation.SetRPath(that.rPathAddress);
        Presentation.LoadPres(that.PresAddress , slideIndex);
	},
    jumpToAnim:function (slide,step) {
        var that = GLOBAL.aynamicPPT.that ;
        that.jumpToAnimTimer = that.jumpToAnimTimer || null ;
        clearTimeout(that.jumpToAnimTimer);
        that.jumpToAnimTimer = setTimeout(function () {
            if(slide != undefined && step!=undefined ){
                Presentation.JumpToAnim(step, slide);
            }else if(slide != undefined){
                Presentation.GotoSlide(slide)
            }else if(step != undefined){
                Presentation.JumpToAnim(step);
            }else{
                console.error("slide 和 step必须有值");
            }
		},200);
    },
	onInitaliseSettingsHandler:function(){ //InitaliseSettings后的处理函数
		var that = GLOBAL.aynamicPPT.that ;

		var $objResizer = $('#resizer');
		$objResizer.height(  that.presSettings.Height );
		$objResizer.width( that.presSettings.Width );

	    var $objContentHolder = $('#contentHolder');
	    $objContentHolder.css({
	    	"background-color":that.presSettings.BackColr
	    });
	    $objContentHolder.height(that.presSettings.Height);
	    $objContentHolder.width(that.presSettings.Width);

	    var s = Math.floor((that.presSettings.TotalTime / 1000) % 60);
	    var m = Math.floor(((that.presSettings.TotalTime / 1000) / 60) % 60);
	    var h = Math.floor((((that.presSettings.TotalTime / 1000) / 60) / 60) % 24);

	    if (s < 10) {
	        s = "0" + s;
	    }
	    if (m < 10) {
	        m = "0" + m;
	    }
	    if (h < 10) {
	        h = "0" + h;
	    }
	    if (h == 0) {
	        that.formatedTotalTime = m + ":" + s;
	    } else {
	       that. formatedTotalTime = +h + ":" + m + ":" + s;
	    }

        $("#big_literally_vessel , #file_list_"+that.fileid )
            .attr("data-total-page" ,that.presSettings.TotalSlides );
	} ,
	loading:{ //加载ppt
		LoadingStart:function(){
			$("#preloader").css("display" , 'block');
		} ,
		loadingEnd:function(){
			var that = GLOBAL.aynamicPPT.that ;
			$("#preloader").css("display" , 'none');
            if (!that.firstLoaded) {
                that.firstLoaded = true;
                $('#ppt_prev_page , #ppt_next_page , #btnPause , #btnPlay , #ppt_next_page_slide ,#ppt_prev_page_slide , #btnGoto , #resizer , #aynamic_ppt_click  , #tool_zoom_big_ppt , #tool_zoom_small_ppt').off("click mousedown");
               // $('#ppt_prev_page').click(Presentation.Prev) ;
               //  $('#ppt_next_page').click(Presentation.Next) ;
                // $('#btnPause').click( Presentation.Pause) ;
                // $('#btnPlay').click(Presentation.Play) ;
                $('#ppt_prev_page_slide').click(function(){
                    // var data = Presentation.CurrentStatus() ;
                    // if(data){
                    //     if(data.slide > 1){
                    //         // that.jumpToAnim(data.slide-1,0);
                    //         that.recvCount = 0 ;
                    //         Presentation.PrvSlide();
                    //     }
                    // }
                    that.recvCount = 0 ;
                    Presentation.Prev();
                    return false ;
                }) ;
                $("#prev_page_phone_slide").click(function(){
                    that.recvCount = 0 ;
                    Presentation.Prev();
                }) ;
				$("#next_page_phone_slide").click(function(){
                    that.recvCount = 0 ;
                    Presentation.Next();
                }) ;
                $('#ppt_next_page_slide').click(function(){
                    // var data = Presentation.CurrentStatus() ;
                    // if(data){
                    //     if(data.slide < that.presSettings.TotalSlides){
                    //         // that.jumpToAnim(data.slide+1,0);
                    //         that.recvCount = 0 ;
                    //         Presentation.NxtSlide();
                    //     }
                    // }
                    that.recvCount = 0 ;
                    Presentation.Next();
                    return false ;
                }) ;
                
                // $('#btnGoto').click(that.playerControlClass.HandleGoto) ;

                $('#resizer').click(function(){
                    /*TODO 这里需要对点击resize就执行Next操作进行修改，底层已经执行Next*/
                    // Presentation.Next();
                    return false ;
                }) ;
                $("#aynamic_ppt_click").click(function () {
                    // that.recvCount = 0 ;
                    // Presentation.Next();
                    return false ;
                });
                // $('#resizer').mousedown(function (e) {
                //     var e = e || window.event ;
                //     if(e.button == "2"){
                //         // console.error("执行右键代码");
                //         var data = Presentation.CurrentStatus() ;
                //         if(data.slide > 1){
                //             Presentation.Prev();
                //         }
                //     }
                //     return false ;
                // }) ;

                $("#tool_zoom_big_ppt").off("click");
                $("#tool_zoom_big_ppt").click(function(){
                    that.currScale += 0.5 ;
                    if(that.currScale >=3){
                        that.currScale = 3 ;
                    }
                    checkZoomStatus();
                    that.autoChangePptSize(that);
                });
                $("#tool_zoom_small_ppt").off("click");
                $("#tool_zoom_small_ppt").click(function(){
                    that.currScale -= 0.5 ;
                    if(that.currScale <=1){
                        that.currScale = 1 ;
                    }
                    checkZoomStatus();
                    that.autoChangePptSize(that);
                });
                function  checkZoomStatus() {
                    if( that.currScale>=3){
                        $("#tool_zoom_big_ppt").addClass("disabled").attr("disabled","disabled");
                    }else{
                        $("#tool_zoom_big_ppt").removeClass("disabled").removeAttr("disabled");
                    }
                    if( that.currScale<=1){
                        $("#tool_zoom_small_ppt").addClass("disabled").attr("disabled","disabled");
                    }else{
                        $("#tool_zoom_small_ppt").removeClass("disabled").removeAttr("disabled");
                    }
                    $(document).trigger("updateLcScale" , [that.currScale]);
                }
                checkZoomStatus();
                var eventData = {
                    eventSelector:'#ppt_prev_page , #ppt_next_page , #btnPause , #btnPlay , #ppt_next_page_slide ,#ppt_prev_page_slide , #btnGoto , #resizer , #aynamic_ppt_click  ' ,
                    eventName:'click mousedown' ,
                    rolePermissionNotExecute:'chairman' ,
                    needClassBegin:true ,
                };
                $(document).trigger("cancelEvent" , [eventData]) ;
            }
		}
	},
	addEvent:function () {

    },
	playerControlClass:{
		HandlePlayAndPause:function(f) {
        	//Handle play pause here
	        if (f) {
	            $('btnPause').css("display" ,  'block' ) ;
	            $('btnPlay').css("display" ,  'none' ) ;
	        } else {
	        	$('btnPause').css("display" ,  'none' ) ;
	            $('btnPlay').css("display" ,  'block' ) ;
	        }
	    } ,
	    HandleSlideChange:function(n) {
	        //Handle slide change here
	        var that = GLOBAL.aynamicPPT.that ;
	        $("#s"+n+"s0.SC").show().siblings(".SC").hide();
	        if(n <=1){
                $("#ppt_prev_page_slide").removeClass("disabled").addClass("disabled").attr("disabled","disabled");
            }else{
                $("#ppt_prev_page_slide").removeClass("disabled").removeAttr("disabled");
            }
            if(n >= that.presSettings.TotalSlides ){
                $("#ppt_next_page_slide").removeClass("disabled").addClass("disabled").attr("disabled","disabled");
            }else{
                $("#ppt_next_page_slide").removeClass("disabled").removeAttr("disabled");
            }

	        $("#curr_ppt_page").html(n);
            $("#all_ppt_page").html(  that.presSettings.TotalSlides );
            // $("#big_literally_vessel , #file_list_"+that.fileid )
            //     .attr("data-ppt-slide" , n )
            //     .attr("data-curr-page" , n);

            var data = {
               slide:n ,
               total:that.presSettings.TotalSlides ,
               fileid:that.fileid
            };
            $(document).trigger("slideChangeToLcData", [data]);
            //   $("#SlideNumberDiv").html(n + '/' + that.presSettings.TotalSlides)
	    } ,
	    HandleProgress:function(t) {
	        //Handle presentation progress here
			var that = GLOBAL.aynamicPPT.that ;
	        var ratio = 300 / that.presSettings.TotalTime;
	        var width = t * ratio;
	        $("#ProgressBarDiv").width(width);

	        var s = Math.floor((t / 1000) % 60);
	        var m = Math.floor(((t / 1000) / 60) % 60);
	        var h = Math.floor((((t / 1000) / 60) / 60) % 24);

	        if (s < 10) {
	            s = "0" + s;
	        }

	        if (m < 10) {
	            m = "0" + m;
	        }

	        if (h < 10) {
	            h = "0" + h;
	        }

	        if (h == "00") {
	        	$("#time").html(m + ":" + s + '/' + that.formatedTotalTime);
	        } else {
	        	$("#time").html(h + ":" + m + ":" + s + '/' + that.formatedTotalTime);
	        }
	    },
	    HandleGoto:function() {
	    	var that = GLOBAL.aynamicPPT.that ;
	        var v = $("#inputGoto").value();
	        var n = parseInt(v);
	        if (n == isNaN)
	            return;
	        Presentation.GotoSlide(n);
	    }
	}
}
