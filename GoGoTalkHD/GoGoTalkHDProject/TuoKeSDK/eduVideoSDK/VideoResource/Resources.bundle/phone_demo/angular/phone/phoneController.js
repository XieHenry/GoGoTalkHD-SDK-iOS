﻿var GLOBAL = GLOBAL || {} ;
tk_room.controller('phoneController', function ($scope , $timeout , $interval ,$rootScope , $window, ServiceLiterally  , ServiceNewPptAynamicPPT  , ServiceTools) {
	$(function(){
		$scope.phone = {
			func:{}
		};
		
		/*角色对象*/
        $rootScope.role = {};
        Object.defineProperties($rootScope.role, {
            //0：主讲  1：助教    2: 学员   3：直播用户 4:巡检员　10:系统管理员　11:企业管理员　12:管理员
            roleChairman: {
                value: 0,
                writable: false,
            },
            roleTeachingAssistant: {
                value: 1,
                writable: false,
            },
            roleStudent: {
                value: 2,
                writable: false,
            },
            roleAudit: {
                value: 3,
                writable: false,
            },
            rolePatrol: {
                value: 4,
                writable: false,
            }
        });
					
						
		$rootScope.initPageParameterFormPhone = {//手机端初始化参数
	        mClientType:null , //0:flash,1:PC,2:IOS,3:andriod,4:tel,5:h323	6:html5 7:sip
            serviceUrl:{
                address:null ,
                port:null
			} , //服务器地址
	        addPagePermission:false , //加页权限
	        deviceType:null , //0-手机 , 1-ipad 
	        role:null , //角色
	        classBegin:null , //是否上课,1-上课 , 2-下课， 0-没上课
	    };

		$rootScope.joinMeetingMessage = {}; //加入房间的信息

		
		/*操作的节点*/
	    var $participants = $("#participants");
	    var $videoChatContainer =  $("#video_chat_container") ;
	    var $videoContainer =  $("#video_container");
	    var $messageWin = $("#message_win");
	    var $headerWinMax =  $("#header_win_max");
	    var $headerWinMin =  $("#header_win_min");
	    var $allWrap = $("#all_wrap");
	    var $headerCurrColor = $("#header_curr_color");
	    var $headerColorList  = $("#header_color_list") ;
	    var $header = $("#header"); 
	    var $headerContainer = $header.find("#header_container");
	    var $toolContainer = $("#tool_container");
	    var $fileListEle =  $("#tool_course_list") ;
	    
	    
		/*-------事件绑定start----------------*/
		/*绑定事件来实现白板数据发送 [发送给所有人，除了自己]*/
		$scope.bindDocumentEvent = function(){
			/*绑定事件来实现白板数据发送 [发送给所有人，除了自己]*/
			$(document).off("sendDataToLiterallyEvent");
	        $(document).on("sendDataToLiterallyEvent",function (event , testIDPrefix , testData , signallingName , assignId  , do_not_save) {
	            var  currPageNum = ServiceLiterally.ele.attr("data-curr-page")  ;
	            var  currFileId =  ServiceLiterally.ele.attr("data-file-id")  ;
	            var isDelMsg = false , toID="__allExceptSender"  ;
	            var testID = assignId || testIDPrefix + "###_"+signallingName+"_"+currFileId+"_"+currPageNum;
	            var eventName  = "publish-message-received" ;
	             testData = JSON.stringify(testData);
	       		var tmpData = {
	       			id:testID , 
	       			toID:toID ,
	       			data:testData ,
	       			signallingName:signallingName ,
	       			eventName:eventName ,
	       		};
	       		if(do_not_save!=undefined){
	       			tmpData.do_not_save = do_not_save;
	       		}
	            tmpData = JSON.stringify(tmpData);
	            console.log("sendDataToLiterally data:",tmpData);
	            switch ( $rootScope.initPageParameterFormPhone.mClientType){
	                case 2://ios
	                	if(window.webkit && window.webkit.messageHandlers ){
	                		window.webkit.messageHandlers.sendBoardData.postMessage({"data":tmpData});
	                	}else{
	                		console.error("没有方法window.webkit.messageHandlers.sendBoardData.postMessage");
	                	}
	                    break;
	                case 3://android
	                	if(window.JSWhitePadInterface){
	                    	window.JSWhitePadInterface.sendBoardData( tmpData );
	                	}else{
	                		console.error("没有方法window.JSWhitePadInterface.sendBoardData");
	                	}
	                    break;
	                default:
	                	console.error("没有设备类型，无法区分发送给手机的方法");
	                    break;
	            }
	        });
	
			/*删除白板数据事件*/
			$(document).off("deleteLiterallyDataEvent");
	        $(document).on("deleteLiterallyDataEvent" , function(event , testIDPrefix , testData , signallingName , assignId){
	            var  currPageNum = ServiceLiterally.ele.attr("data-curr-page")  ;
	            var  currFileId =  ServiceLiterally.ele.attr("data-file-id")  ;
	            var isDelMsg = true , toID="__allExceptSender" , do_not_save = true ;
	            var testID = assignId || testIDPrefix + "###_"+signallingName+"_"+currFileId+"_"+currPageNum ;
	            var eventName = "delete-message-received";
	            testData = JSON.stringify(testData);
	            var tmpData = {
	       			id:testID , 
	       			toID:toID ,
	       			data:testData ,
	       			signallingName:signallingName ,
	       			eventName:eventName  ,
	       		};
	       		if(do_not_save!=undefined){
	       			tmpData.do_not_save = do_not_save;
	       		}
	            tmpData = JSON.stringify(tmpData);
	            console.log("deleteLiterallyData data:",tmpData);
	            switch ( $rootScope.initPageParameterFormPhone.mClientType){
	            	case 2://ios
	            		if(window.webkit && window.webkit.messageHandlers ){
	                		window.webkit.messageHandlers.deleteBoardData.postMessage({"data":tmpData});
	                	}else{
	                		console.error("没有方法window.webkit.messageHandlers.deleteBoardData.postMessage");
	                	}
	                    break;
	                case 3://android
	                	if(window.JSWhitePadInterface){
	                    	window.JSWhitePadInterface.deleteBoardData( tmpData );
	                	}else{
	                		console.error("没有方法window.JSWhitePadInterface.deleteBoardData");
	                	}
	                default:
	                    break;
	            }
	        });
	        /*======接收手机数据事件 start ============*/
	        //发送的信息接收事件
	        $(document).off("publish-message-received");
	        $(document).on("publish-message-received", function(event , data) {
	            console.log("publish-message-received: " + JSON.stringify(data));
	            $rootScope.loginController.func.publishMessageReceivedHandler(data);
	        });
	        
	        //信息列表接收事件
	        $(document).off("message-list-received");
	        $(document).on("message-list-received", function(event , data) {
	            console.log("message-list-received: " + JSON.stringify(data));
	            $("#literally_no_write_wrap").show();
				if( $rootScope.page  &&  $rootScope.page.pageOperation && ServiceLiterally.lc ){
					$("#literally_no_write_wrap").show();
					$rootScope.loginController.func.messageListReceivedHandler(data);
				}
	        });
		     
		     
		    //删除信息接收事件
		    $(document).off("delete-message-received");
	         $(document).on("delete-message-received", function(event , data) {
	            console.log("delete-message-received: " + JSON.stringify(data));
				$rootScope.loginController.func.deleteMessageReceivedHandler(data);
	        });
		            
	        /*======接收手机数据事件 end ============*/
		}
		/*-------事件绑定end----------------*/
		  
		  
	    /*登陆界面控制器参数控制*/
		$rootScope.loginController = {
			func: {},
			parameter: {},
			necessary: {}
		};
		/*call界面控制器参数控制*/
        $scope.callController = {
            func: {},
            parameter: {},
            necessary: {}
        };
                
	    /*publish-message-received事件内部数据 处理函数*/
		$scope.showPageTime = {
	    	media:null ,
	    	file:null
	    } ;
	    $rootScope.loginController.func.publishMessageReceivedHandler = function(data){
	    	console.error("publishMessageReceivedHandler" , data);
	    	if(data && typeof data == "string" ){
				data = JSON.parse( data );
			}
			if(data.params.data && typeof data.params.data == "string" ){
				data.params.data = JSON.parse( data.params.data );
			}
			if( $rootScope.page  &&  $rootScope.page.pageOperation && ServiceLiterally.lc ){
	        	switch (data.params.name){
	        		case "SharpsChange":
        				if(data.params.data != null && (data.params.data.eventType === "shapeSaveEvent" || data.params.data.eventType === "clearEvent" ||
									data.params.data.eventType === "redoEvent" || data.params.data.eventType === "laserMarkEvent")) {
								if(data.params.data.eventType  === "laserMarkEvent" ) {
                                    ServiceLiterally.receiveSnapshot(data.params, null);
                                }else {
                                    if(data.params.data.eventType == "shapeSaveEvent" || (data.params.data.eventType == "redoEvent" && data.params.data.actionName == "AddShapeAction")) {
                                        if(data.params.data.data.data) {
                                            data.params.data.data = LC.JSONToShape(data.params.data.data);
                                        }
                                    };
                                    var shapeName = data.params.id.substring(data.params.id.lastIndexOf("###_") + 4);
                                    if(shapeName){
                                        var shapeNameArr =shapeName.split("_");
                                        var fileid = shapeNameArr[1] ;
                                        var currpage = shapeNameArr[2] ;
                                        if( ServiceLiterally.ele.attr("data-file-id") == fileid.toString() && ServiceLiterally.ele.attr("data-curr-page") == currpage.toString() ){
                                            ServiceLiterally.receiveSnapshot(data.params, null);
                                        }else{
                                            if($rootScope.shapeJson[shapeName] == null || $rootScope.shapeJson[shapeName] == undefined) {
                                                $rootScope.shapeJson[shapeName] = [];
                                                $rootScope.shapeJson[shapeName].push(data.params);
                                            } else {
                                                $rootScope.shapeJson[shapeName].push(data.params);
                                            }
                                        }
                                    }
                                };
							}
	        			break;
					case "ShowPage":
						$timeout(function () {
                            if(!data.params.data.ismedia) {
                                if(!data.params.data.aynamicPPT){
                                	$rootScope.roomPage.flag.isShow.isCourseFile = true ;                                                                   
                                    $rootScope.page.saveLcStackToStorage();
                                    $rootScope.page.setLcFileAttr(data.params.data.filedata);
                                    $rootScope.page.pageOperation(null, false);
                                    $("#prev_page_phone").show();
                                    $("#next_page_phone").show();
                                    $("#add_literally_page_phone").hide();
                                    $("#prev_page_phone_slide").hide();
                                    $("#next_page_phone_slide").hide();
                                }else{
                                    $rootScope.roomPage.flag.isShow.isCourseFile = false ;
                                    var isremote = true ;
                                    var isOpenPPT  = false;
                                    var pptslide = data.params.data.filedata.pptslide ;
                                    var pptstep = data.params.data.filedata.pptstep ;
                                    var pptfileid = data.params.data.filedata.fileid ;
                                    if(data.params.data.action === "show"){
                                        isOpenPPT = true ;
                                        $rootScope.page.saveLcStackToStorage();
                                        $rootScope.page.setLcFileAttr(data.params.data.filedata);
                                        $rootScope.page.recoverLcData();
									}
                                    $(document).trigger("uploadAynamicPptProgress" , [ pptslide , pptstep  , pptfileid , isOpenPPT , isremote   ] );
                                    $("#prev_page_phone_slide").show();
                                    $("#next_page_phone_slide").show();
                                    $("#prev_page_phone").hide();
                                    $("#next_page_phone").hide();
                                    $("#add_literally_page_phone").hide();
                                }
                            } 
                        },0);           
	        			break;
					case "ClassBegin": //上课
						$rootScope.isClassBegin = true; //上课状态
                        $(document).trigger("onStartAttend");
                        if($rootScope.isClassBegin &&  !($rootScope.hasRole.roleChairman || $rootScope.hasRole.roleTeachingAssistant)  ){
//                      	$rootScope.roomPage.flag.isShow.isCourseFile = true;
//                      	$("#page_wrap").removeClass("no-permission");
                            $("#ppt_next_page_slide , #ppt_prev_page_slide , #next_page , #prev_page , #add_literally_page").addClass("disabled").attr("disabled","disabled").attr("data-set-disabled" ,'no');
                        }
						break;
					case "NewPptTriggerActionClick": //动态PPT动作		
					    console.log("NewPptTriggerActionClick" , data.params);
                        if($rootScope.roomPage.flag.isShow.isCourseFile === false &&  $rootScope.hasRole.roleChairman === false  ){		
//                      	clearTimeout(ServiceNewPptAynamicPPT.newPptTriggerActionClickTimer);
//          				ServiceNewPptAynamicPPT.newPptTriggerActionClickTimer = setTimeout(function () {
								ServiceNewPptAynamicPPT.postMessage(data.params.data);   
//							},300);
                        }
						break;
						
	        		default:
	        			break;
	        	}
	    	}
	 	};
	 	
	 	/*delete-message-received事件内部数据 处理函数*/
	    $rootScope.loginController.func.deleteMessageReceivedHandler = function(data){
	    	console.error("deleteMessageReceivedHandler" , data);
			if(data && typeof data == "string" ){
				data = JSON.parse( data );
			}
			if(data.params.data && typeof data.params.data == "string" ){
				data.params.data = JSON.parse( data.params.data );
			}
			switch (data.params.name){
				case "ClassBegin": //删除上课（也就是下课了）					
						$(document).trigger("onEndAttend");
						$rootScope.isClassBegin = false; //下课状态
						break;
				case "SharpsChange"://删除白板数据
	        		ServiceLiterally.receiveSnapshot( data.params , null);
					break;
			};
	    }
		
		/*message-list-received事件内部处理函数*/
	    $rootScope.loginController.func.messageListReceivedHandler = function(data){
	    	console.error("messageListReceivedHandler" , data);
	    	if(data && typeof data == "string" ){
				data = JSON.parse( data );
			}
			/*
			    @function     JsonSort 对json排序
			    @param        json     用来排序的json
			    @param        key      排序的键值
			*/
			function JsonSort(json,key){
			    for(var j=1,jl=json.length;j < jl;j++){
			        var temp = json[j],
			            val  = temp[key],
			            i    = j-1;
			        while(i >=0 && json[i][key]>val){
			            json[i+1] = json[i];
			            i = i-1;    
			        }
			        json[i+1] = temp;
			        
			    }
			    return json;
			}
			
			if( $rootScope.page  &&  $rootScope.page.pageOperation && ServiceLiterally.lc ){
				$rootScope.shapeJson = {};
				var resultData = data.params ;
				for (var x in resultData ) {
					if(resultData[x].data && typeof resultData[x].data == "string" ){
	        			resultData[x].data = JSON.parse( resultData[x].data );
	        		}
					if(resultData[x].name == "SharpsChange") {
						if(resultData[x].data != null && (resultData[x].data.eventType === "shapeSaveEvent" || resultData[x].data.eventType === "clearEvent" || resultData[x].data.eventType === "redoEvent")) {
							if(resultData[x].data.eventType === "shapeSaveEvent" || (resultData[x].data.eventType === "redoEvent" && resultData[x].data.actionName == "AddShapeAction")) {
                                if(resultData[x].data.data.data) {
                                    resultData[x].data.data = LC.JSONToShape(resultData[x].data.data);
                                }
							}
                            if(resultData[x].data.eventType  === "laserMarkEvent" ) {
                            }else {
                                var shapeName = resultData[x].id.substring(resultData[x].id.lastIndexOf("###_") + 4);
                                if($rootScope.shapeJson[shapeName] == null || $rootScope.shapeJson[shapeName] == undefined) {
                                    $rootScope.shapeJson[shapeName] = [];
                                    $rootScope.shapeJson[shapeName].push(resultData[x]);
                                } else {
                                    $rootScope.shapeJson[shapeName].push(resultData[x]);
                                }
							}
						}
					} else if(resultData[x].name == "ShowPage") {
						if($rootScope.shapeJson["ShowPage"] == null || $rootScope.shapeJson["ShowPage"] == undefined) {
							$rootScope.shapeJson["ShowPage"] = [];
							$rootScope.shapeJson["ShowPage"].push(resultData[x]);
						} else {
							$rootScope.shapeJson["ShowPage"].push(resultData[x]);
						}
					}  else if(resultData[x].name == "ClassBegin") {
                        if($rootScope.shapeJson["ClassBegin"] == null || $rootScope.shapeJson["ClassBegin"] == undefined) {
                            $rootScope.shapeJson["ClassBegin"] = [];
                            $rootScope.shapeJson["ClassBegin"].push(resultData[x]);
                        } else {
                            $rootScope.shapeJson["ClassBegin"].push(resultData[x]);
                        }
                    }else if(resultData[x].name == "NewPptTriggerActionClick"){//动态PPT动作	
                    	 if($rootScope.shapeJson["NewPptTriggerActionClick"] == null || $rootScope.shapeJson["NewPptTriggerActionClick"] == undefined) {
                            $rootScope.shapeJson["NewPptTriggerActionClick"] = [];
                            $rootScope.shapeJson["NewPptTriggerActionClick"].push(resultData[x]);
                        } else {
                            $rootScope.shapeJson["NewPptTriggerActionClick"].push(resultData[x]);
                        }
					    
                    }
	            }
	        	
	        	
        	 	/*数据排序*/
//	        	if(  $rootScope.initPageParameterFormPhone  &&  $rootScope.initPageParameterFormPhone.mClientType!=null  &&  $rootScope.initPageParameterFormPhone.mClientType!=undefined  &&  $rootScope.initPageParameterFormPhone.mClientType === 1  ){
        		for(var x in $rootScope.shapeJson ){
	        		if($rootScope.shapeJson[x] && $rootScope.shapeJson[x].length>0){
	        			$rootScope.shapeJson[x] = JsonSort($rootScope.shapeJson[x],"seq") ;
	        		}
				}
//	        	}


				/*上课数据*/
                var classBeginArr = $rootScope.shapeJson["ClassBegin"];
                if(classBeginArr != null && classBeginArr != undefined && classBeginArr.length > 0) {
                    if(classBeginArr[classBeginArr.length - 1].name == "ClassBegin") {
                        $rootScope.isClassBegin = true; //已经上课
                        $(document).trigger("onStartAttend");
                        if($rootScope.isClassBegin &&  !($rootScope.hasRole.roleChairman || $rootScope.hasRole.roleTeachingAssistant)  ){
//                      	$rootScope.roomPage.flag.isShow.isCourseFile = true;
//                      	$("#page_wrap").removeClass("no-permission");
                            $("#ppt_next_page_slide , #ppt_prev_page_slide , #next_page , #prev_page , #add_literally_page").addClass("disabled").attr("disabled","disabled").attr("data-set-disabled" ,'no');
                        }
                    }
                }
				
													
				/*动态ppt触发器动作数据*/
				var newPptTriggerActionClickArr = $rootScope.shapeJson["NewPptTriggerActionClick"];
				if(newPptTriggerActionClickArr != null && newPptTriggerActionClickArr != undefined && newPptTriggerActionClickArr.length > 0) {
					if(newPptTriggerActionClickArr[newPptTriggerActionClickArr.length - 1].name == "NewPptTriggerActionClick") {
						newPptTriggerActionClickArr[newPptTriggerActionClickArr.length - 1].data["form"] = "messageListReceivedHandler" ;									
						ServiceNewPptAynamicPPT.remoteActionData = newPptTriggerActionClickArr[newPptTriggerActionClickArr.length - 1].data ;  								
					}
				}
				$rootScope.shapeJson["NewPptTriggerActionClick"] = null ;
						
				//最后打开的文档文件和媒体文件	 
        		var lastDoucmentFileData = null,
					lastMediaFileData = null;
				var showPageArr = $rootScope.shapeJson["ShowPage"];
				if(showPageArr != null && showPageArr != undefined && showPageArr.length > 0) {
					for(var i = 0; i < showPageArr.length; i++) {
						if(!showPageArr[i].data.ismedia) {
							lastDoucmentFileData = showPageArr[i].data;
						} else {
							lastMediaFileData = showPageArr[i].data;
						}
					}
				}
				$rootScope.shapeJson["ShowPage"] = null;
	            
            	//打开文件列表中的一个
				if(lastDoucmentFileData != undefined && lastDoucmentFileData != null) {
					$timeout(function(){
						if(!lastDoucmentFileData.ismedia) {
							if(!lastDoucmentFileData.aynamicPPT){
								$rootScope.page.saveLcStackToStorage();
								$rootScope.page.setLcFileAttr(lastDoucmentFileData.filedata);
								$rootScope.page.pageOperation(null, false);
								$rootScope.roomPage.flag.isShow.isCourseFile = true ;
							}else{
								$rootScope.roomPage.flag.isShow.isCourseFile = false ;
	                            var isremote = true ;
	                            var isOpenPPT  = true;
	                            var pptslide = lastDoucmentFileData.filedata.pptslide ;
	                            var pptstep = lastDoucmentFileData.filedata.pptstep ;
	                            var pptfileid = lastDoucmentFileData.filedata.fileid ;
	                            $rootScope.page.saveLcStackToStorage();
	                            $rootScope.page.setLcFileAttr(lastDoucmentFileData.filedata);
	                            $rootScope.page.recoverLcData();
	                            $(document).trigger("uploadAynamicPptProgress" , [ pptslide , pptstep  , pptfileid , isOpenPPT , isremote ] );
							}
						}
						$("#file_list_"+lastDoucmentFileData.filedata.fileid).removeClass("active").addClass("active")
							.find(".t-open-container").addClass("on")
							.end().siblings("li").removeClass("active").find(".t-open-container").removeClass("on");
					},0);
			
				} 	  
				
				
			};
	    };
		
		
	

                    
		
		/*白板处理函数*/
	    $scope.phone.func.literallyHandle = function(){
		   /*白板元素*/
		   var $bigLc = $("#big_literally_vessel") ;
		   var $smallLc = $("#small_literally_vessel") ;
		    /*白板服务初始化*/
		    ServiceLiterally.initConfig["backgroundColor"] = "#d4d8dc" ;
		    ServiceLiterally.initConfig["secondaryColor"] = "#d4d8dc" ;
		    ServiceLiterally.rolePermission["laser"] = false ;
		    $scope.customLc = ServiceLiterally.lcInit( $bigLc , $smallLc ) ;
		    $scope.customLc.lc.toolStatus.eraserWidth = 120 ;
		    $scope.customLc.toolsInitBind();
	    };
	
       		
   			/*动态PPT相关处理方法*/
            $scope.excuteAynamicPPTFunction = function () {
                $scope.callController.func.aynamicPPTHandler = function(options){ //创建动态PPT处理对象
                    // ServiceAynamicPPT.clearAll();
                    ServiceNewPptAynamicPPT.clearAll();
                    if($rootScope.joinMeetingMessage && ($rootScope.hasRole.roleChairman || $rootScope.hasRole.roleTeachingAssistant || $rootScope.hasRole.roleStudent) ){
                        var sendMessagePermission = true ;
                        // ServiceAynamicPPT.setSendMessagePermission(sendMessagePermission);
                        ServiceNewPptAynamicPPT.setSendMessagePermission(sendMessagePermission);
                    }
                    // ServiceAynamicPPT.newDopPresentation(options);
                    ServiceNewPptAynamicPPT.newDopPresentation(options);

                    /*接收IFrame框架的消息*/
                    ServiceNewPptAynamicPPT.remoteIframeOrigin = $rootScope.loginController.necessary.serviceUrl+":"+ $rootScope.loginController.necessary.servicePort ;
                    // ServiceNewPptAynamicPPT.remoteIframeOrigin = "https://192.168.1.182:8443" ;
                    $(window).off('message');
                    ServiceTools.tool.addEvent(window ,'message' , function(event){    //给当前window建立message监听函数
                        try{
                            // 通过origin属性判断消息来源地址
                            console.log("receive remote iframe data form "+ event.origin +":",  event);
                            //if (ServiceNewPptAynamicPPT.remoteIframeOrigin.toString().indexOf(event.origin) != -1 ) {
                                if( event.data ){
                                    var data =  JSON.parse( event.data) ;
                                    if(data.sendAuthor === "newppt_iframe_children") {
                                    	var INITEVENT = "initEvent" ;
	                                    var SLIDECHANGEEVENT = "slideChangeEvent" ;
	                                    var STEPCHANGEEVENT = "stepChangeEvent" ;
	                                    var AUTOPLAYVIDEOINNEWPPT = "autoPlayVideoInNewPpt" ;   
	                                   	var CLICKNEWPPTTRIGGEREVENT = "clickNewpptTriggerEvent" ;
	                                    switch (data.action){
	                                        case INITEVENT :
	                                            ServiceNewPptAynamicPPT.remoteData.view = data.view ;	                                            
	                                            ServiceNewPptAynamicPPT.remoteData.slidesCount = data.slidesCount ;
	                                            ServiceNewPptAynamicPPT.remoteData.slide = data.slide ;
	                                            ServiceNewPptAynamicPPT.remoteData.step = data.step ;
	                                            ServiceNewPptAynamicPPT.remoteData.stepTotal = data.stepTotal ;
	                                            ServiceNewPptAynamicPPT.recvInitEventHandler(data.slide ,data.step );                                        
	                                            break ;
	                                        case SLIDECHANGEEVENT :
	                                            ServiceNewPptAynamicPPT.remoteData.slide = data.slide ;
	                                            ServiceNewPptAynamicPPT.remoteData.step = data.step ;
	                                            ServiceNewPptAynamicPPT.remoteData.stepTotal = data.stepTotal ;
	                                            ServiceNewPptAynamicPPT.recvSlideChangeEventHandler( data.slide );
	                                            var $videoEle = $("#phone_video_play_newppt");
	                                            console.log("SLIDECHANGEEVENT source size:" ,$videoEle.find("source").length );
												if($videoEle && $videoEle.length > 0 &&  ServiceNewPptAynamicPPT.playVideo ){		
													switch ( $rootScope.initPageParameterFormPhone.mClientType){
										                case 2://ios
										                	window.GLOBAL.phone.closeNewPptVideo();
										                	if(window.webkit && window.webkit.messageHandlers ){
										                		var tmpData = {action:"closeNewPptVideo" , elementId:$videoEle.attr("id") } ;
										                		tmpData = JSON.stringify(tmpData);										                		
										                		window.webkit.messageHandlers.closeNewPptVideo.postMessage({"data":tmpData});
										                	}else{
										                		console.error("没有方法window.webkit.messageHandlers.closeNewPptVideo.postMessage");
										                	}
										                    break;
										                case 3://android
										                	window.GLOBAL.phone.closeNewPptVideo();
										                    break;
										                default:
										                	console.error("没有设备类型，无法区分发送给手机的方法");
										                    break;
										            }
													ServiceNewPptAynamicPPT.playVideo = false ;
												}
	                                            break ;
	                                        case STEPCHANGEEVENT:
	                                            ServiceNewPptAynamicPPT.remoteData.slide = data.slide ;
	                                            ServiceNewPptAynamicPPT.remoteData.step = data.step ;
	                                            ServiceNewPptAynamicPPT.remoteData.stepTotal = data.stepTotal ;
	                                            ServiceNewPptAynamicPPT.recvStepChangeEventHandler(data.step);
	                                            break ;
	                                        case AUTOPLAYVIDEOINNEWPPT:	                                        
												if(!data.isPC){
													ServiceNewPptAynamicPPT.playVideo = true ;
													var $videoEle = $("#phone_video_play_newppt");
													$videoEle.removeAttr("src").find("source").remove();
													for (var i=0 ; i<data.resouceEleArr.length ; i++) {
														var resouceJson = data.resouceEleArr[i];
														var attrStr = "" ;
														for (var x in resouceJson) {
															var urlStr = "" ;
															if(x == "src"){						
//																resouceJson[x] = ServiceNewPptAynamicPPT.rPathAddress+resouceJson[x]+'?ts='+new Date().getTime() ;																
																resouceJson[x] = ServiceNewPptAynamicPPT.rPathAddress+resouceJson[x]  ;																
															}
                              								urlStr = resouceJson[x] ;
															attrStr += (x+'='+'"'+urlStr+'"  ') ;
														}
														
														if($rootScope.initPageParameterFormPhone.mClientType !== 2){
															$videoEle.append("<source "+attrStr+ " ></source>");		
														}
														
													}
												
													try{
									                	var videoData = JSON.stringify( data );
										        	    switch ( $rootScope.initPageParameterFormPhone.mClientType){
											            	case 2://ios
											            		try{
											            			$videoEle[0].pause();
										            				$videoEle.hide();
												            		if(window.webkit && window.webkit.messageHandlers ){
												                		window.webkit.messageHandlers.onJsPlay.postMessage({"data":videoData});
												                	}else{
												                		console.error("没有方法window.webkit.messageHandlers.onJsPlay.postMessage");
												                	}
											            		}catch(e8){
											            			console.error("动态PPT视频不能执行暂停pause方法！" , e8);
											            		}													            															            	
											                    break;
											                case 3://android
											                	$videoEle[0].load();
											                	if(window.JSWhitePadInterface){
											                    	window.JSWhitePadInterface.onJsPlay( videoData );
											                	}else{
											                		console.error("没有方法window.JSWhitePadInterface.onJsPlay");
											                	}
											                default:
											                    break;
											            }
								                	}catch(e7){
								                		console.error("autoPlayVideoInNewPpt  Canplay Event:" , e7);
								                	}   																					               	
												}	                                       
	                                            break ;
	                                        case CLICKNEWPPTTRIGGEREVENT:
	                                       	 	if($rootScope.roomPage.flag.isShow.isCourseFile === false &&  $rootScope.hasRole.roleChairman  ){							
													var testData = data  , signallingName = "NewPptTriggerActionClick" , assignId = "NewPptTriggerActionClick";
	                                            	$(document).trigger("sendDataToLiterallyEvent",[ null , testData , signallingName , assignId , true]);
						                        }	                                        	
	                                            break ;	                                            
	                                    }
                                    }                                    
                                }
                            //}
						}catch(e3){
                            console.error("message Event form iframe's parent :" , e3);
                        }
                    } , false  );
                };

          
                $scope.callController.func.openAynamicPPTHandler = function(isSetUrl,isSend){ //打开动态PPT
                 	$rootScope.roomPage.flag.isShow.isCourseFile = false ;
                    ServiceNewPptAynamicPPT.isOpenPptFile = !$rootScope.roomPage.flag.isShow.isCourseFile ;
                    ServiceLiterally.isOpenLcFile = $rootScope.roomPage.flag.isShow.isCourseFile ;
                    isSetUrl = isSetUrl!=undefined ? isSetUrl : true ;
                    isSend = isSend!=undefined ? isSend : true ;
                    ServiceLiterally.resetLcDefault();

                    ServiceLiterally.ele.find(".background-canvas").hide();
                    $("#big_literally_vessel").removeClass("aynamic-ppt-lc").addClass("aynamic-ppt-lc");
                    $(document).trigger("checkAynamicPptClickEvent",[]);

                    var  fileId = parseInt(  ServiceLiterally.ele.attr("data-file-id") ) ;
                    var swfPath = ServiceLiterally.ele.attr("data-file-swfpath");
                    var pptSlide = parseInt( ServiceLiterally.ele.attr("data-ppt-slide") );
                    var pptStep = parseInt( ServiceLiterally.ele.attr("data-ppt-step") );
                    var options = {
	                     rPathAddress:   $rootScope.loginController.necessary.serviceUrl+":"+ $rootScope.loginController.necessary.servicePort + swfPath+"/"  ,
                     	//rPathAddress:   "http://192.168.1.182:80" + swfPath+"/"  ,
                        PresAddress:"newppt.html?remoteHost="+window.location.host+"&remoteProtocol="+window.location.protocol+"&mClientType="+$rootScope.initPageParameterFormPhone.mClientType +"&deviceType="+$rootScope.initPageParameterFormPhone.deviceType+"&ts="+new Date().getTime(),
                        slideIndex:pptSlide ,
                        stepIndex:pptStep ,
                        fileid:fileId
                    };
                    console.log("openAynamicPPTHandler options" , JSON.stringify(options) );
                    if(isSend && $rootScope.isClassBegin && $rootScope.joinMeetingMessage && ( $rootScope.hasRole.roleChairman || $rootScope.hasRole.roleTeachingAssistant ) ){
                        var action = {action:"show"};
                        var data  = {
                        	slide:pptSlide,
                            step:pptStep ,
						};
                        for(var x in action){
                            data[x] = action[x];
                        }
                        data["total"] = ServiceNewPptAynamicPPT.slidesCount;
                        $(document).trigger("sendPPTMessageEvent",[data]);
                    }
                    if(isSetUrl){
                        ServiceLiterally.closeLoading();
                        $scope.callController.func.updateLcScaleWhenAynicPPTInitHandler( 16 / 9  );
                        ServiceNewPptAynamicPPT.setRPathAndPres(options);
                    }
                };
                $scope.callController.func.AynamicPPTJumpToAnim = function (slide , step) { //跳转到PPT的某一页的某一个帧
                    ServiceNewPptAynamicPPT.jumpToAnim(slide , step );
                };
                $scope.callController.func.updateLcScaleWhenAynicPPTInitHandler = function (lcLitellyScalc) {
                    ServiceLiterally.lcLitellyScalc = lcLitellyScalc;
                    ServiceLiterally.lc.watermarkImage = null ;
                    ServiceLiterally.setBackgroundWatermarkImage("");
                };
            };

            
        	/*发送PPT数据给其它人*/
            $(document).off("sendPPTMessageEvent");
            $(document).on("sendPPTMessageEvent",function (event , data ) {
                // if( $rootScope.isClassBegin &&  $rootScope.joinMeetingMessage && ( $rootScope.hasRole.roleChairman || $rootScope.hasRole.roleTeachingAssistant ) ){
                if(  $rootScope.joinMeetingMessage &&  $rootScope.hasRole.roleChairman  ){
                	if(data){
                        var signallingName = "ShowPage" ;
                        var assignId = 'DocumentFilePage_ShowPage';
                        var  fileId = parseInt(  ServiceLiterally.ele.attr("data-file-id") ) ;
                        var  allPageNum =  parseInt( ServiceLiterally.ele.attr("data-total-page")  )   ;
                        var  fileType =  ServiceLiterally.ele.attr("data-file-type");
                        var fileName = ServiceLiterally.ele.attr("data-file-name");
                        var swfPath = ServiceLiterally.ele.attr("data-file-swfpath");
                        var pptslide = data.slide;
                        var pptstep = data.step;
                        var currPageNum = data.slide ;
                        var action = data.action ;
                        var filedata = {
                            fileid:fileId ,
                            currpage:currPageNum ,
                            pagenum:allPageNum ,
                            filetype:fileType ? fileType:"" ,
                            filename:fileName?fileName:"" ,
                            swfpath:swfPath?swfPath:"" ,
                            pptslide:pptslide ,
                            pptstep:pptstep
                        };
                        var testData = {
                            ismedia:false ,
                            aynamicPPT:true ,
                            action:action ,
                            filedata:filedata
                        };
                        ServiceNewPptAynamicPPT.recvCount = 0 ;
                        console.log("ServiceNewPptAynamicPPT.recvCount" , ServiceNewPptAynamicPPT.recvCount);
						if( ServiceNewPptAynamicPPT.recvCount > 0){
                           return ;
						}else{
                            $(document).trigger("sendDataToLiterallyEvent",[ null , testData , signallingName , assignId]);
						}
					}
                }
            });
                
         	/*更新动态PPT的进度*/
	        $(document).off("uploadAynamicPptProgress");
	        $(document).on("uploadAynamicPptProgress" , function(event , slide , step ,  fileid  , openPPT , isRemote){ //绑定事件，更新动态PPT的进度
	            // ServiceAynamicPPT.isOpenPptFile = !$rootScope.roomPage.flag.isShow.isCourseFile ;
                ServiceNewPptAynamicPPT.isOpenPptFile = !$rootScope.roomPage.flag.isShow.isCourseFile ;
                ServiceLiterally.isOpenLcFile = $rootScope.roomPage.flag.isShow.isCourseFile ;
                if(isRemote){
                    ServiceNewPptAynamicPPT.recvCount ++ ;
                	var data = {
                        fileid: fileid ,
						slide: slide ,
						step:step
					};
                    ServiceNewPptAynamicPPT.changeRecvAynamicPptData(data);
				};
				/*  ServiceAynamicPPT.recvRemoteDataing = isremote ;
				 $timeout(function(){
				 ServiceAynamicPPT.recvRemoteDataing = false ;
				 },200);*/
                if(openPPT){
                    $scope.callController.func.openAynamicPPTHandler(true , false);
                    return ;
                }
                if( ServiceLiterally.ele.attr("data-file-id") == fileid.toString() ){
                    try{
                        $scope.callController.func.AynamicPPTJumpToAnim(slide,step);
                    }catch(e) {
                        $scope.callController.func.openAynamicPPTHandler(true, false);
                    }
                }
	        });
	
			/*绑定动态PPT更新白板尺寸事件*/
			$(document).off("updateLcScaleWhenAynicPPTInit");
			$(document).on("updateLcScaleWhenAynicPPTInit" , function (event , data) {
				console.log("updateLcScaleWhenAynicPPTInit" , data);
				if(data && data.Width && data.Height){
	                $scope.callController.func.updateLcScaleWhenAynicPPTInitHandler( data.Width / data.Height );
				}				
			});
	
			/*绑定动态PPT更新白板当前页画笔数据事件*/
	        $(document).off("slideChangeToLcData");
	        $(document).on("slideChangeToLcData" , function (event , data) {
	            console.log("trigger slideChangeToLcData" ,JSON.stringify(data)  , ServiceLiterally.ele.attr("data-curr-page") );
	            if(data){
	                $rootScope.page.saveLcStackToStorage();
	                $("#big_literally_vessel , #file_list_"+data.fileid )
	                    .attr("data-ppt-slide" , data.slide )
	                    .attr("data-curr-page" , data.slide);
	                $rootScope.page.recoverLcData();
	            }
	        });
	
			/*检测参与者能否点击事件*/
	        $(document).off("checkAynamicPptClickEvent");
	        $(document).on("checkAynamicPptClickEvent",function (event,data) {
	           if( ServiceNewPptAynamicPPT.isOpenPptFile  && ($rootScope.hasRole.roleChairman ||  $rootScope.hasRole.roleTeachingAssistant )  ){
                    if(  $("#tool_mouse").hasClass("active-tool") && ServiceLiterally.getIsDrawAble() ){
                        $("#scroll_literally_container").hide();
                    }else{
                        $("#scroll_literally_container").show();
                        ServiceLiterally.resizeHandler(ServiceLiterally);
                    }
                }else{
                    $("#scroll_literally_container").show();
                }
	        });
            
            /*更新白板的缩放比例*/
            $(document).off("updateLcScale");
            $(document).on("updateLcScale" , function(event , data){
           		ServiceLiterally.eleWHPercent = data ;
           		ServiceLiterally.resizeHandler(ServiceLiterally);
            });
              
             /*取消绑定的事件*/
            $(document).off("cancelEvent");
            $(document).on("cancelEvent" , function(event , data){
            	var execute = true ;
            	if(data){
            		if(data.rolePermissionNotExecute){
            			switch (data.rolePermissionNotExecute){
							case "chairman":
								if($rootScope.joinMeetingMessage && ($rootScope.hasRole.roleChairman || $rootScope.hasRole.roleTeachingAssistant) ){
                                    execute = false ;
								}
								break;
							default:
                                execute = true ;
								break;
						}
					}
					if(data.needClassBegin){
            			if($rootScope.isClassBegin !== true){
                            execute = false ;
						}
					}
					if(execute){
                        $(data.eventSelector).off(data.eventName) ;
					}
				}
			});
      
   		
		/*白板翻页代码*/
	    $rootScope.page = {
	        prevPage:function(){
	            $rootScope.page.saveLcStackToStorage();
	            $rootScope.page.pageOperation(false,true);
	        },
	        nextPage:function(){
	            $rootScope.page.saveLcStackToStorage();
	            $rootScope.page.pageOperation(true,true);
	        },
	        setLcFileAttr:function(data){
                ServiceLiterally.ele
                    .attr("data-file-id" , data.fileid)
                    .attr("data-curr-page",data.currpage )
                    .attr("data-total-page", data.pagenum )
                    .attr("data-file-type", data.filetype )
                    .attr("data-file-name", data.filename )
                    .attr("data-file-swfpath", data.swfpath)
                    .attr("data-ppt-slide", data.pptslide)
                    .attr("data-ppt-step", data.pptstep);
            },
           	defaultInitLcData:function(){ //默认初始化白板数据
                var data = {
                    fileid:0 ,
                    currpage:1 ,
                    pagenum:1 ,
                    swfpath:"" ,
                    filetype:"" ,
                    filename:"" ,
                    swfpath:"" ,
                    pptslide:0 ,
                    pptstep:0 ,
                };
                $rootScope.page.setLcFileAttr(data);
            },
	        showLiterally:function(isSend){
	            $rootScope.page.saveLcStackToStorage();
	            isSend = (isSend !=null && isSend!=undefined ?isSend:true);
	            $rootScope.page.pageOperation(null,isSend);
	        },
	        literallyAddPage:function(){
	        	if($rootScope.initPageParameterFormPhone.addPagePermission){
	        		$rootScope.page.saveLcStackToStorage();
		            var fileID =  0 ;
		            var currObj =  ServiceLiterally.ele ;
		            var pageTotal = parseInt( currObj.attr("data-total-page") ) + 1 ;
		            currObj.attr("data-total-page", pageTotal );
		            var signallingName = "WBPageCount" ;
		            var assignId = "AddBoardPage_WBPageCount";
		            var testData = {
		                totalPage: pageTotal ,
		                fileid:fileID
		            };
		            $(document).trigger("sendDataToLiterallyEvent",[ null , testData , signallingName , assignId]);		    
		            $rootScope.page.pageOperation(true,true);
	        	}
	        },
            pageOperation:function(isNext,isSend , isSetPlayUrl , isRemote){
            	/*手机特有代码 start*/
            	var $videoEle = $("#phone_video_play_newppt");
				if($videoEle && $videoEle.length > 0 && ServiceNewPptAynamicPPT.playVideo ){				
					switch ( $rootScope.initPageParameterFormPhone.mClientType){
		                case 2://ios
                    	window.GLOBAL.phone.closeNewPptVideo();
		                	if(window.webkit && window.webkit.messageHandlers ){
		                		var tmpData = {action:"closeNewPptVideo" , elementId:$videoEle.attr("id") } ;
		                		tmpData = JSON.stringify(tmpData);
		                		window.webkit.messageHandlers.closeNewPptVideo.postMessage({"data":tmpData});
		                	}else{
		                		console.error("没有方法window.webkit.messageHandlers.closeNewPptVideo.postMessage");
		                	}
		                    break;
		                case 3://android
		                	window.GLOBAL.phone.closeNewPptVideo();
		                    break;
		                default:
		                	console.error("没有设备类型，无法区分发送给手机的方法");
		                    break;
		            }
					ServiceNewPptAynamicPPT.playVideo = false ;
				}				        		
	            /*手机特有代码 end*/  
	              
                $rootScope.roomPage.flag.isShow.isCourseFile = true ;
                // ServiceAynamicPPT.isOpenPptFile = !$rootScope.roomPage.flag.isShow.isCourseFile ;
                ServiceNewPptAynamicPPT.isOpenPptFile = !$rootScope.roomPage.flag.isShow.isCourseFile ;
                ServiceLiterally.isOpenLcFile = $rootScope.roomPage.flag.isShow.isCourseFile ;
                isSend = (isSend!=null && isSend!=undefined ) ?isSend:true ;
                isSetPlayUrl = (isSetPlayUrl!=null && isSetPlayUrl!=undefined ) ?isSetPlayUrl:true ;
                $("#big_literally_vessel").removeClass("aynamic-ppt-lc") ;
                $("#aynamic_ppt_click").hide();
                $("#resizer").html("");
                $("#preloader").css("display" , 'none');
                ServiceLiterally.ele.find(".background-canvas").show();
                //ServiceAynamicPPT.stop();
                ServiceNewPptAynamicPPT.setNewPptFrameSrc("");
                ServiceLiterally.resetLcDefault();
				$(document).trigger("checkAynamicPptClickEvent",[]);
				 
				var  $prevPageBtnPhone = $("#content").find("#prev_page_phone") ;
	            var  $nextPageBtnPhone = $("#content").find("#next_page_phone") ;
	            var  $addPageBtnPhone = $("#content").find("#add_literally_page_phone") ;
                var  $prevPageBtn = $("#page_wrap").find("#prev_page") ;
                var  $nextPageBtn = $("#page_wrap").find("#next_page") ;
                var  $addPageBtn = $("#page_wrap").find("#add_literally_page") ;

                var  currPageNum =  parseInt( ServiceLiterally.ele.attr("data-curr-page")  )  ;
                var  allPageNum =  parseInt( ServiceLiterally.ele.attr("data-total-page")  )   ;
                var  fileId = parseInt(  ServiceLiterally.ele.attr("data-file-id") ) ;

                $prevPageBtn.add($nextPageBtn).add($addPageBtn).removeClass("pointer-events").addClass("pointer-events");
                $timeout(function(){
                    $prevPageBtn.add($nextPageBtn).add($addPageBtn).removeClass("pointer-events");
                },500);

                 if(isNext == true){
	                currPageNum ++ ;
	            }else if(isNext == false){
	                currPageNum -- ;
	            }
	          
	            if(currPageNum == 1){
	            	if ($rootScope.initPageParameterFormPhone.deviceType === 1 ) { //ipad
						$prevPageBtn.removeClass("disabled").addClass("disabled").attr("disabled","disabled");
					}else {
						$prevPageBtnPhone.removeClass("disabled").addClass("disabled").attr("disabled","disabled");
					}
	            }else{
	            	if ($rootScope.initPageParameterFormPhone.deviceType === 1 ) { //ipad
						$prevPageBtn.removeAttr("disabled").removeClass("disabled");
					}else {
						$prevPageBtnPhone.removeAttr("disabled").removeClass("disabled");
					}
	            }
	          
	            if(currPageNum == allPageNum){
	            	if ($rootScope.initPageParameterFormPhone.deviceType === 1 ) {//ipad
						$nextPageBtn.removeClass("disabled").addClass("disabled").attr("disabled","disabled");
					}else {
						$nextPageBtnPhone.removeClass("disabled").addClass("disabled").attr("disabled","disabled");
					}
	            }else{
	            	if ($rootScope.initPageParameterFormPhone.deviceType === 1 ) {//ipad
						$nextPageBtn.removeClass("disabled").removeAttr("disabled");
					}else {
						$nextPageBtnPhone.removeClass("disabled").removeAttr("disabled");
					}
	            }

                if(ServiceLiterally.ele.attr("data-file-id") == "0"){
                    ServiceLiterally.lcLitellyScalc = 16 / 9 ;
                      	if($rootScope.initPageParameterFormPhone.addPagePermission){
	            		if(currPageNum == allPageNum){
	            			if ($rootScope.initPageParameterFormPhone.deviceType === 1 ) {
								$addPageBtn.show();
		                    	$nextPageBtn.hide();
							}else {
								$addPageBtnPhone.show();
		                    	$nextPageBtnPhone.hide();
							}
		                }else{
		                	if ($rootScope.initPageParameterFormPhone.deviceType === 1 ) {
								$addPageBtn.hide();
		                    	$nextPageBtn.show();
							}else {
								$addPageBtnPhone.hide();
		                    	$nextPageBtnPhone.show();
							}
		                }
	            	}else{
	            		if ($rootScope.initPageParameterFormPhone.deviceType === 1 ) {
							$addPageBtn.hide();
	                    	$nextPageBtn.show();
						}else {
							$addPageBtnPhone.hide();
	                    	$nextPageBtnPhone.show();
						}
	            	}
                    if(isSetPlayUrl) {
                        ServiceLiterally.setBackgroundWatermarkImage("");
                    }
                    ServiceLiterally.ele.find(".background-canvas").hide();
                }else{
                	if ($rootScope.initPageParameterFormPhone.deviceType === 1 ) {
						$addPageBtn.hide();
                    	$nextPageBtn.show();
					}else {
						$addPageBtnPhone.hide();
                    	$nextPageBtnPhone.show();
					}
					try{
						var swfpath = ServiceLiterally.ele.attr("data-file-swfpath") ;
	                    var index = swfpath.lastIndexOf(".") ;
	                    var imgType = swfpath.substring(index);
	                    var fileUrl = swfpath.replace(imgType,"-"+currPageNum+imgType) ;
	                    var serviceUrl = $rootScope.loginController.necessary.serviceUrl+":"+$rootScope.loginController.necessary.servicePort ;
	                    if(isSetPlayUrl) {
	                        ServiceLiterally.setBackgroundWatermarkImage(serviceUrl + fileUrl);
	                    }
					}catch(e){
						console.error("出现错误，错误信息：", e ) ;
					}                 
                }
                
                if($rootScope.initPageParameterFormPhone.deviceType !=null && $rootScope.initPageParameterFormPhone.mClientType !=null){
 	            	 if( !$rootScope.initPageParameterFormPhone.addPagePermission && $rootScope.initPageParameterFormPhone.deviceType === 0 && allPageNum<=1 &&  ( $rootScope.initPageParameterFormPhone.mClientType === 3 || $rootScope.initPageParameterFormPhone.mClientType ===2 ) ){
						$prevPageBtnPhone.show();
						$nextPageBtnPhone.show();
						$addPageBtnPhone.hide();	
					}
	            }else{
	            	$prevPageBtnPhone.hide();
					$nextPageBtnPhone.hide();
					$addPageBtnPhone.hide();
	            }

                ServiceLiterally.ele.attr("data-curr-page",currPageNum );
                $fileListEle.find("#file_list_"+fileId).attr("data-curr-page",currPageNum );
                $scope.page.variable.pageNum = currPageNum ;
                $("#page_wrap").find("#curr_page").html(currPageNum);
                $("#page_wrap").find("#all_page").html(allPageNum);
                
                if( isSend ){
                    var signallingName = "ShowPage" ;
                    var assignId = "DocumentFilePage_ShowPage";
                    var swfPath = ServiceLiterally.ele.attr("data-file-swfpath");
                    var fileType =  ServiceLiterally.ele.attr("data-file-type");
                    var fileName = ServiceLiterally.ele.attr("data-file-name");
                    var filedata = {
                        fileid:fileId ,
                        currpage:currPageNum ,
                        pagenum:allPageNum ,
                        filetype:fileType ,
                        filename:fileName ,
                        swfpath:swfPath
                    };
                    var testData = {
                        ismedia:false ,
                        filedata:filedata
                    };
                    $(document).trigger("sendDataToLiterallyEvent",[ null , testData , signallingName , assignId]);
                };
                //加载当前页的白板数据
                $rootScope.page.recoverLcData(fileId , currPageNum);
            },
	       recoverLcData:function (fileId , currPageNum) {
                var  currPageNum = currPageNum ||  parseInt( ServiceLiterally.ele.attr("data-curr-page")  )  ;
                var  fileId = fileId || parseInt(  ServiceLiterally.ele.attr("data-file-id") ) ;
                ServiceLiterally.lc.clear(false);
                ServiceLiterally.lc.redoStack.length = 0 ;
                ServiceLiterally.lc.undoStack.length = 0 ;
                var undoStack = ServiceLiterally.stackStorage[ "undoStack_"+fileId+"_"+currPageNum ] ;
                var redoStack = ServiceLiterally.stackStorage[ "redoStack_"+fileId+"_"+currPageNum ] ;               
                if(undoStack && undoStack.length>0){
                    for (var i=0 ; i<undoStack.length; i++) {
                        var action =  undoStack[i] ;                      
                        if(action.constructor.name === "AddShapeAction"){
                            ServiceLiterally.lc.saveShape( action.shape  , false  , null , false);
                        }else if(action.constructor.name === "ClearAction"){
                            ServiceLiterally.lc.clear(false , action.id);
                        }
                    }
                }
                if($rootScope.joinMeetingMessage && $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleChairman){
					/*TODO 这里暂时采用老师将恢复栈的数据都加到撤销站中，再执行撤销操作，有待优化*/
                    if(redoStack && redoStack.length>0){
                        for (var i=redoStack.length - 1 ; i>=0; i--) {
                            var action =  redoStack[i] ;
                            if(action.constructor.name === "AddShapeAction"){
                                ServiceLiterally.lc.saveShape( action.shape  , false  , null , false);
                            }else if(action.constructor.name === "ClearAction"){
                                ServiceLiterally.lc.clear(false , action.id);
                            }
                        }
                        for (var i=0 ; i<redoStack.length; i++) {
                            ServiceLiterally.lc.undo(false);
                        }
                    }
                };
                ServiceLiterally.operationIsAbled();
                $("#lc_extend_more_tool").find("#tool_zoom_default").trigger("click");

                if(  $rootScope.shapeJson == undefined ||  $rootScope.shapeJson == null){
                    $rootScope.shapeJson = {};
                }else{
                    var currPageShapeArr =  $rootScope.shapeJson["SharpsChange_"+fileId+"_"+currPageNum] ;
                    if(currPageShapeArr!=null && currPageShapeArr!=undefined && currPageShapeArr.length>0){
                        ServiceLiterally.batchReceiveSnapshot(currPageShapeArr , $scope.userName);
                    }
                    $rootScope.shapeJson["SharpsChange_"+fileId+"_"+currPageNum] = null ;
                }
                
                if($rootScope.isClassBegin &&  !($rootScope.hasRole.roleChairman || $rootScope.hasRole.roleTeachingAssistant)  ){
                	$("#ppt_next_page_slide , #ppt_prev_page_slide , #next_page , #prev_page , #add_literally_page").addClass("disabled").attr("disabled","disabled").attr("data-set-disabled" ,'no');
				}
            },
            saveLcStackToStorage:function(){
                if( ServiceLiterally.ele ){                	 
                    if( ServiceLiterally.ele.attr("data-curr-page")!=undefined && ServiceLiterally.ele.attr("data-curr-page")!=""   && ServiceLiterally.ele.attr("data-file-id")!=undefined  && ServiceLiterally.ele.attr("data-file-id")!="" ){
                        var  currPageNum =  parseInt( ServiceLiterally.ele.attr("data-curr-page")  )  ;
                        var  fileId = parseInt( ServiceLiterally.ele.attr("data-file-id") ) ;
                    
                        ServiceLiterally.stackStorage["undoStack_"+fileId+"_"+currPageNum]  = ServiceLiterally.lc.undoStack.slice(0) ;
                        if($rootScope.joinMeetingMessage && $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleChairman){
                            ServiceLiterally.stackStorage["redoStack_"+fileId+"_"+currPageNum]  = ServiceLiterally.lc.redoStack.slice(0)  ;
						}
                    }
                }
            },
	       variable:{
	            pageNum:1
	        }
	    };

		
	    /*会议页面控制*/
	    $rootScope.roomPage = {
	        flag:{
	            isShow:{
	                graffitiTools:false ,  //涂鸦工具
                    isCourseFile:true , //是否是课件文件
	                literallyWritePermission:true , //白板写入权限
	            }
	        } ,
	        elementShow:function(hideElementIdArr , showElementIdArr){
	            if(hideElementIdArr && hideElementIdArr.length>0){
	                hideElementIdArr.forEach(function(eleId){
	                    $("#"+eleId).hide();
	                });
	            }
	            if(showElementIdArr && showElementIdArr.length>0){
	                showElementIdArr.forEach(function(eleId){
	                    $("#"+eleId).show();
	                });
	            }
	        }
	    };
		
		
	    /*执行页面功能函数*/
		$scope.phone.func.execute = function(){
			var root =  document.getElementById("all_root");
	       /*动态更改html的font-size*/
	        $(window).off("resize");
	        $(window).resize(function (event , triggerTypeJson , notTriggerTypeJson) {
	           var baseSize = 15.8 ; 
	           var defalutFontSize = window.innerWidth / baseSize;
	           root.style.fontSize = defalutFontSize+ 'px';
	            var LC = "lc" ;
                if( notTriggerTypeJson ){
                	if(!notTriggerTypeJson[LC] ){
                        ServiceLiterally.resizeHandler(ServiceLiterally);
					}
				}else{
                    ServiceLiterally.resizeHandler(ServiceLiterally);
				}
	        });
	    	/*执行白板处理函数*/
			$scope.phone.func.literallyHandle();	
			$rootScope.page.defaultInitLcData();
			$rootScope.page.showLiterally(false);
			
			/*动态PPT部分 start*/
            $scope.excuteAynamicPPTFunction();
            
            $scope.isfullLc = false ; //白板是否全屏
            $("#lc_full_btn , #ppt_lc_full_btn").click(function(){
            	$scope.isfullLc = !$scope.isfullLc ;
            	var fullClass = $scope.isfullLc ? "yes" : "no" ;
            	 $("#lc_full_btn , #ppt_lc_full_btn").removeClass("yes no").addClass(fullClass);
        	    switch ( $rootScope.initPageParameterFormPhone.mClientType){
	                case 2://ios
	                	if(window.webkit && window.webkit.messageHandlers ){
	                		window.webkit.messageHandlers.fullScreenToLc.postMessage({"data":$scope.isfullLc});
	                	}else{
	                		console.error("没有方法window.webkit.messageHandlers.fullScreenToLc.postMessage");
	                	}
	                    break;
	                case 3://android
	                	if(window.JSWhitePadInterface){
	                    	window.JSWhitePadInterface.fullScreenToLc( $scope.isfullLc );
	                	}else{
	                		console.error("没有方法window.JSWhitePadInterface.fullScreenToLc");
	                	}
	                    break;
	                default:
	                	console.error("没有设备类型，无法区分发送给手机的方法");
	                    break;
	            };           
            });
           
		}

		GLOBAL.phone = {
			flag:{
				isInit:false 
			},
			drawPermission:function(isDraw){ //白板可画权限控制，true-可话画 ， false-不可画
				GLOBAL.phone.logMessage( {method:'drawPermission',isDraw:isDraw} , "ios");
				ServiceLiterally.setIsDrawAble(isDraw);
				if($rootScope.initPageParameterFormPhone.deviceType === 1){ //ipad
					if(isDraw){
						$("#role_control_draw_permission , #pad-draw-tool").removeClass("no-permission");
					}else{
						$("#role_control_draw_permission, #pad-draw-tool").removeClass("no-permission").addClass("no-permission");
					}	
				}else{
					if(isDraw){
						$("#role_control_draw_permission , #lc_tool_container").removeClass("no-permission");
					}else{
						$("#role_control_draw_permission, #lc_tool_container").removeClass("no-permission").addClass("no-permission");
					}
				}
				$(document).trigger("checkAynamicPptClickEvent",[]);
				
			} , 
			pageTurningPermission:function(isPageTurning){ //翻页权限控制，true-可翻页， false-不可翻页
				GLOBAL.phone.logMessage( {method:'pageTurningPermission',isPageTurning:isPageTurning} , "ios");				
				if($rootScope.initPageParameterFormPhone.deviceType === 1){ //ipad
//					console.error(isPageTurning);
					if(isPageTurning){
						$("#page_wrap.ipad").removeClass("no-permission");
					}else{
//						$("#page_wrap.ipad").removeClass("no-permission").addClass("no-permission");
						$("#page_wrap.ipad").addClass("disabled").attr("disabled");
					}
				}else{
					console.error(isPageTurning);
					if(isPageTurning){//可翻页时显示
						$("#content.lc-container").find(".lc-tool-icon-wrap.page-phone").removeClass("no-permission");
					}else{//不可翻页时隐藏
						$("#content.lc-container").find(".lc-tool-icon-wrap.page-phone").addClass("no-permission");
					}
				}
			} ,
			setInitPageParameterFormPhone:function (data){ //设置初始化手机端参数
				var that = this ;
				GLOBAL.phone.logMessage( {method:'setInitPageParameterFormPhone',data:data} , "ios");
				if (data.deviceType === 0) {
					$("#ppt_page_wrap,#page_wrap").hide();
				}else if (data.deviceType === 1) {
					$("#page_wrap").removeClass("no-permission");
				}
				if(!GLOBAL.phone.flag.isInit){
					GLOBAL.phone.flag.isInit = true ;
					$rootScope.initPageParameterFormPhone = data ;
				
					/*执行call相关操作*/
					
					if($rootScope.initPageParameterFormPhone.serviceUrl){
						$rootScope.loginController.necessary.serviceUrl = $rootScope.initPageParameterFormPhone.serviceUrl.address ;
						$rootScope.loginController.necessary.servicePort = $rootScope.initPageParameterFormPhone.serviceUrl.port ;
						
	//					$scope.url = {
	//	//					serviceUrl:{address:"https://192.168.0.66" , port:443}
	//						serviceUrl:$rootScope.initPageParameterFormPhone.serviceUrl
	//					};
					}
                    if($rootScope.initPageParameterFormPhone.role != undefined && $rootScope.initPageParameterFormPhone.role != null ){
                        $rootScope.joinMeetingMessage.roomrole = $rootScope.initPageParameterFormPhone.role ;
						/*当前登录对象事是否拥有指定角色*/
                        $rootScope.hasRole = {};
                        Object.defineProperties( $rootScope.hasRole , {
                            //0：主讲  1：助教    2: 学员   3：直播用户 4:巡检员　10:系统管理员　11:企业管理员　12:管理员
                            roleChairman: {
                                value:$rootScope.joinMeetingMessage && $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleChairman ,
                                writable: false ,
                            },
                            roleTeachingAssistant: {
                                value:$rootScope.joinMeetingMessage &&  $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleTeachingAssistant  ,
                                writable: false ,
                            },
                            roleStudent: {
                                value:$rootScope.joinMeetingMessage &&  $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleStudent ,
                                writable: false ,
                            },
                            roleAudit:{
                                value:$rootScope.joinMeetingMessage &&  $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleAudit ,
                                writable: false ,
                            } ,
                            rolePatrol:{
                                value:$rootScope.joinMeetingMessage && $rootScope.joinMeetingMessage.roomrole === $rootScope.role.rolePatrol ,
                                writable: false ,
                            }
                        });
                        that.roleSettingPage($rootScope.joinMeetingMessage.roomrole);
                        if(!$scope.aynamicPPT){
                            $scope.callController.func.aynamicPPTHandler();//动态PPT初始化
                            $scope.aynamicPPT = true ;
                        }
                    }
					if($rootScope.initPageParameterFormPhone.deviceType!=undefined  && $rootScope.initPageParameterFormPhone.deviceType === 1){
						/*ipad 白板工具代码*/
						$("#prev_page_phone,#next_page_phone,#add_literally_page_phone,#prev_page_phone_slide,#next_page_phone_slide").hide();
						$scope.drawingBandle = function () {
							//var color = $(".t1-color button[data-color='']");
							var pencilWidth = "";
							var eraserWidth = "";
							$scope.settingSize = function () {
								$scope.customLc.lc.toolStatus.pencilWidth = parseFloat( pencilWidth ) ;//设置画笔尺寸
				    			$scope.customLc.lc.toolStatus.eraserWidth = parseFloat( eraserWidth ) ;//设置橡皮尺寸
				    			if(  $("#tool_eraser").hasClass("active-tool") ){
				                	$scope.customLc.uploadEraserWidth();
				               	}else{
				                	$scope.customLc.uploadPencilWidth();
				                }
							}
							
							$("#tool_mouse,#tool_pencil,#tool_eraser").click(function () {
								$(this).parent().siblings(".tl-tool").children("button").removeClass("active");
								$(this).addClass("active");
                            });
							
							/*选择尺寸：*/
							$(".tool-color-top .tool-pencil-size").click(function () {
								pencilWidth = $(this).attr("data-pencil-size");/*保存画笔尺寸*/
								eraserWidth = $(this).attr("data-eraser-size");/*保存橡皮尺寸*/
                                $scope.settingSize();
                                $(this).parent().siblings(".tool-color-top").removeClass("active");
                                $(this).parent().addClass("active");
							});

							/*选择颜色：*/
                            $(".t1-color button").click(function () {
                                $scope.customLc.uploadColor('primary' , "#"+$(this).attr("data-color") );
                                $(this).parent().siblings(".t1-color").removeClass("active");
								$(this).parent().addClass("active");
                            });
						}
						$scope.drawingBandle();

						$(".tool-color-top .tool-pencil-size[data-pencil-size='5']").trigger("click");//初始尺寸为5
						// $(".tool-color-bottom .tool-color-btn").trigger("click");
						$("#tool_mouse").trigger("click");

					}else if($rootScope.initPageParameterFormPhone.deviceType!=undefined &&  $rootScope.initPageParameterFormPhone.deviceType === 0 ){
					   /*=========Phone 涂鸦工具 start =====================*/
						$("#lc_tool_container").on("click",".tl-color button",function () { //颜色添加点击事件
				            $(this).parents(".tl-color").addClass("active").siblings(".tl-color").removeClass("active");
				            $scope.customLc.uploadColor('primary' , "#"+$(this).attr("data-color") );//设置画笔颜色
			//	            $scope.customLc.lc.setColor('primary',"#"+$(this).attr("data-color")); 
				        });
				        $("#lc_tool_container").find(".tl-color button.red").trigger("click");
				        
				        $("#lc_tool_container").on("click",".tl-tool button",function () {//涂鸦工具添加点击事件
				            $(this).parents(".tl-tool").addClass("active").siblings(".tl-tool").removeClass("active");
				        });
						/*=========Phone 涂鸦工具 end =====================*/
					}
					
					$("#room").find(".opacity-init").removeClass("opacity-init");
				}
			} , 
			changeInitPageParameterFormPhone:function(recvObj){  //修改手机初始化参数	
				GLOBAL.phone.logMessage( {method:'changeInitPageParameterFormPhone',recvObj:recvObj} , "ios");
				var that = this ;
				for (var key in recvObj) {
					var value = recvObj[key];
					$rootScope.initPageParameterFormPhone[key] = value ;
					if(key === "role"){
						$rootScope.joinMeetingMessage.roomrole = $rootScope.initPageParameterFormPhone.role ;
						/*当前登录对象事是否拥有指定角色*/
	                    $rootScope.hasRole = {};
	                    Object.defineProperties( $rootScope.hasRole , {
	                        //0：主讲  1：助教    2: 学员   3：直播用户 4:巡检员　10:系统管理员　11:企业管理员　12:管理员
	                        roleChairman: {
	                            value:$rootScope.joinMeetingMessage && $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleChairman ,
	                            writable: false ,
	                        },
	                        roleTeachingAssistant: {
	                            value:$rootScope.joinMeetingMessage &&  $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleTeachingAssistant  ,
	                            writable: false ,
	                        },
	                        roleStudent: {
	                            value:$rootScope.joinMeetingMessage &&  $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleStudent ,
	                            writable: false ,
	                        },
	                        roleAudit:{
	                            value:$rootScope.joinMeetingMessage &&  $rootScope.joinMeetingMessage.roomrole === $rootScope.role.roleAudit ,
	                            writable: false ,
	                        } ,
	                        rolePatrol:{
	                            value:$rootScope.joinMeetingMessage && $rootScope.joinMeetingMessage.roomrole === $rootScope.role.rolePatrol ,
	                            writable: false ,
	                        }
	                    });
						that.roleSettingPage($rootScope.joinMeetingMessage.roomrole);
						if(!$scope.aynamicPPT){
                            $scope.callController.func.aynamicPPTHandler();//动态PPT初始化
                            $scope.aynamicPPT = true ;
						}
					}
				}
			},
			receivePhoneByTriggerEvent:function(eventName, params){ //接收手机端数据
				GLOBAL.phone.logMessage( {method:'receivePhoneByTriggerEvent',eventName:eventName , params:params} , "ios");
				var obj = {params:params};
				$(document).trigger(eventName,[obj]);
			},
			phonePage:function(date){
				GLOBAL.phone.logMessage( {method:'phonePage',date:date} , "ios");
				if (typeof date == "string") {
					var date = JSON.parse(date);
				}
				if (date.isDynamicPPt == true) {
					if (date.action == 'left') {
						$("#prev_page_phone_slide").trigger("click");
					}else if(date.action == 'right'){
						$("#next_page_phone_slide").trigger("click");
					}
				}else {
					if (date.action == 'left') {
						$rootScope.page.prevPage();
					}else if(date.action == 'right'){
						$rootScope.page.nextPage();
					}
				}
			},
			logMessage:function(message,clientType){ //日志接口				
				console.info("logMessage:" , message , clientType);
				message = JSON.stringify(message);
				var typeNum  = null ;
				switch (clientType){
					case "ios":
						typeNum = 2 ;
						break;
					case "android":
						typeNum = 3 ;
						break;
					default:
						typeNum = $rootScope.initPageParameterFormPhone.mClientType ;
						break;
				}
				if(typeNum != $rootScope.initPageParameterFormPhone.mClientType){
					return ;
				}
				switch ( typeNum){
	            	case 2://ios
	            		if(window.webkit && window.webkit.messageHandlers ){
	                		window.webkit.messageHandlers.printLogMessage.postMessage({"data":{msg:message}});
	                	}else{
	                		console.error("没有方法window.webkit.messageHandlers.printLogMessage.postMessage");
	                	}
	                    break;
	                case 3://android
	                	if(window.JSWhitePadInterface){
	                    	window.JSWhitePadInterface.printLogMessage( {msg:message} );
	                	}else{
	                		console.error("没有方法window.JSWhitePadInterface.printLogMessage");
	                	}
	                default:
	                    break;
	            }
			},
			clearLcAllData:function(){ //清除白板所有数据
				GLOBAL.phone.logMessage( {method:'clearLcAllData'} , "ios");
				ServiceLiterally.lc.clear(false);
			    ServiceLiterally.lc.redoStack.length = 0 ;
			    ServiceLiterally.lc.undoStack.length = 0 ;
			    ServiceLiterally.stackStorage = {} ;//白板数据栈对象
			},
			roleSettingPage:function(role){ //角色决定ipad页面
				GLOBAL.phone.logMessage( {method:'roleSettingPage' , role:role} , "ios");
				if(role === $rootScope.role.roleStudent){
					$(".role-student-hide").css({"display":"none !important"});
				}
			} , 
			newPptAutoPlay:function(videoDataJson){ //动态PPT自动播放		
				GLOBAL.phone.logMessage( {method:'newPptAutoPlay' , videoDataJson:videoDataJson} , "ios");
				try{
					if(typeof videoDataJson  ==  "string"){
						videoDataJson = JSON.parse(videoDataJson);
					}
					var videoData = videoDataJson.videoData ;
					if(typeof videoData  ==  "string"){
						videoData = JSON.parse(videoData);						
					}
					if(videoData.action === "autoPlayVideoInNewPpt" && videoData.videoElementId ){				
						var $videoEle = $("#phone_video_play_newppt");
						$videoEle.show();
						if($videoEle && $videoEle.length > 0  && $videoEle.find("source").length>0 ){
							$videoEle[0].currentTime = 0 ;
							if(videoData.isPlay){
								$videoEle[0].play();
							}else{
								$videoEle[0].pause();
							}	
						}
					}					
				}catch(e){
					console.error("newPptAutoPlay error:" ,e);
				}							
			},
			closeNewPptVideo:function(data){
				GLOBAL.phone.logMessage( {method:'closeNewPptVideo' , data:data} , "ios");
				var $videoEle = $("#phone_video_play_newppt");
	        	if($videoEle && $videoEle.length > 0 && ServiceNewPptAynamicPPT.playVideo){
	        		$videoEle.removeAttr("src").hide().find("source").remove();
	        	 	$videoEle[0].currentTime = 0 ;
					$videoEle[0].pause();				
	        	}    
			},
			resizeNewpptHandler:function(data){ //改变动态ppt大小
				GLOBAL.phone.logMessage( {method:'resizeNewpptHandler' , data:data} , "ios");
               if(ServiceNewPptAynamicPPT.remoteData  ){
			      	if(typeof data == "string"){
			      		data = JSON.parse(data);
			      	}
			      	data.action = "resizeHandler" ;
               		ServiceNewPptAynamicPPT.postMessage(data);               
               	}else{
              		console.error("phone resizeHandler error:" , ServiceNewPptAynamicPPT.remoteData);
                }              	
			}

		}	
	  	
		$scope.bindDocumentEvent();
		$scope.phone.func.execute();
  	
		if(window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.onPageFinished ){//ios
			window.webkit.messageHandlers.onPageFinished.postMessage({"data":""});
		}else if(window.JSWhitePadInterface && window.JSWhitePadInterface.onPageFinished){//android
	    	window.JSWhitePadInterface.onPageFinished();
		}else{
			console.error("没有方法window.webkit.messageHandlers.onPageFinished.postMessage 和 window.JSWhitePadInterface.onPageFinished");
		}
		
		GLOBAL.phone.drawPermission(false);
		GLOBAL.phone.pageTurningPermission(false);
  		
	});
});

