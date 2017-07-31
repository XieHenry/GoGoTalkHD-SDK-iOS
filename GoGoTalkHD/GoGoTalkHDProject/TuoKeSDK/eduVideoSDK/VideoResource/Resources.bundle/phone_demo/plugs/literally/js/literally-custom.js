/**
 * 白板组件
 * @module literallyCustomModule
 * @description  白板自封装组件
 * @author QiuShao
 * @date 2017/7/10
 */

;(function (factory) {
    if (typeof define === "function" && define.amd) {
        // AMD模式
       /* define(function( require, exports, module) {
            var  LC = require("literallyCanvasCore");
            var GLOBAL = GLOBAL || {} ;
            var isAmd = true ;
            module.exports  =  factory(LC , GLOBAL , isAmd);
        });*/
		 // 全局模式
        window.GLOBAL = window.GLOBAL || {} ;
        var isAmd = false ;
        window.CustomLiterally =  factory( window.LC  , window.GLOBAL , isAmd );
    } else {
        // 全局模式
        window.GLOBAL = window.GLOBAL || {} ;
        var isAmd = false ;
        window.CustomLiterally =  factory( window.LC  , window.GLOBAL , isAmd );
    }
}(function (LC , GLOBAL , isAmd) {
    /*=======自定义Literally Canvas画板=============*/
    var CustomLiterally  = function(ele , cloneElement){
//	this.literallyIDPrefix = "literallyID_" ;
        GLOBAL.thisObj = this ;
        this.ele = ele || null   ;
        this.isResized = false ;
        this.isOpenLcFile = false ;
        this.cloneCanvasEle = cloneElement || null  ;
        this.lcLitellyScalc = 16 / 9 ;
        this.watermarkImage = null ;
        this.rolePermission = {
            laser:false
        } ;
        this.stackStorage  = {} ;//白板数据栈对象

        /*回掉函数*/
        this.callback = {
            onAddElementDisable:null ,
            onRemoveElementDisable:null ,
            onRemoveToolActive:null ,
            onToolActiveDetection:null
        };

        /*工具节点*/
        this.toolElement = {
            tool_pencil:"tool_pencil" ,
            tool_pencil_phone:"tool_pencil_phone" ,
            tool_eraser:"tool_eraser" ,
            tool_eraser_phone:"tool_eraser_phone" ,
            tool_text:"tool_text" ,
            tool_pan:"tool_pan" ,
            tool_line:"tool_line" ,
            tool_rectangle:"tool_rectangle" ,
            tool_rectangle_empty:"tool_rectangle_empty" ,
            tool_ellipse:"tool_ellipse" ,
            tool_ellipse_empty:"tool_ellipse_empty" ,
            tool_polygon:"tool_polygon" ,
            tool_eyedropper:"tool_eyedropper" ,
            tool_selectShape:"tool_selectShape" ,
            tool_arrow:"tool_arrow" ,
            tool_dashed:"tool_dashed" ,
            tool_fill_color:"tool_fill_color" ,
            tool_stroke_color:"tool_stroke_color" ,
            tool_background_color:"tool_background_color" ,
            tool_operation_undo:"tool_operation_undo" ,
            tool_operation_redo:"tool_operation_redo" ,
            tool_operation_clear:"tool_operation_clear" ,
            tool_zoom_big:"tool_zoom_big" ,
            tool_zoom_small:"tool_zoom_small" ,
            tool_zoom_default:"tool_zoom_default" ,
            tool_pan:"tool_pan" ,
            tool_pan_default:"tool_pan_default" ,
            tool_move_scrollbar:"tool_move_scrollbar" ,
            tool_mouse:"tool_mouse" ,
            tool_highlighter:"tool_highlighter" ,
            tool_laser:"tool_laser" ,
            tool_rotate_left:"tool_rotate_left" ,
            tool_rotate_right:"tool_rotate_right"
        };

        /*其它节点*/
        this.otherElement = {
            literallyDataLoadingWrap:"#literally_data_loading_wrap" ,
            whiteBoardOuterLayout:"#white_board_outer_layout" ,
            bigLiterallyWrap:"#big_literally_wrap" ,
            lcToolContainer:"#lc_tool_container" ,
            scrollLiterallyContainer:"#scroll_literally_container" ,
            MINWH:null ,
            BaseLiterallyWidth:960 ,
        };
        if (typeof define === "function" && define.amd && isAmd!=undefined && isAmd!= false) {
            this.defaultBackImgSrc = "./src/plugs/literally/lib/img/transparent_bg.png";
        }else{
            this.defaultBackImgSrc = "./plugs/literally/lib/img/transparent_bg.png";
        }

    };

    CustomLiterally.prototype = {
        constructor:CustomLiterally,
        initConfig:{
            primaryColor:"#000000" ,
            secondaryColor:"#ffffff" ,
            backgroundColor:"#ffffff" ,
            backgroundShapes:[] ,
            snapshot: JSON.parse(localStorage.getItem('drawing')),
            keyboardShortcuts:true ,
            defaultStrokeWidth: 5,
            strokeWidths: [1, 2, 5, 10, 20, 30] ,
            toolbarPosition: 'top'
        } ,
        clearAll:function(resetLc){
            resetLc = resetLc!=undefined && resetLc!=null?resetLc:true ;
            if(this.lc){
                this.lc.clear(false);
                this.lc.redoStack.length = 0 ;
                this.lc.undoStack.length = 0 ;
                this.stackStorage  = {} ;//白板数据栈对象
            }
            if(resetLc){
                this.isResized = false;
                this.lc = null ;
                this.ele = null ;
                this.cloneCanvasEle = null ;
            }
        },
        lcInit:function(ele , cloneElement , operationUserThirdid ,  initConfig , isDefalutClear , isDefalutDrawingChangeEvent){
            this.lc = null ;
            this.ele = ele ||  this.ele || $("#lc_vessel") ;
            this.operationUserThirdid = operationUserThirdid || jQuery.getNewGUID() ;
            this.cloneCanvasEle = this.cloneCanvasEle || cloneElement  || $("#lc_canvas_clone") ;
            this.initConfig = initConfig || this.initConfig ;
            isDefalutClear = ( isDefalutClear == undefined || isDefalutClear == null || isDefalutClear==true ? true :false ) ;
            isDefalutDrawingChangeEvent = ( isDefalutDrawingChangeEvent == undefined || isDefalutDrawingChangeEvent == null || isDefalutDrawingChangeEvent==true ? true :false ) ;
            this.backImageResize(this,this.lcLitellyScalc,null,false);
            this.lc = LC.init(this.ele[0],this.initConfig);
            this.lc.setColor('background',this.initConfig.backgroundColor);
            this.lc.setColor('secondary',this.initConfig.secondaryColor);
            this.lc.setColor('primary',this.initConfig.primaryColor);
            this.lc.setZoom( 1 );
            this.lc.setPan(0,0);
            this.lc.backgroundShapes.length = 0;
            this.lc.backingScale = 1 ;
            if(isDefalutClear){
                this.lc.clear(false);
            }
//      this.lc.on('drawingChange', this.drawingChangeEvent);
            this.lc.on('shapeSave', this.shapeSaveEvent);
//      this.lc.on('snapshotLoad ', this.snapshotLoadEvent);
            this.lc.on("undo",this.undoEvent) ;
            this.lc.on("redo",this.redoEvent) ;
            this.lc.on("clear",this.clearEvent) ;
//      this.lc.on("doClearRedoStack",this.doClearRedoStackEvent) ;
//      this.lc.on("primaryColorChange",this.primaryColorChangeEvent) ;
//      this.lc.on("secondaryColorChange",this.secondaryColorChangeEvent) ;
//      this.lc.on("backgroundColorChange",this.backgroundColorChangeEvent) ;
//      this.lc.on("drawStart",this.drawStartEvent) ;
//      this.lc.on("drawContinue",this.drawContinueEvent) ;
//      this.lc.on("drawEnd",this.drawEndEvent) ;
//      this.lc.on("toolChange",this.toolChangeEvent) ;
//      this.lc.on('pan',  this.panEvent);
//      this.lc.on('zoom',  this.zoomEvent);
//      this.lc.on("repaint",this.repaintEvent) ;
//      this.lc.on("lc-pointerdown",this.lcPointerdownEvent) ;
//      this.lc.on("lc-pointerup",this.lcPointerupEvent) ;
//      this.lc.on("lc-pointermove",this.lcPointermoveEvent) ;
//      this.lc.on("lc-pointerdrag",this.lcPointerdragEvent) ;
            // this.setBackgroundWatermarkImage("./plugs/literally/lib/img/saturation.png");
            if(isDefalutDrawingChangeEvent){
                this.drawingChangeEvent();
            }

            /*白板工具状态量*/
            this.lc.toolStatus = {
                pencilWidth:5 ,
                eraserWidth:20 ,
                eyedropperIsStroke:"stroke" ,
                strokeColor:"#000000"  ,
                fillColor:"#ffffff" ,
                backgroundColor:"#ffffff" ,
                fontSize:30 ,
                fontFamily:"微软雅黑" ,
                fontStyle:"normal" ,
                fontWeight:"normal"
            };

            /*是否是谷歌*/
            this.isChrome = false ;
            var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
            if (userAgent.toString().toLocaleLowerCase().indexOf("chrome") > -1){
                this.isChrome = true ;
            }

            /*操作栈*/
            this.undoAndRedoStack = {} ;


            /*白板是否可画*/
            this.lc.canvasWrite ={
                isWrite:true ,
                isLoading:false
            };
            this.literallyOutsideScale = 1 ;  //白板外层盒子缩放默认为1
            /*更新canvas*/
            if(!this.isResized){
                this.resizeUpdateCanvas(this);
                this.isResized = true ;
            }
            return this ;
        },
        resetLcDefault:function () {
            var that = this ;
            that.eleWHPercent = 1 ;
            that.lc.rotateDeg = 0 ;
            that.scaleButtonStyle();
            that.resizeHandler(that);
        },
        resizeUpdateCanvas:function(that){
            that.x = 0 ;
            that.scale  = 1 ;
            that.eleWHPercent = 1 ; //canvas包裹元素宽高百分比
            that.y=0 ;
            that.canvastimer = null ;
            $(window).trigger("resize");
        },
        resizeHandler:function (that) {
            var that = that || this ;
            if(that.lc){
                var backImg = that.watermarkImage || that.lc.watermarkImage ;
                if(backImg && /plugs\/literally\/lib\/img\/transparent_bg.png/.test(backImg.src) == false ){
                    // if(that.isOpenLcFile) {
                    var imgScale = backImg.width / backImg.height;
                    that.backImageResize(that, imgScale, backImg, true, true);
                    // }
                }else if(backImg){
                    that.backImageResize(that,that.lcLitellyScalc,backImg,true,false);
                }
            }
        },
        batchReceiveSnapshot:function(shapeJsonList,userName){ //批量操作shape画图
            for (var i=0 ; i<shapeJsonList.length; i++ ) {
                var doNotPaint = true ;
                if( i == shapeJsonList.length-1){
                    doNotPaint = false ;
                }
                this.remoteSaveShape( shapeJsonList[i] , userName  , doNotPaint);
            }
            this.operationIsAbled();
        },
        receiveSnapshot:function(obj  , userName ){  //接收shape进行画操作
            var doNotPaint = false ;
            this.remoteSaveShape( obj  , userName  , doNotPaint);
            this.operationIsAbled();
        },
        remoteSaveShape:function(obj  , userName , doNotPaint){ //处理shape画操作
            if(obj.data!=null && obj.data.eventType!=null){
                switch(obj.data.eventType){
                    case "shapeSaveEvent":
//              	console.error( "shapeSaveEvent" , this.lc.redoStack , this.lc.undoStack );
                        if(obj.data.data.data){
                            obj.data.data = LC.JSONToShape(obj.data.data);
                        }
                        this.lc.saveShape(  obj.data.data  , false  , null , doNotPaint);
                        break ;
                    case "undoEvent":
//              	console.error( "undoEvent" , this.lc.redoStack , this.lc.undoStack );
                        if(obj.data.actionName && obj.data.actionName === "AddShapeAction"){
                            this.lc.undo(false , obj.data.shapeId);
                        }else if( obj.data.actionName && obj.data.actionName === "ClearAction" ){
                            this.lc.undo(false , obj.data.clearActionId);
                        }
                        break ;
                    case "redoEvent":
//              	console.error( "redoEvent" , this.lc.redoStack , this.lc.undoStack );
                        if(obj.data.actionName && obj.data.actionName === "AddShapeAction"){
                            var flag = false ;  //恢复栈中是否有该shape
                            for (var i= this.lc.redoStack.length-1 ; i>=0 ; i-- ) {
                                if( obj.data.shapeId === this.lc.redoStack[i].shapeId){
                                    this.lc.redoStack.splice(i,1);
                                    flag = true ;
                                    break ;
                                }
                            }
                            if(obj.data.data.data){
                                obj.data.data = LC.JSONToShape(obj.data.data);
                            }
                            this.lc.saveShape(  obj.data.data  , false  , null , doNotPaint);
                        }else if( obj.data.actionName && obj.data.actionName === "ClearAction" ){
                            this.lc.clear(false , null);
                        }
                        break ;
                    case "clearEvent":
//              	console.error( "clearEvent" , this.lc.redoStack , this.lc.undoStack );
                        this.lc.clear(false , null);
                        break ;
                    case "laserMarkEvent":
                        var $laserMark =  $(this.lc.containerEl).parent().find(".laser-mark");
                        switch (obj.data.action){
                            case "show":
                                $laserMark.show();
                                break;
                            case "hide":
                                $laserMark.hide();
                                break;
                            case "move":
                                if(obj.data && obj.data.laser){
                                    var left = obj.data.laser.left ;
                                    var top = obj.data.laser.top ;
                                    $laserMark.css({
                                        "left":left+"%" ,
                                        "top":top+"%"
                                    });
                                }
                                break;
                            default:
                                break;
                        }
                        break ;
                    default:
                        break ;
                }
            }
        },
        sendMessageCommonFunction:function(eventType , parameter){
            var thisObj = this ;
            switch(eventType){
                case "shapeSaveEvent":
//          	console.error("shapeSaveEvent" ,parameter);
                    var shapeData  = LC.shapeToJSON(parameter.shape);
                    if(shapeData!=null && shapeData.className != null && (shapeData.className == "LinePath" || shapeData.className == "ErasedLinePath" )){
                        shapeData.data.smoothedPointCoordinatePairs = null ;
                        delete shapeData.data.smoothedPointCoordinatePairs;
                        var tmpData = shapeData.data.pointCoordinatePairs ;
                        tmpData.forEach(function (item) {
                            item[0] = Math.round( item[0] )  ;
                            item[1] = Math.round(  item[1]  ) ;
                        });
                    }
                    var testData  = {eventType:eventType , data:shapeData };
                    var signallingName = "SharpsChange" ;
                    $(document).trigger("sendDataToLiterallyEvent",[ parameter.shapeId , testData , signallingName]);
                    break;
                case "undoEvent" :
//          	console.error("undoEvent" ,parameter);
                    if( parameter.action.constructor.name === "AddShapeAction" ){
                        var shapeId = parameter.action.shapeId ;
                        var testData  = {eventType:eventType , shapeId:shapeId , actionName:parameter.action.constructor.name};
                        var signallingName = "SharpsChange" ;
                        $(document).trigger("deleteLiterallyDataEvent",[ shapeId , testData , signallingName ]);
                    }else if(parameter.action.constructor.name === "ClearAction"){
                        var clearActionId = parameter.action.id ;
                        var testData  = {eventType:eventType , clearActionId:clearActionId  , actionName:parameter.action.constructor.name};
                        var signallingName = "SharpsChange" ;
                        $(document).trigger("deleteLiterallyDataEvent",[ clearActionId , testData , signallingName ]);
                    }
                    break ;
                case "redoEvent" :
//          	console.error("redoEvent" ,parameter) ;
                    if( parameter.action.constructor.name === "AddShapeAction" ){
                        var shapeData  = LC.shapeToJSON(parameter.action.shape);
                        if(shapeData!=null && shapeData.className != null && (shapeData.className == "LinePath" || shapeData.className == "ErasedLinePath" )){
                            shapeData.data.smoothedPointCoordinatePairs = null ;
                            delete shapeData.data.smoothedPointCoordinatePairs;
                            var tmpData = shapeData.data.pointCoordinatePairs ;
                            tmpData.forEach(function (item) {
                                item[0] = Math.round( item[0] )  ;
                                item[1] = Math.round(  item[1]  ) ;
                            });
                        }
                        var shapeId =  parameter.action.shapeId ;
                        var testData  = {eventType:eventType , data:shapeData , shapeId:shapeId  , actionName:parameter.action.constructor.name};
                        var signallingName = "SharpsChange" ;
                        $(document).trigger("sendDataToLiterallyEvent",[ shapeId , testData , signallingName]);
                    }else if(parameter.action.constructor.name === "ClearAction"){
                        var clearActionId = parameter.action.id ;
                        var testData  = {eventType:eventType , clearActionId:clearActionId , actionName:parameter.action.constructor.name};
                        var signallingName = "SharpsChange" ;
                        $(document).trigger("sendDataToLiterallyEvent",[clearActionId , testData , signallingName]);
                    }
                    break ;
                case "clearEvent":
//          	console.error("clearEvent" ,parameter);
                    var clearActionId = parameter.clearActionId;
                    var testData  = {eventType:eventType , clearActionId:clearActionId};
                    var signallingName = "SharpsChange" ;
                    $(document).trigger("sendDataToLiterallyEvent",[ clearActionId , testData , signallingName]);
                    break ;
                case "laserMarkEvent":
//          	console.error("laserMarkEvent" ,parameter);
                    var signallingName = "SharpsChange" ;
                    var laserMarkId =  "laserMarkEvent###_"+signallingName;
                    var testData  = {eventType:eventType , action:parameter.action };
                    if(parameter && parameter.laser){
                        testData.laser = parameter.laser
                    }
                    var do_not_save = true ;
                    $(document).trigger("sendDataToLiterallyEvent",[ null , testData , signallingName , laserMarkId , do_not_save]);
                    break ;
            }
        },
        setBackgroundWatermarkImage:function(imgUrl){
            console.log("setBackgroundWatermarkImage imgUrl:" , imgUrl);
            var that = this ;
            that.eleWHPercent = 1 ;
            var $_thisLC = this.lc ;
            $_thisLC.watermarkImage = null;
            if(  imgUrl=="" || imgUrl==null || imgUrl==undefined ){
                that.backImg = new Image();
                that.backImg.src = that.defaultBackImgSrc+"?ts" + new Date().getTime();
                that.backImageResize(that, that.lcLitellyScalc, that.backImg, true, false);
                $_thisLC.watermarkScale = 1;
                $_thisLC.setWatermarkImage(that.backImg);
            }else{
                that.lc.canvasWrite.isLoading = true ;
                if(  that.lc.canvasWrite.isLoading &&  that.lc.canvasWrite.isWrite ){
                    $(that.otherElement.literallyDataLoadingWrap).show();
                }
                that.time = that.time!=undefined || null ;
                clearTimeout(that.time);
                that.time = setTimeout(function(){
                    that.backImg = new Image();
                    that.backImg.onload = function(){
                        var imgWidth = that.backImg.width ;
                        var imgHeight = that.backImg.height ;
                        var imgScale = imgWidth / imgHeight ;
                        $_thisLC.setWatermarkImage(that.backImg);
                        that.backImageResize(that,imgScale,that.backImg,true,true);
                        that.lc.canvasWrite.isLoading = false ;
                        if(  !that.lc.canvasWrite.isLoading &&  that.lc.canvasWrite.isWrite ){
                            $(that.otherElement.literallyDataLoadingWrap).hide();
                        }
                    };
                    that.backImg.src = imgUrl;
                },150);
            }
        },
        closeLoading:function () {/*关闭loading*/
            var that = this ;
            that.lc.canvasWrite.isLoading = false ;
            if(  !that.lc.canvasWrite.isLoading &&  that.lc.canvasWrite.isWrite ){
                $(that.otherElement.literallyDataLoadingWrap).hide();
            }
        },
        backImageResize:function(that,imgScale,backImg,isChangeCanvas,isChangeWatermarkScale){
            var that = this ;
            // clearTimeout(that.backImageResizeTimer);
            // that.backImageResizeTimer = setTimeout(function () {
            isChangeCanvas = ( isChangeCanvas !=undefined && isChangeCanvas!=null?isChangeCanvas:true);
            isChangeWatermarkScale = ( isChangeWatermarkScale !=undefined && isChangeWatermarkScale!=null?isChangeWatermarkScale:true);
            var $_thisLC = that.lc ;
            if($_thisLC){
                var $literally =  that.ele;
                var $literrallyLayout = that.ele.parents(that.otherElement.whiteBoardOuterLayout) ;
                var $bigLiterallyWrap =  that.ele.parents(that.otherElement.bigLiterallyWrap) ;
                var $lc_tool_container = $(that.otherElement.lcToolContainer);
                var $scroll_literally_container = $(that.otherElement.scrollLiterallyContainer);
                that.eleWHPercent = that.eleWHPercent || 1 ;
                var MINWH = that.otherElement.MINWH ;
                var imgScaleFixed= imgScale ;
                var isRotate = false ;
                if( $_thisLC.rotateDeg % 180 !== 0 ){
                    isRotate = true ;
                }
                if(!isRotate){
                    if( $literrallyLayout.height() * imgScale < $literrallyLayout.width()  ){
                        $bigLiterallyWrap.add($literally).add($scroll_literally_container).height( Math.round( $literrallyLayout.height() )  * that.eleWHPercent);
                        $bigLiterallyWrap.add($literally).add($scroll_literally_container).width( Math.round(  $literrallyLayout.height()*imgScale ) * that.eleWHPercent );
                        if(MINWH !=undefined && MINWH!=null){
                            $literally.add($bigLiterallyWrap).add($scroll_literally_container).css({"min-width":Math.round(MINWH*imgScale)+"px"});
                            $literally.add($bigLiterallyWrap).add($scroll_literally_container).css({"min-hegiht":MINWH+"px"});
                        }
                        $bigLiterallyWrap.css({"margin-top":"0px" , "margin-left":-$bigLiterallyWrap.width()/2+"px" , "top":"0px" , "left":"50%" });
                    }else {
                        $bigLiterallyWrap.add($literally).add($scroll_literally_container).height(Math.round($literrallyLayout.width() / imgScale) * that.eleWHPercent);
                        $bigLiterallyWrap.add($literally).add($scroll_literally_container).width($literrallyLayout.width() * that.eleWHPercent);
                        if (MINWH != undefined && MINWH != null) {
                            $literally.add($bigLiterallyWrap).add($scroll_literally_container).css({"min-width": Math.round(MINWH * imgScale) + "px"});
                            $literally.add($bigLiterallyWrap).add($scroll_literally_container).css({"min-height": MINWH + "px"});
                        }
                        $bigLiterallyWrap.css({
                            "margin-left": "0px",
                            "margin-top": -$bigLiterallyWrap.height() / 2 + "px",
                            "left": "0px",
                            "top": "50%"
                        });
                    }
                    $literally.css({
                        "transform":"rotate("+$_thisLC.rotateDeg+"deg)" ,
                        "left":"" ,
                        "top":"",
                    });
                }else{
                    var imgScaleRotate = 1 / imgScale ;
                    if( $literrallyLayout.height() * imgScaleRotate < $literrallyLayout.width()  ){
                        $bigLiterallyWrap.add($scroll_literally_container).height( Math.round( $literrallyLayout.height() )  * that.eleWHPercent);
                        $bigLiterallyWrap.add($scroll_literally_container).width( Math.round(  $literrallyLayout.height()*imgScaleRotate ) * that.eleWHPercent );
                        $literally.width( Math.round( $literrallyLayout.height() )  * that.eleWHPercent);
                        $literally.height( Math.round(  $literrallyLayout.height()*imgScaleRotate ) * that.eleWHPercent );
                        if(MINWH !=undefined && MINWH!=null){
                            $bigLiterallyWrap.css({"min-width":Math.round(MINWH*imgScaleRotate)+"px"});
                            $bigLiterallyWrap.css({"min-hegiht":MINWH+"px"});
                            $literally.css({"min-height":Math.round(MINWH*imgScaleRotate)+"px"});
                            $literally.css({"min-width":MINWH+"px"});
                        }
                        $bigLiterallyWrap.css({"margin-top":"0px" , "margin-left":-$bigLiterallyWrap.width()/2+"px" , "top":"0px" , "left":"50%" });
                    }else {
                        $bigLiterallyWrap.add($scroll_literally_container).height(Math.round($literrallyLayout.width() / imgScaleRotate) * that.eleWHPercent);
                        $bigLiterallyWrap.add($scroll_literally_container).width($literrallyLayout.width() * that.eleWHPercent);
                        $literally.width(Math.round($literrallyLayout.width() / imgScaleRotate) * that.eleWHPercent);
                        $literally.height($literrallyLayout.width() * that.eleWHPercent);
                        if (MINWH != undefined && MINWH != null) {
                            $bigLiterallyWrap.css({"min-width": Math.round(MINWH * imgScaleRotate) + "px"});
                            $bigLiterallyWrap.css({"min-height": MINWH + "px"});
                            $literally.css({"min-height": Math.round(MINWH * imgScaleRotate) + "px"});
                            $literally.css({"min-width": MINWH + "px"});
                        }
                        $bigLiterallyWrap.css({
                            "margin-left": "0px",
                            "margin-top": -$bigLiterallyWrap.height() / 2 + "px",
                            "left": "0px",
                            "top": "50%"
                        });
                    }
                    /* if( $literrallyLayout.height() * imgScale < $literrallyLayout.width()  ){
                     $literally.height( Math.round( $literrallyLayout.height() )  * that.eleWHPercent);
                     $literally.width( Math.round(  $literrallyLayout.height()*imgScale ) * that.eleWHPercent );
                     if(MINWH !=undefined && MINWH!=null){
                     $literally.css({"min-width":Math.round(MINWH*imgScale)+"px"});
                     $literally.css({"min-hegiht":MINWH+"px"});
                     }
                     }else {
                     $literally.height(Math.round($literrallyLayout.width() / imgScale) * that.eleWHPercent);
                     $literally.width($literrallyLayout.width() * that.eleWHPercent);
                     if (MINWH != undefined && MINWH != null) {
                     $literally.css({"min-width": Math.round(MINWH * imgScale) + "px"});
                     $literally.css({"min-height": MINWH + "px"});
                     }
                     }*/
                    // $literally.width( $bigLiterallyWrap.height() ).height( $bigLiterallyWrap.width() );
                    $literally.css({
                        "transform":"rotate("+$_thisLC.rotateDeg+"deg)" ,
                        "left":($literally.height() - $literally.width() ) / 2+"px" ,
                        "top":-($literally.height() - $literally.width() ) / 2+"px" ,
                    });
                }
                if(isChangeCanvas){
                    that.lc.respondToSizeChange();
                    that.scale = ($literally.height()+$literally.width() ) /  ( that.otherElement.BaseLiterallyWidth+that.otherElement.BaseLiterallyWidth*imgScale ) ;
                    that.lc.setZoom(that.scale);
                    that.lc.setPan(	that.x  , that.y) ;
                    if(isChangeWatermarkScale){
                        var imgWidth = backImg.width ;
                        var imgHeight = backImg.height ;
                        var lv = null ;
                        var lvW = $_thisLC.backgroundCanvas.width / imgWidth ;
                        var lvH =  $_thisLC.backgroundCanvas.height / imgHeight ;
                        lv = (lvW+lvH)/2;
                        $_thisLC.watermarkScale= lv  ;
                        $_thisLC.setWatermarkImage(backImg);
                    }
                    clearTimeout(that.canvastimer);
                    that.canvastimer = setTimeout(function(){
                        if(isChangeWatermarkScale){
                            var imgWidth = backImg.width ;
                            var imgHeight = backImg.height ;
                            var lv = null ;
                            var lvW = $_thisLC.backgroundCanvas.width / imgWidth ;
                            var lvH =  $_thisLC.backgroundCanvas.height / imgHeight ;
                            lv = (lvW+lvH)/2;
                            $_thisLC.watermarkScale= lv  ;
                            $_thisLC.setWatermarkImage(backImg);
                        }
                        var cWidth = $_thisLC.canvas.width  ;
                        var cHeight = $_thisLC.canvas.height  ;
                        var eleWidth = $literally.width()   ;
                        var eleHeight = $literally.height() ;
                        if( (cWidth!=eleWidth) || (cHeight!=eleHeight) ){
                            that.lc.respondToSizeChange();
                            that.scale = ($literally.height()+$literally.width() ) /  ( that.otherElement.BaseLiterallyWidth+that.otherElement.BaseLiterallyWidth*imgScale ) ;
                            that.lc.setZoom(that.scale);
                            that.lc.setPan(	that.x  , that.y) ;
                        }else{
                            clearTimeout(that.canvastimer);
                            that.canvastimer = null ;
                        }
                    },150);
                };

                // if(that.isOpenLcFile){
                if(that.eleWHPercent>1){
                    $bigLiterallyWrap.addClass("custom-scroll-bar");
                    if(  $literrallyLayout.width()  - $bigLiterallyWrap.width() < $lc_tool_container.width() ){
                        $lc_tool_container.css({"right":"0.15rem"});
                    }else{
                        $lc_tool_container.css({"right":""});
                    }
                }else{
                    $bigLiterallyWrap.removeClass("custom-scroll-bar");
                    $lc_tool_container.css({"right":""});
                }
                // }
                $("#aynamic_ppt , #aynamic_ppt_newppt").height( $literally.height() ).width($literally.width());
            }
            // },150);
        },
        cloneCanvas:function(canvas ){
            if(  this.cloneCanvasEle.html() == ""){
                this.cloneCanvasEle.html( this.ele.html() ) ;
            }
            var $cv = this.cloneCanvasEle.find(".lc-drawing");
            $cv.empty();
            $cv[0].appendChild(canvas);
        } ,
        convertCanvasToImage:function (canvas) {  // 从 canvas 提取图片 image
            //新Image对象，可以理解为DOM
            var image = new Image();
            // canvas.toDataURL 返回的是一串Base64编码的URL，当然,浏览器自己肯定支持
            // 指定格式 PNG
            image.src = canvas.toDataURL("image/png");
            return image;
        },
        bindElementOnLC:function(ele,cloneElement){
            this.ele = ele || null   ;
            this.cloneCanvasEle = cloneElement || null  ;
        } ,
        cloneElementScalc:function(clonePackElement){
        } ,
        toolsConfig:function(){
            var thisObj = this ;
            return {
                tools:[
                    {
                        name: 'pencil',
                        ele: document.getElementById(thisObj.toolElement['tool_pencil']),
                        tool: new LC.tools.Pencil(this.lc)
                    },{
                        name: 'pencilPhone',
                        ele: document.getElementById(thisObj.toolElement['tool_pencil_phone']),
                        tool: new LC.tools.Pencil(this.lc)
                    },{
                        name: 'eraser',
                        ele: document.getElementById(thisObj.toolElement['tool_eraser']),
                        tool: new LC.tools.Eraser(this.lc)
                    },{
                        name: 'eraserPhone',
                        ele: document.getElementById(thisObj.toolElement['tool_eraser_phone']),
                        tool: new LC.tools.Eraser(this.lc)
                    },{
                        name: 'text',
                        ele: document.getElementById(thisObj.toolElement['tool_text']),
                        tool: new LC.tools.Text(this.lc)
                    },
                    {
                        name: 'pan',
                        ele: document.getElementById(thisObj.toolElement['tool_pan']),
                        tool: new LC.tools.Pan(this.lc)
                    },
                    {
                        name: 'line',
                        ele: document.getElementById(thisObj.toolElement['tool_line']),
                        tool: new LC.tools.Line(this.lc)
                    },{
                        name: 'rectangle',
                        ele: document.getElementById(thisObj.toolElement['tool_rectangle']),
                        tool: new LC.tools.Rectangle(this.lc)
                    },{
                        name: 'rectangleEmpty',
                        ele: document.getElementById(thisObj.toolElement['tool_rectangle_empty']),
                        tool: new LC.tools.Rectangle(this.lc)
                    },{
                        name: 'ellipse',
                        ele: document.getElementById(thisObj.toolElement['tool_ellipse']),
                        tool: new LC.tools.Ellipse(this.lc)
                    },{
                        name: 'ellipseEmpty',
                        ele: document.getElementById(thisObj.toolElement['tool_ellipse_empty']),
                        tool: new LC.tools.Ellipse(this.lc)
                    },{
                        name: 'polygon',
                        ele: document.getElementById(thisObj.toolElement['tool_polygon']),
                        tool: new LC.tools.Polygon(this.lc)
                    },{
                        name: 'eyedropper',
                        ele: document.getElementById(thisObj.toolElement['tool_eyedropper']),
                        tool: new LC.tools.Eyedropper(this.lc)
                    },{
                        name: 'selectShape',
                        ele: document.getElementById(thisObj.toolElement['tool_selectShape']),
                        tool: new LC.tools.SelectShape(this.lc)
                    },{
                        name: 'arrow',
                        ele: document.getElementById(thisObj.toolElement['tool_arrow']),
                        tool: function() {
                            var arrow = null ;
                            arrow = new LC.tools.Line(thisObj.lc);
                            arrow.hasEndArrow = true;
                            return arrow;
                        }()
                    },{
                        name: 'dashed',
                        ele: document.getElementById(thisObj.toolElement['tool_dashed']),
                        tool: function() {
                            var dashed = null  ;
                            dashed = new LC.tools.Line(thisObj.lc);
                            dashed.isDashed = true;
                            return dashed;
                        }()
                    },{
                        name: 'mouse',
                        ele: document.getElementById(thisObj.toolElement['tool_mouse']),
                        tool: new LC.tools.Pencil(this.lc)
                    } ,
                    {
                        name: 'highlighter',
                        ele: document.getElementById(thisObj.toolElement['tool_highlighter']),
                        tool: new LC.tools.Pencil(this.lc)
                    }  ,
                    {
                        name: 'laser',
                        ele: document.getElementById(thisObj.toolElement['tool_laser']),
                        tool: new LC.tools.Pencil(this.lc)
                    }
                ] ,
                colors:[
                    {
                        name: 'strokeColor',
                        ele: document.getElementById(thisObj.toolElement['tool_stroke_color']),
                        defalutColor:"#000000"
                    },{
                        name: 'fillColor',
                        ele: document.getElementById(thisObj.toolElement['tool_fill_color']),
                        defalutColor:"#ffffff"
                    },{
                        name: 'backgroundColor',
                        ele: document.getElementById(thisObj.toolElement['tool_background_color']),
                        defalutColor:"#ffffff"
                    }
                ] ,
                operation:[
                    {
                        name: 'undo',
                        ele: document.getElementById(thisObj.toolElement['tool_operation_undo']),
                    } ,
                    {
                        name: 'redo',
                        ele: document.getElementById(thisObj.toolElement['tool_operation_redo']),
                    } ,
                    {
                        name: 'clear',
                        ele: document.getElementById(thisObj.toolElement['tool_operation_clear']),
                    }
                ] ,
                zoom:[
                    {
                        name: 'zoomBig',
                        ele: document.getElementById(thisObj.toolElement['tool_zoom_big']),
                    } ,
                    {
                        name: 'zoomSmall',
                        ele: document.getElementById(thisObj.toolElement['tool_zoom_small']),
                    },
                    {
                        name: 'zoomDefault',
                        ele: document.getElementById(thisObj.toolElement['tool_zoom_default']),
                    }
                ],
                rotate:[
                    {
                        name: 'rotateLeft',
                        ele: document.getElementById(thisObj.toolElement['tool_rotate_left']),
                    } ,
                    {
                        name: 'rotateRight',
                        ele: document.getElementById(thisObj.toolElement['tool_rotate_right']),
                    }
                ],
                pan:[
                    {
                        name: 'panDefault',
                        ele: document.getElementById(thisObj.toolElement['tool_pan_default']),
                    },{
                        name: 'movePan',
                        ele: document.getElementById(thisObj.toolElement['tool_pan']),
                    }
                ],
                move:[
                    {
                        name: 'moveScrollbar',
                        ele: document.getElementById(thisObj.toolElement['tool_move_scrollbar']),
                    }
                ]
            }
        },
        setActiveToolByName:function( ary , val) {
            var thisObj = this ;
            ary.forEach(function(cur) {
                var $curEle = $(cur.ele) ;
                $curEle.toggleClass('active-tool', ( cur.name == val) );
                thisObj.toolActiveDetection($curEle);
            });
        } ,
        isIE:function() {
            var userAgent = navigator.userAgent;
            var isIE = false;
            if (window.ActiveXObject || "ActiveXObject" in window) {
                isIE = true;
            } else {
                isIE = (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1
                && !(userAgent.indexOf("Opera") > -1));
                isIE = false;
            }
            return isIE;
        },
        toolsInitBind:function(){
            var thisObj = this ;
            var toolsConfig = thisObj.toolsConfig() ;
            // Wire tools
            toolsConfig.tools.forEach(function(tl) {
                $(tl.ele).click(function() {
                    thisObj.lc.setTool(tl.tool);
                    thisObj.setActiveToolByName(toolsConfig.tools, tl.name);
                    thisObj.setIsTmpDrawAble(true);

                    //鼠标部分
                    if(tl.ele.getAttribute("id") === thisObj.toolElement['tool_mouse'] ){
                        thisObj.setIsTmpDrawAble(false);
                        // $("#aynamic_ppt_click").show();
                    }else{
                        // thisObj.setIsTmpDrawAble(true);
                        // $("#aynamic_ppt_click").hide();
                    }
                    $(document).trigger("checkAynamicPptClickEvent",[]);

                    //激光笔部分
                    var $temporaryDrawPermission =  $(thisObj.lc.containerEl).parent().find(".temporary-draw-permission");
                    var $laserMark =  $(thisObj.lc.containerEl).parent().find(".laser-mark");
                    if(tl.ele.getAttribute("id") === thisObj.toolElement['tool_laser'] ){
                        thisObj.setIsTmpDrawAble(false);
                        $temporaryDrawPermission.off("mousemove ");
                        $(thisObj.lc.containerEl).parent().off("mouseenter mouseleave");
                        thisObj.selectLaserTool = true ;
                        if( thisObj.rolePermission["laser"] ){
                            $temporaryDrawPermission.removeClass("cursor-none").addClass("cursor-none");
                            thisObj.laserTime = thisObj.laserTime!=undefined?thisObj.laserTime : null ;
                            thisObj.laserPosition = thisObj.laserPosition!=undefined?thisObj.laserPosition : {left:0 , top:0} ;
                            $temporaryDrawPermission.on("mousemove",function(e){
                                var offset = $(this).offset();
                                var x = e.pageX , y = e.pageY ;
                                var x1 , y1 ;
                                var markContainerWidth  = $(this).width();
                                var markContainerHeight = $(this).height()  ;
                                switch (thisObj.lc.rotateDeg){
                                    case 0:
                                        x1 = x - offset.left ;
                                        y1 = y - offset.top  ;
                                        break;
                                    case 90:
                                        x1 =  y - offset.top ;
                                        y1 = markContainerHeight - (x - offset.left );
                                        break;
                                    case 180:
                                        x1 = markContainerWidth - (x - offset.left ) ;
                                        y1 = markContainerHeight - ( y - offset.top) ;
                                        break;
                                    case 270:
                                        x1 = markContainerWidth - ( y - offset.top) ;
                                        y1 = x - offset.left ;
                                        break;
                                    default:
                                        x1 = x - offset.left ;
                                        y1 = y - offset.top  ;
                                        break
                                }
                                var left = x1 /  $(this).width() *100;
                                var top =  y1  /  $(this).height() *100;
                                $laserMark.css({
                                    "left":left+"%" ,
                                    "top":top+"%"
                                });
                                clearTimeout(thisObj.laserTime);
                                thisObj.laserTime = setTimeout(function(){
                                    if( thisObj.laserPosition && ( Math.abs( left-thisObj.laserPosition.left ) > 0.3 || Math.abs( top-thisObj.laserPosition.top )>0.3 ) ){
                                        var parameter = {
                                            laser:{
                                                left:left ,
                                                top:top
                                            },
                                            action:"move"
                                        }
                                        thisObj.laserPosition = parameter.laser ;
                                        thisObj.sendMessageCommonFunction("laserMarkEvent" , parameter);
                                    }
                                },100);
                                return false;
                            });

                            $(thisObj.lc.containerEl).parent().on("mouseenter",function(e){
                                if( thisObj.rolePermission["laser"] ){
                                    var parameter = {
                                        action:"show"
                                    }
                                    thisObj.sendMessageCommonFunction("laserMarkEvent" , parameter);
                                }
                                $laserMark.show();
                                return false;
                            });
                            $(thisObj.lc.containerEl).parent().on("mouseleave",function(e){
                                if( thisObj.rolePermission["laser"] ){
                                    var parameter = {
                                        action:"hide"
                                    }
                                    thisObj.sendMessageCommonFunction("laserMarkEvent" , parameter);
                                }
                                $laserMark.hide();
                                return false;
                            });
                        }
                    }else{
                        $temporaryDrawPermission.off("mousemove ");
                        $(thisObj.lc.containerEl).parent().off("mouseenter mouseleave");
                        $temporaryDrawPermission.removeClass("cursor-none");
                        // thisObj.setIsTmpDrawAble(true);
                        $laserMark.hide();
                        if(thisObj.selectLaserTool){
                            if( thisObj.rolePermission["laser"] ){
                                var parameter = {
                                    action:"hide"
                                }
                                thisObj.sendMessageCommonFunction("laserMarkEvent" , parameter);
                            }
                            thisObj.selectLaserTool = false ;
                        }
                    }

                    if(  thisObj.lc.tool.name == "Eyedropper"){//吸管
                        thisObj.setEyedropperObject();
                    }else if( thisObj.lc.tool.name == "Text" ){
                        thisObj.uploadTextFont();
                    }else if(thisObj.lc.tool.name == "Eraser"){
                        thisObj.uploadEraserWidth();
                    }else if(thisObj.lc.tool.name == "Pencil" || thisObj.lc.tool.name == "Rectangle" || thisObj.lc.tool.name  == "Ellipse" ||  thisObj.lc.tool.name  == "Line" ){
                        thisObj.uploadPencilWidth();
                    }
                    if( ( thisObj.lc.tool.name == "Rectangle" || thisObj.lc.tool.name  == "Ellipse" ) && tl.ele.getAttribute("data-empty") === "true" ){
                        thisObj.lc.setColor('secondary',"transparent" ) ;
                    }else{
                        thisObj.lc.setColor('secondary',thisObj.initConfig.secondaryColor);
                    }

                    //荧光笔
                    if( tl.name === 'highlighter' ){
                        var color = thisObj.initConfig.primaryColor.colorRgb().toLowerCase().replace("rgb","rgba").replace(")",",0.5)") ;
                        thisObj.lc.setColor('primary', color  ) ;
                    }else{
                        thisObj.lc.setColor('primary',thisObj.initConfig.primaryColor);
                    }
                });
            });
//      $(toolsConfig.tools[0]).trigger("click");
            // thisObj.setActiveToolByName(toolsConfig.tools, toolsConfig.tools[0].name);

            // Wire Colors
            toolsConfig.colors.forEach(function(clr) {
                $(clr.ele).val(clr.defalutColor);
                $(clr.ele).change(function(ev) {
                    switch(clr.name){
                        case "strokeColor" :
                            thisObj.lc.setColor('primary', $(ev.target).val()   ) ;
                            break ;
                        case "fillColor" :
                            thisObj.lc.setColor('secondary', $(ev.target).val()   ) ;
                            break ;
                        case "backgroundColor" :
                            thisObj.lc.setColor('background', $(ev.target).val()   ) ;
                            break ;
                    }
                });
            });


            // Wire Operation
            toolsConfig.operation.forEach(function(ort) {
                $(ort.ele).click(function(e) {
                    switch(ort.name){
                        case "undo" :
                            thisObj.lc.undo();
                            break;
                        case "redo" :
                            thisObj.lc.redo();
                            break;
                        case "clear" :
                            thisObj.lc.clear();
                            break;
                        case "rotate" :
                            thisObj.lc.rotateDeg = (thisObj.lc.rotateDeg + 90 ) % 360;
                            var that = thisObj ;
                            that.resizeHandler(that);
                            break;
                    }
                    thisObj.operationIsAbled();
                })
            });
            thisObj.operationIsAbled();


            // Wire Rotate
            toolsConfig.rotate.forEach(function(rtt) {
                $(rtt.ele).click(function(e) {
                    switch(rtt.name){
                        case "rotateLeft" :
                            thisObj.lc.rotateDeg = (thisObj.lc.rotateDeg - 90 + 360 ) % 360;
                            var that = thisObj ;
                            that.resizeHandler(that);
                            break;
                        case "rotateRight" :
                            thisObj.lc.rotateDeg = (thisObj.lc.rotateDeg + 90 + 360 ) % 360;
                            var that = thisObj ;
                            that.resizeHandler(that);
                            break;
                    }
                });
            });

            // Wire Zoom
            toolsConfig.zoom.forEach(function(zm) {
                $(zm.ele).click(function(e) {
                    switch(zm.name){
                        case "zoomBig" :
                            if( thisObj.eleWHPercent < 3){
                                thisObj.eleWHPercent += 0.5 ;
                            }
                            break;
                        case "zoomSmall" :
                            if( thisObj.eleWHPercent > 1){
                                thisObj.eleWHPercent -= 0.5 ;
                            }
                            break;
                        case "zoomDefault" :
                            //        			thisObj.lc.setZoom( thisObj.scale );
                            thisObj.eleWHPercent = 1 ;
                            break;
                    }
                    thisObj.scaleButtonStyle();
                    var that = thisObj ;
                    that.resizeHandler(that);
                });
                thisObj.scaleButtonStyle();
                var that = thisObj ;
                that.resizeHandler(that);
            });

            // Wire Pan
            toolsConfig.pan.forEach(function(pn) {
                $(pn.ele).click(function(e) {
                    switch(pn.name){
                        case "panDefault" :
                            thisObj.lc.setPan( 0,0 );
                            break;
                    }
                });
            });

            //wire  move
            toolsConfig.move.forEach(function(mv) {
                $(mv.ele).attr("data-move-open",false);
                var $moveToolBgContainer = $(thisObj.otherElement.moveToolBgContainer) ;
                $moveToolBgContainer.hide();
                $(mv.ele).click(function(e) {
                    switch(mv.name){
                        case "moveScrollbar" :
                            if( $(this).attr("data-move-open") == "false" ){
                                $moveToolBgContainer.show();
                                thisObj.setActiveToolByName(toolsConfig.tools,"");
                                thisObj.setActiveToolByName(toolsConfig.move, mv.name);
                                $(this).attr("data-move-open" , true) ;
                                thisObj.literallyMoveScrollEvent( $moveToolBgContainer  );
                            }else if($(this).attr("data-move-open") == "true"){
                                $moveToolBgContainer.hide();
                                $(this).attr("data-move-open" , false) ;
                                thisObj.setActiveToolByName(toolsConfig.move,"");
                                if( thisObj.lc ){
                                    toolsConfig.tools.forEach(function(tl) {
                                        if( tl.name == thisObj.lc.tool.name.toLowerCase()  ){
                                            thisObj.setActiveToolByName(toolsConfig.tools, tl.name);
                                            if(  thisObj.lc.tool.name == "Eyedropper"){
                                                thisObj.setEyedropperObject();
                                            }else if( thisObj.lc.tool.name == "Text" ){
                                                thisObj.uploadTextFont();
                                            }else if(thisObj.lc.tool.name == "Eraser"){
                                                thisObj.uploadEraserWidth();
                                            }else if(thisObj.lc.tool.name == "Pencil" || thisObj.lc.tool.name == "Rectangle" || thisObj.lc.tool.name  == "Ellipse" ){
                                                thisObj.uploadPencilWidth();
                                            }
                                        }
                                    });
                                }

                            }
                            break;
                    }
                });
            });
        },
        scaleButtonStyle:function () {
            var thisObj = this ;
            if( thisObj.eleWHPercent <= 1){
                thisObj.eleWHPercent =  1;
                thisObj.addElementDisable( $("#"+ thisObj.toolElement.tool_zoom_default)  );
                thisObj.addElementDisable( $("#"+ thisObj.toolElement.tool_zoom_small)  );
            }else{
                thisObj.removeElementDisable( $("#"+ thisObj.toolElement.tool_zoom_small) );
                thisObj.removeElementDisable( $("#"+ thisObj.toolElement.tool_zoom_default)  );
            }
            if( thisObj.eleWHPercent >= 3){
                thisObj.addElementDisable( $("#"+ thisObj.toolElement.tool_zoom_big)  );
            }else{
                thisObj.removeElementDisable( $("#"+ thisObj.toolElement.tool_zoom_big)  );
            }
        },
        /*TODO 移动功能有bug,暂时没有修复*/
        literallyMoveScrollEvent:function($moveToolBgContainer,isClearEvent){
            var that = this;
            isClearEvent = (isClearEvent!=undefined && isClearEvent!=null?isClearEvent:false) ;
            var $literallyCanvasContainer = $(that.otherElement.literallyCanvasContainer);
            var flag = false;  //鼠标是否按下
            var nx,ny,dx,dy,x,y ;
            var timer = null ;
            var startPoint = {  //开始节点的x,y,scrollTop,scrollLeft
                x:0 ,
                y:0 ,
                scrollTop:0 ,
                scrollLeft:0
            }
            $moveToolBgContainer.mousedown(function(e){ //鼠标按下时
                startPoint = {
                    x:e.offsetX ,
                    y:e.offsetY ,
                    scrollLeft:$literallyCanvasContainer.scrollLeft(),
                    scrollTop:$literallyCanvasContainer.scrollTop()
                }
                flag = true ; //鼠标按下标志
            });
            $moveToolBgContainer.mousemove(function(e){
                if(flag){
                    nx =  startPoint.x - e.offsetX ;
                    ny =  startPoint.y - e.offsetY ;
                    if( Math.abs( nx ) >5 ){
                        $literallyCanvasContainer.scrollLeft( startPoint.scrollLeft+nx );
                    }

                    if( Math.abs( ny ) >5 ){
                        $literallyCanvasContainer.scrollTop( startPoint.scrollTop+ny );
                    }
//				console.info(  e.offsetX ,  e.offsetY  ) ;
                }
            });

            $moveToolBgContainer.on("mouseup mouseleave mouseenter",function(e){
                flag = false ;
                switch (e.type){
                    case "mouseup":
                        startPoint = {
                            x:e.offsetX ,
                            y:e.offsetY ,
                            scrollLeft:$literallyCanvasContainer.scrollLeft(),
                            scrollTop:$literallyCanvasContainer.scrollTop()
                        }
                        break;
                    default:
                        break;
                }
            });

            $(document).mouseenter(function(e){
                flag = false ;
            });
        },
        operationIsAbled:function(){
            var thisObj = this ;
            var addOperationDisabled  = addOperationDisabled ||	function (ortName){
                    var operation = thisObj.toolsConfig().operation ;
                    for (var i = 0; i < operation.length; i++) {
                        if( operation[i].name == ortName){
//  				$(operation[i].ele).css({"background":"#ddd"}).attr("disabled",true);
                            var $curEle =  $(operation[i].ele) ;
                            thisObj.addElementDisable($curEle);
                        }
                    }
                };

            var removeOperationDisabled = removeOperationDisabled || function (ortName){
                    var operation = thisObj.toolsConfig().operation ;
                    for (var i = 0; i < operation.length; i++) {
                        if( operation[i].name == ortName){
//  				$(operation[i].ele).css({"background":""}).attr("disabled",false);
                            var $curEle =  $(operation[i].ele) ;
                            thisObj.removeElementDisable($curEle);
                        }
                    }
                };

            if( thisObj.lc.shapes.length == 0 ){
                addOperationDisabled("clear");
                thisObj.addElementDisable( $("#"+thisObj.toolElement["tool_eyedropper"]) );
            }else{
                removeOperationDisabled("clear");
                thisObj.removeElementDisable( $("#"+thisObj.toolElement["tool_eyedropper"]) );
            }
            if( ! thisObj.lc.canRedo() ){
                addOperationDisabled("redo");
            }else{
                removeOperationDisabled("redo");
            }

            if( ! thisObj.lc.canUndo()  ){
                addOperationDisabled("undo");
            }else{
                removeOperationDisabled("undo");
            }
        },
        addElementDisable:function($curEle){
            $curEle.attr("disabled","disabled").addClass("disabled");
            if( this.callback.onAddElementDisable && $.isFunction(this.callback.onAddElementDisable) ){
                this.callback.onAddElementDisable($curEle);
            }
        },
        removeElementDisable:function($curEle){
            $curEle.removeAttr("disabled").removeClass("disabled");
            if( this.callback.onRemoveElementDisable && $.isFunction(this.callback.onRemoveElementDisable) ){
                this.callback.onRemoveElementDisable($curEle);
            }
        },
        toolActiveDetection:function($curEle){
            if( this.callback.onToolActiveDetection && $.isFunction(this.callback.onToolActiveDetection) ){
                this.callback.onToolActiveDetection($curEle);
            }
        },
        removeToolActive:function($curEle){
            if( this.callback.onRemoveToolActive && $.isFunction(this.callback.onRemoveToolActive) ){
                this.callback.onRemoveToolActive($curEle);
            }
        },
        setEyedropperObject:function(){
            var that = this ;
            var tool = that.lc.tool ;
            if(tool.name == "Eyedropper"){
                tool.strokeOrFill = that.lc.toolStatus.eyedropperIsStroke ;
            }
        },
        setLCTextFont:function(fontSize,fontFamily,fontStyle , fontWeight ){
            /*：font-style | font-variant | font-weight | font-size | line-height | font-family */
            /*
             font:italic small-caps bold 12px/1.5em arial,verdana;  （注：简写时，font-size和line-height只能通过斜杠/组成一个值，不能分开写。）
             等效于：
             font-style:italic;
             font-variant:small-caps;
             font-weight:bold;
             font-size:12px;
             line-height:1.5em;
             font-family:arial,verdana;
             */
            var tool = this.lc.tool ;
            if(tool.name == "Text"){
                fontSize = (fontSize!=null  && fontSize!=undefined  && fontSize>0 ) ? fontSize : 20 ;
                fontFamily = (fontFamily!=null && fontFamily!=undefined  && fontFamily!="" )? fontFamily : "微软雅黑" ;
                fontStyle =  (fontStyle!=null && fontStyle!=undefined  && fontStyle!="" )? fontStyle : "normal" ;
                fontWeight =  (fontWeight!=null && fontWeight!=undefined  && fontWeight!="" )? fontWeight : "normal" ;
                tool.font = fontStyle+" "+fontWeight+" "+fontSize+"px "+fontFamily;
            }

        },
        uploadTextFont:function(){
            this.setLCTextFont(  this.lc.toolStatus.fontSize,this.lc.toolStatus.fontFamily,this.lc.toolStatus.fontStyle , this.lc.toolStatus.fontWeight  );
        },
        uploadPencilWidth:function () {
            this.lc.trigger( 'setStrokeWidth', this.lc.toolStatus.pencilWidth );
        },
        uploadEraserWidth:function () {
            this.lc.trigger( 'setStrokeWidth', this.lc.toolStatus.eraserWidth );
        },
        getIsDrawAble:function(){
            return this.lc.isDrawAble ;
        },
        setIsDrawAble:function(value){
            this.lc.isDrawAble = value;
            var drawPermission = this.lc.containerEl.parentNode.getElementsByClassName("draw-permission")[0];
            if( this.lc.isDrawAble ){
                drawPermission.className = drawPermission.className.replace(/( yes| no)/g,"");
                drawPermission.className += " yes" ;
            }else{
                drawPermission.className = drawPermission.className.replace(/( yes| no)/g,"");
                drawPermission.className += " no" ;
            }
        },
        getIsTmpDrawAble:function(){
            return this.lc.isTmpDrawAble ;
        },
        setIsTmpDrawAble:function(value){
            this.lc.isTmpDrawAble = value;
            var temporaryDrawPermission = this.lc.containerEl.parentNode.getElementsByClassName("temporary-draw-permission")[0];
            if( this.lc.isTmpDrawAble ){
                temporaryDrawPermission.className = temporaryDrawPermission.className.replace(/( yes| no)/g,"");
                temporaryDrawPermission.className += " yes" ;
            }else{
                temporaryDrawPermission.className = temporaryDrawPermission.className.replace(/( yes| no)/g,"");
                temporaryDrawPermission.className += " no" ;
            }
        },
        uploadColor:function(key , value){
            var that = this ;
            that.initConfig[key+"Color"] = value ;
            that.lc.setColor(key , that.initConfig[key+"Color"]) ;

            var $toolHighlighter = $( "#"+that.toolElement['tool_highlighter'] ) ;
            if(key==="primary" && $toolHighlighter.length>0 &&  $toolHighlighter.attr("data-select") == "true" ){
                var color = value.colorRgb().toLowerCase().replace("rgb","rgba").replace(")",",0.5)") ;
                that.lc.setColor(key, color  ) ;
            }
        },
        snapshotLoadEvent:function(parameter){
            console.log( "================snapshotLoadEvent start===============" );
            console.log( parameter );
            console.log( "================snapshotLoadEvent end===============" );
        },
        primaryColorChangeEvent:function(parameter){
            console.log( "================primaryColorChangeEvent start===============" );
            console.log( parameter );
            console.log( "================primaryColorChangeEvent end===============" );
        },
        secondaryColorChangeEvent:function(parameter){
            console.log( "================secondaryColorChangeEvent start===============" );
            console.log( parameter );
            console.log( "================secondaryColorChangeEvent end===============" );
        },
        backgroundColorChangeEvent:function(parameter){
            console.log( "================backgroundColorChangeEvent start===============" );
            console.log( parameter );
            console.log( "================backgroundColorChangeEvent end===============" );
        },
        drawingChangeEvent:function(parameter) {
//      console.log( "================drawingChangeEvent start===============" );
//      console.log( parameter );
//      console.log( "================drawingChangeEvent end===============" );
            // var thisObj = GLOBAL.thisObj ;
            //parse用于从一个字符串中解析出json对象   stringify()用于从一个对象解析出字符串
//      localStorage.setItem('drawing', JSON.stringify( thisObj.lc.getSnapshot() ) );
//      var snapshotJSON = localStorage['drawing'];
//		var canvas = LC.renderShapesToCanvas(
//		  LC.snapshotJSONToShapes(snapshotJSON),
//		  { x: 0, y: 0, width: thisObj.lc.backgroundCanvas.width , height:  thisObj.lc.backgroundCanvas.height }
//	    );
            // Now you can pull out the image using a data URL:
            //var dataURL = canvas.toDataURL();
            //console.log(dataURL);
//		thisObj.cloneCanvas(canvas);
        },
        doClearRedoStackEvent:function(doClearRedoStack){
//  	console.log( "================doClearRedoStackEvent start===============" );
//      console.log( doClearRedoStack );
//      console.log( "================doClearRedoStackEvent end===============" );
//      var thisObj = GLOBAL.thisObj ;
//      $(document).trigger("doClearRedoStackEvent",[ doClearRedoStack.doClearRedoStack  , thisObj.undoAndRedoStack ]);
//      thisObj.undoAndRedoStack = [] ;
        },
        shapeSaveEvent:function(parameter){
            /*console.log( "================shapeSaveEvent start===============" );
             console.log( parameter );
             console.log( "================shapeSaveEvent end===============" );*/
            var thisObj = GLOBAL.thisObj ;
            thisObj.sendMessageCommonFunction("shapeSaveEvent" , parameter);
            thisObj.operationIsAbled();
        },
        undoEvent:function(parameter){
            /*console.log( "================undoEvent start===============" );
             console.log( parameter );
             console.log( "================undoEvent end===============" );*/
            var thisObj = GLOBAL.thisObj ;
            thisObj.sendMessageCommonFunction("undoEvent",parameter);
            thisObj.operationIsAbled();
        },
        redoEvent:function(parameter){
            /*console.log( "================redoEvent start===============" );
             //		 console.log( parameter );
             console.log( "================redoEvent end===============" );*/
            var thisObj = GLOBAL.thisObj ;
            thisObj.sendMessageCommonFunction("redoEvent",parameter);
            thisObj.operationIsAbled();
        },
        clearEvent:function(parameter){
            /*console.log( "================clearEvent start===============" );
             console.log( parameter );
             console.log( "================clearEvent end===============" );*/
            var thisObj = GLOBAL.thisObj ;
            thisObj.sendMessageCommonFunction("clearEvent",parameter);
            thisObj.operationIsAbled();
        },
        drawStartEvent:function(parameter){
//      console.log( "================drawStartEvent start===============" );
//      console.log( parameter );
//      console.log( "================drawStartEvent end===============" );
        },
        drawContinueEvent:function(parameter){
            console.log( "================drawContinueEvent start===============" );
            console.log( parameter );
            console.log( "================drawContinueEvent end===============" );
        },
        drawEndEvent:function(parameter){
            console.log( "================drawEndEvent start===============" );
            console.log( parameter );
            console.log( "================drawEndEvent end===============" );
        },
        toolChangeEvent:function(parameter){
            console.log( "================toolChangeEvent start===============" );
            console.log( parameter );
            console.log( "================toolChangeEvent end===============" );
        },
        panEvent:function(parameter){
            console.log( "================panEvent start===============" );
            console.log( parameter );
            console.log( "================panEvent end===============" );
            /*		var thisObj = GLOBAL.thisObj;
             thisObj.x = parameter.x * ( thisObj.newScale / thisObj.oldScale) ;
             thisObj.y = parameter.y * ( thisObj.newScale / thisObj.oldScale) ;*/
        },
        zoomEvent:function(parameter){
            console.log( "================zoomEvent start===============" );
            console.log( parameter );
            console.log( "================zoomEvent end===============" );
            /*		var thisObj = GLOBAL.thisObj;
             thisObj.oldScale = parameter.oldScale ;
             thisObj.newScale = parameter.newScale ;*/
        },
        repaintEvent:function(parameter){
            console.log( "================repaintEvent start===============" );
            console.log( parameter );
            console.log( "================repaintEvent end===============" );
        },
        lcPointerdownEvent:function(parameter){
            console.log( "================lcPointerdownEvent start===============" );
            console.log( parameter );
            console.log( "================lcPointerdownEvent end===============" );
        },
        lcPointerupEvent:function(parameter){
            console.log( "================lcPointerupEvent start===============" );
            console.log( parameter );
            console.log( "================lcPointerupEvent end===============" );
        },
        lcPointermoveEvent:function(parameter){
            console.log( "================lcPointermoveEvent start===============" );
            console.log( parameter );
            console.log( "================lcPointermoveEvent end===============" );
        },
        lcPointerdragEvent:function(parameter){
            console.log( "================lcPointerdragEvent start===============" );
            console.log( parameter );
            console.log( "================lcPointerdragEvent end===============" );
        }
    }

    /*RGB颜色转换为16进制*/
    String.prototype.colorHex = function(){
        var that = this;
        var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
        if(/^(rgb|RGB)/.test(that)){
            var aColor = that.replace(/(?:\(|\)|rgb|RGB)*/g,"").split(",");
            var strHex = "#";
            for(var i=0; i<aColor.length; i++){
                var hex = Number(aColor[i]).toString(16);
                if(hex === "0"){
                    hex += hex;
                }
                strHex += hex;
            }
            if(strHex.length !== 7){
                strHex = that;
            }
            return strHex;
        }else if(reg.test(that)){
            var aNum = that.replace(/#/,"").split("");
            if(aNum.length === 6){
                return that;
            }else if(aNum.length === 3){
                var numHex = "#";
                for(var i=0; i<aNum.length; i+=1){
                    numHex += (aNum[i]+aNum[i]);
                }
                return numHex;
            }
        }else{
            return that;
        }
    };

    /*16进制颜色转为RGB格式*/
    String.prototype.colorRgb = function(){
        var sColor = this.toLowerCase();
        var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
        if(sColor && reg.test(sColor)){
            if(sColor.length === 4){
                var sColorNew = "#";
                for(var i=1; i<4; i+=1){
                    sColorNew += sColor.slice(i,i+1).concat(sColor.slice(i,i+1));
                }
                sColor = sColorNew;
            }
            //处理六位的颜色值
            var sColorChange = [];
            for(var i=1; i<7; i+=2){
                sColorChange.push(parseInt("0x"+sColor.slice(i,i+2)));
            }
            return "RGB(" + sColorChange.join(",") + ")";
        }else{
            return sColor;
        }
    };
    return CustomLiterally ;
}));


