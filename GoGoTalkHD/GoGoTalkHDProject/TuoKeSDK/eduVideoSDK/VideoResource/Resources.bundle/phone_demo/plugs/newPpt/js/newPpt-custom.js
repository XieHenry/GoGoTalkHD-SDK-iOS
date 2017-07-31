/**
 * 动态PPT组件
 * @module newPptCustomModule
 * @description  动态PPT自封装组件
 * @author QiuShao
 * @date 2017/7/10
 */
;(function (factory) {
    if (typeof define === "function" && define.amd) {
        // AMD模式
        define(function( require, exports, module) {
            var GLOBAL = GLOBAL || {} ;
            var isAmd = true ;
            module.exports  =  factory( GLOBAL , isAmd);
        });
    } else {
        // 全局模式
        window.GLOBAL = window.GLOBAL || {} ;
        var isAmd = false ;
        window.NewPptAynamicPPT =  factory( window.GLOBAL , isAmd );
    }
}(function (GLOBAL , isAmd) {
    var NewPptAynamicPPT = function(options){
        'use strict';
        var that = this ;
        this.options = options || {};
        this.isResized =  false ;
        this.sendMessagePermission = this.options.sendMessagePermission ||  false ; //发送数据的权限
        this.recvRemoteDataing = this.options.recvRemoteDataing ||  false ; //接收远端数据，则不需要发送信令
        this.isOpenPptFile = false ;
        GLOBAL.newPptAynamicPPT ={
            that:that
        };
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
        this.remoteData = {} ;
        this.recvCount = 0 ;
    };

    NewPptAynamicPPT.prototype = {
        constructor:NewPptAynamicPPT,
        sendMessageToRemote:function (action , isGetData ) {
            var that = GLOBAL.newPptAynamicPPT.that ;
            isGetData = isGetData!=undefined ?isGetData :true ;
            if(that.sendMessagePermission){
                var data = {} ;
                if(isGetData && that.remoteData){
                    data.slide = that.remoteData.slide+1 ;
                    data.step =that.remoteData.step>=0?that.remoteData.step:0;
                    if(!data){
                        console.error("动态PPT的data没有数据");
                        return ;
                    }
                }
                for(var x in action){
                    data[x] = action[x];
                }
                data["total"] = that.remoteData.slidesCount ;
                $(document).trigger("sendPPTMessageEvent",[data]);
            }
        },
        resizeUpdatePPT:function(that){
            that.scale  = 1 ;
            $(window).trigger("resize");
        },
        resizeHandler:function (that) {
            var that = that || this ;
            if(that.isOpenPptFile){
                that.autoChangePptSize(that);
            }
        },
        autoChangePptSize:function(that){
            that = that || this ;
            /*
             if(that.remoteData.view && that.remoteData.view.width && that.remoteData.view.height){
             clearTimeout(that.autoChangePptSizeTimer);
             that.autoChangePptSizeTimer = setTimeout(function(){
             that.contentHolder =  $("#contentHolderNewppt") ;
             that.contentHolderParent =   $("#aynamic_ppt_newppt") ;
             that.pptVesselElemnt =   $("#ppt_vessel_newppt");
             that.pptZoomElemnt =    $("#ppt_zoom_container_newppt");
             that.lcToolContainer =    $("#lc_tool_container");
             var whRatio = that.remoteData.view.width / that.remoteData.view.height ;
             var w , h ;
             // var scale = that.currScale ;
             var scale = 1 ;
             if(that.contentHolderParent.height() * whRatio < that.contentHolderParent.width()  ){
             that.scale = that.contentHolderParent.height() / that.remoteData.view.height  ;
             w = that.contentHolder.width() * that.scale * scale ;
             h = that.contentHolder.height() * that.scale  * scale;
             that.pptVesselElemnt.add(that.pptZoomElemnt).css({
             width:w+"px" ,
             height:h+"px"
             });
             }else {
             that.scale = that.contentHolderParent.width() / that.remoteData.view.width ;
             w = that.contentHolder.width() * that.scale * scale ;
             h = that.contentHolder.height() * that.scale * scale ;
             that.pptVesselElemnt.add(that.pptZoomElemnt).css({
             width:w+"px" ,
             height:h+"px"
             });
             }
             that.pptVesselElemnt.css({
             width:w+"px" ,
             height:h+"px"
             });
             that.contentHolder.css({
             "transform":"scale("+that.scale* scale+")" ,
             "left":"50%" ,
             "margin-top":(h/2 - that.remoteData.view.height /2) + "px" ,
             "margin-left":(w/2 - that.remoteData.view.width /2 - w/2  ) + "px" ,
             });
             },200);
             }
             */
        },
        changeAynamicPptData:function () {
            var that = this ;
            var ts = that.remoteData;
            if( !(ts.slide!=undefined && ts.step!=undefined) ){
                return ;
            }
            var data = {
                slide: ts.slide+1 ,
                step: ts.step
            };
            for (var key in that.aynamicPptData.now){
                that.aynamicPptData.old[key] = that.aynamicPptData.now[key]  ;
            }
            that.aynamicPptData.now.fileid = that.fileid ;
            that.aynamicPptData.now.slide = data.slide;
            that.aynamicPptData.now.step = data.step ;
        },
        playerControlClass:{
            HandleSlideChange:function(n) {
                //Handle slide change here
                var that = GLOBAL.newPptAynamicPPT.that ;


                $("#curr_ppt_page").html(n+1);
                $("#all_ppt_page").html(  that.remoteData.slidesCount );
                var data = {
                    slide:n+1 ,
                    total:that.remoteData.slidesCount ,
                    fileid:that.fileid
                };
                $(document).trigger("slideChangeToLcData", [data]);
            } ,
        },
        changeFileElementProperty:function () {
            var that = GLOBAL.newPptAynamicPPT.that ;
            var ts = that.remoteData;
            if( ts.step === undefined &&  ts.stepTotal === undefined &&  ts.slide === undefined){
                return ;
            }
            var stepTotal = ts.stepTotal ;
            var slide = ts.slide + 1 ;
            var step = ts.step ;
            if(slide <=1 && step<=0){
                $("#ppt_prev_page_slide[data-set-disabled=yes] ,#prev_page_phone_slide[data-set-disabled=yes]").removeClass("disabled").addClass("disabled").attr("disabled","disabled");
            }else{
                $("#ppt_prev_page_slide[data-set-disabled=yes] ,#prev_page_phone_slide[data-set-disabled=yes]").removeClass("disabled").removeAttr("disabled");
            }
            if(slide >= that.remoteData.slidesCount && step>=stepTotal-1){
                $("#ppt_next_page_slide[data-set-disabled=yes] ,#next_page_phone_slide[data-set-disabled=yes]").removeClass("disabled").addClass("disabled").attr("disabled","disabled");
            }else{
                $("#ppt_next_page_slide[data-set-disabled=yes] ,#next_page_phone_slide[data-set-disabled=yes]").removeClass("disabled").removeAttr("disabled");
            }
            $("#big_literally_vessel , #file_list_"+that.fileid )
                .attr("data-ppt-step" ,ts.step );
        },
        setSendMessagePermission:function (value) {
            var that = GLOBAL.newPptAynamicPPT.that ;
            that.sendMessagePermission = value ;
        },
        setRPathAndPres:function(options){
            var that = GLOBAL.newPptAynamicPPT.that ;
            options = options || {};
            that.rPathAddress = options.rPathAddress  ;
            that.PresAddress = options.PresAddress  ;
            that.fileid = options.fileid ||  null ;
            that.currScale = 1 ;
            var slideIndex = options.slideIndex || 1 ;
            var stepIndex = options.stepIndex || 0 ;
            that.remoteSlide = slideIndex;
            that.remoteStep = stepIndex;
            that.needUpdateSlideAndStep = true ;
            that.isInitFinsh = false ;
            that.setNewPptFrameSrc(that.rPathAddress+that.PresAddress);
            that.loading.loadingStart();
        },
        setNewPptFrameSrc:function (src) {
            var that = this ;
            if(src){
                $("#newppt_frame").attr("src", src) ;
            }else{
                $("#newppt_frame").removeAttr("src") ;
            }
        },
        clearAll:function () {
            var that = this ;
            that.isResized =  false ;
            that.isOpenPptFile = false ;
            that.firstLoaded = false ;
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
            that.setNewPptFrameSrc("");
            that.newpptFrame = null ;
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
        recvInitEventHandler:function (slideIndex , stepIndex) {
            var that = this ;
            that.isInitFinsh = true ;
            that.changeAynamicPptData();
            that.playerControlClass.HandleSlideChange(slideIndex);
            that.changeFileElementProperty();    
            if(that.needUpdateSlideAndStep){
                if(that.remoteSlide!=null && that.remoteStep!=null ){
                    that.jumpToAnim(that.remoteSlide ,that.remoteStep );
                    that.remoteSlide = null ;
                    that.remoteStep = null ;
                }
                that.needUpdateSlideAndStep = false ;
            };
            if(that.remoteActionData){
                that.postMessage(that.remoteActionData);
                that.remoteActionData = null ;
            }
            that.onInitaliseSettingsHandler();
            var data = {
                Width: that.remoteData.view.width,
                Height: that.remoteData.view.height
            }
            $(document).trigger("updateLcScaleWhenAynicPPTInit" , [data]); //更新动态ppt的白板尺寸
            that.loading.loadingEnd();
        },
        recvSlideChangeEventHandler:function (slideIndex) {
            var that  = this;
            that.changeAynamicPptData();
            that.playerControlClass.HandleSlideChange(slideIndex);
            that.changeFileElementProperty();     
             if(!that.isLoadInitSlideAndStep &&  that.remoteData.slide ===0 &&  that.remoteData.step===0 ){
                that.isLoadInitSlideAndStep = true ;
                return ;
            }       
            that.sendMessageToRemote({action: "slide"});
            
        },
        recvStepChangeEventHandler:function (stepIndex) {
            var that  = this;
            that.changeAynamicPptData();
            that.changeFileElementProperty();
            if(!that.isLoadInitSlideAndStep &&  that.remoteData.slide ===0 &&  that.remoteData.step===0 ){
                that.isLoadInitSlideAndStep = true ;
                return ;
            }
            that.sendMessageToRemote({action: "step"});
        },
        newDopPresentation:function(options , loadUrl){ //初始化PPT对象
            var that = GLOBAL.newPptAynamicPPT.that ;
            that.options = options || that.options  ;
            that.resetParameter(that.options);
            that.playbackController  = null ;
            that.remoteData.slidesCount  = null ;
            that.isPlayedPresentation  = null ;
            that.remoteData.view  = null ;
            that.presentation  = null ;
            that.isLoadInitSlideAndStep  = false ;
            if(!that.isResized){
                that.resizeUpdatePPT(that);
                that.isResized = true ;
            }
            if (!that.firstLoaded) {
                that.firstLoaded = true;
                $('#ppt_prev_page , #ppt_next_page , #btnPause , #btnPlay , #ppt_next_page_slide ,#ppt_prev_page_slide , #btnGoto , #resizer , #aynamic_ppt_click  , #tool_zoom_big_ppt , #tool_zoom_small_ppt , #prev_page_phone_slide , #next_page_phone_slide').off("click mousedown");
                $('#ppt_prev_page_slide,#prev_page_phone_slide').click(function(){
                    var plugs =  $(this).attr("data-plugs") ;
                    if(plugs == "newppt"){
                        that.recvCount = 0 ;
                        that.gotoPreviousStep();
                        return false ;
                    }
                }) ;


                $('#ppt_next_page_slide,#next_page_phone_slide').click(function(){
                    var plugs =  $(this).attr("data-plugs") ;
                    if(plugs == "newppt"){
                        that.recvCount = 0 ;
                        that.gotoNextStep();
                        return false ;
                    }
                }) ;


                $("#tool_zoom_big_ppt").off("click");
                $("#tool_zoom_big_ppt").click(function(){
                    var plugs =  $(this).attr("data-plugs") ;
                    if(plugs == "newppt"){
                        that.currScale += 0.5 ;
                        if(that.currScale >=3){
                            that.currScale = 3 ;
                        }
                        checkZoomStatus();
                        that.autoChangePptSize(that);
                    }
                });
                $("#tool_zoom_small_ppt").off("click");
                $("#tool_zoom_small_ppt").click(function(){
                    var plugs =  $(this).attr("data-plugs") ;
                    if(plugs == "newppt"){
                        that.currScale -= 0.5 ;
                        if(that.currScale <=1){
                            that.currScale = 1 ;
                        }
                        checkZoomStatus();
                        that.autoChangePptSize(that);
                    }
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
                    eventSelector:'#ppt_prev_page , #ppt_next_page , #btnPause , #btnPlay , #ppt_next_page_slide ,#ppt_prev_page_slide , #btnGoto , #resizer , #aynamic_ppt_click , #prev_page_phone_slide , #next_page_phone_slide ' ,
                    eventName:'click mousedown' ,
                    rolePermissionNotExecute:'chairman' ,
                    needClassBegin:true ,
                };
                $(document).trigger("cancelEvent" , [eventData]) ;
            }
            return that ;
        } ,
        resetParameter:function(options){ //重置参数
            this.playbackController  = null ;
            this.slidesCount  = null ;
            this.isPlayedPresentation  = null ;
            this.view  = null ;
            this.presentation  = null ;
            this.options = options || this.options  || {};
            this.rPathAddress = options.rPathAddress  ;
            this.PresAddress = options.PresAddress ;
            this.fileid = options.fileid ||  null ;
            this.remoteSlide = options.remoteSlide ||  null ;
            this.remoteStep = options.remoteStep ||  null ;
            this.needUpdateSlideAndStep = false ;
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
            this.isTouchDevice = null ;
            this.ipadKeyPadFlg = null ;
            this.isPlaying = false ;
            this.remoteData = {};
        },
        postMessage:function (data) {
            var that  = this ;
            that.newpptFrame =  that.newpptFrame  ||  document.getElementById("newppt_frame")  ;
            if( that.newpptFrame.getAttribute("src") ){
                data["sendAuthor"] = "newppt_iframe_father" ;
                data = JSON.stringify(data);
                if(that.newpptFrame && that.newpptFrame.contentWindow){
                    //that.newpptFrame.contentWindow.postMessage(data , that.newpptFrame.getAttribute("src") );
                    that.newpptFrame.contentWindow.postMessage(data ,"*" );
                }else{
                    console.error("postMessage error【that.newpptFrame ，that.newpptFrame.contentWindow 】:" , that.newpptFrame , that.newpptFrame.contentWindow);
                }
            }
        },
        jumpToAnim:function (slide,step , timeOffset , autoStart ) {
            var that = GLOBAL.newPptAynamicPPT.that ;
            //that.needUpdateSlideAndStep = false ;
            that.jumpToAnimTimer = that.jumpToAnimTimer || null ;
            if(that.isInitFinsh){
                // clearTimeout(that.jumpToAnimTimer);
                // that.jumpToAnimTimer = setTimeout(function () {
                var data = {
                    action:"jumpToAnim" ,
                    data:{
                        slide:slide ,
                        step:step ,
                        timeOffset:timeOffset ,
                        autoStart:autoStart
                    }
                } ;
                that.postMessage(data);
                // },200);
            }
        },
        onInitaliseSettingsHandler:function(){ //InitaliseSettings后的处理函数
            var that = GLOBAL.newPptAynamicPPT.that ;
            // var $objResizer = $('#newppt_frame');
            // $objResizer.height(  that.remoteData.view.height );
            // $objResizer.width( that.remoteData.view.width );
            //
            // var $objContentHolder = $('#contentHolderNewppt');
            // $objContentHolder.height( that.remoteData.view.height);
            // $objContentHolder.width(that.remoteData.view.width);
            $("#big_literally_vessel , #file_list_"+that.fileid )
                .attr("data-total-page" ,that.remoteData.slidesCount );
        } ,
        gotoPreviousStep:function () {
            var that = this ;
            if(that.isInitFinsh) {
                //clearTimeout(that.actionTimer);
                //that.actionTimer = setTimeout(function () {
                var data = {
                    action:"gotoPreviousStep" ,
                } ;
                that.postMessage(data);
                //},100);
            }
        },
        gotoNextStep:function () {
            var that = this ;
            if(that.isInitFinsh) {
                //clearTimeout(that.actionTimer);
                //that.actionTimer = setTimeout(function () {
                that.recvCount = 0 ;
                var data = {
                    action:"gotoNextStep" ,
                } ;
                that.postMessage(data);
                //},100);
            }
        },
        gotoPreviousStep:function () {
            var that = this ;
            if(that.isInitFinsh) {
                //clearTimeout(that.actionTimer);
                //that.actionTimer = setTimeout(function () {
                that.recvCount = 0 ;
                var data = {
                    action:"gotoPreviousStep" ,
                } ;
                that.postMessage(data);
                //},100);
            }
        },
        gotoNextSlide:function (autoStart) {
            var that = this ;
            if(that.isInitFinsh) {
                //clearTimeout(that.actionTimer);
                //that.actionTimer = setTimeout(function () {
                var ts = that.remoteData;
                if( !(ts.slide!=undefined && ts.step!=undefined) ){
                    return ;
                }
                var data = {
                    slide: ts.slide+1 ,
                    step: ts.step
                };
                if(that.remoteData.slidesCount   &&   data.slide< that.remoteData.slidesCount) {
                    that.recvCount = 0;
                    var sendData = {
                        action:"gotoNextSlide" ,
                        autoStart:autoStart
                    } ;
                    that.postMessage(sendData);
                }
                //},100);
            }
        },
        gotoPreviousSlide:function (autoStart) {
            var that = this ;
            if(that.isInitFinsh) {
                //clearTimeout(that.actionTimer);
                //that.actionTimer = setTimeout(function () {
                var ts = that.remoteData;
                if( !(ts.slide!=undefined && ts.step!=undefined) ){
                    return ;
                }
                var data = {
                    slide: ts.slide+1 ,
                    step: ts.step
                };
                if(that.remoteData.slidesCount  &&  data.slide > 1 ) {
                    that.recvCount = 0;
                    var sendData = {
                        action:"gotoPreviousSlide" ,
                        autoStart:autoStart
                    } ;
                    that.postMessage(sendData);
                }
                //},100);
            }
        },
        loading:{ //加载ppt
            loadingStart:function(){
                //$("#preloader_newppt").css("display" , 'block');
            } ,
            loadingEnd:function(){
                var that = GLOBAL.newPptAynamicPPT.that ;
                //$("#preloader_newppt").css("display" , 'none');
            }
        },
    };

    return NewPptAynamicPPT ;
}));

