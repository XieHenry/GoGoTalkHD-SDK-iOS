webpackJsonp([2,0],{

/***/ 0:
/***/ (function(module, exports, __webpack_require__) {

	module.exports = __webpack_require__(281);


/***/ }),

/***/ 10:
/***/ (function(module, exports) {

	/**
	 * 事件对象定义组件
	 * @module eventUtilModule
	 * @description  用于定义事件分发器的对象
	 * @author QiuShao
	 * @date 2017/7/6
	 */
	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	var eventsObj = {};
	eventsObj.Document = TK.EventDispatcher({});
	eventsObj.Window = TK.EventDispatcher({});
	eventsObj.Element = TK.EventDispatcher({});
	eventsObj.Room = TK.EventDispatcher({});
	eventsObj.Stream = TK.EventDispatcher({});
	eventsObj.Role = TK.EventDispatcher({});
	exports["default"] = eventsObj;
	module.exports = exports["default"];

/***/ }),

/***/ 12:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * TK全局变量类
	 * @class TkGlobal
	 * @description   提供 TK系统所需的全局变量
	 * @author QiuShao
	 * @date 2017/7/21
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	window.GLOBAL = window.GLOBAL || {};
	var TkGlobal = window.GLOBAL;
	
	TkGlobal.classBegin = false; //是否已经上课
	TkGlobal.endClassBegin = false; //结束上课
	TkGlobal.routeName = undefined; //路由的位置
	TkGlobal.playback = false; //是否回放
	TkGlobal.playPptVideoing = false; //是否正在播放PPT视频
	TkGlobal.playMediaFileing = false; //是否正在播放媒体文件
	TkGlobal.serviceTime = undefined; //服务器的时间
	TkGlobal.firstGetServiceTime = false; //是否是第一次获取服务器的时间
	TkGlobal.isHandleMsglist = false; //是否已经处理msglist数据
	TkGlobal.remindServiceTime = undefined; //remind用的服务器的时间
	TkGlobal.classBeginTime = undefined; //上课的时间
	TkGlobal.isSkipPageing = false; //是否正在输入跳转页
	TkGlobal.isClient = false; //是否客户端
	TkGlobal.isBroadcast = false; //是否直播
	TkGlobal.mobileDeviceType = undefined;
	
	var browserInfo = _TkUtils2['default'].getBrowserInfo();
	L.Logger.debug("浏览器 browserInfo:" + JSON.stringify(browserInfo));
	TkGlobal.isMobile = browserInfo.versions.mobile || browserInfo.versions.ios || browserInfo.versions.android || browserInfo.versions.iPhone || browserInfo.versions.iPad; //是否是移动端
	TkGlobal.isBroadcastClient = TkGlobal.isClient && TkGlobal.isBroadcast; //是否是直播且客户端
	TkGlobal.isBroadcastMobile = TkGlobal.isMobile && TkGlobal.isBroadcast; //是否是直播且是移动端
	// TkGlobal.languageName = browserInfo.language && browserInfo.language.toLowerCase().match(/zh/g) ? 'chinese': 'english' ;
	TkGlobal.languageName = _TkUtils2['default'].getUrlParams('languageType') === 'ch' ? 'chinese' : _TkUtils2['default'].getUrlParams('languageType') === 'tw' ? 'complex' : 'english';
	TkGlobal.defaultFileInfo = {
	    fileid: 0,
	    currpage: 1,
	    pagenum: 1,
	    filetype: 'whiteboard',
	    filename: 'whiteboard',
	    swfpath: '',
	    pptslide: 1,
	    pptstep: 0,
	    steptotal: 0
	}; //默认的文件信息
	
	exports['default'] = TkGlobal;
	module.exports = exports['default'];

/***/ }),

/***/ 18:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * TK常量类
	 * @class TkConstant
	 * @description   提供 TK系统所需的常量
	 * @author QiuShao
	 * @date 2017/7/21
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var TkConstant = {};
	/*版本号*/
	var VERSIONS = 'v2.0.5',
	    VERSIONSTIME = '2017110323',
	    DEV = false;
	try {
	    VERSIONS = ('2.0.7');
	    VERSIONSTIME = (2017110622);
	    DEV = (true);
	} catch (e) {
	    L.Logger.warning('There is no configuration version number and version time[__VERSIONS__ , __VERSIONSTIME__]!');
	    L.Logger.warning('There is no configuration dev mark[__DEV__]!');
	}
	TkConstant.VERSIONS = VERSIONS; //系统版本号
	TkConstant.VERSIONSTIME = VERSIONSTIME; //系统版本号更新时间
	TkConstant.newpptVersions = 2017091401; //动态ppt的版本
	TkConstant.remoteNewpptUpdateTime = 201710171022; //远程动态PPT文件更新时间
	TkConstant.debugFromAddress = _TkUtils2['default'].getUrlParams('debug') ? _TkUtils2['default'].getUrlParams('debug') != "" : false; //从地址栏设置系统为debug状态
	TkConstant.DEV = DEV || TkConstant.debugFromAddress; //系统是否处于开发者状态
	
	/*角色对象*/
	TkConstant.role = {};
	Object.defineProperties(TkConstant.role, {
	    //0：主讲  1：助教    2: 学员   3：直播用户 4:巡检员　10:系统管理员　11:企业管理员　12:管理员 , -1:回放者
	    roleChairman: {
	        value: 0,
	        writable: false
	    },
	    roleTeachingAssistant: {
	        value: 1,
	        writable: false
	    },
	    roleStudent: {
	        value: 2,
	        writable: false
	    },
	    roleAudit: {
	        value: 3,
	        writable: false
	    },
	    rolePatrol: {
	        value: 4,
	        writable: false
	    },
	    rolePlayback: {
	        value: -1,
	        writable: false
	    }
	});
	
	var RoomEvent = {}; //房间事件
	Object.defineProperties(RoomEvent, {
	    roomConnected: { //room-connected 房间连接事件
	        value: 'room-connected',
	        writable: false,
	        enumerable: true
	    },
	    roomParticipantJoin: { //room-participant_join 参与者加入房间事件
	        value: 'room-participant_join',
	        writable: false,
	        enumerable: true
	    },
	    roomParticipantLeave: { //room-participant_leave  参与者离开房间事件
	        value: 'room-participant_leave',
	        writable: false,
	        enumerable: true
	    },
	    roomPubmsg: { //room-pubmsg pubMsg消息事件
	        value: 'room-pubmsg',
	        writable: false,
	        enumerable: true
	    },
	    roomDelmsg: { //room-delmsg delMsg消息事件
	        value: 'room-delmsg',
	        writable: false,
	        enumerable: true
	    },
	    roomUserpropertyChanged: { //room-userproperty-changed setProperty消息事件
	        value: 'room-userproperty-changed',
	        writable: false,
	        enumerable: true
	    },
	    roomDisconnected: { // room-disconnected 房间失去连接事件
	        value: 'room-disconnected',
	        writable: false,
	        enumerable: true
	    },
	    roomMsglist: { //room-msglist：房间信令msglist事件
	        value: 'room-msglist',
	        writable: false,
	        enumerable: true
	    },
	    roomPlaybackClearAll: { //room-playback-clear_all：回放清除所有信令生成的数据
	        value: 'room-playback-clear_all',
	        writable: false,
	        enumerable: true
	    }
	});
	
	var WindowEvent = {}; //window事件
	Object.defineProperties(WindowEvent, {
	    onResize: { //onResize 窗口改变事件
	        value: 'onResize',
	        writable: false
	    }
	});
	Object.defineProperties(WindowEvent, {
	    onMessage: { //message
	        value: 'onMessage',
	        writable: false
	    }
	});
	
	var DocumentEvent = {}; //document事件
	Object.defineProperties(DocumentEvent, {
	    onKeydown: { //onKeydown 键盘按下事件
	        value: 'onKeydown',
	        writable: false
	    },
	    onFullscreenchange: { //onFullscreenchange 全屏状态改变事件
	        value: 'onFullscreenchange',
	        writable: false
	    }
	});
	
	/*事件类型*/
	TkConstant.EVENTTYPE = {};
	Object.defineProperties(TkConstant.EVENTTYPE, {
	    RoomEvent: {
	        value: RoomEvent,
	        writable: false
	    },
	    WindowEvent: {
	        value: WindowEvent,
	        writable: false
	    },
	    DocumentEvent: {
	        value: DocumentEvent,
	        writable: false
	    }
	});
	
	/*房间类型*/
	TkConstant.ROOMTYPE = {};
	Object.defineProperties(TkConstant.ROOMTYPE, {
	    //1：1 ， 1：6 ， 1：多 , 大讲堂（直播）
	    oneToOne: { //1对1
	        value: 0,
	        writable: false
	    }
	});
	
	/*发布状态*/
	/*  oneToSix: {//1对6
	      value: 1,
	      writable: false,
	  },
	  oneToMore: { //1对多
	      value: 3,
	      writable: false,
	  },
	  liveBroadcast: { // 大讲堂（直播）
	      value: 10,
	      writable: false,
	  }*/
	TkConstant.PUBLISHSTATE = {};
	Object.defineProperties(TkConstant.PUBLISHSTATE, {
	    PUBLISH_STATE_NONE: {
	        value: TK.PUBLISH_STATE_NONE, //下台,
	        writable: false
	    },
	    PUBLISH_STATE_AUDIOONLY: {
	        value: TK.PUBLISH_STATE_AUDIOONLY, //只发布音频,
	        writable: false
	    },
	    PUBLISH_STATE_VIDEOONLY: {
	        value: TK.PUBLISH_STATE_VIDEOONLY, //只发布视频,
	        writable: false
	    },
	    PUBLISH_STATE_BOTH: {
	        value: TK.PUBLISH_STATE_BOTH, //音视频都发布,
	        writable: false
	    },
	    PUBLISH_STATE_MUTEALL: {
	        value: TK.PUBLISH_STATE_MUTEALL, //音视频都关闭,
	        writable: false
	    }
	});
	
	/*rem 基准大小*/
	TkConstant.STANDARDSIZE = 15.8;
	
	/*企业companyidMap*/
	TkConstant.companyidToCompanyName = {
	    10035: { //英联邦
	        value: 'icoachu',
	        writable: false,
	        enumerable: true
	    },
	    10036: { //笨鸟
	        value: 'stupidBird',
	        writable: false,
	        enumerable: true
	    },
	    10059: { //一起作业
	        value: '17zuoye',
	        writable: false,
	        enumerable: true
	    }
	};
	
	/*输出日志等级*/
	TkConstant.LOGLEVEL = {};
	Object.defineProperties(TkConstant.LOGLEVEL, {
	    DEBUG: {
	        value: 0,
	        writable: false
	    },
	    TRACE: {
	        value: 1,
	        writable: false
	    },
	    INFO: {
	        value: 2,
	        writable: false
	    },
	    WARNING: {
	        value: 3,
	        writable: false
	    },
	    ERROR: {
	        value: 4,
	        writable: false
	    },
	    NONE: {
	        value: 5,
	        writable: false
	    }
	});
	
	/*绑定服务器地址信息到TkConstant*/
	TkConstant.SERVICEINFO = {};
	TkConstant.bindServiceinfoToTkConstant = function (protocol, hostname, port) {
	    var isInit = arguments.length <= 3 || arguments[3] === undefined ? true : arguments[3];
	
	    var addressArray = TK.global.initPageParameterFormPhone.serviceUrl.address.split("://");
	    Log.error(protocol, hostname, port, isInit, TK.global.initPageParameterFormPhone.serviceUrl, addressArray);
	    protocol = protocol || addressArray[0];
	    hostname = hostname || addressArray[1];
	    port = port || TK.global.initPageParameterFormPhone.serviceUrl.port;
	    var serviceinfo = {
	        protocol: protocol,
	        hostname: hostname,
	        port: port,
	        sdkPort: 443,
	        protocolAndHostname: protocol + "://" + hostname,
	        address: protocol + "://" + hostname + ":" + port
	    };
	    if (isInit) {
	        serviceinfo.joinUrl = _TkUtils2['default'].encrypt(window.location.href);
	    }
	    Object.assign(TkConstant.SERVICEINFO, serviceinfo);
	    if (isInit) {
	        console.info('encrypt_tk_info:\n', TkConstant.SERVICEINFO.joinUrl);
	    }
	    if (_eventObjectDefine2['default'] && _eventObjectDefine2['default'].CoreController && _eventObjectDefine2['default'].CoreController.dispatchEvent) {
	        _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: "bindServiceinfoToTkConstant", message: { SERVICEINFO: TkConstant.SERVICEINFO } });
	    }
	};
	
	/*绑定房间信息到TkConstant*/
	TkConstant.joinRoomInfo = {};
	TkConstant.bindRoomInfoToTkConstant = function (joinRoomInfo) {
	    if (!joinRoomInfo) {
	        L.Logger.error('joinRoomInfo is not exist!');return;
	    };
	    L.Logger.debug('joinRoomInfo:', joinRoomInfo);
	    TkConstant.joinRoomInfo = joinRoomInfo;
	    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: "bindRoomInfoToTkConstant", message: { joinRoomInfo: TkConstant.joinRoomInfo } });
	};
	
	/*绑定当前登录对象事是否拥有指定角色到TkConstant
	 * @method bindParticipantRoleToHasRole
	 * @description  [TkConstant.joinRoomInfo:加入房间的信息 , ]*/
	TkConstant.hasRole = {};
	TkConstant.bindParticipantHasRoleToTkConstant = function () {
	    if (!TkConstant.joinRoomInfo) {
	        L.Logger.error('TkConstant.joinRoomInfo is not exist!');return;
	    };
	    Object.defineProperties(TkConstant.hasRole, {
	        //0：主讲  1：助教    2: 学员   3：直播用户 4:巡检员　10:系统管理员　11:企业管理员　12:管理员 , -1:回放者
	        roleChairman: {
	            value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomrole === TkConstant.role.roleChairman,
	            writable: false
	        },
	        roleTeachingAssistant: {
	            value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomrole === TkConstant.role.roleTeachingAssistant,
	            writable: false
	        },
	        roleStudent: {
	            value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomrole === TkConstant.role.roleStudent,
	            writable: false
	        },
	        roleAudit: {
	            value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomrole === TkConstant.role.roleAudit,
	            writable: false
	        },
	        rolePatrol: {
	            value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomrole === TkConstant.role.rolePatrol,
	            writable: false
	        },
	        rolePlayback: {
	            value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomrole === TkConstant.role.rolePlayback,
	            writable: false
	        }
	    });
	    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: "bindParticipantHasRoleToTkConstant", message: { hasRole: TkConstant.hasRole } });
	};
	
	/*绑定当前登录对象事是否拥有指定教室到TkConstant*/
	TkConstant.hasRoomtype = {};
	TkConstant.bindParticipantHasRoomtypeToTkConstant = function () {
	    if (!TkConstant.joinRoomInfo) {
	        L.Logger.error('TkConstant.joinRoomInfo is not exist!');return;
	    };
	    Object.defineProperties(TkConstant.hasRoomtype, {
	        //1：1 ， 1：6 ， 1：多 , 大讲堂（直播）
	        oneToOne: { //1对1
	            value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomtype === TkConstant.ROOMTYPE.oneToOne,
	            writable: false
	        }
	    });
	    /*  oneToSix: {//1对6
	          value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomtype === TkConstant.ROOMTYPE.oneToSix ,
	          writable: false,
	      },
	      oneToMore: { //1对多
	          value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomtype === TkConstant.ROOMTYPE.oneToMore ,
	          writable: false,
	      },
	      liveBroadcast: { // 大讲堂（直播）
	          value: TkConstant.joinRoomInfo && TkConstant.joinRoomInfo.roomtype === TkConstant.ROOMTYPE.liveBroadcast,
	          writable: false,
	      }*/
	    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: "bindParticipantHasRoomtypeToTkConstant", message: { hasRoomtype: TkConstant.hasRoomtype } });
	};
	window.TkConstant = TkConstant;
	exports['default'] = TkConstant;
	module.exports = exports['default'];

/***/ }),

/***/ 19:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 拓课工具类
	 * @module serviceTools
	 * @description   提供 系统所需要的工具
	 * @author QiuShao
	 * @date 2017/7/20
	 */
	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
	    value: true
	});
	
	var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; })();
	
	var tkUtils = {
	    /*所需工具*/
	    tool: {
	        /**启动全屏
	         @method launchFullscreen
	         @param {element} element 全屏元素
	         */
	        launchFullscreen: function launchFullscreen(element) {
	            if (element.requestFullscreen) {
	                element.requestFullscreen();
	            } else if (element.mozRequestFullScreen) {
	                element.mozRequestFullScreen();
	            } else if (element.webkitRequestFullscreen) {
	                element.webkitRequestFullscreen();
	            } else if (element.msRequestFullscreen) {
	                element.msRequestFullscreen();
	            }
	        },
	        /**退出全屏
	         @method exitFullscreen
	         */
	        exitFullscreen: function exitFullscreen() {
	            if (document.exitFullScreen) {
	                document.exitFullScreen();
	            } else if (document.mozCancelFullScreen) {
	                document.mozCancelFullScreen();
	            } else if (document.webkitExitFullscreen) {
	                document.webkitExitFullscreen();
	            } else if (element.msExitFullscreen) {
	                element.msExitFullscreen();
	            }
	        },
	        /*是否处于全屏状态
	         @method isFullScreenStatus
	         * */
	        isFullScreenStatus: function isFullScreenStatus(element) {
	            return document.fullscreen || document.mozFullScreen || document.webkitIsFullScreen || document.webkitFullScreen || document.msFullScreen || false;
	        },
	        /**返回正处于全屏状态的Element节点，如果当前没有节点处于全屏状态，则返回null。
	         @method getFullscreenElement
	         */
	        getFullscreenElement: function getFullscreenElement() {
	            var fullscreenElement = document.fullscreenElement || document.mozFullScreenElement || document.webkitFullscreenElement;
	            return fullscreenElement;
	        },
	        /**返回一个布尔值，表示当前文档是否可以切换到全屏状态
	         @method isFullscreenEnabled
	         */
	        isFullscreenEnabled: function isFullscreenEnabled() {
	            var fullscreenEnabled = document.fullscreenEnabled || document.mozFullScreenEnabled || document.webkitFullscreenEnabled || document.msFullscreenEnabled;
	            return fullscreenEnabled;
	        },
	        /*添加前缀---方法执行（如果是方法），又是属性判断（是否支持属性）
	         @method runPrefixMethod
	         TODO 暂时没有测试能否可用
	         */
	        runPrefixMethod: function runPrefixMethod(element, method) {
	            var usablePrefixMethod = undefined;
	            ["webkit", "moz", "ms", "o", ""].forEach(function (prefix) {
	                if (usablePrefixMethod) return;
	                if (prefix === "") {
	                    // 无前缀，方法首字母小写
	                    method = method.slice(0, 1).toLowerCase() + method.slice(1);
	                }
	
	                var typePrefixMethod = typeof element[prefix + method];
	
	                if (typePrefixMethod + "" !== "undefined") {
	                    if (typePrefixMethod === "function") {
	                        usablePrefixMethod = element[prefix + method]();
	                    } else {
	                        usablePrefixMethod = element[prefix + method];
	                    }
	                }
	            });
	
	            return usablePrefixMethod;
	        },
	        /**为全屏添加全屏事件fullscreenchange
	         @method addFullscreenchange
	         @param   {Function} handle 事件处理器
	         */
	        addFullscreenchange: function addFullscreenchange(handle) {
	            tkUtils.tool.addEvent(document, "fullscreenchange", handle, false);
	            tkUtils.tool.addEvent(document, "webkitfullscreenchange", handle, false);
	            tkUtils.tool.addEvent(document, "mozfullscreenchange", handle, false);
	            tkUtils.tool.addEvent(document, "MSFullscreenChange", handle, false);
	            tkUtils.tool.addEvent(document, "msfullscreenchange", handle, false);
	            tkUtils.tool.addEvent(document, "fullscreeneventchange", handle, false);
	        },
	        /**移除全屏添加全屏事件fullscreenchange
	         @method removeFullscreenchange
	         @param   {Function} handle 事件处理器
	         */
	        removeFullscreenchange: function removeFullscreenchange(handle) {
	            tkUtils.tool.removeEvent(document, "fullscreenchange", handle, false);
	            tkUtils.tool.removeEvent(document, "webkitfullscreenchange", handle, false);
	            tkUtils.tool.removeEvent(document, "mozfullscreenchange", handle, false);
	            tkUtils.tool.removeEvent(document, "MSFullscreenChange", handle, false);
	            tkUtils.tool.removeEvent(document, "msfullscreenchange", handle, false);
	            tkUtils.tool.removeEvent(document, "fullscreeneventchange", handle, false);
	        },
	        /**为全屏添加全屏事件fullscreenerror
	         @method addFullscreenerror
	         @param   {Function} handle 事件处理器
	         */
	        addFullscreenerror: function addFullscreenerror(handle) {
	            tkUtils.tool.addEvent(document, "fullscreenerror", handle, false);
	            tkUtils.tool.addEvent(document, "webkitfullscreenerror", handle, false);
	            tkUtils.tool.addEvent(document, "mozfullscreenerror", handle, false);
	            tkUtils.tool.addEvent(document, "MSFullscreenError", handle, false);
	            tkUtils.tool.addEvent(document, "msfullscreenerror", handle, false);
	            tkUtils.tool.addEvent(document, "fullscreenerroreventchange", handle, false);
	        },
	        /**移除全屏添加全屏事件fullscreenerror
	         @method removeFullscreenerror
	         @param   {Function} handle 事件处理器
	         */
	        removeFullscreenerror: function removeFullscreenerror(handle) {
	            tkUtils.tool.removeEvent(document, "fullscreenerror", handle, false);
	            tkUtils.tool.removeEvent(document, "webkitfullscreenerror", handle, false);
	            tkUtils.tool.removeEvent(document, "mozfullscreenerror", handle, false);
	            tkUtils.tool.removeEvent(document, "MSFullscreenError", handle, false);
	            tkUtils.tool.removeEvent(document, "msfullscreenerror", handle, false);
	            tkUtils.tool.removeEvent(document, "fullscreenerroreventchange", handle, false);
	        },
	        /**绑定事件
	         @method addEvent
	         @param   {element} element 添加事件元素
	         {string} eType 事件类型
	         {Function} handle 事件处理器
	         {Bollean} bol false 表示在事件第三阶段（冒泡）触发，true表示在事件第一阶段（捕获）触发。
	         */
	        addEvent: function addEvent(element, eType, handle, bol) {
	            /*$(element).on(eType , handle);*/
	            bol = bol != undefined && bol != null ? bol : false;
	            if (element.addEventListener) {
	                //如果支持addEventListener
	                element.addEventListener(eType, handle, bol);
	            } else if (element.attachEvent) {
	                //如果支持attachEvent
	                element.attachEvent("on" + eType, handle);
	            } else {
	                //否则使用兼容的onclick绑定
	                element["on" + eType] = handle;
	            }
	        },
	        /**事件解绑
	         @method addEvent
	         @param   {element} element 添加事件元素
	         {string} eType 事件类型
	         {Function} handle 事件处理器
	         {Bollean} bol false 表示在事件第三阶段（冒泡）触发，true表示在事件第一阶段（捕获）触发。
	         */
	        removeEvent: function removeEvent(element, eType, handle, bol) {
	            if (element.addEventListener) {
	                element.removeEventListener(eType, handle, bol);
	            } else if (element.attachEvent) {
	                element.detachEvent("on" + eType, handle);
	            } else {
	                element["on" + eType] = null;
	            }
	        },
	        /**自动元素定位--中间定位
	         @method autoElementPositionCneter
	         @param {element} $ele 定位元素
	         */
	        autoElementPositionCneter: function autoElementPositionCneter($ele) {
	            $ele.css({
	                "margin-left": -$ele.width() / 2 + "px",
	                "margin-top": -$ele.height() / 2 + "px"
	            });
	        },
	        /**清除元素定位--中间定位
	         @method clearElementPositionCneter
	         @param {element} $ele 定位元素
	         */
	        clearElementPositionCneter: function clearElementPositionCneter($ele) {
	            $ele.css({
	                "margin-left": "",
	                "margin-top": ""
	            });
	        }
	    },
	    getGUID: function getGUID() {
	        //获取GUID
	        function GUID() {
	            this.date = new Date(); /* 判断是否初始化过，如果初始化过以下代码，则以下代码将不再执行，实际中只执行一次 */
	            if (typeof this.newGUID != 'function') {
	                /* 生成GUID码 */
	                GUID.prototype.newGUID = function () {
	                    this.date = new Date();
	                    var guidStr = '';
	                    var sexadecimalDate = this.hexadecimal(this.getGUIDDate(), 16);
	                    var sexadecimalTime = this.hexadecimal(this.getGUIDTime(), 16);
	                    for (var i = 0; i < 9; i++) {
	                        guidStr += Math.floor(Math.random() * 16).toString(16);
	                    }
	                    guidStr += sexadecimalDate;
	                    guidStr += sexadecimalTime;
	                    while (guidStr.length < 32) {
	                        guidStr += Math.floor(Math.random() * 16).toString(16);
	                    }
	                    return this.formatGUID(guidStr);
	                };
	                /* * 功能：获取当前日期的GUID格式，即8位数的日期：19700101 * 返回值：返回GUID日期格式的字条串 */
	                GUID.prototype.getGUIDDate = function () {
	                    return this.date.getFullYear() + this.addZero(this.date.getMonth() + 1) + this.addZero(this.date.getDay());
	                };
	                /* * 功能：获取当前时间的GUID格式，即8位数的时间，包括毫秒，毫秒为2位数：12300933 * 返回值：返回GUID日期格式的字条串 */
	                GUID.prototype.getGUIDTime = function () {
	                    return this.addZero(this.date.getHours()) + this.addZero(this.date.getMinutes()) + this.addZero(this.date.getSeconds()) + this.addZero(parseInt(this.date.getMilliseconds() / 10));
	                };
	                /* * 功能: 为一位数的正整数前面添加0，如果是可以转成非NaN数字的字符串也可以实现 * 参数: 参数表示准备再前面添加0的数字或可以转换成数字的字符串 * 返回值: 如果符合条件，返回添加0后的字条串类型，否则返回自身的字符串 */
	                GUID.prototype.addZero = function (num) {
	                    if (Number(num).toString() != 'NaN' && num >= 0 && num < 10) {
	                        return '0' + Math.floor(num);
	                    } else {
	                        return num.toString();
	                    }
	                };
	                /*  * 功能：将y进制的数值，转换为x进制的数值 * 参数：第1个参数表示欲转换的数值；第2个参数表示欲转换的进制；第3个参数可选，表示当前的进制数，如不写则为10 * 返回值：返回转换后的字符串 */GUID.prototype.hexadecimal = function (num, x, y) {
	                    if (y != undefined) {
	                        return parseInt(num.toString(), y).toString(x);
	                    } else {
	                        return parseInt(num.toString()).toString(x);
	                    }
	                };
	                /* * 功能：格式化32位的字符串为GUID模式的字符串 * 参数：第1个参数表示32位的字符串 * 返回值：标准GUID格式的字符串 */
	                GUID.prototype.formatGUID = function (guidStr) {
	                    var str1 = guidStr.slice(0, 8) + '-',
	                        str2 = guidStr.slice(8, 12) + '-',
	                        str3 = guidStr.slice(12, 16) + '-',
	                        str4 = guidStr.slice(16, 20) + '-',
	                        str5 = guidStr.slice(20);
	                    return str1 + str2 + str3 + str4 + str5;
	                };
	            }
	        }
	        return new GUID();
	    },
	    getNewGUID: function getNewGUID() {
	        //获取初始化
	        if (!tkUtils.guidObj) {
	            tkUtils.guidObj = new tkUtils.getGUID();
	        }
	        var guid = tkUtils.guidObj.newGUID();
	        tkUtils.guidObj = null;
	        return guid;
	    },
	    getBrowserInfo: function getBrowserInfo() {
	        //获取浏览器基本信息
	        var userAgent = window.navigator.userAgent,
	            rMsie = /(msie\s|trident.*rv:)([\w.]+)/,
	            rFirefox = /(firefox)\/([\w.]+)/,
	            rOpera = /(opera).+version\/([\w.]+)/,
	            rChrome = /(chrome)\/([\w.]+)/,
	            rSafari = /version\/([\w.]+).*(safari)/;
	        var uaMatch = function uaMatch(ua) {
	            var match = rMsie.exec(ua);
	            if (match != null) {
	                return { browser: "IE", version: match[2] || "0" };
	            }
	            match = rFirefox.exec(ua);
	            if (match != null) {
	                return { browser: match[1] || "", version: match[2] || "0" };
	            }
	            match = rOpera.exec(ua);
	            if (match != null) {
	                return { browser: match[1] || "", version: match[2] || "0" };
	            }
	            match = rChrome.exec(ua);
	            if (match != null) {
	                return { browser: match[1] || "", version: match[2] || "0" };
	            }
	            match = rSafari.exec(ua);
	            if (match != null) {
	                return { browser: match[2] || "", version: match[1] || "0" };
	            }
	            if (match != null) {
	                return { browser: "", version: "0" };
	            } else {
	                return { browser: "unknown", version: "unknown" };
	            }
	        };
	        var browserMatch = uaMatch(userAgent.toLowerCase());
	        //判断访问终端
	        var browser = {
	            versions: (function () {
	                var u = navigator.userAgent,
	                    app = navigator.appVersion;
	                return {
	                    trident: u.indexOf('Trident') > -1, //IE内核
	                    presto: u.indexOf('Presto') > -1, //opera内核
	                    webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
	                    gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
	                    mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
	                    ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
	                    android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
	                    iPhone: u.indexOf('iPhone') > -1, //是否为iPhone或者QQHD浏览器
	                    iPad: u.indexOf('iPad') > -1, //是否iPad
	                    webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
	                };
	            })(),
	            language: (navigator.browserLanguage || navigator.language).toLowerCase(),
	            info: {
	                browserName: browserMatch.browser, //浏览器使用的版本名字
	                browserVersion: browserMatch.version, //浏览器使用的版本号
	                appCodeName: navigator.appCodeName, //返回浏览器的代码名。
	                appMinorVersion: navigator.appMinorVersion, //返回浏览器的次级版本。
	                appName: navigator.appName, //返回浏览器的名称。
	                appVersion: navigator.appVersion, //	返回浏览器的平台和版本信息。
	                browserLanguage: navigator.browserLanguage, //	返回当前浏览器的语言。
	                cookieEnabled: navigator.cookieEnabled, //	返回指明浏览器中是否启用 cookie 的布尔值。
	                cpuClass: navigator.cpuClass, //	返回浏览器系统的 CPU 等级。
	                onLine: navigator.onLine, //	返回指明系统是否处于脱机模式的布尔值。
	                platform: navigator.platform, //	返回运行浏览器的操作系统平台。
	                systemLanguage: navigator.systemLanguage, //返回 OS 使用的默认语言。
	                userAgent: navigator.userAgent, //返回由客户机发送服务器的 user-agent 头部的值。
	                userLanguage: navigator.userLanguage }
	        };
	        //	返回 OS 的自然语言设置。
	        return browser;
	    },
	    isEmpty: function isEmpty(obj) {
	        var keys = Object.keys(obj);
	        return keys.length === 0;
	    },
	    getUrlParams: function getUrlParams(key, url) {
	        /*charCodeAt()：返回指定位置的字符的 Unicode 编码。这个返回值是 0 - 65535 之间的整数。
	         fromCharCode()：接受一个指定的 Unicode 值，然后返回一个字符串。
	         encodeURIComponent()：把字符串作为 URI 组件进行编码。
	         decodeURIComponent()：对 encodeURIComponent() 函数编码的 URI 进行解码。*/
	        var href = window.location.href;
	        if (window.TkConstant) {
	            href = tkUtils.decrypt(window.TkConstant.SERVICEINFO.joinUrl) || window.location.href;
	        }
	        href = url || href;
	        // let urlAdd = decodeURI(href);
	        var urlAdd = decodeURIComponent(href);
	        var urlIndex = urlAdd.indexOf("?");
	        var urlSearch = urlAdd.substring(urlIndex + 1);
	        var reg = new RegExp("(^|&)" + key + "=([^&]*)(&|$)", "i"); //reg表示匹配出:$+url传参数名字=值+$,并且$可以不存在，这样会返回一个数组
	        var arr = urlSearch.match(reg);
	        if (arr != null) {
	            return arr[2];
	        } else {
	            return "";
	        }
	    },
	    /*字符串第一个首字母转大写
	     * @method replaceFirstUper
	     * @params [str:string]*/
	    replaceFirstUper: function replaceFirstUper(str) {
	        if (str.length > 0) {
	            var tmpChar = str.substring(0, 1).toUpperCase();
	            var postString = str.substring(1);
	            var tmpStr = tmpChar + postString;
	            return tmpStr;
	        } else {
	            str;
	        }
	    },
	    /*判断是否是数组
	     * @method isArray
	     * @params [object:any]*/
	    isArray: function isArray(object) {
	        return Array && Array.isArray && typeof Array.isArray === 'function' ? Array.isArray(object) : object && typeof object === 'object' && typeof object.length === 'number' && typeof object.splice === 'function' &&
	        //判断length属性是否是可枚举的 对于数组 将得到false
	        !object.propertyIsEnumerable('length');
	    },
	    /*过滤包含以data-开头的属性
	     * @method filterContainDataAttribute */
	    filterContainDataAttribute: function filterContainDataAttribute(attributeObj) {
	        var that = tkUtils;
	        if (attributeObj && !that.isArray(attributeObj) && typeof attributeObj === "object") {
	            var tmpAttributeObj = {};
	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;
	
	            try {
	                for (var _iterator = Object.entries(attributeObj)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var _step$value = _slicedToArray(_step.value, 2);
	
	                    var key = _step$value[0];
	                    var value = _step$value[1];
	
	                    if (/^data-/g.test(key)) {
	                        tmpAttributeObj[key] = value;
	                    }
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator["return"]) {
	                        _iterator["return"]();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }
	
	            return tmpAttributeObj;
	        } else {
	            return attributeObj;
	        }
	    },
	    /*根据文件后缀名判断属于什么文件类型*/
	    getFiletyeByFilesuffix: function getFiletyeByFilesuffix(filesuffix) {
	
	        var filetype = undefined;
	        if (filesuffix == "jpg" || filesuffix == "jpeg" || filesuffix == "png" || filesuffix == "gif" || filesuffix == "ico" || filesuffix == "bmp") {
	            filetype = "jpg"; //图片
	        } else if (filesuffix == "doc" || filesuffix == "docx" || filesuffix == "rtf") {
	                filetype = "doc"; //文档
	            } else if (filesuffix == "pdf") {
	                    filetype = "pdf"; //pdf
	                } else if (filesuffix == "ppt" || filesuffix == "pptx" || filesuffix == "pps") {
	                        filetype = "ppt"; //ppt
	                    } else if (filesuffix == "txt") {
	                            filetype = "txt"; //txt
	                        } else if (filesuffix == "xls" || filesuffix == "xlsx") {
	                                filetype = "xlsx"; //xlsx
	                            } else if (filesuffix == "mp4" || filesuffix == "webm") {
	                                    //video:.mp4  , .webm
	                                    filetype = "mp4";
	                                } else if (filesuffix == "mp3" || filesuffix == "wav") {
	                                    //audio:.mp3 , .wav , .ogg
	                                    filetype = "mp3";
	                                } else if (filesuffix == "zip") {
	                                    //h5
	                                    filetype = "h5";
	                                } else if (filesuffix === "whiteboard") {
	                                    filetype = "whiteboard";
	                                } else {
	                                    filetype = "other";
	                                }
	        return filetype; //jpg、doc、pdf、ppt、txt、xlsx、mp4、mp3、other
	    },
	    /*是否是函数*/
	    isFunction: function isFunction(callback) {
	        return callback && typeof callback === 'function';
	    },
	    /*从用户中获取用户的自定义属性*/
	    getCustomUserPropertyByUser: function getCustomUserPropertyByUser(user) {
	        var customUserproperty = {
	            disableaudio: user.disableaudio,
	            disablevideo: user.disablevideo,
	            giftnumber: user.giftnumber,
	            hasaudio: user.hasaudio,
	            hasvideo: user.hasvideo,
	            publishstate: user.publishstate,
	            raisehand: user.raisehand
	        };
	        return customUserproperty;
	    },
	    /*计算时间差，转为hh,mm,ss*/
	    getTimeDifferenceToFormat: function getTimeDifferenceToFormat(start, end) {
	        var difference = end - start; //时间差的毫秒数
	        if (difference >= 0) {
	            //计算出相差天数
	            var days = Math.floor(difference / (24 * 3600 * 1000));
	            //计算出小时数
	            var leave1 = difference % (24 * 3600 * 1000); //计算天数后剩余的毫秒数
	            var hours = Math.floor(leave1 / (3600 * 1000));
	            //计算相差分钟数
	            var leave2 = leave1 % (3600 * 1000); //计算小时数后剩余的毫秒数
	            var minutes = Math.floor(leave2 / (60 * 1000));
	            //计算相差秒数
	            var leave3 = leave2 % (60 * 1000); //计算分钟数后剩余的毫秒数
	            var seconds = Math.round(leave3 / 1000);
	            var daysAddHour = hours + days * 24; //加上天数的小时数
	            var clock = {};
	            if (seconds >= 60) {
	                seconds = 0;
	                minutes += 1;
	            }
	            if (minutes >= 60) {
	                minutes = 0;
	                daysAddHour += 1;
	            }
	            clock.hh = daysAddHour > 9 ? daysAddHour : '0' + daysAddHour;
	            clock.mm = minutes > 9 ? minutes : '0' + minutes;
	            clock.ss = seconds > 9 ? seconds : '0' + seconds;
	            return clock;
	        } else {
	            L.Logger.error('Start time is greater than end time [start:' + start + '  , end:' + end + ']!');
	            return undefined;
	        }
	    },
	    /*判断时间是秒级还是毫秒级 ,true:毫秒级 ， false:秒级 , undefined:传入的时间不正确 */
	    isMillisecondClass: function isMillisecondClass(time) {
	        if (typeof time !== 'number') {
	            L.Logger.error('time must is number!');return;
	        };
	        time = String(time);
	        var length = time.length;
	        if (length === 13) {
	            return true; //毫秒级
	        } else if (length === 10) {
	                return false; //秒级
	            } else {
	                    L.Logger.warning('The incoming time is incorrect and cannot be judged to be second or second!');
	                    return undefined;
	                }
	    },
	    /**
	     * 加密函数
	     * @param str 待加密字符串
	     * @returns {string}
	     */
	    encrypt: function encrypt(str, encryptRandom) {
	        if (!str) {
	            return str;
	        }
	        if (window.TkConstant) {
	            if (window.TkConstant.DEV) {
	                //开发模式
	                return str;
	            }
	        } else {
	            var DEV = false;
	            try {
	                DEV = (true);
	            } catch (e) {
	                L.Logger.warning('There is no configuration dev mark[__DEV__]!');
	            }
	            if (DEV || tkUtils.getUrlParams('debug')) {
	                //开发模式
	                return str;
	            }
	        }
	        return L.Utils.encrypt(str, encryptRandom);
	    },
	    /**
	     * 解密函数
	     * @param str 待解密字符串
	     * @returns {string}*/
	    decrypt: function decrypt(str, encryptRandom) {
	        if (!str) {
	            return str;
	        }
	        if (window.TkConstant) {
	            if (window.TkConstant.DEV) {
	                //开发模式
	                return str;
	            }
	        } else {
	            var DEV = false;
	            try {
	                DEV = (true);
	            } catch (e) {
	                L.Logger.warning('There is no configuration dev mark[__DEV__]!');
	            }
	            DEV = false;
	            if (DEV || tkUtils.getUrlParams('debug')) {
	                //开发模式
	                return str;
	            }
	        }
	        return L.Utils.decrypt(str, encryptRandom);
	    },
	    /*返回操作系统*/
	    detectOS: function detectOS() {
	        var sUserAgent = navigator.userAgent;
	        var isWin = navigator.platform === "Win32" || navigator.platform === "Windows";
	        var isMac = navigator.platform === "Mac68K" || navigator.platform === "MacPPC" || navigator.platform === "Macintosh" || navigator.platform === "MacIntel";
	        if (isMac) return "Mac";
	        var isUnix = navigator.platform === "X11" && !isWin && !isMac;
	        if (isUnix) return "Unix";
	        var isLinux = String(navigator.platform).indexOf("Linux") > -1;
	        if (isLinux) return "Linux";
	        if (isWin) {
	            var isWin2K = sUserAgent.indexOf("Windows NT 5.0") > -1 || sUserAgent.indexOf("Windows 2000") > -1;
	            if (isWin2K) return "Win2000";
	            var isWinXP = sUserAgent.indexOf("Windows NT 5.1") > -1 || sUserAgent.indexOf("Windows XP") > -1;
	            if (isWinXP) return "WinXP";
	            var isWin2003 = sUserAgent.indexOf("Windows NT 5.2") > -1 || sUserAgent.indexOf("Windows 2003") > -1;
	            if (isWin2003) return "Win2003";
	            var isWinVista = sUserAgent.indexOf("Windows NT 6.0") > -1 || sUserAgent.indexOf("Windows Vista") > -1;
	            if (isWinVista) return "WinVista";
	            var isWin7 = sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 7") > -1;
	            if (isWin7) return "Win7";
	            var isWin8 = sUserAgent.indexOf("Windows NT 6.2") > -1 || sUserAgent.indexOf("Windows 8") > -1;
	            if (isWin8) return "Win8";
	            var isWin10 = sUserAgent.indexOf("Windows NT 10.0") > -1 || sUserAgent.indexOf("Windows 10") > -1;
	            if (isWin10) return "Win10";
	        }
	        return "Other";
	    },
	    /*网速检测*/
	    internetSpeedTest: function internetSpeedTest() {},
	    /*获取白板区工具相对白板的位置rem(拖拽后将相对白板的百分比转为rem使用)*/
	    percentageChangeToRem: function percentageChangeToRem(that, percentLeft, percentTop, dragEleId) {
	        var defalutFontSize = window.innerWidth / TkConstant.STANDARDSIZE;
	        //获取拖拽的元素宽高：
	        var dragEle = document.getElementById(dragEleId); //拖拽的元素
	        var dragEleW = dragEle.clientWidth;
	        var dragEleH = dragEle.clientHeight;
	        //获取白板区域宽高：
	        var boundsEle = document.getElementById('tk_app');
	        var boundsEleW = boundsEle.clientWidth;
	        var boundsEleH = boundsEle.clientHeight;
	        //计算白板区工具相对白板的位置：
	        that.state[dragEleId].left = percentLeft * (boundsEleW - dragEleW) / defalutFontSize;
	        that.state[dragEleId].top = percentTop * (boundsEleH - dragEleH) / defalutFontSize;
	        return that.state[dragEleId];
	    },
	    /*获取白板区工具相对白板的位置%(拖拽后将相对白板的rem转为百分比使用)*/
	    RemChangeToPercentage: function RemChangeToPercentage(that, left, top, dragEleId) {
	        //获取白板区工具相对白板的位置
	        var defalutFontSize = window.innerWidth / TkConstant.STANDARDSIZE;
	        //获取拖拽的元素宽高：
	        var dragEle = document.getElementById(dragEleId); //拖拽的元素
	        var dragEleW = dragEle.clientWidth;
	        var dragEleH = dragEle.clientHeight;
	        //获取白板区域宽高：
	        var boundsEle = document.getElementById('tk_app');
	        var boundsEleW = boundsEle.clientWidth;
	        var boundsEleH = boundsEle.clientHeight;
	        //计算白板区工具相对白板的位置：
	        var percentLeft = left / (boundsEleW - dragEleW) * defalutFontSize;
	        var percentTop = top / (boundsEleH - dragEleH) * defalutFontSize;
	        return { percentLeft: percentLeft, percentTop: percentTop };
	    },
	    /*控制拖拽的范围*/
	    controlDragBounds: function controlDragBounds(that, dragEleId, boundsEleId) {
	        var defalutFontSize = window.innerWidth / TkConstant.STANDARDSIZE;
	        var dragEle = document.getElementById(dragEleId); //拖拽的元素
	        var dragEleW = dragEle.clientWidth / defalutFontSize;
	        var dragEleH = dragEle.clientHeight / defalutFontSize;
	        var boundsEle = document.getElementById(boundsEleId); //白板拖拽区域
	        var boundsEleW = boundsEle.clientWidth / defalutFontSize;
	        var boundsEleH = boundsEle.clientHeight / defalutFontSize;
	        that.state[dragEleId].left = that.state[dragEleId].left < 0 ? that.state[dragEleId].left = 0 : that.state[dragEleId].left;
	        that.state[dragEleId].left = that.state[dragEleId].left > boundsEleW - dragEleW ? boundsEleW - dragEleW : that.state[dragEleId].left;
	        that.state[dragEleId].top = that.state[dragEleId].top < 0 ? that.state[dragEleId].top = 0 : that.state[dragEleId].top;
	        that.state[dragEleId].top = that.state[dragEleId].top > boundsEleH - dragEleH ? boundsEleH - dragEleH : that.state[dragEleId].top;
	        return that.state[dragEleId];
	    }
	};
	exports["default"] = tkUtils;
	module.exports = exports["default"];

/***/ }),

/***/ 20:
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {/**
	 * UI-总控制中心
	 * @module CoreController
	 * @description  用于控制页面组件的通信
	 * @author QiuShao
	 * @date 2017/7/5
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _RoomHandler = __webpack_require__(275);
	
	var _RoomHandler2 = _interopRequireDefault(_RoomHandler);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _TkAppPermissions = __webpack_require__(122);
	
	var _TkAppPermissions2 = _interopRequireDefault(_TkAppPermissions);
	
	var _ServiceTools = __webpack_require__(120);
	
	var _ServiceTools2 = _interopRequireDefault(_ServiceTools);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var coreController = TK.EventDispatcher({});
	_eventObjectDefine2['default'].CoreController = coreController;
	coreController.handler = {};
	/*加载系统所需的信息
	* @method loadSystemRequiredInfo*/
	coreController.handler.loadSystemRequiredInfo = function () {
	    /*禁止浏览器右键*/
	    document.oncontextmenu = null;
	    document.oncontextmenu = function () {
	        return false;
	    };
	
	    window.onbeforeunload = null;
	    window.onbeforeunload = function () {//onbeforeunload 事件在即将离开当前页面（刷新或关闭）时触发
	
	    };
	
	    /*todo 禁止选中文字（暂时去掉）*/
	    /*  $(document).off("selectstart");
	      $(document).bind("selectstart", function () { return true; });*/
	
	    if (TK.tkLogPrintConfig) {
	        //DEBUG = 0, TRACE = 1, INFO = 2, WARNING = 3, ERROR = 4, NONE = 5,
	        if (_TkConstant2['default'].DEV) {
	            //开发模式
	            var socketLogConfig = {
	                debug: true
	            },
	                loggerConfig = {
	                development: true,
	                logLevel: _TkConstant2['default'].LOGLEVEL.DEBUG
	            },
	                adpConfig = {
	                webrtcLogDebug: true
	            };
	            TK.tkLogPrintConfig(socketLogConfig, loggerConfig, adpConfig);
	        } else {
	            //发布模式
	            var socketLogConfig = {
	                debug: false
	            },
	                loggerConfig = {
	                development: false,
	                logLevel: _TkConstant2['default'].LOGLEVEL.INFO
	            },
	                adpConfig = {
	                webrtcLogDebug: false
	            };
	            TK.tkLogPrintConfig(socketLogConfig, loggerConfig, adpConfig);
	        }
	    }
	
	    _ServiceTools2['default'].getAppLanguageInfo(function (languageInfo) {
	        //加载语言包
	        _TkGlobal2['default'].language = languageInfo;
	    });
	    //handlerCoreController.setPageStyleByDomain();//根据公司domain决定加载的页面样式布局*
	
	    _ServiceRoom2['default'].setTkRoom(TK.Room());
	    _RoomHandler2['default'].registerEventToRoom();
	};
	
	/*核心控制器操控系统权限-更新和获取以及初始化权限*/
	coreController.handler.setAppPermissions = function (appPermissionsKey, appPermissionsValue) {
	    _TkAppPermissions2['default'].setAppPermissions(appPermissionsKey, appPermissionsValue);
	};
	coreController.handler.getAppPermissions = function (appPermissionsKey) {
	    return _TkAppPermissions2['default'].getAppPermissions(appPermissionsKey);
	};
	coreController.handler.initAppPermissions = function (initAppPermissionsJson) {
	    _TkAppPermissions2['default'].initAppPermissions(initAppPermissionsJson);
	};
	
	coreController.handler.addEventListenerOnCoreController = function () {
	    $(window).off("resize");
	    $(window).resize(function () {
	        //窗口resize事件监听
	        var defalutFontSize = window.innerWidth / _TkConstant2['default'].STANDARDSIZE; //5rem = defalutFontSize*'5px' ;
	        var rootElement = document.getElementById('all_root') || document.getElementsByTagName('html');
	        if (rootElement) {
	            var rootEle = _TkUtils2['default'].isArray(rootElement) ? rootElement[0] : rootElement;
	            if (rootEle && rootEle.style) {
	                rootEle.style.fontSize = defalutFontSize + 'px';
	            }
	        }
	        _eventObjectDefine2['default'].Window.dispatchEvent({ type: _TkConstant2['default'].EVENTTYPE.WindowEvent.onResize, message: { defalutFontSize: defalutFontSize } });
	    });
	    $(window).resize();
	
	    /*接收IFrame框架的消息*/
	    var _eventHandler_windowMessage = function _eventHandler_windowMessage(event) {
	        _eventObjectDefine2['default'].Window.dispatchEvent({ type: _TkConstant2['default'].EVENTTYPE.WindowEvent.onMessage, message: { event: event } });
	    };
	    _TkUtils2['default'].tool.removeEvent(window, 'message', _eventHandler_windowMessage);
	    _TkUtils2['default'].tool.addEvent(window, 'message', _eventHandler_windowMessage, false); //给当前window建立message监听函数
	
	    $(document).off("keydown");
	    $(document).keydown(function (event) {
	        event = event || window.event;
	        _eventObjectDefine2['default'].Document.dispatchEvent({ type: _TkConstant2['default'].EVENTTYPE.DocumentEvent.onKeydown, message: { keyCode: event.keyCode } });
	    });
	
	    var _eventHandler_addFullscreenchange = function _eventHandler_addFullscreenchange(event) {
	        _eventObjectDefine2['default'].Document.dispatchEvent({ type: _TkConstant2['default'].EVENTTYPE.DocumentEvent.onFullscreenchange, message: { event: event } });
	    };
	    _TkUtils2['default'].tool.removeFullscreenchange(_eventHandler_addFullscreenchange);
	    _TkUtils2['default'].tool.addFullscreenchange(_eventHandler_addFullscreenchange);
	
	    if (TK.SDKTYPE === 'mobile') {
	        coreController.handler.addEventfRromMobileUICoreEventManager();
	    }
	};
	coreController.handler.addEventfRromMobileUICoreEventManager = function () {
	    if (TK.SDKTYPE === 'mobile') {
	        TK.mobileUICoreEventManager.addEventListener('mobileSdk_closeDynamicPptWebPlay', function (recvEventData) {
	            //关闭动态PPTweb页的自动播放
	            _eventObjectDefine2['default'].CoreController.dispatchEvent(recvEventData);
	        });
	        TK.mobileUICoreEventManager.addEventListener('mobileSdk_setInitPageParameterFormPhone', function (recvEventData) {
	            var initJson = recvEventData.message;
	            if (initJson.deviceType !== undefined) {
	                _TkGlobal2['default'].mobileDeviceType = TK.global.initPageParameterFormPhone.deviceType === 0 ? 'phone' : 'pad';
	            }
	            _TkConstant2['default'].bindServiceinfoToTkConstant(undefined, undefined, undefined, true); //绑定服务器地址信息到TkConstant
	        });
	        TK.mobileUICoreEventManager.addEventListener('mobileSdk_changeInitPageParameterFormPhone', function (recvEventData) {
	            var changeInitJson = recvEventData.message;
	            Log.error('mobileSdk_changeInitPageParameterFormPhone', changeInitJson);
	            if (changeInitJson.deviceType !== undefined) {
	                _TkGlobal2['default'].mobileDeviceType = TK.global.initPageParameterFormPhone.deviceType === 0 ? 'phone' : 'pad';
	            }
	            if (changeInitJson.serviceUrl !== undefined) {
	                _TkConstant2['default'].bindServiceinfoToTkConstant(undefined, undefined, undefined, false);
	            }
	        });
	        TK.mobileUICoreEventManager.addEventListener('mobileSdk_fullScreenChangeCallback', function (recvEventData) {
	            //页面全屏的回调通知
	            _eventObjectDefine2['default'].CoreController.dispatchEvent(recvEventData);
	        });
	        TK.mobileUICoreEventManager.addEventListener('mobileSdk_changeDynamicPptSize', function (recvEventData) {
	            //改变动态PPT大小的回调通知
	            _eventObjectDefine2['default'].CoreController.dispatchEvent(recvEventData);
	        });
	    }
	};
	coreController.handler.addEventListenerOnCoreController();
	
	exports['default'] = coreController;
	module.exports = exports['default'];
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(41)))

/***/ }),

/***/ 22:
/***/ (function(module, exports) {

	/**
	 * 房间服务
	 * @module ServiceRoom
	 * @description  提供 房间相关的服务
	 * @author QiuShao
	 * @date 2017/08/07
	 */
	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	    value: true
	});
	var ServiceRoom = function ServiceRoom() {
	    var tkRoom = undefined;
	    var roomName = undefined;
	    var userName = undefined;
	    var localStream = undefined;
	    var userThirdid = undefined;
	
	    this.getTkRoom = function () {
	        return tkRoom;
	    };
	
	    this.getRoomName = function () {
	        return roomName;
	    };
	
	    this.setTkRoom = function (value) {
	        tkRoom = value;
	    };
	
	    this.setRoomName = function (value) {
	        roomName = value;
	    };
	
	    this.getLocalStream = function () {
	        return localStream;
	    };
	
	    this.setLocalStream = function (value) {
	        localStream = value;
	    };
	
	    this.getUserName = function () {
	        return userName;
	    };
	
	    this.setUserName = function (value) {
	        userName = value;
	    };
	
	    this.getUserThirdid = function () {
	        return userThirdid;
	    };
	
	    this.setUserThirdid = function (value) {
	        userThirdid = value;
	    };
	
	    this.clearAll = function () {
	        tkRoom = null;
	        roomName = null;
	        userName = null;
	        localStream = null;
	        userThirdid = null;
	    };
	};
	exports["default"] = new ServiceRoom();
	module.exports = exports["default"];

/***/ }),

/***/ 25:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 信令服务
	 * @module ServiceSignalling
	 * @description  提供 信令相关的功能服务
	 * @author QiuShao
	 * @date 2017/08/12
	 */
	'use strict';
	
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x6, _x7, _x8) { var _again = true; _function: while (_again) { var object = _x6, property = _x7, receiver = _x8; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x6 = parent; _x7 = property; _x8 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _SignallingInterface2 = __webpack_require__(272);
	
	var _SignallingInterface3 = _interopRequireDefault(_SignallingInterface2);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var ServiceSignalling = (function (_SignallingInterface) {
	    _inherits(ServiceSignalling, _SignallingInterface);
	
	    function ServiceSignalling() {
	        _classCallCheck(this, ServiceSignalling);
	
	        _get(Object.getPrototypeOf(ServiceSignalling.prototype), 'constructor', this).call(this);
	    }
	
	    /* method sendSignallingFromUpdateTime */
	
	    _createClass(ServiceSignalling, [{
	        key: 'sendSignallingFromUpdateTime',
	        value: function sendSignallingFromUpdateTime(toParticipantID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromUpdateTime')) {
	                return;
	            };
	            var that = this;
	            var isDelMsg = false,
	                id = "UpdateTime",
	                toID = toParticipantID || "__all",
	                data = {},
	                signallingName = "UpdateTime",
	                do_not_save = true;
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, do_not_save);
	        }
	    }, {
	        key: 'sendSignallingFromSharpsChange',
	
	        /*发送白板数据相关的信令SharpsChange
	         *@method  sendSignallingFromSharpsChange */
	        value: function sendSignallingFromSharpsChange(isDelMsg, signallingName, id, toID, data, do_not_save, expiresabs, associatedMsgID, associatedUserID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromSharpsChange')) {
	                return;
	            };
	            var that = this;
	            if (isDelMsg) {
	                do_not_save = true;
	            }
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, do_not_save, expiresabs, associatedMsgID, associatedUserID);
	        }
	
	        /*发送白板加页相关的信令WBPageCount
	        * @method sendSignallingFromWBPageCount */
	    }, {
	        key: 'sendSignallingFromWBPageCount',
	        value: function sendSignallingFromWBPageCount(data) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromWBPageCount')) {
	                return;
	            };
	            var that = this;
	            var signallingName = "WBPageCount";
	            var id = "WBPageCount";
	            var dot_not_save = undefined;
	            var isDelMsg = false;
	            var toID = "__allExceptSender";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, dot_not_save);
	        }
	    }, {
	        key: 'sendSignallingFromShowPage',
	
	        /*发送ShowPage相关的信令
	        *@method sendSignallingFromShowPage */
	        value: function sendSignallingFromShowPage(isDelMsg, id, data) {
	            var toID = arguments.length <= 3 || arguments[3] === undefined ? '__allExceptSender' : arguments[3];
	
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromShowPage')) {
	                return;
	            };
	            if (!data) {
	                L.Logger.error('sendSignallingFromShowPage data is not exist!');
	                return;
	            }
	            if (data && typeof data === 'string') {
	                data = JSON.parse(data);
	            }
	            if (data.isDynamicPPT && !_CoreController2['default'].handler.getAppPermissions('sendSignallingFromDynamicPptShowPage')) {
	                return;
	            }
	            if (data.isH5Document && !_CoreController2['default'].handler.getAppPermissions('sendSignallingFromH5ShowPage')) {
	                return;
	            }
	            if (data.isGeneralFile && !_CoreController2['default'].handler.getAppPermissions('sendSignallingFromGeneralShowPage')) {
	                return;
	            }
	            var that = this;
	            var signallingName = "ShowPage";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data);
	        }
	    }, {
	        key: 'sendSignallingFromDynamicPptTriggerActionClick',
	
	        /*发送动态PPT触发器NewPptTriggerActionClick相关的信令
	        * @method */
	        value: function sendSignallingFromDynamicPptTriggerActionClick(data) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromDynamicPptTriggerActionClick')) {
	                return;
	            };
	            var that = this;
	            var signallingName = "NewPptTriggerActionClick",
	                id = "NewPptTriggerActionClick",
	                toID = "__allExceptSender",
	                isDelMsg = false,
	                dot_not_save = false;
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, dot_not_save);
	        }
	    }, {
	        key: 'sendSignallingFromH5DocumentAction',
	
	        /*h5文档的动作相关信令*/
	        value: function sendSignallingFromH5DocumentAction(data) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromH5DocumentAction')) {
	                return;
	            };
	            var that = this;
	            var signallingName = "H5DocumentAction",
	                id = "H5DocumentAction",
	                toID = "__allExceptSender",
	                isDelMsg = false,
	                dot_not_save = false;
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, dot_not_save);
	        }
	    }, {
	        key: 'sendSignallingFromVideoDraghandle',
	
	        /*拖拽的动作相关信令*/
	        value: function sendSignallingFromVideoDraghandle(data, toID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromVideoDraghandle')) {
	                return;
	            };
	            var that = this;
	            var signallingName = "videoDraghandle",
	                id = "videoDraghandle",
	                isDelMsg = false,
	                dot_not_save = false;
	            toID = toID || "__allExceptSender";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, dot_not_save);
	        }
	    }, {
	        key: 'sendMarkToolMouseIsSelect',
	
	        /*鼠标状态是否选中*/
	        value: function sendMarkToolMouseIsSelect(selectMouse, selectElementLiId, selectElementId) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendWhiteboardMarkTool')) {
	                return;
	            };
	            var that = this;
	            var data = { selectMouse: selectMouse };
	            if (selectElementLiId) {
	                data.selectElementLiId = selectElementLiId;
	            }
	            if (selectElementId) {
	                data.selectElementId = selectElementId;
	            }
	            var signallingName = "whiteboardMarkTool",
	                id = "whiteboardMarkTool",
	                toID = "__allExceptSender",
	                isDelMsg = false;
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data);
	        }
	    }, {
	        key: 'sendSignallingFromBlackBoard',
	
	        /*发送多黑板信令*/
	        value: function sendSignallingFromBlackBoard(data) {
	            var isDelMsg = arguments.length <= 1 || arguments[1] === undefined ? false : arguments[1];
	
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromBlackBoard')) {
	                return;
	            };
	            var signallingName = "BlackBoard",
	                id = "BlackBoard",
	                toID = "__all";
	            this.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data);
	        }
	    }, {
	        key: 'sendSignallingTimerToStudent',
	
	        /*老师端教学组件倒计时的发送到学生端的信令*/
	        value: function sendSignallingTimerToStudent(data) {
	            var isDelMsg = arguments.length <= 1 || arguments[1] === undefined ? false : arguments[1];
	
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingTimerToStudent')) {
	                return false;
	            };
	            var that = this;
	            var id = "timerMesg",
	                signallingName = "timer",
	                toID = "__all";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data);
	        }
	    }, {
	        key: 'sendSignallingFromBlackBoardDrag',
	
	        /*小黑板拖拽的动作相关信令*/
	        value: function sendSignallingFromBlackBoardDrag(data, toID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromBlackBoardDrag')) {
	                return;
	            };
	            var that = this;
	            var signallingName = "BlackBoardDrag",
	                id = "BlackBoardDrag",
	                isDelMsg = false,
	                dot_not_save = false,
	                associatedMsgID = "BlackBoard";
	            toID = toID || "__allExceptSender";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, dot_not_save, undefined, associatedMsgID);
	        }
	    }, {
	        key: 'sendSignallingDialToStudent',
	
	        /*老师助教端转盘组件的发送到学生端的信令*/
	        value: function sendSignallingDialToStudent(data) {
	            var isDelMsg = arguments.length <= 1 || arguments[1] === undefined ? false : arguments[1];
	
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingDialToStudent')) {
	                return;
	            };
	            var signallingName = "dial",
	                id = "dialMesg",
	                toID = "__all";
	            this.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data);
	        }
	    }, {
	        key: 'sendSignallingAnswerToStudent',
	
	        /*老师答题卡发送信令*/
	        value: function sendSignallingAnswerToStudent(data) {
	            var isDelMsg = arguments.length <= 1 || arguments[1] === undefined ? false : arguments[1];
	
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingAnswerToStudent')) {
	                return false;
	            };
	            var that = this;
	            var id = "answerMesg",
	                signallingName = "answer",
	                toID = "__all";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data);
	        }
	    }, {
	        key: 'sendSignallingDataStudentToTeacherAnswer',
	
	        /*学生提交答案*/
	        value: function sendSignallingDataStudentToTeacherAnswer(isDelMsg, data) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingDataStudentToTeacherAnswer')) {
	                return false;
	            };
	            var that = this;
	            var signallingName = "submitAnswers",
	                toID = "__all",
	                associatedMsgID = "answerMesg";
	            var id = "submitAnswers_" + _ServiceRoom2['default'].getTkRoom().getMySelf().id;
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, undefined, undefined, associatedMsgID);
	        }
	    }, {
	        key: 'sendSignallingQiangDaQi',
	
	        /*抢答器*/
	        value: function sendSignallingQiangDaQi(isDelMsg, data) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingQiangDaQi')) {
	                return false;
	            };
	            var that = this;
	            var signallingName = "qiangDaQi",
	                toID = "__all",
	                id = "qiangDaQiMesg";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data);
	        }
	    }, {
	        key: 'sendSignallingQiangDaZhe',
	
	        /*抢答者*/
	        value: function sendSignallingQiangDaZhe(isDelMsg, data) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingQiangDaZhe')) {
	                return false;
	            };
	            var that = this;
	            var signallingName = "QiangDaZhe",
	                toID = "__all",
	                associatedMsgID = "qiangDaQiMesg";
	            var id = "QiangDaZhe_" + _ServiceRoom2['default'].getTkRoom().getMySelf().id;
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, undefined, undefined, associatedMsgID);
	        }
	    }, {
	        key: 'sendSignallingFromDialDrag',
	
	        /*转盘拖拽的动作相关信令*/
	        value: function sendSignallingFromDialDrag(data, toID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromDialDrag')) {
	                return;
	            };
	            var that = this;
	            var signallingName = "DialDrag",
	                id = "DialDrag",
	                isDelMsg = false,
	                dot_not_save = false,
	                associatedMsgID = "dialMesg";
	            toID = toID || "__allExceptSender";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, dot_not_save, undefined, associatedMsgID);
	        }
	    }, {
	        key: 'sendSignallingFromResponderDrag',
	
	        /*抢答器拖拽的相关信令*/
	        value: function sendSignallingFromResponderDrag(data, toID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('isSendSignallingFromResponderDrag')) {
	                return;
	            };
	            var that = this;
	            var signallingName = "ResponderDrag",
	                id = "ResponderDrag",
	                isDelMsg = false,
	                dot_not_save = false,
	                associatedMsgID = "qiangDaQiMesg";
	            toID = toID || "__allExceptSender";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, dot_not_save, undefined, associatedMsgID);
	        }
	    }, {
	        key: 'sendSignallingFromTimerDrag',
	
	        /*计时器拖拽的动作相关信令*/
	        value: function sendSignallingFromTimerDrag(data, toID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('isSendSignallingFromTimerDrag')) {
	                return;
	            };
	            var that = this;
	            var signallingName = "TimerDrag",
	                id = "TimerDrag",
	                isDelMsg = false,
	                dot_not_save = false,
	                associatedMsgID = "timerMesg";
	            toID = toID || "__allExceptSender";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, dot_not_save, undefined, associatedMsgID);
	        }
	    }, {
	        key: 'sendSignallingFromAnswerDrag',
	
	        /*答题卡拖拽的动作相关信令*/
	        value: function sendSignallingFromAnswerDrag(data, toID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('isSendSignallingFromAnswerDrag')) {
	                return;
	            };
	            var that = this;
	            var signallingName = "AnswerDrag",
	                id = "AnswerDrag",
	                isDelMsg = false,
	                dot_not_save = false,
	                associatedMsgID = "answerMesg";
	            toID = toID || "__allExceptSender";
	            that.sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, dot_not_save, undefined, associatedMsgID);
	        }
	    }]);
	
	    return ServiceSignalling;
	})(_SignallingInterface3['default']);
	
	var ServiceSignallingInstance = new ServiceSignalling();
	exports['default'] = ServiceSignallingInstance;
	
	/*
	备注：
	    toID=> __all , __allExceptSender , userid , __none ,__allSuperUsers
	* */
	module.exports = exports['default'];

/***/ }),

/***/ 119:
/***/ (function(module, exports) {

	/**
	 * 白板界面与白板底层沟通的中间层处理类
	 * @class HandlerWhiteboardAndCore
	 * @description  提供白板界面与白板底层沟通的中间层处理类
	 * @author QiuShao
	 * @date 2017/09/05
	 */'use strict'; /*RGB颜色转换为16进制*/Object.defineProperty(exports,"__esModule",{value:true});var _slicedToArray=(function(){function sliceIterator(arr,i){var _arr=[];var _n=true;var _d=false;var _e=undefined;try{for(var _i=arr[Symbol.iterator](),_s;!(_n = (_s = _i.next()).done);_n = true) {_arr.push(_s.value);if(i && _arr.length === i)break;}}catch(err) {_d = true;_e = err;}finally {try{if(!_n && _i["return"])_i["return"]();}finally {if(_d)throw _e;}}return _arr;}return function(arr,i){if(Array.isArray(arr)){return arr;}else if(Symbol.iterator in Object(arr)){return sliceIterator(arr,i);}else {throw new TypeError("Invalid attempt to destructure non-iterable instance");}};})();var _createClass=(function(){function defineProperties(target,props){for(var i=0;i < props.length;i++) {var descriptor=props[i];descriptor.enumerable = descriptor.enumerable || false;descriptor.configurable = true;if("value" in descriptor)descriptor.writable = true;Object.defineProperty(target,descriptor.key,descriptor);}}return function(Constructor,protoProps,staticProps){if(protoProps)defineProperties(Constructor.prototype,protoProps);if(staticProps)defineProperties(Constructor,staticProps);return Constructor;};})();function _classCallCheck(instance,Constructor){if(!(instance instanceof Constructor)){throw new TypeError("Cannot call a class as a function");}}String.prototype.colorHex = function(){var that=this;var reg=/^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;if(/^(rgb|RGB)/.test(that)){var aColor=that.replace(/(?:\(|\)|rgb|RGB)*/g,"").split(",");var strHex="#";for(var i=0;i < aColor.length;i++) {var hex=Number(aColor[i]).toString(16);if(hex === "0"){hex += hex;}strHex += hex;}if(strHex.length !== 7){strHex = that;}return strHex;}else if(reg.test(that)){var aNum=that.replace(/#/,"").split("");if(aNum.length === 6){return that;}else if(aNum.length === 3){var numHex="#";for(var i=0;i < aNum.length;i += 1) {numHex += aNum[i] + aNum[i];}return numHex;}}else {return that;}}; /*16进制颜色转为RGB格式*/String.prototype.colorRgb = function(){var sColor=this.toLowerCase();var reg=/^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;if(sColor && reg.test(sColor)){if(sColor.length === 4){var sColorNew="#";for(var i=1;i < 4;i += 1) {sColorNew += sColor.slice(i,i + 1).concat(sColor.slice(i,i + 1));}sColor = sColorNew;} //处理六位的颜色值
	var sColorChange=[];for(var i=1;i < 7;i += 2) {sColorChange.push(parseInt("0x" + sColor.slice(i,i + 2)));}return "RGB(" + sColorChange.join(",") + ")";}else {return sColor;}}; /*白板内部使用的工具*/var whiteboardInnerUtils={ /**绑定事件
	     @method addEvent
	     @param   {element} element 添加事件元素
	     {string} eType 事件类型
	     {Function} handle 事件处理器
	     {Bollean} bol false 表示在事件第三阶段（冒泡）触发，true表示在事件第一阶段（捕获）触发。
	     */addEvent:function addEvent(element,eType,handle,bol){bol = bol != undefined && bol != null?bol:false;if(element.addEventListener){ //如果支持addEventListener
	element.addEventListener(eType,handle,bol);}else if(element.attachEvent){ //如果支持attachEvent
	element.attachEvent("on" + eType,handle);}else { //否则使用兼容的onclick绑定
	element["on" + eType] = handle;}}, /**事件解绑
	     @method removeEvent
	     @param   {element} element 删除事件元素
	     {string} eType 事件类型
	     {Function} handle 事件处理器
	     {Bollean} bol false 表示在事件第三阶段（冒泡）触发，true表示在事件第一阶段（捕获）触发。
	     */removeEvent:function removeEvent(element,eType,handle,bol){if(element.addEventListener){element.removeEventListener(eType,handle,bol);}else if(element.attachEvent){element.detachEvent("on" + eType,handle);}else {element["on" + eType] = null;}},getOffset:function getOffset(elem){var obj={left:elem.offsetLeft,top:elem.offsetTop};while(elem != document.body) {elem = elem.offsetParent;obj.left += elem.offsetLeft;obj.top += elem.offsetTop;}return obj;}}; /*白板类*/var HandlerWhiteboardAndCore=(function(){function HandlerWhiteboardAndCore(){_classCallCheck(this,HandlerWhiteboardAndCore);this.whiteboardToolsInfo = { //白板当前工具的状态
	primaryColor:"#000000", //画笔的颜色
	secondaryColor:"#ffffff", //填充的颜色
	backgroundColor:"#ffffff", //背景颜色
	pencilWidth:5, //笔的大小
	shapeWidth:5, //图形画笔大小
	eraserWidth:15, //橡皮大小
	fontSize:18, //字体大小
	fontFamily:"微软雅黑",fontStyle:"normal",fontWeight:"normal"};this.defaultProductionOptions = { //默认的白板生产配置选项
	whiteboardClear:true, //默认清除白板
	watermarkImageScalc:16 / 9, //默认的白板比例
	whiteboardMagnification:1, //默认的白板放大比例
	containerWidthAndHeight:{width:0,height:0}, //白板承载容器的宽和高
	minHeight:undefined, //白板默认的最小高度
	rotateDeg:0, //默认的旋转角度
	baseWhiteboardWidth:960, //白板的宽高比例基数
	proprietaryTools:false, //白板是否拥有专属工具
	deawPermission:true, //白板可画权限
	tempDeawPermission:true, //白板临时可画权限（必须在可画权限的基础上）
	saveRedoStack:false, //saveRedoStack权限
	saveUndoStack:true}; //saveUndoStack权限
	this.whiteboardInstanceIDPrefix = "whiteboard_";this.whiteboardInstanceDefaultID = "whiteboard_" + 'default';this.whiteboardInstanceStore = {}; //白板实例存储中心
	this.whiteboardThumbnailStore = {}; //白板缩略图存储中心
	this.uniqueWhiteboard = false; //唯一的白板
	this.minMagnification = 1; //最小的白板放大倍数
	this.maxMagnification = 3; //最大的白板放大倍数
	this.useWhiteboardTool = {tool_pencil:false,tool_highlighter:false,tool_line:false,tool_arrow:false,tool_dashed:false,tool_eraser:false,tool_text:false,tool_rectangle:false,tool_rectangle_empty:false,tool_ellipse:false,tool_ellipse_empty:false,tool_polygon:false,tool_eyedropper:false,tool_selectShape:false,tool_mouse:false,tool_laser:false,action_undo:false,action_redo:false,action_clear:false,zoom_big:false,zoom_small:false,zoom_default:false}; //使用的白板工具
	this.specialWhiteboardInstanceIDPrefix = 'specialWhiteboardInstanceIDPrefix_';this.awaitSaveToWhiteboardInstanceSignallingArray = []; //等待保存到白板实例的信令数据集合
	this.commonActiveTool = 'tool_pencil'; //公共的正在使用的白板工具
	this.basicTemplateWhiteboardSignallingList = {}; //基本模板信令集合
	this.basicTemplateWhiteboardSignallingChildrenStackStorage = {}; //基本模板画笔数据集合-孩子集合（用户保存使用模板的白板数据栈数据,不包含模板数据）
	}_createClass(HandlerWhiteboardAndCore,[{key:"getSpecialWhiteboardInstanceIDPrefix", /*获取特殊白板id前缀*/value:function getSpecialWhiteboardInstanceIDPrefix(){return this.specialWhiteboardInstanceIDPrefix;}},{key:"setUniqueWhiteboard", /*设置白板是否是唯一的白板*/value:function setUniqueWhiteboard(isUniqueWhiteboard){this.uniqueWhiteboard = isUniqueWhiteboard;}},{key:"activeCommonWhiteboardTool", /*激活公共的白板工具*/value:function activeCommonWhiteboardTool(toolKey){var that=this;if(/^tool_/.test(toolKey)){ //白板底层工具
	that.commonActiveTool = toolKey; //当前使用的公共的激活工具
	}var _iteratorNormalCompletion=true;var _didIteratorError=false;var _iteratorError=undefined;try{for(var _iterator=Object.values(that.whiteboardInstanceStore)[Symbol.iterator](),_step;!(_iteratorNormalCompletion = (_step = _iterator.next()).done);_iteratorNormalCompletion = true) {var whiteboardInstance=_step.value;if(whiteboardInstance.proprietaryTools){ //白板拥有专属工具则不受公共工具的管理
	continue;}var id=whiteboardInstance.id;that.activeWhiteboardTool(toolKey,id);}}catch(err) {_didIteratorError = true;_iteratorError = err;}finally {try{if(!_iteratorNormalCompletion && _iterator["return"]){_iterator["return"]();}}finally {if(_didIteratorError){throw _iteratorError;}}}}},{key:"updateCommonWhiteboardToolsInfo", /*更新whiteboardToolsInfo*/value:function updateCommonWhiteboardToolsInfo(whiteboardToolsInfo){if(whiteboardToolsInfo && typeof whiteboardToolsInfo === 'object'){Object.assign(this.whiteboardToolsInfo,whiteboardToolsInfo);}}},{key:"getWhiteboardDefaultFiledata", /*获取白板的默认filedata数据*/value:function getWhiteboardDefaultFiledata(replaceJson){var filedata={fileid:0,currpage:1,pagenum:1,filetype:'whiteboard',filename:'whiteboard',swfpath:'',pptslide:1,pptstep:0,steptotal:0};if(replaceJson && typeof replaceJson === 'object'){Object.assign(filedata,replaceJson);}return filedata;}},{key:"handlerPubmsg_SharpsChange", /*处理pubmsg的SharpsChange信令数据(注意：只能有一个地方调用)*/value:function handlerPubmsg_SharpsChange(pubmsgData){if(pubmsgData){if(pubmsgData.data && typeof pubmsgData.data === 'string'){pubmsgData.data = JSON.parse(pubmsgData.data);}this._saveBasicTemplateWhiteboardSignallingData(pubmsgData,'pubmsg');var whiteboardID=pubmsgData.data.whiteboardID;var whiteboardInstance=this._getWhiteboardInstanceById(whiteboardID);if(!whiteboardInstance){pubmsgData.source = 'pubmsg';this.awaitSaveToWhiteboardInstanceSignallingArray.push(pubmsgData);return;}if(pubmsgData && pubmsgData.data != null && (pubmsgData.data.eventType === "shapeSaveEvent" || pubmsgData.data.eventType === "clearEvent" || pubmsgData.data.eventType === "redoEvent" || pubmsgData.data.eventType === "laserMarkEvent" || pubmsgData.data.eventType === "changeZoomEvent")){pubmsgData.source = 'pubmsg';if(pubmsgData.data.eventType === "laserMarkEvent"){this._receiveSnapshot(pubmsgData,whiteboardInstance);}else {var shapeName=pubmsgData.id.substring(pubmsgData.id.lastIndexOf("###_") + 4);if(shapeName){var shapeNameArr=shapeName.split("_");var remoteFileid=shapeNameArr[1];var remoteCurrpage=shapeNameArr[2];var currFileData=this.getWhiteboardFiledata(whiteboardID);if(currFileData.fileid == remoteFileid && currFileData.currpage == remoteCurrpage){this._receiveSnapshot(pubmsgData,whiteboardInstance);}else {if(whiteboardInstance.waitingProcessShapeData[shapeName] == null || whiteboardInstance.waitingProcessShapeData[shapeName] == undefined){whiteboardInstance.waitingProcessShapeData[shapeName] = [];whiteboardInstance.waitingProcessShapeData[shapeName].push(pubmsgData);}else {whiteboardInstance.waitingProcessShapeData[shapeName].push(pubmsgData);}}}};}}}},{key:"handlerDelmsg_SharpsChange", /*处理delmsg的SharpsChange信令数据(注意：只能有一个地方调用)*/value:function handlerDelmsg_SharpsChange(delmsgData){if(delmsgData){if(delmsgData.data && typeof delmsgData.data === 'string'){delmsgData.data = JSON.parse(delmsgData.data);}this._saveBasicTemplateWhiteboardSignallingData(delmsgData,'delmsg');var whiteboardID=delmsgData.data.whiteboardID;var whiteboardInstance=this._getWhiteboardInstanceById(whiteboardID);if(!whiteboardInstance){delmsgData.source = 'delmsg';this.awaitSaveToWhiteboardInstanceSignallingArray.push(delmsgData);return;}var shapeName=delmsgData.id.substring(delmsgData.id.lastIndexOf("###_") + 4);if(shapeName){var shapeNameArr=shapeName.split("_");var remoteFileid=shapeNameArr[1];var remoteCurrpage=shapeNameArr[2];var currFileData=this.getWhiteboardFiledata(whiteboardID);delmsgData.source = 'delmsg';if(currFileData.fileid == remoteFileid && currFileData.currpage == remoteCurrpage){this._receiveSnapshot(delmsgData,whiteboardInstance);}else {if(whiteboardInstance.waitingProcessShapeData[shapeName] == null || whiteboardInstance.waitingProcessShapeData[shapeName] == undefined){whiteboardInstance.waitingProcessShapeData[shapeName] = [];whiteboardInstance.waitingProcessShapeData[shapeName].push(delmsgData);}else {whiteboardInstance.waitingProcessShapeData[shapeName].push(delmsgData);}}}}}},{key:"handlerMsglist_SharpsChange", /*处理msglist的SharpsChange信令数据(注意：只能有一个地方调用)*/value:function handlerMsglist_SharpsChange(sharpsChangeArray){for(var i=0;i < sharpsChangeArray.length;i++) {var waitingProcessData=sharpsChangeArray[i];if(waitingProcessData.data && typeof waitingProcessData.data === 'string'){waitingProcessData.data = JSON.parse(waitingProcessData.data);}if(waitingProcessData.data.whiteboardID !== undefined && waitingProcessData.data.dependenceBaseboardWhiteboardID !== undefined && this.basicTemplateWhiteboardSignallingChildrenStackStorage[waitingProcessData.data.dependenceBaseboardWhiteboardID] && this.basicTemplateWhiteboardSignallingChildrenStackStorage[waitingProcessData.data.dependenceBaseboardWhiteboardID][waitingProcessData.data.whiteboardID]){this.basicTemplateWhiteboardSignallingChildrenStackStorage[waitingProcessData.data.dependenceBaseboardWhiteboardID][waitingProcessData.data.whiteboardID] = null;delete this.basicTemplateWhiteboardSignallingChildrenStackStorage[waitingProcessData.data.dependenceBaseboardWhiteboardID][waitingProcessData.data.whiteboardID];}this._saveBasicTemplateWhiteboardSignallingData(waitingProcessData,'msglist');var whiteboardID=waitingProcessData.data.whiteboardID;var whiteboardInstance=this._getWhiteboardInstanceById(whiteboardID);if(!whiteboardInstance){waitingProcessData.source = 'msglist';this.awaitSaveToWhiteboardInstanceSignallingArray.push(waitingProcessData);continue;}if(waitingProcessData.data != null && (waitingProcessData.data.eventType === "shapeSaveEvent" || waitingProcessData.data.eventType === "clearEvent" || waitingProcessData.data.eventType === "redoEvent" || waitingProcessData.data.eventType === "changeZoomEvent")){waitingProcessData.source = 'msglist';var shapeName=waitingProcessData.id.substring(waitingProcessData.id.lastIndexOf("###_") + 4);if(whiteboardInstance.waitingProcessShapeData[shapeName] == null || whiteboardInstance.waitingProcessShapeData[shapeName] == undefined){whiteboardInstance.waitingProcessShapeData[shapeName] = [];whiteboardInstance.waitingProcessShapeData[shapeName].push(waitingProcessData);}else {whiteboardInstance.waitingProcessShapeData[shapeName].push(waitingProcessData);}}}}},{key:"preloadWhiteboardImg", /*预加载白板的图片*/value:function preloadWhiteboardImg(imgUrl,callback){if(!imgUrl){L.Logger.warning('preload img url is not esixt!');return;};var img=new Image();img.onload = function(){ //图片加载成功后
	if(callback && typeof callback === 'function'){callback();}};img.src = imgUrl;}},{key:"productionWhiteboard", /*初始化白板权限
	     * @params
	     whiteboardElementId:白板元素id（string , required） thumbnailId:缩略图元素id（string ） ，
	     options:配置项(object)
	     */value:function productionWhiteboard(){var _ref=arguments.length <= 0 || arguments[0] === undefined?{}:arguments[0];var whiteboardElementId=_ref.whiteboardElementId;var thumbnailId=_ref.thumbnailId;var _ref$productionOptions=_ref.productionOptions;var productionOptions=_ref$productionOptions === undefined?{}:_ref$productionOptions;var _ref$handler=_ref.handler;var handler=_ref$handler === undefined?{}:_ref$handler;var id=_ref.id;var that=this;if(!whiteboardElementId){L.Logger.error('whiteboardElementId is required!');return;}var whiteboardInstanceID=that._getWhiteboardInstanceID(id);var whiteboardInstance=that._getWhiteboardInstanceByID(whiteboardInstanceID);if(whiteboardInstance){L.Logger.error('The production whiteboard(whiteboardInstanceID:' + whiteboardInstanceID + ') fails, the whiteboard already exists!');return whiteboardInstance;}whiteboardInstance = {};var whiteboardElement=document.getElementById(whiteboardElementId);if(!whiteboardElement){L.Logger.error('Whiteboard elements do not exist , element id is:' + whiteboardElementId + '!');return whiteboardInstance;}var whiteboardInstanceElement=document.createElement('div');var whiteboardInstanceElementId=whiteboardElementId + '_whiteboardInstance';whiteboardInstanceElement.className = 'whiteboard-instance-element';whiteboardInstanceElement.id = whiteboardInstanceElementId;whiteboardElement.appendChild(whiteboardInstanceElement);productionOptions = Object.assign({},that.defaultProductionOptions,productionOptions);that.whiteboardInstanceStore[whiteboardInstanceID] = whiteboardInstance; //白板实例
	whiteboardInstance.filedata = productionOptions.filedata || {};whiteboardInstance.baseWhiteboardWidth = productionOptions.baseWhiteboardWidth;whiteboardInstance.whiteboardInstanceID = whiteboardInstanceID; //白板id
	whiteboardInstance.parcelAncestorElementId = productionOptions.parcelAncestorElementId; //包裹的祖先元素的id
	whiteboardInstance.isBaseboard = productionOptions.isBaseboard; //是否是模板白板
	whiteboardInstance.needLooadBaseboard = productionOptions.needLooadBaseboard; //是否需要加载模板数据
	whiteboardInstance.dependenceBaseboardWhiteboardID = productionOptions.dependenceBaseboardWhiteboardID; //依赖的模板白板的id
	whiteboardInstance.watermarkImageScalc = productionOptions.watermarkImageScalc; //白板比例
	whiteboardInstance.whiteboardMagnification = productionOptions.whiteboardMagnification; //白板缩放倍数
	whiteboardInstance.associatedMsgID = productionOptions.associatedMsgID; //绑定的信令消息id
	whiteboardInstance.associatedUserID = productionOptions.associatedUserID; //绑定的用户id
	whiteboardInstance.proprietaryTools = productionOptions.proprietaryTools; //白板是否拥有专属工具
	whiteboardInstance.minHeight = productionOptions.minHeight; //白板最小的高度
	whiteboardInstance.rotateDeg = productionOptions.rotateDeg; //白板的旋转角度
	whiteboardInstance.deawPermission = productionOptions.deawPermission; //白板可画权限
	whiteboardInstance.tempDeawPermission = productionOptions.tempDeawPermission; //白板临时可画权限（必须在可画权限的基础上）
	whiteboardInstance.nickname = productionOptions.nickname; //白板属于的用户的nickname
	whiteboardInstance.userid = productionOptions.userid; //白板属于的用户的userid
	whiteboardInstance.whiteboardToolsInfo = Object.assign({},that.whiteboardToolsInfo); //白板工具信息
	if(productionOptions.primaryColor){whiteboardInstance.whiteboardToolsInfo.primaryColor = productionOptions.primaryColor;}if(productionOptions.secondaryColor){whiteboardInstance.whiteboardToolsInfo.secondaryColor = productionOptions.secondaryColor;}if(productionOptions.backgroundColor){whiteboardInstance.whiteboardToolsInfo.backgroundColor = productionOptions.backgroundColor;}whiteboardInstance.saveRedoStack = productionOptions.saveRedoStack; //白板的saveRedoStack权限
	whiteboardInstance.saveUndoStack = productionOptions.saveUndoStack; //白板的saveUndoStack权限
	whiteboardInstance.imageThumbnailId = productionOptions.imageThumbnailId; //白板的图片缩略图Id
	whiteboardInstance.imageThumbnailTipContent = productionOptions.imageThumbnailTipContent; //白板的图片缩略图提示信息
	whiteboardInstance.registerWhiteboardToolsList = {}; //白板标注工具注册集合
	whiteboardInstance.stackStorage = {}; //白板数据栈对象
	whiteboardInstance.handler = {}; //处理函数集合
	whiteboardInstance.handler.sendSignallingToServer = handler.sendSignallingToServer;whiteboardInstance.handler.delSignallingToServer = handler.delSignallingToServer;whiteboardInstance.handler.resizeWhiteboardSizeCallback = handler.resizeWhiteboardSizeCallback;whiteboardInstance.handler.noticeUpdateToolDescCallback = handler.noticeUpdateToolDescCallback;whiteboardInstance.active = true; //白板激活状态
	whiteboardInstance.containerWidthAndHeight = productionOptions.containerWidthAndHeight;whiteboardInstance.waitingProcessShapeData = {}; //等待处理的白板数据
	whiteboardInstance.whiteboardElementId = whiteboardElementId; //白板节点的id
	whiteboardInstance.whiteboardElement = whiteboardElement; //白板的节点元素
	whiteboardInstance.whiteboardInstanceElementId = whiteboardInstanceElementId; //白板实例节点的id
	whiteboardInstance.whiteboardInstanceElement = whiteboardInstanceElement; //白板实例节点元素
	whiteboardInstance.id = id; //文件id
	whiteboardInstance.thumbnailId = thumbnailId; //白板缩略图元素id
	whiteboardInstance.lc = window.LC.init(whiteboardInstance.whiteboardInstanceElement); //白板对象
	whiteboardInstance.lc.backingScale = 1; //设置canvas不受电脑分辨率影响
	whiteboardInstance.lc.setColor('primary',whiteboardInstance.whiteboardToolsInfo.primaryColor);whiteboardInstance.lc.setColor('secondary',whiteboardInstance.whiteboardToolsInfo.secondaryColor);whiteboardInstance.lc.setColor('background',whiteboardInstance.whiteboardToolsInfo.backgroundColor);whiteboardInstance.lc.setZoom(1);whiteboardInstance.lc.setPan(0,0);whiteboardInstance.lc.on("shapeSave",that._handlerShapeSaveEvent.bind(that,whiteboardInstance));whiteboardInstance.lc.on("undo",that._handlerUndoEvent.bind(that,whiteboardInstance));whiteboardInstance.lc.on("redo",that._handlerRedoEvent.bind(that,whiteboardInstance));whiteboardInstance.lc.on("clear",that._handlerClearEvent.bind(that,whiteboardInstance));whiteboardInstance.lc.on('drawingChange',this._handlerDrawingChangeEvent.bind(that,whiteboardInstance)); //      whiteboardInstance.lc.on('snapshotLoad ', this.snapshotLoadEvent);
	//      whiteboardInstance.lc.on("doClearRedoStack",this.doClearRedoStackEvent) ;
	//      whiteboardInstance.lc.on("primaryColorChange",this.primaryColorChangeEvent) ;
	//      whiteboardInstance.lc.on("secondaryColorChange",this.secondaryColorChangeEvent) ;
	//      whiteboardInstance.lc.on("backgroundColorChange",this.backgroundColorChangeEvent) ;
	//      whiteboardInstance.lc.on("drawStart",this.drawStartEvent) ;
	//      whiteboardInstance.lc.on("drawContinue",this.drawContinueEvent) ;
	//      whiteboardInstance.lc.on("drawEnd",this.drawEndEvent) ;
	//      whiteboardInstance.lc.on("toolChange",this.toolChangeEvent) ;
	//      whiteboardInstance.lc.on('pan',  this.panEvent);
	//      whiteboardInstance.lc.on('zoom',  this.zoomEvent);
	//      whiteboardInstance.lc.on("repaint",this.repaintEvent) ;
	//      whiteboardInstance.lc.on("lc-pointerdown",whiteboardInstance.lcPointerdownEvent) ;
	//      whiteboardInstance.lc.on("lc-pointerup",whiteboardInstance.lcPointerupEvent) ;
	//      whiteboardInstance.lc.on("lc-pointermove",whiteboardInstance.lcPointermoveEvent) ;
	//      whiteboardInstance.lc.on("lc-pointerdrag",whiteboardInstance.lcPointerdragEvent) ;
	whiteboardInstance.activeTool = undefined;if(productionOptions.whiteboardClear){that.clearWhiteboardAllDataById(id);};if(whiteboardInstance.dependenceBaseboardWhiteboardID !== undefined && whiteboardInstance.id !== undefined){if(that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID] && that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID][whiteboardInstance.id]){if(!whiteboardInstance.isBaseboard){whiteboardInstance.stackStorage = Object.assign({},that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID][whiteboardInstance.id]);}that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID][whiteboardInstance.id] = null;delete that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID][whiteboardInstance.id];}}that._changeWhiteboardDeawPermission(whiteboardInstance.deawPermission,whiteboardInstance);that._changeWhiteboardTemporaryDeawPermission(whiteboardInstance.tempDeawPermission,whiteboardInstance);that._saveAwaitSaveToWhiteboardInstanceSignallingToWhiteboardInstance(whiteboardInstance); //保存等待的白板信令数据到相应的白板实例中
	that.activeWhiteboardTool(!whiteboardInstance.proprietaryTools?that.commonActiveTool:whiteboardInstance.useToolKey?whiteboardInstance.useToolKey:'tool_pencil',id);that._zoomIsDisable(whiteboardInstance);that._actionIsDisable(whiteboardInstance);that._noticeUpdateToolDesc(whiteboardInstance);that._resizeWhiteboardHandler(whiteboardInstance);return whiteboardInstance;}},{key:"updateImageThumbnailId", /*更新图片缩略图ID*/value:function updateImageThumbnailId(id,imageThumbnailId){var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateImageThumbnailId]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.imageThumbnailId = imageThumbnailId;this._saveImageBase64ToImageThumbnail(whiteboardInstance);}},{key:"updateWhiteboardSaveRedoStackAndSaveUndoStack", /*更新白板saveRedoStack、saveUndoStack权限*/value:function updateWhiteboardSaveRedoStackAndSaveUndoStack(id,_ref2){var saveRedoStack=_ref2.saveRedoStack;var saveUndoStack=_ref2.saveUndoStack;var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateSaveRedoStackAndSaveUndoStack]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.saveRedoStack = saveRedoStack != undefined?saveRedoStack:whiteboardInstance.saveRedoStack;whiteboardInstance.saveUndoStack = saveUndoStack != undefined?saveUndoStack:whiteboardInstance.saveUndoStack;} /*更新isBaseboard*/},{key:"updateIsBaseboard",value:function updateIsBaseboard(id,isBaseboard){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateIsBaseboard]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.isBaseboard = isBaseboard;} /*更新dependenceBaseboardWhiteboardID*/},{key:"updateDependenceBaseboardWhiteboardID",value:function updateDependenceBaseboardWhiteboardID(id,dependenceBaseboardWhiteboardID){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateDependenceBaseboardWhiteboardID]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.dependenceBaseboardWhiteboardID = dependenceBaseboardWhiteboardID;} /*更新白板信令绑定的消息id*/},{key:"updateWhiteboardAssociatedMsgID",value:function updateWhiteboardAssociatedMsgID(id,associatedMsgID){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateWhiteboardAssociatedMsgID]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.associatedMsgID = associatedMsgID;} /*更新白板信令绑定的用户id*/},{key:"updateWhiteboardAssociatedUserID",value:function updateWhiteboardAssociatedUserID(id,associatedUserID){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateWhiteboardAssociatedUserID]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.associatedUserID = associatedUserID;} /*白板实例是否存在，通过id判断*/},{key:"hasWhiteboardById",value:function hasWhiteboardById(id){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);return whiteboardInstance !== undefined && whiteboardInstance !== null;}},{key:"clearWhiteboardAllDataById", /*清除白板的所有数据，包括存储的数据,通过id*/value:function clearWhiteboardAllDataById(id){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[clear]There are no white board Numbers that belong to id ' + id);return;}that._clearWhiteboardAllDataByInstance(whiteboardInstance);}},{key:"productionSpecialId", /*生产特殊的id*/value:function productionSpecialId(id){var that=this;var specialId=that.specialWhiteboardInstanceIDPrefix + id;return specialId;} /*销毁白板实例，通过id*/},{key:"destroyWhiteboardInstance",value:function destroyWhiteboardInstance(id){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[destroy]There are no white board Numbers that belong to id ' + id);return;};that._destroyWhiteboardInstance(whiteboardInstance);}},{key:"clearRedoAndUndoStack", /*清空白板且清除白板数据栈*/value:function clearRedoAndUndoStack(id,clearRedoAndUndoStackJson){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[clearRedoAndUndoStack]There are no white board Numbers that belong to id ' + id);return;};that._clearRedoAndUndoStack(whiteboardInstance,clearRedoAndUndoStackJson);}},{key:"resetDedaultWhiteboardMagnification", /*重置白板的缩放比*/value:function resetDedaultWhiteboardMagnification(id){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[resetDedaultWhiteboardMagnification]There are no white board Numbers that belong to id ' + id);return;};whiteboardInstance.whiteboardMagnification = that.defaultProductionOptions.whiteboardMagnification;that._zoomIsDisable(whiteboardInstance);that._resizeWhiteboardHandler(whiteboardInstance);}},{key:"updateWhiteboardMagnification", /*更新白板的缩放比*/value:function updateWhiteboardMagnification(id,whiteboardMagnification){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateWhiteboardMagnification]There are no white board Numbers that belong to id ' + id);return;};whiteboardInstance.whiteboardMagnification = whiteboardMagnification;}},{key:"updateWhiteboardWatermarkImageScalc", /*更新白板的watermarkImageScalc*/value:function updateWhiteboardWatermarkImageScalc(id){var watermarkImageScalc=arguments.length <= 1 || arguments[1] === undefined?this.defaultProductionOptions.watermarkImageScalc:arguments[1];var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateWhiteboardWatermarkImageScalc]There are no white board Numbers that belong to id ' + id);return;};this._updateWhiteboardWatermarkImageScalc(whiteboardInstance,watermarkImageScalc);} /*设置白板的图片*/},{key:"setWhiteboardWatermarkImage",value:function setWhiteboardWatermarkImage(id,watermarkImageUrl){var _ref3=arguments.length <= 2 || arguments[2] === undefined?{}:arguments[2];var _ref3$resetDedaultWhiteboardMagnification=_ref3.resetDedaultWhiteboardMagnification;var resetDedaultWhiteboardMagnification=_ref3$resetDedaultWhiteboardMagnification === undefined?true:_ref3$resetDedaultWhiteboardMagnification;var that=this;L.Logger.debug('setWhiteboardWatermarkImage watermarkImageUrl:' + watermarkImageUrl);var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[setWhiteboardWatermarkImage]There are no white board Numbers that belong to id ' + id);return;};whiteboardInstance.lc.watermarkImage = null;if(resetDedaultWhiteboardMagnification){that.resetDedaultWhiteboardMagnification(id);}if(!watermarkImageUrl){ //图片地址没有，则使用默认白板
	that.hideWhiteboardCanvasBackground(id);whiteboardInstance.lc.watermarkScale = 1;that._resizeWhiteboardByScalc(whiteboardInstance,{isChangeWatermarkScale:false});that._hideWhiteboardLoading(whiteboardInstance);whiteboardInstance.lc.watermarkImage = null;that._hideWhiteboardLoading(whiteboardInstance);}else {that.showWhiteboardCanvasBackground(id);that._showWhiteboardLoading(whiteboardInstance);clearTimeout(whiteboardInstance.setWhiteboardWatermarkImageTimer);whiteboardInstance.setWhiteboardWatermarkImageTimer = setTimeout(function(){var watermarkImage=new Image();watermarkImage.onload = function(){var watermarkImageScalc=watermarkImage.width / watermarkImage.height;whiteboardInstance.lc.setWatermarkImage(watermarkImage);that._resizeWhiteboardByScalc(whiteboardInstance,{watermarkImage:watermarkImage,watermarkImageScalc:watermarkImageScalc});that._hideWhiteboardLoading(whiteboardInstance);};watermarkImage.src = watermarkImageUrl;},150);}}},{key:"resizeWhiteboardHandler", /*根据resize更新白板的大小*/value:function resizeWhiteboardHandler(id){var that=this;if(id === undefined){var _iteratorNormalCompletion2=true;var _didIteratorError2=false;var _iteratorError2=undefined;try{for(var _iterator2=Object.values(that.whiteboardInstanceStore)[Symbol.iterator](),_step2;!(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done);_iteratorNormalCompletion2 = true) {var whiteboardInstance=_step2.value;that._resizeWhiteboardHandler(whiteboardInstance);}}catch(err) {_didIteratorError2 = true;_iteratorError2 = err;}finally {try{if(!_iteratorNormalCompletion2 && _iterator2["return"]){_iterator2["return"]();}}finally {if(_didIteratorError2){throw _iteratorError2;}}}}else {var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[resizeWhiteboardHandler]There are no white board Numbers that belong to id ' + id);return;};that._resizeWhiteboardHandler(whiteboardInstance);}}},{key:"updateContainerWidthAndHeight", /*更新承载容器的宽高*/value:function updateContainerWidthAndHeight(id){var _ref4=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var width=_ref4.width;var height=_ref4.height;var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateContainerWidthAndHeight]There are no white board Numbers that belong to id ' + id);return;};if(width === undefined || height === undefined){L.Logger.error('[updateContainerWidthAndHeight]width or height is not exist , [width:' + width + ' , height:' + height + ']!');return;};whiteboardInstance.containerWidthAndHeight = {width:width,height:height};that._resizeWhiteboardHandler(whiteboardInstance);}},{key:"hideWhiteboardCanvasBackground", /*隐藏白板的背景canvas*/value:function hideWhiteboardCanvasBackground(id){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[hideWhiteboardCanvasBackground]There are no white board Numbers that belong to id ' + id);return;};if(whiteboardInstance.lc && whiteboardInstance.lc.backgroundCanvas){whiteboardInstance.lc.backgroundCanvas.style.display = 'none';}}},{key:"showWhiteboardCanvasBackground", /*显示白板的背景canvas*/value:function showWhiteboardCanvasBackground(id){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[showWhiteboardCanvasBackground]There are no white board Numbers that belong to id ' + id);return;};if(whiteboardInstance.lc && whiteboardInstance.lc.backgroundCanvas){whiteboardInstance.lc.backgroundCanvas.style.display = '';}}},{key:"hideWhiteboard", /*隐藏白板*/value:function hideWhiteboard(id){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(whiteboardInstance && whiteboardInstance.whiteboardElement){whiteboardInstance.whiteboardElement.style.display = 'none';}}},{key:"showWhiteboard", /*显示白板*/value:function showWhiteboard(id){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(whiteboardInstance && whiteboardInstance.whiteboardElement){whiteboardInstance.whiteboardElement.style.display = 'block';}}},{key:"updateTextFont", /*更新白板字体*/value:function updateTextFont(id){var _ref5=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var fontSize=_ref5.fontSize;var fontFamily=_ref5.fontFamily;var fontStyle=_ref5.fontStyle;var fontWeight=_ref5.fontWeight;var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateTextFont]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.whiteboardToolsInfo.fontSize = fontSize != undefined?fontSize:whiteboardInstance.whiteboardToolsInfo.fontSize;whiteboardInstance.whiteboardToolsInfo.fontFamily = fontFamily != undefined?fontFamily:whiteboardInstance.whiteboardToolsInfo.fontFamily;whiteboardInstance.whiteboardToolsInfo.fontStyle = fontStyle != undefined?fontStyle:whiteboardInstance.whiteboardToolsInfo.fontStyle;whiteboardInstance.whiteboardToolsInfo.fontWeight = fontWeight != undefined?fontWeight:whiteboardInstance.whiteboardToolsInfo.fontWeight;that._updateTextFont(whiteboardInstance);}},{key:"updateEraserWidth", /*更新橡皮宽度*/value:function updateEraserWidth(id){var _ref6=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var eraserWidth=_ref6.eraserWidth;var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateEraserWidth]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.whiteboardToolsInfo.eraserWidth = eraserWidth != undefined?eraserWidth:whiteboardInstance.whiteboardToolsInfo.eraserWidth;that._updateEraserWidth(whiteboardInstance);}},{key:"updatePencilWidth", /*更新画笔的宽度*/value:function updatePencilWidth(id){var _ref7=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var pencilWidth=_ref7.pencilWidth;var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updatePencilWidth]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.whiteboardToolsInfo.pencilWidth = pencilWidth != undefined?pencilWidth:whiteboardInstance.whiteboardToolsInfo.pencilWidth;that._updatePencilWidth(whiteboardInstance);}},{key:"updateWhiteboardToolsInfo", /*更新whiteboardToolsInfo*/value:function updateWhiteboardToolsInfo(id,whiteboardToolsInfo){var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateWhiteboardToolsInfo]There are no white board Numbers that belong to id ' + id);return;}if(whiteboardToolsInfo && typeof whiteboardToolsInfo === 'object'){Object.assign(whiteboardInstance.whiteboardToolsInfo,whiteboardToolsInfo);}}},{key:"updateShapeWidth", /*更新形状的宽度*/value:function updateShapeWidth(id){var _ref8=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var shapeWidth=_ref8.shapeWidth;var that=this;var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[uploadShapeWidth]There are no white board Numbers that belong to id ' + id);return;}whiteboardInstance.whiteboardToolsInfo.shapeWidth = shapeWidth != undefined?shapeWidth:whiteboardInstance.whiteboardToolsInfo.shapeWidth;that._updateShapeWidth(whiteboardInstance);}},{key:"updateColor", /*更新颜色*/value:function updateColor(id,colorJson){var that=this;if(colorJson && typeof colorJson === 'object'){var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateColor]There are no white board Numbers that belong to id ' + id);return;}var _iteratorNormalCompletion3=true;var _didIteratorError3=false;var _iteratorError3=undefined;try{for(var _iterator3=Object.entries(colorJson)[Symbol.iterator](),_step3;!(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done);_iteratorNormalCompletion3 = true) {var _step3$value=_slicedToArray(_step3.value,2);var key=_step3$value[0];var value=_step3$value[1]; /*
	                 primaryColor:"#000000" , //画笔的颜色
	                 secondaryColor:"#ffffff" , //填充的颜色
	                 backgroundColor:"#ffffff" , //背景颜色
	                 */whiteboardInstance.whiteboardToolsInfo[key + "Color"] = value;}}catch(err) {_didIteratorError3 = true;_iteratorError3 = err;}finally {try{if(!_iteratorNormalCompletion3 && _iterator3["return"]){_iterator3["return"]();}}finally {if(_didIteratorError3){throw _iteratorError3;}}}that._updateColor(whiteboardInstance,colorJson);}} /*激活白板工具*/},{key:"activeWhiteboardTool",value:function activeWhiteboardTool(toolKey,id){var that=this;if(that.useWhiteboardTool[toolKey] === undefined){L.Logger.error('The whiteboard does not have the ' + toolKey + ' tool!');return;};if(id === undefined || id === null){L.Logger.error('[activeWhiteboardTool]id is undefined or null ');return;};var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[activeWhiteboardTool]There are no white board Numbers that belong to id ' + id);return;}if(/^tool_/.test(toolKey)){ //白板底层工具
	whiteboardInstance.activeTool = toolKey; //当前使用的激活工具
	that._setWhiteboardTools(toolKey,whiteboardInstance);that._handlerActiveToolLaser(toolKey,whiteboardInstance);if(toolKey == "tool_text"){that._updateTextFont(whiteboardInstance);}else if(toolKey == "tool_eraser"){that._updateEraserWidth(whiteboardInstance);}else if(toolKey == "tool_pencil" || toolKey == "tool_highlighter" || toolKey == "tool_line" || toolKey == "tool_arrow" || toolKey == "tool_dashed"){that._updatePencilWidth(whiteboardInstance);}else if(toolKey == "tool_rectangle" || toolKey == "tool_rectangle_empty" || toolKey == "tool_ellipse" || toolKey == "tool_ellipse_empty" || toolKey == "tool_polygon"){that._updateShapeWidth(whiteboardInstance);}if(toolKey == "tool_ellipse_empty" || toolKey == "tool_rectangle_empty"){ //空心
	whiteboardInstance.lc.setColor('secondary',"transparent");}else {whiteboardInstance.lc.setColor('secondary',whiteboardInstance.whiteboardToolsInfo.secondaryColor);}if(toolKey === 'tool_highlighter'){ //荧光笔
	var color=whiteboardInstance.whiteboardToolsInfo.primaryColor.colorRgb().toLowerCase().replace("rgb","rgba").replace(")",",0.5)");whiteboardInstance.lc.setColor('primary',color);}else {whiteboardInstance.lc.setColor('primary',whiteboardInstance.whiteboardToolsInfo.primaryColor);}}else if(/^action_/.test(toolKey)){ //白板执行的动作
	if(toolKey === 'action_undo'){whiteboardInstance.lc.undo();}else if(toolKey === 'action_redo'){whiteboardInstance.lc.redo();}else if(toolKey === 'action_clear'){whiteboardInstance.lc.clear();}that._actionIsDisable(whiteboardInstance);}else if(/^zoom_/.test(toolKey)){ //白板的缩放调整
	if(toolKey === 'zoom_big'){if(whiteboardInstance.whiteboardMagnification < that.maxMagnification){whiteboardInstance.whiteboardMagnification += 0.5;}}else if(toolKey === 'zoom_small'){if(whiteboardInstance.whiteboardMagnification > that.minMagnification){whiteboardInstance.whiteboardMagnification -= 0.5;}}else if(toolKey === 'zoom_default'){whiteboardInstance.whiteboardMagnification = that.defaultProductionOptions.whiteboardMagnification;}if(whiteboardInstance.whiteboardMagnification > that.maxMagnification){whiteboardInstance.whiteboardMagnification = that.maxMagnification;}else if(whiteboardInstance.whiteboardMagnification < that.minMagnification){whiteboardInstance.whiteboardMagnification = that.minMagnification;}that._zoomIsDisable(whiteboardInstance);that._resizeWhiteboardHandler(whiteboardInstance);}}},{key:"changeWhiteboardTemporaryDeawPermission", /*改变白板临时可画权限*/value:function changeWhiteboardTemporaryDeawPermission(value,id){var that=this;var whiteboardInstance=undefined;if(id != undefined){whiteboardInstance = that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[changeWhiteboardTemporaryDeawPermission]There are no white board Numbers that belong to id ' + id);return;}}that._changeWhiteboardTemporaryDeawPermission(value,whiteboardInstance);}},{key:"changeWhiteboardDeawPermission", /*改变白板临时可画权限*/value:function changeWhiteboardDeawPermission(value,id){var that=this;var whiteboardInstance=undefined;if(id != undefined){whiteboardInstance = that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[changeWhiteboardDeawPermission]There are no white board Numbers that belong to id ' + id);return;}}that._changeWhiteboardDeawPermission(value,whiteboardInstance);}},{key:"registerWhiteboardTools", /*初始化标注工具*/value:function registerWhiteboardTools(id,toolsDesc){var that=this;if(!(toolsDesc && typeof toolsDesc === 'object')){L.Logger.error('[initWhiteboardTools] tools desc cannot be empty and type json!');return;};var whiteboardInstance=that._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[registerWhiteboardTools]There are no white board Numbers that belong to id ' + id);return;}var toolsDescMap={};var _iteratorNormalCompletion4=true;var _didIteratorError4=false;var _iteratorError4=undefined;try{for(var _iterator4=Object.entries(toolsDesc)[Symbol.iterator](),_step4;!(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done);_iteratorNormalCompletion4 = true) {var _step4$value=_slicedToArray(_step4.value,2);var toolKey=_step4$value[0];var toolValue=_step4$value[1];if(that.useWhiteboardTool[toolKey] === undefined){L.Logger.warning('The whiteboard does not have the ' + toolKey + ' tool!');continue;}toolsDescMap[toolKey] = that._productionToolDesc(toolKey,toolValue);that.useWhiteboardTool[toolKey] = true;}}catch(err) {_didIteratorError4 = true;_iteratorError4 = err;}finally {try{if(!_iteratorNormalCompletion4 && _iterator4["return"]){_iterator4["return"]();}}finally {if(_didIteratorError4){throw _iteratorError4;}}}whiteboardInstance.registerWhiteboardToolsList = toolsDescMap;whiteboardInstance.isRegisterWhiteboardTool = true;that._zoomIsDisable(whiteboardInstance);that._zoomIsDisable(whiteboardInstance);that._noticeUpdateToolDesc(whiteboardInstance);}},{key:"hasWhiteboardFiledata", /*是否拥有filedata数据*/value:function hasWhiteboardFiledata(id){var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[hasWhiteboardFiledata]There are no white board Numbers that belong to id ' + id);return;}var _iteratorNormalCompletion5=true;var _didIteratorError5=false;var _iteratorError5=undefined;try{for(var _iterator5=Object.keys(whiteboardInstance.filedata)[Symbol.iterator](),_step5;!(_iteratorNormalCompletion5 = (_step5 = _iterator5.next()).done);_iteratorNormalCompletion5 = true) {var key=_step5.value;return true;}}catch(err) {_didIteratorError5 = true;_iteratorError5 = err;}finally {try{if(!_iteratorNormalCompletion5 && _iterator5["return"]){_iterator5["return"]();}}finally {if(_didIteratorError5){throw _iteratorError5;}}}return false;}},{key:"updateWhiteboardFiledata", /*更新白板的filedata数据*/value:function updateWhiteboardFiledata(id,filedata){var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[updateWhiteboardFiledata]There are no white board Numbers that belong to id ' + id);return;}this._updateWhiteboardFiledata(whiteboardInstance,filedata);}},{key:"getWhiteboardFiledata", /*获取白板的filedata*/value:function getWhiteboardFiledata(id){var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[getWhiteboardFiledata]There are no white board Numbers that belong to id ' + id);return;}return Object.assign({},whiteboardInstance.filedata);}},{key:"loadCurrpageWhiteboard", /*加载当前页的白板数据*/value:function loadCurrpageWhiteboard(id){var _ref9=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var _ref9$loadRedoStack=_ref9.loadRedoStack;var loadRedoStack=_ref9$loadRedoStack === undefined?false:_ref9$loadRedoStack;var _ref9$loadUndoStack=_ref9.loadUndoStack;var loadUndoStack=_ref9$loadUndoStack === undefined?true:_ref9$loadUndoStack;var callback=_ref9.callback;var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[loadCurrpageWhiteboard]There are no white board Numbers that belong to id ' + id);return;}this._clearRedoAndUndoStack(whiteboardInstance); //清空白板且清除白板数据栈
	this._basicTemplateWhiteboardSignallingListToWhiteboardInstance(whiteboardInstance);var _whiteboardInstance$filedata=whiteboardInstance.filedata;var fileid=_whiteboardInstance$filedata.fileid;var currpage=_whiteboardInstance$filedata.currpage;if(loadUndoStack){var undoStack=whiteboardInstance.stackStorage["undoStack_" + fileid + "_" + currpage];if(undoStack && undoStack.length > 0){for(var i=0;i < undoStack.length;i++) {var action=undoStack[i];if(action.actionName === "AddShapeAction"){whiteboardInstance.lc.saveShape(action.shape,false,null,false);}else if(action.actionName === "ClearAction"){whiteboardInstance.lc.clear(false,action.id);}}}}if(loadRedoStack){ /*TODO 这里暂时采用老师将恢复栈的数据都加到撤销站中，再执行撤销操作，有待优化*/var redoStack=whiteboardInstance.stackStorage["redoStack_" + fileid + "_" + currpage];if(redoStack && redoStack.length > 0){for(var i=redoStack.length - 1;i >= 0;i--) {var action=redoStack[i];if(action.actionName === "AddShapeAction"){whiteboardInstance.lc.saveShape(action.shape,false,null,false);}else if(action.actionName === "ClearAction"){whiteboardInstance.lc.clear(false,action.id);}}for(var i=0;i < redoStack.length;i++) {whiteboardInstance.lc.undo(false);}}}if(whiteboardInstance.waitingProcessShapeData == undefined || whiteboardInstance.waitingProcessShapeData == null){whiteboardInstance.waitingProcessShapeData = {};}else {var currpageWaitingProcessShapeData=whiteboardInstance.waitingProcessShapeData["SharpsChange_" + fileid + "_" + currpage];if(currpageWaitingProcessShapeData != null && currpageWaitingProcessShapeData != undefined && currpageWaitingProcessShapeData.length > 0){this._batchReceiveSnapshot(currpageWaitingProcessShapeData,whiteboardInstance);whiteboardInstance.waitingProcessShapeData["SharpsChange_" + fileid + "_" + currpage] = null;delete whiteboardInstance.waitingProcessShapeData["SharpsChange_" + fileid + "_" + currpage];}}this._actionIsDisable(whiteboardInstance);if(callback && typeof callback === "function"){callback();}}},{key:"saveWhiteboardStackToStorage", /*保存白板数据栈到数据栈仓库中*/value:function saveWhiteboardStackToStorage(id){var _ref10=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var saveRedoStack=_ref10.saveRedoStack;var saveUndoStack=_ref10.saveUndoStack;var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[saveWhiteboardStackToStorage]There are no white board Numbers that belong to id ' + id);return;}saveRedoStack = saveRedoStack != undefined?saveRedoStack:whiteboardInstance.saveRedoStack;saveUndoStack = saveUndoStack != undefined?saveUndoStack:whiteboardInstance.saveUndoStack;var _getWhiteboardFiledata=this.getWhiteboardFiledata(id);var fileid=_getWhiteboardFiledata.fileid;var currpage=_getWhiteboardFiledata.currpage;if(saveUndoStack){whiteboardInstance.stackStorage["undoStack_" + fileid + "_" + currpage] = whiteboardInstance.lc.undoStack.slice(0);}if(saveRedoStack){whiteboardInstance.stackStorage["redoStack_" + fileid + "_" + currpage] = whiteboardInstance.lc.redoStack.slice(0);}}},{key:"showWhiteboardLoading", /*显示白板正在loading*/value:function showWhiteboardLoading(id){var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[showWhiteboardLoading]There are no white board Numbers that belong to id ' + id);return;}this._showWhiteboardLoading(whiteboardInstance);}},{key:"hideWhiteboardLoading", /*隐藏白板正在loading*/value:function hideWhiteboardLoading(id){var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[showWhiteboardLoading]There are no white board Numbers that belong to id ' + id);return;}this._hideWhiteboardLoading(whiteboardInstance);}},{key:"isWhiteboardTextEditing", /*白板是否处于文本点击状态*/value:function isWhiteboardTextEditing(id){var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[isWhiteboardTextEditing]There are no white board Numbers that belong to id ' + id);return;}var isEditing=whiteboardInstance.lc.tool.name.toString() == "Text" && whiteboardInstance.lc.tool.currentShapeState == "editing";return isEditing;} /*检测白板Canvas大小*/},{key:"checkWhiteboardCanvasSize",value:function checkWhiteboardCanvasSize(id){var _ref11=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var _ref11$isResize=_ref11.isResize;var isResize=_ref11$isResize === undefined?false:_ref11$isResize;var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[checkWhiteboardCanvasSize]There are no white board Numbers that belong to id ' + id);return;}if(whiteboardInstance.lc && whiteboardInstance.lc.canvas){if(whiteboardInstance.lc.canvas.width === 0 || whiteboardInstance.lc.canvas.height === 0){if(isResize){this._resizeWhiteboardHandler(whiteboardInstance);}return true;}return false;}return undefined;}},{key:"downCanvasImageToLocalFile", /*下载画板canvas图片*/value:function downCanvasImageToLocalFile(id){var type=arguments.length <= 1 || arguments[1] === undefined?'png':arguments[1];var _fixtype=function _fixtype(type){type = type.toLocaleLowerCase().replace(/jpg/i,'jpeg');var r=type.match(/png|jpeg|bmp|gif/)[0];return 'image/' + r;};var _savaFile=function _savaFile(data,filename){ //将图片保存到本地
	var save_link=document.createElementNS('http://www.w3.org/1999/xhtml','a');save_link.href = data;save_link.download = filename;var event=document.createEvent('MouseEvents');event.initMouseEvent('click',true,false,window,0,0,0,0,0,false,false,false,false,0,null);save_link.dispatchEvent(event);};var whiteboardInstance=this._getWhiteboardInstanceById(id);if(!whiteboardInstance){L.Logger.error('[downCanvasImageToLocalFile]There are no white board Numbers that belong to id ' + id);return;}var imgBase64=this._convertCanvasToImageBase64(whiteboardInstance,type);imgBase64 = imgBase64.replace(_fixtype(type),'image/octet-stream'); //将mime-type改为image/octet-stream,强制让浏览器下载
	var filename=(whiteboardInstance.nickname?whiteboardInstance.nickname + "_":"") + whiteboardInstance.id + '_' + new Date().getTime() + '.' + type;_savaFile(imgBase64,filename);} /*清空白板且清除白板数据栈*/},{key:"_clearRedoAndUndoStack",value:function _clearRedoAndUndoStack(whiteboardInstance){var _ref12=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var _ref12$clear=_ref12.clear;var clear=_ref12$clear === undefined?true:_ref12$clear;var _ref12$redo=_ref12.redo;var redo=_ref12$redo === undefined?true:_ref12$redo;var _ref12$undo=_ref12.undo;var undo=_ref12$undo === undefined?true:_ref12$undo;var that=this;if(clear){that._clearLc(whiteboardInstance,{triggerEvent:false});};if(redo){that._clearLcRedoStack(whiteboardInstance);};if(undo){that._clearLcUndoStack(whiteboardInstance);};that._actionIsDisable(whiteboardInstance);}},{key:"_updateWhiteboardFiledata", /*更新白板的filedata数据*/value:function _updateWhiteboardFiledata(whiteboardInstance,filedata){if(filedata && typeof filedata === 'object'){filedata.currpage = Number(filedata.currpage);filedata.pagenum = Number(filedata.pagenum);filedata.pptslide = Number(filedata.pptslide);filedata.pptstep = Number(filedata.pptstep);filedata.steptotal = Number(filedata.steptotal);Object.assign(whiteboardInstance.filedata,filedata);}}},{key:"_batchReceiveSnapshot", /*批量接收白板数据操作shape画图*/value:function _batchReceiveSnapshot(shapesArray,whiteboardInstance){var that=this;if(!Array.isArray(shapesArray)){L.Logger.error('shapesArray must be an array!');return;};shapesArray.forEach(function(remoteData,index){var doNotPaint=true;if(index === shapesArray.length - 1){doNotPaint = false;}that._handlerRemoteDataToWhiteboard(remoteData,doNotPaint,whiteboardInstance);});that._actionIsDisable(whiteboardInstance);}},{key:"_receiveSnapshot", /* 接收白板数据操作shape画图*/value:function _receiveSnapshot(remoteData,whiteboardInstance){var that=this;var doNotPaint=false;that._handlerRemoteDataToWhiteboard(remoteData,doNotPaint,whiteboardInstance);that._actionIsDisable(whiteboardInstance);}},{key:"_handlerRemoteDataToWhiteboard", /*处理远程的数据到白板上*/value:function _handlerRemoteDataToWhiteboard(remoteData,doNotPaint,whiteboardInstance){if(remoteData.data && typeof remoteData.data === 'string'){remoteData.data = JSON.parse(remoteData.data);}if(remoteData.data != null && remoteData.data.eventType != null){if(remoteData.source === 'delmsg'){ //回放的delmsg数据不是发送上去的数据，而是撤销的动作的相关描述，所以这里需要做兼容，如果是来自于delmsg的则事件类型为shapeSaveEvent和clearEvent也执行撤销操作
	switch(remoteData.data.eventType){case "shapeSaveEvent":case "clearEvent":case "undoEvent":if(remoteData.data.actionName && remoteData.data.actionName === "AddShapeAction"){whiteboardInstance.lc.undo(false,remoteData.data.shapeId);}else if(remoteData.data.actionName && remoteData.data.actionName === "ClearAction"){whiteboardInstance.lc.undo(false,remoteData.data.clearActionId);}break;}}else {switch(remoteData.data.eventType){case "shapeSaveEvent":if(remoteData.data && remoteData.data.data && remoteData.data.data.data){remoteData.data.data = LC.JSONToShape(remoteData.data.data);}whiteboardInstance.lc.saveShape(remoteData.data.data,false,null,doNotPaint);break;case "undoEvent":if(remoteData.data.actionName && remoteData.data.actionName === "AddShapeAction"){whiteboardInstance.lc.undo(false,remoteData.data.shapeId);}else if(remoteData.data.actionName && remoteData.data.actionName === "ClearAction"){whiteboardInstance.lc.undo(false,remoteData.data.clearActionId);}break;case "redoEvent":if(remoteData.data.actionName && remoteData.data.actionName === "AddShapeAction"){var flag=false; //恢复栈中是否有该shape
	for(var i=whiteboardInstance.lc.redoStack.length - 1;i >= 0;i--) {if(remoteData.data.shapeId === whiteboardInstance.lc.redoStack[i].shapeId){whiteboardInstance.lc.redoStack.splice(i,1);flag = true;break;}}if(remoteData.data && remoteData.data.data && remoteData.data.data.data){remoteData.data.data = LC.JSONToShape(remoteData.data.data);}whiteboardInstance.lc.saveShape(remoteData.data.data,false,null,doNotPaint);}else if(remoteData.data.actionName && remoteData.data.actionName === "ClearAction"){whiteboardInstance.lc.clear(false,null);}break;case "clearEvent":whiteboardInstance.lc.clear(false,null);break;case "laserMarkEvent":var laserMark=whiteboardInstance.lc.containerEl.parentNode.getElementsByClassName("laser-mark")[0];switch(remoteData.data.actionName){case "show":laserMark.style.display = 'block';break;case "hide":laserMark.style.display = 'none';break;case "move":if(remoteData.data && remoteData.data.laser){var left=remoteData.data.laser.left;var _top=remoteData.data.laser.top;laserMark.style.left = left + "%";laserMark.style.top = _top + "%";}break;default:break;}break;}}}}},{key:"_productionToolDesc", /*生产标注工具的描述信息*/value:function _productionToolDesc(toolKey,toolValue){var that=this;var toolDesc={toolKey:toolKey,disabled:false};return toolDesc;}},{key:"_noticeUpdateToolDesc", /*通知白板工具更新的消息给上层*/value:function _noticeUpdateToolDesc(whiteboardInstance){if(whiteboardInstance && whiteboardInstance.isRegisterWhiteboardTool){clearTimeout(whiteboardInstance.noticeUpdateToolDescTimer);whiteboardInstance.noticeUpdateToolDescTimer = setTimeout(function(){if(whiteboardInstance.handler && whiteboardInstance.handler.noticeUpdateToolDescCallback){whiteboardInstance.handler.noticeUpdateToolDescCallback(whiteboardInstance.registerWhiteboardToolsList);}},250);}}},{key:"_updateToolDesc", /*更新标注工具的描述信息*/value:function _updateToolDesc(whiteboardInstance,toolKey,toolValue){if(whiteboardInstance.registerWhiteboardToolsList[toolKey]){var _iteratorNormalCompletion6=true;var _didIteratorError6=false;var _iteratorError6=undefined;try{for(var _iterator6=Object.entries(toolValue)[Symbol.iterator](),_step6;!(_iteratorNormalCompletion6 = (_step6 = _iterator6.next()).done);_iteratorNormalCompletion6 = true) {var _step6$value=_slicedToArray(_step6.value,2);var key=_step6$value[0];var value=_step6$value[1];if(whiteboardInstance.registerWhiteboardToolsList[toolKey][key] !== undefined){whiteboardInstance.registerWhiteboardToolsList[toolKey][key] = value;}}}catch(err) {_didIteratorError6 = true;_iteratorError6 = err;}finally {try{if(!_iteratorNormalCompletion6 && _iterator6["return"]){_iterator6["return"]();}}finally {if(_didIteratorError6){throw _iteratorError6;}}}}}},{key:"_batchUpdateToolDesc", /*批量更新工具描述*/value:function _batchUpdateToolDesc(whiteboardInstance,updateDescArray){var that=this;if(!Array.isArray(updateDescArray)){L.Logger.error('updateDescArray must be an array , whiteboard id is ' + whiteboardInstance.id + '!');return;};var _iteratorNormalCompletion7=true;var _didIteratorError7=false;var _iteratorError7=undefined;try{for(var _iterator7=updateDescArray[Symbol.iterator](),_step7;!(_iteratorNormalCompletion7 = (_step7 = _iterator7.next()).done);_iteratorNormalCompletion7 = true) {var desc=_step7.value;if(Array.isArray(desc)){that._updateToolDesc(whiteboardInstance,desc[0],desc[1]);}}}catch(err) {_didIteratorError7 = true;_iteratorError7 = err;}finally {try{if(!_iteratorNormalCompletion7 && _iterator7["return"]){_iterator7["return"]();}}finally {if(_didIteratorError7){throw _iteratorError7;}}}}},{key:"_setWhiteboardTools", /*设置白板的标注工具*/value:function _setWhiteboardTools(toolKey,whiteboardInstance){var that=this;var _setWhiteboardToolsFromInner=function _setWhiteboardToolsFromInner(whiteboardInstance){var tool=that._productionToolByCore(toolKey,whiteboardInstance);whiteboardInstance.lc.setTool(tool);};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_setWhiteboardToolsFromInner);}},{key:"_productionToolByCore", /*生产白板核心层工具，通过白板核心层来生产*/value:function _productionToolByCore(toolKey,whiteboardInstance){var that=this;var tool=undefined;if(that.useWhiteboardTool[toolKey] === undefined){L.Logger.error('The whiteboard does not have the ' + toolKey + ' tool!');return tool;}switch(toolKey){case 'tool_pencil': //笔
	tool = new LC.tools.Pencil(whiteboardInstance.lc);break;case 'tool_highlighter': //荧光笔
	tool = new LC.tools.Pencil(whiteboardInstance.lc);break;case 'tool_line': //直线
	tool = new LC.tools.Line(whiteboardInstance.lc);break;case 'tool_arrow': //箭头
	tool = new LC.tools.Line(whiteboardInstance.lc);tool.hasEndArrow = true;break;case 'tool_dashed': //虚线
	tool = new LC.tools.Line(whiteboardInstance.lc);tool.isDashed = true;break;case 'tool_eraser': //橡皮
	tool = new LC.tools.Eraser(whiteboardInstance.lc);break;case 'tool_text': //文字
	tool = new LC.tools.Text(whiteboardInstance.lc);break;case 'tool_rectangle': //矩形
	tool = new LC.tools.Rectangle(whiteboardInstance.lc);break;case 'tool_rectangle_empty': //空心矩形
	tool = new LC.tools.Rectangle(whiteboardInstance.lc);break;case 'tool_ellipse': //椭圆
	tool = new LC.tools.Ellipse(whiteboardInstance.lc);break;case 'tool_ellipse_empty': //空心椭圆
	tool = new LC.tools.Ellipse(whiteboardInstance.lc);break;case 'tool_polygon': //多边形
	tool = new LC.tools.Polygon(whiteboardInstance.lc);break;case 'tool_eyedropper': //吸管
	tool = new LC.tools.Eyedropper(whiteboardInstance.lc);break;case 'tool_selectShape': //选中拖动
	tool = new LC.tools.SelectShape(whiteboardInstance.lc);break;case 'tool_mouse': //鼠标
	tool = whiteboardInstance.lc.tool;break;case 'tool_laser': //激光笔
	tool = whiteboardInstance.lc.tool;break;default:L.Logger.warning('Tool ' + toolKey + ' is not created in the whiteboard core layer!');tool = whiteboardInstance.lc.tool;break;};return tool;}},{key:"_getWhiteboardInstanceID", /*获取白板实例id,根据id获取*/value:function _getWhiteboardInstanceID(id){var that=this;var whiteboardInstanceID=!that.uniqueWhiteboard && id != undefined && id != null?that.whiteboardInstanceIDPrefix + id:that.whiteboardInstanceDefaultID;if(id && typeof id === 'string'){var rq=new RegExp(that.specialWhiteboardInstanceIDPrefix,'g');if(rq.test(id)){whiteboardInstanceID = id;}}return whiteboardInstanceID;}},{key:"_getWhiteboardInstanceById", /*获取白板实例,根据id获取*/value:function _getWhiteboardInstanceById(id){var that=this;var whiteboardInstanceID=that._getWhiteboardInstanceID(id);var whiteboardInstance=that.whiteboardInstanceStore[whiteboardInstanceID];return whiteboardInstance;}},{key:"_getWhiteboardInstanceByID", /*获取白板实例,根据whiteboardInstanceID获取*/value:function _getWhiteboardInstanceByID(whiteboardInstanceID){var that=this;var whiteboardInstance=that.whiteboardInstanceStore[whiteboardInstanceID];return whiteboardInstance;}},{key:"_resizeWhiteboardByScalc", /*白板大小根据比例自适应*/value:function _resizeWhiteboardByScalc(whiteboardInstance){var _ref13=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var watermarkImage=_ref13.watermarkImage;var _ref13$isChangeCanvas=_ref13.isChangeCanvas;var isChangeCanvas=_ref13$isChangeCanvas === undefined?true:_ref13$isChangeCanvas;var _ref13$isChangeWatermarkScale=_ref13.isChangeWatermarkScale;var isChangeWatermarkScale=_ref13$isChangeWatermarkScale === undefined?true:_ref13$isChangeWatermarkScale;var watermarkImageScalc=_ref13.watermarkImageScalc;watermarkImageScalc = watermarkImageScalc !== undefined?watermarkImageScalc:whiteboardInstance.watermarkImageScalc;var whiteboardInstance_lc=whiteboardInstance.lc;if(whiteboardInstance_lc){var whiteboardElement=whiteboardInstance.whiteboardElement;var whiteboardInstanceElement=whiteboardInstance.whiteboardInstanceElement;var containerWidth=whiteboardInstance.containerWidthAndHeight['width'];var containerHeight=whiteboardInstance.containerWidthAndHeight['height'];if(whiteboardInstance.parcelAncestorElementId && document.getElementById(whiteboardInstance.parcelAncestorElementId)){var parcelAncestorElement=document.getElementById(whiteboardInstance.parcelAncestorElementId);containerWidth = parcelAncestorElement.clientWidth;containerHeight = parcelAncestorElement.clientHeight;}var fatherContainerConfiguration={};var width=0,height=0,minWidth=0,minHeight=0;if(containerHeight * watermarkImageScalc < containerWidth){width = Math.round(containerHeight * watermarkImageScalc * whiteboardInstance.whiteboardMagnification);height = Math.round(containerHeight * whiteboardInstance.whiteboardMagnification);whiteboardElement.style.width = width + 'px';whiteboardElement.style.height = height + 'px';whiteboardInstanceElement.style.width = width + 'px';whiteboardInstanceElement.style.height = height + 'px';if(whiteboardInstance.minHeight !== undefined && whiteboardInstance.minHeight !== null){minWidth = whiteboardInstance.minHeight * watermarkImageScalc;minHeight = whiteboardInstance.minHeight;whiteboardElement.style.minWidth = minWidth + 'px';whiteboardElement.style.minHeight = minHeight + 'px';whiteboardInstanceElement.style.minWidth = minWidth + 'px';whiteboardInstanceElement.style.minHeight = minHeight + 'px';fatherContainerConfiguration['minWidth'] = minWidth + 'px';fatherContainerConfiguration['minHegiht'] = minHeight + 'px';}fatherContainerConfiguration['top'] = 0 + '%';fatherContainerConfiguration['left'] = 50 + '%';fatherContainerConfiguration['marginTop'] = 0 + 'px';fatherContainerConfiguration['marginLeft'] = -width / 2 + 'px';fatherContainerConfiguration['width'] = width + 'px';fatherContainerConfiguration['height'] = height + 'px';}else {width = Math.round(containerWidth * whiteboardInstance.whiteboardMagnification);height = Math.round(containerWidth / watermarkImageScalc * whiteboardInstance.whiteboardMagnification);whiteboardElement.style.width = width + 'px';whiteboardElement.style.height = height + 'px';whiteboardInstanceElement.style.width = width + 'px';whiteboardInstanceElement.style.height = height + 'px';if(whiteboardInstance.minHeight !== undefined && whiteboardInstance.minHeight !== null){minWidth = whiteboardInstance.minHeight * watermarkImageScalc;minHeight = whiteboardInstance.minHeight;whiteboardElement.style.minWidth = minWidth + 'px';whiteboardElement.style.minHeight = minHeight + 'px';whiteboardInstanceElement.style.minWidth = minWidth + 'px';whiteboardInstanceElement.style.minHeight = minHeight + 'px';fatherContainerConfiguration['minWidth'] = minWidth + 'px';fatherContainerConfiguration['minHegiht'] = minHeight + 'px';}fatherContainerConfiguration['top'] = 50 + '%';fatherContainerConfiguration['left'] = 0 + '%';fatherContainerConfiguration['marginTop'] = -height / 2 + 'px';fatherContainerConfiguration['marginLeft'] = 0 + 'px';fatherContainerConfiguration['width'] = width + 'px';fatherContainerConfiguration['height'] = height + 'px';}if(isChangeCanvas){whiteboardInstance_lc.respondToSizeChange();var eleWidth=whiteboardInstanceElement.clientWidth;var eleHeight=whiteboardInstanceElement.clientHeight;var whiteboardScalc=(eleWidth + eleHeight) / (whiteboardInstance.baseWhiteboardWidth + whiteboardInstance.baseWhiteboardWidth * watermarkImageScalc);whiteboardInstance_lc.setZoom(whiteboardScalc);whiteboardInstance_lc.setPan(0,0);if(isChangeWatermarkScale && watermarkImage){var watermarkImageWidth=watermarkImage.width;var watermarkImageHeight=watermarkImage.height;var lvW=whiteboardInstance_lc.backgroundCanvas.width / watermarkImageWidth;var lvH=whiteboardInstance_lc.backgroundCanvas.height / watermarkImageHeight;var lv=(lvW + lvH) / 2;whiteboardInstance_lc.watermarkScale = lv;whiteboardInstance_lc.setWatermarkImage(watermarkImage);}}if(whiteboardInstance.whiteboardMagnification > 1){fatherContainerConfiguration.addClassName = 'custom-scroll-bar';}else {fatherContainerConfiguration.addClassName = '';}if(whiteboardInstance.handler && whiteboardInstance.handler.resizeWhiteboardSizeCallback && typeof whiteboardInstance.handler.resizeWhiteboardSizeCallback === 'function'){whiteboardInstance.handler.resizeWhiteboardSizeCallback(fatherContainerConfiguration);}}} /*清除白板的所有数据，包括存储的数据,通过whiteboardInstanceID*/},{key:"_clearWhiteboardAllDataByInstance",value:function _clearWhiteboardAllDataByInstance(whiteboardInstance){if(!whiteboardInstance){L.Logger.error('[_clear]The whiteboard instance does not exist!');return;}whiteboardInstance.lc.clear(false);whiteboardInstance.lc.redoStack.length = 0;whiteboardInstance.lc.undoStack.length = 0;whiteboardInstance.stackStorage = {}; //白板数据栈对象
	whiteboardInstance.waitingProcessShapeData = {}; //等待处理的白板数据
	}},{key:"_resizeWhiteboardHandler", /*更新白板的大小*/value:function _resizeWhiteboardHandler(whiteboardInstance){var that=this;if(whiteboardInstance && whiteboardInstance.lc){var watermarkImage=whiteboardInstance.lc.watermarkImage;if(watermarkImage && watermarkImage.src){var watermarkImageScalc=watermarkImage.width / watermarkImage.height;that._resizeWhiteboardByScalc(whiteboardInstance,{watermarkImage:watermarkImage,watermarkImageScalc:watermarkImageScalc});}else {that._resizeWhiteboardByScalc(whiteboardInstance,{isChangeWatermarkScale:false});}}}},{key:"_updateWhiteboardWatermarkImageScalc", /*更新白板的watermarkImageScalc*/value:function _updateWhiteboardWatermarkImageScalc(whiteboardInstance,watermarkImageScalc){whiteboardInstance.watermarkImageScalc = watermarkImageScalc;} /*白板事件回调处理函数:shapeSave*/},{key:"_handlerShapeSaveEvent",value:function _handlerShapeSaveEvent(whiteboardInstance,eventData){this._sendWhiteboardMessageToSignallingServer(whiteboardInstance,"shapeSaveEvent",eventData);this._actionIsDisable(whiteboardInstance);}},{key:"_handlerUndoEvent", /*白板事件回调处理函数:undo*/value:function _handlerUndoEvent(whiteboardInstance,eventData){this._sendWhiteboardMessageToSignallingServer(whiteboardInstance,"undoEvent",eventData);this._actionIsDisable(whiteboardInstance);}},{key:"_handlerRedoEvent", /*白板事件回调处理函数:redo*/value:function _handlerRedoEvent(whiteboardInstance,eventData){this._sendWhiteboardMessageToSignallingServer(whiteboardInstance,"redoEvent",eventData);this._actionIsDisable(whiteboardInstance);}},{key:"_handlerClearEvent", /*白板事件回调处理函数:clear*/value:function _handlerClearEvent(whiteboardInstance,eventData){this._sendWhiteboardMessageToSignallingServer(whiteboardInstance,"clearEvent",eventData);this._actionIsDisable(whiteboardInstance);}},{key:"_handlerDrawingChangeEvent", /*白板画了数据之后的回调函数*/value:function _handlerDrawingChangeEvent(whiteboardInstance){this._saveImageBase64ToImageThumbnail(whiteboardInstance);}},{key:"_saveImageBase64ToImageThumbnail", /*保存canvas数据到图片缩略图中*/value:function _saveImageBase64ToImageThumbnail(whiteboardInstance){if(whiteboardInstance.imageThumbnailId){var imageThumbnail=document.getElementById(whiteboardInstance.imageThumbnailId);if(imageThumbnail && imageThumbnail.nodeName.toLowerCase() === 'img'){var imageBase64Url=this._convertCanvasToImageBase64(whiteboardInstance,'jpg');imageThumbnail.src = imageBase64Url;if(whiteboardInstance.imageThumbnailTipContent && document.getElementById(whiteboardInstance.imageThumbnailId + '_imageDescribe')){document.getElementById(whiteboardInstance.imageThumbnailId + '_imageDescribe').innerHTML = whiteboardInstance.imageThumbnailTipContent;}else if(whiteboardInstance.nickname && document.getElementById(whiteboardInstance.imageThumbnailId + '_imageDescribe')){document.getElementById(whiteboardInstance.imageThumbnailId + '_imageDescribe').innerHTML = whiteboardInstance.nickname;}}}} /*销毁白板实例，通过实例whiteboardInstance*/},{key:"_destroyWhiteboardInstance",value:function _destroyWhiteboardInstance(whiteboardInstance){var that=this;clearTimeout(whiteboardInstance.noticeUpdateToolDescTimer);clearTimeout(whiteboardInstance.laserTimer);clearTimeout(whiteboardInstance.setWhiteboardWatermarkImageTimer);if(whiteboardInstance.dependenceBaseboardWhiteboardID !== undefined && !whiteboardInstance.isBaseboard && whiteboardInstance.id !== undefined){if(that.basicTemplateWhiteboardSignallingList[whiteboardInstance.dependenceBaseboardWhiteboardID]){that.saveWhiteboardStackToStorage(whiteboardInstance.id,{saveRedoStack:whiteboardInstance.saveRedoStack,saveUndoStack:whiteboardInstance.saveUndoStack});that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID] = that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID] || {};that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID][whiteboardInstance.id] = Object.assign({},whiteboardInstance.stackStorage);}else if(that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID]){that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID] = null;delete that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.dependenceBaseboardWhiteboardID];}}if(that.basicTemplateWhiteboardSignallingList[whiteboardInstance.id]){that.basicTemplateWhiteboardSignallingList[whiteboardInstance.id] = null;delete that.basicTemplateWhiteboardSignallingList[whiteboardInstance.id];}if(that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.id]){that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.id] = null;delete that.basicTemplateWhiteboardSignallingChildrenStackStorage[whiteboardInstance.id];}that._clearWhiteboardAllDataByInstance(whiteboardInstance);var whiteboardInstanceID=whiteboardInstance.whiteboardInstanceID;var whiteboardElement=whiteboardInstance.whiteboardElement;if(!whiteboardElement){L.Logger.warning('[destroy] whiteboard elements do not exist , element id is:' + whiteboardInstance.whiteboardElementId + '!');}else {whiteboardElement.innerHTML = '';}var thumbnailElement=whiteboardInstance.thumbnailId?document.getElementById(whiteboardInstance.thumbnailId):undefined;if(thumbnailElement){thumbnailElement.innerHTML = '';}var _iteratorNormalCompletion8=true;var _didIteratorError8=false;var _iteratorError8=undefined;try{for(var _iterator8=Object.keys(whiteboardInstance)[Symbol.iterator](),_step8;!(_iteratorNormalCompletion8 = (_step8 = _iterator8.next()).done);_iteratorNormalCompletion8 = true) {var key=_step8.value;whiteboardInstance[key] = null;delete whiteboardInstance[key];}}catch(err) {_didIteratorError8 = true;_iteratorError8 = err;}finally {try{if(!_iteratorNormalCompletion8 && _iterator8["return"]){_iterator8["return"]();}}finally {if(_didIteratorError8){throw _iteratorError8;}}}that.whiteboardInstanceStore[whiteboardInstanceID] = null; //白板实例
	delete that.whiteboardInstanceStore[whiteboardInstanceID];}},{key:"_clearLc", /*执行白板的clear方法*/value:function _clearLc(whiteboardInstance){var _ref14=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var _ref14$triggerEvent=_ref14.triggerEvent;var triggerEvent=_ref14$triggerEvent === undefined?true:_ref14$triggerEvent;whiteboardInstance && whiteboardInstance.lc?whiteboardInstance.lc.clear(false):L.Logger.warning('clear whiteboard is not exist!');}},{key:"_clearLcRedoStack", /*执行白板的redoStack方法*/value:function _clearLcRedoStack(whiteboardInstance){whiteboardInstance && whiteboardInstance.lc?whiteboardInstance.lc.redoStack.length = 0:L.Logger.warning('clearRedoStack whiteboard is not exist!');}},{key:"_clearLcUndoStack", /*执行白板的UndoStack方法*/value:function _clearLcUndoStack(whiteboardInstance){whiteboardInstance && whiteboardInstance.lc?whiteboardInstance.lc.undoStack.length = 0:L.Logger.warning('clearUndoStack whiteboard is not exist!');}},{key:"_showWhiteboardLoading", /*显示白板正在loading*/value:function _showWhiteboardLoading(whiteboardInstance){var that=this;if(whiteboardInstance.lc.loadingElement){whiteboardInstance.lc.loadingElement.style.display = 'block';}}},{key:"_hideWhiteboardLoading", /*隐藏白板正在loading*/value:function _hideWhiteboardLoading(whiteboardInstance){var that=this;if(whiteboardInstance.lc.loadingElement){whiteboardInstance.lc.loadingElement.style.display = 'none';}}},{key:"_changeWhiteboardTemporaryDeawPermission", /*改变白板临时可画权限*/value:function _changeWhiteboardTemporaryDeawPermission(value,whiteboardInstance){var that=this;var _handerChangeWhiteboardTemporaryDeawPermission=function _handerChangeWhiteboardTemporaryDeawPermission(whiteboardInstance){var whiteboardInstance_lc=whiteboardInstance.lc;if(whiteboardInstance_lc.isTmpDrawAble !== value){whiteboardInstance_lc.isTmpDrawAble = value;var temporaryDrawPermission=whiteboardInstance_lc.containerEl.parentNode.getElementsByClassName("temporary-draw-permission")[0];if(whiteboardInstance_lc.isTmpDrawAble){temporaryDrawPermission.className = temporaryDrawPermission.className.replace(/( yes| no)/g,"");temporaryDrawPermission.className += " yes";}else {temporaryDrawPermission.className = temporaryDrawPermission.className.replace(/( yes| no)/g,"");temporaryDrawPermission.className += " no";}}};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_handerChangeWhiteboardTemporaryDeawPermission);}},{key:"_changeWhiteboardDeawPermission", /*改变白板可画权限*/value:function _changeWhiteboardDeawPermission(value,whiteboardInstance){var that=this;var _handerChangeWhiteboardDeawPermission=function _handerChangeWhiteboardDeawPermission(whiteboardInstance){var whiteboardInstance_lc=whiteboardInstance.lc;if(whiteboardInstance_lc.isDrawAble !== value){whiteboardInstance_lc.isDrawAble = value;var drawPermission=whiteboardInstance_lc.containerEl.parentNode.getElementsByClassName("draw-permission")[0];if(whiteboardInstance_lc.isDrawAble){drawPermission.className = drawPermission.className.replace(/( yes| no)/g,"");drawPermission.className += " yes";}else {drawPermission.className = drawPermission.className.replace(/( yes| no)/g,"");drawPermission.className += " no";}}};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_handerChangeWhiteboardDeawPermission);}},{key:"_handlerActiveToolLaser", /*处理激光笔工具的激活*/value:function _handlerActiveToolLaser(toolKey,whiteboardInstance){var that=this;var _handlerActiveToolLaserFromInner=function _handlerActiveToolLaserFromInner(whiteboardInstance){var whiteboardInstance_lc=whiteboardInstance.lc;var containerElParent=whiteboardInstance_lc.containerEl.parentNode;var temporaryDrawPermission=containerElParent.getElementsByClassName("temporary-draw-permission")[0];var laserMark=containerElParent.getElementsByClassName("laser-mark")[0];if(toolKey === 'tool_laser'){that._laserEventHandler_mousemove = that._laserEventHandler_mousemove || function(e){var offset=whiteboardInnerUtils.getOffset(temporaryDrawPermission); // let offset = $(temporaryDrawPermission).offset();
	var x=e.pageX,y=e.pageY;var x1=undefined,y1=undefined;var markContainerWidth=temporaryDrawPermission.clientWidth;var markContainerHeight=temporaryDrawPermission.clientHeight;switch(whiteboardInstance.rotateDeg){case 0:x1 = x - offset.left;y1 = y - offset.top;break;case 90:x1 = y - offset.top;y1 = markContainerHeight - (x - offset.left);break;case 180:x1 = markContainerWidth - (x - offset.left);y1 = markContainerHeight - (y - offset.top);break;case 270:x1 = markContainerWidth - (y - offset.top);y1 = x - offset.left;break;default:x1 = x - offset.left;y1 = y - offset.top;break;}var left=x1 / markContainerWidth * 100;var top=y1 / markContainerHeight * 100;laserMark.style.left = left + "%";laserMark.style.top = top + "%";clearTimeout(whiteboardInstance.laserTimer);whiteboardInstance.laserTimer = setTimeout(function(){if(whiteboardInstance.laserPosition && (Math.abs(left - whiteboardInstance.laserPosition.left) > 0.3 || Math.abs(top - whiteboardInstance.laserPosition.top) > 0.3)){var parameter={laser:{left:left,top:top},action:{actionName:"move"}};whiteboardInstance.laserPosition = parameter.laser;that._sendWhiteboardMessageToSignallingServer(whiteboardInstance,"laserMarkEvent",parameter);}},100);return false;};that._laserEventHandler_mouseenter = that._laserEventHandler_mouseenter || function(e){var parameter={action:{actionName:"show"}};that._sendWhiteboardMessageToSignallingServer(whiteboardInstance,"laserMarkEvent",parameter);laserMark.style.display = 'block';return false;};that._laserEventHandler_mouseleave = that._laserEventHandler_mouseleave || function(e){var parameter={action:{actionName:"hide"}};that._sendWhiteboardMessageToSignallingServer(whiteboardInstance,"laserMarkEvent",parameter);laserMark.style.display = 'none';return false;};that._changeWhiteboardTemporaryDeawPermission(false,whiteboardInstance);whiteboardInstance.selectLaserTool = true;whiteboardInnerUtils.removeEvent(temporaryDrawPermission,'mousemove',that._laserEventHandler_mousemove);whiteboardInnerUtils.removeEvent(containerElParent,'mouseenter',that._laserEventHandler_mouseenter);whiteboardInnerUtils.removeEvent(containerElParent,'mouseleave',that._laserEventHandler_mouseleave);temporaryDrawPermission.className = temporaryDrawPermission.className.replace(/ cursor-none/g,"");temporaryDrawPermission.className += " cursor-none";whiteboardInstance.laserPosition = whiteboardInstance.laserPosition || {left:0,top:0};whiteboardInnerUtils.addEvent(temporaryDrawPermission,'mousemove',that._laserEventHandler_mousemove);whiteboardInnerUtils.addEvent(containerElParent,'mouseenter',that._laserEventHandler_mouseenter);whiteboardInnerUtils.addEvent(containerElParent,'mouseleave',that._laserEventHandler_mouseleave);}else {that._changeWhiteboardTemporaryDeawPermission(toolKey !== 'tool_mouse',whiteboardInstance);whiteboardInnerUtils.removeEvent(temporaryDrawPermission,'mousemove',that._laserEventHandler_mousemove);whiteboardInnerUtils.removeEvent(containerElParent,'mouseenter',that._laserEventHandler_mouseenter);whiteboardInnerUtils.removeEvent(containerElParent,'mouseleave',that._laserEventHandler_mouseleave);temporaryDrawPermission.className = temporaryDrawPermission.className.replace(/ cursor-none/g,"");laserMark.style.display = 'none';if(whiteboardInstance.selectLaserTool){var parameter={action:{actionName:"hide"}};that._sendWhiteboardMessageToSignallingServer(whiteboardInstance,"laserMarkEvent",parameter);whiteboardInstance.selectLaserTool = false;}}};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_handlerActiveToolLaserFromInner);}},{key:"_sendSignallingToServer", /*发送白板数据信令给服务器*/value:function _sendSignallingToServer(whiteboardInstance){var _ref15=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var idPrefix=_ref15.idPrefix;var data=_ref15.data;var signallingName=_ref15.signallingName;var assignId=_ref15.assignId;var do_not_save=_ref15.do_not_save;var expiresabs=_ref15.expiresabs;var associatedMsgID=_ref15.associatedMsgID;var associatedUserID=_ref15.associatedUserID;if(!whiteboardInstance){L.Logger.error('[_sendSignallingToServer]whiteboardInstance is not exist!');return;}if(whiteboardInstance.handler && whiteboardInstance.handler.sendSignallingToServer && typeof whiteboardInstance.handler.sendSignallingToServer === 'function'){var _whiteboardInstance$filedata2=whiteboardInstance.filedata;var currpage=_whiteboardInstance$filedata2.currpage;var fileid=_whiteboardInstance$filedata2.fileid;if(currpage === undefined || fileid === undefined){L.Logger.error('[_sendSignallingToServer]whiteboardInstance.filedata do not contain  currpage or fileid , [ currpage , fileid ]is [' + currpage + ',' + fileid + ']!');return;}if(data && typeof data === 'string'){data = JSON.parse(data);}data.whiteboardID = whiteboardInstance.id;data.isBaseboard = whiteboardInstance.isBaseboard;if(whiteboardInstance.dependenceBaseboardWhiteboardID !== undefined){data.dependenceBaseboardWhiteboardID = whiteboardInstance.dependenceBaseboardWhiteboardID;}associatedMsgID = associatedMsgID || whiteboardInstance.associatedMsgID;associatedUserID = associatedUserID || whiteboardInstance.associatedUserID;var id=assignId || idPrefix + "###_" + signallingName + "_" + fileid + "_" + currpage,toID="__allExceptSender";var copyData=Object.assign({},data);this._saveBasicTemplateWhiteboardSignallingData({signallingName:signallingName,id:id,toID:toID,data:copyData,do_not_save:do_not_save,expiresabs:expiresabs,associatedMsgID:associatedMsgID,associatedUserID:associatedUserID},'pubmsg');whiteboardInstance.handler.sendSignallingToServer(signallingName,id,toID,data,do_not_save,expiresabs,associatedMsgID,associatedUserID);}}},{key:"_delSignallingToServer", /*发送白板数据信令给服务器*/value:function _delSignallingToServer(whiteboardInstance){var _ref16=arguments.length <= 1 || arguments[1] === undefined?{}:arguments[1];var idPrefix=_ref16.idPrefix;var data=_ref16.data;var signallingName=_ref16.signallingName;var assignId=_ref16.assignId;if(!whiteboardInstance){L.Logger.error('[_delSignallingToServer]whiteboardInstance is not exist!');return;}if(whiteboardInstance.handler && whiteboardInstance.handler.delSignallingToServer && typeof whiteboardInstance.handler.delSignallingToServer === 'function'){var _whiteboardInstance$filedata3=whiteboardInstance.filedata;var currpage=_whiteboardInstance$filedata3.currpage;var fileid=_whiteboardInstance$filedata3.fileid;if(currpage === undefined || fileid === undefined){L.Logger.error('[_delSignallingToServer]whiteboardInstance.filedata do not contain  currpage or fileid , [ currpage , fileid ]is [' + currpage + ',' + fileid + ']!');return;}data.whiteboardID = whiteboardInstance.id;data.isBaseboard = whiteboardInstance.isBaseboard;if(whiteboardInstance.dependenceBaseboardWhiteboardID !== undefined){data.dependenceBaseboardWhiteboardID = whiteboardInstance.dependenceBaseboardWhiteboardID;}var id=assignId || idPrefix + "###_" + signallingName + "_" + fileid + "_" + currpage,toID="__allExceptSender";var copyData=Object.assign({},data);this._saveBasicTemplateWhiteboardSignallingData({signallingName:signallingName,id:id,toID:toID,data:copyData},'delmsg');whiteboardInstance.handler.delSignallingToServer(signallingName,id,toID,data);}}},{key:"_sendWhiteboardMessageToSignallingServer", /*发送白板消息给信令服务器*/value:function _sendWhiteboardMessageToSignallingServer(whiteboardInstance,eventType,parameter){var that=this;var idPrefix=undefined,data=undefined,signallingName=undefined,assignId=undefined,do_not_save=undefined,shapeData=undefined,testData=undefined;switch(eventType){case "shapeSaveEvent":shapeData = LC.shapeToJSON(parameter.shape);if(shapeData != null && shapeData.className != null && (shapeData.className == "LinePath" || shapeData.className == "ErasedLinePath")){shapeData.data.smoothedPointCoordinatePairs = null;delete shapeData.data.smoothedPointCoordinatePairs;var tmpData=shapeData.data.pointCoordinatePairs;tmpData.forEach(function(item){item[0] = Math.round(item[0]);item[1] = Math.round(item[1]);});}testData = {eventType:eventType,actionName:parameter.action.actionName,shapeId:parameter.shapeId,data:shapeData};idPrefix = parameter.shapeId,data = testData,signallingName = "SharpsChange",assignId = undefined,do_not_save = undefined;that._sendSignallingToServer(whiteboardInstance,{idPrefix:idPrefix,data:data,signallingName:signallingName,assignId:assignId,do_not_save:do_not_save});break;case "undoEvent":if(parameter.action.actionName === "AddShapeAction"){var shapeId=parameter.action.shapeId;testData = {eventType:eventType,actionName:parameter.action.actionName,shapeId:shapeId};idPrefix = shapeId,data = testData,signallingName = "SharpsChange",assignId = undefined;that._delSignallingToServer(whiteboardInstance,{idPrefix:idPrefix,data:data,signallingName:signallingName,assignId:assignId});}else if(parameter.action.actionName === "ClearAction"){var _clearActionId=parameter.action.id;testData = {eventType:eventType,actionName:parameter.action.actionName,clearActionId:_clearActionId};idPrefix = _clearActionId,data = testData,signallingName = "SharpsChange",assignId = undefined;that._delSignallingToServer(whiteboardInstance,{idPrefix:idPrefix,data:data,signallingName:signallingName,assignId:assignId});}break;case "redoEvent":if(parameter.action.actionName === "AddShapeAction"){shapeData = LC.shapeToJSON(parameter.action.shape);if(shapeData != null && shapeData.className != null && (shapeData.className == "LinePath" || shapeData.className == "ErasedLinePath")){shapeData.data.smoothedPointCoordinatePairs = null;delete shapeData.data.smoothedPointCoordinatePairs;var tmpData=shapeData.data.pointCoordinatePairs;tmpData.forEach(function(item){item[0] = Math.round(item[0]);item[1] = Math.round(item[1]);});};var shapeId=parameter.action.shapeId;testData = {eventType:eventType,actionName:parameter.action.actionName,shapeId:shapeId,data:shapeData};var _idPrefix=shapeId,_data=testData,_signallingName="SharpsChange",_assignId=undefined,_do_not_save=undefined;that._sendSignallingToServer(whiteboardInstance,{idPrefix:_idPrefix,data:_data,signallingName:_signallingName,assignId:_assignId,do_not_save:_do_not_save});}else if(parameter.action.actionName === "ClearAction"){var _clearActionId2=parameter.action.id;testData = {eventType:eventType,actionName:parameter.action.actionName,clearActionId:_clearActionId2};idPrefix = _clearActionId2,data = testData,signallingName = "SharpsChange",assignId = undefined,do_not_save = undefined;that._sendSignallingToServer(whiteboardInstance,{idPrefix:idPrefix,data:data,signallingName:signallingName,assignId:assignId,do_not_save:do_not_save});}break;case "clearEvent":var clearActionId=parameter.clearActionId;testData = {eventType:eventType,actionName:parameter.action.actionName,clearActionId:clearActionId};idPrefix = clearActionId,data = testData,signallingName = "SharpsChange",assignId = undefined,do_not_save = undefined;that._sendSignallingToServer(whiteboardInstance,{idPrefix:idPrefix,data:data,signallingName:signallingName,assignId:assignId,do_not_save:do_not_save});break;case "laserMarkEvent":var laserMarkId="laserMarkEvent";testData = {eventType:eventType,actionName:parameter.action.actionName};if(parameter && parameter.laser){testData.laser = parameter.laser;}idPrefix = laserMarkId,data = testData,signallingName = "SharpsChange",assignId = undefined,do_not_save = true;that._sendSignallingToServer(whiteboardInstance,{idPrefix:idPrefix,data:data,signallingName:signallingName,assignId:assignId,do_not_save:do_not_save});break;};}},{key:"_updateTextFont", /*更新白板字体*/value:function _updateTextFont(whiteboardInstance){ /*：font-style | font-variant | font-weight | font-size | line-height | font-family */ /*
	         font:italic small-caps bold 12px/1.5em arial,verdana;  （注：简写时，font-size和line-height只能通过斜杠/组成一个值，不能分开写。）
	         等效于：
	         font-style:italic;
	         font-variant:small-caps;
	         font-weight:bold;
	         font-size:12px;
	         line-height:1.5em;
	         font-family:arial,verdana;
	         */var that=this;var _updateTextFontFromInner=function _updateTextFontFromInner(whiteboardInstance){var fontSize=whiteboardInstance.whiteboardToolsInfo.fontSize,fontFamily=whiteboardInstance.whiteboardToolsInfo.fontFamily,fontStyle=whiteboardInstance.whiteboardToolsInfo.fontStyle,fontWeight=whiteboardInstance.whiteboardToolsInfo.fontWeight;var tool=whiteboardInstance.lc.tool;if(tool.name == "Text"){tool.font = fontStyle + " " + fontWeight + " " + fontSize + "px " + fontFamily;}};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_updateTextFontFromInner);}},{key:"_updateEraserWidth", /*更新橡皮宽度*/value:function _updateEraserWidth(whiteboardInstance){var that=this;var _updateEraserWidthFromInner=function _updateEraserWidthFromInner(whiteboardInstance){var eraserWidth=whiteboardInstance.whiteboardToolsInfo.eraserWidth;whiteboardInstance.lc.trigger('setStrokeWidth',eraserWidth);};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_updateEraserWidthFromInner);}},{key:"_updatePencilWidth", /*更新画笔的宽度*/value:function _updatePencilWidth(whiteboardInstance){var that=this;var _updatePencilWidthFromInner=function _updatePencilWidthFromInner(whiteboardInstance){var pencilWidth=whiteboardInstance.whiteboardToolsInfo.pencilWidth;whiteboardInstance.lc.trigger('setStrokeWidth',pencilWidth);};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_updatePencilWidthFromInner);}},{key:"_updateShapeWidth", /*更新形状的宽度*/value:function _updateShapeWidth(whiteboardInstance){var that=this;var _updateShapeWidthFromInner=function _updateShapeWidthFromInner(whiteboardInstance){var shapeWidth=whiteboardInstance.whiteboardToolsInfo.shapeWidth;whiteboardInstance.lc.trigger('setStrokeWidth',shapeWidth);};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_updateShapeWidthFromInner);}},{key:"_updateColor", /*更新颜色*/value:function _updateColor(whiteboardInstance,colorJson){var that=this;if(colorJson && typeof colorJson === 'object'){var _updateColorFromInner=function _updateColorFromInner(whiteboardInstance){var _iteratorNormalCompletion9=true;var _didIteratorError9=false;var _iteratorError9=undefined;try{for(var _iterator9=Object.keys(colorJson)[Symbol.iterator](),_step9;!(_iteratorNormalCompletion9 = (_step9 = _iterator9.next()).done);_iteratorNormalCompletion9 = true) {var key=_step9.value;whiteboardInstance.lc.setColor(key,whiteboardInstance.whiteboardToolsInfo[key + "Color"]);if(key === "primary" && whiteboardInstance.activeTool === 'tool_highlighter'){var color=whiteboardInstance.whiteboardToolsInfo[key + "Color"].colorRgb().toLowerCase().replace("rgb","rgba").replace(")",",0.5)");whiteboardInstance.lc.setColor(key,color);}}}catch(err) {_didIteratorError9 = true;_iteratorError9 = err;}finally {try{if(!_iteratorNormalCompletion9 && _iterator9["return"]){_iterator9["return"]();}}finally {if(_didIteratorError9){throw _iteratorError9;}}}};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_updateColorFromInner);}}},{key:"_actionIsDisable", /*undo、redo、clear等动作是否禁用*/value:function _actionIsDisable(whiteboardInstance){var that=this;var _actionIsDisableFromInnner=function _actionIsDisableFromInnner(whiteboardInstance){if(whiteboardInstance.active){ //如果白板处于激活动态
	if(whiteboardInstance.lc.shapes.length === 0){ //白板没有画笔数据
	var updateDescArray=[['action_clear',{disabled:true}],['tool_eraser',{disabled:true}],['tool_eyedropper',{disabled:true}]];that._batchUpdateToolDesc(whiteboardInstance,updateDescArray);that._noticeUpdateToolDesc(whiteboardInstance);}else {var updateDescArray=[['action_clear',{disabled:false}],['tool_eraser',{disabled:false}],['tool_eyedropper',{disabled:false}]];that._batchUpdateToolDesc(whiteboardInstance,updateDescArray);that._noticeUpdateToolDesc(whiteboardInstance);}if(!whiteboardInstance.lc.canRedo()){ //不能够redo
	that._updateToolDesc(whiteboardInstance,'action_redo',{disabled:true});that._noticeUpdateToolDesc(whiteboardInstance);}else {that._updateToolDesc(whiteboardInstance,'action_redo',{disabled:false});that._noticeUpdateToolDesc(whiteboardInstance);}if(!whiteboardInstance.lc.canUndo()){ //不能够undo
	that._updateToolDesc(whiteboardInstance,'action_undo',{disabled:true});that._noticeUpdateToolDesc(whiteboardInstance);}else {that._updateToolDesc(whiteboardInstance,'action_undo',{disabled:false});that._noticeUpdateToolDesc(whiteboardInstance);}}};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_actionIsDisableFromInnner);}},{key:"_zoomIsDisable", /*白板缩放比例决定其描述信息*/value:function _zoomIsDisable(whiteboardInstance){var that=this;var _zoomIsDisableFromInnner=function _zoomIsDisableFromInnner(whiteboardInstance){if(whiteboardInstance.active){ //如果白板处于激活动态
	if(whiteboardInstance.whiteboardMagnification <= that.minMagnification){var updateDescArray=[['zoom_small',{disabled:true}],['zoom_default',{disabled:true}]];that._batchUpdateToolDesc(whiteboardInstance,updateDescArray);that._noticeUpdateToolDesc(whiteboardInstance);}else {var updateDescArray=[['zoom_small',{disabled:false}],['zoom_default',{disabled:false}]];that._batchUpdateToolDesc(whiteboardInstance,updateDescArray);that._noticeUpdateToolDesc(whiteboardInstance);}if(whiteboardInstance.whiteboardMagnification >= that.maxMagnification){that._updateToolDesc(whiteboardInstance,'zoom_big',{disabled:true});that._noticeUpdateToolDesc(whiteboardInstance);}else {that._updateToolDesc(whiteboardInstance,'zoom_big',{disabled:false});that._noticeUpdateToolDesc(whiteboardInstance);}}};that._automaticTraverseWhiteboardInstance(whiteboardInstance,_zoomIsDisableFromInnner);}},{key:"_automaticTraverseWhiteboardInstance", /*自动遍历白板实例，如果实例没有则遍历所有实例执行处理*/value:function _automaticTraverseWhiteboardInstance(whiteboardInstance,callback){var that=this;if(whiteboardInstance){if(callback && typeof callback === 'function'){callback(whiteboardInstance);}}else {var _iteratorNormalCompletion10=true;var _didIteratorError10=false;var _iteratorError10=undefined;try{for(var _iterator10=Object.values(that.whiteboardInstanceStore)[Symbol.iterator](),_step10;!(_iteratorNormalCompletion10 = (_step10 = _iterator10.next()).done);_iteratorNormalCompletion10 = true) {var _whiteboardInstance=_step10.value;if(callback && typeof callback === 'function'){callback(_whiteboardInstance);}}}catch(err) {_didIteratorError10 = true;_iteratorError10 = err;}finally {try{if(!_iteratorNormalCompletion10 && _iterator10["return"]){_iterator10["return"]();}}finally {if(_didIteratorError10){throw _iteratorError10;}}}}}},{key:"_saveAwaitSaveToWhiteboardInstanceSignallingToWhiteboardInstance", /*保存等待的白板信令数据到相应的白板实例中*/value:function _saveAwaitSaveToWhiteboardInstanceSignallingToWhiteboardInstance(whiteboardInstance){var isClear=false;for(var i=0;i < this.awaitSaveToWhiteboardInstanceSignallingArray.length;i++) {var waitingProcessData=this.awaitSaveToWhiteboardInstanceSignallingArray[i];if(waitingProcessData.data && typeof waitingProcessData.data === 'string'){waitingProcessData.data = JSON.parse(waitingProcessData.data);}if(waitingProcessData.data.whiteboardID === whiteboardInstance.id){var shapeName=waitingProcessData.id.substring(waitingProcessData.id.lastIndexOf("###_") + 4);if(whiteboardInstance.waitingProcessShapeData[shapeName] == null || whiteboardInstance.waitingProcessShapeData[shapeName] == undefined){whiteboardInstance.waitingProcessShapeData[shapeName] = [];whiteboardInstance.waitingProcessShapeData[shapeName].push(waitingProcessData);}else {whiteboardInstance.waitingProcessShapeData[shapeName].push(waitingProcessData);}isClear = true;this.awaitSaveToWhiteboardInstanceSignallingArray.splice(i,1,null);}}if(isClear){for(var i=this.awaitSaveToWhiteboardInstanceSignallingArray.length - 1;i >= 0;i--) {if(this.awaitSaveToWhiteboardInstanceSignallingArray[i] === null){this.awaitSaveToWhiteboardInstanceSignallingArray.splice(i,1);}}}}},{key:"_basicTemplateWhiteboardSignallingListToWhiteboardInstance", /*模板数据保存到*/value:function _basicTemplateWhiteboardSignallingListToWhiteboardInstance(whiteboardInstance){if(whiteboardInstance.needLooadBaseboard && !whiteboardInstance.isBaseboard && whiteboardInstance.dependenceBaseboardWhiteboardID !== undefined && !whiteboardInstance.isHandleBasicTemplateWhiteboardSignallingList && whiteboardInstance.id !== whiteboardInstance.dependenceBaseboardWhiteboardID && this.basicTemplateWhiteboardSignallingList[whiteboardInstance.dependenceBaseboardWhiteboardID] && Array.isArray(this.basicTemplateWhiteboardSignallingList[whiteboardInstance.dependenceBaseboardWhiteboardID])){this._batchReceiveSnapshot(this.basicTemplateWhiteboardSignallingList[whiteboardInstance.dependenceBaseboardWhiteboardID],whiteboardInstance);whiteboardInstance.isHandleBasicTemplateWhiteboardSignallingList = true;}}},{key:"_convertCanvasToImage", /*从 canvas 提取图片 image*/value:function _convertCanvasToImage(whiteboardInstance){var type=arguments.length <= 1 || arguments[1] === undefined?'png':arguments[1];if(whiteboardInstance && whiteboardInstance.lc && whiteboardInstance.lc.canvas){var canvas=whiteboardInstance.lc.canvas; //新Image对象，可以理解为DOM
	var image=new Image(); // canvas.toDataURL 返回的是一串Base64编码的URL，当然,浏览器自己肯定支持
	image.src = canvas.toDataURL("image/" + type); // 指定格式 PNG
	return image;}}},{key:"_convertCanvasToImageBase64", /*从 canvas 提取图片 image base64*/value:function _convertCanvasToImageBase64(whiteboardInstance,type){if(whiteboardInstance && whiteboardInstance.lc && whiteboardInstance.lc.canvas){var canvas=whiteboardInstance.lc.canvas; // canvas.toDataURL 返回的是一串Base64编码的URL，当然,浏览器自己肯定支持
	var imgBase64=canvas.toDataURL("image/" + type); // 指定格式 PNG
	return imgBase64;}}},{key:"_saveBasicTemplateWhiteboardSignallingData", /*保存基础模板数据*/value:function _saveBasicTemplateWhiteboardSignallingData(signallingData,source){if(signallingData.data.isBaseboard){if(signallingData && signallingData.data){if(signallingData.data.isBaseboard && signallingData.data.whiteboardID !== undefined){signallingData.source = source;this.basicTemplateWhiteboardSignallingList[signallingData.data.whiteboardID] = this.basicTemplateWhiteboardSignallingList[signallingData.data.whiteboardID] || [];this.basicTemplateWhiteboardSignallingList[signallingData.data.whiteboardID].push(signallingData);}}}}}]);return HandlerWhiteboardAndCore;})();;var HandlerWhiteboardAndCoreInstance=new HandlerWhiteboardAndCore();exports["default"] = HandlerWhiteboardAndCoreInstance;module.exports = exports["default"];

/***/ }),

/***/ 120:
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {/**
	 * 工具服务
	 * @module serviceTools
	 * @description   提供 工具服务
	 * @author QiuShao
	 * @date 2017/7/10
	 */
	'use strict';
	
	Object.defineProperty(exports, '__esModule', {
	  value: true
	});
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var ServiceTools = {
	  /*获取语言包数据
	   @method getAppLanguageInfo
	   @param {string} languageName 语言名字*/
	  getAppLanguageInfo: function getAppLanguageInfo(callback, languageName) {
	    var lang = languageName ? languageName : _TkGlobal2['default'].languageName; //默认语言
	    var languageInfo = {};
	    _TkGlobal2['default'].language = _TkGlobal2['default'].language || {};
	    /*获取语言数据*/
	    languageInfo.name = lang;
	    languageInfo.languageData = __webpack_require__(627)("./i18_" + lang + '.js');
	    if (callback && typeof callback === "function") {
	      callback(languageInfo);
	    }
	    $(document.body).removeClass("chinese english complex").addClass(languageInfo.name).attr("data-language", languageInfo.name);
	  },
	  TkUtils: _TkUtils2['default']
	};
	
	exports['default'] = ServiceTools;
	module.exports = exports['default'];
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(41)))

/***/ }),

/***/ 121:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 提示框服务
	 * @module ServiceTooltip
	 * @description  提供 提示框的相关服务
	 * @author QiuShao
	 * @date 2017/08/07
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var Tooltip = {
	    showAlert: function showAlert(msg, _callback) {
	        _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'showAlert', message: { data: {
	                    title: msg.title,
	                    message: msg.message,
	                    ok: msg.ok,
	                    callback: function callback(answer) {
	                        if (_callback && typeof _callback === "function") {
	                            _callback(answer);
	                        }
	                    }
	                } } });
	    },
	    showConfirm: function showConfirm(msg, _callback2) {
	        _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'showConfirm', message: { data: {
	                    title: msg.title,
	                    message: msg.message,
	                    isOk: {
	                        cancel: msg.button.cancel,
	                        ok: msg.button.ok
	                    },
	                    callback: function callback(answer) {
	                        if (_callback2 && typeof _callback2 === "function") {
	                            _callback2(answer);
	                        }
	                    }
	                } } });
	        /*LxNotificationService.confirm(msg.title, msg.message, {
	                cancel: msg.button.cancel,
	                ok: msg.button.ok
	            },
	            function(answer) {
	                if(callback && typeof callback === "function") {
	                    callback(answer);
	                }
	            }
	        );*/
	    }
	};
	var ServiceTooltip = {
	    /*显示错误提示框*/
	    showError: function showError(errorMessage, callback, title, ok) {
	        var e = {
	            message: errorMessage,
	            title: title ? title : _TkGlobal2['default'].language.languageData.alertWin.title.showError.text,
	            ok: ok ? ok : _TkGlobal2['default'].language.languageData.alertWin.ok.showError.text
	        };
	        Tooltip.showAlert(e, callback);
	    },
	
	    /*显示正常提示框*/
	    showPrompt: function showPrompt(tipMessage, callback, title, ok) {
	        var msg = {
	            message: tipMessage,
	            title: title ? title : _TkGlobal2['default'].language.languageData.alertWin.title.showPrompt.text,
	            ok: ok ? ok : _TkGlobal2['default'].language.languageData.alertWin.ok.showPrompt.text
	        };
	        Tooltip.showAlert(msg, callback);
	    },
	
	    /*显示确认对话框*/
	    showConfirm: function showConfirm(confirmMessage, confirmCallback, title, ok, cancel) {
	        var msg = {
	            title: title ? title : _TkGlobal2['default'].language.languageData.alertWin.title.showConfirm.text,
	            button: {
	                cancel: cancel ? cancel : _TkGlobal2['default'].language.languageData.alertWin.ok.showConfirm.cancel,
	                ok: ok ? ok : _TkGlobal2['default'].language.languageData.alertWin.ok.showConfirm.ok
	            },
	            message: confirmMessage
	        };
	        Tooltip.showConfirm(msg, confirmCallback);
	    }
	};
	exports['default'] = ServiceTooltip;
	module.exports = exports['default'];

/***/ }),

/***/ 122:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * TK权限控制类
	 * @class TkAppPermissions
	 * @description   提供 TK系统所需的权限控制
	 * @author QiuShao
	 * @date 2017/08/08
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var TkAppPermissions = (function () {
	    function TkAppPermissions() {
	        _classCallCheck(this, TkAppPermissions);
	
	        this.permissionsJson = this.productionDefaultAppAppPermissions();
	    }
	
	    _createClass(TkAppPermissions, [{
	        key: 'productionDefaultAppAppPermissions',
	        value: function productionDefaultAppAppPermissions() {
	            var defaultAppPermissions = {
	                canDraw: false, //画笔权限
	                whiteboardPagingPage: false, //白板翻页权限
	                newpptPagingPage: false, //动态ppt翻页权限
	                h5DocumentPagingPage: false, //h5课件翻页权限
	                h5DocumentActionClick: false, //h5课件点击动作的权限
	                dynamicPptActionClick: false, //动态PPT点击动作的权限
	                pubMsg: true, //pubMsg 信令权限
	                delMsg: true, //delMsg 信令权限
	                setProperty: true, //setProperty 信令权限
	                setParticipantPropertyToAll: true, //setParticipantPropertyToAll 设置参与者属性发送给所有人权限
	                sendSignallingDataToParticipant: true, //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	                sendSignallingFromWBPageCount: false, //发送白板加页相关的信令权限
	                sendSignallingFromSharpsChange: false, //发送白板数据相关的信令权限
	                sendSignallingFromShowPage: false, //发送ShowPage相关的信令权限
	                sendSignallingFromDynamicPptShowPage: false, //发送动态PPT的ShowPage相关数据权限
	                sendSignallingFromH5ShowPage: false, //发送H5文档的ShowPage相关数据权限
	                sendSignallingFromGeneralShowPage: false, //发送普通文档的ShowPage相关数据权限
	                sendSignallingFromDynamicPptTriggerActionClick: false, //发送动态PPT触发器NewPptTriggerActionClick相关的信令权限
	                sendSignallingFromH5DocumentAction: false, //发送h5文档相关动作的信令权限
	                sendSignallingFromVideoDraghandle: false, //拖拽的信令权限
	                sendSignallingFromBlackBoardDrag: false, //小黑板拖拽的信令权限
	                allUserTools: false, //教学工具的权限
	                laser: false, //激光笔权限
	                publishDynamicPptMediaPermission_video: false, //发布动态PPT视频的权限
	                sendWhiteboardMarkTool: false, //发送标注工具信令权限
	                jumpPage: false, //能否输入页数跳转到指定文档页权限
	                sendSignallingFromBlackBoard: false, //发送多黑板信令的权限
	                sendSignallingTimerToStudent: false, //老师教课工具倒计时信令权限
	                sendSignallingDialToStudent: false, //转盘的信令权限
	                sendSignallingDataStudentToTeacherAnswer: true, //学生发送数据
	                studentInit: false, //学生的初始权限
	                dialIconClose: false, //转盘图标关闭的初始权限
	                sendSignallingAnswerToStudent: false, //发送选项给学生的信令权限
	                sendSignallingQiangDaQi: false, //抢答器发送的信令
	                sendSignallingQiangDaZhe: true, //抢答者发送的信令
	                sendSignallingFromDialDrag: false, //转盘拖拽的动作相关信令
	                isSendSignallingFromTimerDrag: false, //计时器拖拽的相关信令
	                isSendSignallingFromAnswerDrag: false, //答题卡拖拽的相关信令
	                isSendSignallingFromResponderDrag: false }; //权限存储json
	            //抢答器拖拽的相关信令
	            return defaultAppPermissions;
	        }
	
	        /*重置默认的权限*/
	    }, {
	        key: 'resetDefaultAppPermissions',
	        value: function resetDefaultAppPermissions() {
	            var isSendReset = arguments.length <= 0 || arguments[0] === undefined ? true : arguments[0];
	
	            var that = this;
	            that.permissionsJson = that.productionDefaultAppAppPermissions();
	            if (isSendReset) {
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                    // type:'resetDefaultAppPermissions',
	                    type: 'initAppPermissions',
	                    message: {
	                        data: that.permissionsJson
	                    }
	                });
	            }
	        }
	    }, {
	        key: 'resetAppPermissions',
	
	        /*重置权限*/
	        value: function resetAppPermissions(appPermissions) {
	            var isSendReset = arguments.length <= 1 || arguments[1] === undefined ? true : arguments[1];
	
	            var that = this;
	            if (appPermissions && typeof appPermissions === 'object') {
	                Object.assign(that.permissionsJson, appPermissions);
	                if (isSendReset) {
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                        type: 'resetAppPermissions',
	                        message: {
	                            data: that.permissionsJson
	                        }
	                    });
	                }
	            }
	        }
	    }, {
	        key: 'setAppPermissions',
	
	        /*设置（更新）权限
	        *@method updateAppPermissions
	        *@params [appPermissionsKey:string , appPermissionsValue:any ] */
	        value: function setAppPermissions(appPermissionsKey, appPermissionsValue) {
	            var that = this;
	            if (that.permissionsJson[appPermissionsKey] !== appPermissionsValue) {
	                L.Logger.debug('setAppPermissions key and value:', appPermissionsKey, appPermissionsValue, 'old appPermissions:', that.permissionsJson[appPermissionsKey]);
	                that.permissionsJson[appPermissionsKey] = appPermissionsValue;
	                var updateAppPermissionsEventData = {
	                    type: 'updateAppPermissions_' + appPermissionsKey,
	                    message: {
	                        key: appPermissionsKey,
	                        value: appPermissionsValue
	                    }
	                };
	                _eventObjectDefine2['default'].CoreController.dispatchEvent(updateAppPermissionsEventData);
	            }
	        }
	    }, {
	        key: 'getAppPermissions',
	
	        /*设置（更新）权限
	         *@method updateAppPermissions
	         *@params [appPermissionsKey:string] */
	        value: function getAppPermissions(appPermissionsKey) {
	            var that = this;
	            return that.permissionsJson[appPermissionsKey];
	        }
	    }, {
	        key: 'initAppPermissions',
	
	        /*初始化权限
	         *@method initAppPermissions
	         *@params [initAppPermissionsJson:json] */
	        value: function initAppPermissions(initAppPermissionsJson) {
	            L.Logger.debug('initAppPermissions data:', initAppPermissionsJson);
	            var that = this;
	            for (var appPermissionsKey in initAppPermissionsJson) {
	                that.permissionsJson[appPermissionsKey] = initAppPermissionsJson[appPermissionsKey];
	            }
	            Object.assign(that.permissionsJson, initAppPermissionsJson);
	            that.permissionsJson = initAppPermissionsJson;
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                type: 'initAppPermissions',
	                message: {
	                    data: that.permissionsJson
	                }
	            });
	        }
	    }]);
	
	    return TkAppPermissions;
	})();
	
	;
	var TkAppPermissionsInstance = new TkAppPermissions();
	exports['default'] = TkAppPermissionsInstance;
	module.exports = exports['default'];

/***/ }),

/***/ 252:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 右侧内容-文档翻页等工具Smart组件
	 * @module PagingToolBarSmart
	 * @description   承载右侧内容-文档翻页等工具的所有Smart组件
	 * @author QiuShao
	 * @date 2017/08/14
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceTooltip = __webpack_require__(121);
	
	var _ServiceTooltip2 = _interopRequireDefault(_ServiceTooltip);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _reactDraggable = __webpack_require__(58);
	
	var _reactDraggable2 = _interopRequireDefault(_reactDraggable);
	
	var PagingToolBarSmart = (function (_React$Component) {
	    _inherits(PagingToolBarSmart, _React$Component);
	
	    function PagingToolBarSmart(props) {
	        _classCallCheck(this, PagingToolBarSmart);
	
	        _get(Object.getPrototypeOf(PagingToolBarSmart.prototype), 'constructor', this).call(this, props);
	        this.whiteboardJson = {
	            disabled: {
	                prevPage: true,
	                nextPage: true,
	                addPage: true
	            },
	            page: {
	                currpage: 1,
	                totalpage: 1
	            },
	            temporaryDisabled: {
	                prevPage: false,
	                nextPage: false,
	                addPage: false
	            },
	            show: {
	                prevPage: true,
	                nextPage: true,
	                addPage: false
	            },
	            onClick: {
	                prevPage: this.whiteboardPrevPageClick.bind(this),
	                nextPage: this.whiteboardNextPageClick.bind(this),
	                addPage: this.whiteboardAddPageClick.bind(this),
	                fullScreen: this.fullScreenClick.bind(this)
	            }
	        };
	        this.newpptJson = {
	            disabled: {
	                prevPage: true,
	                nextPage: true,
	                addPage: true
	            },
	            page: {
	                currpage: 1,
	                totalpage: 1
	            },
	            temporaryDisabled: {
	                prevPage: false,
	                nextPage: false,
	                addPage: false
	            },
	            show: {
	                prevPage: true,
	                nextPage: true,
	                addPage: false
	            },
	            onClick: {
	                prevPage: this.newpptPrevStepClick.bind(this),
	                nextPage: this.newpptNextStepClick.bind(this),
	                addPage: undefined,
	                fullScreen: this.fullScreenClick.bind(this)
	            }
	        };
	        this.h5DocumentJson = {
	            disabled: {
	                prevPage: true,
	                nextPage: true,
	                addPage: true
	            },
	            page: {
	                currpage: 1,
	                totalpage: 1
	            },
	            temporaryDisabled: {
	                prevPage: false,
	                nextPage: false,
	                addPage: false
	            },
	            show: {
	                prevPage: true,
	                nextPage: true,
	                addPage: false
	            },
	            onClick: {
	                prevPage: this.h5DocumentPrevStepClick.bind(this),
	                nextPage: this.h5DocumentNextStepClick.bind(this),
	                addPage: undefined,
	                fullScreen: this.fullScreenClick.bind(this)
	            }
	        };
	        this.state = {
	            jumpPage: _CoreController2['default'].handler.getAppPermissions('jumpPage'),
	            fileTypeMark: 'general',
	            isFullScreen: false,
	            pagingDesc: this._getPaddingDesc('general'),
	            registerWhiteboardToolsList: {
	                zoom_small: {
	                    toolKey: 'zoom_small',
	                    disabled: false
	                },
	                zoom_big: {
	                    toolKey: 'zoom_big',
	                    disabled: false
	                }
	            }
	        };
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	    }
	
	    _createClass(PagingToolBarSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            _eventObjectDefine2['default'].Document.addEventListener(_TkConstant2['default'].EVENTTYPE.DocumentEvent.onKeydown, that.handlerOnKeydown.bind(that), that.listernerBackupid); //document.keydown事件
	            _eventObjectDefine2['default'].Document.addEventListener(_TkConstant2['default'].EVENTTYPE.DocumentEvent.onFullscreenchange, that.handlerOnFullscreenchange.bind(that), that.listernerBackupid); //document.onFullscreenchange事件
	            _eventObjectDefine2['default'].CoreController.addEventListener('changeFileTypeMark', that.handlerChangeFileTypeMark.bind(that), that.listernerBackupid); //设置翻页栏属于普通文档还是动态PPT
	            _eventObjectDefine2['default'].CoreController.addEventListener('updatePagdingState', that.handlerUpdatePagdingState.bind(that), that.listernerBackupid); //更新翻页状态事件
	            _eventObjectDefine2['default'].CoreController.addEventListener('initAppPermissions', that.handlerInitAppPermissions.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener('updateAppPermissions_jumpPage', that.handlerUpdateAppPermissions_jumpPage.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener('commonWhiteboardTool_noticeUpdateToolDesc', that.handlerCommonWhiteboardTool_noticeUpdateToolDesc.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener('mobileSdk_fullScreenChangeCallback', that.handlerMobileSdk_fullScreenChangeCallback.bind(that), that.listernerBackupid);
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	            _eventObjectDefine2['default'].Document.removeBackupListerner(that.listernerBackupid);
	            clearTimeout(that.keydownTimer);
	        }
	    }, {
	        key: 'handlerOnKeydown',
	        value: function handlerOnKeydown(recvEventData) {
	            var that = this;
	            if (_TkGlobal2['default'].playPptVideoing || _TkGlobal2['default'].playMediaFileing || _TkGlobal2['default'].isSkipPageing) {
	                //正在播放动态ppt视频或者播放媒体文件，不能执行键盘翻页事件
	                return;
	            }
	            var keyCode = recvEventData.message.keyCode;
	
	            clearTimeout(that.keydownTimer);
	            that.keydownTimer = setTimeout(function () {
	                if (that.state.fileTypeMark === 'general') {
	                    if (_CoreController2['default'].handler.getAppPermissions('whiteboardPagingPage')) {
	                        switch (keyCode) {
	                            case 37:
	                                //左键
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'lcTextEditing', message: { callback: function callback(lcTextEditing) {
	                                            if (!lcTextEditing) {
	                                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboardPrevPage' }); //通知白板执行了翻页：上一页
	                                            }
	                                        } } });
	                                break;
	                            case 39:
	                                //右键
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'lcTextEditing', message: { callback: function callback(lcTextEditing) {
	                                            if (!lcTextEditing) {
	                                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboardNextPage' }); //通知白板执行了翻页：下一页
	                                            }
	                                        } } });
	                                break;
	                        }
	                    }
	                } else if (that.state.fileTypeMark === 'dynamicPPT') {
	                    if (_CoreController2['default'].handler.getAppPermissions('newpptPagingPage')) {
	                        switch (keyCode) {
	                            case 39:
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'lcTextEditing', message: { callback: function callback(lcTextEditing) {
	                                            if (!lcTextEditing) {
	                                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'newpptNextSlideClick' }); //通知动态PPT执行下一页
	                                            }
	                                        } } });
	                                break;
	                            case 37:
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'lcTextEditing', message: { callback: function callback(lcTextEditing) {
	                                            if (!lcTextEditing) {
	                                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'newpptPrevSlideClick' }); //通知动态PPT执行上一页
	                                            }
	                                        } } });
	                                break;
	                            case 38:
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'newpptPrevStepClick' }); //通知动态PPT执行上一帧
	                                break;
	                            case 40:
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'newpptNextStepClick' }); //通知动态PPT执行下一帧
	                                break;
	                        }
	                    }
	                } else if (that.state.fileTypeMark === 'h5document') {
	                    if (_CoreController2['default'].handler.getAppPermissions('h5DocumentPagingPage')) {
	                        switch (keyCode) {
	                            case 37:
	                                //左键
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'lcTextEditing', message: { callback: function callback(lcTextEditing) {
	                                            if (!lcTextEditing) {
	                                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'h5DocumentPageUpClick' }); //通知h5文件执行下上一页
	                                            }
	                                        } } });
	                                break;
	                            case 39:
	                                //右键
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'lcTextEditing', message: { callback: function callback(lcTextEditing) {
	                                            if (!lcTextEditing) {
	                                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'h5DocumentPageDownClick' }); //通知h5文件执行下一页
	                                            }
	                                        } } });
	                                break;
	                        }
	                    }
	                }
	            }, 250);
	        }
	    }, {
	        key: 'handlerChangeFileTypeMark',
	        value: function handlerChangeFileTypeMark(recvEventData) {
	            this.setState({ fileTypeMark: recvEventData.message.fileTypeMark });
	            this.setState({ pagingDesc: this._getPaddingDesc(recvEventData.message.fileTypeMark) });
	        }
	    }, {
	        key: 'handlerUpdatePagdingState',
	        value: function handlerUpdatePagdingState(recvEventData) {
	            var that = this;
	            var message = recvEventData.message;
	            if (message.source === 'whiteboard') {
	                var tmpWhiteboardDesc = {
	                    disabled: {
	                        prevPage: !(_CoreController2['default'].handler.getAppPermissions('whiteboardPagingPage') && message.data.currpage > 1),
	                        nextPage: !(_CoreController2['default'].handler.getAppPermissions('whiteboardPagingPage') && message.data.currpage < message.data.pagenum),
	                        addPage: !(_CoreController2['default'].handler.getAppPermissions('sendSignallingFromWBPageCount') && message.data.currpage === message.data.pagenum && message.data.fileid === 0)
	                    },
	                    page: {
	                        currpage: message.data.currpage,
	                        totalpage: message.data.pagenum
	                    },
	                    show: {
	                        prevPage: true,
	                        nextPage: !(message.data.fileid === 0 && message.data.currpage === message.data.pagenum),
	                        addPage: message.data.fileid === 0 && message.data.currpage === message.data.pagenum
	                    }
	                };
	                Object.assign(this.whiteboardJson, tmpWhiteboardDesc);
	                if (this.state.fileTypeMark === 'general') {
	                    this.setState({ pagingDesc: this.whiteboardJson });
	                }
	            } else if (message.source === 'newppt') {
	                var tmpNewPptDesc = {
	                    disabled: {
	                        prevPage: !_CoreController2['default'].handler.getAppPermissions('newpptPagingPage') || _TkGlobal2['default'].playMediaFileing || _TkGlobal2['default'].playPptVideoing || message.data.pptslide <= 1 && message.data.pptstep <= 0,
	                        nextPage: !_CoreController2['default'].handler.getAppPermissions('newpptPagingPage') || _TkGlobal2['default'].playMediaFileing || _TkGlobal2['default'].playPptVideoing || message.data.pptslide >= message.data.pagenum && message.data.pptstep >= message.data.steptotal - 1,
	                        addPage: true
	                    },
	                    page: {
	                        currpage: message.data.currpage,
	                        totalpage: message.data.pagenum
	                    }
	                };
	                Object.assign(this.newpptJson, tmpNewPptDesc);
	                if (this.state.fileTypeMark === 'dynamicPPT') {
	                    this.setState({ pagingDesc: this.newpptJson });
	                }
	            } else if (message.source === 'h5document') {
	                var h5DocumentDesc = {
	                    disabled: {
	                        prevPage: !(_CoreController2['default'].handler.getAppPermissions('h5DocumentPagingPage') && message.data.currpage > 1),
	                        nextPage: !(_CoreController2['default'].handler.getAppPermissions('h5DocumentPagingPage') && message.data.currpage < message.data.pagenum),
	                        addPage: true
	                    },
	                    page: {
	                        currpage: message.data.currpage,
	                        totalpage: message.data.pagenum
	                    }
	                };
	                Object.assign(this.h5DocumentJson, h5DocumentDesc);
	                if (this.state.fileTypeMark === 'h5document') {
	                    this.setState({ pagingDesc: this.h5DocumentJson });
	                }
	            }
	        }
	    }, {
	        key: 'handlerOnFullscreenchange',
	
	        /*添加全屏监测处理函数*/
	        value: function handlerOnFullscreenchange() {
	            if (TK.SDKTYPE !== 'mobile') {
	                this.setState({ isFullScreen: _TkUtils2['default'].tool.getFullscreenElement() && _TkUtils2['default'].tool.getFullscreenElement().id == "lc-full-vessel" });
	            }
	        }
	    }, {
	        key: 'handlerMobileSdk_fullScreenChangeCallback',
	        value: function handlerMobileSdk_fullScreenChangeCallback(recvEventData) {
	            if (TK.SDKTYPE === 'mobile') {
	                var isFullScreen = recvEventData.message.isFullScreen;
	
	                this.setState({ isFullScreen: isFullScreen });
	            }
	        }
	    }, {
	        key: 'handlerInitAppPermissions',
	        value: function handlerInitAppPermissions() {
	            this.setState({
	                jumpPage: _CoreController2['default'].handler.getAppPermissions('jumpPage')
	            });
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_jumpPage',
	        value: function handlerUpdateAppPermissions_jumpPage() {
	            this.setState({
	                jumpPage: _CoreController2['default'].handler.getAppPermissions('jumpPage')
	            });
	        }
	    }, {
	        key: 'handlerCurrpageOnChange',
	
	        /*当前页修改的处理函数*/
	        value: function handlerCurrpageOnChange(e) {
	            var currpage = e.target.value;
	            currpage = currpage.replace(/[^\d]/g, ""); //xgd 17-09-19
	            this.state.pagingDesc.page.currpage = currpage;
	            this.setState({ pagingDesc: this.state.pagingDesc });
	        }
	    }, {
	        key: 'handlerKeyDown',
	
	        /*回车键按下响应事件*/
	        value: function handlerKeyDown(e) {
	            var that = this;
	            if (e.keyCode === 13) {
	                that.handlerCurrpageOnBlur(e);
	            }
	        }
	
	        /*当前页修改的处理函数*/
	    }, {
	        key: 'handlerCurrpageOnBlur',
	        value: function handlerCurrpageOnBlur(e) {
	            var that = this;
	            _TkGlobal2['default'].isSkipPageing = false;
	            if (!/^\d+$/.test(that.state.pagingDesc.page.currpage)) {
	                _ServiceTooltip2['default'].showPrompt(_TkGlobal2['default'].language.languageData.alertWin.call.fun.page.pageInteger.text);
	                that.state.pagingDesc.page.currpage = that.changeCurrpage;
	                that.setState({ pagingDesc: that.state.pagingDesc });
	                return;
	            }
	            if (that.state.pagingDesc.page.currpage > that.state.pagingDesc.page.totalpage) {
	                _ServiceTooltip2['default'].showPrompt(_TkGlobal2['default'].language.languageData.alertWin.call.fun.page.pageMax.text);
	                that.state.pagingDesc.page.currpage = that.changeCurrpage;
	                that.setState({ pagingDesc: that.state.pagingDesc });
	                return;
	            }
	            if (that.state.pagingDesc.page.currpage < 1) {
	                _ServiceTooltip2['default'].showPrompt(_TkGlobal2['default'].language.languageData.alertWin.call.fun.page.pageMin.text);
	                that.state.pagingDesc.page.currpage = that.changeCurrpage;
	                that.setState({ pagingDesc: that.state.pagingDesc });
	                return;
	            }
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'skipPage_' + that.state.fileTypeMark, message: { currpage: that.state.pagingDesc.page.currpage } });
	            that.changeCurrpage = undefined;
	        }
	    }, {
	        key: 'handlerCurrpageOnFocus',
	
	        /*当前页修改的处理函数*/
	        value: function handlerCurrpageOnFocus(e) {
	            var that = this;
	            _TkGlobal2['default'].isSkipPageing = true;
	            that.changeCurrpage = that.state.pagingDesc.page.currpage;
	        }
	    }, {
	        key: 'whiteboardPrevPageClick',
	        value: function whiteboardPrevPageClick(event) {
	            this._addTemporaryDisabled('prevPage');
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboardPrevPage' }); //通知白板执行了翻页：上一页
	        }
	    }, {
	        key: 'whiteboardNextPageClick',
	        value: function whiteboardNextPageClick(event) {
	            this._addTemporaryDisabled('nextPage');
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboardNextPage' }); //通知白板执行了翻页：下一页
	        }
	    }, {
	        key: 'whiteboardAddPageClick',
	        value: function whiteboardAddPageClick(event) {
	            this._addTemporaryDisabled('addPage');
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboardAddPage' }); //通知白板执行了加页
	        }
	    }, {
	        key: 'newpptPrevStepClick',
	        value: function newpptPrevStepClick(event) {
	            this._addTemporaryDisabled('prevPage');
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'newpptPrevStepClick' }); //通知动态PPT执行上一帧
	        }
	    }, {
	        key: 'newpptNextStepClick',
	        value: function newpptNextStepClick(event) {
	            this._addTemporaryDisabled('nextPage');
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'newpptNextStepClick' }); //通知动态PPT执行下一帧
	        }
	    }, {
	        key: 'h5DocumentPrevStepClick',
	        value: function h5DocumentPrevStepClick(event) {
	            this._addTemporaryDisabled('prevPage');
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'h5DocumentPageUpClick' }); //通知h5文件执行下上一页
	        }
	    }, {
	        key: 'h5DocumentNextStepClick',
	        value: function h5DocumentNextStepClick(event) {
	            this._addTemporaryDisabled('nextPage');
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'h5DocumentPageDownClick' }); //通知h5文件执行下一页
	        }
	    }, {
	        key: 'fullScreenClick',
	        value: function fullScreenClick(event) {
	            if (TK.SDKTYPE === 'mobile') {
	                var isFullScreen = !this.state.isFullScreen;
	                _ServiceRoom2['default'].getTkRoom().changeWebPageFullScreen(isFullScreen);
	                //this.setState({isFullScreen:isFullScreen }); //todo  这里应该走回调
	            } else {
	                    var ele = document.getElementById("lc-full-vessel");
	                    if (_TkUtils2['default'].tool.isFullScreenStatus(ele)) {
	                        _TkUtils2['default'].tool.exitFullscreen();
	                    } else {
	                        _TkUtils2['default'].tool.launchFullscreen(ele);
	                    }
	                }
	        }
	    }, {
	        key: 'handlerWhiteboard_activeCommonWhiteboardToolClick',
	        value: function handlerWhiteboard_activeCommonWhiteboardToolClick(toolKey, event) {
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboard_activeCommonWhiteboardTool', message: { toolKey: toolKey } });
	        }
	    }, {
	        key: 'handlerCommonWhiteboardTool_noticeUpdateToolDesc',
	        value: function handlerCommonWhiteboardTool_noticeUpdateToolDesc(recvEventData) {
	            var registerWhiteboardToolsList = recvEventData.message.registerWhiteboardToolsList;
	
	            var isChange = false;
	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;
	
	            try {
	                for (var _iterator = Object.keys(this.state.registerWhiteboardToolsList)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var key = _step.value;
	
	                    if (registerWhiteboardToolsList[key]) {
	                        this.state.registerWhiteboardToolsList[key] = registerWhiteboardToolsList[key];
	                        isChange = true;
	                    }
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator['return']) {
	                        _iterator['return']();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }
	
	            if (isChange) {
	                this.setState({
	                    registerWhiteboardToolsList: this.state.registerWhiteboardToolsList
	                });
	            }
	        }
	    }, {
	        key: '_getPaddingDesc',
	
	        /*获取分页数据描述*/
	        value: function _getPaddingDesc(fileTypeMark) {
	            fileTypeMark = fileTypeMark || this.state.fileTypeMark;
	            if (fileTypeMark === 'general' || fileTypeMark === undefined) {
	                return this.whiteboardJson;
	            } else if (fileTypeMark === 'dynamicPPT') {
	                return this.newpptJson;
	            } else if (fileTypeMark === 'h5document') {
	                return this.h5DocumentJson;
	            }
	        }
	    }, {
	        key: '_addTemporaryDisabled',
	
	        /*添加按钮的临时disabled*/
	        value: function _addTemporaryDisabled(temporaryDisabledKey) {
	            var _this = this;
	
	            var fileTypeMark = this.state.fileTypeMark;
	            var jsonKey = this.state.fileTypeMark == 'general' ? 'whiteboardJson' : this.state.fileTypeMark == 'dynamicPPT' ? 'newpptJson' : 'h5DocumentJson';
	            this[jsonKey].temporaryDisabled[temporaryDisabledKey] = true;
	            this.setState({ pagingDesc: this._getPaddingDesc(this.state.fileTypeMark) });
	            setTimeout(function () {
	                _this[jsonKey].temporaryDisabled[temporaryDisabledKey] = false;
	                if (_this.state.fileTypeMark === fileTypeMark) {
	                    _this.setState({ pagingDesc: _this._getPaddingDesc(_this.state.fileTypeMark) });
	                }
	            }, 250);
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	
	            var _that$state = that.state;
	            var fileTypeMark = _that$state.fileTypeMark;
	            var isFullScreen = _that$state.isFullScreen;
	            var pagingDesc = _that$state.pagingDesc;
	            var registerWhiteboardToolsList = _that$state.registerWhiteboardToolsList;
	            var zoom_small = registerWhiteboardToolsList.zoom_small;
	            var zoom_big = registerWhiteboardToolsList.zoom_big;
	
	            return _react2['default'].createElement(
	                _reactDraggable2['default'],
	                { bounds: '#tk_app' },
	                _react2['default'].createElement(
	                    'div',
	                    { className: "header-left-page-time-container clear-float add-fr tk-tool-bottom " + (_TkGlobal2['default'].mobileDeviceType === 'phone' ? 'phone ' : 'pc pad'), id: 'page_wrap' },
	                    ' ',
	                    _react2['default'].createElement(
	                        'div',
	                        { className: 'h-page-container add-fl clear-float' },
	                        _react2['default'].createElement(
	                            'div',
	                            { className: "h-page-next-prev-container add-fl clear-float " + ('tk-paging-' + fileTypeMark) },
	                            _react2['default'].createElement('button', { className: "lc-tool-icon-wrap add-fl arrow-wrap lc-prev-page " + (pagingDesc.disabled.prevPage ? ' disabled' : '') + (pagingDesc.temporaryDisabled.prevPage ? ' temporary-disabled' : ' '), 'data-set-disabled': 'yes', onTouchStart: !pagingDesc.disabled.prevPage ? pagingDesc.onClick.prevPage : undefined, style: { display: !pagingDesc.show.prevPage ? 'none' : 'block' }, disabled: pagingDesc.disabled.prevPage || undefined, id: 'prev_page', title: _TkGlobal2['default'].language.languageData.header.page.prev.text }),
	                            _react2['default'].createElement(
	                                'div',
	                                { className: 'lc-tool-icon-wrap  add-fl page-print not-active' },
	                                _react2['default'].createElement(
	                                    'span',
	                                    { className: 'page-print-content' },
	                                    _react2['default'].createElement('input', { id: 'curr_page', disabled: !that.state.jumpPage ? true : undefined, className: 'h-page-print-oblique curr-page', type: 'text', value: pagingDesc.page.currpage, onFocus: that.handlerCurrpageOnFocus.bind(that), onBlur: that.handlerCurrpageOnBlur.bind(that), onChange: that.handlerCurrpageOnChange.bind(that), onKeyDown: that.handlerKeyDown.bind(that) }),
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'h-page-print-oblique' },
	                                        '/'
	                                    ),
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { id: 'all_page', className: 'all-page disabled ', disabled: true },
	                                        pagingDesc.page.totalpage
	                                    )
	                                )
	                            ),
	                            _react2['default'].createElement('button', { className: "lc-tool-icon-wrap  add-fl arrow-wrap lc-next-page " + (pagingDesc.disabled.nextPage ? ' disabled' : '') + (pagingDesc.temporaryDisabled.nextPage ? ' temporary-disabled' : ' '), 'data-set-disabled': 'yes', onTouchStart: !pagingDesc.disabled.nextPage ? pagingDesc.onClick.nextPage : undefined, style: { display: !pagingDesc.show.nextPage ? 'none' : 'block' }, disabled: pagingDesc.disabled.nextPage || undefined, id: 'next_page', title: _TkGlobal2['default'].language.languageData.header.page.next.text }),
	                            _react2['default'].createElement('button', { className: " lc-tool-icon-wrap   add-fl add-page lc-add-page " + (pagingDesc.disabled.addPage ? ' disabled' : '') + (pagingDesc.temporaryDisabled.addPage ? ' temporary-disabled' : ' '), id: 'add_literally_page', 'data-set-disabled': 'yes', onTouchStart: !pagingDesc.disabled.addPage ? pagingDesc.onClick.addPage : undefined, style: { display: !pagingDesc.show.addPage ? 'none' : 'block' }, disabled: pagingDesc.disabled.addPage || undefined, title: _TkGlobal2['default'].language.languageData.header.page.add.text }),
	                            _react2['default'].createElement('button', { disabled: zoom_small.disabled, className: " lc-tool-icon-wrap   add-fl lc-zoom-small " + (zoom_small.disabled ? 'disabled' : ''), style: { display: that.state.fileTypeMark !== 'general' ? 'none' : '' }, id: 'tool_zoom_small', 'data-set-disabled': 'yes', title: _TkGlobal2['default'].language.languageData.header.tool.tool_zoom_small.title, onTouchStart: that.handlerWhiteboard_activeCommonWhiteboardToolClick.bind(that, 'zoom_small') }),
	                            _react2['default'].createElement('button', { disabled: zoom_big.disabled, className: " lc-tool-icon-wrap   add-fl lc-zoom-big " + (zoom_big.disabled ? 'disabled' : ''), style: { display: that.state.fileTypeMark !== 'general' ? 'none' : '' }, id: 'tool_zoom_big', 'data-set-disabled': 'yes', title: _TkGlobal2['default'].language.languageData.header.tool.tool_zoom_big.title, onTouchStart: that.handlerWhiteboard_activeCommonWhiteboardToolClick.bind(that, 'zoom_big') }),
	                            _TkGlobal2['default'].mobileDeviceType !== 'phone' ? _react2['default'].createElement('button', { className: " lc-tool-icon-wrap   add-fl lc-full " + (isFullScreen ? 'yes' : 'no'), id: 'lc_full_btn', onTouchStart: pagingDesc.onClick.fullScreen, title: fileTypeMark === 'general' ? _TkGlobal2['default'].language.languageData.header.page.lcFullBtn.title : fileTypeMark === 'dynamicPPT' ? _TkGlobal2['default'].language.languageData.header.page.pptFullBtn.title : _TkGlobal2['default'].language.languageData.header.page.h5FileFullBtn.title }) : undefined
	                        )
	                    )
	                )
	            );
	        }
	    }]);
	
	    return PagingToolBarSmart;
	})(_react2['default'].Component);
	
	;
	exports['default'] = PagingToolBarSmart;
	module.exports = exports['default'];
	/*白板以及动态PPT下面工具条*/

/***/ }),

/***/ 253:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 组合移动原生mobile页面的所有模块
	 * @module TkMobile
	 * @description   提供移动原生mobile页面的所有模块的组合功能
	 * @author QiuShao
	 * @date 2017/11/09
	 */
	
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	// import initReactFastclick from 'react-fastclick';
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _whiteboardAndNewpptWhiteboardAndNewppt = __webpack_require__(261);
	
	var _whiteboardAndNewpptWhiteboardAndNewppt2 = _interopRequireDefault(_whiteboardAndNewpptWhiteboardAndNewppt);
	
	var _whiteboardAndNewpptBalckBoardMoreBlackBoard = __webpack_require__(257);
	
	var _whiteboardAndNewpptBalckBoardMoreBlackBoard2 = _interopRequireDefault(_whiteboardAndNewpptBalckBoardMoreBlackBoard);
	
	var _whiteboardAndNewpptBalckBoardBlackboardThumbnailImage = __webpack_require__(256);
	
	var _whiteboardAndNewpptBalckBoardBlackboardThumbnailImage2 = _interopRequireDefault(_whiteboardAndNewpptBalckBoardBlackboardThumbnailImage);
	
	var _pagingToolBarPagingToolBar = __webpack_require__(252);
	
	var _pagingToolBarPagingToolBar2 = _interopRequireDefault(_pagingToolBarPagingToolBar);
	
	var _whiteboardToolAndControlOverallBarWhiteboardToolAndControlOverallBar = __webpack_require__(270);
	
	var _whiteboardToolAndControlOverallBarWhiteboardToolAndControlOverallBar2 = _interopRequireDefault(_whiteboardToolAndControlOverallBarWhiteboardToolAndControlOverallBar);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentTimerTeachingToolComponent = __webpack_require__(269);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentTimerTeachingToolComponent2 = _interopRequireDefault(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentTimerTeachingToolComponent);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentDialTeachingToolComponent = __webpack_require__(265);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentDialTeachingToolComponent2 = _interopRequireDefault(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentDialTeachingToolComponent);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentAnswerTeachingToolComponent = __webpack_require__(264);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentAnswerTeachingToolComponent2 = _interopRequireDefault(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentAnswerTeachingToolComponent);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentResponderTeacherToolComponent = __webpack_require__(267);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentResponderTeacherToolComponent2 = _interopRequireDefault(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentResponderTeacherToolComponent);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentResponderStudentToolCompontent = __webpack_require__(266);
	
	var _whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentResponderStudentToolCompontent2 = _interopRequireDefault(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentResponderStudentToolCompontent);
	
	// initReactFastclick();
	/*TkMobile页面*/
	
	var TkMobile = (function (_React$Component) {
	    _inherits(TkMobile, _React$Component);
	
	    function TkMobile(props) {
	        _classCallCheck(this, TkMobile);
	
	        _get(Object.getPrototypeOf(TkMobile.prototype), 'constructor', this).call(this, props);
	        this.state = {};
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	    }
	
	    _createClass(TkMobile, [{
	        key: 'componentWillMount',
	        value: function componentWillMount() {
	            //在初始化渲染执行之前立刻调用
	            var that = this;
	        }
	    }, {
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            // setTimeout( () => {
	            if (_ServiceRoom2['default'].getTkRoom() && _ServiceRoom2['default'].getTkRoom().onPageFinished) {
	                _ServiceRoom2['default'].getTkRoom().onPageFinished();
	            }
	            // },10000);
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	        }
	    }, {
	        key: 'callAllWrapOnClick',
	
	        /*点击call整体页面的事件处理*/
	        value: function callAllWrapOnClick(event) {
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'callAllWrapOnClick', message: { event: event } });
	            /*if(event){
	             event.preventDefault();
	             event.stopPropagation();
	             }
	             return false ;*/
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            return _react2['default'].createElement(
	                'section',
	                { className: 'all-container', onTouchStart: this.callAllWrapOnClick.bind(this) },
	                _react2['default'].createElement(_whiteboardAndNewpptWhiteboardAndNewppt2['default'], null),
	                ' ',
	                _react2['default'].createElement(_whiteboardAndNewpptBalckBoardMoreBlackBoard2['default'], { id: 'moreBlackboardDrag', blackboardThumbnailImageId: "blackboardThumbnailImageId", blackboardCanvasBackgroundColor: "#ffffff" }),
	                _react2['default'].createElement(_whiteboardAndNewpptBalckBoardBlackboardThumbnailImage2['default'], { blackboardThumbnailImageId: "blackboardThumbnailImageId", blackboardThumbnailImageBackgroundColor: "#ffffff", blackboardThumbnailImageWidth: "2rem" }),
	                _react2['default'].createElement(_pagingToolBarPagingToolBar2['default'], { id: 'page_wrap' }),
	                ' ',
	                !_TkGlobal2['default'].playback ? _react2['default'].createElement(_whiteboardToolAndControlOverallBarWhiteboardToolAndControlOverallBar2['default'], { id: 'lc_tool_container' }) : undefined,
	                _react2['default'].createElement(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentTimerTeachingToolComponent2['default'], { id: 'timerDrag' }),
	                _react2['default'].createElement(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentDialTeachingToolComponent2['default'], { id: 'dialDrag' }),
	                _react2['default'].createElement(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentAnswerTeachingToolComponent2['default'], { id: 'answerDrag' }),
	                _react2['default'].createElement(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentResponderTeacherToolComponent2['default'], { id: 'responderDrag' }),
	                _react2['default'].createElement(_whiteboardToolAndControlOverallBarTeachingToolBoxBarCompontentResponderStudentToolCompontent2['default'], { id: 'studentResponderDrag' })
	            );
	        }
	    }]);
	
	    return TkMobile;
	})(_react2['default'].Component);
	
	;
	exports['default'] = TkMobile;
	module.exports = exports['default'];
	/*白板以及动态PPT组件*/ /*多黑板组件*/ /*多黑板缩略图组件*/ /*白板以及动态ppt下面工具条*/ /*白板工具栏以及全体操作功能栏*/

/***/ }),

/***/ 254:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * Created by weijin on 2017/8/28.
	 */
	
	'use strict';
	
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var H5Document = (function (_React$Component) {
	    _inherits(H5Document, _React$Component);
	
	    function H5Document(props) {
	        _classCallCheck(this, H5Document);
	
	        _get(Object.getPrototypeOf(H5Document.prototype), 'constructor', this).call(this, props);
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	        this.h5FileId = null;
	        this.state = {
	            h5FileSrc: "",
	            h5DocumentActionClick: _CoreController2['default'].handler.getAppPermissions('h5DocumentActionClick')
	        };
	        // isDraging:false,
	        this.H5IsOnload = false;
	        this.h5ActionJson = {};
	    }
	
	    _createClass(H5Document, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            var that = this;
	            this.h5Frame = document.getElementById("h5DocumentFrame").contentWindow;
	            _eventObjectDefine2['default'].Window.addEventListener(_TkConstant2['default'].EVENTTYPE.WindowEvent.onMessage, that.handlerOnMessage.bind(that), that.listernerBackupid); //接收onMessage事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //room-pubmsg事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //room-delmsg事件
	            _eventObjectDefine2['default'].CoreController.addEventListener("openDocuemntOrMediaFile", that.handlerOpenDocuemntOrMediaFile.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-ShowPage-lastDocument", that.handlerShowLastDocument.bind(that), that.listernerBackupid); //接收ShowPage信令：h5课件处理
	            _eventObjectDefine2['default'].CoreController.addEventListener("initAppPermissions", that.handlerInitAppPermissions.bind(that), that.listernerBackupid); //initAppPermissions：初始化权限处理
	            _eventObjectDefine2['default'].CoreController.addEventListener("h5DocumentPageUpClick", that.handlerH5FilePageUpClick.bind(that), that.listernerBackupid); //上一页操作
	            _eventObjectDefine2['default'].CoreController.addEventListener("h5DocumentPageDownClick", that.handlerH5FilePageDownClick.bind(that), that.listernerBackupid); //下一页操作
	            _eventObjectDefine2['default'].CoreController.addEventListener("setH5FileFrameSrc", that.setH5FileFrameSrc.bind(that), that.listernerBackupid); //设置h5文件路径
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_h5DocumentPagingPage", that.handlerUpdateAppPermissions_h5DocumentPagingPage.bind(that), that.listernerBackupid); //updateAppPermissions_h5DocumentPagingPage：更新H5翻页权限
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_h5DocumentActionClick", that.handlerUpdateAppPermissions_h5DocumentActionClick.bind(that), that.listernerBackupid); //h5点击动作权限的更新
	            _eventObjectDefine2['default'].CoreController.addEventListener("skipPage_h5document", that.handlerSkipPage_h5document.bind(that), that.listernerBackupid); //skipPage_h5document：H5文档跳转
	            // eventObjectDefine.CoreController.addEventListener("layerIsShowOfDraging" ,that.layerIsShowOfDraging.bind(that) , that.listernerBackupid); //skipPage_dynamicPPT：动态PPT跳转
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	            _eventObjectDefine2['default'].Window.removeBackupListerner(that.listernerBackupid);
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_h5DocumentPagingPage',
	        value: function handlerUpdateAppPermissions_h5DocumentPagingPage() {
	            var that = this;
	            if (that.props.fileTypeMark === 'h5document') {
	                var callbackHandler = function callbackHandler(fileInfo) {
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updatePagdingState', message: { source: 'h5document', data: fileInfo } });
	                };
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	            }
	        }
	    }, {
	        key: 'handlerRoomPubmsg',
	        value: function handlerRoomPubmsg(pubmsgDataEvent) {
	            var _this = this;
	
	            //room-pubmsg事件：动态h5文档处理
	            var that = this;
	            var pubmsgData = pubmsgDataEvent.message;
	            switch (pubmsgData.name) {
	                case "ShowPage":
	                    var open = that.h5FileId !== pubmsgData.data.filedata.fileid;
	                    that.h5FileId = pubmsgData.data.filedata.fileid; //保存当前文档id
	                    that._handlerReceiveShowPageSignalling({ message: { data: pubmsgData.data, open: open, source: 'room-pubmsg' } });
	                    break;
	                case "H5DocumentAction":
	                    //h5文件动作
	                    var callbackHandler = function callbackHandler(fileInfo) {
	                        var currpage = fileInfo.currpage;
	
	                        var data = pubmsgData.data;
	                        if (_this.H5IsOnload === false && _TkGlobal2['default'].playback) {
	                            if (_this.h5ActionJson[currpage] && _this.h5ActionJson[currpage].length > 0) {
	                                _this.h5ActionJson[currpage].push(data);
	                            } else {
	                                _this.h5ActionJson[currpage] = [];
	                                _this.h5ActionJson[currpage].push(data);
	                            }
	                            L.Logger.warning('iframe加载好之前保存H5文件动作：', _this.h5ActionJson);
	                        }
	                        that.h5Frame.postMessage(JSON.stringify(data), '*');
	                    };
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	
	                    break;
	                default:
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerRoomDelmsg',
	        value: function handlerRoomDelmsg(delmsgData) {//room-delmsg事件：动态h5文档处理
	
	        }
	    }, {
	        key: 'handlerOnMessage',
	        value: function handlerOnMessage(recvEventData) {
	            var that = this;
	            var event = recvEventData.message.event;
	
	            that.handlerIframeMessage(event); //iframe框架消息处理函数
	        }
	    }, {
	        key: 'handlerIframeMessage',
	        value: function handlerIframeMessage(event) {
	            var _this2 = this;
	
	            //iframe框架消息处理函数
	            var that = this;
	            // 通过origin属性判断消息来源地址
	            if (event.data) {
	                var data = undefined;
	                try {
	                    data = JSON.parse(event.data);
	                } catch (e) {
	                    L.Logger.warning("iframe message data can't be converted to JSON , iframe data:", event.data);
	                    return;
	                }
	                if (data.method) {
	                    L.Logger.debug("[h5]receive remote iframe data form " + event.origin + ":", event);
	                    switch (data.method) {
	                        case "onPagenum":
	                            //收到总页数
	                            var h5Pagenum = data.totalPages;
	                            that.initH5Document(h5Pagenum);
	                            break;
	                        case "onFileMessage":
	                            //操作h5课件时
	                            data.method = "onFileMessage";
	                            _ServiceSignalling2['default'].sendSignallingFromH5DocumentAction(data);
	                            //点击时是否收回列表
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'resetAllLeftToolButtonOpenStateToFalse' });
	                            break;
	                        case "onLoadComplete":
	                            //收到iframe加载完成时
	                            this.H5IsOnload = true;
	                            var callback = function callback(fileInfo) {
	                                that.h5FileJumpPage(fileInfo);
	                                var currpage = fileInfo.currpage;
	
	                                if (!_TkUtils2['default'].isEmpty(_this2.h5ActionJson) && _this2.h5ActionJson[currpage]) {
	                                    if (_this2.h5ActionJson[currpage].length !== 0) {
	                                        _this2.h5ActionJson[currpage].map(function (item, index) {
	                                            that.h5Frame.postMessage(JSON.stringify(item), '*');
	                                        });
	                                        _this2.h5ActionJson = {};
	                                    }
	                                }
	                            };
	                            var coursewareRatio = data.coursewareRatio || 16 / 9;
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callback } });
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateLcScaleWhenAynicPPTInitHandler', message: { lcLitellyScalc: coursewareRatio } });
	                            break;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'initH5Document',
	        value: function initH5Document(h5Pagenum) {
	            this._sendDocumentPageChangeAndSaveWhiteboard(h5Pagenum);
	        }
	    }, {
	        key: 'handlerInitAppPermissions',
	        value: function handlerInitAppPermissions(recvEventData) {
	            this._sendDocumentPageChangeAndSaveWhiteboard();
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_h5DocumentActionClick',
	        value: function handlerUpdateAppPermissions_h5DocumentActionClick() {
	            var that = this;
	            that.setState({ h5DocumentActionClick: _CoreController2['default'].handler.getAppPermissions('h5DocumentActionClick') });
	        }
	    }, {
	        key: 'handlerSkipPage_h5document',
	        value: function handlerSkipPage_h5document(recvEventData) {
	            var that = this;
	
	            if (that.props.fileTypeMark === 'h5document') {
	                var currpage = recvEventData.message.currpage;
	
	                that._skipH5documentPaging(currpage);
	            }
	        }
	    }, {
	        key: 'handlerOpenDocuemntOrMediaFile',
	        value: function handlerOpenDocuemntOrMediaFile(recvEventData) {
	            //本地收到打开文档
	            var that = this;
	            var fileDataInfo = recvEventData.message;
	            var open = that.h5FileId !== fileDataInfo.filedata.fileid;
	            that.h5FileId = fileDataInfo.filedata.fileid; //保存当前文档id
	            if (fileDataInfo.isH5Document) {
	                //如果是h5文档
	                that._handlerReceiveShowPageSignalling({ message: { data: fileDataInfo, open: open, source: 'h5DocumentClickEvent' } });
	            }
	        }
	    }, {
	        key: 'handlerShowLastDocument',
	        value: function handlerShowLastDocument(showpageData) {
	            //打开最后一次操作的文档
	            showpageData.message.open = this.h5FileId !== showpageData.message.data.filedata.fileid;
	            this.h5FileId = showpageData.message.data.filedata.fileid; //保存当前文档id
	            this._handlerReceiveShowPageSignalling(showpageData);
	        }
	    }, {
	        key: '_handlerReceiveShowPageSignalling',
	        value: function _handlerReceiveShowPageSignalling(showpageData) {
	            //接收ShowPage信令
	            var that = this;
	            var h5DocumentData = showpageData.message.data;
	            var open = showpageData.message.open;
	            this.h5FileId = h5DocumentData.filedata.fileid;
	            that.h5DocumentData = h5DocumentData;
	            if (!h5DocumentData.isMedia) {
	                if (h5DocumentData.isH5Document) {
	                    var isReturn = false;
	                    var callbackHandler = function callbackHandler(fileInfo) {
	                        if (!open && h5DocumentData.filedata.fileid === that.fileid && Number(h5DocumentData.filedata.currpage) === fileInfo.currpage) {
	                            isReturn = true;
	                        }
	                    };
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	                    if (isReturn) {
	                        return;
	                    }
	                    if (showpageData.message.source === "room-pubmsg" || showpageData.message.source === "room-msglist" || showpageData.message.source === "h5DocumentClickEvent") {
	                        if (showpageData.message.open == true) {
	                            that._openH5DocumentHandler(h5DocumentData.filedata);
	                        } /*else {
	                             const callbackHandler = (fileInfo) => {
	                                 that.slideChangeToLc(fileInfo);
	                             };
	                             eventObjectDefine.CoreController.dispatchEvent({type:'getFileDataFromLcElement' ,message:{callback:callbackHandler}});
	                          }*/
	                    }
	                    that.slideChangeToLc(h5DocumentData.filedata);
	                    that.h5FileJumpPage(h5DocumentData.filedata);
	                }
	            }
	        }
	    }, {
	        key: 'h5FileJumpPage',
	        value: function h5FileJumpPage(filedata) {
	            //跳转到h5文档的某一页
	            var data = null;
	            var toPage = filedata.currpage;
	            data = JSON.stringify({ method: "onJumpPage", "toPage": toPage });
	            this.h5Frame.postMessage(data, '*');
	            this._sendDocumentPageChangeAndSaveWhiteboard(filedata.pagenum, toPage);
	        }
	    }, {
	        key: '_openH5DocumentHandler',
	        value: function _openH5DocumentHandler(filedata) {
	            //打开h5文档
	            var that = this;
	            var fileTypeMark = 'h5document';
	            var serviceUrl = _TkConstant2['default'].SERVICEINFO.address;
	            var swfpath = filedata.swfpath;
	            var toPage = filedata.currpage;
	            that.props.changeFileTypeMark(fileTypeMark); //改变fileTypeMark的值
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'resetLcDefault' });
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateLcScaleWhenAynicPPTInitHandler', message: { lcLitellyScalc: 16 / 9 } });
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setNewPptFrameSrc', message: { src: '' } }); //清空ppt的路径
	            this.H5IsOnload = false;
	            that.setState({ h5FileSrc: serviceUrl + swfpath });
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'checkSelectMouseState', message: { fileTypeMark: fileTypeMark } });
	        }
	    }, {
	        key: 'setH5FileFrameSrc',
	        value: function setH5FileFrameSrc(fileData) {
	            //设置h5文件路径
	            this.setState({ h5FileSrc: fileData.message.src || "" });
	        }
	    }, {
	        key: 'slideChangeToLc',
	        value: function slideChangeToLc(filedata) {
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'saveLcStackToStorage', message: {} }); //保存上一页数据
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setFileDataToLcElement', message: { filedata: filedata } }); //设置当前文档数据到白板节点上
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'recoverCurrpageLcData' }); //画当前文档当前页数据到白板上
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updatePagdingState', message: { source: 'h5document', data: filedata } });
	        }
	    }, {
	        key: 'handlerH5FilePageUpClick',
	        value: function handlerH5FilePageUpClick() {
	            //点击上一页
	            var that = this;
	            var data = JSON.stringify({ method: "onPageup" });
	            that.h5Frame.postMessage(data, '*');
	            that.changCurrPageUp(); //改变当前页数
	        }
	    }, {
	        key: 'handlerH5FilePageDownClick',
	        value: function handlerH5FilePageDownClick() {
	            //点击下一页
	            var that = this;
	            var data = JSON.stringify({ method: "onPagedown" });
	            that.h5Frame.postMessage(data, '*');
	            that.changCurrPageDown(); //改变当前页数
	        }
	    }, {
	        key: 'changCurrPageUp',
	        value: function changCurrPageUp() {
	            var that = this;
	            var callbackHandler = function callbackHandler(fileInfo) {
	                var currpage = fileInfo.currpage;
	                var pagenum = fileInfo.pagenum;
	
	                currpage--;
	                if (currpage <= 1) {
	                    currpage = 1;
	                }
	                fileInfo.currpage = currpage;
	                that.slideChangeToLc(fileInfo);
	                that.h5DocumentData.filedata = fileInfo;
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                    type: 'documentPageChange',
	                    message: that.h5DocumentData
	                });
	                that.h5DocumentData.action = 'onJumpPage';
	                that.sendSignallingToH5File(that.h5DocumentData); //发送信令告诉其他人翻页
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updatePagdingState', message: { source: 'h5document', data: fileInfo } });
	            };
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	        }
	    }, {
	        key: 'changCurrPageDown',
	        value: function changCurrPageDown() {
	            var that = this;
	            var callbackHandler = function callbackHandler(fileInfo) {
	                var currpage = fileInfo.currpage;
	                var pagenum = fileInfo.pagenum;
	
	                currpage++;
	                if (currpage >= pagenum) {
	                    currpage = pagenum;
	                }
	                fileInfo.currpage = currpage;
	                that.slideChangeToLc(fileInfo);
	                that.h5DocumentData.filedata = fileInfo;
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                    type: 'documentPageChange',
	                    message: that.h5DocumentData
	                });
	
	                that.h5DocumentData.action = 'onJumpPage';
	                that.sendSignallingToH5File(that.h5DocumentData); //发送信令告诉其他人翻页
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updatePagdingState', message: { source: 'h5document', data: fileInfo } });
	            };
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	        }
	    }, {
	        key: 'sendSignallingToH5File',
	        value: function sendSignallingToH5File(h5FileData) {
	            //发送信令告诉其他人翻页
	            var isDelMsg = false;
	            var id = 'DocumentFilePage_ShowPage';
	            _ServiceSignalling2['default'].sendSignallingFromShowPage(isDelMsg, id, h5FileData);
	        }
	    }, {
	        key: '_skipH5documentPaging',
	        value: function _skipH5documentPaging(currpage) {
	            var data = null;
	            var toPage = currpage;
	            data = JSON.stringify({ method: "onJumpPage", "toPage": toPage });
	            this.h5Frame.postMessage(data, '*');
	            this.h5DocumentData.filedata.currpage = currpage;
	            this.slideChangeToLc(this.h5DocumentData.filedata);
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                type: 'documentPageChange',
	                message: this.h5DocumentData
	            });
	            this.sendSignallingToH5File(this.h5DocumentData); //发送信令告诉其他人跳转到某页
	        }
	    }, {
	        key: '_updateLcScaleWhenAynicPPTInitHandler',
	        value: function _updateLcScaleWhenAynicPPTInitHandler(lcLitellyScalc) {
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateLcScaleWhenAynicPPTInitHandler', message: { lcLitellyScalc: lcLitellyScalc } });
	        }
	    }, {
	        key: '_sendDocumentPageChangeAndSaveWhiteboard',
	        value: function _sendDocumentPageChangeAndSaveWhiteboard(h5Pagenum, h5Currpage) {
	            var that = this;
	            that.setState({ h5DocumentActionClick: _CoreController2['default'].handler.getAppPermissions('h5DocumentActionClick') });
	            if (that.props.fileTypeMark === 'h5document') {
	                var callbackHandler = function callbackHandler(fileInfo) {
	                    if (h5Pagenum) {
	                        fileInfo.pagenum = h5Pagenum;
	                    }
	                    if (h5Currpage) {
	                        fileInfo.currpage = h5Currpage;
	                    }
	                    var pagingData = {
	                        isMedia: false,
	                        isDynamicPPT: false,
	                        isGeneralFile: false,
	                        isH5Document: true,
	                        action: 'show',
	                        mediaType: "",
	                        filedata: fileInfo
	                    };
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                        type: 'documentPageChange',
	                        message: pagingData
	                    });
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setFileDataToLcElement', message: { filedata: fileInfo } }); //设置当前文档数据到白板节点上
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updatePagdingState', message: { source: 'h5document', data: fileInfo } });
	                };
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	            }
	        }
	    }, {
	        key: 'render',
	
	        /*layerIsShowOfDraging(handledata){//根据是否正在拖拽显示课件上的浮层
	            this.setState({isDraging:handledata.message.isDraging});
	        };*/
	
	        value: function render() {
	            var fileTypeMark = this.props.fileTypeMark;
	            var _state = this.state;
	            var h5FileSrc = _state.h5FileSrc;
	            var h5DocumentActionClick = _state.h5DocumentActionClick;
	
	            var styleClass = Object.assign({ display: fileTypeMark == 'h5document' ? "block" : "none" }, this.props.styleJson);
	            return _react2['default'].createElement(
	                'div',
	                { id: 'h5FileWrap', style: styleClass, className: 'h5-file-wrap add-position-absolute-top0-left0' },
	                _react2['default'].createElement('iframe', { allowFullScreen: 'true', id: 'h5DocumentFrame', scrolling: 'no', src: h5FileSrc, name: 'h5FileFrame' }),
	                _react2['default'].createElement('div', { className: 'student-disabled add-position-absolute-top0-left0', style: { display: !h5DocumentActionClick ? "block" : "none" } }),
	                _react2['default'].createElement('div', { id: 'h5Document-layer', className: 'student-disabled add-position-absolute-top0-left0', style: { display: !h5DocumentActionClick ? "block" : "none" } })
	            );
	        }
	    }]);
	
	    return H5Document;
	})(_react2['default'].Component);
	
	exports['default'] = H5Document;
	module.exports = exports['default'];

/***/ }),

/***/ 255:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 白板组件
	 * @module WhiteboardSmart
	 * @description   提供 白板的组件
	 * @author QiuShao
	 * @date 2017/7/27
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _plugsLiterallyJsHandlerWhiteboardAndCore = __webpack_require__(119);
	
	var _plugsLiterallyJsHandlerWhiteboardAndCore2 = _interopRequireDefault(_plugsLiterallyJsHandlerWhiteboardAndCore);
	
	var BlackboardSmart = (function (_React$Component) {
	    _inherits(BlackboardSmart, _React$Component);
	
	    function BlackboardSmart(props) {
	        _classCallCheck(this, BlackboardSmart);
	
	        _get(Object.getPrototypeOf(BlackboardSmart.prototype), 'constructor', this).call(this, props);
	        this.containerWidthAndHeight = Object.assign({}, this.props.containerWidthAndHeight);
	        this.instanceId = this.props.instanceId !== undefined ? this.props.instanceId : 'whiteboard_default';
	        this.whiteboardElementId = 'whiteboard_container_' + this.instanceId;
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	    }
	
	    _createClass(BlackboardSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.addEventListener("resizeHandler", that.handlerResizeHandler.bind(that), that.listernerBackupid); //接收resizeHandler事件执行resizeHandler
	            that._lcInit();
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            if (that.props.saveImage) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].downCanvasImageToLocalFile(that.instanceId);
	            }
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].destroyWhiteboardInstance(that.instanceId);
	            _eventObjectDefine2['default'].Window.removeBackupListerner(that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	        }
	    }, {
	        key: 'componentDidUpdate',
	        value: function componentDidUpdate(prevProps, prevState) {
	            //在组件完成更新后立即调用,在初始化时不会被调用
	            var that = this;
	            if (prevProps.show !== this.props.show && this.props.show) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].resizeWhiteboardHandler(that.instanceId);
	            }
	            if (that.props.containerWidthAndHeight && (that.props.containerWidthAndHeight.width !== that.containerWidthAndHeight.width || that.props.containerWidthAndHeight.height !== that.containerWidthAndHeight.height)) {
	                Object.assign(that.containerWidthAndHeight, that.props.containerWidthAndHeight);
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateContainerWidthAndHeight(that.instanceId, that.containerWidthAndHeight);
	            }
	            if (that.props.isBaseboard !== prevProps.isBaseboard) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateIsBaseboard(that.instanceId, that.props.isBaseboard);
	            };
	            if (that.props.dependenceBaseboardWhiteboardID !== prevProps.dependenceBaseboardWhiteboardID) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateDependenceBaseboardWhiteboardID(that.instanceId, that.props.dependenceBaseboardWhiteboardID);
	            };
	            if (that.props.deawPermission !== prevProps.deawPermission) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].changeWhiteboardDeawPermission(that.props.deawPermission, that.instanceId);
	            };
	            if (that.props.useToolKey !== prevProps.useToolKey) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].activeWhiteboardTool(that.props.useToolKey, that.instanceId);
	            }
	            if (that.props.useToolColor !== prevProps.useToolColor) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateColor(that.instanceId, { primary: that.props.useToolColor });
	            }
	            if (that.props.pencilWidth !== prevProps.pencilWidth) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updatePencilWidth(that.instanceId, { pencilWidth: that.props.pencilWidth });
	            }
	            if (that.props.saveRedoStack !== prevProps.saveRedoStack) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardSaveRedoStackAndSaveUndoStack(that.instanceId, { saveRedoStack: that.props.saveRedoStack });
	            }
	            if (that.props.fontSize !== prevProps.fontSize) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateTextFont(that.instanceId, { fontSize: that.props.fontSize });
	            }
	            if (that.props.imageThumbnailId !== prevProps.imageThumbnailId) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateImageThumbnailId(that.instanceId, that.props.imageThumbnailId);
	            }
	            if (that.props.backgroundColor !== prevProps.backgroundColor) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateColor(that.instanceId, { background: that.props.backgroundColor });
	            }
	        }
	    }, {
	        key: 'handlerResizeHandler',
	        value: function handlerResizeHandler(recvEventData) {
	            var that = this;
	            if (recvEventData && recvEventData.message && recvEventData.message.eleWHPercent != undefined) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardMagnification(that.instanceId, recvEventData.message.eleWHPercent);
	            }
	        }
	    }, {
	        key: 'sendSignallingToServer',
	        value: function sendSignallingToServer(signallingName, id, toID, data, do_not_save, expiresabs, associatedMsgID, associatedUserID) {
	            var isDelMsg = false;
	            _ServiceSignalling2['default'].sendSignallingFromSharpsChange(isDelMsg, signallingName, id, toID, data, do_not_save, expiresabs, associatedMsgID, associatedUserID);
	        }
	    }, {
	        key: 'delSignallingToServer',
	        value: function delSignallingToServer(signallingName, id, toID, data) {
	            var isDelMsg = true;
	            _ServiceSignalling2['default'].sendSignallingFromSharpsChange(isDelMsg, signallingName, id, toID, data);
	        }
	    }, {
	        key: 'resizeWhiteboardSizeCallback',
	        value: function resizeWhiteboardSizeCallback(fatherContainerConfiguration) {
	            if (this.props.resizeWhiteboardSizeCallback && typeof this.props.resizeWhiteboardSizeCallback === 'function') {
	                this.props.resizeWhiteboardSizeCallback(fatherContainerConfiguration);
	            }
	        }
	    }, {
	        key: 'noticeUpdateToolDescCallback',
	        value: function noticeUpdateToolDescCallback(registerWhiteboardToolsList) {
	            // eventObjectDefine.CoreController.dispatchEvent({type:'commonWhiteboardTool_noticeUpdateToolDesc' , message:{registerWhiteboardToolsList}});
	        }
	    }, {
	        key: '_lcInit',
	        value: function _lcInit() {
	            //白板初始化
	            var that = this;
	            if (!_plugsLiterallyJsHandlerWhiteboardAndCore2['default'].hasWhiteboardById(that.instanceId)) {
	                var whiteboardInstanceData = {
	                    whiteboardElementId: that.whiteboardElementId,
	                    id: that.instanceId,
	                    productionOptions: {
	                        proprietaryTools: true,
	                        isBaseboard: this.props.isBaseboard,
	                        dependenceBaseboardWhiteboardID: this.props.dependenceBaseboardWhiteboardID,
	                        deawPermission: this.props.deawPermission,
	                        containerWidthAndHeight: this.props.containerWidthAndHeight,
	                        associatedMsgID: this.props.associatedMsgID,
	                        associatedUserID: this.props.associatedUserID,
	                        needLooadBaseboard: this.props.needLooadBaseboard,
	                        nickname: this.props.nickname,
	                        useToolKey: this.props.useToolKey,
	                        saveRedoStack: this.props.saveRedoStack,
	                        imageThumbnailId: this.props.imageThumbnailId,
	                        backgroundColor: this.props.backgroundColor,
	                        imageThumbnailTipContent: this.props.imageThumbnailTipContent
	                    },
	                    handler: {
	                        sendSignallingToServer: that.sendSignallingToServer.bind(that),
	                        delSignallingToServer: that.delSignallingToServer.bind(that),
	                        resizeWhiteboardSizeCallback: that.resizeWhiteboardSizeCallback.bind(that),
	                        noticeUpdateToolDescCallback: that.noticeUpdateToolDescCallback.bind(that)
	                    }
	                };
	                /*        else if( signallingData.data.dependenceBaseboardWhiteboardID !== undefined  && !signallingData.data.isBaseboard && signallingData.data.whiteboardID !== undefined){
	                                signallingData.source = source;
	                                this.basicTemplateWhiteboardSignallingChildrenList[signallingData.data.dependenceBaseboardWhiteboardID] = this.basicTemplateWhiteboardSignallingChildrenList[signallingData.data.dependenceBaseboardWhiteboardID] || {} ;
	                                this.basicTemplateWhiteboardSignallingChildrenList[signallingData.data.dependenceBaseboardWhiteboardID][signallingData.data.whiteboardID] = this.basicTemplateWhiteboardSignallingChildrenList[signallingData.data.dependenceBaseboardWhiteboardID][signallingData.data.whiteboardID] || [] ;
	                                this.basicTemplateWhiteboardSignallingChildrenList[signallingData.data.dependenceBaseboardWhiteboardID][signallingData.data.whiteboardID].push(signallingData);
	                            }*/
	                var toolsDesc = {
	                    tool_pencil: {},
	                    tool_eraser: {},
	                    tool_text: {}
	                };
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].productionWhiteboard(whiteboardInstanceData);
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].registerWhiteboardTools(that.instanceId, toolsDesc);
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].clearRedoAndUndoStack(that.instanceId);
	                if (!_plugsLiterallyJsHandlerWhiteboardAndCore2['default'].hasWhiteboardFiledata(that.instanceId)) {
	                    _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardFiledata(that.instanceId, _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardDefaultFiledata({
	                        fileid: this.instanceId,
	                        filetype: 'blackboard',
	                        filename: 'blackboard'
	                    }));
	                };
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].loadCurrpageWhiteboard(that.instanceId);
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].resizeWhiteboardHandler(that.instanceId);
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateTextFont(that.instanceId, { fontSize: that.props.fontSize });
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateColor(that.instanceId, { primary: that.props.useToolColor });
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updatePencilWidth(that.instanceId, { pencilWidth: that.props.pencilWidth });
	                /*HandlerWhiteboardAndCoreInstance.updateEraserWidth(that.instanceId , {eraserWidth:that.props.eraserWidth} );*/
	            }
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	            var _that$props = that.props;
	            var show = _that$props.show;
	
	            var other = _objectWithoutProperties(_that$props, ['show']);
	
	            return _react2['default'].createElement('div', _extends({ id: that.whiteboardElementId, style: { display: show ? 'block' : 'none' }, className: "overflow-hidden  scroll-literally-container " }, _TkUtils2['default'].filterContainDataAttribute(other)));
	        }
	    }]);
	
	    return BlackboardSmart;
	})(_react2['default'].Component);
	
	;
	BlackboardSmart.propTypes = {
	    instanceId: _react.PropTypes.string.isRequired,
	    containerWidthAndHeight: _react.PropTypes.object.isRequired,
	    isBaseboard: _react.PropTypes.bool.isRequired,
	    deawPermission: _react.PropTypes.bool.isRequired
	};
	exports['default'] = BlackboardSmart;
	module.exports = exports['default'];

/***/ }),

/***/ 256:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 多黑板缩略图组件
	 * @module MoreBlackboardSmart
	 * @description   提供 多黑板缩略图组件
	 * @author QiuShao
	 * @date 2017/11/20
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var BlackboardThumbnailImageSmart = (function (_React$Component) {
	    _inherits(BlackboardThumbnailImageSmart, _React$Component);
	
	    function BlackboardThumbnailImageSmart(props) {
	        _classCallCheck(this, BlackboardThumbnailImageSmart);
	
	        _get(Object.getPrototypeOf(BlackboardThumbnailImageSmart.prototype), 'constructor', this).call(this, props);
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	        this.state = {
	            show: false,
	            blackboardThumbnailImageWidth: this.props.blackboardThumbnailImageWidth || "2rem",
	            blackboardThumbnailImageBackgroundColor: this.props.blackboardThumbnailImageBackgroundColor || "#ffffff",
	            blackboardThumbnailImageId: this.props.blackboardThumbnailImageId || 'blackboardThumbnailImageId'
	        };
	    }
	
	    _createClass(BlackboardThumbnailImageSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.addEventListener('updateBlackboardThumbnailImageFromMoreBlackboard', that.handlerUpdateBlackboardThumbnailImageFromMoreBlackboard.bind(that), that.listernerBackupid);
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	        }
	    }, {
	        key: 'handlerUpdateBlackboardThumbnailImageFromMoreBlackboard',
	        value: function handlerUpdateBlackboardThumbnailImageFromMoreBlackboard(recvEventData) {
	            var _recvEventData$message = recvEventData.message;
	            var show = _recvEventData$message.show;
	            var blackboardThumbnailImageId = _recvEventData$message.blackboardThumbnailImageId;
	            var blackboardThumbnailImageBackgroundColor = _recvEventData$message.blackboardThumbnailImageBackgroundColor;
	
	            if (blackboardThumbnailImageId !== this.state.blackboardThumbnailImageId) {
	                this.setState({ blackboardThumbnailImageId: blackboardThumbnailImageId });
	            }
	            if (show !== this.state.show) {
	                this.setState({ show: show });
	            }
	            if (blackboardThumbnailImageBackgroundColor !== this.state.blackboardThumbnailImageBackgroundColor) {
	                this.setState({ blackboardThumbnailImageBackgroundColor: blackboardThumbnailImageBackgroundColor });
	            }
	        }
	    }, {
	        key: 'blackboardThumbnailOnClick',
	        value: function blackboardThumbnailOnClick() {
	            this.setState({ show: false });
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateBlackboardThumbnailImageFromBlackboardThumbnailImage', message: { action: 'magnify' } });
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            return _react2['default'].createElement(
	                'article',
	                { className: 'blackboard-thumbnail-image-container add-position-absolute-bottom0-left0', onClick: TK.SDKTYPE === 'mobile' ? undefined : this.blackboardThumbnailOnClick.bind(this), onTouchStart: this.blackboardThumbnailOnClick.bind(this), style: { display: this.state.show ? 'block' : 'none', zIndex: 160 } },
	                _react2['default'].createElement('img', { className: 'blackboard-thumbnail-img', id: this.state.blackboardThumbnailImageId, style: { display: 'block', width: this.state.blackboardThumbnailImageWidth, height: 'auto', backgroundColor: this.state.blackboardThumbnailImageBackgroundColor } }),
	                _react2['default'].createElement('span', { className: 'blackboard-thumbnail-imageDescribe add-position-absolute-bottom0-left0 add-nowrap', id: this.state.blackboardThumbnailImageId + '_imageDescribe', style: { display: 'block', width: this.state.blackboardThumbnailImageWidth, height: 'auto', fontSize: '0.2rem' } })
	            );
	        }
	    }]);
	
	    return BlackboardThumbnailImageSmart;
	})(_react2['default'].Component);
	
	;
	exports['default'] = BlackboardThumbnailImageSmart;
	module.exports = exports['default'];

/***/ }),

/***/ 257:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 多黑板组件
	 * @module MoreBlackboardSmart
	 * @description   提供 多黑板的组件
	 * @author QiuShao
	 * @date 2017/7/27
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i['return']) _i['return'](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError('Invalid attempt to destructure non-iterable instance'); } }; })();
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x3, _x4, _x5) { var _again = true; _function: while (_again) { var object = _x3, property = _x4, receiver = _x5; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x3 = parent; _x4 = property; _x5 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(42);
	
	var _reactDom2 = _interopRequireDefault(_reactDom);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _blackboard = __webpack_require__(255);
	
	var _blackboard2 = _interopRequireDefault(_blackboard);
	
	var MoreBlackboardSmart = (function (_React$Component) {
	    _inherits(MoreBlackboardSmart, _React$Component);
	
	    function MoreBlackboardSmart(props) {
	        _classCallCheck(this, MoreBlackboardSmart);
	
	        _get(Object.getPrototypeOf(MoreBlackboardSmart.prototype), 'constructor', this).call(this, props);
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	        this.state = Object.assign({}, this._getDefaultState(), {
	            show: false,
	            moreBlackboardDrag: {
	                pagingToolLeft: "",
	                pagingToolTop: ""
	            }
	        });
	        this.blackboardCanvasBackgroundColor = this.props.blackboardCanvasBackgroundColor || "#ffffff";
	        this.blackboardThumbnailImageId = this.props.blackboardThumbnailImageId || 'blackboardThumbnailImageId';
	        this.associatedMsgID = 'BlackBoard';
	        this.currentTapKey = undefined;
	        this.whiteboardMagnification = 16 / 9;
	        this.maxBlackboardNumber = 4; //超过7个后显示左右按钮
	    }
	
	    _createClass(MoreBlackboardSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            _eventObjectDefine2['default'].Window.addEventListener(_TkConstant2['default'].EVENTTYPE.WindowEvent.onResize, that.handlerOnResize.bind(that), that.listernerBackupid); //window.resize事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //roomPubmsg 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //roomPubmsg 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomParticipantJoin, that.handlerRoomParticipantJoin.bind(that), that.listernerBackupid); //roomParticipantJoin 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomParticipantLeave, that.handlerRoomParticipantLeave.bind(that), that.listernerBackupid); //roomParticipantLeave 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDisconnected, that.handlerRoomDisconnected.bind(that), that.listernerBackupid); //roomDisconnected 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPlaybackClearAll, that.handlerRoomPlaybackClearAll.bind(that), that.listernerBackupid); //roomDisconnected 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener('receive-msglist-BlackBoard', that.handlerReceive_msglist_BlackBoard.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener("resizeHandler", that.handlerResizeHandler.bind(that), that.listernerBackupid); //接收resizeHandler事件执行resizeHandler
	            _eventObjectDefine2['default'].CoreController.addEventListener("isSendSignallingFromBlackBoardDrag", that.handlerBlackBoardDrag.bind(that), that.listernerBackupid); //接收小黑板的拖拽信息
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateBlackboardThumbnailImageFromBlackboardThumbnailImage", that.handlerUpdateBlackboardThumbnailImageFromBlackboardThumbnailImage.bind(that), that.listernerBackupid); //接收小黑板的缩略图信息
	            this._init();
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            clearTimeout(this.disabledBlackboardToolBtnTimer);
	            _eventObjectDefine2['default'].Window.removeBackupListerner(that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	        }
	    }, {
	        key: 'componentDidUpdate',
	        value: function componentDidUpdate(prevProps, prevState) {
	            //在组件完成更新后立即调用,在初始化时不会被调用
	            if (prevState.show !== this.state.show && this.state.show) {
	                this._updateContainerWidthAndHeight();
	            }
	            if (prevState.blackBoardState !== this.state.blackBoardState) {
	                this._updateBlackBoardDescListByBlackBoardState();
	                this._updateContainerWidthAndHeight();
	            }
	        }
	    }, {
	        key: 'handlerUpdateBlackboardThumbnailImageFromBlackboardThumbnailImage',
	        value: function handlerUpdateBlackboardThumbnailImageFromBlackboardThumbnailImage(recvEventData) {
	            var action = recvEventData.message.action;
	
	            this.blackboardThumbnailImageClick({ action: action, initiative: false });
	        }
	    }, {
	        key: 'handlerRoomPlaybackClearAll',
	        value: function handlerRoomPlaybackClearAll() {
	            this._recoverDedaultState();
	        }
	    }, {
	        key: 'handlerRoomDisconnected',
	        value: function handlerRoomDisconnected() {
	            this._recoverDedaultState();
	        }
	    }, {
	        key: 'handlerRoomParticipantJoin',
	        value: function handlerRoomParticipantJoin() {
	            this._updateBlackBoardDescListByBlackBoardState();
	        }
	    }, {
	        key: 'handlerRoomParticipantLeave',
	        value: function handlerRoomParticipantLeave() {
	            this._updateBlackBoardDescListByBlackBoardState();
	        }
	    }, {
	        key: 'handlerOnResize',
	        value: function handlerOnResize() {
	            this._updateContainerWidthAndHeight();
	        }
	    }, {
	        key: 'handlerResizeHandler',
	        value: function handlerResizeHandler(recvEventData) {
	            this._updateContainerWidthAndHeight();
	        }
	    }, {
	        key: 'handlerReceive_msglist_BlackBoard',
	        value: function handlerReceive_msglist_BlackBoard(recvEventData) {
	            this.handlerRoomPubmsg(recvEventData);
	        }
	    }, {
	        key: 'handlerRoomPubmsg',
	        value: function handlerRoomPubmsg(recvEventData) {
	            var pubmsgData = recvEventData.message;
	            switch (pubmsgData.name) {
	                case "BlackBoard":
	                    if ((_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) && this.state.useToolColor === undefined) {
	                        this.setState({
	                            useToolColor: '#FF0000'
	                        });
	                    } else if (!(_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) && this.state.useToolColor === undefined) {
	                        this.setState({
	                            useToolColor: '#000000'
	                        });
	                    }
	                    if ((_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol || _TkConstant2['default'].hasRole.rolePlayback) && pubmsgData.data.blackBoardState !== '_none' || pubmsgData.data.blackBoardState === '_dispenseed' || pubmsgData.data.blackBoardState === '_recycle' || pubmsgData.data.blackBoardState === '_againDispenseed') {
	                        this.setState({
	                            show: true
	                        });
	                    }
	                    var currentTapKey = this.currentTapKey;
	                    var blackBoardState = this.state.blackBoardState;
	                    if (pubmsgData.data.currentTapKey !== undefined) {
	                        this.currentTapKey = pubmsgData.data.currentTapKey;
	                    }
	                    if (pubmsgData.data.currentTapPage !== undefined && this.state.currentTapPage !== pubmsgData.data.currentTapPage) {
	                        this.state.currentTapPage = pubmsgData.data.currentTapPage;
	                    }
	                    this.setState({
	                        blackBoardState: pubmsgData.data.blackBoardState,
	                        updateState: !this.state.updateState,
	                        currentTapPage: this.state.currentTapPage
	                    });
	                    if (blackBoardState === pubmsgData.data.blackBoardState && currentTapKey !== pubmsgData.data.currentTapKey) {
	                        if (!(_TkConstant2['default'].hasRole.roleStudent && (pubmsgData.data.blackBoardState === '_dispenseed' || pubmsgData.data.blackBoardState === '_againDispenseed'))) {
	                            this._updateBlackBoardDescListByBlackBoardState();
	                        }
	                    }
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerRoomDelmsg',
	        value: function handlerRoomDelmsg(recvEventData) {
	            var delmsgData = recvEventData.message;
	            switch (delmsgData.name) {
	                case "BlackBoard":
	                    this._recoverDedaultState();
	                    break;
	                case "ClassBegin":
	                    this._recoverDedaultState();
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerBlackBoardDrag',
	        value: function handlerBlackBoardDrag(handleData) {
	            //接收小黑板的拖拽信息
	            var BlackBoardDragInfo = handleData.message.data;
	            if (this.state.blackBoardState === '_recycle') {
	                //小黑板处于回收状态
	                _ServiceSignalling2['default'].sendSignallingFromBlackBoardDrag(BlackBoardDragInfo);
	            }
	        }
	    }, {
	        key: 'handlerCloseClick',
	        value: function handlerCloseClick() {
	            /** todo 保存图片（文件夹级保存）--未完成
	            ServiceTooltip.showConfirm(TkGlobal.language.languageData.header.tool.blackBoard.tip.saveImage , (answer)=>{
	                if(answer){
	                    for(let value of Object.values( this.state.blackBoardDescList) ){
	                        value.saveImage = true ;
	                    }
	                    this.setState({
	                        blackBoardDescList:this.state.blackBoardDescList
	                    });
	                    let isDelMsg = true , data = {} ;
	                    ServiceSignalling.sendSignallingFromBlackBoard(data , isDelMsg);
	                }else{
	                    let isDelMsg = true , data = {} ;
	                    ServiceSignalling.sendSignallingFromBlackBoard(data , isDelMsg);
	                }
	            });*/
	
	            var isDelMsg = true,
	                data = {};
	            _ServiceSignalling2['default'].sendSignallingFromBlackBoard(data, isDelMsg);
	        }
	    }, {
	        key: 'handlerBlackBoardDispatchClick',
	        value: function handlerBlackBoardDispatchClick() {
	            var _this = this;
	
	            var blackBoardState = undefined;
	            var _props = this.props;
	            var translateX = _props.translateX;
	            var translateY = _props.translateY;
	
	            var data = {
	                translateX: translateX,
	                translateY: translateY
	            };
	            if (this.state.blackBoardState === '_prepareing') {
	                _ServiceSignalling2['default'].sendSignallingFromBlackBoardDrag(data); //变成分发状态时同步小黑板位置
	                blackBoardState = '_dispenseed';
	            } else if (this.state.blackBoardState === '_dispenseed') {
	                _ServiceSignalling2['default'].sendSignallingFromBlackBoardDrag(data); //点击再次分发时同步小黑板位置
	                blackBoardState = '_recycle';
	            } else if (this.state.blackBoardState === '_recycle') {
	                blackBoardState = '_againDispenseed';
	            } else if (this.state.blackBoardState === '_againDispenseed') {
	                _ServiceSignalling2['default'].sendSignallingFromBlackBoardDrag(data); //点击再次分发时同步小黑板位置
	                blackBoardState = '_recycle';
	            } else if (this.state.blackBoardState === '_none') {
	                L.Logger.error('current blackBoardState is _none , can\'t execute blackBoardDispatchClick!');
	                return;
	            }
	            if (blackBoardState) {
	                var isDelMsg = false,
	                    _data = {
	                    blackBoardState: blackBoardState, //_none:无 , _prepareing:准备中 , _dispenseed:分发 , _recycle:回收分发 , _againDispenseed:再次分发
	                    currentTapKey: this.currentTapKey,
	                    currentTapPage: this.state.currentTapPage
	                };
	                _ServiceSignalling2['default'].sendSignallingFromBlackBoard(_data, isDelMsg);
	            }
	            this.setState({
	                disabledBlackboardToolBtn: true
	            });
	            clearTimeout(this.disabledBlackboardToolBtnTimer);
	            this.disabledBlackboardToolBtnTimer = setTimeout(function () {
	                _this.setState({
	                    disabledBlackboardToolBtn: false
	                });
	            }, 300);
	        }
	    }, {
	        key: 'handlerTabClick',
	        value: function handlerTabClick(instanceId) {
	            if (instanceId !== undefined) {
	                var isDelMsg = false,
	                    data = {
	                    blackBoardState: this.state.blackBoardState, //_none:无 , _prepareing:准备中 , _dispenseed:分发 , _recycle:回收分发 , _againDispenseed:再次分发
	                    currentTapKey: instanceId,
	                    currentTapPage: this.state.currentTapPage
	                };
	                _ServiceSignalling2['default'].sendSignallingFromBlackBoard(data, isDelMsg);
	            };
	        }
	    }, {
	        key: 'resizeWhiteboardSizeCallback',
	        value: function resizeWhiteboardSizeCallback(fatherContainerConfiguration) {}
	    }, {
	        key: 'handleToolClick',
	        value: function handleToolClick(toolKey) {
	            if (toolKey === 'tool_pencil' || toolKey === 'tool_text' || toolKey === 'tool_eraser') {
	                this.setState({
	                    useToolKey: toolKey
	                });
	            }
	        }
	    }, {
	        key: 'changeStrokeColorClick',
	        value: function changeStrokeColorClick(colorValue) {
	            this.setState({
	                useToolColor: colorValue
	            });
	        }
	    }, {
	        key: 'onTapPrevOrNextClick',
	        value: function onTapPrevOrNextClick(type) {
	            var send = arguments.length <= 1 || arguments[1] === undefined ? false : arguments[1];
	
	            var blackboardNumber = Object.keys(this.state.blackBoardDescList).length;
	            var totalPage = Math.ceil(blackboardNumber / (this.maxBlackboardNumber - 1));
	            switch (type) {
	                case 'prev':
	                    this.state.currentTapPage--;
	                    break;
	                case 'next':
	                    this.state.currentTapPage++;
	                    break;
	            }
	            if (this.state.currentTapPage < 1) {
	                this.state.currentTapPage = 1;
	            } else if (this.state.currentTapPage > totalPage) {
	                this.state.currentTapPage = totalPage;
	            }
	            if (send) {
	                var isDelMsg = false,
	                    data = {
	                    blackBoardState: this.state.blackBoardState, //_none:无 , _prepareing:准备中 , _dispenseed:分发 , _recycle:回收分发 , _againDispenseed:再次分发
	                    currentTapKey: this.currentTapKey,
	                    currentTapPage: this.state.currentTapPage
	                };
	                _ServiceSignalling2['default'].sendSignallingFromBlackBoard(data, isDelMsg);
	            };
	            this.setState({
	                currentTapPage: this.state.currentTapPage
	            });
	        }
	    }, {
	        key: 'blackboardThumbnailImageClick',
	        value: function blackboardThumbnailImageClick() {
	            var _ref = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	            var action = _ref.action;
	            var _ref$initiative = _ref.initiative;
	            var initiative = _ref$initiative === undefined ? true : _ref$initiative;
	
	            if (this.state.blackBoardState !== '_none') {
	                switch (action) {
	                    case 'shrink':
	                        this.setState({ blackboardThumbnailImage: this.blackboardThumbnailImageId });
	                        if (initiative) {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateBlackboardThumbnailImageFromMoreBlackboard', message: { show: true, blackboardThumbnailImageId: this.blackboardThumbnailImageId, blackboardThumbnailImageBackgroundColor: this.blackboardCanvasBackgroundColor } });
	                        }
	                        break;
	                    case 'magnify':
	                        this.setState({ blackboardThumbnailImage: undefined });
	                        if (initiative) {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateBlackboardThumbnailImageFromMoreBlackboard', message: { show: false, blackboardThumbnailImageId: this.blackboardThumbnailImageId, blackboardThumbnailImageBackgroundColor: this.blackboardCanvasBackgroundColor } });
	                        }
	                        break;
	                }
	            } else {
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateBlackboardThumbnailImageFromMoreBlackboard', message: { show: false, blackboardThumbnailImageId: this.blackboardThumbnailImageId, blackboardThumbnailImageBackgroundColor: this.blackboardCanvasBackgroundColor } });
	            }
	        }
	    }, {
	        key: '_init',
	        value: function _init() {
	            this._updateContainerWidthAndHeight();
	        }
	    }, {
	        key: '_updateContainerWidthAndHeight',
	        value: function _updateContainerWidthAndHeight() {
	            var moreBlackboardEle = document.getElementById('blackboardContentBox');
	            if (TK.SDKTYPE === 'mobile') {
	                if (moreBlackboardEle) {
	                    var width = moreBlackboardEle.clientWidth;
	                    var height = moreBlackboardEle.clientHeight;
	                    this.state.containerWidthAndHeight.width = width;
	                    this.state.containerWidthAndHeight.height = height;
	                    this.setState({
	                        containerWidthAndHeight: this.state.containerWidthAndHeight
	                    });
	                }
	            } else if (TK.SDKTYPE === 'pc') {
	                if (moreBlackboardEle) {
	                    var width = moreBlackboardEle.clientWidth;
	                    var height = width * (1 / this.whiteboardMagnification);
	                    this.state.containerWidthAndHeight.width = width;
	                    this.state.containerWidthAndHeight.height = height;
	                    this.setState({
	                        containerWidthAndHeight: this.state.containerWidthAndHeight
	                    });
	                }
	            }
	        }
	    }, {
	        key: '_updateBlackBoardDescListByBlackBoardState',
	        value: function _updateBlackBoardDescListByBlackBoardState() {
	            if (_ServiceRoom2['default'].getTkRoom()) {
	                var blackBoardDescList = this.state.blackBoardDescList;
	                if (this.currentTapKey !== 'blackBoardCommon' && !_ServiceRoom2['default'].getTkRoom().getUser(this.currentTapKey)) {
	                    //users里面没有currentTapKey
	                    this.currentTapKey = 'blackBoardCommon';
	                }
	                if (this.state.blackBoardState === '_prepareing') {
	                    if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol || _TkConstant2['default'].hasRole.rolePlayback) {
	                        this.currentTapKey = 'blackBoardCommon';
	                    }
	                    blackBoardDescList = Object.assign({}, this._getBlackBoardCommon());
	                } else if (this.state.blackBoardState === '_dispenseed' || this.state.blackBoardState === '_againDispenseed') {
	                    if (_TkConstant2['default'].hasRole.roleStudent) {
	                        this.currentTapKey = _ServiceRoom2['default'].getTkRoom().getMySelf().id;
	                    }
	                    blackBoardDescList = Object.assign({}, this._getBlackBoardCommon(), this._getStudentBlackboard());
	                } else if (this.state.blackBoardState === '_recycle') {
	                    blackBoardDescList = Object.assign({}, this._getBlackBoardCommon(), this._getStudentBlackboard());
	                } else if (this.state.blackBoardState === '_none') {
	                    blackBoardDescList = {};
	                }
	                var blackboardNumber = Object.keys(blackBoardDescList).length;
	                var totalPage = Math.ceil(blackboardNumber / (this.maxBlackboardNumber - 1));
	                if (this.state.currentTapPage < 1) {
	                    this.state.currentTapPage = 1;
	                } else if (this.state.currentTapPage > totalPage) {
	                    this.state.currentTapPage = totalPage;
	                }
	                this.setState({
	                    blackBoardDescList: blackBoardDescList,
	                    currentTapPage: this.state.currentTapPage
	                });
	            }
	        }
	    }, {
	        key: '_getStudentBlackboard',
	        value: function _getStudentBlackboard() {
	            var studentBlackboardList = {};
	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;
	
	            try {
	                for (var _iterator = Object.entries(_ServiceRoom2['default'].getTkRoom().getSpecifyRoleList(_TkConstant2['default'].role.roleStudent))[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var _step$value = _slicedToArray(_step.value, 2);
	
	                    var key = _step$value[0];
	                    var value = _step$value[1];
	
	                    if (value.playbackLeaved) {
	                        continue;
	                    };
	                    studentBlackboardList[key] = {
	                        instanceId: key,
	                        show: this.currentTapKey === key,
	                        isBaseboard: false,
	                        deawPermission: false,
	                        dependenceBaseboardWhiteboardID: 'blackBoardCommon',
	                        needLooadBaseboard: true,
	                        saveImage: false,
	                        nickname: value.nickname
	                    };
	                    if (_TkConstant2['default'].role.roleStudent && (this.state.blackBoardState === '_dispenseed' || this.state.blackBoardState === '_againDispenseed') && _ServiceRoom2['default'].getTkRoom().getMySelf().id === key) {
	                        studentBlackboardList[key]['deawPermission'] = true;
	                    }
	                    if (this.state.blackBoardState === '_recycle' && (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant)) {
	                        studentBlackboardList[key]['deawPermission'] = true;
	                    }
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator['return']) {
	                        _iterator['return']();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }
	
	            return studentBlackboardList;
	        }
	    }, {
	        key: '_getBlackBoardCommon',
	        value: function _getBlackBoardCommon(extraJson) {
	            var blackBoardCommon = {
	                blackBoardCommon: {
	                    instanceId: 'blackBoardCommon',
	                    show: this.currentTapKey === 'blackBoardCommon',
	                    isBaseboard: this.state.blackBoardState === '_prepareing',
	                    deawPermission: _TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant,
	                    dependenceBaseboardWhiteboardID: undefined,
	                    needLooadBaseboard: false,
	                    saveImage: false,
	                    nickname: 'blackBoardCommon'
	                }
	            };
	            if (extraJson && typeof extraJson === 'object') {
	                Object.assign(blackBoardCommon.blackBoardCommon, extraJson);
	            }
	            return blackBoardCommon;
	        }
	    }, {
	        key: '_getDefaultState',
	        value: function _getDefaultState() {
	            var defaultState = {
	                blackBoardState: '_none', //_none:无 , _prepareing:准备中 , _dispenseed:分发 , _recycle:回收分发 , _againDispenseed:再次分发
	                disabledBlackboardToolBtn: false,
	                blackBoardDescList: {},
	                useToolKey: 'tool_pencil',
	                useToolColor: _TkConstant2['default'].hasRole.roleChairman === undefined ? undefined : _TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant ? '#FF0000' : '#000000',
	                containerWidthAndHeight: {
	                    width: 0,
	                    height: 0
	                },
	                updateState: false,
	                currentTapPage: 1,
	                blackboardToolsInfo: { pencil: 5, text: 30, eraser: 30 },
	                selectBlackboardToolSizeId: 'blackboard_size_small',
	                blackboardThumbnailImage: undefined
	            };
	            return defaultState;
	        }
	    }, {
	        key: '_loadBlackBoardElementArray',
	        value: function _loadBlackBoardElementArray(blackBoardDescList) {
	            var _this2 = this;
	
	            var users = undefined;
	            var tabContentBlackBoardElementArray = [];
	            var tabBlackBoardElementArray = [];
	            var useWidth = this.state.useToolKey === 'tool_eraser' ? this.state.blackboardToolsInfo.eraser : this.state.blackboardToolsInfo.pencil;
	            var fontSize = this.state.blackboardToolsInfo.text;
	            var descArray = [];
	            var blackBoardCommonDesc = undefined;
	            var _iteratorNormalCompletion2 = true;
	            var _didIteratorError2 = false;
	            var _iteratorError2 = undefined;
	
	            try {
	                for (var _iterator2 = Object.values(blackBoardDescList)[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	                    var desc = _step2.value;
	
	                    if (desc.instanceId !== 'blackBoardCommon') {
	                        descArray.push(desc);
	                    } else {
	                        blackBoardCommonDesc = desc;
	                    }
	                }
	            } catch (err) {
	                _didIteratorError2 = true;
	                _iteratorError2 = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion2 && _iterator2['return']) {
	                        _iterator2['return']();
	                    }
	                } finally {
	                    if (_didIteratorError2) {
	                        throw _iteratorError2;
	                    }
	                }
	            }
	
	            descArray.sort(function (obj1, obj2) {
	                if (obj1 === undefined || !obj1.hasOwnProperty('instanceId') || obj2 === undefined || !obj2.hasOwnProperty('instanceId')) return 0;
	                if (obj1.instanceId < obj2.instanceId) {
	                    return -1;
	                } else if (obj1.instanceId > obj2.instanceId) {
	                    return 1;
	                } else {
	                    return 0;
	                }
	            });
	            if (blackBoardCommonDesc) {
	                descArray.unshift(blackBoardCommonDesc);
	            }
	            var blackboardNumber = Object.keys(blackBoardDescList).length;
	            var optionTapWidth = undefined;
	            var marginLeft = undefined;
	            var totalPage = Math.ceil(blackboardNumber / (this.maxBlackboardNumber - 1));
	            if (totalPage > 1) {
	                optionTapWidth = 100 / (this.maxBlackboardNumber - 1);
	                if (totalPage === 1 || this.state.currentTapPage < totalPage) {
	                    marginLeft = (this.state.currentTapPage - 1) * (this.maxBlackboardNumber - 1) * optionTapWidth;
	                } else {
	                    var difference = totalPage * (this.maxBlackboardNumber - 1) - blackboardNumber;
	                    marginLeft = ((this.state.currentTapPage - 1) * (this.maxBlackboardNumber - 1) - difference) * optionTapWidth;
	                }
	            }
	            descArray.forEach(function (value, index) {
	                if (value.instanceId === 'blackBoardCommon' || value.instanceId !== 'blackBoardCommon' && _ServiceRoom2['default'].getTkRoom() && _ServiceRoom2['default'].getTkRoom().getUser(value.instanceId)) {
	                    var associatedUserID = undefined;
	                    // let associatedUserID = value.instanceId!=='blackBoardCommon'?value.instanceId:undefined ;
	                    tabContentBlackBoardElementArray.push(_react2['default'].createElement(
	                        'li',
	                        { className: 'tab-content-option ', key: value.instanceId, style: { display: value.show ? 'block' : 'none' } },
	                        _react2['default'].createElement(_blackboard2['default'], { containerWidthAndHeight: _this2.state.containerWidthAndHeight, resizeWhiteboardSizeCallback: _this2.resizeWhiteboardSizeCallback.bind(_this2), instanceId: value.instanceId,
	                            show: value.show, isBaseboard: value.isBaseboard, deawPermission: value.deawPermission, dependenceBaseboardWhiteboardID: value.dependenceBaseboardWhiteboardID,
	                            associatedMsgID: _this2.associatedMsgID, associatedUserID: associatedUserID, needLooadBaseboard: value.needLooadBaseboard, saveImage: value.saveImage,
	                            nickname: value.nickname, useToolKey: _this2.state.useToolKey, fontSize: fontSize, useToolColor: _this2.state.useToolColor, pencilWidth: useWidth,
	                            saveRedoStack: _TkConstant2['default'].hasRole.roleChairman, imageThumbnailId: value.show ? _this2.state.blackboardThumbnailImage : undefined, backgroundColor: _this2.blackboardCanvasBackgroundColor,
	                            imageThumbnailTipContent: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.content.blackboardHeadTitle
	                        })
	                    ));
	                    tabBlackBoardElementArray.push(_react2['default'].createElement(
	                        'li',
	                        { style: { marginLeft: index === 0 ? marginLeft !== undefined ? -marginLeft + '%' : undefined : undefined, width: optionTapWidth !== undefined ? optionTapWidth + '%' : undefined, maxWidth: optionTapWidth !== undefined ? optionTapWidth + '%' : undefined, minWidth: optionTapWidth !== undefined ? optionTapWidth + '%' : undefined }, className: "tap-option add-nowrap " + (value.show ? 'active' : '') + (!(_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) ? ' disabled' : ' '), key: value.instanceId, onTouchStart: _TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant ? _this2.handlerTabClick.bind(_this2, value.instanceId) : undefined },
	                        _react2['default'].createElement(
	                            'span',
	                            { className: 'text add-nowrap' },
	                            value.instanceId === 'blackBoardCommon' ? _TkGlobal2['default'].language.languageData.header.tool.blackBoard.toolBtn.commonTeacher : _ServiceRoom2['default'].getTkRoom().getUser(value.instanceId).nickname
	                        )
	                    ));
	                }
	            });
	            return {
	                tabContentBlackBoardElementArray: tabContentBlackBoardElementArray,
	                tabBlackBoardElementArray: tabBlackBoardElementArray
	            };
	        }
	    }, {
	        key: '_loadToolColorsElementArray',
	        value: function _loadToolColorsElementArray() {
	            var _this3 = this;
	
	            var colorsArray = [];
	            var colors = ["#FF0000", "#FFFF00", "#00FF00", "#00FFFF", "#0000FF", "#FF00FF", "#FE9401", "#FF2C55", "#007AFF", "#7457F1", "#626262", "#000000"];
	            colors.forEach(function (item, index) {
	                colorsArray.push(_react2['default'].createElement('li', { className: "color-option " + (_this3.state.useToolColor === item ? ' active' : ''), key: index, onTouchStart: _this3.changeStrokeColorClick.bind(_this3, item), style: { backgroundColor: item }, id: "blackboard_color_" + _this3._colorFilter(item) }));
	            });
	            return {
	                toolColorsArray: colorsArray
	            };
	        }
	    }, {
	        key: '_colorFilter',
	        value: function _colorFilter(text) {
	            return text.replace(/#/g, "");
	        }
	    }, {
	        key: '_recoverDedaultState',
	        value: function _recoverDedaultState() {
	            clearTimeout(this.disabledBlackboardToolBtnTimer);
	            var defaultState = this._getDefaultState();
	            this.currentTapKey = undefined;
	            this.setState(Object.assign({}, defaultState, {
	                show: false
	            }));
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateBlackboardThumbnailImageFromMoreBlackboard', message: { show: false, blackboardThumbnailImageId: this.blackboardThumbnailImageId, blackboardThumbnailImageBackgroundColor: this.blackboardCanvasBackgroundColor } });
	        }
	    }, {
	        key: '_changeStrokeSizeClick',
	
	        /*改变大小的点击事件*/
	        value: function _changeStrokeSizeClick(selectBlackboardToolSizeId, strokeJson) {
	            this.setState({
	                selectBlackboardToolSizeId: selectBlackboardToolSizeId,
	                blackboardToolsInfo: Object.assign(this.state.blackboardToolsInfo, strokeJson)
	            });
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	            var _that$state = that.state;
	            var blackBoardState = _that$state.blackBoardState;
	            var show = _that$state.show;
	            var blackBoardDescList = _that$state.blackBoardDescList;
	            var containerWidthAndHeight = _that$state.containerWidthAndHeight;
	            var useToolKey = _that$state.useToolKey;
	            var blackboardThumbnailImage = _that$state.blackboardThumbnailImage;
	            var id = this.props.id;
	
	            var blackboardToolBtnText = blackBoardState !== '_none' ? blackBoardState === '_prepareing' ? _TkGlobal2['default'].language.languageData.header.tool.blackBoard.toolBtn.dispenseed : blackBoardState === '_dispenseed' ? _TkGlobal2['default'].language.languageData.header.tool.blackBoard.toolBtn.recycle : blackBoardState === '_recycle' ? _TkGlobal2['default'].language.languageData.header.tool.blackBoard.toolBtn.againDispenseed : blackBoardState === '_againDispenseed' ? _TkGlobal2['default'].language.languageData.header.tool.blackBoard.toolBtn.recycle : '' : '';
	
	            var _that$_loadBlackBoardElementArray = that._loadBlackBoardElementArray(blackBoardDescList);
	
	            var tabContentBlackBoardElementArray = _that$_loadBlackBoardElementArray.tabContentBlackBoardElementArray;
	            var tabBlackBoardElementArray = _that$_loadBlackBoardElementArray.tabBlackBoardElementArray;
	
	            var _that$_loadToolColorsElementArray = that._loadToolColorsElementArray();
	
	            var toolColorsArray = _that$_loadToolColorsElementArray.toolColorsArray;
	
	            var blackboardNumber = Object.keys(blackBoardDescList).length;
	            var totalPage = Math.ceil(blackboardNumber / (that.maxBlackboardNumber - 1));
	            var tapContentStyle = undefined;
	            var hideTap = !(blackBoardState === '_recycle' || (blackBoardState === '_dispenseed' || blackBoardState === '_againDispenseed') && (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol || _TkConstant2['default'].hasRole.rolePlayback));
	            var hideBottom = _TkConstant2['default'].hasRole.rolePlayback || _TkConstant2['default'].hasRole.rolePatrol || _TkConstant2['default'].hasRole.roleStudent && !(blackBoardState === '_dispenseed' || blackBoardState === '_againDispenseed');
	            if (TK.SDKTYPE === 'mobile') {
	                var ohterContentHeightRem = 0.44; //0.44:title , 0.46:bottom , tap:0.3452
	                if (!hideTap) {
	                    ohterContentHeightRem += 0.3452;
	                }
	                if (!hideBottom) {
	                    ohterContentHeightRem += 0.46;
	                }
	                tapContentStyle = {
	                    height: 'calc( 100% - ' + ohterContentHeightRem + 'rem )'
	                };
	            }
	            return _react2['default'].createElement(
	                'section',
	                { id: id, className: 'black-board-container', style: { display: show ? 'block' : 'none', position: "absolute", opacity: blackboardThumbnailImage === undefined ? undefined : 0, zIndex: blackboardThumbnailImage === undefined ? undefined : -999 } },
	                _react2['default'].createElement(
	                    'article',
	                    { className: 'title-container' },
	                    _react2['default'].createElement(
	                        'span',
	                        { className: 'title' },
	                        _TkGlobal2['default'].language.languageData.header.tool.blackBoard.content.blackboardHeadTitle
	                    ),
	                    TK.SDKTYPE === 'mobile' ? _react2['default'].createElement(
	                        'button',
	                        { className: 'blackboard-thumbnail-image', onTouchStart: that.blackboardThumbnailImageClick.bind(that, { action: 'shrink' }), title: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.title.shrink },
	                        _TkGlobal2['default'].language.languageData.header.tool.blackBoard.title.shrink
	                    ) : undefined,
	                    _react2['default'].createElement('button', { className: 'close', style: { display: !(_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) ? 'none' : '' }, title: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.title.close, onTouchStart: that.handlerCloseClick.bind(that) })
	                ),
	                _react2['default'].createElement(
	                    'article',
	                    { className: 'tap-container clear-float', style: { display: hideTap ? 'none' : '' } },
	                    _react2['default'].createElement('button', { className: "prev add-fl " + (that.state.currentTapPage <= 1 ? 'disabled' : ''), disabled: that.state.currentTapPage <= 1, style: { display: blackboardNumber < that.maxBlackboardNumber ? 'none' : '' }, title: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.title.prev, onTouchStart: !(that.state.currentTapPage <= 1) ? that.onTapPrevOrNextClick.bind(that, 'prev', true) : undefined }),
	                    _react2['default'].createElement(
	                        'ul',
	                        { className: 'tap add-fl clear-float' },
	                        tabBlackBoardElementArray
	                    ),
	                    _react2['default'].createElement('button', { className: "next add-fr " + (that.state.currentTapPage >= totalPage ? 'disabled' : ''), disabled: that.state.currentTapPage >= totalPage, style: { display: blackboardNumber < that.maxBlackboardNumber ? 'none' : '' }, title: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.title.next, onTouchStart: !(that.state.currentTapPage >= totalPage) ? that.onTapPrevOrNextClick.bind(that, 'next', true) : undefined })
	                ),
	                _react2['default'].createElement(
	                    'article',
	                    { className: 'tab-content-container', id: 'blackboardContentBox', style: tapContentStyle },
	                    _react2['default'].createElement(
	                        'ul',
	                        { style: { width: containerWidthAndHeight.width + 'px', height: containerWidthAndHeight.height + 'px' }, className: 'tab-content clear-float overflow-hidden' },
	                        tabContentBlackBoardElementArray
	                    )
	                ),
	                _react2['default'].createElement(
	                    'article',
	                    { id: 'blackboard-tool-container', className: 'blackboard-tool-container clear-float', style: { display: hideBottom ? 'none' : '' } },
	                    _react2['default'].createElement(
	                        'ul',
	                        { className: 'blackboard-tool clear-float', style: { display: _TkConstant2['default'].hasRole.rolePlayback || _TkConstant2['default'].hasRole.rolePatrol || _TkConstant2['default'].hasRole.roleStudent && !(blackBoardState === '_dispenseed' || blackBoardState === '_againDispenseed') ? 'none' : '' } },
	                        _react2['default'].createElement(
	                            'li',
	                            { className: 'blackboard-tool-option' },
	                            _react2['default'].createElement('button', { id: 'blackboard_tool_vessel_pencil', className: "tool-btn pencil-icon " + (useToolKey === 'tool_pencil' ? ' active' : ''), title: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.boardTool.pen, onTouchStart: that.handleToolClick.bind(that, 'tool_pencil') })
	                        ),
	                        _react2['default'].createElement(
	                            'li',
	                            { className: 'blackboard-tool-option' },
	                            _react2['default'].createElement('button', { id: 'blackboard_tool_vessel_text', className: "tool-btn text-icon" + (useToolKey === 'tool_text' ? ' active' : ''), title: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.boardTool.text, onTouchStart: that.handleToolClick.bind(that, 'tool_text') })
	                        ),
	                        _react2['default'].createElement(
	                            'li',
	                            { className: 'blackboard-tool-option' },
	                            _react2['default'].createElement('button', { id: 'blackboard_tool_vessel_eraser', className: "tool-btn eraser-icon" + (useToolKey === 'tool_eraser' ? ' active' : ''), title: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.boardTool.eraser, onTouchStart: that.handleToolClick.bind(that, 'tool_eraser') })
	                        ),
	                        _react2['default'].createElement(
	                            'li',
	                            { className: 'blackboard-tool-option colors  add-position-relative' },
	                            _react2['default'].createElement(
	                                'button',
	                                { id: 'blackboard_tool_vessel_color', className: 'tool-btn colors-icon', title: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.boardTool.color },
	                                _react2['default'].createElement('span', { className: 'current-color', style: { backgroundColor: this.state.useToolColor } })
	                            ),
	                            _react2['default'].createElement(
	                                'div',
	                                { className: 'blackboard-color-size-box' },
	                                _react2['default'].createElement(
	                                    'ul',
	                                    { className: 'tool-size-container', id: 'blackboard_tool_size' },
	                                    _react2['default'].createElement(
	                                        'li',
	                                        { id: 'blackboard_size_small', onTouchStart: that._changeStrokeSizeClick.bind(that, 'blackboard_size_small', { pencil: 5, text: 30, eraser: 30 }), className: "size-small " + (this.state.selectBlackboardToolSizeId === 'blackboard_size_small' ? 'active' : ''), 'data-pencil-size': '5', 'data-text-size': '30', 'data-eraser-size': '15' },
	                                        _react2['default'].createElement('span', null)
	                                    ),
	                                    _react2['default'].createElement(
	                                        'li',
	                                        { id: 'blackboard_size_middle', onTouchStart: that._changeStrokeSizeClick.bind(that, 'blackboard_size_middle', { pencil: 15, text: 36, eraser: 90 }), className: "size-middle " + (this.state.selectBlackboardToolSizeId === 'blackboard_size_middle' ? 'active' : ''), 'data-pencil-size': '15', 'data-text-size': '36', 'data-eraser-size': '45' },
	                                        _react2['default'].createElement('span', null)
	                                    ),
	                                    _react2['default'].createElement(
	                                        'li',
	                                        { id: 'blackboard_size_big', onTouchStart: that._changeStrokeSizeClick.bind(that, 'blackboard_size_big', { pencil: 30, text: 72, eraser: 150 }), className: "size-big " + (this.state.selectBlackboardToolSizeId === 'blackboard_size_big' ? 'active' : ''), 'data-pencil-size': '30', 'data-text-size': '72', 'data-eraser-size': '90' },
	                                        _react2['default'].createElement('span', null)
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'ol',
	                                    { className: 'colors-container' },
	                                    toolColorsArray
	                                )
	                            )
	                        )
	                    ),
	                    _react2['default'].createElement(
	                        'button',
	                        { style: { display: !(_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) ? 'none' : '' }, className: "blackboard-send-btn " + (this.state.disabledBlackboardToolBtn ? 'disabled' : ''), disabled: this.state.disabledBlackboardToolBtn, onTouchStart: that.handlerBlackBoardDispatchClick.bind(that) },
	                        blackboardToolBtnText
	                    )
	                )
	            );
	        }
	    }]);
	
	    return MoreBlackboardSmart;
	})(_react2['default'].Component);
	
	;
	exports['default'] = MoreBlackboardSmart;
	module.exports = exports['default'];
	/*<p className="blackboard-size-title">{TkGlobal.language.languageData.header.tool.colorAndMeasure.selectMeasure}</p>*/ /*<p className="colors-container-title">{TkGlobal.language.languageData.header.tool.colorAndMeasure.selectColorText}</p>*/

/***/ }),

/***/ 258:
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {/**
	 * 动态PPT Smart组件
	 * @module NewpptSmart
	 * @description   提供 动态PPT功能的Smart组件
	 * @author QiuShao
	 * @date 2017/7/27
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _ServiceTools = __webpack_require__(120);
	
	var _ServiceTools2 = _interopRequireDefault(_ServiceTools);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _plugsNewPptJsNewPptCustom = __webpack_require__(259);
	
	var _plugsNewPptJsNewPptCustom2 = _interopRequireDefault(_plugsNewPptJsNewPptCustom);
	
	var NewpptSmart = (function (_React$Component) {
	    _inherits(NewpptSmart, _React$Component);
	
	    function NewpptSmart(props) {
	        _classCallCheck(this, NewpptSmart);
	
	        _get(Object.getPrototypeOf(NewpptSmart.prototype), 'constructor', this).call(this, props);
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	        this.fileid = undefined; //切换文件或者打开文件之前的文件id
	        this.pptvideoStream = undefined;
	        this.state = {
	            updateState: false
	        };
	        this.newPptActionJson = {};
	    }
	
	    _createClass(NewpptSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            that._lcInit();
	            _eventObjectDefine2['default'].Window.addEventListener(_TkConstant2['default'].EVENTTYPE.WindowEvent.onMessage, that.handlerOnMessage.bind(that), that.listernerBackupid); //接收onMessage事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //room-pubmsg事件：动态ppt处理
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //room-delmsg事件：动态ppt处理
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.streamAdded_media, that.handlerStreamAdded_media.bind(that), that.listernerBackupid); //streamAdded_media事件：动态ppt处理
	            _eventObjectDefine2['default'].CoreController.addEventListener('mobileSdk_closeDynamicPptWebPlay', that.handlerMobileSdk_closeDynamicPptWebPlay.bind(that), that.listernerBackupid); //mobileSdk_closeDynamicPptWebPlay事件：动态ppt处理
	            _eventObjectDefine2['default'].CoreController.addEventListener('mobileSdk_changeDynamicPptSize', that.handlermobileSdk_changeDynamicPptSize.bind(that), that.listernerBackupid); //mobileSdk_changeDynamicPptSize 事件：动态ppt处理
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-ShowPage-lastDocument", that.handlerReceiveMsglistShowPageLastDocument.bind(that), that.listernerBackupid); //接收ShowPage信令：动态PPT处理
	            _eventObjectDefine2['default'].CoreController.addEventListener("setNewPptFrameSrc", that.handlerSetNewPptFrameSrc.bind(that), that.listernerBackupid); //setNewPptFrameSrc：设置动态PPT的路径
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_newpptPagingPage", that.handlerUpdateAppPermissions_newpptPagingPage.bind(that), that.listernerBackupid); //updateAppPermissions_newpptPagingPage：更新动态PPT翻页权限
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_publishDynamicPptMediaPermission_video", that.handlerUpdateAppPermissions_publishDynamicPptMediaPermission_video.bind(that), that.listernerBackupid); //updateAppPermissions_publishDynamicPptMediaPermission_video：更新动态PPT视频发布权限
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_dynamicPptActionClick", that.handlerUpdateAppPermissions_dynamicPptActionClick.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener("initAppPermissions", that.handlerInitAppPermissions.bind(that), that.listernerBackupid); //initAppPermissions：初始化权限处理
	            _eventObjectDefine2['default'].CoreController.addEventListener("openDocuemntOrMediaFile", that.handlerOpenDocuemntOrMediaFile.bind(that), that.listernerBackupid); //openDocuemntOrMediaFile：打开文档或者媒体文件
	            _eventObjectDefine2['default'].CoreController.addEventListener("newpptPrevStepClick", that.handlerNewpptPrevStepClick.bind(that), that.listernerBackupid); //接收newpptPrevStepClick事件:上一帧操作
	            _eventObjectDefine2['default'].CoreController.addEventListener("newpptNextStepClick", that.handlerNewpptNextStepClick.bind(that), that.listernerBackupid); //接收newpptNextStepClick事件：下一帧操作
	            _eventObjectDefine2['default'].CoreController.addEventListener("newpptPrevSlideClick", that.handlerNewpptPrevSlideClick.bind(that), that.listernerBackupid); //接收newpptPrevSlideClick事件:上一页操作
	            _eventObjectDefine2['default'].CoreController.addEventListener("newpptNextSlideClick", that.handlerNewpptNextSlideClick.bind(that), that.listernerBackupid); //接收newpptNextSlideClick事件：下一页操作
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-ClassBegin", that.handlerReceiveMsglistClassBegin.bind(that), that.listernerBackupid); //接收receive-msglist-ClassBegin事件
	            _eventObjectDefine2['default'].CoreController.addEventListener("playDynamicPPTMediaStream", that.handlerPlayDynamicPPTMediaStream.bind(that), that.listernerBackupid); //接收playDynamicPPTMediaStream事件
	            _eventObjectDefine2['default'].CoreController.addEventListener("skipPage_dynamicPPT", that.handlerSkipPage_dynamicPPT.bind(that), that.listernerBackupid); //skipPage_dynamicPPT：动态PPT跳转
	            // eventObjectDefine.CoreController.addEventListener("layerIsShowOfDraging" ,that.layerIsShowOfDraging.bind(that) , that.listernerBackupid); //skipPage_dynamicPPT：动态PPT跳转
	
	            /*发送动态PPT信令消息*/
	            $(document).off("sendPPTMessageEvent");
	            $(document).on("sendPPTMessageEvent", function (event, data, isInitiative) {
	                //发送PPT数据给其它人
	                that._handlerSendPPTMessageEvent(data, isInitiative);
	            });
	
	            /*绑定动态PPT更新总页数给白板事件*/
	            $(document).off("updateSlidesCountToLcElement");
	            $(document).on("updateSlidesCountToLcElement", function (event, data) {
	                if (data) {
	                    var callbackHandler = function callbackHandler(fileInfo) {
	                        Object.assign(fileInfo, data);
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setFileDataToLcElement', message: { filedata: fileInfo } });
	                    };
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	                }
	            });
	
	            /*绑定动态PPT更新白板当前页画笔数据事件*/
	            $(document).off("slideChangeToLcData");
	            $(document).on("slideChangeToLcData", function (event, data) {
	                if (data) {
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'saveLcStackToStorage', message: {} });
	                    var callbackHandler = function callbackHandler(fileInfo) {
	                        Object.assign(fileInfo, data);
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setFileDataToLcElement', message: { filedata: fileInfo } });
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'recoverCurrpageLcData' }); //画当前文档当前页数据到白板上
	                    };
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	                }
	            });
	
	            /*绑定动态PPT更新白板尺寸事件*/
	            $(document).off("updateLcScaleWhenAynicPPTInit");
	            $(document).on("updateLcScaleWhenAynicPPTInit", function (event, data) {
	                if (data && data.Width && data.Height) {
	                    that._updateLcScaleWhenAynicPPTInitHandler(data.Width / data.Height);
	                }
	            });
	
	            /*更新白板的缩放比例*/
	            $(document).off("updateLcScale");
	            $(document).on("updateLcScale", function (event, data) {
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'resizeHandler', message: { eleWHPercent: data } });
	            });
	
	            /*更新白板的缩放比例*/
	            $(document).off("newppt_changeFileElementProperty");
	            $(document).on("newppt_changeFileElementProperty", function (event, data) {
	                var callbackHandler = function callbackHandler(fileInfo) {
	                    Object.assign(fileInfo, data); //将动态ppt数据的数据浅拷贝到文件信息中
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setFileDataToLcElement', message: { filedata: fileInfo } });
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updatePagdingState', message: { source: 'newppt', data: fileInfo } });
	                };
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	            });
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	            _eventObjectDefine2['default'].Window.removeBackupListerner(that.listernerBackupid);
	            $(document).off("sendPPTMessageEvent");
	            $(document).off("slideChangeToLcData");
	            $(document).off("updateSlidesCountToLcElement");
	            $(document).off("updateLcScaleWhenAynicPPTInit");
	            $(document).off("updateLcScale");
	            $(document).off("newppt_changeFileElementProperty");
	        }
	    }, {
	        key: 'handlermobileSdk_changeDynamicPptSize',
	        value: function handlermobileSdk_changeDynamicPptSize(recvEventData) {
	            if (TK.SDKTYPE === 'mobile' && recvEventData.message && typeof recvEventData.message === 'object') {
	                var data = {
	                    action: "resizeHandler"
	                };
	                Object.assign(data, recvEventData.message);
	                this.ServiceNewPptAynamicPPT.postMessage(data);
	            }
	        }
	    }, {
	        key: 'handlerOnMessage',
	        value: function handlerOnMessage(recvEventData) {
	            var that = this;
	            var event = recvEventData.message.event;
	
	            that.handlerIframeMessage(event); //iframe框架消息处理函数
	        }
	    }, {
	        key: 'handlerRoomPubmsg',
	        value: function handlerRoomPubmsg(pubmsgDataEvent) {
	            var _this = this;
	
	            //room-pubmsg事件：动态ppt处理
	            var that = this;
	            var pubmsgData = pubmsgDataEvent.message;
	            switch (pubmsgData.name) {
	                case "ShowPage":
	                    var open = that._saveFileidReturnOpen(pubmsgData.data);
	                    that._handlerReceiveShowPageSignalling({ message: { data: pubmsgData.data, open: open, source: 'room-pubmsg' } });
	                    break;
	                case "NewPptTriggerActionClick":
	                    //动态PPT动作
	                    if (that.ServiceNewPptAynamicPPT.isOpenPptFile === true) {
	                        (function () {
	                            var data = pubmsgData.data;
	                            var newSlide = data.slide;
	                            var newFileid = data.fileid;
	                            newSlide = newSlide + 1;
	                            var callbackHandler = function callbackHandler(fileInfo) {
	                                var currpage = fileInfo.currpage;
	                                var fileid = fileInfo.fileid;
	
	                                if ((currpage !== newSlide || newFileid !== fileid) && _TkGlobal2['default'].playback) {
	                                    if (_this.newPptActionJson[newSlide] && _this.newPptActionJson[newSlide].length > 0) {
	                                        _this.newPptActionJson[newSlide].push(data);
	                                    } else {
	                                        _this.newPptActionJson[newSlide] = [];
	                                        _this.newPptActionJson[newSlide].push(data);
	                                    }
	                                    L.Logger.warning('iframe加载好之前保存ppt动作：', _this.newPptActionJson);
	                                }
	                            };
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'getFileDataFromLcElement',
	                                message: { callback: callbackHandler }
	                            });
	                            that.ServiceNewPptAynamicPPT.postMessage(pubmsgData.data);
	                        })();
	                    }
	                    break;
	                case "ClassBegin":
	                    that.handlerClassBeginCloseDynamicPptVideo();
	                    that._handlerClassBeginStartOrEnd();
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerRoomDelmsg',
	        value: function handlerRoomDelmsg(delmsgDataEvent) {
	            //room-delmsg事件：动态ppt处理
	            var that = this;
	            var delmsgData = delmsgDataEvent.message;
	            switch (delmsgData.name) {
	                case "ClassBegin":
	                    that._handlerClassBeginStartOrEnd();
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerStreamAdded_media',
	        value: function handlerStreamAdded_media(recvEventData) {
	            if (TK.SDKTYPE === 'pc') {
	                var that = this;
	                var stream = recvEventData.stream;
	
	                var attributes = stream.getAttributes();
	                if (attributes && attributes.type === 'media') {
	                    var data = {
	                        action: "closeDynamicPptAutoVideo"
	                    };
	                    that.ServiceNewPptAynamicPPT.postMessage(data);
	                }
	            }
	        }
	    }, {
	        key: 'handlerMobileSdk_closeDynamicPptWebPlay',
	        value: function handlerMobileSdk_closeDynamicPptWebPlay(recvEventData) {
	            if (TK.SDKTYPE === 'mobile') {
	                var data = {
	                    action: "closeDynamicPptAutoVideo"
	                };
	                this.ServiceNewPptAynamicPPT.postMessage(data);
	            }
	        }
	    }, {
	        key: 'handlerIframeMessage',
	        value: function handlerIframeMessage(event) {
	            var _this2 = this;
	
	            //iframe框架消息处理函数
	            var that = this;
	            // 通过origin属性判断消息来源地址
	            if (event.data) {
	                var _ret2 = (function () {
	                    var data = undefined;
	                    var recvData = undefined;
	                    try {
	                        recvData = JSON.parse(event.data);
	                        data = recvData.data;
	                    } catch (e) {
	                        L.Logger.warning("iframe message data can't be converted to JSON , iframe data:", event.data);
	                        return {
	                            v: undefined
	                        };
	                    }
	                    if (recvData.source === "tk_dynamicPPT") {
	                        L.Logger.debug("[dynamicPpt]receive remote iframe data form " + event.origin + ":", event);
	                        var INITEVENT = "initEvent";
	                        var SLIDECHANGEEVENT = "slideChangeEvent";
	                        var STEPCHANGEEVENT = "stepChangeEvent";
	                        var AUTOPLAYVIDEOINNEWPPT = "autoPlayVideoInNewPpt";
	                        var CLICKNEWPPTTRIGGEREVENT = "clickNewpptTriggerEvent";
	                        var CLICKLINK = "clickLink";
	                        switch (data.action) {
	                            case INITEVENT:
	                                that.ServiceNewPptAynamicPPT.remoteData.view = data.view;
	                                that.ServiceNewPptAynamicPPT.remoteData.slidesCount = data.slidesCount;
	                                that.ServiceNewPptAynamicPPT.remoteData.slide = data.slide;
	                                that.ServiceNewPptAynamicPPT.remoteData.step = data.step;
	                                that.ServiceNewPptAynamicPPT.remoteData.stepTotal = data.stepTotal;
	                                that.ServiceNewPptAynamicPPT.recvInitEventHandler(data.slide, data.step, data.externalData);
	                                break;
	                            case SLIDECHANGEEVENT:
	                                var _callback = function _callback(fileInfo) {
	                                    var currpage = fileInfo.currpage;
	
	                                    if (!_TkUtils2['default'].isEmpty(_this2.newPptActionJson) && _this2.newPptActionJson[currpage]) {
	                                        if (_this2.newPptActionJson[currpage].length !== 0) {
	                                            _this2.newPptActionJson[currpage].map(function (item, index) {
	                                                that.ServiceNewPptAynamicPPT.postMessage(item); //执行当前页的动作（触发器）
	                                            });
	                                            _this2.newPptActionJson = {};
	                                        }
	                                    }
	                                };
	                                that.ServiceNewPptAynamicPPT.remoteData.slide = data.slide;
	                                that.ServiceNewPptAynamicPPT.remoteData.step = data.step;
	                                that.ServiceNewPptAynamicPPT.remoteData.stepTotal = data.stepTotal;
	                                that.ServiceNewPptAynamicPPT.recvSlideChangeEventHandler(data.slide, data.externalData);
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: _callback } });
	                                if (that.ServiceNewPptAynamicPPT.isInitiative(data.externalData)) {
	                                    //点击时是否收回列表
	                                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'resetAllLeftToolButtonOpenStateToFalse' });
	                                }
	                                break;
	                            case STEPCHANGEEVENT:
	                                var _callbackHandler = function _callbackHandler(fileInfo) {
	                                    var currpage = fileInfo.currpage;
	
	                                    if (!_TkUtils2['default'].isEmpty(_this2.newPptActionJson) && _this2.newPptActionJson[currpage]) {
	                                        if (_this2.newPptActionJson[currpage].length !== 0) {
	                                            _this2.newPptActionJson[currpage].map(function (item, index) {
	                                                that.ServiceNewPptAynamicPPT.postMessage(item); //执行当前页的动作（触发器）
	                                            });
	                                            _this2.newPptActionJson = {};
	                                        }
	                                    }
	                                };
	                                that.ServiceNewPptAynamicPPT.remoteData.slide = data.slide;
	                                that.ServiceNewPptAynamicPPT.remoteData.step = data.step;
	                                that.ServiceNewPptAynamicPPT.remoteData.stepTotal = data.stepTotal;
	                                that.ServiceNewPptAynamicPPT.recvStepChangeEventHandler(data.step, data.externalData);
	                                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: _callbackHandler } });
	                                if (that.ServiceNewPptAynamicPPT.isInitiative(data.externalData)) {
	                                    //点击时是否收回列表
	                                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'resetAllLeftToolButtonOpenStateToFalse' });
	                                }
	                                break;
	                            case AUTOPLAYVIDEOINNEWPPT:
	                                var _data = data,
	                                    isvideo = _data.isvideo,
	                                    url = _data.url,
	                                    fileid = _data.fileid,
	                                    pptslide = _data.pptslide;
	
	                                if (isvideo && !_TkGlobal2['default'].playback) {
	                                    var videoUrl = that.ServiceNewPptAynamicPPT.rPathAddress + url;
	                                    var pptVideoJson = {
	                                        url: videoUrl,
	                                        fileid: fileid ? Number(fileid) : fileid,
	                                        isvideo: isvideo,
	                                        pptslide: pptslide ? Number(pptslide) : pptslide
	                                    };
	                                    that._newpptAutoPlayVideoInNewPpt(pptVideoJson);
	                                }
	                                break;
	                            case CLICKNEWPPTTRIGGEREVENT:
	                                if (that.props.fileTypeMark === 'dynamicPPT' && _CoreController2['default'].handler.getAppPermissions('sendSignallingFromDynamicPptTriggerActionClick') && that.ServiceNewPptAynamicPPT.isInitiative(data.externalData)) {
	                                    var callbackHandler = function callbackHandler(fileInfo) {
	                                        var fileid = fileInfo.fileid;
	
	                                        data.fileid = fileid;
	                                    };
	                                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	                                    _ServiceSignalling2['default'].sendSignallingFromDynamicPptTriggerActionClick(data);
	                                    //点击时是否收回列表
	                                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'resetAllLeftToolButtonOpenStateToFalse' });
	                                }
	                                break;
	                            case CLICKLINK:
	                                //todo 超链接 ， bug:触发器的也会走这
	                                if (that.props.fileTypeMark === 'dynamicPPT' && _CoreController2['default'].handler.getAppPermissions('sendSignallingFromDynamicPptTriggerClickLink') && that.ServiceNewPptAynamicPPT.isInitiative(data.externalData)) {
	                                    // ServiceSignalling.sendSignallingFromDynamicPptTriggerClickLink(data);
	                                }
	                                break;
	                        };
	                    }
	                })();
	
	                if (typeof _ret2 === 'object') return _ret2.v;
	            }
	        }
	    }, {
	        key: 'handlerSetNewPptFrameSrc',
	        value: function handlerSetNewPptFrameSrc(recvEventData) {
	            var that = this;
	            that.ServiceNewPptAynamicPPT.setNewPptFrameSrc(recvEventData.message.src || "");
	        }
	    }, {
	        key: 'handlerReceiveMsglistShowPageLastDocument',
	        value: function handlerReceiveMsglistShowPageLastDocument(showpageData) {
	            var that = this;
	            var open = that._saveFileidReturnOpen(showpageData.message.data);
	            showpageData.message.open = open;
	            that._handlerReceiveShowPageSignalling(showpageData);
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_newpptPagingPage',
	        value: function handlerUpdateAppPermissions_newpptPagingPage() {
	            var that = this;
	            if (that.props.fileTypeMark === 'dynamicPPT') {
	                var callbackHandler = function callbackHandler(fileInfo) {
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updatePagdingState', message: { source: 'newppt', data: fileInfo } });
	                };
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	                var data = {
	                    action: "changeNewpptPagingPage",
	                    newpptPagingPage: _CoreController2['default'].handler.getAppPermissions('newpptPagingPage')
	                };
	                that.ServiceNewPptAynamicPPT.postMessage(data);
	            }
	        }
	    }, {
	        key: 'handlerInitAppPermissions',
	        value: function handlerInitAppPermissions() {
	            var that = this;
	            that.handlerUpdateAppPermissions_newpptPagingPage();
	            that.handlerUpdateAppPermissions_publishDynamicPptMediaPermission_video();
	            that.handlerUpdateAppPermissions_dynamicPptActionClick();
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_publishDynamicPptMediaPermission_video',
	        value: function handlerUpdateAppPermissions_publishDynamicPptMediaPermission_video() {
	            //动态PPT视频播放权限更改后通知iframe
	            var that = this;
	            var data = {
	                action: "changePublishDynamicPptMediaPermission_video",
	                publishDynamicPptMediaPermission_video: _CoreController2['default'].handler.getAppPermissions('publishDynamicPptMediaPermission_video')
	            };
	            that.ServiceNewPptAynamicPPT.postMessage(data);
	        }
	    }, {
	        key: 'handlerOpenDocuemntOrMediaFile',
	        value: function handlerOpenDocuemntOrMediaFile(recvEventData) {
	            var that = this;
	            var fileDataInfo = recvEventData.message;
	            var open = that._saveFileidReturnOpen(fileDataInfo);
	            if (fileDataInfo.isDynamicPPT) {
	                //如果是动态PPT
	                that._handlerReceiveShowPageSignalling({ message: { data: fileDataInfo, open: open, source: 'newpptFileClickEvent' } });
	                /*fileDataInfo格式:
	                     const fileDataInfo = {
	                         isGeneralFile:file.isGeneralFile,
	                         isMedia:file.isMediaFile,
	                         isDynamicPPT:file.isDynamicPPT,
	                         action: file.isDynamicPPT?"show":"",
	                         mediaType:file.isMediaFile?file.filetype:null,
	                         filedata: {
	                             fileid: file.fileid,
	                             currpage: file.currentPage,
	                             pagenum: file.pagenum,
	                             filetype: file.filetype,
	                             filename: file.filename,
	                             swfpath: file.swfpath,
	                             pptslide: file.pptslide,
	                             pptstep: file.pptstep,
	                             steptotal:file.steptotal
	                         }
	                     }
	                 * */
	            }
	        }
	    }, {
	        key: 'handlerNewpptPrevStepClick',
	        value: function handlerNewpptPrevStepClick() {
	            var that = this;
	            that.ServiceNewPptAynamicPPT.recvCount = 0;
	            that.ServiceNewPptAynamicPPT.gotoPreviousStep();
	        }
	    }, {
	        key: 'handlerNewpptNextStepClick',
	        value: function handlerNewpptNextStepClick() {
	            var that = this;
	            that.ServiceNewPptAynamicPPT.recvCount = 0;
	            that.ServiceNewPptAynamicPPT.gotoNextStep();
	        }
	    }, {
	        key: 'handlerNewpptPrevSlideClick',
	        value: function handlerNewpptPrevSlideClick() {
	            var that = this;
	            var autoStart = true;
	            that.ServiceNewPptAynamicPPT.recvCount = 0;
	            that.ServiceNewPptAynamicPPT.gotoPreviousSlide(autoStart);
	        }
	    }, {
	        key: 'handlerNewpptNextSlideClick',
	        value: function handlerNewpptNextSlideClick() {
	            var that = this;
	            var autoStart = true;
	            that.ServiceNewPptAynamicPPT.recvCount = 0;
	            that.ServiceNewPptAynamicPPT.gotoNextSlide(autoStart);
	        }
	    }, {
	        key: 'handlerReceiveMsglistClassBegin',
	        value: function handlerReceiveMsglistClassBegin() {
	            var that = this;
	            that._handlerClassBeginStartOrEnd();
	        }
	    }, {
	        key: 'handlerPlayDynamicPPTMediaStream',
	        value: function handlerPlayDynamicPPTMediaStream(recvEventData) {
	            var that = this;
	            var _recvEventData$message = recvEventData.message;
	            var show = _recvEventData$message.show;
	            var stream = _recvEventData$message.stream;
	
	            if (show) {
	                that.handlerUpdateAppPermissions_newpptPagingPage();
	            } else {
	                that.handlerUpdateAppPermissions_newpptPagingPage();
	            }
	        }
	    }, {
	        key: 'handlerSkipPage_dynamicPPT',
	        value: function handlerSkipPage_dynamicPPT(recvEventData) {
	            var that = this;
	            if (that.props.fileTypeMark === 'dynamicPPT') {
	                var currpage = recvEventData.message.currpage;
	
	                that._skipDynamicPPTPaging(currpage);
	            }
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_dynamicPptActionClick',
	        value: function handlerUpdateAppPermissions_dynamicPptActionClick() {
	            var that = this;
	            this.setState({ updateState: !this.state.updateState });
	            var data = {
	                action: "changeDynamicPptActionClick",
	                dynamicPptActionClick: _CoreController2['default'].handler.getAppPermissions('dynamicPptActionClick')
	            };
	            that.ServiceNewPptAynamicPPT.postMessage(data);
	        }
	    }, {
	        key: '_openAynamicPPTHandler',
	        value: function _openAynamicPPTHandler(filedata) {
	            //打开动态PPT
	            var that = this;
	            var fileTypeMark = 'dynamicPPT';
	            that.props.changeFileTypeMark(fileTypeMark); //改变fileTypeMark的值
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'saveLcStackToStorage', message: {} });
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setFileDataToLcElement', message: { filedata: filedata } });
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'recoverCurrpageLcData' }); //画当前文档当前页数据到白板上
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'resetLcDefault' });
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setH5FileFrameSrc', message: { src: '' } });
	            var fileid = filedata.fileid;
	            var swfpath = filedata.swfpath;
	            var pptslide = filedata.pptslide;
	            var pptstep = filedata.pptstep;
	
	            var newpptVersions = _TkConstant2['default'].newpptVersions;
	            var remoteNewpptUpdateTime = _TkConstant2['default'].remoteNewpptUpdateTime;
	            // swfpath = "/upload/20171120_142511_snzsmeix";
	            var options = {
	                // rPathAddress:   "http://192.168.1.182:80" + swfpath+"/"  ,
	                rPathAddress: _TkConstant2['default'].SERVICEINFO.protocolAndHostname + ":" + _TkConstant2['default'].SERVICEINFO.port + swfpath + "/",
	                PresAddress: "newppt.html?remoteHost=" + window.location.host + "&remoteProtocol=" + window.location.protocol + "&versions=" + newpptVersions + "&fileid=" + fileid + "&playback=" + _TkGlobal2['default'].playback + "&classbegin=" + _TkGlobal2['default'].classBegin + "&publishDynamicPptMediaPermission_video=" + _CoreController2['default'].handler.getAppPermissions('publishDynamicPptMediaPermission_video') + "&remoteNewpptUpdateTime=" + remoteNewpptUpdateTime + "&role=" + (_TkConstant2['default'].joinRoomInfo ? _TkConstant2['default'].joinRoomInfo.roomrole : undefined) + "&dynamicPptActionClick=" + _CoreController2['default'].handler.getAppPermissions('dynamicPptActionClick') + "&newpptPagingPage=" + _CoreController2['default'].handler.getAppPermissions('newpptPagingPage') + "&dynamicPptDebug=" + _TkConstant2['default'].DEV + "&ts=" + new Date().getTime(),
	                slideIndex: pptslide,
	                stepIndex: pptstep,
	                fileid: fileid
	            };
	            this.setState({ updateState: !this.state.updateState });
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'closeLoading' });
	            that._updateLcScaleWhenAynicPPTInitHandler(16 / 9);
	            that.ServiceNewPptAynamicPPT.setRPathAndPres(options);
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'checkSelectMouseState', message: { fileTypeMark: fileTypeMark } });
	        }
	    }, {
	        key: '_aynamicPPTJumpToAnim',
	        value: function _aynamicPPTJumpToAnim(slide, step) {
	            //跳转到PPT的某一页的某一个帧
	            var that = this;
	            that.ServiceNewPptAynamicPPT.jumpToAnim(slide, step);
	        }
	    }, {
	        key: '_updateLcScaleWhenAynicPPTInitHandler',
	        value: function _updateLcScaleWhenAynicPPTInitHandler(lcLitellyScalc) {
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateLcScaleWhenAynicPPTInitHandler', message: { lcLitellyScalc: lcLitellyScalc } });
	        }
	    }, {
	        key: '_handlerReceiveShowPageSignalling',
	        value: function _handlerReceiveShowPageSignalling(showpageData) {
	            //接收ShowPage信令：动态PPT处理
	            var that = this;
	            var _showpageData$message = showpageData.message;
	            var data = _showpageData$message.data;
	            var open = _showpageData$message.open;
	
	            var newpptDocumentData = data;
	            if (!newpptDocumentData.isMedia) {
	                if (newpptDocumentData.isDynamicPPT) {
	                    /*  let isReturn  = false ;
	                        const callbackHandler = (fileInfo) => {
	                            if(!open && newpptDocumentData.filedata.fileid === that.fileid  &&  Number(newpptDocumentData.filedata.currpage) === fileInfo.currpage &&  Number(newpptDocumentData.filedata.pptslide) === fileInfo.pptslide
	                                &&  Number(newpptDocumentData.filedata.pptstep) === fileInfo.pptstep ){
	                                isReturn = true ;
	                            }
	                        };
	                        eventObjectDefine.CoreController.dispatchEvent({type:'getFileDataFromLcElement' ,message:{callback:callbackHandler}});
	                       if(isReturn){
	                           return ;
	                       }*/
	                    var isRemote = true;
	                    that._reveiveNewpptDataHandler(newpptDocumentData.filedata, open, isRemote);
	                }
	            }
	        }
	    }, {
	        key: '_reveiveNewpptDataHandler',
	        value: function _reveiveNewpptDataHandler(filedata, openPPT, isRemote) {
	            //接收动态PPT远程数据进行处理
	            var that = this;
	            if (isRemote) {
	                that.ServiceNewPptAynamicPPT.recvCount++;
	            };
	            if (openPPT) {
	                that._openAynamicPPTHandler(filedata);
	                return;
	            }
	            that._aynamicPPTJumpToAnim(filedata.pptslide, filedata.pptstep);
	        }
	    }, {
	        key: '_handlerSendPPTMessageEvent',
	
	        /*动态ppt数据发送*/
	        value: function _handlerSendPPTMessageEvent(data, isInitiative) {
	            var that = this;
	            var callbackHandler = function callbackHandler(fileInfo) {
	                var filedata = fileInfo;
	                var newpptData = that._replaceSendPPTMessageData(filedata, data);
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                    type: 'documentPageChange',
	                    message: newpptData
	                });
	                if (isInitiative) {
	                    that._sendSignallingFromDynamicPptShowPage(newpptData);
	                }
	            };
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'getFileDataFromLcElement', message: { callback: callbackHandler } });
	        }
	    }, {
	        key: '_lcInit',
	        value: function _lcInit() {
	            //动态PPT初始化
	            var that = this;
	            that.ServiceNewPptAynamicPPT = that.ServiceNewPptAynamicPPT || new _plugsNewPptJsNewPptCustom2['default']();
	            that.ServiceNewPptAynamicPPT.clearAll();
	            that.ServiceNewPptAynamicPPT.newDopPresentation();
	        }
	    }, {
	        key: '_replaceSendPPTMessageData',
	        value: function _replaceSendPPTMessageData(oldFiledata, replaceData) {
	            if (replaceData) {
	                oldFiledata.pagenum = replaceData.pagenum != undefined ? replaceData.pagenum : oldFiledata.pagenum;
	                oldFiledata.pptslide = replaceData.pptslide != undefined ? replaceData.pptslide : oldFiledata.pptslide;
	                oldFiledata.pptstep = replaceData.pptstep != undefined ? replaceData.pptstep : oldFiledata.pptstep;
	                oldFiledata.steptotal = replaceData.steptotal != undefined ? replaceData.steptotal : oldFiledata.steptotal;
	                oldFiledata.currpage = replaceData.currpage != undefined ? replaceData.currpage : oldFiledata.currpage;
	            }
	            var newpptData = {
	                isGeneralFile: false,
	                isMedia: false,
	                isDynamicPPT: true,
	                isH5Document: false,
	                action: replaceData.action || '',
	                mediaType: '',
	                filedata: oldFiledata
	            };
	            return newpptData;
	        }
	    }, {
	        key: '_sendSignallingFromDynamicPptShowPage',
	
	        /*发送动态PPT的ShowPage相关数据（action:show/slide/step）
	         * @method sendSignallingFromDynamicPptShowPage*/
	        value: function _sendSignallingFromDynamicPptShowPage(newpptData) {
	            var that = this;
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingFromDynamicPptShowPage')) {
	                return;
	            };
	            var isDelMsg = false;
	            var assignId = 'DocumentFilePage_ShowPage';
	            _ServiceSignalling2['default'].sendSignallingFromShowPage(isDelMsg, assignId, newpptData);
	        }
	    }, {
	        key: '_newpptAutoPlayVideoInNewPpt',
	        value: function _newpptAutoPlayVideoInNewPpt(pptVideoJson) {
	            /*动态PPT视频的处理函数*/
	            var that = this;
	            if (TK.SDKTYPE === 'mobile') {
	                _ServiceRoom2['default'].getTkRoom().dynamicPptVideoAutoPlay(pptVideoJson);
	            } else if (TK.SDKTYPE === 'pc') {
	                /*let roleChairmanList = ServiceRoom.getTkRoom().getSpecifyRoleList(TkConstant.role.roleChairman) ;
	                 if( !TkConstant.hasRole.roleChairman &&  !TkUtils.isEmpty(roleChairmanList) ){ //如果当前房间角色有老师，并且我的角色不是老师，则return
	                 return ;
	                 }*/
	                var mediaAttributes = { filename: "", fileid: pptVideoJson.fileid, type: 'media' };
	                if (!_TkGlobal2['default'].classBegin) {
	                    mediaAttributes.toID = _ServiceRoom2['default'].getTkRoom().getMySelf().id;
	                };
	                that.pptvideoStream = TK.Stream({ video: pptVideoJson.isvideo, audio: true, url: pptVideoJson.url, extensionId: _ServiceRoom2['default'].getTkRoom().getMySelf().id + ":media", attributes: mediaAttributes }, _TkGlobal2['default'].isClient);
	                _ServiceTools2['default'].unpublishAllMediaStream(function (code, stream) {
	                    switch (code) {
	                        case -1:
	                        case 1:
	                            if (!_CoreController2['default'].handler.getAppPermissions('publishMediaStream') || !_CoreController2['default'].handler.getAppPermissions('publishDynamicPptMediaPermission_video')) {
	                                return false;
	                            }
	                            _TkGlobal2['default'].playPptVideoing = true;
	                            that.handlerPlayDynamicPPTMediaStream({ type: 'playDynamicPPTMediaStream', message: { show: true, stream: that.pptvideoStream } }); //手动封装playDynamicPPTMediaStream的数据,给本组件而不给其它组件
	                            _ServiceSignalling2['default'].publishMediaStream(that.pptvideoStream);
	                            break;
	                        case 0:
	                            break;
	                    }
	                });
	            }
	        }
	    }, {
	        key: '_saveFileidReturnOpen',
	        value: function _saveFileidReturnOpen(fileFormatInfo) {
	            //保存文件id，返回是否打开文件
	            var that = this;
	            var open = undefined;
	            if (!fileFormatInfo.isMedia) {
	                //不是媒体文件才有这个操作
	                var fileid = fileFormatInfo.filedata.fileid;
	                open = that.fileid != fileid;
	                that.fileid = fileid;
	            }
	            return open;
	        }
	    }, {
	        key: '_handlerClassBeginStartOrEnd',
	        value: function _handlerClassBeginStartOrEnd() {
	            //处理上下课信令
	            var that = this;
	            var data = {
	                action: "changeClassBegin",
	                classbegin: _TkGlobal2['default'].classBegin
	            };
	            that.ServiceNewPptAynamicPPT.postMessage(data);
	        }
	    }, {
	        key: 'handlerClassBeginCloseDynamicPptVideo',
	        value: function handlerClassBeginCloseDynamicPptVideo() {
	            var that = this;
	            var data = {
	                action: "closeDynamicPptAutoVideo"
	            };
	            that.ServiceNewPptAynamicPPT.postMessage(data);
	        }
	    }, {
	        key: '_skipDynamicPPTPaging',
	        value: function _skipDynamicPPTPaging(currpage) {
	            //动态PPT跳转
	            var that = this;
	            var autoStart = true;
	            that.ServiceNewPptAynamicPPT.recvCount = 0;
	            var step = 0;
	            var slide = currpage;
	            var initiative = true; //主动跳转
	            that.ServiceNewPptAynamicPPT.jumpToAnim(slide, step, initiative);
	        }
	    }, {
	        key: 'render',
	
	        /*layerIsShowOfDraging(handledata) {//根据是否正在拖拽显示课件上的浮层
	            this.setState({isDraging: handledata.message.isDraging});
	        };*/
	        value: function render() {
	            var that = this;
	            var _that$props = that.props;
	            var fileTypeMark = _that$props.fileTypeMark;
	
	            var other = _objectWithoutProperties(_that$props, ['fileTypeMark']);
	
	            if (!that.ServiceNewPptAynamicPPT) {
	                that.ServiceNewPptAynamicPPT = new _plugsNewPptJsNewPptCustom2['default']();
	            }
	            that.ServiceNewPptAynamicPPT.isOpenPptFile = fileTypeMark === 'dynamicPPT';
	            var styleClass = Object.assign({ display: fileTypeMark !== 'dynamicPPT' ? "none" : "block" }, this.props.styleJson);
	            return _react2['default'].createElement(
	                'div',
	                _extends({ style: styleClass, className: 'aynamic-ppt-conwrap add-position-absolute-top0-left0', id: 'aynamic_ppt_newppt' }, _TkUtils2['default'].filterContainDataAttribute(other)),
	                '  ',
	                _react2['default'].createElement(
	                    'div',
	                    { className: 'ppt-vessel', id: 'ppt_vessel_newppt' },
	                    _react2['default'].createElement(
	                        'div',
	                        { className: 'ppt-zoom-container', id: 'ppt_zoom_container_newppt' },
	                        _react2['default'].createElement(
	                            'div',
	                            { id: 'contentHolderNewppt', className: 'aynamic-ppt-container' },
	                            _react2['default'].createElement('iframe', { allowFullScreen: 'true', id: 'newppt_frame', src: '', name: 'myframe' }),
	                            _react2['default'].createElement('div', { id: 'preloader_newppt', className: 'ppt-loading-container add-position-absolute-top0-left0' }),
	                            _react2['default'].createElement('div', { id: 'ppt_not_click_newppt', className: 'ppt-not-click-newppt add-position-absolute-top0-left0' }),
	                            _react2['default'].createElement('div', { className: 'add-position-absolute-top0-left0', style: { width: '100%', height: '100%', zIndex: 1, display: _CoreController2['default'].handler.getAppPermissions('dynamicPptActionClick') ? 'none' : 'block' } })
	                        )
	                    )
	                )
	            );
	        }
	    }]);
	
	    return NewpptSmart;
	})(_react2['default'].Component);
	
	exports['default'] = NewpptSmart;
	
	/*
	export default DropTarget('talkDrag', specTarget, connect => ({
	    connectDropTarget: connect.dropTarget(),
	}))(NewpptSmart);
	*/
	module.exports = exports['default'];
	/*动态PPT插件-is*/
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(41)))

/***/ }),

/***/ 259:
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {/**
	 * 动态PPT组件
	 * @module newPptCustomModule
	 * @description  动态PPT自封装组件
	 * @author QiuShao
	 * @date 2017/7/10
	 */
	'use strict';
	Object.defineProperty(exports, "__esModule", {
	    value: true
	});
	var NewPptAynamicPPTGLOBAL = {};
	var NewPptAynamicPPT = function NewPptAynamicPPT(options) {
	    var that = this;
	    this.options = options || {};
	    this.isResized = false;
	    this.sendMessagePermission = this.options.sendMessagePermission || true; //发送数据的权限
	    this.recvRemoteDataing = this.options.recvRemoteDataing || false; //接收远端数据，则不需要发送信令
	    this.isOpenPptFile = false;
	    NewPptAynamicPPTGLOBAL.newPptAynamicPPT = {
	        that: that
	    };
	    this.aynamicPptData = {
	        old: {
	            slide: null,
	            step: null,
	            fileid: null
	        },
	        now: {
	            slide: null,
	            step: null,
	            fileid: null
	        }
	    };
	    this.remoteData = {};
	    this.recvCount = 0;
	};
	NewPptAynamicPPT.prototype = {
	    constructor: NewPptAynamicPPT,
	    sendMessageToRemote: function sendMessageToRemote(action, externalData, isGetData) {
	        var that = NewPptAynamicPPTGLOBAL.newPptAynamicPPT.that;
	        isGetData = isGetData != undefined ? isGetData : true;
	        //if(that.sendMessagePermission){
	        var data = {};
	        if (isGetData && that.remoteData) {
	            data.pptslide = that.remoteData.slide + 1;
	            data.currpage = that.remoteData.slide + 1;
	            data.pptstep = that.remoteData.step >= 0 ? that.remoteData.step : 0;
	            data.steptotal = that.remoteData.stepTotal;
	        }
	        for (var x in action) {
	            data[x] = action[x];
	        }
	        data["pagenum"] = that.remoteData.slidesCount;
	        var isInitiative = that.isInitiative(externalData);
	        $(document).trigger("sendPPTMessageEvent", [data, isInitiative]);
	        //}
	    },
	    resizeUpdatePPT: function resizeUpdatePPT(that) {
	        that.scale = 1;
	        $(window).trigger("resize");
	    },
	    resizeHandler: function resizeHandler(that) {
	        var that = that || this;
	        if (that.isOpenPptFile) {
	            that.autoChangePptSize(that);
	        }
	    },
	    autoChangePptSize: function autoChangePptSize(that) {
	        that = that || this;
	    },
	    changeAynamicPptData: function changeAynamicPptData() {
	        var that = this;
	        var ts = that.remoteData;
	        if (!(ts.slide != undefined && ts.step != undefined)) {
	            return;
	        }
	        var data = {
	            slide: ts.slide + 1,
	            step: ts.step
	        };
	        for (var key in that.aynamicPptData.now) {
	            that.aynamicPptData.old[key] = that.aynamicPptData.now[key];
	        }
	        that.aynamicPptData.now.fileid = that.fileid;
	        that.aynamicPptData.now.slide = data.slide;
	        that.aynamicPptData.now.step = data.step;
	    },
	    playerControlClass: {
	        HandleSlideChange: function HandleSlideChange(n) {
	            //Handle slide change here
	            var that = NewPptAynamicPPTGLOBAL.newPptAynamicPPT.that;
	            $("#curr_ppt_page").html(n + 1);
	            $("#all_ppt_page").html(that.remoteData.slidesCount);
	            var data = {
	                pptslide: n + 1,
	                currpage: n + 1,
	                fileid: that.fileid,
	                pagenum: that.remoteData.slidesCount
	            };
	            $(document).trigger("slideChangeToLcData", [data]);
	        }
	    },
	    changeFileElementProperty: function changeFileElementProperty() {
	        var that = NewPptAynamicPPTGLOBAL.newPptAynamicPPT.that;
	        var ts = that.remoteData;
	        if (ts.step === undefined && ts.stepTotal === undefined && ts.slide === undefined) {
	            return;
	        }
	        var stepTotal = ts.stepTotal;
	        var slide = ts.slide + 1;
	        var step = ts.step;
	        if (slide <= 1 && step <= 0) {
	            $("#ppt_prev_page_slide[data-set-disabled=yes] ,#prev_page_phone_slide[data-set-disabled=yes]").removeClass("disabled").addClass("disabled").attr("disabled", "disabled");
	        } else {
	            $("#ppt_prev_page_slide[data-set-disabled=yes] ,#prev_page_phone_slide[data-set-disabled=yes]").removeClass("disabled").removeAttr("disabled");
	        }
	        if (slide >= that.remoteData.slidesCount && step >= stepTotal - 1) {
	            $("#ppt_next_page_slide[data-set-disabled=yes] ,#next_page_phone_slide[data-set-disabled=yes]").removeClass("disabled").addClass("disabled").attr("disabled", "disabled");
	        } else {
	            $("#ppt_next_page_slide[data-set-disabled=yes] ,#next_page_phone_slide[data-set-disabled=yes]").removeClass("disabled").removeAttr("disabled");
	        };
	        /*        $("#big_literally_vessel")
	                    .attr("data-ppt-step" ,ts.step )
	                    .attr('data-ppt-step-total' , ts.stepTotal);*/
	        $(document).trigger("newppt_changeFileElementProperty", { pptstep: ts.step, steptotal: ts.stepTotal });
	    },
	    setSendMessagePermission: function setSendMessagePermission(value) {
	        var that = NewPptAynamicPPTGLOBAL.newPptAynamicPPT.that;
	        that.sendMessagePermission = value;
	    },
	    setRPathAndPres: function setRPathAndPres(options) {
	        var that = NewPptAynamicPPTGLOBAL.newPptAynamicPPT.that;
	        options = options || {};
	        that.rPathAddress = options.rPathAddress;
	        that.PresAddress = options.PresAddress;
	        that.fileid = options.fileid || null;
	        that.currScale = 1;
	        var slideIndex = options.slideIndex || 1;
	        var stepIndex = options.stepIndex || 0;
	        that.remoteSlide = slideIndex;
	        that.remoteStep = stepIndex;
	        that.needUpdateSlideAndStep = true;
	        that.isInitFinsh = false;
	        that.setNewPptFrameSrc(that.rPathAddress + that.PresAddress);
	        that.loading.loadingStart();
	    },
	    setNewPptFrameSrc: function setNewPptFrameSrc(src) {
	        var that = this;
	        console.log('set newppt src:', src);
	        if (src) {
	            $("#newppt_frame").attr("src", src);
	        } else {
	            $("#newppt_frame").removeAttr("src");
	        }
	    },
	    clearAll: function clearAll() {
	        var that = this;
	        that.isResized = false;
	        that.isOpenPptFile = false;
	        that.firstLoaded = false;
	        that.sendMessagePermission = this.options.sendMessagePermission || true; //发送数据的权限
	        that.recvRemoteDataing = this.options.recvRemoteDataing || false; //接收远端数据，则不需要发送信令
	        that.contentHolder = null;
	        that.contentHolderParent = null;
	        that.pptVesselElemnt = null;
	        that.pptZoomElemnt = null;
	        that.lcToolContainer = null;
	        that.presSettings = {};
	        that.aynamicPptData = {
	            old: {
	                slide: null,
	                step: null,
	                fileid: null
	            },
	            now: {
	                slide: null,
	                step: null,
	                fileid: null
	            }
	        };
	        that.recvCount = 0;
	        that.setNewPptFrameSrc("");
	        that.newpptFrame = null;
	    },
	    recvInitEventHandler: function recvInitEventHandler(slideIndex, stepIndex) {
	        var that = this;
	        that.isInitFinsh = true;
	        that.changeAynamicPptData();
	        that.playerControlClass.HandleSlideChange(slideIndex);
	        that.onInitaliseSettingsHandler();
	        that.changeFileElementProperty();
	        if (that.needUpdateSlideAndStep) {
	            if (that.remoteSlide != null && that.remoteStep != null) {
	                that.jumpToAnim(that.remoteSlide, that.remoteStep);
	                that.remoteSlide = null;
	                that.remoteStep = null;
	            }
	            that.needUpdateSlideAndStep = false;
	        };
	        if (that.remoteActionData) {
	            that.postMessage(that.remoteActionData);
	            that.remoteActionData = null;
	        }
	        var data = {
	            Width: that.remoteData.view.width,
	            Height: that.remoteData.view.height
	        };
	        $(document).trigger("updateLcScaleWhenAynicPPTInit", [data]); //更新动态ppt的白板尺寸
	        that.loading.loadingEnd();
	    },
	    recvSlideChangeEventHandler: function recvSlideChangeEventHandler(slideIndex, externalData) {
	        var that = this;
	        that.changeAynamicPptData();
	        that.playerControlClass.HandleSlideChange(slideIndex);
	        that.changeFileElementProperty();
	        if (!that.isLoadInitSlideAndStep) {
	            that.isLoadInitSlideAndStep = true;
	            if (that.remoteData.slide === 0 && that.remoteData.step === 0) {
	                return;
	            }
	        }
	        that.sendMessageToRemote({ action: "slide" }, externalData);
	    },
	    recvStepChangeEventHandler: function recvStepChangeEventHandler(stepIndex, externalData) {
	        var that = this;
	        that.changeAynamicPptData();
	        that.changeFileElementProperty();
	        if (!that.isLoadInitSlideAndStep) {
	            that.isLoadInitSlideAndStep = true;
	            if (that.remoteData.slide === 0 && that.remoteData.step === 0) {
	                return;
	            }
	        }
	        that.sendMessageToRemote({ action: "step" }, externalData);
	    },
	    newDopPresentation: function newDopPresentation(options, loadUrl) {
	        //初始化PPT对象
	        var that = NewPptAynamicPPTGLOBAL.newPptAynamicPPT.that;
	        that.options = options || that.options;
	        that.resetParameter(that.options);
	        that.playbackController = null;
	        that.remoteData.slidesCount = null;
	        that.isPlayedPresentation = null;
	        that.remoteData.view = null;
	        that.presentation = null;
	        that.isLoadInitSlideAndStep = false;
	        if (!that.isResized) {
	            that.resizeUpdatePPT(that);
	            that.isResized = true;
	        }
	        if (!that.firstLoaded) {
	            that.firstLoaded = true;
	            $('#ppt_prev_page , #ppt_next_page , #btnPause , #btnPlay , #ppt_next_page_slide ,#ppt_prev_page_slide , #btnGoto , #resizer , #aynamic_ppt_click  , #tool_zoom_big_ppt , #tool_zoom_small_ppt , #prev_page_phone_slide , #next_page_phone_slide').off("click mousedown");
	            $('#ppt_prev_page_slide,#prev_page_phone_slide').click(function () {
	                var plugs = $(this).attr("data-plugs");
	                if (plugs == "newppt") {
	                    that.recvCount = 0;
	                    that.gotoPreviousStep();
	                    return false;
	                }
	            });
	
	            $('#ppt_next_page_slide,#next_page_phone_slide').click(function () {
	                var plugs = $(this).attr("data-plugs");
	                if (plugs == "newppt") {
	                    that.recvCount = 0;
	                    that.gotoNextStep();
	                    return false;
	                }
	            });
	
	            $("#tool_zoom_big_ppt").off("click");
	            $("#tool_zoom_big_ppt").click(function () {
	                var plugs = $(this).attr("data-plugs");
	                if (plugs == "newppt") {
	                    that.currScale += 0.5;
	                    if (that.currScale >= 3) {
	                        that.currScale = 3;
	                    }
	                    that.checkZoomStatus();
	                    that.autoChangePptSize(that);
	                }
	            });
	            $("#tool_zoom_small_ppt").off("click");
	            $("#tool_zoom_small_ppt").click(function () {
	                var plugs = $(this).attr("data-plugs");
	                if (plugs == "newppt") {
	                    that.currScale -= 0.5;
	                    if (that.currScale <= 1) {
	                        that.currScale = 1;
	                    }
	                    that.checkZoomStatus();
	                    that.autoChangePptSize(that);
	                }
	            });
	            that.checkZoomStatus();
	            var eventData = {
	                eventSelector: '#ppt_prev_page , #ppt_next_page , #btnPause , #btnPlay , #ppt_next_page_slide ,#ppt_prev_page_slide , #btnGoto , #resizer , #aynamic_ppt_click , #prev_page_phone_slide , #next_page_phone_slide ',
	                eventName: 'click mousedown',
	                rolePermissionNotExecute: 'chairman',
	                needClassBegin: true
	            };
	            $(document).trigger("cancelEvent", [eventData]);
	        }
	        return that;
	    },
	    checkZoomStatus: function checkZoomStatus() {
	        var that = this;
	        if (that.currScale >= 3) {
	            $("#tool_zoom_big_ppt").addClass("disabled").attr("disabled", "disabled");
	        } else {
	            $("#tool_zoom_big_ppt").removeClass("disabled").removeAttr("disabled");
	        }
	        if (that.currScale <= 1) {
	            $("#tool_zoom_small_ppt").addClass("disabled").attr("disabled", "disabled");
	        } else {
	            $("#tool_zoom_small_ppt").removeClass("disabled").removeAttr("disabled");
	        }
	        $(document).trigger("updateLcScale", [that.currScale]);
	    },
	    resetParameter: function resetParameter(options) {
	        //重置参数
	        this.playbackController = null;
	        this.slidesCount = null;
	        this.isPlayedPresentation = null;
	        this.view = null;
	        this.presentation = null;
	        this.options = options || this.options || {};
	        this.rPathAddress = options.rPathAddress;
	        this.PresAddress = options.PresAddress;
	        this.fileid = options.fileid || null;
	        this.remoteSlide = options.remoteSlide || null;
	        this.remoteStep = options.remoteStep || null;
	        this.needUpdateSlideAndStep = false;
	        this.currScale = 1;
	        this.recvCount = 0;
	        this.isOpenPptFile = false;
	        this.aynamicPptData = {
	            old: {
	                slide: null,
	                step: null,
	                fileid: null
	            },
	            now: {
	                slide: null,
	                step: null,
	                fileid: null
	            }
	        };
	        this.formatedTotalTime = null;
	        this.presSettings = {};
	        this.isTouchDevice = null;
	        this.ipadKeyPadFlg = null;
	        this.isPlaying = false;
	        this.remoteData = {};
	    },
	    postMessage: function postMessage(data) {
	        var that = this;
	        that.newpptFrame = that.newpptFrame || document.getElementById("newppt_frame");
	        if (that.newpptFrame.getAttribute("src")) {
	            var source = "tk_dynamicPPT";
	            var sendData = {
	                source: source,
	                data: data
	            };
	            sendData = JSON.stringify(sendData);
	            if (that.newpptFrame && that.newpptFrame.contentWindow) {
	                //that.newpptFrame.contentWindow.postMessage(data , that.newpptFrame.getAttribute("src") );
	                that.newpptFrame.contentWindow.postMessage(sendData, "*");
	            } else {
	                console.error("postMessage error【that.newpptFrame ，that.newpptFrame.contentWindow 】:", that.newpptFrame, that.newpptFrame.contentWindow);
	            }
	        }
	    },
	    jumpToAnim: function jumpToAnim(slide, step, initiative, timeOffset, autoStart) {
	        var that = NewPptAynamicPPTGLOBAL.newPptAynamicPPT.that;
	        //that.needUpdateSlideAndStep = false ;
	        that.jumpToAnimTimer = that.jumpToAnimTimer || null;
	        if (that.isInitFinsh) {
	            // clearTimeout(that.jumpToAnimTimer);
	            // that.jumpToAnimTimer = setTimeout(function () {
	            var data = {
	                action: "jumpToAnim",
	                data: {
	                    slide: slide,
	                    step: step,
	                    timeOffset: timeOffset,
	                    autoStart: autoStart,
	                    initiative: initiative
	                }
	            };
	            that.postMessage(data);
	            // },200);
	        }
	    },
	    onInitaliseSettingsHandler: function onInitaliseSettingsHandler() {
	        //InitaliseSettings后的处理函数
	        var that = NewPptAynamicPPTGLOBAL.newPptAynamicPPT.that;
	        $(document).trigger("updateSlidesCountToLcElement", { pagenum: that.remoteData.slidesCount });
	        /*        $("#big_literally_vessel")
	                    .attr("data-total-page" ,that.remoteData.slidesCount );*/
	    },
	    gotoPreviousStep: function gotoPreviousStep() {
	        var that = this;
	        if (that.isInitFinsh) {
	            //clearTimeout(that.actionTimer);
	            //that.actionTimer = setTimeout(function () {
	            var data = {
	                action: "gotoPreviousStep"
	            };
	            that.postMessage(data);
	            //},100);
	        }
	    },
	    gotoNextStep: function gotoNextStep() {
	        var that = this;
	        if (that.isInitFinsh) {
	            //clearTimeout(that.actionTimer);
	            //that.actionTimer = setTimeout(function () {
	            that.recvCount = 0;
	            var data = {
	                action: "gotoNextStep"
	            };
	            that.postMessage(data);
	            //},100);
	        }
	    },
	    gotoNextSlide: function gotoNextSlide(autoStart) {
	        var that = this;
	        if (that.isInitFinsh) {
	            var ts = that.remoteData;
	            if (!(ts.slide != undefined && ts.step != undefined)) {
	                return;
	            }
	            var data = {
	                slide: ts.slide + 1,
	                step: ts.step
	            };
	            if (that.remoteData.slidesCount && data.slide < that.remoteData.slidesCount) {
	                that.recvCount = 0;
	                var sendData = {
	                    action: "gotoNextSlide",
	                    autoStart: autoStart
	                };
	                that.postMessage(sendData);
	            }
	        }
	    },
	    gotoPreviousSlide: function gotoPreviousSlide(autoStart) {
	        var that = this;
	        if (that.isInitFinsh) {
	            var ts = that.remoteData;
	            if (!(ts.slide != undefined && ts.step != undefined)) {
	                return;
	            }
	            var data = {
	                slide: ts.slide + 1,
	                step: ts.step
	            };
	            if (that.remoteData.slidesCount && data.slide > 1) {
	                that.recvCount = 0;
	                var sendData = {
	                    action: "gotoPreviousSlide",
	                    autoStart: autoStart
	                };
	                that.postMessage(sendData);
	            }
	        }
	    },
	    isInitiative: function isInitiative(externalData) {
	        return externalData && externalData.initiative;
	    },
	    loading: { //加载ppt
	        loadingStart: function loadingStart() {
	            $("#preloader_newppt").css("display", 'block');
	        },
	        loadingEnd: function loadingEnd() {
	            $("#preloader_newppt").css("display", 'none');
	        }
	    }
	};
	exports["default"] = NewPptAynamicPPT;
	module.exports = exports["default"];
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(41)))

/***/ }),

/***/ 260:
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {/**
	 * 白板组件
	 * @module WhiteboardSmart
	 * @description   提供 白板的组件
	 * @author QiuShao
	 * @date 2017/7/27
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i['return']) _i['return'](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError('Invalid attempt to destructure non-iterable instance'); } }; })();
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x5, _x6, _x7) { var _again = true; _function: while (_again) { var object = _x5, property = _x6, receiver = _x7; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x5 = parent; _x6 = property; _x7 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _plugsLiterallyJsHandlerWhiteboardAndCore = __webpack_require__(119);
	
	var _plugsLiterallyJsHandlerWhiteboardAndCore2 = _interopRequireDefault(_plugsLiterallyJsHandlerWhiteboardAndCore);
	
	var WhiteboardSmart = (function (_React$Component) {
	    _inherits(WhiteboardSmart, _React$Component);
	
	    function WhiteboardSmart(props) {
	        _classCallCheck(this, WhiteboardSmart);
	
	        _get(Object.getPrototypeOf(WhiteboardSmart.prototype), 'constructor', this).call(this, props);
	        this.state = {
	            show: true,
	            selectMouse: true };
	        //选中的标注工具默认是鼠标
	        this.containerWidthAndHeight = { width: 0, height: 0 };
	        this.instanceId = this.props.instanceId !== undefined ? this.props.instanceId : 'default';
	        this.whiteboardElementId = 'whiteboard_container_' + this.instanceId;
	        this.fileid = undefined; //切换文件或者打开文件之前的文件id
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	        this.cacheMaxPageNum = 1; //当前打开文档的缓存的最大页数，缺省为1
	        this.cacheMinPageNum = 1; //当前打开文档的缓存的最小页数，缺省为1
	        this.filePreLoadCurrPage = 1; //当前打开文档的缓存的当前页，缺省为1
	        this.filePreLoadStep = 2; //普通文档预加载步长，缺省为2
	    }
	
	    _createClass(WhiteboardSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            _eventObjectDefine2['default'].Window.addEventListener(_TkConstant2['default'].EVENTTYPE.WindowEvent.onResize, that.handlerOnResize.bind(that), that.listernerBackupid); //window.resize事件：白板处理
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //room-pubmsg事件：白板处理
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //room-delmsg事件：白板处理
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDisconnected, that.handlerRoomDisconnected.bind(that), that.listernerBackupid); //roomDisconnected事件：白板处理
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPlaybackClearAllFromPlaybackController, that.handlerRoomPlaybackClearAll.bind(that), that.listernerBackupid); //roomPlaybackClearAll 事件：回放清除所有信令
	            // eventObjectDefine.CoreController.addEventListener("save-lc-waiting-process-data" ,that.handlerSavelcWaitingProcessData.bind(that) , that.listernerBackupid); //保存白板待处理数据事件
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-ShowPage-lastDocument", that.handlerReceiveMsglistShowPageLastDocument.bind(that), that.listernerBackupid); //接收ShowPage信令：白板处理
	            _eventObjectDefine2['default'].CoreController.addEventListener("saveLcStackToStorage", that.handlerSaveLcStackToStorage.bind(that), that.listernerBackupid); //接收saveLcStackToStorage事件执行saveLcStackToStorage
	            _eventObjectDefine2['default'].CoreController.addEventListener("resizeHandler", that.handlerResizeHandler.bind(that), that.listernerBackupid); //接收resizeHandler事件执行resizeHandler
	            _eventObjectDefine2['default'].CoreController.addEventListener("setFileDataToLcElement", that.handlerSetFileDataToLcElement.bind(that), that.listernerBackupid); //接收setFileDataToLcElement事件执行setFileDataToLcElement
	            _eventObjectDefine2['default'].CoreController.addEventListener("getFileDataFromLcElement", that.handlerGetFileDataFromLcElement.bind(that), that.listernerBackupid); //接收getFileDataFromLcElement事件执行getFileDataFromLcElement
	            _eventObjectDefine2['default'].CoreController.addEventListener("resetLcDefault", that.handlerResetLcDefault.bind(that), that.listernerBackupid); //接收resetLcDefault事件执行resetLcDefault
	            _eventObjectDefine2['default'].CoreController.addEventListener("closeLoading", that.handlerCloseLoading.bind(that), that.listernerBackupid); //接收closeLoading事件执行closeLoading
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateLcScaleWhenAynicPPTInitHandler", that.handlerUpdateLcScaleWhenAynicPPTInitHandler.bind(that), that.listernerBackupid); //接收updateLcScaleWhenAynicPPTInitHandler事件：根据动态PPT传过来的白板比例进行白板缩放
	            _eventObjectDefine2['default'].CoreController.addEventListener("recoverCurrpageLcData", that.handlerRecoverCurrpageLcData.bind(that), that.listernerBackupid); //接收recoverCurrpageLcData事件执行recoverCurrpageLcData
	            _eventObjectDefine2['default'].CoreController.addEventListener("whiteboardPrevPage", that.handlerWhiteboardPrevPage.bind(that), that.listernerBackupid); //接收whiteboardPrevPage事件上一页操作
	            _eventObjectDefine2['default'].CoreController.addEventListener("whiteboardNextPage", that.handlerWhiteboardNextPage.bind(that), that.listernerBackupid); //接收whiteboardNextPage事件下一页操作
	            _eventObjectDefine2['default'].CoreController.addEventListener("whiteboardAddPage", that.handlerWhiteboardAddPage.bind(that), that.listernerBackupid); //接收whiteboardAddPage事件加页操作
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_whiteboardPagingPage", that.handlerUpdateAppPermissions_whiteboardPagingPage.bind(that), that.listernerBackupid); //updateAppPermissions_whiteboardPagingPage:更新白板翻页权限
	            _eventObjectDefine2['default'].CoreController.addEventListener("initAppPermissions", that.handlerInitAppPermissions.bind(that), that.listernerBackupid); //initAppPermissions：初始化权限处理
	            _eventObjectDefine2['default'].CoreController.addEventListener("openDocuemntOrMediaFile", that.handlerOpenDocuemntOrMediaFile.bind(that), that.listernerBackupid); //openDocuemntOrMediaFile：打开文档或者媒体文件
	            _eventObjectDefine2['default'].CoreController.addEventListener("whiteboard_updateWhiteboardToolsInfo", that.handlerWhiteboard_updateWhiteboardToolsInfo.bind(that), that.listernerBackupid); //whiteboard_updateWhiteboardToolsInfo：更新白板toolStatus
	            _eventObjectDefine2['default'].CoreController.addEventListener("whiteboard_updateTextFont", that.handlerWhiteboard_updateTextFont.bind(that), that.listernerBackupid); //whiteboard_updateTextFont：执行白板uploadTextFont方法
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateSelectMouse", that.handlerUpdateSelectMouse.bind(that), that.listernerBackupid); //updateSelectMouse：选择的标注工具是否是鼠标
	            _eventObjectDefine2['default'].CoreController.addEventListener("checkSelectMouseState", that.handlerCheckSelectMouseState.bind(that), that.listernerBackupid); //checkSelectMouseState：检测选中的标注工具是否是鼠标
	            _eventObjectDefine2['default'].CoreController.addEventListener("changeStrokeSize", that.handlerChangeStrokeSize.bind(that), that.listernerBackupid); //changeStrokeSize：改变白板画笔等大小
	            _eventObjectDefine2['default'].CoreController.addEventListener("changeStrokeColor", that.handlerChangeStrokeColor.bind(that), that.listernerBackupid); //changeStrokeColor：改变白板的画笔颜色
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_canDraw", that.handlerUpdateAppPermissions_canDraw.bind(that), that.listernerBackupid); //updateAppPermissions_canDraw：白板可画权限更新
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_h5DocumentActionClick", that.handlerUpdateAppPermissions_h5DocumentActionClick.bind(that), that.listernerBackupid); //updateAppPermissions_h5DocumentActionClick：H5文档可点击权限更新
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_dynamicPptActionClick", that.handlerUpdateAppPermissions_dynamicPptActionClick.bind(that), that.listernerBackupid); //updateAppPermissions_dynamicPptActionClick：动态PPT可点击权限更新
	            _eventObjectDefine2['default'].CoreController.addEventListener("lcTextEditing", that.handlerLcTextEditing.bind(that), that.listernerBackupid); //lcTextEditing：白板是否处于text的editing
	            _eventObjectDefine2['default'].CoreController.addEventListener("skipPage_general", that.handlerSkipPage_general.bind(that), that.listernerBackupid); //skipPage_general：普通文档跳转
	            _eventObjectDefine2['default'].CoreController.addEventListener("preloadWhiteboardImg", that.handlerPreloadWhiteboardImg.bind(that), that.listernerBackupid); //preloadWhiteboardImg：预加载白板图片
	            _eventObjectDefine2['default'].CoreController.addEventListener('receive-msglist-whiteboardMarkTool', that.handlerReceive_msglist_whiteboardMarkTool.bind(that), that.listernerBackupid); //receive-msglist-whiteboardMarkTool
	            _eventObjectDefine2['default'].CoreController.addEventListener('whiteboard_activeCommonWhiteboardTool', that.handlerWhiteboard_activeCommonWhiteboardTool.bind(that), that.listernerBackupid); //whiteboard_activeCommonWhiteboardTool
	            that._lcInit();
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].Window.removeBackupListerner(that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].destroyWhiteboardInstance(that.instanceId);
	        }
	    }, {
	        key: 'componentDidUpdate',
	        value: function componentDidUpdate(prevProps, prevState) {
	            //在组件完成更新后立即调用,在初始化时不会被调用
	            if (prevState.selectMouse !== this.state.selectMouse) {
	                this.handlerCheckSelectMouseState();
	            }
	            if (prevState.show !== this.state.show && this.state.show) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].checkWhiteboardCanvasSize(this.instanceId, { isResize: true });
	            }
	        }
	    }, {
	        key: 'handlerOnResize',
	        value: function handlerOnResize() {
	            //window.resize事件：白板处理
	            var that = this;
	            if (that.props.fatherContainerId) {
	                var $fatherContainer = $("#" + that.props.fatherContainerId);
	                if ($fatherContainer && $fatherContainer.length > 0) {
	                    var containerWidthAndHeight = {
	                        width: $fatherContainer.width(),
	                        height: $fatherContainer.height()
	                    };
	                    that.containerWidthAndHeight = containerWidthAndHeight;
	                    _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateContainerWidthAndHeight(that.instanceId, containerWidthAndHeight);
	                }
	            }
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].resizeWhiteboardHandler(that.instanceId);
	        }
	    }, {
	        key: 'handlerRoomPubmsg',
	        value: function handlerRoomPubmsg(pubmsgDataEvent) {
	            //room-pubmsg事件：白板处理
	            var that = this;
	            var pubmsgData = pubmsgDataEvent.message;
	            switch (pubmsgData.name) {
	                /*case "SharpsChange":
	                    HandlerWhiteboardAndCoreInstance.handlerPubmsg_SharpsChange(pubmsgData , that.instanceId);
	                    break;*/
	                case "ShowPage":
	                    var open = that._saveFileidReturnOpen(pubmsgData.data);
	                    var tmpData = { message: { data: pubmsgData.data, open: open, source: 'room-pubmsg' } };
	                    that._handlerReceiveShowPageSignalling(tmpData);
	                    break;
	                case "whiteboardMarkTool":
	                    var selectMouse = pubmsgData.data.selectMouse;
	
	                    that.handlerUpdateSelectMouse({ type: 'updateSelectMouse', message: { selectMouse: selectMouse } });
	                    break;
	                default:
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerReceive_msglist_whiteboardMarkTool',
	        value: function handlerReceive_msglist_whiteboardMarkTool(recvEventData) {
	            var that = this;
	            var pubmsgData = recvEventData.message;
	            var selectMouse = pubmsgData.data.selectMouse;
	
	            that.handlerUpdateSelectMouse({ type: 'updateSelectMouse', message: { selectMouse: selectMouse } });
	        }
	    }, {
	        key: 'handlerRoomDelmsg',
	        value: function handlerRoomDelmsg(delmsgDataEvent) {
	            //room-delmsg事件：白板处理
	            var that = this;
	            var delmsgData = delmsgDataEvent.message;
	            switch (delmsgData.name) {
	                /*case "SharpsChange": //删除白板数据
	                    HandlerWhiteboardAndCoreInstance.handlerDelmsg_SharpsChange(delmsgData  );
	                    break;*/
	                case "ClassBegin":
	                    if (_CoreController2['default'].handler.getAppPermissions('endClassbeginRevertToStartupLayout')) {
	                        //是否拥有下课重置界面权限
	                        _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].clearWhiteboardAllDataById(that.instanceId);
	                    }
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerRoomPlaybackClearAll',
	        value: function handlerRoomPlaybackClearAll() {
	            if (!_TkGlobal2['default'].playback) {
	                L.Logger.error('No playback environment, no execution event[roomPlaybackClearAll] handler ');return;
	            };
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].clearWhiteboardAllDataById(that.instanceId);
	        }
	    }, {
	        key: 'handlerRoomDisconnected',
	        value: function handlerRoomDisconnected(recvEventData) {
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].clearWhiteboardAllDataById(that.instanceId);
	        }
	    }, {
	        key: 'handlerReceiveMsglistShowPageLastDocument',
	
	        /* handlerSavelcWaitingProcessData(waitingProcessEventData){//保存白板待处理数据事件处理函数
	            const that = this ;
	            let {sharpsChangeArray} = waitingProcessEventData.message;
	            HandlerWhiteboardAndCoreInstance.handlerMsglist_SharpsChange(sharpsChangeArray);
	        };*/
	        value: function handlerReceiveMsglistShowPageLastDocument(showpageData) {
	            var that = this;
	            var open = that._saveFileidReturnOpen(showpageData.message.data);
	            showpageData.message.open = open;
	            that._handlerReceiveShowPageSignalling(showpageData);
	        }
	    }, {
	        key: 'handlerSaveLcStackToStorage',
	        value: function handlerSaveLcStackToStorage(recvEventData) {
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].saveWhiteboardStackToStorage(that.instanceId, {
	                saveRedoStack: _TkConstant2['default'].hasRole.roleChairman
	            });
	        }
	    }, {
	        key: 'handlerResizeHandler',
	        value: function handlerResizeHandler(recvEventData) {
	            var that = this;
	            if (recvEventData && recvEventData.message && recvEventData.message.eleWHPercent != undefined) {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardMagnification(that.instanceId, recvEventData.message.eleWHPercent);
	            }
	            that.handlerOnResize();
	        }
	    }, {
	        key: 'handlerSetFileDataToLcElement',
	        value: function handlerSetFileDataToLcElement(recvEventData) {
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardFiledata(that.instanceId, recvEventData.message.filedata);
	        }
	    }, {
	        key: 'handlerGetFileDataFromLcElement',
	        value: function handlerGetFileDataFromLcElement(recvEventData) {
	            var that = this;
	            var callback = recvEventData.message.callback;
	
	            if (callback && typeof callback === 'function') {
	                var fileInfo = _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardFiledata(that.instanceId);
	                callback(fileInfo);
	            }
	        }
	    }, {
	        key: 'handlerResetLcDefault',
	        value: function handlerResetLcDefault(recvEventData) {
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].resetDedaultWhiteboardMagnification(that.instanceId);
	        }
	    }, {
	        key: 'handlerCloseLoading',
	        value: function handlerCloseLoading(recvEventData) {
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].hideWhiteboardLoading(that.instanceId);
	        }
	    }, {
	        key: 'handlerUpdateLcScaleWhenAynicPPTInitHandler',
	        value: function handlerUpdateLcScaleWhenAynicPPTInitHandler(recvEventData) {
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardWatermarkImageScalc(that.instanceId, recvEventData.message.lcLitellyScalc);
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].setWhiteboardWatermarkImage(that.instanceId, "");
	        }
	    }, {
	        key: 'handlerRecoverCurrpageLcData',
	        value: function handlerRecoverCurrpageLcData(recvEventData) {
	            var that = this;
	            that._recoverCurrpageLcData();
	        }
	    }, {
	        key: 'handlerWhiteboardPrevPage',
	        value: function handlerWhiteboardPrevPage() {
	            var that = this;
	            that._whiteboardPaging(false, true);
	        }
	    }, {
	        key: 'handlerWhiteboardNextPage',
	        value: function handlerWhiteboardNextPage() {
	            var that = this;
	            that._whiteboardPaging(true, true);
	        }
	    }, {
	        key: 'handlerWhiteboardAddPage',
	        value: function handlerWhiteboardAddPage() {
	            var that = this;
	            that.handlerSaveLcStackToStorage();
	            var lcData = _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardFiledata(that.instanceId);
	            lcData.pagenum += 1;
	            var addPageData = {
	                totalPage: lcData.pagenum,
	                fileid: lcData.fileid
	            };
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardFiledata(that.instanceId, lcData);
	            _ServiceSignalling2['default'].sendSignallingFromWBPageCount(addPageData);
	            that._whiteboardPaging(true, true);
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_whiteboardPagingPage',
	        value: function handlerUpdateAppPermissions_whiteboardPagingPage() {
	            var that = this;
	            if (that.props.fileTypeMark === 'general') {
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updatePagdingState', message: { source: 'whiteboard', data: _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardFiledata(that.instanceId) } });
	            }
	        }
	    }, {
	        key: 'handlerInitAppPermissions',
	        value: function handlerInitAppPermissions() {
	            var that = this;
	            that.handlerUpdateAppPermissions_canDraw();
	            that.handlerUpdateAppPermissions_whiteboardPagingPage();
	            that.handlerCheckSelectMouseState();
	        }
	    }, {
	        key: 'handlerOpenDocuemntOrMediaFile',
	        value: function handlerOpenDocuemntOrMediaFile(recvEventData) {
	            var that = this;
	            var fileDataInfo = recvEventData.message;
	            var open = that._saveFileidReturnOpen(fileDataInfo);
	            if (fileDataInfo.isGeneralFile) {
	                //如果是普通文档
	                that._handlerReceiveShowPageSignalling({ message: { data: fileDataInfo, open: open, source: 'commonFileClickEvent' } });
	                /*fileDataInfo格式:
	                     const fileDataInfo = {
	                         isGeneralFile:file.isGeneralFile,
	                         isMedia:file.isMediaFile,
	                         isDynamicPPT:file.isDynamicPPT,
	                         action: file.isDynamicPPT?"show":"",
	                         mediaType:file.isMediaFile?file.filetype:null,
	                         filedata: {
	                             fileid: file.fileid,
	                             currpage: file.currentPage,
	                             pagenum: file.pagenum,
	                             filetype: file.filetype,
	                             filename: file.filename,
	                             swfpath: file.swfpath,
	                             pptslide: file.pptslide,
	                             pptstep: file.pptstep,
	                             steptotal:file.steptotal
	                         }
	                     }
	                 * */
	            }
	        }
	    }, {
	        key: 'handlerWhiteboard_updateWhiteboardToolsInfo',
	        value: function handlerWhiteboard_updateWhiteboardToolsInfo(recvEventData) {
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardToolsInfo(this.instanceId, recvEventData.message.whiteboardToolsInfo);
	        }
	    }, {
	        key: 'handlerWhiteboard_updateTextFont',
	        value: function handlerWhiteboard_updateTextFont(recvEventData) {
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateTextFont(that.instanceId);
	        }
	    }, {
	        key: 'handlerUpdateSelectMouse',
	        value: function handlerUpdateSelectMouse(recvEventData) {
	            var selectMouse = recvEventData.message.selectMouse;
	            if (this.state.selectMouse !== selectMouse) {
	                var fileTypeMark = this.props.fileTypeMark;
	
	                var hideLc = false;
	                switch (fileTypeMark) {
	                    case 'dynamicPPT':
	                        hideLc = selectMouse; //是动态PPT并且拥有动态PPT点击权限并且选中的是鼠标，则隐藏
	                        // hideLc = CoreController.handler.getAppPermissions('dynamicPptActionClick') &&  selectMouse ;//是动态PPT并且拥有动态PPT点击权限并且选中的是鼠标，则隐藏
	                        break;
	                    case 'h5document':
	                        hideLc = selectMouse; //是H5文档并且拥有H5文档点击权限并且选中的是鼠标，则隐藏
	                        // hideLc = CoreController.handler.getAppPermissions('h5DocumentActionClick') &&  selectMouse ;//是H5文档并且拥有H5文档点击权限并且选中的是鼠标，则隐藏
	                        break;
	                    default:
	                        hideLc = false;
	                        break;
	                }
	                this.setState({ selectMouse: selectMouse, show: !hideLc });
	            }
	        }
	    }, {
	        key: 'handlerCheckSelectMouseState',
	        value: function handlerCheckSelectMouseState(recvEventData) {
	            var fileTypeMark = undefined;
	            if (recvEventData && recvEventData.message && recvEventData.message.fileTypeMark) {
	                fileTypeMark = recvEventData.message.fileTypeMark;
	            }
	            var _state = this.state;
	            var selectMouse = _state.selectMouse;
	            var show = _state.show;
	
	            fileTypeMark = fileTypeMark || this.props.fileTypeMark;
	            var hideLc = false;
	            switch (fileTypeMark) {
	                case 'dynamicPPT':
	                    hideLc = selectMouse; //是动态PPT并且拥有动态PPT点击权限并且选中的是鼠标，则隐藏
	                    // hideLc = CoreController.handler.getAppPermissions('dynamicPptActionClick') &&  selectMouse ;//是动态PPT并且拥有动态PPT点击权限并且选中的是鼠标，则隐藏
	                    break;
	                case 'h5document':
	                    hideLc = selectMouse; //是H5文档并且拥有H5文档点击权限并且选中的是鼠标，则隐藏
	                    // hideLc = CoreController.handler.getAppPermissions('h5DocumentActionClick') &&  selectMouse ;//是H5文档并且拥有H5文档点击权限并且选中的是鼠标，则隐藏
	                    break;
	                default:
	                    hideLc = false;
	                    break;
	            }
	            if (show !== !hideLc) {
	                this.setState({ show: !hideLc });
	            }
	        }
	    }, {
	        key: 'handlerChangeStrokeSize',
	        value: function handlerChangeStrokeSize(recvEventData) {
	            var that = this;
	            var _recvEventData$message$strokeJson = recvEventData.message.strokeJson;
	            var pencil = _recvEventData$message$strokeJson.pencil;
	            var text = _recvEventData$message$strokeJson.text;
	            var eraser = _recvEventData$message$strokeJson.eraser;
	            var shape = _recvEventData$message$strokeJson.shape;
	
	            var whiteboardToolsInfo = { pencilWidth: pencil, fontSize: text, eraserWidth: eraser, shapeWidth: shape };
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardToolsInfo(that.instanceId, whiteboardToolsInfo);
	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;
	
	            try {
	                for (var _iterator = Object.entries(recvEventData.message.selectedTool)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var _step$value = _slicedToArray(_step.value, 2);
	
	                    var key = _step$value[0];
	                    var value = _step$value[1];
	
	                    if (!value) {
	                        continue;
	                    };
	                    switch (key) {
	                        case 'pencil':
	                            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updatePencilWidth(that.instanceId, { pencilWidth: pencil });
	                            break;
	                        case 'text':
	                            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateTextFont(that.instanceId, { fontSize: text });
	                            break;
	                        case 'eraser':
	                            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateEraserWidth(that.instanceId, { eraserWidth: eraser });
	                            break;
	                        case 'shape':
	                            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateShapeWidth(that.instanceId, { shapeWidth: shape });
	                            break;
	                    }
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator['return']) {
	                        _iterator['return']();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerChangeStrokeColor',
	        value: function handlerChangeStrokeColor(recvEventData) {
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateColor(that.instanceId, { primary: "#" + recvEventData.message.selectColor }); //设置画笔颜色
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_canDraw',
	        value: function handlerUpdateAppPermissions_canDraw() {
	            var that = this;
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].changeWhiteboardDeawPermission(_CoreController2['default'].handler.getAppPermissions('canDraw'), that.instanceId); //设置白板可画权限
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_h5DocumentActionClick',
	        value: function handlerUpdateAppPermissions_h5DocumentActionClick() {
	            this.handlerCheckSelectMouseState();
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_dynamicPptActionClick',
	        value: function handlerUpdateAppPermissions_dynamicPptActionClick() {
	            this.handlerCheckSelectMouseState();
	        }
	    }, {
	        key: 'handlerLcTextEditing',
	        value: function handlerLcTextEditing(recvEventData) {
	            var that = this;
	            var callback = recvEventData.message.callback;
	            if (callback && typeof callback === 'function') {
	                callback(_plugsLiterallyJsHandlerWhiteboardAndCore2['default'].isWhiteboardTextEditing(that.instanceId));
	            }
	        }
	    }, {
	        key: 'handlerSkipPage_general',
	        value: function handlerSkipPage_general(recvEventData) {
	            var that = this;
	            if (that.props.fileTypeMark === 'general') {
	                var currpage = recvEventData.message.currpage;
	
	                that._skipWhiteboardPaging(currpage);
	            }
	        }
	    }, {
	        key: 'handlerPreloadWhiteboardImg',
	        value: function handlerPreloadWhiteboardImg(recvEventData) {
	            var that = this;
	            var url = recvEventData.message.url;
	
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].preloadWhiteboardImg(url);
	        }
	    }, {
	        key: 'sendSignallingToServer',
	        value: function sendSignallingToServer(signallingName, id, toID, data, do_not_save, expiresabs, associatedMsgID, associatedUserID) {
	            var isDelMsg = false;
	            _ServiceSignalling2['default'].sendSignallingFromSharpsChange(isDelMsg, signallingName, id, toID, data, do_not_save, expiresabs, associatedMsgID, associatedUserID);
	        }
	    }, {
	        key: 'delSignallingToServer',
	        value: function delSignallingToServer(signallingName, id, toID, data) {
	            var isDelMsg = true;
	            _ServiceSignalling2['default'].sendSignallingFromSharpsChange(isDelMsg, signallingName, id, toID, data);
	        }
	    }, {
	        key: 'resizeWhiteboardSizeCallback',
	        value: function resizeWhiteboardSizeCallback(fatherContainerConfiguration) {
	            if (this.props.resizeWhiteboardSizeCallback && typeof this.props.resizeWhiteboardSizeCallback === 'function') {
	                this.props.resizeWhiteboardSizeCallback(fatherContainerConfiguration);
	            }
	        }
	    }, {
	        key: 'noticeUpdateToolDescCallback',
	        value: function noticeUpdateToolDescCallback(registerWhiteboardToolsList) {
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'commonWhiteboardTool_noticeUpdateToolDesc', message: { registerWhiteboardToolsList: registerWhiteboardToolsList } });
	        }
	    }, {
	        key: 'handlerWhiteboard_activeCommonWhiteboardTool',
	        value: function handlerWhiteboard_activeCommonWhiteboardTool(recvEventData) {
	            var toolKey = recvEventData.message.toolKey;
	
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].activeWhiteboardTool(toolKey, this.instanceId);
	        }
	    }, {
	        key: '_lcInit',
	        value: function _lcInit() {
	            //白板初始化
	            var that = this;
	            if (!_plugsLiterallyJsHandlerWhiteboardAndCore2['default'].hasWhiteboardById(that.instanceId)) {
	                var whiteboardInstanceData = {
	                    whiteboardElementId: that.whiteboardElementId,
	                    id: that.instanceId,
	                    handler: {
	                        sendSignallingToServer: that.sendSignallingToServer.bind(that),
	                        delSignallingToServer: that.delSignallingToServer.bind(that),
	                        resizeWhiteboardSizeCallback: that.resizeWhiteboardSizeCallback.bind(that),
	                        noticeUpdateToolDescCallback: that.noticeUpdateToolDescCallback.bind(that)
	                    },
	                    productionOptions: {}
	                };
	                var toolsDesc = {
	                    tool_pencil: {},
	                    tool_highlighter: {},
	                    tool_line: {},
	                    tool_arrow: {},
	                    tool_eraser: {},
	                    tool_text: {},
	                    tool_rectangle: {},
	                    tool_rectangle_empty: {},
	                    tool_ellipse: {},
	                    tool_ellipse_empty: {},
	                    tool_mouse: {},
	                    tool_laser: {},
	                    action_undo: {},
	                    action_redo: {},
	                    action_clear: {},
	                    zoom_big: {},
	                    zoom_small: {}
	                };
	                /*   if(TK.SDKTYPE === 'mobile'){
	                       whiteboardInstanceData.productionOptions.backgroundColor = "#d4d8dc";
	                       whiteboardInstanceData.productionOptions.secondaryColor = "#d4d8dc";
	                   }*/
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].productionWhiteboard(whiteboardInstanceData);
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].registerWhiteboardTools(that.instanceId, toolsDesc);
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].clearRedoAndUndoStack(that.instanceId);
	                if (!_plugsLiterallyJsHandlerWhiteboardAndCore2['default'].hasWhiteboardFiledata(that.instanceId)) {
	                    _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardFiledata(that.instanceId, _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardDefaultFiledata());
	                }
	                that.handlerOnResize();
	            }
	        }
	    }, {
	        key: '_handlerReceiveShowPageSignalling',
	        value: function _handlerReceiveShowPageSignalling(showpageData) {
	            var that = this;
	            var doucmentFileData = showpageData.message.data;
	            var open = showpageData.message.open;
	            if (!doucmentFileData.isMedia) {
	                if (doucmentFileData.isGeneralFile) {
	                    //普通文档
	                    if (!open && doucmentFileData.filedata.fileid === that.fileid && Number(doucmentFileData.filedata.currpage) === _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardFiledata(this.instanceId).currpage) {
	                        return;
	                    }
	                    that.handlerSaveLcStackToStorage();
	                    _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardFiledata(that.instanceId, doucmentFileData.filedata);
	                    var isSetPlayUrl = true;
	                    that._recviceCommonDocumentShowPage(isSetPlayUrl, open);
	                }
	            }
	        }
	    }, {
	        key: '_recviceCommonDocumentShowPage',
	        value: function _recviceCommonDocumentShowPage(isSetPlayUrl, open) {
	            //普通文档的显示处理
	            var that = this;
	            var fileTypeMark = 'general';
	            that.props.changeFileTypeMark(fileTypeMark); //改变fileTypeMark的值
	            isSetPlayUrl = isSetPlayUrl != null && isSetPlayUrl != undefined ? isSetPlayUrl : true;
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setNewPptFrameSrc', message: { src: '' } });
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'setH5FileFrameSrc', message: { src: '' } });
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].resetDedaultWhiteboardMagnification(that.instanceId); //重置白板的缩放比
	
	            var _HandlerWhiteboardAndCoreInstance$getWhiteboardFiledata = _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardFiledata(that.instanceId);
	
	            var swfpath = _HandlerWhiteboardAndCoreInstance$getWhiteboardFiledata.swfpath;
	            var currpage = _HandlerWhiteboardAndCoreInstance$getWhiteboardFiledata.currpage;
	            var pagenum = _HandlerWhiteboardAndCoreInstance$getWhiteboardFiledata.pagenum;
	            var filetype = _HandlerWhiteboardAndCoreInstance$getWhiteboardFiledata.filetype;
	
	            if (filetype === 'whiteboard') {
	                _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardWatermarkImageScalc(that.instanceId, 16 / 9);
	                if (isSetPlayUrl) {
	                    _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].setWhiteboardWatermarkImage(that.instanceId, "", { resetDedaultWhiteboardMagnification: false });
	                }
	            } else {
	                var index = swfpath.lastIndexOf(".");
	                var imgType = swfpath.substring(index);
	                var fileUrl = swfpath.replace(imgType, "-" + currpage + imgType);
	                if (isSetPlayUrl) {
	                    var serviceUrl = _TkConstant2['default'].SERVICEINFO.protocolAndHostname + ":" + _TkConstant2['default'].SERVICEINFO.port;
	                    _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].setWhiteboardWatermarkImage(that.instanceId, serviceUrl + fileUrl, { resetDedaultWhiteboardMagnification: false });
	
	                    //open == true 为打开一个普通文档。open === undefined为前后翻页
	                    var startInt = 1;
	                    var endInt = 1;
	                    if (open) {
	                        that.cacheMaxPageNum = currpage;
	                        that.filePreLoadCurrPage = currpage;
	                        that.cacheMinPageNum = currpage;
	                        if (that.cacheMaxPageNum + that.filePreLoadStep <= pagenum) {
	                            that.cacheMaxPageNum += that.filePreLoadStep;
	                        } else if (that.cacheMaxPageNum < pagenum) {
	                            that.cacheMaxPageNum += pagenum - that.cacheMaxPageNum;
	                        }
	
	                        if (that.cacheMinPageNum - that.filePreLoadStep >= 1) {
	                            that.cacheMinPageNum -= that.filePreLoadStep;
	                        } else {
	                            that.cacheMinPageNum = 1;
	                        }
	                        endInt = that.cacheMaxPageNum;
	                        startInt = that.cacheMinPageNum;
	                    } else {
	                        if (that.filePreLoadCurrPage < currpage) {
	                            startInt = that.cacheMaxPageNum + 1;
	                            if (currpage > that.cacheMaxPageNum) {
	                                that.cacheMaxPageNum = currpage;
	                            }
	                            if (that.cacheMaxPageNum + that.filePreLoadStep <= pagenum) {
	                                that.cacheMaxPageNum += that.filePreLoadStep;
	                            } else if (that.cacheMaxPageNum < pagenum) {
	                                that.cacheMaxPageNum += pagenum - that.cacheMaxPageNum;
	                            }
	                            endInt = that.cacheMaxPageNum;
	                        } else if (that.filePreLoadCurrPage > currpage) {
	                            endInt = that.cacheMinPageNum - 1;
	                            if (currpage < that.cacheMinPageNum) {
	                                that.cacheMinPageNum = currpage;
	                            }
	                            if (that.cacheMinPageNum - that.filePreLoadStep >= 1) {
	                                that.cacheMinPageNum -= that.filePreLoadStep;
	                            } else {
	                                that.cacheMinPageNum = 1;
	                            }
	                            startInt = that.cacheMinPageNum;
	                        }
	                        that.filePreLoadCurrPage = currpage;
	                    }
	
	                    for (var i = startInt; i <= endInt; i++) {
	                        //todo qiugs 普通文档预加载代码
	                        if (i !== currpage) {
	                            var _index = swfpath.lastIndexOf(".");
	                            var _imgType = swfpath.substring(_index);
	                            var _fileUrl = swfpath.replace(_imgType, "-" + i + _imgType);
	                            var _serviceUrl = _TkConstant2['default'].SERVICEINFO.protocolAndHostname + ":" + _TkConstant2['default'].SERVICEINFO.port;
	                            that.handlerPreloadWhiteboardImg({ type: 'preloadWhiteboardImg', message: { url: _serviceUrl + _fileUrl } });
	                        }
	                    }
	                }
	            }
	            //加载当前页的白板数据
	            that._recoverCurrpageLcData();
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updatePagdingState', message: { source: 'whiteboard', data: _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardFiledata(that.instanceId) } });
	            that.handlerCheckSelectMouseState({ type: 'checkSelectMouseState', message: { fileTypeMark: fileTypeMark } });
	        }
	    }, {
	        key: '_recoverCurrpageLcData',
	        value: function _recoverCurrpageLcData() {
	            //画当前文档当前页数据到白板上
	            var that = this;
	            var paramsJson = { loadRedoStack: _TkConstant2['default'].hasRole.roleChairman };
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].loadCurrpageWhiteboard(that.instanceId, paramsJson);
	        }
	    }, {
	        key: '_whiteboardPaging',
	
	        /*白板翻页*/
	        value: function _whiteboardPaging(next) {
	            var send = arguments.length <= 1 || arguments[1] === undefined ? true : arguments[1];
	            var isSetPlayUrl = arguments.length <= 2 || arguments[2] === undefined ? true : arguments[2];
	
	            var that = this;
	            var lcData = _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardFiledata(that.instanceId);
	            if (next === true) {
	                if (lcData.currpage >= lcData.pagenum) {
	                    return;
	                }
	                lcData.currpage++;
	            } else if (next == false) {
	                if (lcData.currpage <= 1) {
	                    return;
	                }
	                lcData.currpage--;
	            }
	            that.handlerSaveLcStackToStorage();
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardFiledata(that.instanceId, lcData);
	            that._recviceCommonDocumentShowPage(isSetPlayUrl);
	            var pagingData = {
	                isMedia: false,
	                isDynamicPPT: false,
	                isGeneralFile: true,
	                isH5Document: false,
	                action: "",
	                mediaType: "",
	                filedata: lcData
	            };
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                type: 'documentPageChange',
	                message: pagingData
	            });
	            if (send) {
	                var isDelMsg = false,
	                    id = 'DocumentFilePage_ShowPage';
	                _ServiceSignalling2['default'].sendSignallingFromShowPage(isDelMsg, id, pagingData);
	            };
	        }
	    }, {
	        key: '_skipWhiteboardPaging',
	        value: function _skipWhiteboardPaging(currpage) {
	            var send = arguments.length <= 1 || arguments[1] === undefined ? true : arguments[1];
	            var isSetPlayUrl = arguments.length <= 2 || arguments[2] === undefined ? true : arguments[2];
	            //普通文档跳转
	            var that = this;
	            var lcData = _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].getWhiteboardFiledata(that.instanceId);
	            lcData.currpage = currpage;
	            that.handlerSaveLcStackToStorage();
	            _plugsLiterallyJsHandlerWhiteboardAndCore2['default'].updateWhiteboardFiledata(that.instanceId, lcData);
	            that._recviceCommonDocumentShowPage(isSetPlayUrl);
	            var pagingData = {
	                isMedia: false,
	                isDynamicPPT: false,
	                isGeneralFile: true,
	                isH5Document: false,
	                action: "",
	                mediaType: "",
	                filedata: lcData
	            };
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                type: 'documentPageChange',
	                message: pagingData
	            });
	            if (send) {
	                var isDelMsg = false,
	                    id = 'DocumentFilePage_ShowPage';
	                _ServiceSignalling2['default'].sendSignallingFromShowPage(isDelMsg, id, pagingData);
	            };
	        }
	    }, {
	        key: '_saveFileidReturnOpen',
	        value: function _saveFileidReturnOpen(fileFormatInfo) {
	            //保存文件id，返回是否打开文件
	            var that = this;
	            var open = undefined;
	            if (!fileFormatInfo.isMedia) {
	                //不是媒体文件才有这个操作
	                var fileid = fileFormatInfo.filedata.fileid;
	                open = that.fileid != fileid;
	                that.fileid = fileid;
	            }
	            return open;
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	            var _that$props = that.props;
	            var fileTypeMark = _that$props.fileTypeMark;
	
	            var other = _objectWithoutProperties(_that$props, ['fileTypeMark']);
	
	            var show = that.state.show;
	
	            return _react2['default'].createElement('div', _extends({ id: that.whiteboardElementId, style: { display: !show ? 'none' : 'block' }, className: "overflow-hidden  scroll-literally-container " + ('tk-filetype-' + fileTypeMark) }, _TkUtils2['default'].filterContainDataAttribute(other)));
	        }
	    }]);
	
	    return WhiteboardSmart;
	})(_react2['default'].Component);
	
	;
	WhiteboardSmart.propTypes = {
	    instanceId: _react.PropTypes.string.isRequired
	};
	exports['default'] = WhiteboardSmart;
	module.exports = exports['default'];
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(41)))

/***/ }),

/***/ 261:
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {/**
	 * 白板以及动态 Smart模块
	 * @module WhiteboardAndNewpptSmart
	 * @description   整合白板以及动态PPT
	 * @author QiuShao
	 * @date 2017/7/27
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i['return']) _i['return'](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError('Invalid attempt to destructure non-iterable instance'); } }; })();
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(42);
	
	var _reactDom2 = _interopRequireDefault(_reactDom);
	
	var _whiteboard = __webpack_require__(260);
	
	var _whiteboard2 = _interopRequireDefault(_whiteboard);
	
	var _newppt = __webpack_require__(258);
	
	var _newppt2 = _interopRequireDefault(_newppt);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _H5Document = __webpack_require__(254);
	
	var _H5Document2 = _interopRequireDefault(_H5Document);
	
	var WhiteboardAndNewpptSmart = (function (_React$Component) {
	    _inherits(WhiteboardAndNewpptSmart, _React$Component);
	
	    function WhiteboardAndNewpptSmart(props) {
	        _classCallCheck(this, WhiteboardAndNewpptSmart);
	
	        _get(Object.getPrototypeOf(WhiteboardAndNewpptSmart.prototype), 'constructor', this).call(this, props);
	        this.state = {
	            fileTypeMark: 'general', //general 、 dynamicPPT 、 h5document
	            literallyWrapClass: '',
	            literallyWrapStyle: {}
	        };
	        this.fatherContainerId = 'white_board_outer_layout';
	        this.whiteboardContainerId = 'big_literally_wrap';
	    }
	
	    _createClass(WhiteboardAndNewpptSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	        }
	    }, {
	        key: 'changeFileTypeMark',
	        value: function changeFileTypeMark(fileTypeMark) {
	            if (this.state.fileTypeMark !== fileTypeMark) {
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'changeFileTypeMark', message: { fileTypeMark: fileTypeMark } });
	                this.setState({ fileTypeMark: fileTypeMark });
	            }
	        }
	    }, {
	        key: 'resizeWhiteboardSizeCallback',
	        value: function resizeWhiteboardSizeCallback(fatherContainerConfiguration) {
	            if (fatherContainerConfiguration && fatherContainerConfiguration.addClassName !== undefined) {
	                this.state.literallyWrapClass = fatherContainerConfiguration.addClassName;
	                delete fatherContainerConfiguration.addClassName;
	            }
	            var $whiteboardContainer = $("#" + this.whiteboardContainerId);
	            var isChangeMarginTop = false,
	                isChangeMarginLeft = false;
	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;
	
	            try {
	                for (var _iterator = Object.entries(fatherContainerConfiguration)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var _step$value = _slicedToArray(_step.value, 2);
	
	                    var key = _step$value[0];
	                    var value = _step$value[1];
	
	                    if (key === 'marginTop' && Number(value.replace(/(px|%)/g, '')) !== 0) {
	                        isChangeMarginTop = true;
	                        continue;
	                    }
	                    if (key === 'marginLeft' && Number(value.replace(/(px|%)/g, '')) !== 0) {
	                        isChangeMarginLeft = true;
	                        continue;
	                    }
	                    if (key === 'width' || key === 'height') {
	                        this.state.literallyWrapStyle[key] = value;
	                    }
	                    $whiteboardContainer[0].style[key] = value;
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator['return']) {
	                        _iterator['return']();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }
	
	            if (isChangeMarginTop) {
	                var height = $whiteboardContainer.height();
	                $whiteboardContainer.css({ 'margin-top': -height / 2 + 'px' });
	            }
	            if (isChangeMarginLeft) {
	                var width = $whiteboardContainer.width();
	                $whiteboardContainer.css({ 'margin-left': -width / 2 + 'px' });
	            }
	            this.setState({
	                literallyWrapClass: this.state.literallyWrapClass,
	                literallyWrapStyle: this.state.literallyWrapStyle
	            });
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	            return _react2['default'].createElement(
	                'div',
	                { id: that.fatherContainerId, className: "white-board-outer-layout" },
	                '  ',
	                _react2['default'].createElement(
	                    'div',
	                    { id: that.whiteboardContainerId, className: "big-literally-wrap " + this.state.literallyWrapClass },
	                    ' ',
	                    _react2['default'].createElement(_whiteboard2['default'], { instanceId: 'default', resizeWhiteboardSizeCallback: that.resizeWhiteboardSizeCallback.bind(that), fatherContainerId: that.fatherContainerId, fileTypeMark: that.state.fileTypeMark, changeFileTypeMark: that.changeFileTypeMark.bind(that) }),
	                    _react2['default'].createElement(_newppt2['default'], { styleJson: this.state.literallyWrapStyle, fileTypeMark: that.state.fileTypeMark, changeFileTypeMark: that.changeFileTypeMark.bind(that) }),
	                    _react2['default'].createElement(_H5Document2['default'], { styleJson: this.state.literallyWrapStyle, fileTypeMark: that.state.fileTypeMark, changeFileTypeMark: that.changeFileTypeMark.bind(that) })
	                )
	            );
	        }
	    }]);
	
	    return WhiteboardAndNewpptSmart;
	})(_react2['default'].Component);
	
	;
	
	exports['default'] = WhiteboardAndNewpptSmart;
	module.exports = exports['default'];
	/*白板最外层包裹 */ /*白板和动态PPT*/ /*白板内层包裹区域*/
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(41)))

/***/ }),

/***/ 262:
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {/**
	 * 右侧内容-全员操作功能 Smart组件
	 * @module ControlOverallBarSmart
	 * @description   承载右侧内容-全员操作的所有Smart组件
	 * @author QiuShao
	 * @date 2017/08/14
	 */
	
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _ServiceTooltip = __webpack_require__(121);
	
	var _ServiceTooltip2 = _interopRequireDefault(_ServiceTooltip);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var ControlOverallBarSmart = (function (_React$Component) {
	    _inherits(ControlOverallBarSmart, _React$Component);
	
	    function ControlOverallBarSmart(props) {
	        _classCallCheck(this, ControlOverallBarSmart);
	
	        _get(Object.getPrototypeOf(ControlOverallBarSmart.prototype), 'constructor', this).call(this, props);
	        this.state = {
	            show: {
	                allTools: false },
	            //工具箱的权限
	            disabledBlackBoard: false,
	            teachExpansionColumnDisplay: null,
	            answerShow: false,
	            startAndStop: false,
	            restarting: false,
	            timeDescArray: [0, 5, 0, 0],
	            initArr: [{ id: 0, "name": "A", "sel": false }, { id: 1, "name": "B", "sel": false }, { id: 2, "name": "C", "sel": false }, { id: 3, "name": "D", "sel": false }],
	            brr: [],
	            crr: [],
	            idA: [],
	            idB: [],
	            idC: [],
	            idD: [],
	            idE: [],
	            idF: [],
	            idG: [],
	            idH: [],
	            allNumbers: 0,
	            trueLV: 0,
	            allStudentChosseAnswer: {},
	            tableObject: {},
	            round: false,
	            dialShow: false,
	            responderShow: false,
	            beginIsStatus: false,
	            studentRes: false,
	            timerShow: false,
	            userAdmin: "",
	            disabledAnswer: false,
	            disabledTurnplate: false,
	            disabledTimer: false,
	            disabledResponder: false,
	            isPublished: false,
	            toolsShow: {
	                answer: false,
	                turnplate: false,
	                timer: false,
	                responder: false,
	                moreBlackboard: false
	            },
	            teachToolUl: "",
	            boxToolClick: false
	        };
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	        this.destTopShare = false;
	    }
	
	    _createClass(ControlOverallBarSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //roomPubmsg 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //roomPubmsg 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomConnected, that.handlerRoomConnected.bind(that), that.listernerBackupid); //roomDisconnected 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener("initAppPermissions", that.handlerInitAppPermissions.bind(that), that.listernerBackupid); //initAppPermissions：白板可画权限更新
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-timer", that.handlerMsglistTimerShow.bind(that), that.listernerBackupid); //倒计时
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-dial", that.handlerMsglistDialShow.bind(that), that.listernerBackupid); //转盘
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-answer", that.handlerMsglistAnswerShow.bind(that), that.listernerBackupid); //答题卡
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-qiangDaQi", that.handlerMsglistQiangDaQi.bind(that), that.listernerBackupid); //抢答器
	            _eventObjectDefine2['default'].CoreController.addEventListener('receive-msglist-BlackBoard', that.handlerReceive_msglist_BlackBoard.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener('callAllWrapOnClick', that.handlerCallAllWrapOnClick.bind(that), that.listernerBackupid); //callAllWrapOnClick 事件-点击整个页面容器
	            _eventObjectDefine2['default'].CoreController.addEventListener('whiteboardToolBox', that.whiteboardToolBox.bind(that), that.listernerBackupid); //白板工具的点击事件
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	        }
	    }, {
	        key: 'handlerReceive_msglist_BlackBoard',
	        value: function handlerReceive_msglist_BlackBoard(recvEventData) {
	            this.handlerRoomPubmsg(recvEventData);
	            var pubmsgData = recvEventData.message;
	            if (pubmsgData.name === 'BlackBoard') {
	                this.setState({
	                    disabledBlackBoard: true
	                });
	            }
	        }
	    }, {
	        key: 'handlerCallAllWrapOnClick',
	
	        /*屏幕的点击事件*/
	        value: function handlerCallAllWrapOnClick(recvEventData) {
	            if (TK.SDKTYPE === 'mobile') {
	                var _event = recvEventData.message.event;
	
	                var parentId = this.props.parentId || 'teach_header_tool_vessel';
	                if (!(_event.target.id === parentId || $(_event.target) && $(_event.target).parents("#" + parentId).length > 0)) {
	                    this.whiteboardToolBox();
	                }
	            }
	        }
	    }, {
	        key: 'allLiMouseLeave',
	        value: function allLiMouseLeave() {
	            //  	if(TK.SDKTYPE !== 'mobile'){
	
	            //      }
	        }
	    }, {
	        key: 'handlerRoomConnected',
	
	        /*断线重连*/
	        value: function handlerRoomConnected(recvEventData) {
	            //房间连接成功后执行的操作
	            this.setState({
	                disabledBlackBoard: false,
	                disabledAnswer: false,
	                disabledTurnplate: false,
	                disabledTimer: false,
	                disabledResponder: false
	            });
	        }
	    }, {
	        key: 'handlerMsglistTimerShow',
	
	        /*倒计时的message-list*/
	        value: function handlerMsglistTimerShow(recvEventData) {
	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;
	
	            try {
	                for (var _iterator = recvEventData.message.timerShowArr[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var message = _step.value;
	
	                    this.setState({
	                        disabledTimer: true
	                    });
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator['return']) {
	                        _iterator['return']();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerMsglistDialShow',
	
	        /*转盘的message-list*/
	        value: function handlerMsglistDialShow(recvEventData) {
	            var _iteratorNormalCompletion2 = true;
	            var _didIteratorError2 = false;
	            var _iteratorError2 = undefined;
	
	            try {
	
	                for (var _iterator2 = recvEventData.message.dialShowArr[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	                    var message = _step2.value;
	
	                    this.setState({
	                        disabledTurnplate: true
	                    });
	                }
	            } catch (err) {
	                _didIteratorError2 = true;
	                _iteratorError2 = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion2 && _iterator2['return']) {
	                        _iterator2['return']();
	                    }
	                } finally {
	                    if (_didIteratorError2) {
	                        throw _iteratorError2;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerMsglistAnswerShow',
	
	        /*答题卡的message-list*/
	        value: function handlerMsglistAnswerShow(recvEventData) {
	            var _iteratorNormalCompletion3 = true;
	            var _didIteratorError3 = false;
	            var _iteratorError3 = undefined;
	
	            try {
	                for (var _iterator3 = recvEventData.message.answerShowArr[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
	                    var message = _step3.value;
	
	                    this.setState({
	                        disabledAnswer: true
	                    });
	                }
	            } catch (err) {
	                _didIteratorError3 = true;
	                _iteratorError3 = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion3 && _iterator3['return']) {
	                        _iterator3['return']();
	                    }
	                } finally {
	                    if (_didIteratorError3) {
	                        throw _iteratorError3;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerMsglistQiangDaQi',
	
	        /*抢答器的message-list*/
	        value: function handlerMsglistQiangDaQi(recvEventData) {
	            var _iteratorNormalCompletion4 = true;
	            var _didIteratorError4 = false;
	            var _iteratorError4 = undefined;
	
	            try {
	                for (var _iterator4 = recvEventData.message.qiangDaQiArr[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
	                    var message = _step4.value;
	
	                    this.setState({
	                        disabledResponder: true
	                    });
	                }
	            } catch (err) {
	                _didIteratorError4 = true;
	                _iteratorError4 = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion4 && _iterator4['return']) {
	                        _iterator4['return']();
	                    }
	                } finally {
	                    if (_didIteratorError4) {
	                        throw _iteratorError4;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerRoomPubmsg',
	        value: function handlerRoomPubmsg(recvEventData) {
	            var pubmsgData = recvEventData.message;
	            switch (pubmsgData.name) {
	                case "BlackBoard":
	                    this.setState({
	                        disabledBlackBoard: true
	                    });
	                    break;
	                case "answer":
	                    this.setState({
	                        disabledAnswer: true
	                    });
	                    break;
	                case "dial":
	                    this.setState({
	                        disabledTurnplate: true
	                    });
	                    break;
	                case "timer":
	                    this.setState({
	                        disabledTimer: true
	                    });
	                    break;
	                case "qiangDaQi":
	                    this.setState({
	                        disabledResponder: true
	                    });
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerRoomDelmsg',
	        value: function handlerRoomDelmsg(recvEventData) {
	            var delmsgData = recvEventData.message;
	            switch (delmsgData.name) {
	                case "BlackBoard":
	                    this.setState({
	                        disabledBlackBoard: false
	                    });
	                    break;
	                case "answer":
	                    this.setState({
	                        disabledAnswer: false
	                    });
	                    break;
	                case "dial":
	                    this.setState({
	                        disabledTurnplate: false
	                    });
	                    break;
	                case "timer":
	                    this.setState({
	                        disabledTimer: false
	                    });
	                    break;
	                case "qiangDaQi":
	                    this.setState({
	                        disabledResponder: false
	                    });
	                    break;
	                case "ClassBegin":
	                    this.setState({
	                        disabledAnswer: false,
	                        disabledTurnplate: false,
	                        disabledTimer: false,
	                        disabledResponder: false,
	                        disabledBlackBoard: false
	                    });
	            }
	        }
	    }, {
	        key: 'handlerInitAppPermissions',
	
	        /*初始化权限*/
	        value: function handlerInitAppPermissions() {
	            var toolsShow = {
	                answer: true,
	                turnplate: true,
	                timer: true,
	                responder: true,
	                moreBlackboard: true
	            };
	            Object.assign(this.state.toolsShow, toolsShow);
	            this.state.show.allTools = _CoreController2['default'].handler.getAppPermissions('allUserTools');
	            this.setState({ show: this.state.show, destTopShare: this.state.toolsShow });
	        }
	    }, {
	        key: 'teachExpansionController',
	
	        /*显示教学工具箱*/
	        value: function teachExpansionController(e) {
	            e.preventDefault();
	            e.stopPropagation();
	            this.state.boxToolClick = !this.state.boxToolClick;
	            this.setState({
	                boxToolClick: this.state.boxToolClick
	            });
	            if (this.state.boxToolClick) {
	                var boxID = document.getElementById("tool-box");
	                boxID.setAttribute("class", "tool-box-wrap-active");
	                this.state.teachExpansionColumnDisplay = "block";
	                this.state.teachToolUl = "block";
	                this.setState({
	                    teachExpansionColumnDisplay: this.state.teachExpansionColumnDisplay,
	                    teachToolUl: this.state.teachToolUl
	                });
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                    type: 'teacherToolBox'
	                });
	            } else {
	                this.teachBoxLeftMouseOut();
	            }
	        }
	    }, {
	        key: 'whiteboardToolBox',
	
	        /*监听其他工具的点击事件*/
	        value: function whiteboardToolBox() {
	            this.teachBoxLeftMouseOut();
	        }
	    }, {
	        key: 'teachBoxLeftMouseOut',
	
	        /*隐藏工具的事件*/
	        value: function teachBoxLeftMouseOut() {
	            this.state.boxToolClick = false;
	            this.setState({
	                boxToolClick: this.state.boxToolClick
	            });
	            var boxID = document.getElementById("tool-box");
	            boxID.setAttribute("class", "tool-box-wrap");
	            this.state.teachExpansionColumnDisplay = "none";
	            this.setState({ teachExpansionColumnDisplay: this.state.teachExpansionColumnDisplay });
	        }
	    }, {
	        key: 'answerAssemblyShowHandel',
	
	        /*答题器组件的显示的控制*/
	        value: function answerAssemblyShowHandel(e) {
	            if (this.state.disabledAnswer) {
	                return false;
	            }
	            e.preventDefault();
	            e.stopPropagation();
	            this.state.teachToolUl = "none";
	            this.state.answerShow = true;
	            this.setState({
	                answerShow: this.state.answerShow,
	                teachToolUl: this.state.teachToolUl
	            });
	            this.teachBoxLeftMouseOut();
	            var rounds = this.state.round;
	            var optionalAnswer = this.state.initArr;
	            var studentSels = this.state.brr;
	            var trueLV = this.state.trueLV;
	            var allNumbers = this.state.allNumbers;
	            var dataChoose = this.state.allStudentChosseAnswer;
	            var idAS = this.state.idA;
	            var idBS = this.state.idB;
	            var idCS = this.state.idC;
	            var idDS = this.state.idD;
	            var idES = this.state.idE;
	            var idFS = this.state.idF;
	            var idGS = this.state.idG;
	            var idHS = this.state.idH;
	            var dataTable = this.state.tableObject;
	            var isPublished = this.state.isPublished;
	            var quizTime = document.getElementById("result-teach-mytime").textContent;
	            var newCrr = Array.from(new Set(this.state.crr));
	            newCrr = newCrr.sort();
	            var iconShow = this.state.answerShow;
	            var data = {
	                optionalAnswers: optionalAnswer,
	                quizTimes: quizTime,
	                rightAnswers: newCrr,
	                isRound: rounds,
	                studentSelect: studentSels,
	                trueLV: trueLV,
	                allNumbers: allNumbers,
	                dataChoose: dataChoose,
	                dataTable: dataTable,
	                isPublished: isPublished,
	                idAS: idAS,
	                idBS: idBS,
	                idCS: idCS,
	                idDS: idDS,
	                idES: idES,
	                idFS: idFS,
	                idGS: idGS,
	                idHS: idHS,
	                isShow: iconShow
	            };
	            _ServiceSignalling2['default'].sendSignallingAnswerToStudent(data);
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                type: 'handleAnswerShow',
	                className: "answer-implement-bg",
	                isShow: iconShow
	            });
	        }
	    }, {
	        key: 'turntableAssemblyShowHandel',
	
	        /*转盘组件的显示的控制*/
	        value: function turntableAssemblyShowHandel(e) {
	            if (this.state.disabledTurnplate) {
	                return false;
	            }
	            e.preventDefault();
	            e.stopPropagation();
	            this.state.teachToolUl = "none";
	            this.state.dialShow = true;
	            this.setState({
	                dialShow: this.state.dialShow,
	                teachToolUl: this.state.teachToolUl
	            });
	            this.teachBoxLeftMouseOut();
	            var i = 0;
	            var iconShow = this.state.dialShow;
	            var data = {
	                rotationAngle: 'rotate(' + i * 900 + 'deg)',
	                isShow: iconShow
	            };
	            var isDelMsg = false;
	            _ServiceSignalling2['default'].sendSignallingDialToStudent(data);
	        }
	    }, {
	        key: 'timerAssemblyShowHandel',
	
	        /*倒计时组件的显示的控制*/
	        value: function timerAssemblyShowHandel(e) {
	            if (this.state.disabledTimer) {
	                return false;
	            }
	            e.preventDefault();
	            e.stopPropagation();
	            this.state.teachToolUl = "none";
	            this.state.timerShow = true;
	            this.state.restarting = false;
	            this.setState({
	                timerShow: this.state.timerShow,
	                restarting: this.state.restarting,
	                teachToolUl: this.state.teachToolUl
	            });
	            this.teachBoxLeftMouseOut();
	            var stopBtn = this.state.startAndStop;
	            var dataTimerArry = this.state.timeDescArray;
	            var iconShow = this.state.timerShow;
	            var isRestart = this.state.restarting;
	            var data = {
	                isStatus: stopBtn,
	                sutdentTimerArry: dataTimerArry,
	                isShow: iconShow,
	                isRestart: isRestart
	            };
	            _ServiceSignalling2['default'].sendSignallingTimerToStudent(data);
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                type: 'handleTurnShow',
	                className: "timer-implement-bg",
	                isShow: iconShow
	            });
	        }
	    }, {
	        key: 'responderAssemblyShowHandel',
	
	        /*抢答器的显示的控制*/
	        value: function responderAssemblyShowHandel(e) {
	            var that = this;
	            if (that.state.disabledResponder) {
	                return false;
	            };
	            e.preventDefault();
	            e.stopPropagation();
	            that.state.teachToolUl = "none";
	            that.state.responderShow = true;
	            that.setState({
	                responderShow: that.state.responderShow,
	                teachToolUl: that.state.teachToolUl
	            });
	            this.teachBoxLeftMouseOut();
	            var iconShow = that.state.responderShow;
	            var begin = that.state.beginIsStatus;
	            var userAdmin = this.state.userAdmin;
	            var data = {
	                isShow: iconShow,
	                begin: begin,
	                userAdmin: userAdmin
	            };
	            var isDelMsg = false;
	            _ServiceSignalling2['default'].sendSignallingQiangDaQi(isDelMsg, data);
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                type: 'responderShow',
	                className: "responder-implement-bg",
	                isShow: iconShow
	            });
	        }
	    }, {
	        key: 'handleBlackBoardClick',
	        value: function handleBlackBoardClick() {
	            var isDelMsg = false,
	                data = {
	                blackBoardState: '_prepareing', //_none:无 , _prepareing:准备中 , _dispenseed:分发 , _recycle:回收分发 , _againDispenseed:再次分发
	                currentTapKey: 'blackBoardCommon',
	                currentTapPage: 1
	            };
	            _ServiceSignalling2['default'].sendSignallingFromBlackBoard(data, isDelMsg);
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	            var _that$state = that.state;
	            var show = _that$state.show;
	            var onClick = _that$state.onClick;
	            var toolsShow = _that$state.toolsShow;
	            var allTools = show.allTools;
	
	            var toolsNum = 0; //显示工具包的个数
	            var _iteratorNormalCompletion5 = true;
	            var _didIteratorError5 = false;
	            var _iteratorError5 = undefined;
	
	            try {
	                for (var _iterator5 = Object.values(toolsShow)[Symbol.iterator](), _step5; !(_iteratorNormalCompletion5 = (_step5 = _iterator5.next()).done); _iteratorNormalCompletion5 = true) {
	                    var value = _step5.value;
	
	                    if (value) {
	                        toolsNum++;
	                    }
	                    if (toolsNum > 5) {
	                        toolsNum = 5;
	                        break;
	                    }
	                }
	            } catch (err) {
	                _didIteratorError5 = true;
	                _iteratorError5 = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion5 && _iterator5['return']) {
	                        _iterator5['return']();
	                    }
	                } finally {
	                    if (_didIteratorError5) {
	                        throw _iteratorError5;
	                    }
	                }
	            }
	
	            return _react2['default'].createElement(
	                'ol',
	                { className: 'all-participant-function add-fl clear-float  h-tool', id: 'teach_header_tool_vessel', style: { display: allTools ? 'block' : 'none' } },
	                ' ',
	                _react2['default'].createElement(
	                    'li',
	                    { className: 'tl-all-participant-tools ', id: 'tl-all-participant-tools-id', title: _TkGlobal2['default'].language.languageData.toolCase.toolBox.text, onMouseLeave: that.allLiMouseLeave.bind(this), onTouchStart: this.teachExpansionController.bind(this) },
	                    _react2['default'].createElement(
	                        'button',
	                        null,
	                        _react2['default'].createElement('span', { className: 'tool-box-wrap', id: 'tool-box' })
	                    ),
	                    _react2['default'].createElement(
	                        'div',
	                        { className: "teach-expansion-column ", style: { display: this.state.teachExpansionColumnDisplay, width: 'calc(100% * ' + toolsNum + ')' } },
	                        _react2['default'].createElement(
	                            'ul',
	                            { className: 'teach-box-left clear-float', ref: 'teachBoxLeftStyle', style: { display: this.state.teachToolUl } },
	                            _react2['default'].createElement('li', { className: "answer-implement-bg" + " " + (this.state.disabledAnswer ? 'disabled' : ''), disabled: this.state.disabledAnswer, onTouchStart: this.answerAssemblyShowHandel.bind(this), style: { display: !toolsShow.answer ? 'none' : '' } }),
	                            _react2['default'].createElement('li', { className: "turnplate-implement-bg" + " " + (this.state.disabledTurnplate ? 'disabled' : ''), disabled: this.state.disabledTurnplate, onTouchStart: this.turntableAssemblyShowHandel.bind(this), style: { display: !toolsShow.turnplate ? 'none' : '' } }),
	                            _react2['default'].createElement('li', { className: "timer-implement-bg" + " " + (this.state.disabledTimer ? 'disabled' : ''), disabled: this.state.disabledTimer, onTouchStart: this.timerAssemblyShowHandel.bind(this), style: { display: !toolsShow.timer ? 'none' : '' } }),
	                            _react2['default'].createElement('li', { className: "responder-implement-bg" + " " + (this.state.disabledResponder ? 'disabled' : ''), disabled: this.state.disabledResponder, onTouchStart: this.responderAssemblyShowHandel.bind(this), style: { display: toolsShow.responder ? '' : 'none' } }),
	                            _react2['default'].createElement('li', { className: "tl-more-black-board " + (this.state.disabledBlackBoard ? 'disabled' : ''), title: _TkGlobal2['default'].language.languageData.header.tool.blackBoard.title.open, disabled: this.state.disabledBlackBoard, id: 'more_black_board', style: { display: !toolsShow.moreBlackboard ? 'none' : '' }, onTouchStart: this.handleBlackBoardClick.bind(this) })
	                        )
	                    )
	                )
	            );
	        }
	    }]);
	
	    return ControlOverallBarSmart;
	})(_react2['default'].Component);
	
	;
	exports['default'] = ControlOverallBarSmart;
	module.exports = exports['default'];
	/*全员操作功能组件*/
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(41)))

/***/ }),

/***/ 263:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 右侧内容-教学工具箱 Smart组件
	 * @module answerTeachingToolComponent
	 * @description   答题器组件
	 * @author liujianhang
	 * @date 2017/09/19
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
		value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(42);
	
	var _reactDom2 = _interopRequireDefault(_reactDom);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var AnswerStudentToolSmart = (function (_React$Component) {
		_inherits(AnswerStudentToolSmart, _React$Component);
	
		function AnswerStudentToolSmart(props) {
			_classCallCheck(this, AnswerStudentToolSmart);
	
			_get(Object.getPrototypeOf(AnswerStudentToolSmart.prototype), 'constructor', this).call(this, props);
			this.state = {
				optionUl: "",
				initArr: [],
				brr: [],
				allResult: "",
				allResultX: "",
				allResultHover: "",
				crr: [],
				trueSelect: "",
				answerTeachWrapDiv: 'none',
				resultStudentDisplay: null,
				beginStyle: null,
				lisStyle: false,
				flag: null,
				resultTeachStyleDisplay: null,
				changeOneAnswerStyle: "none",
				mySelect: '',
				trueLV: 0,
				allNumbers: 0,
				afterArrayA: [],
				afterArrayB: [],
				afterArrayC: [],
				afterArrayD: [],
				afterArrayE: [],
				afterArrayF: [],
				afterArrayG: [],
				afterArrayH: [],
				allStudentNameA: [],
				allStudentNameB: [],
				allStudentNameC: [],
				allStudentNameD: [],
				allStudentNameE: [],
				allStudentNameF: [],
				allStudentNameG: [],
				allStudentNameH: [],
				liA: "hidden",
				liB: "hidden",
				liC: "hidden",
				liD: "hidden",
				liE: "hidden",
				liF: "hidden",
				liG: "hidden",
				liH: "hidden",
				idA: [],
				idB: [],
				idC: [],
				idD: [],
				idE: [],
				idF: [],
				idG: [],
				idH: [],
				userAdmin: "",
				dataInit: [],
				trueResultDivStyle: "",
				teacherSendTime: "",
				xiangQingText: "",
				columnar: "",
				tableStyle: "",
				tableObject: "",
				userSelect: []
			};
			this.selects = false;
			this.stop = null;
			this.listernerBackupid = new Date().getTime() + '_' + Math.random();
		}
	
		_createClass(AnswerStudentToolSmart, [{
			key: 'componentDidMount',
			value: function componentDidMount() {
				//在完成首次渲染之前调用，此时仍可以修改组件的state
				var that = this;
				_eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-submitAnswers", that.handlerMsglistResultStudent.bind(that), that.listernerBackupid);
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //roomPubmsg事件
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //roomDelmsg事件
				_eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-answer", that.handlerMsglistAnswerShow.bind(that), that.listernerBackupid);
			}
		}, {
			key: 'componentWillUnmount',
			value: function componentWillUnmount() {
				//组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
				var that = this;
				_eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
			}
		}, {
			key: 'handlerRoomPubmsg',
			value: function handlerRoomPubmsg(recvEventData) {
				var that = this;
				var pubmsgData = recvEventData.message;
				switch (pubmsgData.name) {
					case "answer":
						if (_TkConstant2['default'].hasRole.roleStudent) {
							that._updateAnswerShow(pubmsgData);
						}
						break;
					case "submitAnswers":
						if (_TkConstant2['default'].hasRole.roleStudent) {
							that._updateSubmitAnswerShow(pubmsgData);
						}
						break;
				}
			}
		}, {
			key: 'handlerRoomDelmsg',
			value: function handlerRoomDelmsg(recvEventData) {
				var that = this;
				var pubmsgData = recvEventData.message;
				switch (pubmsgData.name) {
					case "ClassBegin":
						that.state.resultStudentDisplay = "none";
						that.state.answerTeachWrapDiv = "none";
						that.setState({ answerTeachWrapDiv: that.state.answerTeachWrapDiv, resultStudentDisplay: that.state.resultStudentDisplay });
						break;
	
					case "answer":
						that.state.answerTeachWrapDiv = "none";
						that.state.resultStudentDisplay = "none";
						that.state.crr = [];
						that.setState({ crr: that.state.crr });
						that.setState({ answerTeachWrapDiv: that.state.answerTeachWrapDiv, resultStudentDisplay: that.state.answerTeachWrapDiv });
	
						break;
				}
			}
		}, {
			key: 'handlerMsglistAnswerShow',
	
			/*answer的message-list*/
			value: function handlerMsglistAnswerShow(recvEventData) {
				var that = this;
				var message = recvEventData.message.answerShowArr;
				var _iteratorNormalCompletion = true;
				var _didIteratorError = false;
				var _iteratorError = undefined;
	
				try {
					for (var _iterator = recvEventData.message.answerShowArr[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
						var _message = _step.value;
	
						if (_TkConstant2['default'].hasRole.roleStudent) {
							that._updateAnswerShow(_message);
						}
					}
				} catch (err) {
					_didIteratorError = true;
					_iteratorError = err;
				} finally {
					try {
						if (!_iteratorNormalCompletion && _iterator['return']) {
							_iterator['return']();
						}
					} finally {
						if (_didIteratorError) {
							throw _iteratorError;
						}
					}
				}
			}
		}, {
			key: 'handlerMsglistResultStudent',
	
			/*submit的message-list*/
			value: function handlerMsglistResultStudent(recvEventData) {
				var that = this;
				var message = recvEventData.message.submitAnswersArr;
				var _iteratorNormalCompletion2 = true;
				var _didIteratorError2 = false;
				var _iteratorError2 = undefined;
	
				try {
					for (var _iterator2 = recvEventData.message.submitAnswersArr[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
						var _message2 = _step2.value;
	
						if (_TkConstant2['default'].hasRole.roleStudent && _ServiceRoom2['default'].getTkRoom().getMySelf().id == _message2.fromID) {
							that._updateSubmitAnswerShow(_message2);
						}
					}
				} catch (err) {
					_didIteratorError2 = true;
					_iteratorError2 = err;
				} finally {
					try {
						if (!_iteratorNormalCompletion2 && _iterator2['return']) {
							_iterator2['return']();
						}
					} finally {
						if (_didIteratorError2) {
							throw _iteratorError2;
						}
					}
				}
			}
		}, {
			key: '_updateSubmitAnswerShow',
			value: function _updateSubmitAnswerShow(pubmsgData) {
				if (pubmsgData.data.sendUserID == _ServiceRoom2['default'].getTkRoom().getMySelf().id) {
					this.state.userSelect = pubmsgData.data.mySelect;
					this.setState({
						userSelect: this.state.userSelect
					});
				}
			}
		}, {
			key: '_updateAnswerShow',
			value: function _updateAnswerShow(pubmsgData) {
				var that = this;
				if (pubmsgData.data.isShow == false) {
					that.state.brr = pubmsgData.data.rightAnswers;
					that.state.lisStyle = false;
					that.state.answerAddStyle = "hidden";
					that.state.answerReduceStyle = "hidden";
					that.state.answerTeachWrapDiv = "block";
					that.state.teacherSendTime = pubmsgData.ts;
					that.state.changeOneAnswerStyle = "none";
					_reactDom2['default'].findDOMNode(that.refs.submitAndChange).textContent = _TkGlobal2['default'].language.languageData.answers.submitAnswer.text;
					that.state.beginStyle = "";
					that.state.initArr = pubmsgData.data.optionalAnswers;
					var _iteratorNormalCompletion3 = true;
					var _didIteratorError3 = false;
					var _iteratorError3 = undefined;
	
					try {
						for (var _iterator3 = that.state.initArr[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
							var value = _step3.value;
	
							value.sel = false;
						}
					} catch (err) {
						_didIteratorError3 = true;
						_iteratorError3 = err;
					} finally {
						try {
							if (!_iteratorNormalCompletion3 && _iterator3['return']) {
								_iterator3['return']();
							}
						} finally {
							if (_didIteratorError3) {
								throw _iteratorError3;
							}
						}
					}
	
					that.setState({
						answerTeachWrapDiv: that.state.answerTeachWrapDiv,
						answerAddStyle: that.state.answerAddStyle,
						initArr: that.state.initArr,
						brr: that.state.brr,
						lisStyle: that.state.lisStyle,
						beginStyle: that.state.beginStyle,
						changeOneAnswerStyle: that.state.changeOneAnswerStyle,
						teacherSendTime: that.state.teacherSendTime
					});
	
					if (pubmsgData.data.isRound) {
						that.state.trueLV = pubmsgData.data.trueLV;
						that.state.allNumbers = pubmsgData.data.allNumbers;
						that.state.dataInit = pubmsgData.data.optionalAnswers;
						that.setState({
							trueLV: that.state.trueLV,
							allNumbers: that.state.allNumbers,
							dataInit: that.state.dataInit
						});
						that.coordArr();
						that.trueArr();
						that.state.idA = [];
						that.state.idB = [];
						that.state.idC = [];
						that.state.idD = [];
						that.state.idE = [];
						that.state.idF = [];
						that.state.idG = [];
						that.state.idH = [];
						that.state.afterArrayA = [];
						that.state.afterArrayB = [];
						that.state.afterArrayC = [];
						that.state.afterArrayD = [];
						that.state.afterArrayE = [];
						that.state.afterArrayF = [];
						that.state.afterArrayG = [];
						that.state.afterArrayH = [];
						for (var a in pubmsgData.data.dataChoose) {
							for (var i in pubmsgData.data.dataChoose[a]) {
								pubmsgData.data.dataChoose[a][i].map(function (item, index) {
									if (item == "A") {
										that.state.idA = pubmsgData.data.idAS;
										that.state.afterArrayA = [];
										that.setState({
											afterArray: that.state.afterArray
										});
										var A = _react2['default'].createElement(
											'div',
											{ className: 'answer-stu-lis', key: index, style: { height: that.state.idA.length < 13 ? that.state.idA.length / 10 + "rem" : 1.2 + "rem" } },
											_react2['default'].createElement(
												'p',
												null,
												that.state.idA.length
											)
										);
										that.state.afterArrayA.push(A);
										that.setState({
											afterArrayA: that.state.afterArrayA,
											idA: that.state.idA
										});
									}
									if (item == "B") {
										that.state.idB = pubmsgData.data.idBS;
										that.state.afterArrayB = [];
										that.setState({
											afterArray: that.state.afterArray
										});
										var B = _react2['default'].createElement(
											'div',
											{ className: 'answer-stu-lis', key: index, style: { height: that.state.idB.length < 13 ? that.state.idB.length / 10 + "rem" : 1.2 + "rem" } },
											_react2['default'].createElement(
												'p',
												null,
												that.state.idB.length
											)
										);
										that.state.afterArrayB.push(B);
										that.setState({
											afterArrayB: that.state.afterArrayB,
											idB: that.state.idB
										});
									}
									if (item == "C") {
										that.state.idC = pubmsgData.data.idCS;
										that.state.afterArrayC = [];
										that.setState({
											afterArray: that.state.afterArray
										});
										var C = _react2['default'].createElement(
											'div',
											{ className: 'answer-stu-lis', key: index, style: { height: that.state.idC.length < 13 ? that.state.idC.length / 10 + "rem" : 1.2 + "rem" } },
											_react2['default'].createElement(
												'p',
												null,
												that.state.idC.length
											)
										);
										that.state.afterArrayC.push(C);
										that.setState({
											afterArrayC: that.state.afterArrayC,
											idC: that.state.idC
										});
									}
									if (item == "D") {
										that.state.idD = pubmsgData.data.idDS;
										that.state.afterArrayD = [];
										var D = _react2['default'].createElement(
											'div',
											{ className: 'answer-stu-lis', key: index, style: { height: that.state.idD.length < 13 ? that.state.idD.length / 10 + "rem" : 1.2 + "rem" } },
											_react2['default'].createElement(
												'p',
												null,
												that.state.idD.length
											)
										);
										that.state.afterArrayD.push(D);
										that.setState({
											afterArrayD: that.state.afterArrayD,
											idD: that.state.idD
										});
									}
									if (item == "E") {
										that.state.idE = pubmsgData.data.idES;
										that.state.afterArrayE = [];
										var E = _react2['default'].createElement(
											'div',
											{ className: 'answer-stu-lis', key: index, style: { height: that.state.idE.length < 13 ? that.state.idE.length / 10 + "rem" : 1.2 + "rem" } },
											_react2['default'].createElement(
												'p',
												null,
												that.state.idE.length
											)
										);
										that.state.afterArrayE.push(E);
										that.setState({
											afterArrayE: that.state.afterArrayE,
											idE: that.state.idE
										});
									}
									if (item == "F") {
										that.state.idF = pubmsgData.data.idFS;
										that.state.afterArrayF = [];
										var D = _react2['default'].createElement(
											'div',
											{ className: 'answer-stu-lis', key: index, style: { height: that.state.idF.length < 13 ? that.state.idF.length / 10 + "rem" : 1.2 + "rem" } },
											_react2['default'].createElement(
												'p',
												null,
												that.state.idF.length
											)
										);
										that.state.afterArrayF.push(D);
										that.setState({
											afterArrayF: that.state.afterArrayF,
											idF: that.state.idF
										});
									}
									if (item == "G") {
										that.state.idG = pubmsgData.data.idGS;
										that.state.afterArrayG = [];
										var G = _react2['default'].createElement(
											'div',
											{ className: 'answer-stu-lis', key: index, style: { height: that.state.idG.length < 13 ? that.state.idG.length / 10 + "rem" : 1.2 + "rem" } },
											_react2['default'].createElement(
												'p',
												null,
												that.state.idG.length
											)
										);
										that.state.afterArrayG.push(G);
										that.setState({
											afterArrayG: that.state.afterArrayG,
											idG: that.state.idG
										});
									}
									if (item == "H") {
										that.state.idH = pubmsgData.data.idHS;
										that.state.afterArrayH = [];
										var H = _react2['default'].createElement(
											'div',
											{ className: 'answer-stu-lis', key: index, style: { height: that.state.idH.length < 13 ? that.state.idH.length / 10 + "rem" : 1.2 + "rem" } },
											_react2['default'].createElement(
												'p',
												null,
												that.state.idH.length
											)
										);
										that.state.afterArrayH.push(H);
										that.setState({
											afterArrayH: that.state.afterArrayH,
											idH: that.state.idH
										});
									}
								});
							}
						};
						that.coordArrX();
						setTimeout(function () {
							that.mySelectArr(that.state.userSelect);
						}, 10);
						that.state.resultStudentDisplay = "block";
						document.getElementById("result-teach-mytimes").textContent = pubmsgData.data.quizTimes;
						that.state.resultStudentDisplay = "block";
						that.state.answerTeachWrapDiv = "none";
						that.state.beginStyle = "";
						that.state.trueResultDivStyle = "hidden";
						that.state.columnar = "block";
						that.state.tableStyle = "none";
						that.state.tableObject = pubmsgData.data.dataTable;
						_reactDom2['default'].findDOMNode(that.refs.submitAndChange).textContent = _TkGlobal2['default'].language.languageData.answers.submitAnswer.text;
						that.state.xiangQingText = _TkGlobal2['default'].language.languageData.answers.details.text;
						that.setState({
							columnar: that.state.columnar,
							tableStyle: that.state.tableStyle,
							tableObject: that.state.tableObject,
							resultStudentDisplay: that.state.resultStudentDisplay,
							answerTeachWrapDiv: that.state.answerTeachWrapDiv,
							beginStyle: that.state.beginStyle,
							trueResultDivStyle: that.state.trueResultDivStyle,
							xiangQingText: that.state.xiangQingText,
							userSelect: that.state.userSelect
						});
						if (pubmsgData.data.isPublished) {
							that.state.trueResultDivStyle = "visible";
							that.setState({
								trueResultDivStyle: that.state.trueResultDivStyle
	
							});
						}
					} else {
						that.state.resultStudentDisplay = "none";
						that.state.answerTeachWrapDiv = "block";
						_reactDom2['default'].findDOMNode(that.refs.submitAndChange).textContent = _TkGlobal2['default'].language.languageData.answers.submitAnswer.text;
						that.state.beginStyle = "";
						that.setState({
							answerTeachWrapDiv: that.state.answerTeachWrapDiv,
							resultStudentDisplay: that.state.resultStudentDisplay,
							beginStyle: that.state.beginStyle
						});
					}
				} else {
					that.state.crr = [];
					that.state.answerTeachWrapDiv = "none";
					that.state.resultStudentDisplay = "none";
					that.setState({
						answerTeachWrapDiv: that.state.answerTeachWrapDiv,
						resultStudentDisplay: that.state.resultStudentDisplay,
						crr: that.state.crr
					});
				}
			}
		}, {
			key: '_loadTimeDescArray',
	
			/*学生可选的选项*/
			value: function _loadTimeDescArray(desc) {
				var _this = this;
	
				var beforeArray = [];
				desc.map(function (item, index) {
					var a = _react2['default'].createElement(
						'li',
						{ className: 'answer-teach-lis', key: item.id, style: { background: _this.state.initArr[index].sel ? "#2196f3" : null }, onClick: _this.changeColor.bind(_this, index) },
						item.name
					);
					beforeArray.push(a);
				});
				return {
					beforeArray: beforeArray
				};
			}
		}, {
			key: '_loadTableDescArray',
	
			/*table*/
			value: function _loadTableDescArray(tableObject) {
				var afterArry = [];
				if (tableObject != "") {
					var newCrr = Array.from(new Set(this.state.brr));
					newCrr = newCrr.sort();
					for (var item in tableObject) {
						var item0 = item + "0";
						var item1 = item + "1";
						var item2 = item + "2";
						var trueResult = tableObject[item][item1].toString() == newCrr.toString();
						var m = parseInt(tableObject[item][item2] / 60) < 10 ? '0' + parseInt(tableObject[item][item2] / 60) : parseInt(tableObject[item][item2] / 60);
						var n = parseInt(tableObject[item][item2] % 60) < 10 ? '0' + parseInt(tableObject[item][item2] % 60) : parseInt(tableObject[item][item2] % 60);
						var student = _react2['default'].createElement(
							'tr',
							{ key: item },
							_react2['default'].createElement(
								'td',
								null,
								tableObject[item][item0]
							),
							_react2['default'].createElement(
								'td',
								{ className: trueResult ? 'table-true-result' : 'table-false-result' },
								tableObject[item][item1]
							),
							_react2['default'].createElement(
								'td',
								null,
								m,
								':',
								n
							)
						);
						afterArry.push(student);
					}
				}
				return {
					afterArry: afterArry
				};
			}
		}, {
			key: 'changeColor',
	
			/*改变颜色*/
			value: function changeColor(index, e) {
				if (this.state.lisStyle) {
					return false;
				}
				this.state.crr = [];
				this.state.crr.length = 0;
				this.setState({
					crr: this.state.crr
				});
				this.state.initArr[index].sel = !this.state.initArr[index].sel;
				this.setState({
					initArr: this.state.initArr
				});
				if (this.state.initArr[index].sel == false) {
					this.state.beginStyle = "";
					this.setState({
						beginStyle: this.state.beginStyle
					});
				}
				var _iteratorNormalCompletion4 = true;
				var _didIteratorError4 = false;
				var _iteratorError4 = undefined;
	
				try {
					for (var _iterator4 = this.state.initArr[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
						var value = _step4.value;
	
						if (value.sel) {
							this.state.beginStyle = "#2196f3";
							this.setState({
								beginStyle: this.state.beginStyle
							});
						}
					}
				} catch (err) {
					_didIteratorError4 = true;
					_iteratorError4 = err;
				} finally {
					try {
						if (!_iteratorNormalCompletion4 && _iterator4['return']) {
							_iterator4['return']();
						}
					} finally {
						if (_didIteratorError4) {
							throw _iteratorError4;
						}
					}
				}
	
				for (var i = 0; i < this.state.initArr.length; i++) {
					if (this.state.initArr[i].sel) {
						this.state.crr.push(this.state.initArr[i].name);
						this.state.crr = Array.from(new Set(this.state.crr));
						this.setState({
							crr: this.state.crr
						});
					}
				}
			}
		}, {
			key: 'beginAnswer',
	
			/*提交答案*/
			value: function beginAnswer(e) {
				if (this.state.crr.length == 0) {
					_reactDom2['default'].findDOMNode(this.refs.submitAndChange).textContent = _TkGlobal2['default'].language.languageData.answers.submitAnswer.text;
					this.state.changeOneAnswerStyle = "block";
					this.setState({
						changeOneAnswerStyle: this.state.changeOneAnswerStyle
					});
					return false;
				};
				if (this.state.crr.length > 0) {
					this.state.changeOneAnswerStyle = "none";
					this.setState({
						changeOneAnswerStyle: this.state.changeOneAnswerStyle
					});
				};
				this.state.lisStyle = !this.state.lisStyle;
				this.setState({
					lisStyle: this.state.lisStyle
				});
				if (this.state.lisStyle == true) {
					this._initSelectArr();
					var studentChoseItem = this.state.crr;
					var isDelMsg = false;
					this.state.userAdmin = _ServiceRoom2['default'].getTkRoom().getMySelf().nickname;
					this.setState({
						userAdmin: this.state.userAdmin
					});
					var times = this.state.teacherSendTime;
					var sendStudentName = this.state.userAdmin;
					var sendUserID = _ServiceRoom2['default'].getTkRoom().getMySelf().id;
					var optionalAnswers = this.state.initArr;
					var data = {
						mySelect: studentChoseItem,
						sendStudentName: sendStudentName,
						sendUserID: sendUserID,
						times: times,
						optionalAnswers: optionalAnswers
					};
					e.target.textContent = _TkGlobal2['default'].language.languageData.answers.changeAnswer.text;
					_ServiceSignalling2['default'].sendSignallingDataStudentToTeacherAnswer(isDelMsg, data);
				} else {
					this.state.crr = [];
					this.state.beginStyle = "#074496";
					this.setState({
						crr: this.state.crr,
						beginStyle: this.state.beginStyle
					});
					var _iteratorNormalCompletion5 = true;
					var _didIteratorError5 = false;
					var _iteratorError5 = undefined;
	
					try {
						for (var _iterator5 = this.state.initArr[Symbol.iterator](), _step5; !(_iteratorNormalCompletion5 = (_step5 = _iterator5.next()).done); _iteratorNormalCompletion5 = true) {
							var value = _step5.value;
	
							value.sel = false;
						}
					} catch (err) {
						_didIteratorError5 = true;
						_iteratorError5 = err;
					} finally {
						try {
							if (!_iteratorNormalCompletion5 && _iterator5['return']) {
								_iterator5['return']();
							}
						} finally {
							if (_didIteratorError5) {
								throw _iteratorError5;
							}
						}
					}
	
					e.target.textContent = _TkGlobal2['default'].language.languageData.answers.submitAnswer.text;
				}
			}
		}, {
			key: '_initSelectArr',
	
			/*初始化数组*/
			value: function _initSelectArr() {
				this.state.crr = [];
				this.state.crr.length = 0;
				this.setState({
					crr: this.state.crr
				});
				for (var i = 0; i < this.state.initArr.length; i++) {
					if (this.state.initArr[i].sel == true) {
						this.state.crr.push(this.state.initArr[i].name);
						this.setState({
							crr: this.state.crr
						});
					}
				}
			}
	
			/*柱状图*/
		}, {
			key: 'coordArrX',
			value: function coordArrX() {
				var _this2 = this;
	
				this.state.allResultX = this.state.dataInit.map(function (value, index) {
					if (value.name == "A") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this2.state.afterArrayA
						);
					}
					if (value.name == "B") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this2.state.afterArrayB
						);
					}
					if (value.name == "C") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this2.state.afterArrayC
						);
					}
					if (value.name == "D") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this2.state.afterArrayD
						);
					}
					if (value.name == "E") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this2.state.afterArrayE
						);
					}
					if (value.name == "F") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this2.state.afterArrayF
						);
					}
					if (value.name == "G") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this2.state.afterArrayG
						);
					}
					if (value.name == "H") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this2.state.afterArrayH
						);
					}
				});
				this.setState({
					allResultX: this.state.allResultX
				});
			}
		}, {
			key: 'coordArr',
			value: function coordArr() {
				this.state.allResult = this.state.dataInit.map(function (value, index) {
					return _react2['default'].createElement(
						'li',
						{ key: value.id },
						value.name
					);
				});
				this.setState({
					allResult: this.state.allResult
				});
			}
		}, {
			key: 'trueArr',
	
			//正确答案
			value: function trueArr() {
				this.state.trueSelect = this.state.brr.map(function (value, index) {
					return _react2['default'].createElement(
						'span',
						{ className: 'spans', key: index },
						value
					);
				});
				this.setState({ trueSelect: this.state.trueSelect });
			}
		}, {
			key: 'mySelectArr',
	
			/*我的答案*/
			value: function mySelectArr(Arry) {
				var newCrr = Array.from(new Set(Arry));
				newCrr = newCrr.sort();
				this.state.mySelect = newCrr.map(function (value, index) {
					return _react2['default'].createElement(
						'span',
						{ className: 'spans', key: index },
						value
					);
				});
				this.setState({ mySelect: this.state.mySelect });
			}
		}, {
			key: 'xiangQingHandel',
	
			/*图表*/
			value: function xiangQingHandel() {
				this.state.isXiangQing = !this.state.isXiangQing;
				this.setState({
					isXiangQing: this.state.isXiangQing
				});
				if (this.state.isXiangQing) {
					this.state.columnar = "none";
					this.state.tableStyle = "block";
					this.state.xiangQingText = _TkGlobal2['default'].language.languageData.answers.statistics.text;
					this.setState({
						columnar: this.state.columnar,
						tableStyle: this.state.tableStyle,
						xiangQingText: this.state.xiangQingText
					});
				} else {
					this.state.columnar = "block";
					this.state.tableStyle = "none";
					this.state.xiangQingText = _TkGlobal2['default'].language.languageData.answers.details.text;
					this.setState({
						columnar: this.state.columnar,
						tableStyle: this.state.tableStyle,
						xiangQingText: this.state.xiangQingText
					});
				}
			}
		}, {
			key: 'render',
			value: function render() {
				var _state = this.state;
				var initArr = _state.initArr;
				var tableObject = _state.tableObject;
	
				this.state.crr = Array.from(new Set(this.state.crr));
	
				var _loadTimeDescArray2 = this._loadTimeDescArray(initArr);
	
				var beforeArray = _loadTimeDescArray2.beforeArray;
	
				var _loadTableDescArray2 = this._loadTableDescArray(tableObject);
	
				var afterArry = _loadTableDescArray2.afterArry;
	
				return _react2['default'].createElement(
					'div',
					null,
					_react2['default'].createElement(
						'div',
						{ className: 'answer-teach-wrapDiv', style: { display: this.state.answerTeachWrapDiv }, ref: 'dragBox' },
						_react2['default'].createElement(
							'div',
							{ className: 'answer-teach-header' },
							_react2['default'].createElement(
								'div',
								{ className: 'answer-teach-header-left' },
								_react2['default'].createElement('span', { className: 'answer-teach-headerImg' }),
								_react2['default'].createElement(
									'span',
									{ className: 'answer-teach-header-left-grey' },
									_TkGlobal2['default'].language.languageData.answers.headerTopLeft.text
								),
								_react2['default'].createElement(
									'span',
									{ className: 'answer-teach-header-left-green' },
									_TkGlobal2['default'].language.languageData.answers.headerMiddel.text
								)
							),
							_react2['default'].createElement('div', { className: 'answer-teach-header-right', style: { display: "none" } })
						),
						_react2['default'].createElement(
							'div',
							{ className: 'answer-teach-content' },
							_react2['default'].createElement(
								'ul',
								{ className: 'answer-teach-optionUl' },
								beforeArray
							),
							_react2['default'].createElement(
								'p',
								{ className: 'changeOneAnswer', style: { display: this.state.changeOneAnswerStyle } },
								_TkGlobal2['default'].language.languageData.answers.selectAnswer.text
							),
							_react2['default'].createElement(
								'div',
								{ className: 'answer-teach-add', style: { visibility: this.state.answerAddStyle } },
								'+'
							),
							_react2['default'].createElement(
								'div',
								{ className: 'answer-teach-reduce', style: { visibility: this.state.answerReduceStyle } },
								'-'
							),
							_react2['default'].createElement(
								'div',
								{ className: 'answer-teach-begin', onTouchStart: this.beginAnswer.bind(this), style: { background: this.state.beginStyle }, ref: 'submitAndChange' },
								_TkGlobal2['default'].language.languageData.answers.submitAnswer.text
							)
						)
					),
					_react2['default'].createElement(
						'div',
						{ className: 'result-teach-wrapDiv', style: { display: this.state.resultStudentDisplay }, ref: 'resultRef' },
						_react2['default'].createElement(
							'div',
							{ className: 'result-teach-header' },
							_react2['default'].createElement(
								'div',
								{ className: 'result-teach-header-left' },
								_react2['default'].createElement('span', { className: 'result-teach-headerImg' }),
								_react2['default'].createElement(
									'span',
									{ className: 'result-teach-header-left-grey' },
									_TkGlobal2['default'].language.languageData.answers.headerTopLeft.text
								),
								_react2['default'].createElement('span', { id: 'result-teach-mytimes', ref: 'timeText' })
							),
							_react2['default'].createElement(
								'p',
								{ className: 'result-teach-close', style: { display: this.state.resultTeachStyleDisplay } },
								'  '
							)
						),
						_react2['default'].createElement(
							'div',
							{ className: 'result-teach-content' },
							_react2['default'].createElement(
								'p',
								{ className: 'answersPeople' },
								_TkGlobal2['default'].language.languageData.answers.numberOfAnswer.text,
								':',
								_react2['default'].createElement(
									'span',
									{ ref: 'ans' },
									this.state.allNumbers
								),
								_react2['default'].createElement(
									'span',
									{ className: 'xiang-qing-div', onTouchStart: this.xiangQingHandel.bind(this) },
									'(',
									this.state.xiangQingText,
									')'
								)
							),
							_react2['default'].createElement(
								'span',
								{ className: 'result-teach-accuracy-right' },
								_react2['default'].createElement(
									'span',
									{ className: 'result-teach-accuracy-right-text' },
									_TkGlobal2['default'].language.languageData.answers.tureAccuracy.text,
									'：'
								),
								_react2['default'].createElement(
									'span',
									{ style: { color: "red" } },
									this.state.trueLV,
									'%'
								)
							),
							_react2['default'].createElement(
								'div',
								{ className: 'result-teach-coordinate-div', style: { display: this.state.columnar } },
								_react2['default'].createElement(
									'span',
									{ className: 'result-teach-heart-span' },
									'0'
								),
								_react2['default'].createElement(
									'div',
									{ className: 'result-teach-staff-div' },
									_react2['default'].createElement(
										'ul',
										{ className: 'result-student-allResult' },
										this.state.allResultX
									)
								),
								_react2['default'].createElement(
									'ul',
									{ className: 'result-teach-allResult' },
									this.state.allResult
								)
							),
							_react2['default'].createElement(
								'div',
								{ className: 'answer-table-div', style: { display: this.state.tableStyle } },
								_react2['default'].createElement(
									'table',
									{ className: 'answer-table' },
									_react2['default'].createElement(
										'tbody',
										null,
										_react2['default'].createElement(
											'tr',
											{ className: 'answer-table-first-tr' },
											_react2['default'].createElement(
												'th',
												null,
												_TkGlobal2['default'].language.languageData.answers.student.text
											),
											_react2['default'].createElement(
												'th',
												null,
												_TkGlobal2['default'].language.languageData.answers.TheSelectedTheAnswer.text
											),
											_react2['default'].createElement(
												'th',
												null,
												_TkGlobal2['default'].language.languageData.answers.AnswerTime.text
											)
										),
										afterArry
									)
								)
							),
							_react2['default'].createElement(
								'div',
								{ className: 'result-teach-true-result', style: { visibility: this.state.trueResultDivStyle } },
								_react2['default'].createElement(
									'span',
									{ style: { color: "white" } },
									_TkGlobal2['default'].language.languageData.answers.trueAnswer.text,
									':'
								),
								_react2['default'].createElement(
									'span',
									{ className: 'result-teach-trueSelect' },
									this.state.trueSelect
								)
							),
							_react2['default'].createElement(
								'div',
								{ className: 'result-teach-true-result' },
								_react2['default'].createElement(
									'span',
									{ style: { color: "white" } },
									_TkGlobal2['default'].language.languageData.answers.myAnswer.text,
									':'
								),
								_react2['default'].createElement(
									'span',
									{ className: 'result-teach-trueSelect' },
									this.state.mySelect
								)
							)
						)
					)
				);
			}
		}]);
	
		return AnswerStudentToolSmart;
	})(_react2['default'].Component);
	
	exports['default'] = AnswerStudentToolSmart;
	module.exports = exports['default'];

/***/ }),

/***/ 264:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 右侧内容-教学工具箱 Smart组件
	 * @module answerTeachingToolComponent
	 * @description   答题器组件
	 * @author liujianhang
	 * @date 2017/09/19
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
		value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(42);
	
	var _reactDom2 = _interopRequireDefault(_reactDom);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _answerStudentTool = __webpack_require__(263);
	
	var _answerStudentTool2 = _interopRequireDefault(_answerStudentTool);
	
	var _reactDraggable = __webpack_require__(58);
	
	var _reactDraggable2 = _interopRequireDefault(_reactDraggable);
	
	var AnswerTeachingToolSmart = (function (_React$Component) {
		_inherits(AnswerTeachingToolSmart, _React$Component);
	
		function AnswerTeachingToolSmart(props) {
			_classCallCheck(this, AnswerTeachingToolSmart);
	
			_get(Object.getPrototypeOf(AnswerTeachingToolSmart.prototype), 'constructor', this).call(this, props);
			var id = this.props.id;
	
			this.state = _defineProperty({
				optionUl: "",
				initArr: [{ id: 0, "name": "A", "sel": false }, { id: 1, "name": "B", "sel": false }, { id: 2, "name": "C", "sel": false }, { id: 3, "name": "D", "sel": false }],
				brr: [],
				allResult: "",
				allResultX: "",
				crr: [],
				trueSelect: "",
				endQuestion: null,
				restartQuestion: null,
				answerTeachWrapDiv: 'none',
				resultTeachDisplay: null,
				beginStyle: null,
				lisStyle: false,
				flag: null,
				plusStyle: "#368bcb",
				reduceStyle: "#368bcb",
				resultTeachStyleDisplay: null,
				studentNumber: 0,
				numz: 0,
				afterArrayA: [],
				afterArrayB: [],
				afterArrayC: [],
				afterArrayD: [],
				afterArrayE: [],
				afterArrayF: [],
				afterArrayG: [],
				afterArrayH: [],
				studentNumbers: [],
				allStudentNameA: [],
				allStudentNameB: [],
				allStudentNameC: [],
				allStudentNameD: [],
				allStudentNameE: [],
				allStudentNameF: [],
				allStudentNameG: [],
				allStudentNameH: [],
				allNumbers: 0,
				studentSendArry: [],
				liA: "hidden",
				liB: "hidden",
				liC: "hidden",
				liD: "hidden",
				liE: "hidden",
				liF: "hidden",
				liG: "hidden",
				liH: "hidden",
				idA: [],
				idB: [],
				idC: [],
				idD: [],
				idE: [],
				idF: [],
				idG: [],
				idH: [],
				trueNum: 0,
				trueLV: 0,
				allStudentChosseAnswer: {},
				round: false,
				isShow: false,
				dataInit: [],
				publishAnswerText: "",
				xiangQingText: "",
				tableStyle: "",
				columnar: "",
				isXiangQing: false,
				tableArry: [],
				tableObject: {},
				isPublished: false,
				publishedWarning: "none",
				publishedWarningColor: "#074496"
			}, id, {
				left: 0,
				top: 0,
				offsetX: 0,
				offsetY: 0
			});
	
			this.liArr = [{ id: 0, "name": "A", "sel": false }, { id: 1, "name": "B", "sel": false }, { id: 2, "name": "C", "sel": false }, { id: 3, "name": "D", "sel": false }, { id: 4, "name": "E", "sel": false }, { id: 5, "name": "F", "sel": false }, { id: 6, "name": "G", "sel": false }, { id: 7, "name": "H", "sel": false }];
			this.selects = false;
			this.stop = null;
			this.isHasTransition = false;
			this[id] = {}; //保存位置的百分比
			this.listernerBackupid = new Date().getTime() + '_' + Math.random();
		}
	
		_createClass(AnswerTeachingToolSmart, [{
			key: 'componentDidMount',
			value: function componentDidMount() {
				//在完成首次渲染之前调用，此时仍可以修改组件的state
				var that = this;
				that.trueArr();
				_eventObjectDefine2['default'].Window.addEventListener(_TkConstant2['default'].EVENTTYPE.WindowEvent.onResize, that.handlerOnResize.bind(that), that.listernerBackupid); //window.resize事件
				_eventObjectDefine2['default'].CoreController.addEventListener('handleAnswerShow', that.handleAnswerShow.bind(that), that.listernerBackupid);
				_eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-submitAnswers", that.handlerMsglistResultStudent.bind(that), that.listernerBackupid);
				_eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-answer", that.handlerMsglistAnswerShow.bind(that), that.listernerBackupid);
				_eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-AnswerDrag", that.handlerMsglistAnswerDrag.bind(that), that.listernerBackupid);
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid);
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //roomPubmsg事件
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPlaybackClearAllFromPlaybackController, that.handlerRoomPlaybackClearAll.bind(that), that.listernerBackupid); //roomPlaybackClearAll 事件：回放清除所有信令
			}
		}, {
			key: 'componentDidUpdate',
			value: function componentDidUpdate() {
				//每次render结束后会触发,每次转过之后去除过度效果
				if (this.isHasTransition == true) {
					this.isHasTransition = false;
				}
			}
		}, {
			key: 'handlerOnResize',
			value: function handlerOnResize() {
				var that = this;
				var id = this.props.id;
	
				if (Object.keys(that[id]).length !== 0) {
					var _that$id = that[id];
					var percentLeft = _that$id.percentLeft;
					var percentTop = _that$id.percentTop;
	
					_TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
					this.setState(_defineProperty({}, id, this.state[id]));
				}
			}
		}, {
			key: 'handlerRoomPubmsg',
			value: function handlerRoomPubmsg(recvEventData) {
				var that = this;
				var pubmsgData = recvEventData.message;
				switch (pubmsgData.name) {
					case "answer":
						if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol) {
							that._teacherRecevedServiceDataShow(pubmsgData);
						}
						break;
					case "submitAnswers":
						that._updateStudentShow(pubmsgData);
						break;
					case 'AnswerDrag':
						//答题卡的拖拽
						var id = that.props.id;
	
						this.isHasTransition = true;
						var _pubmsgData$data = pubmsgData.data,
						    percentLeft = _pubmsgData$data.percentLeft,
						    percentTop = _pubmsgData$data.percentTop;
	
						this[id] = {
							percentLeft: percentLeft,
							percentTop: percentTop
						};
						_TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
						this.setState(_defineProperty({}, id, this.state[id]));
						break;
				}
			}
		}, {
			key: 'handlerMsglistAnswerDrag',
			value: function handlerMsglistAnswerDrag(handleData) {
				var _this = this;
	
				//msglist,计时器的拖拽位置
				var AnswerDragInfo = handleData.message.AnswerDragArray;
				var that = this;
				var id = that.props.id;
	
				AnswerDragInfo.map(function (item, index) {
					var _item$data = item.data;
					var percentLeft = _item$data.percentLeft;
					var percentTop = _item$data.percentTop;
	
					_this[id] = {
						percentLeft: percentLeft,
						percentTop: percentTop
					};
					_TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
					that.setState(_defineProperty({}, id, that.state[id]));
				});
			}
		}, {
			key: 'handleAnswerShow',
			value: function handleAnswerShow(data) {
				var that = this;
				if (data.className == "answer-implement-bg") {
					if (that.state.answerTeachWrapDiv == "none") {
						that.state.answerTeachWrapDiv = "block";
						that.state.resultTeachDisplay = "none";
						that.state.plusStyle = "#368bcb";
						that.state.reduceStyle = "#368bcb";
						that.clearTeacherShowData();
						that.setState({ answerTeachWrapDiv: that.state.answerTeachWrapDiv, resultTeachDisplay: that.state.resultTeachDisplay, plusStyle: that.state.plusStyle,
							reduceStyle: that.state.plusStyle });
					}
				}
			}
		}, {
			key: 'handlerMsglistAnswerShow',
	
			/*老师或者助教接收服务器端的数据*/
			value: function handlerMsglistAnswerShow(recvEventData) {
				var that = this;
				var _iteratorNormalCompletion = true;
				var _didIteratorError = false;
				var _iteratorError = undefined;
	
				try {
					for (var _iterator = recvEventData.message.answerShowArr[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
						var message = _step.value;
	
						if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol) {
							that._teacherRecevedServiceDataShow(message);
						}
					}
				} catch (err) {
					_didIteratorError = true;
					_iteratorError = err;
				} finally {
					try {
						if (!_iteratorNormalCompletion && _iterator['return']) {
							_iterator['return']();
						}
					} finally {
						if (_didIteratorError) {
							throw _iteratorError;
						}
					}
				}
			}
		}, {
			key: '_teacherRecevedServiceDataShow',
	
			/*老师或者助教接收数据*/
			value: function _teacherRecevedServiceDataShow(data) {
				var that = this;
				that.coordArr(data.data.optionalAnswers);
				that.state.crr = data.data.rightAnswers;
				that.state.init = data.data.optionalAnswers;
				that.state.dataInit = data.data.optionalAnswers;
				that.setState({
					crr: that.state.crr,
					dataInit: that.state.dataInit,
					initArr: that.state.initArr
				});
				if (data.data.isShow) {
					that.clearTeacherShowData();
					that.state.initArr = [{ id: 0, "name": "A", "sel": false }, { id: 1, "name": "B", "sel": false }, { id: 2, "name": "C", "sel": false }, { id: 3, "name": "D", "sel": false }];
					that.state.plusStyle = "#368bcb";
					that.state.reduceStyle = "#368bcb";
					that.state.answerTeachWrapDiv = "block";
					that.state.resultTeachDisplay = "none";
					that.state.publishedWarning = "none";
					that.setState({
						plusStyle: that.state.plusStyle,
						reduceStyle: that.state.plusStyle,
						answerTeachWrapDiv: that.state.answerTeachWrapDiv,
						resultTeachDisplay: that.state.resultTeachDisplay,
						initArr: that.state.initArr,
						publishedWarning: that.state.publishedWarning
					});
				} else {
					if (data.data.isRound) {
						clearInterval(that.stop);
						that.state.endQuestion = "none";
						that.state.answerTeachWrapDiv = "none";
						that.state.resultTeachDisplay = "block";
						that.state.restartQuestion = "block";
						that.state.tableArry = [];
						that.state.xiangQingText = _TkGlobal2['default'].language.languageData.answers.details.text;
						that.state.publishAnswerText = _TkGlobal2['default'].language.languageData.answers.PublishTheAnswer.text;
						that.state.resultTeachStyleDisplay = "block";
						that.state.crr = data.data.rightAnswers;
						that.state.dataInit = data.data.optionalAnswers;
						document.getElementById("result-teach-mytime").textContent = "";
						document.getElementById("result-teach-mytime").textContent = data.data.quizTimes;
						that.setState({
							tableArry: that.state.tableArry,
							publishAnswerText: that.state.publishAnswerText,
							xiangQingText: that.state.xiangQingText,
							endQuestion: that.state.endQuestion,
							restartQuestion: that.state.restartQuestion,
							crr: that.state.crr,
							dataInit: that.state.dataInit,
							answerTeachWrapDiv: that.state.answerTeachWrapDiv,
							resultTeachDisplay: that.state.resultTeachDisplay,
							resultTeachStyleDisplay: that.state.resultTeachStyleDisplay
						});
						if (data.data.isPublished) {
							that.state.publishedWarning = "none";
							that.state.publishAnswerText = _TkGlobal2['default'].language.languageData.answers.published.text;
							that.setState({
								publishAnswerText: that.state.publishAnswerText,
								publishedWarning: that.state.publishedWarning
							});
						}
						that.trueArr();
						that.coordArr(that.state.dataInit);
						that.coordArrX(that.state.dataInit);
					} else {
						clearInterval(that.stop);
						document.getElementById("result-teach-mytime").textContent = "00" + ":" + "00" + ":" + "00";
						that.time_fun();
						that.state.endQuestion = "block";
						that.state.restartQuestion = "none";
						that.state.answerTeachWrapDiv = "none";
						that.state.resultTeachDisplay = "block";
						that.state.resultTeachStyleDisplay = "none";
						that.state.columnar = "block";
						that.state.tableStyle = "none";
						that.state.publishedWarningColor = "#074496";
						that.state.dataInit = data.data.optionalAnswers;
						that.state.xiangQingText = _TkGlobal2['default'].language.languageData.answers.details.text;
						that.state.publishAnswerText = _TkGlobal2['default'].language.languageData.answers.PublishTheAnswer.text;
						that.state.afterArrayA = [];
						that.state.afterArrayB = [];
						that.state.afterArrayC = [];
						that.state.afterArrayD = [];
						that.state.afterArrayE = [];
						that.state.afterArrayF = [];
						that.state.afterArrayG = [];
						that.state.afterArrayH = [];
						that.state.afterArray = [];
						that.state.allStudentName = [];
						that.state.allStudentChosseAnswer = {};
						that.state.publishedWarning = "none";
						that.state.trueLV = 0;
						that.state.allNumbers = 0;
						that.state.idA = [];
						that.state.idB = [];
						that.state.idC = [];
						that.state.idD = [];
						that.state.idE = [];
						that.state.idF = [];
						that.state.idG = [];
						that.state.idH = [];
						that.trueArr();
						that.coordArr(that.state.dataInit);
						that.coordArrX(that.state.dataInit);
						that.setState({
							publishedWarningColor: that.state.publishedWarningColor,
							columnar: that.state.columnar,
							tableStyle: that.state.tableStyle,
							publishedWarning: that.state.publishedWarning,
							publishAnswerText: that.state.publishAnswerText,
							xiangQingText: that.state.xiangQingText,
							answerTeachWrapDiv: that.state.answerTeachWrapDiv,
							allStudentChosseAnswer: that.state.allStudentChosseAnswer,
							resultTeachDisplay: that.state.resultTeachDisplay,
							crr: that.state.crr,
							dataInit: that.state.dataInit,
							endQuestion: that.state.endQuestion,
							restartQuestion: that.state.restartQuestion,
							afterArray: that.state.afterArray,
							afterArrayA: that.state.afterArrayA,
							afterArrayB: that.state.afterArrayB,
							afterArrayC: that.state.afterArrayC,
							afterArrayD: that.state.afterArrayD,
							afterArrayE: that.state.afterArrayE,
							afterArrayF: that.state.afterArrayF,
							afterArrayG: that.state.afterArrayG,
							afterArrayH: that.state.afterArrayH,
							trueLV: that.state.trueLV,
							allNumbers: that.state.allNumbers,
							idA: that.state.idA,
							idB: that.state.idB,
							idC: that.state.idC,
							idD: that.state.idD,
							idE: that.state.idE,
							idF: that.state.idF,
							idG: that.state.idG,
							idH: that.state.idH,
							resultTeachStyleDisplay: that.state.resultTeachStyleDisplay
						});
					}
				}
			}
		}, {
			key: 'handlerRoomDelmsg',
			value: function handlerRoomDelmsg(recvEventData) {
				var that = this;
				var pubmsgData = recvEventData.message;
				switch (pubmsgData.name) {
					case "answer":
						that.state.answerTeachWrapDiv = "none";
						that.state.resultTeachDisplay = "none";
						that.state.tableObject = {};
						that.setState({ tableObject: that.state.tableObject, answerTeachWrapDiv: that.state.answerTeachWrapDiv, resultTeachDisplay: that.state.resultTeachDisplay });
						break;
					case "ClassBegin":
						that.state.answerTeachWrapDiv = "none";
						that.state.resultTeachDisplay = "none";
						that.setState({ answerTeachWrapDiv: that.state.answerTeachWrapDiv, resultTeachDisplay: that.state.resultTeachDisplay });
				}
			}
		}, {
			key: 'handlerMsglistResultStudent',
			value: function handlerMsglistResultStudent(recvEventData) {
				var that = this;
				var message = recvEventData.message.submitAnswersArr;
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol) {
					for (var item in message) {
						that._updateStudentShow(message[item]);
					}
				}
			}
		}, {
			key: 'handlerMsglistAnswerIconShow',
			value: function handlerMsglistAnswerIconShow(recvEventData) {
				this.state.answerTeachWrapDiv = "block";
				this.setState({ answerTeachWrapDiv: this.state.answerTeachWrapDiv });
			}
		}, {
			key: 'handlerRoomPlaybackClearAll',
			value: function handlerRoomPlaybackClearAll() {
				if (!_TkGlobal2['default'].playback) {
					L.Logger.error('No playback environment, no execution event[roomPlaybackClearAll] handler ');return;
				};
				var that = this;
				that.clearTeacherShowData(); //清空数据
			}
		}, {
			key: '_updateStudentShow',
			value: function _updateStudentShow(pubmsgData) {
				var that = this;
				that.state.studentNumbers.push(pubmsgData.fromID);
				var userId = pubmsgData.fromID;
				that.setState({
					studentNumbers: that.state.studentNumbers
				});
				var userSelect = pubmsgData.data.mySelect;
				var userName = pubmsgData.data.sendStudentName;
				var userName0 = userId + "0";
				var userName1 = userId + "1";
				var userName2 = userId + "2";
				that.state.tableObject[userId] = {};
				that.state.tableObject[userId][userName0] = pubmsgData.data.sendStudentName;
				that.state.tableObject[userId][userName1] = pubmsgData.data.mySelect;
				that.state.tableObject[userId][userName2] = pubmsgData.ts - pubmsgData.data.times;
				that.state.allStudentChosseAnswer[userId] = {};
				that.state.allStudentChosseAnswer[userId][userName] = userSelect;
				that.setState({
					allStudentChosseAnswer: that.state.allStudentChosseAnswer,
					tableObject: that.state.tableObject
				});
				for (var i = 0; i < that.state.studentNumbers.length; i++) {
					if (pubmsgData.fromID == that.state.studentNumbers[i]) {
						that.state.allStudentChosseAnswer[userId][userName] = userSelect;
						that.state.tableObject[userId][userName0] = pubmsgData.data.sendStudentName;
						that.state.tableObject[userId][userName1] = pubmsgData.data.mySelect;
						that.state.tableObject[userId][userName2] = pubmsgData.ts - pubmsgData.data.times;
						that.setState({
							allStudentChosseAnswer: that.state.allStudentChosseAnswer,
							tableObject: that.state.tableObject
						});
					}
				}
				var newCrr = Array.from(new Set(that.state.studentNumbers));
				that.state.allNumbers = newCrr.length;
				that.state.idA = [];
				that.state.idB = [];
				that.state.idC = [];
				that.state.idD = [];
				that.state.idE = [];
				that.state.idF = [];
				that.state.idG = [];
				that.state.idH = [];
				that.state.afterArrayA = [];
				that.state.afterArrayB = [];
				that.state.afterArrayC = [];
				that.state.afterArrayD = [];
				that.state.afterArrayE = [];
				that.state.afterArrayF = [];
				that.state.afterArrayG = [];
				that.state.afterArrayH = [];
				that.state.trueNum = 0;
				that.setState({ afterArrayA: that.state.afterArrayA, afterArrayB: that.state.afterArrayB, afterArrayC: that.state.afterArrayC, afterArrayD: that.state.afterArrayD, afterArrayE: that.state.afterArrayE,
					afterArrayF: that.state.afterArrayF, afterArrayG: that.state.afterArrayG, afterArrayH: that.state.afterArrayH });
				var liLength = pubmsgData.data.mySelect.length;
				for (var a in that.state.allStudentChosseAnswer) {
					var _loop = function (names) {
						var namesValue = names;
						that.state.allStudentChosseAnswer[a][namesValue].map(function (item, index) {
							if (item == "A") {
								that.state.idA.push(namesValue);
								that.state.afterArrayA = [];
								that.setState({
									afterArray: that.state.afterArray
								});
								var A = _react2['default'].createElement(
									'div',
									{ className: 'answer-stu-lis', key: index, style: { height: that.state.idA.length < 13 ? that.state.idA.length / 10 + "rem" : 1.2 + "rem" } },
									_react2['default'].createElement(
										'p',
										null,
										that.state.idA.length
									)
								);
								that.state.afterArrayA.push(A);
								that.setState({
									afterArrayA: that.state.afterArrayA,
									idA: that.state.idA
								});
							}
							if (item == "B") {
								that.state.idB.push(namesValue);
								that.state.afterArrayB = [];
								that.setState({
									afterArray: that.state.afterArray
								});
								var B = _react2['default'].createElement(
									'div',
									{ className: 'answer-stu-lis', key: index, style: { height: that.state.idB.length < 13 ? that.state.idB.length / 10 + "rem" : 1.2 + "rem" } },
									_react2['default'].createElement(
										'p',
										null,
										that.state.idB.length
									)
								);
								that.state.afterArrayB.push(B);
								that.setState({
									afterArrayB: that.state.afterArrayB,
									idB: that.state.idB
								});
							}
							if (item == "C") {
								that.state.idC.push(namesValue);
								that.state.afterArrayC = [];
								that.setState({
									afterArray: that.state.afterArray
								});
								var C = _react2['default'].createElement(
									'div',
									{ className: 'answer-stu-lis', key: index, style: { height: that.state.idC.length < 13 ? that.state.idC.length / 10 + "rem" : 1.2 + "rem" } },
									_react2['default'].createElement(
										'p',
										null,
										that.state.idC.length
									)
								);
								that.state.afterArrayC.push(C);
								that.setState({
									afterArrayC: that.state.afterArrayC,
									idC: that.state.idC
								});
							}
							if (item == "D") {
								that.state.idD.push(namesValue);
								that.state.afterArrayD = [];
								var D = _react2['default'].createElement(
									'div',
									{ className: 'answer-stu-lis', key: index, style: { height: that.state.idD.length < 13 ? that.state.idD.length / 10 + "rem" : 1.2 + "rem" } },
									_react2['default'].createElement(
										'p',
										null,
										that.state.idD.length
									)
								);
								that.state.afterArrayD.push(D);
								that.setState({
									afterArrayD: that.state.afterArrayD,
									idD: that.state.idD
								});
							}
							if (item == "E") {
								that.state.idE.push(namesValue);
								that.state.afterArrayE = [];
								var E = _react2['default'].createElement(
									'div',
									{ className: 'answer-stu-lis', key: index, style: { height: that.state.idE.length < 13 ? that.state.idE.length / 10 + "rem" : 1.2 + "rem" } },
									_react2['default'].createElement(
										'p',
										null,
										that.state.idE.length
									)
								);
								that.state.afterArrayE.push(E);
								that.setState({
									afterArrayE: that.state.afterArrayE,
									idE: that.state.idE
								});
							}
							if (item == "F") {
								that.state.idF.push(namesValue);
								that.state.afterArrayF = [];
								var F = _react2['default'].createElement(
									'div',
									{ className: 'answer-stu-lis', key: index, style: { height: that.state.idF.length < 13 ? that.state.idF.length / 10 + "rem" : 1.2 + "rem" } },
									_react2['default'].createElement(
										'p',
										null,
										that.state.idF.length
									)
								);
								that.state.afterArrayF.push(F);
								that.setState({
									afterArrayF: that.state.afterArrayF,
									idF: that.state.idF
								});
							}
							if (item == "G") {
								that.state.idG.push(namesValue);
								that.state.afterArrayG = [];
								var G = _react2['default'].createElement(
									'div',
									{ className: 'answer-stu-lis', key: index, style: { height: that.state.idG.length < 13 ? that.state.idG.length / 10 + "rem" : 1.2 + "rem" } },
									_react2['default'].createElement(
										'p',
										null,
										that.state.idG.length
									)
								);
								that.state.afterArrayG.push(G);
								that.setState({
									afterArrayG: that.state.afterArrayG,
									idG: that.state.idG
								});
							}
							if (item == "H") {
								that.state.idH.push(namesValue);
								that.state.afterArrayH = [];
								var H = _react2['default'].createElement(
									'div',
									{ className: 'answer-stu-lis', key: index, style: { height: that.state.idH.length < 13 ? that.state.idH.length / 10 + "rem" : 1.2 + "rem" } },
									_react2['default'].createElement(
										'p',
										null,
										that.state.idH.length
									)
								);
								that.state.afterArrayH.push(H);
								that.setState({
									afterArrayH: that.state.afterArrayH,
									idH: that.state.idH
								});
							}
						});
						var XArry = pubmsgData.data.optionalAnswers;
						that.coordArr(XArry);
						that.coordArrX(XArry);
						var newCrrs = Array.from(new Set(that.state.crr));
						newCrrs = newCrrs.sort();
						if (that.state.allStudentChosseAnswer[a][namesValue].sort().toString() == newCrrs.toString()) {
							that.state.trueNum++;
							that.setState({
								trueNum: that.state.trueNum
							});
							that.state.trueLV = that.state.trueNum / that.state.allNumbers * 100;
							that.state.trueLV = that.state.trueLV.toFixed(0);
							that.setState({
								trueLV: that.state.trueLV
							});
						} else {
							var _newCrr = Array.from(new Set(that.state.studentNumbers));
							that.state.trueLV = that.state.trueNum / that.state.allNumbers * 100;
							that.state.trueLV = that.state.trueLV.toFixed(0);
							that.setState({
								trueLV: that.state.trueLV
							});
						}
					};
	
					for (var names in that.state.allStudentChosseAnswer[a]) {
						_loop(names);
					}
				}
			}
		}, {
			key: '_loadTableDescArray',
	
			/*表格数据*/
			value: function _loadTableDescArray(tableObject) {
				var afterArry = [];
				var newCrr = Array.from(new Set(this.state.crr));
				newCrr = newCrr.sort();
				for (var item in tableObject) {
					var item0 = item + "0";
					var item1 = item + "1";
					var item2 = item + "2";
					var trueResult = tableObject[item][item1].toString() == newCrr.toString();
					var m = parseInt(tableObject[item][item2] / 60) < 10 ? '0' + parseInt(tableObject[item][item2] / 60) : parseInt(tableObject[item][item2] / 60);
					var n = parseInt(tableObject[item][item2] % 60) < 10 ? '0' + parseInt(tableObject[item][item2] % 60) : parseInt(tableObject[item][item2] % 60);
					var student = _react2['default'].createElement(
						'tr',
						{ key: item },
						_react2['default'].createElement(
							'td',
							null,
							tableObject[item][item0]
						),
						_react2['default'].createElement(
							'td',
							{ className: trueResult ? 'table-true-result' : 'table-false-result' },
							tableObject[item][item1]
						),
						_react2['default'].createElement(
							'td',
							null,
							m,
							':',
							n
						)
					);
					afterArry.push(student);
				}
				return {
					afterArry: afterArry
				};
			}
		}, {
			key: '_loadTimeDescArray',
			value: function _loadTimeDescArray(desc) {
				var _this2 = this;
	
				var beforeArray = [];
				desc.map(function (item, index) {
					var a = _react2['default'].createElement(
						'li',
						{ className: 'answer-teach-lis', key: item.id, style: { background: _this2.state.initArr[index].sel ? "#2196f3" : null }, onTouchStart: _this2.changeColor.bind(_this2, index) },
						item.name
					);
					beforeArray.push(a);
				});
				return {
					beforeArray: beforeArray
				};
			}
		}, {
			key: 'addHandel',
	
			/*增加*/
			value: function addHandel(e) {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					var initLength = this.state.initArr.length;
					if (initLength >= 2) {
						this.state.plusStyle = "#368bcb";
						this.state.reduceStyle = "#368bcb";
						this.setState({
							plusStyle: this.state.plusStyle,
							reduceStyle: this.state.reduceStyle
						});
					}
					if (initLength > 7) {
						this.state.plusStyle = "#202C4A";
						this.setState({
							plusStyle: this.state.plusStyle
						});
						return false;
					}
					if (initLength == 7) {
						this.state.plusStyle = "#202C4A";
						this.setState({
							plusStyle: this.state.plusStyle
						});
					}
					this.liArr[initLength].sel = false;
					this.state.initArr.push(this.liArr[initLength]);
					this.setState({
						optionUl: this.state.optionUl,
						initArr: this.state.initArr
					});
				}
			}
		}, {
			key: 'reduceHandel',
	
			/* 减少 */
			value: function reduceHandel(e) {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					var initLength = this.state.initArr.length;
					if (initLength >= 2) {
						this.state.plusStyle = "#368bcb";
						this.setState({
							plusStyle: this.state.plusStyle
						});
					}
					if (initLength >= 3) {
	
						this.state.initArr.pop();
						this.state.reduceStyle = "#368bcb";
						this.setState({
							reduceStyle: this.state.reduceStyle,
							plusStyle: this.state.plusStyle
						});
					}
					if (initLength == 3) {
						this.state.reduceStyle = "#202C4A";
						this.setState({
							reduceStyle: this.state.reduceStyle
						});
					}
					for (var i = 0; i < this.state.initArr.length; i++) {
						if (this.state.initArr[i].sel == false) {
							this.state.beginStyle = "";
							this.setState({
								beginStyle: this.state.beginStyle
							});
						}
						if (this.state.initArr[i].sel) {
							this.state.beginStyle = "#2196f3";
							this.setState({
								beginStyle: this.state.beginStyle
							});
						}
					}
					this.setState({
						initArr: this.state.initArr
					});
				}
			}
		}, {
			key: 'changeColor',
	
			// 改变颜色
			value: function changeColor(index, e) {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					this.state.crr = [];
					this.state.initArr[index].sel = !this.state.initArr[index].sel;
					this.setState({
						initArr: this.state.initArr,
						crr: this.state.crr
					});
					if (this.state.initArr[index].sel == false) {
						this.state.beginStyle = "";
						this.setState({
							beginStyle: this.state.beginStyle
						});
					}
					var _iteratorNormalCompletion2 = true;
					var _didIteratorError2 = false;
					var _iteratorError2 = undefined;
	
					try {
						for (var _iterator2 = this.state.initArr[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
							var value = _step2.value;
	
							if (value.sel) {
								this.state.beginStyle = "#2196f3";
								this.setState({
									beginStyle: this.state.beginStyle
								});
							}
						}
					} catch (err) {
						_didIteratorError2 = true;
						_iteratorError2 = err;
					} finally {
						try {
							if (!_iteratorNormalCompletion2 && _iterator2['return']) {
								_iterator2['return']();
							}
						} finally {
							if (_didIteratorError2) {
								throw _iteratorError2;
							}
						}
					}
				}
			}
		}, {
			key: 'beginAnswer',
	
			/*开始答题*/
			value: function beginAnswer(e) {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					var initLength = this.state.initArr.length;
					for (var i = 0; i < this.state.initArr.length; i++) {
						if (this.state.initArr[i].sel) {
							this.state.crr.push(this.state.initArr[i].name);
							this.state.crr = Array.from(new Set(this.state.crr));
							this.setState({
								crr: this.state.crr
							});
						}
					}
					if (e.target.style.background == "") {
						return false;
					};
					this.state.afterArrayA = [];
					this.state.afterArrayB = [];
					this.state.afterArrayC = [];
					this.state.afterArrayD = [];
					this.state.afterArrayE = [];
					this.state.afterArrayF = [];
					this.state.afterArrayG = [];
					this.state.afterArrayH = [];
					this.state.answerTeachWrapDiv = "none";
					this.state.resultTeachDisplay = "block";
					this.state.resultTeachStyleDisplay = "none";
					this.state.endQuestion = "block";
					this.state.restartQuestion = "none";
					this.state.columnar = "block";
					this.state.tableStyle = "none";
					this.state.publishedWarningColor = "#074496";
					this.state.publishAnswerText = _TkGlobal2['default'].language.languageData.answers.PublishTheAnswer.text;
					this.state.xiangQingText = _TkGlobal2['default'].language.languageData.answers.details.text;
					this.state.isPublished = false;
					this.state.publishedWarning = "none";
					this.setState({
						publishedWarningColor: this.state.publishedWarningColor,
						columnar: this.state.columnar,
						tableStyle: this.state.tableStyle,
						publishedWarning: this.state.publishedWarning,
						isPublished: this.state.isPublished,
						xiangQingText: this.state.xiangQingText,
						publishAnswerText: this.state.publishAnswerText,
						answerTeachWrapDiv: this.state.answerTeachWrapDiv,
						resultTeachDisplay: this.state.resultTeachDisplay,
						resultTeachStyleDisplay: this.state.resultTeachStyleDisplay,
						endQuestion: this.state.endQuestion,
						restartQuestion: this.state.restartQuestion,
						afterArray: this.state.afterArray,
						afterArrayA: this.state.afterArrayA,
						afterArrayB: this.state.afterArrayB,
						afterArrayC: this.state.afterArrayC,
						afterArrayD: this.state.afterArrayD,
						afterArrayE: this.state.afterArrayE,
						afterArrayF: this.state.afterArrayF,
						afterArrayG: this.state.afterArrayG,
						afterArrayH: this.state.afterArrayH,
						trueLV: this.state.trueLV,
						allNumbers: this.state.allNumbers,
						idA: this.state.idA,
						idB: this.state.idB,
						idC: this.state.idC,
						idD: this.state.idD,
						idE: this.state.idE,
						idF: this.state.idF,
						idG: this.state.idG,
						idH: this.state.idH
					});
					clearInterval(this.stop);
					document.getElementById("result-teach-mytime").textContent = "00" + ":" + "00" + ":" + "00";
					this.trueArr();
					this.time_fun();
					var _iteratorNormalCompletion3 = true;
					var _didIteratorError3 = false;
					var _iteratorError3 = undefined;
	
					try {
						for (var _iterator3 = this.state.initArr[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
							var value = _step3.value;
	
							value.sel = false;
							this.setState({
								initArr: this.state.initArr
							});
						}
					} catch (err) {
						_didIteratorError3 = true;
						_iteratorError3 = err;
					} finally {
						try {
							if (!_iteratorNormalCompletion3 && _iterator3['return']) {
								_iterator3['return']();
							}
						} finally {
							if (_didIteratorError3) {
								throw _iteratorError3;
							}
						}
					}
	
					this.state.isShow = false;
					this.setState({
						isShow: this.state.isShow
					});
					var iconShow = this.state.isShow;
					var rounds = this.state.round;
					var optionalAnswer = this.state.initArr;
					var studentSels = this.state.brr;
					var trueLV = this.state.trueLV;
					var allNumbers = this.state.allNumbers;
					var dataChoose = this.state.allStudentChosseAnswer;
					var dataTable = this.state.tableObject;
					var idAS = this.state.idA;
					var idBS = this.state.idB;
					var idCS = this.state.idC;
					var idDS = this.state.idD;
					var idES = this.state.idE;
					var idFS = this.state.idF;
					var idGS = this.state.idG;
					var idHS = this.state.idH;
					var isPublished = this.state.isPublished;
					var quizTime = document.getElementById("result-teach-mytime").textContent;
					var newCrr = Array.from(new Set(this.state.crr));
					newCrr = newCrr.sort();
					var data = {
						optionalAnswers: optionalAnswer,
						quizTimes: quizTime,
						rightAnswers: newCrr,
						isRound: rounds,
						studentSelect: studentSels,
						trueLV: trueLV,
						allNumbers: allNumbers,
						dataChoose: dataChoose,
						dataTable: dataTable,
						isPublished: isPublished,
						idAS: idAS,
						idBS: idBS,
						idCS: idCS,
						idDS: idDS,
						idES: idES,
						idFS: idFS,
						idGS: idGS,
						idHS: idHS,
						isShow: iconShow
					};
					_ServiceSignalling2['default'].sendSignallingAnswerToStudent(data);
					this.coordArr(this.state.initArr);
					this.coordArrX(this.state.initArr);
				}
			}
		}, {
			key: 'coordArrX',
	
			//坐标X轴值
			value: function coordArrX(arrX) {
				this.state.allResultX = arrX.map(function (value, index) {
					return _react2['default'].createElement(
						'li',
						{ key: index, style: { width: 1 / arrX.length * 100 - 5 + "%" } },
						value.name
					);
				});
				this.setState({
					allResultX: this.state.allResultX
				});
			}
		}, {
			key: 'coordArr',
			value: function coordArr(arrX) {
				var _this3 = this;
	
				this.state.allResult = arrX.map(function (value, index) {
					if (value.name == "A") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this3.state.afterArrayA
						);
					}
					if (value.name == "B") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this3.state.afterArrayB
						);
					}
					if (value.name == "C") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this3.state.afterArrayC
						);
					}
					if (value.name == "D") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this3.state.afterArrayD
						);
					}
					if (value.name == "E") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this3.state.afterArrayE
						);
					}
					if (value.name == "F") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this3.state.afterArrayF
						);
					}
					if (value.name == "G") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this3.state.afterArrayG
						);
					}
					if (value.name == "H") {
						return _react2['default'].createElement(
							'li',
							{ key: index, style: { width: 7.5 + "%", left: 0.5 + "%" } },
							_this3.state.afterArrayH
						);
					}
				});
				this.setState({
					allResult: this.state.allResult
				});
			}
		}, {
			key: 'trueArr',
	
			//正确答案
			value: function trueArr() {
				var newCrr = Array.from(new Set(this.state.crr));
				newCrr = newCrr.sort();
				this.state.trueSelect = newCrr.map(function (value, index) {
					return _react2['default'].createElement(
						'span',
						{ className: 'spans', key: index },
						value
					);
				});
				this.setState({
					trueSelect: this.state.trueSelect
				});
			}
		}, {
			key: 'two_char',
	
			//计时器
			value: function two_char(n) {
				return n >= 10 ? n : "0" + n;
			}
		}, {
			key: 'time_fun',
			value: function time_fun() {
				var sec = 0;
				var that = this;
				that.stop = setInterval(function () {
					sec++;
					var date = new Date(0, 0);
					date.setSeconds(sec);
					var h = date.getHours(),
					    m = date.getMinutes(),
					    s = date.getSeconds();
					document.getElementById("result-teach-mytime").textContent = that.two_char(h) + ":" + that.two_char(m) + ":" + that.two_char(s);
				}, 1000);
				that.setState({
					stop: that.state.stop
				});
			}
		}, {
			key: 'endHandel',
	
			//结束答题
			value: function endHandel() {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					clearInterval(this.stop);
					this.state.endQuestion = "none";
					this.state.restartQuestion = "block";
					this.state.resultTeachStyleDisplay = "block";
					this.state.round = true;
					this.state.isPublished = false;
					this.setState({
						endQuestion: this.state.endQuestion,
						restartQuestion: this.state.restartQuestion,
						round: this.state.round,
						resultTeachStyleDisplay: this.state.resultTeachStyleDisplay,
						isPublished: this.state.isPublished
					});
					this.state.isShow = false;
					this.setState({
						isShow: this.state.isShow
					});
					var iconShow = this.state.isShow;
					var quizTime = document.getElementById("result-teach-mytime").textContent;
					var optionalAnswer = this.state.initArr;
					var newCrr = Array.from(new Set(this.state.crr));
					var teacherTrueSelect = newCrr.sort();
					var studentSels = this.state.brr;
					var trueLV = this.state.trueLV;
					var rounds = this.state.round;
					var allNumbers = this.state.allNumbers;
					var dataChoose = this.state.allStudentChosseAnswer;
					var dataTable = this.state.tableObject;
					var isPublished = this.state.isPublished;
					var idAS = this.state.idA;
					var idBS = this.state.idB;
					var idCS = this.state.idC;
					var idDS = this.state.idD;
					var idES = this.state.idE;
					var idFS = this.state.idF;
					var idGS = this.state.idG;
					var idHS = this.state.idH;
					var data = {
						optionalAnswers: optionalAnswer,
						quizTimes: quizTime,
						rightAnswers: teacherTrueSelect,
						isRound: rounds,
						studentSelect: studentSels,
						trueLV: trueLV,
						allNumbers: allNumbers,
						dataChoose: dataChoose,
						dataTable: dataTable,
						isPublished: isPublished,
						idAS: idAS,
						idBS: idBS,
						idCS: idCS,
						idDS: idDS,
						idES: idES,
						idFS: idFS,
						idGS: idGS,
						idHS: idHS,
						isShow: iconShow
					};
					_ServiceSignalling2['default'].sendSignallingAnswerToStudent(data);
					this.state.isPublished = true;
					this.setState({
						isPublished: this.state.isPublished
					});
				}
			}
	
			//重新开始
		}, {
			key: 'restartHandel',
			value: function restartHandel() {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					this.clearTeacherShowData();
					clearInterval(this.stop);
					document.getElementById("result-teach-mytime").textContent = "00" + ":" + "00" + ":" + "00";
					this.state.initArr = [{
						id: 0,
						"name": "A",
						"sel": false
					}, {
						id: 1,
						"name": "B",
						"sel": false
					}, {
						id: 2,
						"name": "C",
						"sel": false
					}, {
						id: 3,
						"name": "D",
						"sel": false
					}];
					this.state.answerTeachWrapDiv = "block";
					this.state.allStudentName = [];
					this.state.tableArry = [];
					this.state.allStudentChosseAnswer = {};
					this.state.round = false;
					this.state.crr = [];
					this.state.brr = [];
					this.state.trueLV = 0;
					this.state.allNumbers = 0;
					this.state.studentNumbers = [];
					this.state.tableObject = {};
					this.state.isPublished = false;
					this.state.publishAnswerText = "";
					this.state.allResult = "";
					this.setState({
						allResult: this.state.allResult,
						publishAnswerText: this.state.publishAnswerText,
						tableObject: this.state.tableObject,
						tableArry: this.state.tableArry,
						allStudentChosseAnswer: this.state.allStudentChosseAnswer,
						studentNumbers: this.state.studentNumbers,
						brr: this.state.brr,
						crr: this.state.crr,
						trueLV: this.state.trueLV,
						allNumbers: this.state.allNumbers,
						answerTeachWrapDiv: this.state.answerTeachWrapDiv,
						allStudentName: this.state.allStudentName,
						round: this.state.round,
						initArr: this.state.initArr,
						isPublished: this.state.isPublished
					});
					this.state.isShow = true;
					this.setState({
						isShow: this.state.isShow
					});
					var iconShow = this.state.isShow;
					var quizTime = document.getElementById("result-teach-mytime").textContent;
					var optionalAnswer = this.state.initArr;
					var newCrr = Array.from(new Set(this.state.crr));
					var teacherTrueSelect = newCrr.sort();
					var studentSels = this.state.brr;
					var trueLV = this.state.trueLV;
					var rounds = this.state.round;
					var allNumbers = this.state.allNumbers;
					var dataChoose = this.state.allStudentChosseAnswer;
					var dataTable = this.state.tableObject;
					var isPublished = this.state.isPublished;
					var idAS = this.state.idA;
					var idBS = this.state.idB;
					var idCS = this.state.idC;
					var idDS = this.state.idD;
					var idES = this.state.idE;
					var idFS = this.state.idF;
					var idGS = this.state.idG;
					var idHS = this.state.idH;
					var data = {
						optionalAnswers: optionalAnswer,
						quizTimes: quizTime,
						rightAnswers: teacherTrueSelect,
						isRound: rounds,
						studentSelect: studentSels,
						trueLV: trueLV,
						allNumbers: allNumbers,
						dataChoose: dataChoose,
						dataTable: dataTable,
						isPublished: isPublished,
						idAS: idAS,
						idBS: idBS,
						idCS: idCS,
						idDS: idDS,
						idES: idES,
						idFS: idFS,
						idGS: idGS,
						idHS: idHS,
						isShow: iconShow
					};
					var isDelMsg = true;
					_ServiceSignalling2['default'].sendSignallingAnswerToStudent(data, isDelMsg);
					isDelMsg = false;
					_ServiceSignalling2['default'].sendSignallingAnswerToStudent(data, isDelMsg);
				}
			}
		}, {
			key: 'publishAnswerHandel',
	
			/*公布答案*/
			value: function publishAnswerHandel(e) {
				if (this.state.isPublished == false) {
					this.state.publishedWarning = "block";
					this.setState({
						publishedWarning: this.state.publishedWarning
					});
					return false;
				}
				e.target.textContent = _TkGlobal2['default'].language.languageData.answers.published.text;
				this.state.publishedWarningColor = "#3C75BB";
				this.state.publishedWarning = "none";
				this.setState({
					publishAnswerText: this.state.publishAnswerText,
					publishedWarning: this.state.publishedWarning,
					publishedWarningColor: this.state.publishedWarningColor
				});
				var iconShow = this.state.isShow;
				var quizTime = document.getElementById("result-teach-mytime").textContent;
				var optionalAnswer = this.state.initArr;
				var newCrr = Array.from(new Set(this.state.crr));
				var teacherTrueSelect = newCrr.sort();
				var studentSels = this.state.brr;
				var trueLV = this.state.trueLV;
				var rounds = this.state.round;
				var allNumbers = this.state.allNumbers;
				var dataChoose = this.state.allStudentChosseAnswer;
				var dataTable = this.state.tableObject;
				var isPublished = this.state.isPublished;
				var idAS = this.state.idA;
				var idBS = this.state.idB;
				var idCS = this.state.idC;
				var idDS = this.state.idD;
				var idES = this.state.idE;
				var idFS = this.state.idF;
				var idGS = this.state.idG;
				var idHS = this.state.idH;
				var data = {
					optionalAnswers: optionalAnswer,
					quizTimes: quizTime,
					rightAnswers: teacherTrueSelect,
					isRound: rounds,
					studentSelect: studentSels,
					trueLV: trueLV,
					allNumbers: allNumbers,
					dataChoose: dataChoose,
					dataTable: dataTable,
					isPublished: isPublished,
					idAS: idAS,
					idBS: idBS,
					idCS: idCS,
					idDS: idDS,
					idES: idES,
					idFS: idFS,
					idGS: idGS,
					idHS: idHS,
					isShow: iconShow
				};
				_ServiceSignalling2['default'].sendSignallingAnswerToStudent(data); //是否公布答案
			}
		}, {
			key: 'xiangQingHandel',
	
			/*图表和柱状图切换*/
			value: function xiangQingHandel() {
				this.state.isXiangQing = !this.state.isXiangQing;
				this.state.publishedWarning = "none";
				this.setState({
					isXiangQing: this.state.isXiangQing,
					publishedWarning: this.state.publishedWarning
				});
				if (this.state.isXiangQing) {
					this.state.columnar = "none";
					this.state.tableStyle = "block";
					this.state.xiangQingText = _TkGlobal2['default'].language.languageData.answers.statistics.text;
					this.setState({
						columnar: this.state.columnar,
						tableStyle: this.state.tableStyle,
						xiangQingText: this.state.xiangQingText
					});
				} else {
					this.state.columnar = "block";
					this.state.tableStyle = "none";
					this.state.xiangQingText = _TkGlobal2['default'].language.languageData.answers.details.text;
					this.setState({
						columnar: this.state.columnar,
						tableStyle: this.state.tableStyle,
						xiangQingText: this.state.xiangQingText
					});
				}
			}
		}, {
			key: 'clearTeacherShowData',
	
			/*清空数据*/
			value: function clearTeacherShowData() {
				var _iteratorNormalCompletion4 = true;
				var _didIteratorError4 = false;
				var _iteratorError4 = undefined;
	
				try {
					for (var _iterator4 = this.state.initArr[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
						var value = _step4.value;
	
						value.sel = false;
						this.setState({ initArr: this.state.initArr });
					}
				} catch (err) {
					_didIteratorError4 = true;
					_iteratorError4 = err;
				} finally {
					try {
						if (!_iteratorNormalCompletion4 && _iterator4['return']) {
							_iterator4['return']();
						}
					} finally {
						if (_didIteratorError4) {
							throw _iteratorError4;
						}
					}
				}
	
				;
				clearInterval(this.stop);
				this.state.trueNum = 0;
				this.state.brr = [];
				this.state.crr = [];
				this.state.afterArrayA = [];
				this.state.afterArrayB = [];
				this.state.afterArrayC = [];
				this.state.afterArrayD = [];
				this.state.afterArrayE = [];
				this.state.afterArrayF = [];
				this.state.afterArrayG = [];
				this.state.afterArrayH = [];
				this.state.afterArray = [];
				this.state.studentNumbers = [];
				this.state.allStudentName = [];
				this.state.tableObject = {};
				this.state.trueLV = 0;
				this.state.allNumbers = 0;
				this.state.idA = [];
				this.state.idB = [];
				this.state.idC = [];
				this.state.idD = [];
				this.state.idE = [];
				this.state.idF = [];
				this.state.idG = [];
				this.state.idH = [];
				this.state.tableArry = [];
				this.state.initArr = [{
					id: 0,
					"name": "A",
					"sel": false
				}, {
					id: 1,
					"name": "B",
					"sel": false
				}, {
					id: 2,
					"name": "C",
					"sel": false
				}, {
					id: 3,
					"name": "D",
					"sel": false
				}];
				document.getElementById("result-teach-mytime").textContent = "00" + ":" + "00" + ":" + "00";
				this.state.endQuestion = "block";
				this.state.restartQuestion = "none";
				this.state.beginStyle = "";
				this.state.resultTeachDisplay = "none";
				this.state.plusStyle = "#368bcb";
				this.state.reduceStyle = "#368bcb";
				this.state.publishedWarning = "none";
				this.setState({
					publishedWarning: this.state.publishedWarning,
					tableObject: this.state.tableObject,
					tableArry: this.state.tableArry,
					endQuestion: this.state.endQuestion,
					studentNumbers: this.state.studentNumbers,
					restartQuestion: this.state.restartQuestion,
					answerTeachWrapDiv: this.state.answerTeachWrapDiv,
					resultTeachDisplay: this.state.resultTeachDisplay,
					beginStyle: this.state.beginStyle,
					brr: this.state.brr,
					crr: this.state.crr,
					initArr: this.state.initArr,
					afterArray: this.state.afterArray,
					afterArrayA: this.state.afterArrayA,
					afterArrayB: this.state.afterArrayB,
					afterArrayC: this.state.afterArrayC,
					afterArrayD: this.state.afterArrayD,
					afterArrayE: this.state.afterArrayE,
					afterArrayF: this.state.afterArrayF,
					afterArrayG: this.state.afterArrayG,
					afterArrayH: this.state.afterArrayH,
					trueLV: this.state.trueLV,
					allNumbers: this.state.allNumbers,
					idA: this.state.idA,
					idB: this.state.idB,
					idC: this.state.idC,
					idD: this.state.idD,
					idE: this.state.idE,
					idF: this.state.idF,
					idG: this.state.idG,
					idH: this.state.idH,
					trueNum: this.state.trueNum,
					plusStyle: this.state.plusStyle,
					reduceStyle: this.state.plusStyle
				});
			}
	
			/*选择答案界面关闭*/
		}, {
			key: 'answerTeachCloseHandel',
			value: function answerTeachCloseHandel() {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					this.state.answerTeachWrapDiv = "none";
					this.clearTeacherShowData();
					var _iteratorNormalCompletion5 = true;
					var _didIteratorError5 = false;
					var _iteratorError5 = undefined;
	
					try {
						for (var _iterator5 = this.state.initArr[Symbol.iterator](), _step5; !(_iteratorNormalCompletion5 = (_step5 = _iterator5.next()).done); _iteratorNormalCompletion5 = true) {
							var value = _step5.value;
	
							value.sel = false;
							this.setState({
								initArr: this.state.initArr
							});
						}
					} catch (err) {
						_didIteratorError5 = true;
						_iteratorError5 = err;
					} finally {
						try {
							if (!_iteratorNormalCompletion5 && _iterator5['return']) {
								_iterator5['return']();
							}
						} finally {
							if (_didIteratorError5) {
								throw _iteratorError5;
							}
						}
					}
	
					clearInterval(this.stop);
					this.state.allStudentChosseAnswer = {};
					this.state.tableObject = {};
					this.state.tableArry = [];
					document.getElementById("result-teach-mytime").textContent = "00" + ":" + "00" + ":" + "00";
					this.state.round = false;
					this.state.plusStyle = "#368bcb";
					this.state.reduceStyle = "#368bcb";
					this.state.endQuestion = "block";
					this.state.restartQuestion = "none";
					this.state.crr = [];
					this.state.trueSelect = "";
					this.state.beginStyle = "";
					this.state.trueLV = 0;
					this.state.allNumbers = 0;
					this.state.initArr = [{
						id: 0,
						"name": "A",
						"sel": false
					}, {
						id: 1,
						"name": "B",
						"sel": false
					}, {
						id: 2,
						"name": "C",
						"sel": false
					}, {
						id: 3,
						"name": "D",
						"sel": false
					}];
					this.state.isPublished = false;
					this.state.publishAnswerText = _TkGlobal2['default'].language.languageData.answers.PublishTheAnswer.text;
					this.state.publishedWarning = "none";
					this.setState({
						publishedWarning: this.state.publishedWarning,
						publishAnswerText: this.state.publishAnswerText,
						isPublished: this.state.isPublished,
						tableObject: this.state.tableObject,
						tableArry: this.state.tableArry,
						allStudentChosseAnswer: this.state.allStudentChosseAnswer,
						answerTeachWrapDiv: this.state.answerTeachWrapDiv,
						initArr: this.state.initArr,
						beginStyle: this.state.beginStyle,
						plusStyle: this.state.plusStyle,
						trueLV: this.state.trueLV,
						allNumbers: this.state.allNumbers,
						reduceStyle: this.state.plusStyle,
						crr: this.state.crr,
						trueSelect: this.state.trueSelect,
						endQuestion: this.state.endQuestion,
						restartQuestion: this.state.restartQuestion,
						round: this.state.round
					});
					var data = {
						answerClose: 'none'
					};
					var isDelMsg = true;
					_ServiceSignalling2['default'].sendSignallingAnswerToStudent(data, isDelMsg);
					//初始化拖拽元素的位置
					var id = this.props.id;
	
					this.state[id].left = 0;
					this.state[id].top = 0;
					this.setState(_defineProperty({}, id, this.state[id]));
				}
			}
		}, {
			key: 'resultTeachCloseHandel',
	
			/*结果界面关闭*/
			value: function resultTeachCloseHandel() {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					this.clearTeacherShowData();
					clearInterval(this.stop);
					this.state.round = false;
					this.state.allStudentChosseAnswer = {};
					this.state.tableObject = {};
					this.state.tableArry = [];
					this.state.isPublished = false;
					document.getElementById("result-teach-mytime").textContent = "00" + ":" + "00" + ":" + "00";
					this.state.plusStyle = "#368bcb";
					this.state.reduceStyle = "#368bcb";
					this.state.resultTeachDisplay = "none";
					this.state.endQuestion = "block";
					this.state.restartQuestion = "none";
					this.state.crr = [];
					this.state.trueSelect = "";
					this.state.trueLV = 0;
					this.state.allNumbers = 0;
					this.state.publishAnswerText = _TkGlobal2['default'].language.languageData.answers.PublishTheAnswer.text;
					this.state.publishedWarning = "none";
					this.setState({
						publishedWarning: this.state.publishedWarning,
						isPublished: this.state.isPublished,
						publishAnswerText: this.state.publishAnswerText,
						tableObject: this.state.tableObject,
						tableArry: this.state.tableArry,
						allStudentChosseAnswer: this.state.allStudentChosseAnswer,
						resultTeachDisplay: this.state.resultTeachDisplay,
						plusStyle: this.state.plusStyle,
						round: this.state.round,
						trueLV: this.state.trueLV,
						allNumbers: this.state.allNumbers,
						reduceStyle: this.state.plusStyle,
						crr: this.state.crr,
						trueSelect: this.state.trueSelect,
						endQuestion: this.state.endQuestion,
						restartQuestion: this.state.restartQuestion
					});
					var data = {
						answerClose: 'none'
					};
					var isDelMsg = true;
					_ServiceSignalling2['default'].sendSignallingAnswerToStudent(data, isDelMsg);
					//初始化拖拽元素的位置
					var id = this.props.id;
	
					this.state[id].left = 0;
					this.state[id].top = 0;
					this.setState(_defineProperty({}, id, this.state[id]));
				}
			}
		}, {
			key: 'handlerOnStartDrag',
			value: function handlerOnStartDrag(e, dragData) {
				//开始拖拽
				var that = this;
				var id = that.props.id;
	
				var defalutFontSize = window.innerWidth / _TkConstant2['default'].STANDARDSIZE;
				that.state[id].offsetX = dragData.x / defalutFontSize - that.state[id].left;
				that.state[id].offsetY = dragData.y / defalutFontSize - that.state[id].top;
			}
		}, {
			key: 'handlerOnDragging',
			value: function handlerOnDragging(e, dragData) {
				//拖拽中
				var that = this;
				var id = that.props.id;
	
				var defalutFontSize = window.innerWidth / _TkConstant2['default'].STANDARDSIZE;
				// 触摸点相对白板区的位置-触摸点相对触摸元素边界的位置：
				that.state[id].left = dragData.x / defalutFontSize - that.state[id].offsetX;
				that.state[id].top = dragData.y / defalutFontSize - that.state[id].offsetY;
				var dragEleId = id; //拖拽的元素
				var boundsEleId = 'tk_app'; //控制拖拽边界的元素
				that.state[id] = _TkUtils2['default'].controlDragBounds(that, dragEleId, boundsEleId);
				that.setState(_defineProperty({}, id, that.state[id]));
			}
		}, {
			key: 'handlerOnStopDrag',
			value: function handlerOnStopDrag(e, dragData) {
				//拖拽结束
				var that = this;
				var id = that.props.id;
	
				that.state[id].offsetX = 0;
				that.state[id].offsetY = 0;
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					var _that$state$id = that.state[id];
					var left = _that$state$id.left;
					var _top = _that$state$id.top;
	
					var _TkUtils$RemChangeToPercentage = _TkUtils2['default'].RemChangeToPercentage(that, left, _top, id);
	
					var percentLeft = _TkUtils$RemChangeToPercentage.percentLeft;
					var percentTop = _TkUtils$RemChangeToPercentage.percentTop;
	
					that[id] = {
						percentLeft: percentLeft,
						percentTop: percentTop
					};
					var data = {
						percentLeft: that[id].percentLeft,
						percentTop: that[id].percentTop,
						isDrag: true
					};
					_ServiceSignalling2['default'].sendSignallingFromAnswerDrag(data);
				}
			}
		}, {
			key: 'render',
			value: function render() {
				var that = this;
				var _state2 = this.state;
				var initArr = _state2.initArr;
				var brr = _state2.brr;
				var tableObject = _state2.tableObject;
				var id = this.props.id;
	
				var _loadTimeDescArray2 = this._loadTimeDescArray(initArr);
	
				var beforeArray = _loadTimeDescArray2.beforeArray;
	
				var _loadTableDescArray2 = this._loadTableDescArray(tableObject);
	
				var afterArry = _loadTableDescArray2.afterArry;
	
				var draggableData = {
					onStart: that.handlerOnStartDrag.bind(that), //开始拖拽
					onDrag: that.handlerOnDragging.bind(that), //拖拽中
					onStop: that.handlerOnStopDrag.bind(that) };
				//拖拽结束
				var answerDragStyle = {
					position: 'absolute',
					zIndex: 110,
					display: 'inline-block',
					left: this.state[id].left + 'rem',
					top: this.state[id].top + 'rem',
					transitionProperty: this.isHasTransition ? 'left,top' : undefined,
					transitionDuration: this.isHasTransition ? '0.4s' : undefined
				};
				return _react2['default'].createElement(
					_reactDraggable.DraggableCore,
					draggableData,
					_react2['default'].createElement(
						'div',
						{ id: 'answerDrag', style: answerDragStyle },
						_react2['default'].createElement(
							'div',
							{ className: 'answer-teach-wrapDiv', style: { display: this.state.answerTeachWrapDiv }, ref: 'dragBox' },
							_react2['default'].createElement(
								'div',
								{ className: 'answer-teach-header' },
								_react2['default'].createElement(
									'div',
									{ className: 'answer-teach-header-left' },
									_react2['default'].createElement('span', { className: 'answer-teach-headerImg' }),
									_react2['default'].createElement(
										'span',
										{ className: 'answer-teach-header-left-grey' },
										_TkGlobal2['default'].language.languageData.answers.headerTopLeft.text
									),
									_react2['default'].createElement(
										'span',
										{ className: 'answer-teach-header-left-green' },
										_TkGlobal2['default'].language.languageData.answers.headerMiddel.text
									)
								),
								_react2['default'].createElement('div', { className: 'answer-teach-header-right', onTouchStart: this.answerTeachCloseHandel.bind(this) })
							),
							_react2['default'].createElement(
								'div',
								{ className: 'answer-teach-content' },
								_react2['default'].createElement(
									'ul',
									{ className: 'answer-teach-optionUl' },
									beforeArray
								),
								_react2['default'].createElement(
									'div',
									{ className: 'answer-teach-add', ref: 'addDiv', onTouchStart: this.addHandel.bind(this), style: { background: this.state.plusStyle } },
									'+'
								),
								_react2['default'].createElement(
									'div',
									{ className: 'answer-teach-reduce', ref: 'reduceDiv', onTouchStart: this.reduceHandel.bind(this), style: { background: this.state.reduceStyle } },
									'-'
								),
								_react2['default'].createElement(
									'div',
									{ className: 'answer-teach-begin', onTouchStart: this.beginAnswer.bind(this), style: { background: this.state.beginStyle } },
									_TkGlobal2['default'].language.languageData.answers.beginAnswer.text
								)
							)
						),
						_react2['default'].createElement(
							'div',
							{ className: 'result-teach-wrapDiv', style: { display: this.state.resultTeachDisplay }, ref: 'resultRef' },
							_react2['default'].createElement(
								'div',
								{ className: 'result-teach-header' },
								_react2['default'].createElement(
									'div',
									{ className: 'result-teach-header-left' },
									_react2['default'].createElement('span', { className: 'result-teach-headerImg' }),
									_react2['default'].createElement(
										'span',
										{ className: 'result-teach-header-left-grey' },
										_TkGlobal2['default'].language.languageData.answers.headerTopLeft.text
									),
									_react2['default'].createElement('span', { id: 'result-teach-mytime' })
								),
								_react2['default'].createElement('p', { className: 'result-teach-close', onTouchStart: this.resultTeachCloseHandel.bind(this), style: { display: this.state.resultTeachStyleDisplay } })
							),
							_react2['default'].createElement(
								'div',
								{ className: 'result-teach-content' },
								_react2['default'].createElement(
									'p',
									{ className: 'answersPeople' },
									_TkGlobal2['default'].language.languageData.answers.numberOfAnswer.text,
									':',
									_react2['default'].createElement(
										'span',
										{ ref: 'anss' },
										this.state.allNumbers
									),
									_react2['default'].createElement(
										'span',
										{ className: 'xiang-qing-div', onTouchStart: this.xiangQingHandel.bind(this) },
										'(',
										this.state.xiangQingText,
										')'
									)
								),
								_react2['default'].createElement(
									'span',
									{ className: 'result-teach-accuracy-right' },
									_react2['default'].createElement(
										'span',
										{ className: 'result-teach-accuracy-right-text' },
										_TkGlobal2['default'].language.languageData.answers.tureAccuracy.text,
										'：'
									),
									_react2['default'].createElement(
										'span',
										{ style: { color: "red" } },
										this.state.trueLV,
										'%'
									)
								),
								_react2['default'].createElement(
									'div',
									{ className: 'result-teach-coordinate-div', style: { display: this.state.columnar } },
									_react2['default'].createElement(
										'span',
										{ className: 'result-teach-heart-span' },
										'0'
									),
									_react2['default'].createElement(
										'div',
										{ className: 'result-teach-staff-div' },
										_react2['default'].createElement(
											'ul',
											{ className: 'result-student-allResult' },
											this.state.allResult
										)
									),
									_react2['default'].createElement(
										'ul',
										{ className: 'result-teach-allResult' },
										this.state.allResultX
									)
								),
								_react2['default'].createElement(
									'div',
									{ className: 'answer-table-div', style: { display: this.state.tableStyle } },
									_react2['default'].createElement(
										'table',
										{ className: 'answer-table' },
										_react2['default'].createElement(
											'tbody',
											null,
											_react2['default'].createElement(
												'tr',
												{ className: 'answer-table-first-tr' },
												_react2['default'].createElement(
													'th',
													null,
													_TkGlobal2['default'].language.languageData.answers.student.text
												),
												_react2['default'].createElement(
													'th',
													null,
													_TkGlobal2['default'].language.languageData.answers.TheSelectedTheAnswer.text
												),
												_react2['default'].createElement(
													'th',
													null,
													_TkGlobal2['default'].language.languageData.answers.AnswerTime.text
												)
											),
											afterArry
										)
									)
								),
								_react2['default'].createElement(
									'div',
									{ className: 'result-teach-true-result' },
									_react2['default'].createElement(
										'span',
										{ style: { color: "white" } },
										_TkGlobal2['default'].language.languageData.answers.trueAnswer.text,
										':'
									),
									_react2['default'].createElement(
										'span',
										{ className: 'result-teach-trueSelect' },
										this.state.trueSelect
									),
									_react2['default'].createElement(
										'span',
										{ className: 'result-teach-published-warning', style: { display: this.state.publishedWarning } },
										_TkGlobal2['default'].language.languageData.answers.end.text
									),
									_react2['default'].createElement(
										'span',
										{ className: 'publish-the-answer', onTouchStart: this.publishAnswerHandel.bind(this), style: { background: this.state.publishedWarningColor } },
										this.state.publishAnswerText
									)
								),
								_react2['default'].createElement(
									'div',
									{ className: 'result-teach-end-question', style: { display: this.state.endQuestion }, onTouchStart: this.endHandel.bind(this) },
									_TkGlobal2['default'].language.languageData.answers.endAnswer.text
								),
								_react2['default'].createElement(
									'div',
									{ className: 'result-teach-restart-question', style: { display: this.state.restartQuestion }, onTouchStart: this.restartHandel.bind(this) },
									_TkGlobal2['default'].language.languageData.answers.restarting.text
								)
							)
						),
						_react2['default'].createElement(_answerStudentTool2['default'], null)
					)
				);
			}
		}]);
	
		return AnswerTeachingToolSmart;
	})(_react2['default'].Component);
	
	exports['default'] = AnswerTeachingToolSmart;
	module.exports = exports['default'];

/***/ }),

/***/ 265:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 右侧内容-教学工具箱 Smart组件
	 * @module dialTeachingToolComponent
	 * @description   转盘组件
	 * @author liujianhang
	 * @date 2017/09/20
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _reactDraggable = __webpack_require__(58);
	
	var _reactDraggable2 = _interopRequireDefault(_reactDraggable);
	
	var DialTeachingToolSmart = (function (_React$Component) {
	    _inherits(DialTeachingToolSmart, _React$Component);
	
	    function DialTeachingToolSmart(props) {
	        var _state;
	
	        _classCallCheck(this, DialTeachingToolSmart);
	
	        _get(Object.getPrototypeOf(DialTeachingToolSmart.prototype), 'constructor', this).call(this, props);
	        var id = this.props.id;
	
	        this.state = (_state = {
	            dialTeachComponentBgDisplay: "none",
	            dialIconClose: false,
	            turnTableDeg: 'rotate(0)',
	            dialShow: false,
	            deg: 45,
	            numdeg: 0,
	            num: 0,
	            isClick: false
	        }, _defineProperty(_state, id, {
	            left: 4.4,
	            top: 0,
	            offsetX: 0,
	            offsetY: 0
	        }), _defineProperty(_state, 'msgDeg', false), _state);
	        this[id] = {}; //保存位置的百分比
	        this.isHasTransition = false;
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	    }
	
	    _createClass(DialTeachingToolSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            _eventObjectDefine2['default'].Window.addEventListener(_TkConstant2['default'].EVENTTYPE.WindowEvent.onResize, that.handlerOnResize.bind(that), that.listernerBackupid); //window.resize事件
	            // 	eventObjectDefine.CoreController.addEventListener("initAppPermissions", that.handlerInitAppPermissions.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-dial", that.handlerMsglistDialShow.bind(that), that.listernerBackupid);
	            //	eventObjectDefine.CoreController.addEventListener(rename.EVENTTYPE.RoomEvent.roomParticipantJoin, that.handlerRoomParticipantJoin.bind(that) , that.listernerBackupid); //监听用户加入
	            //	eventObjectDefine.CoreController.addEventListener(rename.EVENTTYPE.RoomEvent.roomParticipantLeave, that.handlerRoomParticipantLeave.bind(that) , that.listernerBackupid); //监听用户离开
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //room-pubmsg事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //roomDelmsg事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomUserpropertyChanged, that.handlerroomUserpropertyChanged.bind(that), that.listernerBackupid); //roomUserpropertyChanged事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPlaybackClearAllFromPlaybackController, that.handlerRoomPlaybackClearAll.bind(that), that.listernerBackupid); //roomPlaybackClearAll 事件：回放清除所有信令
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-DialDrag", that.handlerMsglistDialDrag.bind(that), that.listernerBackupid); //msglist,后面进来的人收到小黑板的拖拽位置
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].Window.removeBackupListerner(that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	        }
	    }, {
	        key: 'handlerOnResize',
	        value: function handlerOnResize() {
	            var that = this;
	            var id = this.props.id;
	
	            if (Object.keys(that[id]).length !== 0) {
	                var _that$id = that[id];
	                var percentLeft = _that$id.percentLeft;
	                var percentTop = _that$id.percentTop;
	
	                _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	                this.setState(_defineProperty({}, id, this.state[id]));
	            }
	        }
	    }, {
	        key: 'componentDidUpdate',
	        value: function componentDidUpdate() {
	            //每次render结束后会触发,每次转过之后去除过度效果
	            if (this.isHasTransition == true) {
	                this.isHasTransition = false;
	            }
	        }
	    }, {
	        key: 'handlerroomUserpropertyChanged',
	        value: function handlerroomUserpropertyChanged(roomUserpropertyChangedEventData) {
	            var that = this;
	            var changePropertyJson = roomUserpropertyChangedEventData.message;
	            var user = roomUserpropertyChangedEventData.user;
	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;
	
	            try {
	                for (var _iterator = Object.keys(changePropertyJson)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var key = _step.value;
	
	                    if (key === 'publishstate') {
	                        //	                that.goStageUsers();!!!!
	                    }
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator['return']) {
	                        _iterator['return']();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerMsglistDialShow',
	        value: function handlerMsglistDialShow(recvEventData) {
	            var that = this;
	            this.state.msgDeg = true;
	            this.setState({ msgDeg: this.state.msgDeg });
	            var _iteratorNormalCompletion2 = true;
	            var _didIteratorError2 = false;
	            var _iteratorError2 = undefined;
	
	            try {
	                for (var _iterator2 = recvEventData.message.dialShowArr[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	                    var message = _step2.value;
	
	                    if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol) {
	                        if (message.data.isShow) {
	                            that.state.turnTableDeg = 'rotate(0)';
	                            that.state.dialTeachComponentBgDisplay = "block";
	                            that.state.dialIconClose = true;
	                            that.setState({
	                                dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay,
	                                turnTableDeg: that.state.turnTableDeg,
	                                dialIconClose: that.state.dialIconClose
	                            });
	                        } else {
	                            that.state.dialTeachComponentBgDisplay = "block";
	                            that.state.turnTableDeg = message.data.rotationAngle;
	                            that.state.dialIconClose = true;
	                            that.setState({
	                                dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay,
	                                turnTableDeg: that.state.turnTableDeg,
	                                dialIconClose: that.state.dialIconClose,
	                                isClick: that.state.isClick
	                            });
	                        }
	                    } else {
	                        if (message.data.isShow) {
	                            that.state.turnTableDeg = 'rotate(0)';
	                            that.state.dialIconClose = false;
	                            that.state.dialTeachComponentBgDisplay = "block";
	                            that.setState({
	                                dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay,
	                                turnTableDeg: that.state.turnTableDeg,
	                                dialIconClose: that.state.dialIconClose
	                            });
	                        } else {
	                            that.state.dialTeachComponentBgDisplay = "block";
	                            that.state.turnTableDeg = message.data.rotationAngle;
	                            that.state.dialIconClose = false;
	                            that.setState({
	                                dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay,
	                                turnTableDeg: that.state.turnTableDeg,
	                                dialIconClose: that.state.dialIconClose
	                            });
	                        }
	                    }
	                }
	            } catch (err) {
	                _didIteratorError2 = true;
	                _iteratorError2 = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion2 && _iterator2['return']) {
	                        _iterator2['return']();
	                    }
	                } finally {
	                    if (_didIteratorError2) {
	                        throw _iteratorError2;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerMsglistDialDrag',
	        value: function handlerMsglistDialDrag(handleData) {
	            var _this = this;
	
	            //msglist,后面进来的人收到转盘的拖拽位置
	            var DialDragInfo = handleData.message.DialDragArray;
	            var that = this;
	            var id = that.props.id;
	
	            DialDragInfo.map(function (item, index) {
	                var _item$data = item.data;
	                var percentLeft = _item$data.percentLeft;
	                var percentTop = _item$data.percentTop;
	
	                _this[id] = {
	                    percentLeft: percentLeft,
	                    percentTop: percentTop
	                };
	                _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	                that.setState(_defineProperty({}, id, that.state[id]));
	            });
	        }
	    }, {
	        key: 'handlerRoomPubmsg',
	        value: function handlerRoomPubmsg(recvEventData) {
	            var that = this;
	            var pubmsgData = recvEventData.message;
	            switch (pubmsgData.name) {
	                case "dial":
	
	                    that.handlerDisplayTeachTool(pubmsgData);
	                    break;
	                case 'DialDrag':
	                    //转盘的拖拽
	                    var id = that.props.id;
	
	                    this.isHasTransition = true;
	                    var _pubmsgData$data = pubmsgData.data,
	                        percentLeft = _pubmsgData$data.percentLeft,
	                        percentTop = _pubmsgData$data.percentTop;
	
	                    this[id] = {
	                        percentLeft: percentLeft,
	                        percentTop: percentTop
	                    };
	                    _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	                    this.setState(_defineProperty({}, id, this.state[id]));
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerRoomDelmsg',
	        value: function handlerRoomDelmsg(recvEventData) {
	            var that = this;
	            var pubmsgData = recvEventData.message;
	            switch (pubmsgData.name) {
	                case "dial":
	                    var id = this.props.id;
	
	                    that.state.dialTeachComponentBgDisplay = "none";
	                    that.state.num = 0;
	                    that.state.numdeg = 0;
	                    that.state.deg = 45;
	                    that.state[id].left = 4.4;
	                    that.state[id].top = 0;
	                    that.setState(_defineProperty({
	                        dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay,
	                        num: that.state.num,
	                        numdeg: that.state.numdeg,
	                        deg: that.state.deg
	                    }, id, that.state[id]));
	                    break;
	                case "ClassBegin":
	                    that.state.dialTeachComponentBgDisplay = "none";
	                    that.setState({
	                        dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay
	                    });
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerDisplayTeachTool',
	        value: function handlerDisplayTeachTool(recvEventData) {
	            var that = this;
	            if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol) {
	                if (recvEventData.data.isShow) {
	                    that.state.dialTeachComponentBgDisplay = "block";
	                    that.state.dialIconClose = true;
	                    that.setState({
	                        dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay,
	                        turnTableDeg: that.state.turnTableDeg,
	                        dialIconClose: that.state.dialIconClose
	                    });
	                } else {
	                    that.state.dialTeachComponentBgDisplay = "block";
	                    that.state.turnTableDeg = recvEventData.data.rotationAngle;
	                    that.state.dialIconClose = false;
	                    that.state.msgDeg = false;
	                    that.setState({
	                        dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay,
	                        turnTableDeg: that.state.turnTableDeg,
	                        dialIconClose: that.state.dialIconClose,
	                        msgDeg: that.state.msgDeg
	                    });
	                    setTimeout(function () {
	                        that.state.dialIconClose = true;
	                        that.state.isClick = false;
	                        that.setState({
	                            dialIconClose: that.state.dialIconClose,
	                            isClick: that.state.isClick
	                        });
	                    }, 4000);
	                }
	            } else {
	                if (recvEventData.data.isShow) {
	                    that.state.turnTableDeg = 'rotate(0)';
	                    that.state.dialIconClose = false;
	                    that.state.dialTeachComponentBgDisplay = "block";
	                    that.setState({
	                        dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay,
	                        turnTableDeg: that.state.turnTableDeg,
	                        dialIconClose: that.state.dialIconClose
	                    });
	                } else {
	                    that.state.dialTeachComponentBgDisplay = "block";
	                    that.state.turnTableDeg = recvEventData.data.rotationAngle;
	                    that.state.dialIconClose = false;
	                    that.setState({
	                        dialTeachComponentBgDisplay: that.state.dialTeachComponentBgDisplay,
	                        turnTableDeg: that.state.turnTableDeg,
	                        dialIconClose: that.state.dialIconClose
	                    });
	                }
	            }
	        }
	    }, {
	        key: 'handlerRoomPlaybackClearAll',
	        value: function handlerRoomPlaybackClearAll() {
	            if (!_TkGlobal2['default'].playback) {
	                L.Logger.error('No playback environment, no execution event[roomPlaybackClearAll] handler ');return;
	            };
	            var that = this;
	            that.setState({
	                dialTeachComponentBgDisplay: "none",
	                dialIconClose: false,
	                turnTableDeg: 'rotate(0)',
	                dialShow: false
	            });
	        }
	    }, {
	        key: 'opointer',
	
	        /*指针的点击函数*/
	        value: function opointer(e) {
	            if (_TkConstant2['default'].hasRole.roleStudent || this.state.isClick === true) {
	                return false;
	            }
	            if (this.state.isClick) {
	                return false;
	            }
	            if (this.state.msgDeg) {
	                this.state.turnTableDeg = 'rotate(0)';
	            }
	            this.state.msgDeg = false;
	            this.state.isClick = true;
	            this.state.dialShow = false;
	            var index = Math.floor(Math.random() * 5 + 1); //得到0-7随机数
	            this.state.num = index + this.state.num; //得到本次位置
	            this.state.numdeg += index * this.state.deg + Math.floor(Math.random() * 2 + 3) * 360;
	            this.setState({
	                dialShow: this.state.dialShow,
	                num: this.state.num,
	                numdeg: this.state.numdeg,
	                deg: this.state.deg,
	                isClick: this.state.isClick,
	                msgDeg: this.state.msgDeg
	            });
	            var iconShow = this.state.dialShow;
	            var data = {
	                rotationAngle: 'rotate(' + this.state.numdeg + 'deg)',
	                isShow: iconShow
	
	            };
	            _ServiceSignalling2['default'].sendSignallingDialToStudent(data);
	        }
	    }, {
	        key: 'dialClosePHandle',
	
	        /*关闭指针*/
	        value: function dialClosePHandle() {
	            // ReactDOM.findDOMNode(this.refs.turnTable).style.transform=0 ;
	            this.state.num = 0;
	            this.state.numdeg = 0;
	            this.state.deg = 45;
	            this.state.turnTableDeg = 'rotate(0)';
	            this.state.dialTeachComponentBgDisplay = 'none';
	            this.setState({
	                dialTeachComponentBgDisplay: this.state.dialTeachComponentBgDisplay,
	                turnTableDeg: this.state.turnTableDeg,
	                num: this.state.num,
	                numdeg: this.state.numdeg,
	                deg: this.state.deg
	            });
	            var data = {
	                dialClose: 'none'
	            };
	            var isDelMsg = true;
	            _ServiceSignalling2['default'].sendSignallingDialToStudent(data, isDelMsg);
	            this.state.studentNameArr = [];
	            this.setState({ studentNameArr: this.state.studentNameArr });
	            //初始化拖拽元素的位置
	            var id = this.props.id;
	
	            this.state[id].left = 4.4;
	            this.state[id].top = 0;
	            this.setState(_defineProperty({}, id, this.state[id]));
	        }
	    }, {
	        key: 'handlerOnStartDrag',
	        value: function handlerOnStartDrag(e, dragData) {
	            //开始拖拽
	            var that = this;
	            var id = that.props.id;
	
	            var defalutFontSize = window.innerWidth / _TkConstant2['default'].STANDARDSIZE;
	            that.state[id].offsetX = dragData.x / defalutFontSize - that.state[id].left;
	            that.state[id].offsetY = dragData.y / defalutFontSize - that.state[id].top;
	        }
	    }, {
	        key: 'handlerOnDragging',
	        value: function handlerOnDragging(e, dragData) {
	            //拖拽中
	            var that = this;
	            var id = that.props.id;
	
	            var defalutFontSize = window.innerWidth / _TkConstant2['default'].STANDARDSIZE;
	            // 触摸点相对白板区的位置-触摸点相对触摸元素边界的位置：
	            that.state[id].left = dragData.x / defalutFontSize - that.state[id].offsetX;
	            that.state[id].top = dragData.y / defalutFontSize - that.state[id].offsetY;
	            var dragEleId = id; //拖拽的元素
	            var boundsEleId = 'tk_app'; //控制拖拽边界的元素
	            that.state[id] = _TkUtils2['default'].controlDragBounds(that, dragEleId, boundsEleId);
	            that.setState(_defineProperty({}, id, that.state[id]));
	        }
	    }, {
	        key: 'handlerOnStopDrag',
	        value: function handlerOnStopDrag(e, dragData) {
	            //拖拽结束
	            var that = this;
	            var id = that.props.id;
	
	            that.state[id].offsetX = 0;
	            that.state[id].offsetY = 0;
	            if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
	                var _that$state$id = that.state[id];
	                var left = _that$state$id.left;
	                var _top = _that$state$id.top;
	
	                var _TkUtils$RemChangeToPercentage = _TkUtils2['default'].RemChangeToPercentage(that, left, _top, id);
	
	                var percentLeft = _TkUtils$RemChangeToPercentage.percentLeft;
	                var percentTop = _TkUtils$RemChangeToPercentage.percentTop;
	
	                that[id] = {
	                    percentLeft: percentLeft,
	                    percentTop: percentTop
	                };
	                var data = {
	                    percentLeft: that[id].percentLeft,
	                    percentTop: that[id].percentTop,
	                    isDrag: true
	                };
	                _ServiceSignalling2['default'].sendSignallingFromDialDrag(data);
	            }
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	            var studentNameArr = this.state.studentNameArr;
	            var _props = this.props;
	            var getItem = _props.getItem;
	            var id = _props.id;
	
	            var draggableData = {
	                onStart: that.handlerOnStartDrag.bind(that), //开始拖拽
	                onDrag: that.handlerOnDragging.bind(that), //拖拽中
	                onStop: that.handlerOnStopDrag.bind(that) };
	            //拖拽结束
	            var dialDragStyle = {
	                position: 'absolute',
	                zIndex: 110,
	                display: this.state.dialTeachComponentBgDisplay,
	                width: _TkConstant2['default'].hasRole.roleStudent ? '2rem' : '2.2rem',
	                height: _TkConstant2['default'].hasRole.roleStudent ? '2rem' : '2.4rem',
	                transitionProperty: this.isHasTransition ? 'left,top' : undefined,
	                transitionDuration: this.isHasTransition ? '0.4s' : undefined,
	                left: this.state[id].left + 'rem',
	                top: this.state[id].top + 'rem'
	            };
	            return _react2['default'].createElement(
	                _reactDraggable.DraggableCore,
	                draggableData,
	                _react2['default'].createElement(
	                    'div',
	                    { id: 'dialDrag', style: dialDragStyle },
	                    _react2['default'].createElement(
	                        'div',
	                        { className: 'dial-teachComponent-bg', ref: 'dialTeachComponentBg', style: { display: this.state.dialTeachComponentBgDisplay, top: _TkConstant2['default'].hasRole.roleStudent ? '0' : '0.4rem' } },
	                        _react2['default'].createElement('button', { alt: 'pointer', style: { backgroundColor: this.state.a }, className: 'dial-teachComponent-pointer-button', onTouchStart: this.opointer.bind(this) }),
	                        _react2['default'].createElement('div', { className: 'dial-teachComponent-turntable', ref: 'turnTable', style: { transition: 'transform 4s ease', transform: this.state.turnTableDeg } }),
	                        _react2['default'].createElement('div', { className: 'dialCloseP', onTouchStart: this.dialClosePHandle.bind(this), style: { display: this.state.dialIconClose ? "block" : "none" } })
	                    )
	                )
	            );
	        }
	    }]);
	
	    return DialTeachingToolSmart;
	})(_react2['default'].Component);
	
	exports['default'] = DialTeachingToolSmart;
	module.exports = exports['default'];
	/*<div style={{height:'100%',zIndex:121}}></div>*/

/***/ }),

/***/ 266:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 右侧内容-教学工具箱 Smart组件
	 * @module responderStudentToolComponent
	 * @description   抢答器组件
	 * @author liujianhang
	 * @date 2017/10/30
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(42);
	
	var _reactDom2 = _interopRequireDefault(_reactDom);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkConstant3 = _interopRequireDefault(_TkConstant);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _reactDraggable = __webpack_require__(58);
	
	var _reactDraggable2 = _interopRequireDefault(_reactDraggable);
	
	var ResponderStudentToolSmart = (function (_React$Component) {
	    _inherits(ResponderStudentToolSmart, _React$Component);
	
	    function ResponderStudentToolSmart(props) {
	        _classCallCheck(this, ResponderStudentToolSmart);
	
	        _get(Object.getPrototypeOf(ResponderStudentToolSmart.prototype), 'constructor', this).call(this, props);
	        var id = this.props.id;
	
	        this.state = _defineProperty({
	            responderStudentIsShow: "none",
	            responderTop: "",
	            responderLeft: "",
	            timesRun: 3,
	            studentText: "",
	            userName: null,
	            isClick: false,
	            userSort: {},
	            userArry: [],
	            translateMove: null
	        }, id, {
	            left: 4.4,
	            top: 0,
	            offsetX: 0,
	            offsetY: 0
	        });
	        this.intervals = undefined;
	        this.timeOutIntervals = undefined;
	        this.isHasTransition = false;
	        this[id] = {}; //保存位置的百分比
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	    }
	
	    _createClass(ResponderStudentToolSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            _eventObjectDefine2['default'].Window.addEventListener(_TkConstant3['default'].EVENTTYPE.WindowEvent.onResize, that.handlerOnResize.bind(that), that.listernerBackupid); //window.resize事件
	            //eventObjectDefine.CoreController.addEventListener( 'changeOtherVideoStyle' , that.handleChangeOtherVideoStyle.bind(that) , that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-qiangDaQi", that.handlerMsglistQiangDaQi.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-QiangDaZhe", that.handlerMsglistQiangDaZhe.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant3['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant3['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //roomDelmsg事件
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].Window.removeBackupListerner(that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	        }
	    }, {
	        key: 'handlerOnResize',
	        value: function handlerOnResize() {
	            var that = this;
	            var id = this.props.id;
	
	            if (Object.keys(that[id]).length !== 0) {
	                var _that$id = that[id];
	                var percentLeft = _that$id.percentLeft;
	                var percentTop = _that$id.percentTop;
	
	                _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	                this.setState(_defineProperty({}, id, this.state[id]));
	            }
	        }
	    }, {
	        key: 'componentDidUpdate',
	        value: function componentDidUpdate() {
	            //每次render结束后会触发,每次转过之后去除过度效果
	            if (this.isHasTransition === true) {
	                this.isHasTransition = false;
	            }
	        }
	    }, {
	        key: 'handlerRoomPubmsg',
	        value: function handlerRoomPubmsg(recvEventData) {
	            var that = this;
	            var pubmsgData = recvEventData.message;
	            var users = _ServiceRoom2['default'].getTkRoom().getMySelf();
	            switch (pubmsgData.name) {
	                case "qiangDaQi":
	                    if (_TkConstant3['default'].hasRole.roleStudent && users.publishstate >= 0) {
	                        that._teacherRecevedServiceQiangDaQiData(pubmsgData);
	                    }
	                    break;
	                case "QiangDaZhe":
	                    if (_TkConstant3['default'].hasRole.roleStudent) {
	                        that._teacherRecevedServiceQiangDaZheData(pubmsgData);
	                    }
	                    break;
	                case 'ResponderDrag':
	                    //抢答器的拖拽
	                    var id = that.props.id;
	
	                    this.isHasTransition = true;
	                    var _pubmsgData$data = pubmsgData.data,
	                        percentLeft = _pubmsgData$data.percentLeft,
	                        percentTop = _pubmsgData$data.percentTop;
	
	                    this[id] = {
	                        percentLeft: percentLeft,
	                        percentTop: percentTop
	                    };
	                    _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	                    this.setState(_defineProperty({}, id, this.state[id]));
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerRoomDelmsg',
	        value: function handlerRoomDelmsg(recvEventData) {
	            var _that$setState;
	
	            var that = this;
	            var pubmsgData = recvEventData.message;
	            switch (pubmsgData.name) {
	                case "ClassBegin":
	                    that.state.responderStudentIsShow = "none";
	                    that.setState({ responderStudentIsShow: that.state.responderStudentIsShow });
	                    break;
	                case "qiangDaQi":
	                    if (pubmsgData.data.isShow === false) {
	                        //初始化拖拽元素的位置
	                        var _id = this.props.id;
	
	                        this.state[_id].left = 4.4;
	                        this.state[_id].top = 0;
	                    }
	                    that.state.responderStudentIsShow = "none";
	                    that.state.isClick = false;
	                    that.state.timesRun = 3;
	                    that.state.userArry = [];
	                    that.state.userSort = {};
	                    that.state.studentText = that.state.timesRun;
	                    that.setState((_that$setState = {}, _defineProperty(_that$setState, id, this.state[id]), _defineProperty(_that$setState, 'userArry', that.state.userArry), _defineProperty(_that$setState, 'userSort', that.state.userSort), _defineProperty(_that$setState, 'responderStudentIsShow', that.state.responderStudentIsShow), _defineProperty(_that$setState, 'isClick', that.state.isClick), _defineProperty(_that$setState, 'timesRun', that.state.timesRun), _defineProperty(_that$setState, 'studentText', that.state.studentText), _that$setState));
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerMsglistQiangDaQi',
	        value: function handlerMsglistQiangDaQi(recvEventData) {
	            var that = this;
	            var users = _ServiceRoom2['default'].getTkRoom().getMySelf();
	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;
	
	            try {
	                for (var _iterator = recvEventData.message.qiangDaQiArr[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var message = _step.value;
	
	                    if (_TkConstant3['default'].hasRole.roleStudent && users.publishstate > 0) {
	                        that._teacherRecevedServiceQiangDaQiData(message);
	                    }
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator['return']) {
	                        _iterator['return']();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerMsglistQiangDaZhe',
	        value: function handlerMsglistQiangDaZhe(recvEventData) {
	            var that = this;
	            var _iteratorNormalCompletion2 = true;
	            var _didIteratorError2 = false;
	            var _iteratorError2 = undefined;
	
	            try {
	                for (var _iterator2 = recvEventData.message.QiangDaZheArr[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	                    var message = _step2.value;
	
	                    if (_TkConstant3['default'].hasRole.roleStudent) {
	                        that._teacherRecevedServiceQiangDaZheData(message);
	                    }
	                }
	            } catch (err) {
	                _didIteratorError2 = true;
	                _iteratorError2 = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion2 && _iterator2['return']) {
	                        _iterator2['return']();
	                    }
	                } finally {
	                    if (_didIteratorError2) {
	                        throw _iteratorError2;
	                    }
	                }
	            }
	        }
	    }, {
	        key: '_teacherRecevedServiceQiangDaQiData',
	        value: function _teacherRecevedServiceQiangDaQiData(pubmsgData) {
	            var that = this;
	            var id = that.props.id;
	
	            var serviceTimeData = _TkGlobal2['default'].serviceTime / 1000 - pubmsgData.ts;
	            if (pubmsgData.data.begin) {
	                that.state.responderStudentIsShow = "block";
	                if (serviceTimeData >= 8) {
	                    that.state.studentText = _TkGlobal2['default'].language.languageData.responder.noContest.text;
	                    if (Object.keys(that[id]).length !== 0) {
	                        var _that$id2 = that[id];
	                        var percentLeft = _that$id2.percentLeft;
	                        var percentTop = _that$id2.percentTop;
	
	                        _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	                    } else {
	                        that.state[id].left = 4.4;
	                        that.state[id].top = 0;
	                    }
	                    that.setState(_defineProperty({
	                        studentText: that.state.studentText
	                    }, id, this.state[id]));
	                } else {
	                    that.intervals = setInterval(function () {
	                        var _that$setState3;
	
	                        that.state.timesRun -= 1;
	                        if (that.state.timesRun === 0) {
	                            _TkUtils2['default'].percentageChangeToRem(that, 0.2, 0.2, id);
	                        } else if (that.state.timesRun === 1) {
	                            _TkUtils2['default'].percentageChangeToRem(that, 0.4, 0.6, id);
	                        } else if (that.state.timesRun === 2) {
	                            _TkUtils2['default'].percentageChangeToRem(that, 0.7, 0.2, id);
	                        }
	                        that.state.studentText = that.state.timesRun;
	                        that.setState((_that$setState3 = {}, _defineProperty(_that$setState3, id, that.state[id]), _defineProperty(_that$setState3, 'timesRun', that.state.timesRun), _defineProperty(_that$setState3, 'studentText', that.state.studentText), _that$setState3));
	                        if (that.state.timesRun <= 0) {
	                            clearInterval(that.intervals);
	                            that.state.studentText = _TkGlobal2['default'].language.languageData.responder.answer.text;
	                            that.setState({
	                                studentText: that.state.studentText
	                            });
	                            if (that.state.isClick == false) {
	                                that.timeOutIntervals = setTimeout(function () {
	                                    that.isHasTransition = true;
	                                    that.state.studentText = _TkGlobal2['default'].language.languageData.responder.noContest.text;
	                                    if (Object.keys(that[id]).length !== 0) {
	                                        var _that$id3 = that[id];
	                                        var percentLeft = _that$id3.percentLeft;
	                                        var percentTop = _that$id3.percentTop;
	
	                                        _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	                                    } else {
	                                        that.state[id].left = 4.4;
	                                        that.state[id].top = 0;
	                                    }
	                                    that.setState(_defineProperty({
	                                        studentText: that.state.studentText
	                                    }, id, that.state[id]));
	                                }, 4500);
	                            }
	                        }
	                    }, 1000);
	                }
	                that.setState({ responderStudentIsShow: that.state.responderStudentIsShow });
	            } else {
	                if (pubmsgData.data.isShow) {
	                    that.state.timesRun = 3;
	                    that.state.responderStudentIsShow = "none";
	                    that.state.studentText = 3;
	                    that.setState({
	                        timesRun: that.state.timesRun,
	                        responderStudentIsShow: that.state.responderStudentIsShow,
	                        studentText: that.state.studentText
	                    });
	                }
	            }
	        }
	    }, {
	        key: '_teacherRecevedServiceQiangDaZheData',
	        value: function _teacherRecevedServiceQiangDaZheData(pubmsgData) {
	            var that = this;
	            var id = that.props.id;
	
	            if (pubmsgData.data.isClick) {
	                var _that$setState5;
	
	                that.state.userSort[pubmsgData.fromID] = {};
	                that.state.userSort[pubmsgData.fromID][pubmsgData.seq] = pubmsgData.data.userAdmin;
	                that.setState({ userSort: that.state.userSort });
	                that.state.userArry = [];
	                for (var item in that.state.userSort) {
	                    for (var i in that.state.userSort[item]) {
	                        that.state.userArry.push(i);
	                        that.state.userArry = that.state.userArry.sort();
	                        that.setState({ userArry: that.state.userArry });
	                        if (that.state.userSort[item][that.state.userArry[0]] != undefined) {
	                            that.state.studentText = that.state.userSort[item][that.state.userArry[0]];
	                            that.setState({ studentText: that.state.studentText, firstUser: that.state.firstUser });
	                        }
	                    }
	                }
	                clearInterval(that.intervals);
	                clearTimeout(that.timeOutIntervals);
	                if (Object.keys(that[id]).length !== 0) {
	                    var _that$id4 = that[id];
	                    var percentLeft = _that$id4.percentLeft;
	                    var percentTop = _that$id4.percentTop;
	
	                    _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	                } else {
	                    that.state[id].left = 4.4;
	                    that.state[id].top = 0;
	                }
	                that.isHasTransition = true;
	                that.setState((_that$setState5 = {}, _defineProperty(_that$setState5, id, this.state[id]), _defineProperty(_that$setState5, 'studentText', that.state.studentText), _that$setState5));
	            }
	        }
	    }, {
	        key: 'studentResponder',
	
	        /*抢答*/
	        value: function studentResponder() {
	            var users = _ServiceRoom2['default'].getTkRoom().getMySelf();
	            if (users.publishstate >= 0 && _TkConstant3['default'].hasRole.roleStudent && this.state.studentText == _TkGlobal2['default'].language.languageData.responder.answer.text && this.state.isClick == false) {
	                //tkpc2.0.8
	                this.state.userAdmin = users.nickname;
	                this.setState({ userAdmin: this.state.userAdmin });
	                this.state.isClick = true;
	                this.setState({ isClick: this.state.isClick });
	                var userAdmin = this.state.userAdmin;
	                var isClick = this.state.isClick;
	                var data = {
	                    userAdmin: userAdmin,
	                    isClick: isClick
	                };
	                var isDelMsg = false;
	                _ServiceSignalling2['default'].sendSignallingQiangDaZhe(isDelMsg, data);
	            }
	        }
	    }, {
	        key: 'handlerOnStartDrag',
	        value: function handlerOnStartDrag(e, dragData) {
	            //开始拖拽
	            var that = this;
	            var id = that.props.id;
	
	            var defalutFontSize = window.innerWidth / _TkConstant3['default'].STANDARDSIZE;
	            that.state[id].offsetX = dragData.x / defalutFontSize - that.state[id].left;
	            that.state[id].offsetY = dragData.y / defalutFontSize - that.state[id].top;
	        }
	    }, {
	        key: 'handlerOnDragging',
	        value: function handlerOnDragging(e, dragData) {
	            //拖拽中
	            var that = this;
	            var id = that.props.id;
	
	            var defalutFontSize = window.innerWidth / _TkConstant3['default'].STANDARDSIZE;
	            // 触摸点相对白板区的位置-触摸点相对触摸元素边界的位置：
	            that.state[id].left = dragData.x / defalutFontSize - that.state[id].offsetX;
	            that.state[id].top = dragData.y / defalutFontSize - that.state[id].offsetY;
	            var dragEleId = id; //拖拽的元素
	            var boundsEleId = 'tk_app'; //控制拖拽边界的元素
	            that.state[id] = _TkUtils2['default'].controlDragBounds(that, dragEleId, boundsEleId);
	            that.setState(_defineProperty({}, id, that.state[id]));
	        }
	    }, {
	        key: 'handlerOnStopDrag',
	        value: function handlerOnStopDrag(e, dragData) {
	            //拖拽结束
	            var that = this;
	            var id = that.props.id;
	
	            that.state[id].offsetX = 0;
	            that.state[id].offsetY = 0;
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	            var id = that.props.id;
	
	            var draggableData = {
	                onStart: that.handlerOnStartDrag.bind(that), //开始拖拽
	                onDrag: that.handlerOnDragging.bind(that), //拖拽中
	                onStop: that.handlerOnStopDrag.bind(that) };
	            //拖拽结束
	            var responderDragStyle = {
	                display: this.state.responderStudentIsShow,
	                left: this.state[id].left + 'rem',
	                top: this.state[id].top + 'rem',
	                transitionProperty: this.isHasTransition ? 'left,top' : undefined,
	                transitionDuration: this.isHasTransition ? '0.5s' : undefined
	            };
	            return _react2['default'].createElement(
	                _reactDraggable.DraggableCore,
	                draggableData,
	                _react2['default'].createElement(
	                    'div',
	                    { className: 'responder-circle-student', id: id, style: responderDragStyle },
	                    _react2['default'].createElement('div', { className: 'responder-black-circle-student' }),
	                    _react2['default'].createElement(
	                        'div',
	                        { className: "responder-begin-circle-student" + " " + (typeof this.state.studentText == "number" ? 'disabled' : ''), onTouchStart: this.studentResponder.bind(this) },
	                        this.state.studentText
	                    )
	                )
	            );
	        }
	    }]);
	
	    return ResponderStudentToolSmart;
	})(_react2['default'].Component);
	
	exports['default'] = ResponderStudentToolSmart;
	module.exports = exports['default'];

/***/ }),

/***/ 267:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 右侧内容-教学工具箱 Smart组件
	 * @module responderTeachingToolComponent
	 * @description   抢答器组件
	 * @author liujianhang
	 * @date 2017/09/20
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	  value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(42);
	
	var _reactDom2 = _interopRequireDefault(_reactDom);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkConstant3 = _interopRequireDefault(_TkConstant);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _reactDraggable = __webpack_require__(58);
	
	var _reactDraggable2 = _interopRequireDefault(_reactDraggable);
	
	var ResponderTeachingToolSmart = (function (_React$Component) {
	  _inherits(ResponderTeachingToolSmart, _React$Component);
	
	  function ResponderTeachingToolSmart(props) {
	    _classCallCheck(this, ResponderTeachingToolSmart);
	
	    _get(Object.getPrototypeOf(ResponderTeachingToolSmart.prototype), 'constructor', this).call(this, props);
	    var id = this.props.id;
	
	    this.state = _defineProperty({
	      responderIsShow: "none",
	      closeImg: "none",
	      restartImg: "none",
	      startAngle: -(1 / 2 * Math.PI),
	      tmpAngle: -(1 / 2 * Math.PI),
	      answerText: _TkGlobal2['default'].language.languageData.responder.begin.text,
	      responderShow: false,
	      beginIsStatus: false,
	      studentRes: false,
	      userAdmin: "",
	      firstUser: false,
	      userSort: {},
	      userArry: [],
	      teacherTimeOut: null,
	      beginTimeOut: null
	    }, id, {
	      left: 4.4,
	      top: 0,
	      offsetX: 0,
	      offsetY: 0
	    });
	    this[id] = {}; //保存位置的百分比
	    this.isHasTransition = false;
	    this.stop = undefined;
	    this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	    this.mH = 300;
	    this.mW = 300;
	    this.r = this.mW / 2; //中间位置
	    this.cR = this.r - 2 * 5; //圆半径
	    this.endAngle = this.startAngle + 2 * Math.PI; //结束角度
	    this.xAngle = 0.4 * (Math.PI / 180); //偏移角度量
	    this.fontSize = 35; //字号大小
	    this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	  }
	
	  _createClass(ResponderTeachingToolSmart, [{
	    key: 'componentDidMount',
	    value: function componentDidMount() {
	      //在完成首次渲染之前调用，此时仍可以修改组件的state
	      var that = this;
	      _eventObjectDefine2['default'].Window.addEventListener(_TkConstant3['default'].EVENTTYPE.WindowEvent.onResize, that.handlerOnResize.bind(that), that.listernerBackupid); //window.resize事件
	      _eventObjectDefine2['default'].CoreController.addEventListener('responderShow', that.responderShow.bind(that), that.listernerBackupid);
	      _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-qiangDaQi", that.handlerMsglistQiangDaQi.bind(that), that.listernerBackupid);
	      _eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-QiangDaZhe", that.handlerMsglistQiangDaZhe.bind(that), that.listernerBackupid);
	      _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant3['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid);
	      _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant3['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //roomDelmsg事件
	    }
	  }, {
	    key: 'componentWillUnmount',
	    value: function componentWillUnmount() {
	      //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	      var that = this;
	      _eventObjectDefine2['default'].Window.removeBackupListerner(that.listernerBackupid);
	      _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	    }
	  }, {
	    key: 'handlerOnResize',
	    value: function handlerOnResize() {
	      var that = this;
	      var id = this.props.id;
	
	      if (Object.keys(that[id]).length !== 0) {
	        var _that$id = that[id];
	        var percentLeft = _that$id.percentLeft;
	        var percentTop = _that$id.percentTop;
	
	        _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	        this.setState(_defineProperty({}, id, this.state[id]));
	      }
	    }
	  }, {
	    key: 'componentDidUpdate',
	    value: function componentDidUpdate() {
	      //每次render结束后会触发,每次转过之后去除过度效果
	      if (this.isHasTransition == true) {
	        this.isHasTransition = false;
	      }
	    }
	  }, {
	    key: 'handlerRoomPubmsg',
	    value: function handlerRoomPubmsg(recvEventData) {
	      var that = this;
	      var pubmsgData = recvEventData.message;
	      switch (pubmsgData.name) {
	        case "qiangDaQi":
	          if (_TkConstant3['default'].hasRole.roleChairman || _TkConstant3['default'].hasRole.roleTeachingAssistant || _TkConstant3['default'].hasRole.rolePatrol) {
	            that._teacherRecevedServiceQiangDaQiData(pubmsgData);
	          }
	          break;
	        case "QiangDaZhe":
	          if (_TkConstant3['default'].hasRole.roleChairman || _TkConstant3['default'].hasRole.roleTeachingAssistant || _TkConstant3['default'].hasRole.rolePatrol) {
	            that._teacherRecevedServiceQiangDaZheData(pubmsgData);
	          }
	          break;
	        case 'ResponderDrag':
	          //抢答器的拖拽
	          var id = that.props.id;
	
	          this.isHasTransition = true;
	          var _pubmsgData$data = pubmsgData.data,
	              percentLeft = _pubmsgData$data.percentLeft,
	              percentTop = _pubmsgData$data.percentTop;
	
	          this[id] = {
	            percentLeft: percentLeft,
	            percentTop: percentTop
	          };
	          _TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
	          this.setState(_defineProperty({}, id, this.state[id]));
	          break;
	      }
	    }
	  }, {
	    key: 'handlerRoomDelmsg',
	    value: function handlerRoomDelmsg(recvEventData) {
	      var that = this;
	      var pubmsgData = recvEventData.message;
	      switch (pubmsgData.name) {
	        case "ClassBegin":
	          that.state.responderIsShow = "none";
	          that.setState({ responderIsShow: that.state.responderIsShow });
	          break;
	        case "qiangDaQi":
	          if (_TkConstant3['default'].hasRole.roleChairman || _TkConstant3['default'].hasRole.roleTeachingAssistant || _TkConstant3['default'].hasRole.rolePatrol) {
	            if (pubmsgData.data.isShow) {
	              that.state.responderIsShow = "block";
	              clearTimeout(that.state.teacherTimeOut);
	              window.cancelAnimationFrame(that.state.stop);
	              that.state.beginIsStatus = false;
	              that.state.firstUser = false;
	              that.state.userSort = {};
	              that.state.userArry = [];
	              that.setState({
	                teacherTimeOut: that.state.teacherTimeOut,
	                responderIsShow: that.state.responderIsShow,
	                beginIsStatus: that.state.beginIsStatus,
	                firstUser: that.state.firstUser,
	                userSort: that.state.userSort,
	                userArry: that.state.userArry
	              });
	            } else {
	              that.state.responderIsShow = "none";
	              that.state.teacherTimeOut = "";
	              that.setState({
	                teacherTimeOut: that.state.teacherTimeOut,
	                responderIsShow: that.state.responderIsShow
	              });
	            }
	            break;
	          }
	      }
	    }
	  }, {
	    key: 'handlerMsglistQiangDaQi',
	    value: function handlerMsglistQiangDaQi(recvEventData) {
	      var that = this;
	      var _iteratorNormalCompletion = true;
	      var _didIteratorError = false;
	      var _iteratorError = undefined;
	
	      try {
	        for (var _iterator = recvEventData.message.qiangDaQiArr[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	          var message = _step.value;
	
	          if (_TkConstant3['default'].hasRole.roleChairman || _TkConstant3['default'].hasRole.roleTeachingAssistant || _TkConstant3['default'].hasRole.rolePatrol) {
	            that._teacherRecevedServiceQiangDaQiData(message);
	          }
	        }
	      } catch (err) {
	        _didIteratorError = true;
	        _iteratorError = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion && _iterator['return']) {
	            _iterator['return']();
	          }
	        } finally {
	          if (_didIteratorError) {
	            throw _iteratorError;
	          }
	        }
	      }
	    }
	  }, {
	    key: 'handlerMsglistQiangDaZhe',
	    value: function handlerMsglistQiangDaZhe(recvEventData) {
	      var that = this;
	      var _iteratorNormalCompletion2 = true;
	      var _didIteratorError2 = false;
	      var _iteratorError2 = undefined;
	
	      try {
	        for (var _iterator2 = recvEventData.message.QiangDaZheArr[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	          var message = _step2.value;
	
	          if (_TkConstant3['default'].hasRole.roleChairman || _TkConstant3['default'].hasRole.roleTeachingAssistant || _TkConstant3['default'].hasRole.rolePatrol) {
	            that._teacherRecevedServiceQiangDaZheData(message);
	          }
	        }
	      } catch (err) {
	        _didIteratorError2 = true;
	        _iteratorError2 = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion2 && _iterator2['return']) {
	            _iterator2['return']();
	          }
	        } finally {
	          if (_didIteratorError2) {
	            throw _iteratorError2;
	          }
	        }
	      }
	    }
	  }, {
	    key: '_teacherRecevedServiceQiangDaQiData',
	
	    /*抢答题message-list*/
	    value: function _teacherRecevedServiceQiangDaQiData(recvEventData) {
	      var that = this;
	      var serviceTimeData = _TkGlobal2['default'].serviceTime / 1000 - recvEventData.ts;
	      if (recvEventData.data.isShow) {
	        that.state.responderIsShow = "block";
	        that.state.closeImg = "block";
	        that.state.restartImg = "none";
	        that.state.answerText = _TkGlobal2['default'].language.languageData.responder.begin.text;
	        var c = document.getElementById('myCanvas');
	        c.style.display = "block";
	        that.setState({
	          responderIsShow: that.state.responderIsShow,
	          closeImg: that.state.closeImg,
	          restartImg: that.state.restartImg,
	          answerText: that.state.answerText
	        });
	        clearTimeout(that.state.teacherTimeOut);
	        if (recvEventData.data.begin) {
	          if (serviceTimeData >= 8) {
	            clearTimeout(that.state.teacherTimeOut);
	            that.state.closeImg = "block";
	            that.state.restartImg = "block";
	            that.state.responderIsShow = "block";
	            if (that.state.firstUser == false) {
	              that.clearCanvasData();
	              that.state.answerText = _TkGlobal2['default'].language.languageData.responder.noContest.text;
	              that.setState({
	                answerText: that.state.answerText
	              });
	            } else {
	              that.state.answerText = that.state.answerText;
	              that.setState({
	                answerText: that.state.answerText
	              });
	            }
	            that.setState({
	              answerText: that.state.answerText,
	              closeImg: that.state.closeImg,
	              restartImg: that.state.restartImg,
	              responderIsShow: that.state.responderIsShow
	            });
	          } else {
	            that.canvasDraw();
	            that.state.closeImg = "none";
	            that.state.beginIsStatus = recvEventData.data.begin;
	            that.state.answerText = _TkGlobal2['default'].language.languageData.responder.inAnswer.text;
	            that.setState({
	              beginIsStatus: that.state.beginIsStatus,
	              closeImg: that.state.closeImg,
	              answerText: that.state.answerText
	            });
	            that.state.teacherTimeOut = setTimeout(function () {
	              that.state.closeImg = "block";
	              that.state.restartImg = "block";
	              that.state.responderIsShow = "block";
	              that.state.beginIsStatus = false;
	              if (that.state.firstUser == false) {
	                that.clearCanvasData();
	                that.state.answerText = _TkGlobal2['default'].language.languageData.responder.noContest.text;
	                that.setState({
	                  answerText: that.state.answerText
	                });
	              } else {
	                that.state.answerText = that.state.answerText;
	                that.setState({
	                  answerText: that.state.answerText
	                });
	              }
	              that.setState({
	                teacherTimeOut: that.state.teacherTimeOut,
	                answerText: that.state.answerText,
	                closeImg: that.state.closeImg,
	                restartImg: that.state.restartImg,
	                responderIsShow: that.state.responderIsShow,
	                beginIsStatus: that.state.beginIsStatus
	              });
	            }, 8000);
	          }
	        }
	      }
	    }
	  }, {
	    key: '_teacherRecevedServiceQiangDaZheData',
	
	    /*抢答者的message-list*/
	    value: function _teacherRecevedServiceQiangDaZheData(recvEventData) {
	      var that = this;
	      if (recvEventData.data.isClick) {
	        clearTimeout(that.state.teacherTimeOut);
	        that.clearCanvasData();
	        that.state.closeImg = "block";
	        that.state.restartImg = "block";
	        that.state.userSort[recvEventData.fromID] = {};
	        that.state.userSort[recvEventData.fromID][recvEventData.seq] = recvEventData.data.userAdmin;
	        that.setState({ userSort: that.state.userSort });
	        that.state.userArry = [];
	        for (var item in that.state.userSort) {
	          for (var i in that.state.userSort[item]) {
	            that.state.userArry.push(i);
	            that.state.userArry = that.state.userArry.sort();
	            that.setState({ userArry: that.state.userArry });
	            if (that.state.userSort[item][that.state.userArry[0]] != undefined) {
	              that.state.answerText = that.state.userSort[item][that.state.userArry[0]];
	              that.setState({ answerText: that.state.answerText, firstUser: that.state.firstUser });
	            }
	          }
	        }
	        that.state.firstUser = true;
	        that.setState({ firstUser: that.state.firstUser });
	      } else {
	        that.state.firstUser = false;
	        that.setState({ firstUser: that.state.firstUser });
	      }
	    }
	  }, {
	    key: 'responderShow',
	
	    /*事件分发*/
	    value: function responderShow(data) {
	      var that = this;
	      if (data.className == "responder-implement-bg") {
	        if (that.state.responderIsShow == "none") {
	          var c = document.getElementById('myCanvas');
	          c.style.display = "block";
	          that.state.responderIsShow = "block";
	          that.state.closeImg = "block";
	          that.setState({
	            responderIsShow: that.state.responderIsShow,
	            closeImg: that.state.closeImg
	          });
	        }
	      }
	    }
	  }, {
	    key: 'canvasDraw',
	
	    //渲染函数
	    value: function canvasDraw() {
	      window.cancelAnimationFrame(this.state.stop);
	      var that = this;
	      that.c = document.getElementById('myCanvas');
	      that.ctx = that.c.getContext('2d');
	      that.c.width = 300;
	      that.c.height = 300;
	      that.ctx.clearRect(0, 0, 300, 300);
	      if (that.state.tmpAngle >= that.endAngle) {
	
	        return;
	      } else if (that.state.tmpAngle + that.xAngle > that.endAngle) {
	        that.state.tmpAngle = that.endAngle;
	      } else {
	        that.state.tmpAngle += that.xAngle;
	      }
	      that.ctx.clearRect(0, 0, that.mW, that.mH);
	      //画圈
	      that.ctx.beginPath();
	      that.ctx.lineWidth = 9;
	      that.ctx.strokeStyle = '#1e2b49';
	      that.ctx.arc(that.r, that.r, that.cR, that.state.startAngle, that.state.tmpAngle);
	      that.ctx.stroke();
	      that.ctx.closePath();
	      that.stop = requestAnimationFrame(that.canvasDraw.bind(that));
	    }
	  }, {
	    key: 'beginResponder',
	
	    /*开始*/
	    value: function beginResponder() {
	      var _this = this;
	
	      if (_TkConstant3['default'].hasRole.roleChairman || _TkConstant3['default'].hasRole.roleTeachingAssistant) {
	        if (this.state.beginIsStatus == false) {
	          this.canvasDraw();
	          this.state.responderShow = true;
	          this.state.beginIsStatus = true;
	          clearTimeout(this.state.beginTimeOut);
	          this.state.beginTimeOut = setTimeout(function () {
	            _this.state.closeImg = "block";
	            _this.state.restartImg = "block";
	            _this.setState({ closeImg: _this.state.closeImg, restartImg: _this.state.restartImg });
	            if (_this.state.firstUser == false) {
	              _this.state.answerText = _TkGlobal2['default'].language.languageData.responder.noContest.text;
	              _this.setState({ answerText: _this.state.answerText });
	            }
	            var c = document.getElementById('myCanvas');
	            c.style.display = "none";
	          }, 8000);
	          var iconShow = this.state.responderShow;
	          var begin = this.state.beginIsStatus;
	          var userAdmin = this.state.userAdmin;
	          var data = {
	            isShow: iconShow,
	            begin: begin,
	            userAdmin: userAdmin
	          };
	          var isDelMsg = false;
	          _ServiceSignalling2['default'].sendSignallingQiangDaQi(isDelMsg, data);
	          this.state.answerText = _TkGlobal2['default'].language.languageData.responder.inAnswer.text;
	          this.setState({ answerText: this.state.answerText, responderShow: this.state.responderShow, beginTimeOut: this.state.beginTimeOut });
	        }
	      }
	    }
	  }, {
	    key: 'closeResponder',
	
	    /*close*/
	    value: function closeResponder() {
	      if (_TkConstant3['default'].hasRole.roleChairman || _TkConstant3['default'].hasRole.roleTeachingAssistant) {
	        var that = this;
	        var c = document.getElementById('myCanvas');
	        c.style.display = "none";
	        that.state.responderIsShow = "none";
	        that.state.beginIsStatus = false;
	        that.state.responderShow = false;
	        that.state.userSort = {};
	        that.state.userArry = [];
	        that.state.closeImg = "none";
	        that.state.restartImg = "none";
	        that.state.answerText = _TkGlobal2['default'].language.languageData.responder.begin.text;
	        that.setState({
	          closeImg: that.state.closeImg,
	          restartImg: that.state.restartImg,
	          answerText: that.state.answerText,
	          responderIsShow: that.state.responderIsShow,
	          beginIsStatus: that.state.beginIsStatus,
	          responderShow: that.state.responderShow
	        });
	        var data = {
	          isShow: false
	        };
	        var isDelMsg = true;
	        _ServiceSignalling2['default'].sendSignallingQiangDaQi(isDelMsg, data);
	        that.clearCanvasData();
	        //初始化拖拽元素的位置
	        var id = this.props.id;
	
	        this.state[id].left = 4.4;
	        this.state[id].top = 0;
	        this.setState(_defineProperty({}, id, this.state[id]));
	      }
	    }
	  }, {
	    key: 'restartResponder',
	
	    /*restart*/
	    value: function restartResponder() {
	      if (_TkConstant3['default'].hasRole.roleChairman || _TkConstant3['default'].hasRole.roleTeachingAssistant) {
	        this.clearCanvasData();
	        var c = document.getElementById('myCanvas');
	        c.style.display = "block";
	        this.state.closeImg = "none";
	        this.state.restartImg = "none";
	        this.state.answerText = _TkGlobal2['default'].language.languageData.responder.begin.text;
	        this.state.beginIsStatus = false;
	        this.state.responderShow = true;
	        this.state.firstUser = false;
	        this.state.userSort = {};
	        this.state.userArry = [];
	        this.setState({
	          firstUser: this.state.firstUser,
	          responderShow: this.state.responderShow,
	          beginIsStatus: this.state.beginIsStatus,
	          userSort: this.state.userSort,
	          userArry: this.state.userArry
	        });
	        var iconShow = this.state.responderShow;
	        var begin = this.state.beginIsStatus;
	        var userAdmin = this.state.userAdmin;
	        var data = {
	          isShow: iconShow,
	          begin: begin,
	          userAdmin: userAdmin
	        };
	        var isDelMsg = true;
	        _ServiceSignalling2['default'].sendSignallingQiangDaQi(isDelMsg, data);
	        isDelMsg = false;
	        _ServiceSignalling2['default'].sendSignallingQiangDaQi(isDelMsg, data);
	        this.setState({
	          beginIsStatus: this.state.beginIsStatus,
	          startAngle: this.state.startAngle,
	          tmpAngle: this.state.tmpAngle,
	          closeImg: this.state.closeImg,
	          restartImg: this.state.restartImg
	        });
	      }
	    }
	  }, {
	    key: 'clearCanvasData',
	
	    /*清除canvas画布数据*/
	    value: function clearCanvasData() {
	      var c = document.getElementById('myCanvas');
	      var ctx = c.getContext('2d');
	      var mW = c.width = 300;
	      var mH = c.height = 300;
	      ctx.clearRect(0, 0, mW, mH);
	      window.cancelAnimationFrame(this.state.stop);
	      this.state.startAngle = -(1 / 2 * Math.PI); //开始角度
	      this.endAngle = this.state.startAngle + 2 * Math.PI; //结束角度
	      this.xAngle = 0.4 * (Math.PI / 180); //偏移角度量
	      this.fontSize = 35; //字号大小
	      this.state.tmpAngle = this.state.startAngle; //临时角度变量
	    }
	  }, {
	    key: 'handlerOnStartDrag',
	    value: function handlerOnStartDrag(e, dragData) {
	      //开始拖拽
	      var that = this;
	      var id = that.props.id;
	
	      var defalutFontSize = window.innerWidth / _TkConstant3['default'].STANDARDSIZE;
	      that.state[id].offsetX = dragData.x / defalutFontSize - that.state[id].left;
	      that.state[id].offsetY = dragData.y / defalutFontSize - that.state[id].top;
	    }
	  }, {
	    key: 'handlerOnDragging',
	    value: function handlerOnDragging(e, dragData) {
	      //拖拽中
	      var that = this;
	      var id = that.props.id;
	
	      var defalutFontSize = window.innerWidth / _TkConstant3['default'].STANDARDSIZE;
	      // 触摸点相对白板区的位置-触摸点相对触摸元素边界的位置：
	      that.state[id].left = dragData.x / defalutFontSize - that.state[id].offsetX;
	      that.state[id].top = dragData.y / defalutFontSize - that.state[id].offsetY;
	      var dragEleId = id; //拖拽的元素
	      var boundsEleId = 'tk_app'; //控制拖拽边界的元素
	      that.state[id] = _TkUtils2['default'].controlDragBounds(that, dragEleId, boundsEleId);
	      that.setState(_defineProperty({}, id, that.state[id]));
	    }
	  }, {
	    key: 'handlerOnStopDrag',
	    value: function handlerOnStopDrag(e, dragData) {
	      //拖拽结束
	      var that = this;
	      var id = that.props.id;
	
	      that.state[id].offsetX = 0;
	      that.state[id].offsetY = 0;
	      if (_TkConstant3['default'].hasRole.roleChairman || _TkConstant3['default'].hasRole.roleTeachingAssistant) {
	        var _that$state$id = that.state[id];
	        var left = _that$state$id.left;
	        var _top = _that$state$id.top;
	
	        var _TkUtils$RemChangeToPercentage = _TkUtils2['default'].RemChangeToPercentage(that, left, _top, id);
	
	        var percentLeft = _TkUtils$RemChangeToPercentage.percentLeft;
	        var percentTop = _TkUtils$RemChangeToPercentage.percentTop;
	
	        this[id] = {
	          percentLeft: percentLeft,
	          percentTop: percentTop
	        };
	        var data = {
	          percentLeft: that[id].percentLeft,
	          percentTop: that[id].percentTop,
	          isDrag: true
	        };
	        _ServiceSignalling2['default'].sendSignallingFromResponderDrag(data);
	      }
	    }
	  }, {
	    key: 'render',
	    value: function render() {
	      var that = this;
	      var id = that.props.id;
	
	      var draggableData = {
	        onStart: that.handlerOnStartDrag.bind(that), //开始拖拽
	        onDrag: that.handlerOnDragging.bind(that), //拖拽中
	        onStop: that.handlerOnStopDrag.bind(that) };
	      //拖拽结束
	      var responderDragStyle = {
	        position: 'absolute',
	        zIndex: 110,
	        display: this.state.responderIsShow,
	        transitionProperty: this.isHasTransition ? 'left,top' : undefined,
	        transitionDuration: this.isHasTransition ? '0.5s' : undefined,
	        left: this.state[id].left + 'rem',
	        top: this.state[id].top + 'rem'
	      };
	      return _react2['default'].createElement(
	        _reactDraggable.DraggableCore,
	        draggableData,
	        _react2['default'].createElement(
	          'div',
	          { id: id, className: 'responder-circle', style: responderDragStyle },
	          _react2['default'].createElement(
	            'canvas',
	            { id: 'myCanvas' },
	            _TkGlobal2['default'].language.languageData.responder.update.text
	          ),
	          _react2['default'].createElement('div', { className: 'myCanvas-bg-div' }),
	          _react2['default'].createElement('div', { className: 'responder-black-circle' }),
	          _react2['default'].createElement(
	            'div',
	            { className: "responder-begin-circle" + " " + (this.state.beginIsStatus ? 'disabled' : ''), onTouchStart: this.beginResponder.bind(this) },
	            this.state.answerText
	          ),
	          _react2['default'].createElement(
	            'div',
	            { className: 'responder-close-img', onTouchStart: this.closeResponder.bind(this), style: { display: this.state.closeImg } },
	            _TkGlobal2['default'].language.languageData.responder.close.text
	          ),
	          _react2['default'].createElement(
	            'div',
	            { className: 'responder-restart-img', onTouchStart: this.restartResponder.bind(this), style: { display: this.state.restartImg } },
	            _TkGlobal2['default'].language.languageData.responder.restart.text
	          )
	        )
	      );
	    }
	  }]);
	
	  return ResponderTeachingToolSmart;
	})(_react2['default'].Component);
	
	exports['default'] = ResponderTeachingToolSmart;
	module.exports = exports['default'];

/***/ }),

/***/ 268:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 右侧内容-教学工具箱 Smart组件
	 * @module timerTeachingToolComponent
	 * @description   倒计时组件
	 * @author liujianhang
	 * @date 2017/09/20
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
		value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(42);
	
	var _reactDom2 = _interopRequireDefault(_reactDom);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var TimerStudentToolSmart = (function (_React$Component) {
		_inherits(TimerStudentToolSmart, _React$Component);
	
		function TimerStudentToolSmart(props) {
			_classCallCheck(this, TimerStudentToolSmart);
	
			_get(Object.getPrototypeOf(TimerStudentToolSmart.prototype), 'constructor', this).call(this, props);
	
			this.state = {
				hoursDiv: "",
				secondsDiv: "",
				number: "",
				timeDescArray: [],
				triangleStyles: "",
				numContentBorder: "",
				timerTeachToolWrapDisplay: "none",
				studentInit: false,
				startAndStop: false,
				restarting: false,
				startAndStopImg: "none",
				servicerTimes: '',
				ado: "none"
			};
			this.stop = null;
			this.listernerBackupid = new Date().getTime() + '_' + Math.random();
		}
	
		_createClass(TimerStudentToolSmart, [{
			key: 'componentDidMount',
			value: function componentDidMount() {
				//在完成首次渲染之前调用，此时仍可以修改组件的state
				var that = this;
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //roomPubmsg事件
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //roomDelmsg事件
				_eventObjectDefine2['default'].CoreController.addEventListener("initAppPermissions", that.handlerInitAppPermissions.bind(that), that.listernerBackupid); //initAppPermissions：白板可画权限更新
				_eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-timer", that.handlerMsglistTimerShow.bind(that), that.listernerBackupid);
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPlaybackClearAllFromPlaybackController, that.handlerRoomPlaybackClearAll.bind(that), that.listernerBackupid); //roomPlaybackClearAll 事件：回放清除所有信令
			}
		}, {
			key: 'handlerRoomPubmsg',
			value: function handlerRoomPubmsg(recvEventData) {
				var that = this;
				var pubmsgData = recvEventData.message;
				that.state.servicerTimes = _TkGlobal2['default'].serviceTime;
				that.setState({
					servicerTimes: that.state.servicerTimes
				});
	
				switch (pubmsgData.name) {
					case "timer":
						if (_TkConstant2['default'].hasRole.roleStudent) {
							that.handleTimerShow(pubmsgData);
						}
						break;
	
				}
			}
		}, {
			key: 'handlerRoomDelmsg',
			value: function handlerRoomDelmsg(recvEventData) {
				var that = this;
				var pubmsgData = recvEventData.message;
				switch (pubmsgData.name) {
					case "timer":
	
						clearInterval(that.stop);
						that.state.startAndStopImg = "none";
						that.state.timeDescArray = [0, 5, 0, 0];
						that.state.timerTeachToolWrapDisplay = "none";
						that.setState({
							timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay,
							startAndStopImg: that.state.startAndStopImg,
							timeDescArray: that.state.timeDescArray
						});
						break;
	
					case "ClassBegin":
						that.state.timerTeachToolWrapDisplay = "none";
						that.setState({ timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay });
						break;
	
				}
			}
		}, {
			key: 'handlerMsglistTimerShow',
			value: function handlerMsglistTimerShow(recvEventData) {
				var that = this;
				var message = recvEventData.message.timerShowArr[0];
				if (_TkConstant2['default'].hasRole.roleStudent) {
					that.handleTimerShow(message);
				}
			}
		}, {
			key: 'handleTimerShow',
			value: function handleTimerShow(pubmsgData) {
				if (pubmsgData.data.isShow) {
					return false;
				}
				var that = this;
				var serviceTimeData = _TkGlobal2['default'].serviceTime / 1000 - pubmsgData.ts;
				that.state.timerTeachToolWrapDisplay = "block";
				that.state.timeDescArray = pubmsgData.data.sutdentTimerArry;
				that.setState({
					timeDescArray: that.state.timeDescArray,
					timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay
				});
				var timeArrAdd = that.state.timeDescArray[0] * 600 + that.state.timeDescArray[1] * 60 + that.state.timeDescArray[2] * 10 + that.state.timeDescArray[3] * 1;
				var timesValue = timeArrAdd - serviceTimeData;
				if (pubmsgData.data.isStatus) {
					clearInterval(that.stop);
					that.state.numContentBorder = 'black';
					that.state.startAndStopImg = "none";
					that.setState({
						startAndStopImg: that.state.startAndStopImg,
						numContentBorder: that.state.numContentBorder
					});
					that.stop = setInterval(that.timeReduce.bind(that), 1000);
					if (timesValue > 0) {
						if (timesValue > timeArrAdd) {
							timesValue = timeArrAdd;
						}
						var m = parseInt(timesValue / 60) < 10 ? '0' + parseInt(timesValue / 60) : parseInt(timesValue / 60);
						var n = parseInt(timesValue % 60) < 10 ? '0' + parseInt(timesValue % 60) : parseInt(timesValue % 60);
	
						that.state.timeDescArray[0] = m.substring(0, 1);
						that.state.timeDescArray[1] = m.substring(1);
						that.state.timeDescArray[2] = parseInt(n / 10);
						that.state.timeDescArray[3] = parseInt(n % 10);
	
						that.setState({
							timeDescArray: that.state.timeDescArray
						});
					} else {
						clearInterval(that.stop);
						that.state.timeDescArray[0] = 0;
						that.state.timeDescArray[1] = 0;
						that.state.timeDescArray[2] = 0;
						that.state.timeDescArray[3] = 0;
						that.state.numContentBorder = 'red';
						that.state.startAndStopImg = "block";
						that.setState({
							timeDescArray: that.state.timeDescArray,
							numContentBorder: that.state.numContentBorder,
							startAndStopImg: that.state.startAndStopImg
						});
					}
				} else {
					that.state.timeDescArray = pubmsgData.data.sutdentTimerArry;
					that.setState({
						timeDescArray: that.state.timeDescArray
					});
					that.state.startAndStopImg = "block";
					that.state.numContentBorder = 'black';
					that.setState({
						startAndStopImg: that.state.startAndStopImg,
						numContentBorder: that.state.numContentBorder
					});
					clearInterval(that.stop);
				}
			}
		}, {
			key: 'handlerInitAppPermissions',
			value: function handlerInitAppPermissions() {
				this.state.studentInit = _CoreController2['default'].handler.getAppPermissions('studentInit');
				this.setState({
					studentInit: this.state.studentInit
				});
				if (this.state.studentInit == false) {
					this.state.triangleStyles = "hidden";
					this.state.againStuBtnStyle = "none";
					this.state.startStuBtnStyle = "none";
					this.state.startAndStopImg = "none";
					this.setState({
						triangleStyle: this.state.triangleStyles,
						againStuBtnStyle: this.state.againStuBtnStyle,
						startStuBtnStyle: this.state.startStuBtnStyle,
						startAndStopImg: this.state.startAndStopImg
					});
				}
			}
		}, {
			key: 'handlerRoomPlaybackClearAll',
			value: function handlerRoomPlaybackClearAll() {
				if (!_TkGlobal2['default'].playback) {
					L.Logger.error('No playback environment, no execution event[roomPlaybackClearAll] handler ');return;
				};
				var that = this;
				that.setState({
					hoursDiv: "",
					secondsDiv: "",
					number: "",
					timeDescArray: [],
					triangleStyles: "",
					numContentBorder: "",
					timerTeachToolWrapDisplay: "none",
					studentInit: false,
					startAndStop: false,
					restarting: false,
					startAndStopImg: "none",
					servicerTimes: ''
				});
				this.stop = null;
			}
		}, {
			key: '_loadTimeDescArrays',
	
			/*内部方法*/
			value: function _loadTimeDescArrays(desc) {
				var _this = this;
	
				var beforeArrays = [];
				var afterArrays = [];
				desc.forEach(function (value, index) {
					var a = _react2['default'].createElement(
						'div',
						{ className: 'timer-teachTool-num-divs', key: index },
						_react2['default'].createElement('div', { className: 'timer-teachTool-triangle-tops', style: { visibility: _this.state.triangleStyles } }),
						_react2['default'].createElement(
							'div',
							{ className: 'timer-teachTool-num-contents', style: { color: _this.state.numContentBorder } },
							value
						),
						_react2['default'].createElement('div', { className: 'timer-teachTool-triangle-downs', style: { visibility: _this.state.triangleStyles } })
					);
					if (index > 1) {
						afterArrays.push(a);
					} else {
						beforeArrays.push(a);
					}
				});
				return {
					afterArrays: afterArrays,
					beforeArrays: beforeArrays
				};
			}
		}, {
			key: 'timeReduce',
	
			/*倒计时*/
			value: function timeReduce() {
				var that = this;
				that.state.timeDescArray[3]--;
	
				if (that.state.timeDescArray[3] < 0) {
					that.state.timeDescArray[3] = 9;
					that.state.timeDescArray[2]--;
				}
				if (that.state.timeDescArray[2] < 0) {
					that.state.timeDescArray[2] = 5;
					that.state.timeDescArray[1]--;
				}
				if (that.state.timeDescArray[1] < 0) {
					that.state.timeDescArray[1] = 9;
					that.state.timeDescArray[0]--;
				}if (that.state.timeDescArray[0] < 0) {
					that.state.timeDescArray = [0, 0, 0, 0];
					that.state.numContentBorder = 'red';
					clearInterval(that.stop);
					that.playAudioToAudiooutput();
				}
				if (that.state.timeDescArray[0] == 0 && that.state.timeDescArray[1] == 0 && that.state.timeDescArray[2] == 0 && that.state.timeDescArray[3] == 0) {
					that.state.timeDescArray = [0, 0, 0, 0];
					that.playAudioToAudiooutput();
					that.state.numContentBorder = 'red';
					clearInterval(that.stop);
				}
	
				that.setState({
					timeDescArray: that.state.timeDescArray,
					numContentBorder: that.state.numContentBorder
				});
			}
		}, {
			key: 'playAudioToAudiooutput',
	
			/*播放音乐*/
			value: function playAudioToAudiooutput() {
				var audioStudent = document.getElementById('ring_audio_student');
				if (audioStudent) {
					try {
						audioStudent.play();
					} catch (e) {
						L.Logger.info('element id is audioStudent play() is error!');
					}
				}
			}
		}, {
			key: 'render',
			value: function render() {
				var timeDescArray = this.state.timeDescArray;
	
				var _loadTimeDescArrays2 = this._loadTimeDescArrays(timeDescArray);
	
				var afterArrays = _loadTimeDescArrays2.afterArrays;
				var beforeArrays = _loadTimeDescArrays2.beforeArrays;
	
				return _react2['default'].createElement(
					'div',
					{ className: 'timer-teachTool-wraps', style: { display: this.state.timerTeachToolWrapDisplay }, ref: 'timerTeachToolWrap' },
					_react2['default'].createElement(
						'div',
						{ className: 'timer-teachTool-headers' },
						_react2['default'].createElement('span', null),
						_react2['default'].createElement(
							'span',
							null,
							_TkGlobal2['default'].language.languageData.timers.timerSetInterval.text
						),
						_react2['default'].createElement('span', { className: 'timer-teachTool-closeSpans' })
					),
					beforeArrays,
					_react2['default'].createElement(
						'div',
						{ className: 'timer-teachTool-colons' },
						_react2['default'].createElement('div', null),
						_react2['default'].createElement('div', null)
					),
					afterArrays,
					_react2['default'].createElement('div', { className: 'stop-btn-Imgs', style: { display: this.state.startAndStopImg } }),
					_react2['default'].createElement('audio', { id: 'ring_audio_student', preload: 'auto', src: "./music/ring.mp3?ts=" + this.listernerBackupid, className: 'audio-play' })
				);
			}
		}]);
	
		return TimerStudentToolSmart;
	})(_react2['default'].Component);
	
	exports['default'] = TimerStudentToolSmart;
	module.exports = exports['default'];

/***/ }),

/***/ 269:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 右侧内容-教学工具箱 Smart组件
	 * @module timerTeachingToolComponent
	 * @description   倒计时组件
	 * @author liujianhang
	 * @date 2017/09/20
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
		value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(42);
	
	var _reactDom2 = _interopRequireDefault(_reactDom);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _timerStudentToolComponent = __webpack_require__(268);
	
	var _timerStudentToolComponent2 = _interopRequireDefault(_timerStudentToolComponent);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _reactDraggable = __webpack_require__(58);
	
	var _reactDraggable2 = _interopRequireDefault(_reactDraggable);
	
	var TimerTeachingToolSmart = (function (_React$Component) {
		_inherits(TimerTeachingToolSmart, _React$Component);
	
		function TimerTeachingToolSmart(props) {
			_classCallCheck(this, TimerTeachingToolSmart);
	
			_get(Object.getPrototypeOf(TimerTeachingToolSmart.prototype), 'constructor', this).call(this, props);
			var id = this.props.id;
	
			this.state = _defineProperty({
				hoursDiv: "",
				secondsDiv: "",
				number: "",
				timeDescArray: [0, 5, 0, 0],
				triangleStyle: "",
				againBtnStyle: "",
				startBtnStyle: "",
				numContentBorder: "",
				timerTeachToolWrapDisplay: "none",
				timerStuStyle: "",
				restarting: false,
				studentInit: false,
				startAndStop: false,
				startAndStopImg: "none",
				isShow: false,
				againUnClickableStyle: "block"
			}, id, {
				left: 6.6,
				top: 0,
				offsetX: 0,
				offsetY: 0
			});
			this.stop = null;
			this.isHasTransition = false;
			this[id] = {}; //保存位置的百分比
			this.listernerBackupid = new Date().getTime() + '_' + Math.random();
		}
	
		_createClass(TimerTeachingToolSmart, [{
			key: 'componentDidMount',
			value: function componentDidMount() {
				//在完成首次渲染之前调用，此时仍可以修改组件的state
				var that = this;
				_eventObjectDefine2['default'].Window.addEventListener(_TkConstant2['default'].EVENTTYPE.WindowEvent.onResize, that.handlerOnResize.bind(that), that.listernerBackupid); //window.resize事件
				_eventObjectDefine2['default'].CoreController.addEventListener('handleTurnShow', that.handleTurnShow.bind(that), that.listernerBackupid);
				_eventObjectDefine2['default'].CoreController.addEventListener("initAppPermissions", that.handlerInitAppPermissions.bind(that), that.listernerBackupid); //initAppPermissions：白板可画权限更新
				_eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-timer", that.handlerMsglistTimerShow.bind(that), that.listernerBackupid);
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //roomPubmsg事件
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomDelmsg, that.handlerRoomDelmsg.bind(that), that.listernerBackupid); //roomDelmsg事件
				_eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPlaybackClearAllFromPlaybackController, that.handlerRoomPlaybackClearAll.bind(that), that.listernerBackupid); //roomPlaybackClearAll 事件：回放清除所有信令
				_eventObjectDefine2['default'].CoreController.addEventListener("receive-msglist-TimerDrag", that.handlerMsglistTimerDrag.bind(that), that.listernerBackupid);
			}
		}, {
			key: 'componentDidUpdate',
			value: function componentDidUpdate() {
				//每次render结束后会触发,每次转过之后去除过度效果
				if (this.isHasTransition == true) {
					this.isHasTransition = false;
				}
			}
		}, {
			key: 'handlerOnResize',
			value: function handlerOnResize() {
				var that = this;
				var id = this.props.id;
	
				if (Object.keys(that[id]).length !== 0) {
					var _that$id = that[id];
					var percentLeft = _that$id.percentLeft;
					var percentTop = _that$id.percentTop;
	
					_TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
					this.setState(_defineProperty({}, id, this.state[id]));
				}
			}
		}, {
			key: 'handlerRoomPubmsg',
			value: function handlerRoomPubmsg(recvEventData) {
				var that = this;
				var pubmsgData = recvEventData.message;
	
				switch (pubmsgData.name) {
					case "timer":
						if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol) {
							that.handleTimerShow(pubmsgData);
						}
						break;
					case 'TimerDrag':
						//计时器的拖拽
						var id = that.props.id;
	
						this.isHasTransition = true;
						var _pubmsgData$data = pubmsgData.data,
						    percentLeft = _pubmsgData$data.percentLeft,
						    percentTop = _pubmsgData$data.percentTop;
	
						this[id] = {
							percentLeft: percentLeft,
							percentTop: percentTop
						};
						_TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
						this.setState(_defineProperty({}, id, this.state[id]));
						break;
				}
			}
		}, {
			key: 'handlerRoomDelmsg',
			value: function handlerRoomDelmsg(recvEventData) {
				var that = this;
				var pubmsgData = recvEventData.message;
	
				switch (pubmsgData.name) {
					case "ClassBegin":
	
						that.state.timerTeachToolWrapDisplay = "none";
						that.setState({ timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay });
						break;
					case "timer":
	
						clearInterval(that.stop);
						that.state.startAndStopImg = "none";
						that.state.timeDescArray = [0, 5, 0, 0];
						that.state.timerTeachToolWrapDisplay = "none";
						that.setState({
							timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay,
							startAndStopImg: that.state.startAndStopImg,
							timeDescArray: that.state.timeDescArray
						});
						break;
				}
			}
		}, {
			key: 'handlerMsglistTimerShow',
			value: function handlerMsglistTimerShow(recvEventData) {
				var that = this;
				var message = recvEventData.message.timerShowArr[0];
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant || _TkConstant2['default'].hasRole.rolePatrol) {
					that.handleTimerShow(message);
				}
			}
		}, {
			key: 'handlerMsglistTimerDrag',
			value: function handlerMsglistTimerDrag(handleData) {
				var _this = this;
	
				//msglist,计时器的拖拽位置
				var TimerDragInfo = handleData.message.TimerDragArray;
				var that = this;
				var id = that.props.id;
	
				TimerDragInfo.map(function (item, index) {
					var _item$data = item.data;
					var percentLeft = _item$data.percentLeft;
					var percentTop = _item$data.percentTop;
	
					_this[id] = {
						percentLeft: percentLeft,
						percentTop: percentTop
					};
					_TkUtils2['default'].percentageChangeToRem(that, percentLeft, percentTop, id);
					that.setState(_defineProperty({}, id, that.state[id]));
				});
			}
		}, {
			key: 'handleTimerShow',
			value: function handleTimerShow(pubmsgData) {
				var that = this;
				var serviceTimeData = _TkGlobal2['default'].serviceTime / 1000 - pubmsgData.ts;
				that.state.timeDescArray = pubmsgData.data.sutdentTimerArry;
				var timeArrAdd = that.state.timeDescArray[0] * 600 + that.state.timeDescArray[1] * 60 + that.state.timeDescArray[2] * 10 + that.state.timeDescArray[3] * 1;
				var timesValue = timeArrAdd - serviceTimeData;
				if (pubmsgData.data.isShow) {
					that.state.startBtnStyle = "block";
					that.state.timerTeachToolWrapDisplay = "block";
					that.state.againBtnStyle = "none";
					that.state.numContentBorder = 'black';
					that.state.againUnClickableStyle = "block";
					that.state.startAndStopImg = "none";
					that.state.triangleStyle = "visible";
					that.setState({
						timeDescArray: that.state.timeDescArray,
						timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay,
						againUnClickableStyle: that.state.againUnClickableStyle,
						startBtnStyle: that.state.startBtnStyle,
						startAndStopImg: that.state.startAndStopImg
					});
				} else {
	
					if (pubmsgData.data.isStatus) {
						clearInterval(that.stop);
						that.state.againBtnStyle = "block";
						that.state.startBtnStyle = "none";
						that.state.againUnClickableStyle = "none";
						that.state.timerTeachToolWrapDisplay = "block";
						that.state.numContentBorder = 'black';
						that.state.triangleStyle = "hidden";
						that.state.startAndStopImg = "block";
						that.setState({
							startAndStopImg: that.state.startAndStopImg,
							timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay,
							startBtnStyle: that.state.startBtnStyle,
							numContentBorder: that.state.numContentBorder,
							againBtnStyle: that.state.againBtnStyle,
							triangleStyle: that.state.triangleStyle,
							againUnClickableStyle: that.state.againUnClickableStyle
						});
						that.stop = setInterval(that.timeReduce.bind(that), 1000);
						if (timesValue > 0) {
							if (timesValue > timeArrAdd) {
								timesValue = timeArrAdd;
							}
							var m = parseInt(timesValue / 60) < 10 ? '0' + parseInt(timesValue / 60) : parseInt(timesValue / 60);
							var n = parseInt(timesValue % 60) < 10 ? '0' + parseInt(timesValue % 60) : parseInt(timesValue % 60);
	
							that.state.timeDescArray[0] = m.substring(0, 1);
							that.state.timeDescArray[1] = m.substring(1);
							that.state.timeDescArray[2] = parseInt(n / 10);
							that.state.timeDescArray[3] = parseInt(n % 10);
	
							that.setState({
								timeDescArray: that.state.timeDescArray
							});
						} else {
							clearInterval(that.stop);
							that.state.timeDescArray[0] = 0;
							that.state.timeDescArray[1] = 0;
							that.state.timeDescArray[2] = 0;
							that.state.timeDescArray[3] = 0;
							that.state.numContentBorder = 'red';
							that.setState({
								timeDescArray: that.state.timeDescArray,
								numContentBorder: that.state.numContentBorder
							});
						}
					} else {
						if (pubmsgData.data.isRestart) {
							that.state.timeDescArray = pubmsgData.data.sutdentTimerArry;
							that.state.againUnClickableStyle = "block";
							that.state.timerTeachToolWrapDisplay = "block";
							that.state.startBtnStyle = "block";
							that.state.againBtnStyle = "none";
							that.state.triangleStyle = "visible";
							that.state.startAndStop = false;
							that.state.numContentBorder = 'black';
							that.state.startAndStopImg = "none";
							that.setState({
								timeDescArray: that.state.timeDescArray,
								timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay,
								numContentBorder: that.state.numContentBorder,
								startAndStopImg: that.state.startAndStopImg,
								startBtnStyle: that.state.startBtnStyle,
								againBtnStyle: that.state.againBtnStyle,
								triangleStyle: that.state.triangleStyle,
								startAndStop: that.state.startAndStop,
								againUnClickableStyle: that.state.againUnClickableStyle
							});
						} else {
							that.state.timeDescArray = pubmsgData.data.sutdentTimerArry;
							that.state.startBtnStyle = "block";
							that.state.againBtnStyle = "block";
							that.state.againUnClickableStyle = "none";
							that.state.timerTeachToolWrapDisplay = "block";
							that.state.triangleStyle = "hidden";
							that.state.startAndStop = false;
							that.state.numContentBorder = 'black';
							that.state.startAndStopImg = "none";
							that.setState({
								timeDescArray: that.state.timeDescArray,
								timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay,
								numContentBorder: that.state.numContentBorder,
								startAndStopImg: that.state.startAndStopImg,
								startBtnStyle: that.state.startBtnStyle,
								againBtnStyle: that.state.againBtnStyle,
								triangleStyle: that.state.triangleStyle,
								startAndStop: that.state.startAndStop,
								againUnClickableStyle: that.state.againUnClickableStyle
							});
							clearInterval(that.stop);
						}
					}
				}
			}
		}, {
			key: 'handleTurnShow',
			value: function handleTurnShow(data) {
				var that = this;
				if (data.className == "timer-implement-bg") {
					if (that.state.timerTeachToolWrapDisplay == "none") {
						that.state.startBtnStyle = "block";
						that.state.againBtnStyle = "none";
						that.state.startAndStopImg = "none";
						that.state.triangleStyle = "visible";
						that.state.timerTeachToolWrapDisplay = "block";
						that.state.againUnClickableStyle = "block";
						that.state.startAndStop = false;
						that.state.numContentBorder = 'black';
						clearInterval(that.stop);
						that.state.timeDescArray = [0, 5, 0, 0];
						that.setState({ timerTeachToolWrapDisplay: that.state.timerTeachToolWrapDisplay, startAndStop: that.state.startAndStop,
							startBtnStyle: that.state.startBtnStyle, againBtnStyle: that.state.againBtnStyle, triangleStyle: that.state.triangleStyle,
							numContentBorder: that.state.numContentBorder, timeDescArray: that.state.timeDescArray, againUnClickableStyle: that.state.againUnClickableStyle,
							startAndStopImg: that.state.startAndStopImg });
					}
				}
			}
	
			/*权限*/
		}, {
			key: 'handlerInitAppPermissions',
			value: function handlerInitAppPermissions() {
				this.state.studentInit = _CoreController2['default'].handler.getAppPermissions('studentInit');
				this.setState({
					studentInit: this.state.studentInit
				});
				if (this.state.studentInit) {
					this.state.triangleStyle = "visible";
					this.state.againBtnStyle = "none";
					this.state.againUnClickableStyle = "block";
					this.state.startBtnStyle = "block";
					this.state.startAndStopImg = "none";
					this.setState({
						triangleStyle: this.state.triangleStyles,
						againStuBtnStyle: this.state.againStuBtnStyle,
						startStuBtnStyle: this.state.startStuBtnStyle,
						startAndStopImg: this.state.startAndStopImg,
						againUnClickableStyle: this.state.againUnClickableStyle
					});
				}
			}
		}, {
			key: 'handlerRoomPlaybackClearAll',
			value: function handlerRoomPlaybackClearAll() {
				if (!_TkGlobal2['default'].playback) {
					L.Logger.error('No playback environment, no execution event[roomPlaybackClearAll] handler ');return;
				};
				var that = this;
				that.setState({
					hoursDiv: "",
					secondsDiv: "",
					number: "",
					timeDescArray: [0, 5, 0, 0],
					triangleStyle: "",
					againBtnStyle: "",
					startBtnStyle: "",
					numContentBorder: "",
					timerTeachToolWrapDisplay: "none",
					timerStuStyle: "",
					restarting: false,
					studentInit: false,
					startAndStop: false,
					startAndStopImg: "none",
					isShow: false,
					againUnClickableStyle: "block"
				});
				this.stop = null;
			}
		}, {
			key: '_loadTimeDescArray',
	
			/*内部方法*/
			value: function _loadTimeDescArray(desc) {
				var _this2 = this;
	
				var beforeArray = [];
				var afterArray = [];
				desc.forEach(function (value, index) {
					var a = _react2['default'].createElement(
						'div',
						{ className: 'timer-teachTool-num-div', key: index },
						_react2['default'].createElement('div', { className: 'timer-teachTool-triangle-top', style: { visibility: _this2.state.triangleStyle }, onTouchStart: _this2.AddHandel.bind(_this2, index) }),
						_react2['default'].createElement(
							'div',
							{ className: 'timer-teachTool-num-content', style: { color: _this2.state.numContentBorder } },
							value
						),
						_react2['default'].createElement('div', { className: 'timer-teachTool-triangle-down', style: { visibility: _this2.state.triangleStyle }, onTouchStart: _this2.ReduceHandel.bind(_this2, index) })
					);
					if (index > 1) {
						afterArray.push(a);
					} else {
						beforeArray.push(a);
					}
				});
				return {
					afterArray: afterArray,
					beforeArray: beforeArray
				};
			}
		}, {
			key: 'AddHandel',
	
			/*手动增加*/
			value: function AddHandel(index, e) {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					if (index === 0) {
						e.target.nextSibling.textContent++;
						this.state.timeDescArray[0] = e.target.nextSibling.textContent;
						if (e.target.nextSibling.textContent > 9) {
							e.target.nextSibling.textContent = 0;
							this.state.timeDescArray[0] = e.target.nextSibling.textContent;
						}
					}
					if (index === 1) {
						e.target.nextSibling.textContent++;
						this.state.timeDescArray[1] = e.target.nextSibling.textContent;
						if (e.target.nextSibling.textContent > 9) {
							e.target.nextSibling.textContent = 0;
							this.state.timeDescArray[1] = e.target.nextSibling.textContent;
						}
					}
					if (index === 2) {
						e.target.nextSibling.textContent++;
						this.state.timeDescArray[2] = e.target.nextSibling.textContent;
						if (e.target.nextSibling.textContent > 5) {
							e.target.nextSibling.textContent = 0;
							this.state.timeDescArray[2] = e.target.nextSibling.textContent;
						}
					}
					if (index === 3) {
						e.target.nextSibling.textContent++;
						this.state.timeDescArray[3] = e.target.nextSibling.textContent;
						if (e.target.nextSibling.textContent > 9) {
							e.target.nextSibling.textContent = 0;
							this.state.timeDescArray[3] = e.target.nextSibling.textContent = 0;
						}
					}
					this.setState({
						timeDescArray: this.state.timeDescArray
					});
				}
			}
		}, {
			key: 'ReduceHandel',
	
			/*手动减少*/
			value: function ReduceHandel(index, e) {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					if (index === 0) {
						e.target.previousSibling.textContent--;
						this.state.timeDescArray[0] = e.target.previousSibling.textContent;
						if (e.target.previousSibling.textContent < 0) {
							e.target.previousSibling.textContent = 9;
							this.state.timeDescArray[0] = e.target.previousSibling.textContent;
						}
					}
					if (index === 1) {
						e.target.previousSibling.textContent--;
						this.state.timeDescArray[1] = e.target.previousSibling.textContent;
						if (e.target.previousSibling.textContent < 0) {
							e.target.previousSibling.textContent = 9;
							this.state.timeDescArray[1] = e.target.previousSibling.textContent;
						}
					}
					if (index === 2) {
						e.target.previousSibling.textContent--;
						this.state.timeDescArray[2] = e.target.previousSibling.textContent;
						if (e.target.previousSibling.textContent < 0) {
							e.target.previousSibling.textContent = 5;
							this.state.timeDescArray[2] = e.target.previousSibling.textContent;
						}
					}
					if (index === 3) {
						e.target.previousSibling.textContent--;
						this.state.timeDescArray[3] = e.target.previousSibling.textContent;
						if (e.target.previousSibling.textContent < 0) {
							e.target.previousSibling.textContent = 9;
							this.state.timeDescArray[3] = e.target.previousSibling.textContent;
						}
					}
					this.setState({
						timeDescArray: this.state.timeDescArray
					});
				}
			}
		}, {
			key: 'startBtnHandel',
	
			/*开始*/
			value: function startBtnHandel(e) {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					clearInterval(this.stop);
					this.state.numContentBorder = 'black';
					this.state.startAndStop = true;
					this.state.restarting = false;
					this.setState({
						startAndStop: this.state.startAndStop,
						numContentBorder: this.state.numContentBorder,
						restarting: this.state.restarting
					});
					this.state.startBtnStyle = "none";
					this.state.startAndStopImg = "block";
					this.state.triangleStyle = "hidden";
					this.state.againBtnStyle = "block";
					this.state.againUnClickableStyle = "none";
					this.setState({ startAndStopImg: this.state.startAndStopImg, startBtnStyle: this.state.startBtnStyle, againBtnStyle: this.state.againBtnStyle, triangleStyle: this.state.triangleStyle, againUnClickableStyle: this.state.againUnClickableStyle });
					if (this.state.timeDescArray[0] === 0 && this.state.timeDescArray[1] === 0 && this.state.timeDescArray[2] === 0 && this.state.timeDescArray[3] === 0) {
						this.state.timeDescArray = [0, 0, 0, 0];
						this.state.numContentBorder = 'red';
						clearInterval(this.stop);
					}
					this.stop = setInterval(this.timeReduce.bind(this), 1000);
					var stopBtn = this.state.startAndStop;
					var dataTimerArry = this.state.timeDescArray;
					var iconShow = this.state.isShow;
					var isRestart = this.state.restarting;
					var data = {
						isStatus: stopBtn,
						sutdentTimerArry: dataTimerArry,
						isShow: iconShow,
						isRestart: isRestart
					};
					_ServiceSignalling2['default'].sendSignallingTimerToStudent(data);
				}
			}
		}, {
			key: 'stopBtnHandel',
	
			/*暂停*/
			value: function stopBtnHandel() {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					this.state.startAndStop = false;
					this.state.restarting = false;
					this.state.startAndStopImg = "none";
					this.state.triangleStyle = "hidden";
					this.state.startBtnStyle = "block";
					this.state.againUnClickableStyle = "none";
					this.state.againBtnStyle = "block";
					this.setState({ startAndStopImg: this.state.startAndStopImg, startBtnStyle: this.state.startBtnStyle, againBtnStyle: this.state.againBtnStyle, startAndStop: this.state.startAndStop, triangleStyle: this.state.triangleStyle, againUnClickableStyle: this.state.againUnClickableStyle });
					clearInterval(this.stop);
					var stopBtn = this.state.startAndStop;
					var iconShow = this.state.isShow;
					var dataTimerArry = this.state.timeDescArray;
					var isRestart = this.state.restarting;
					var data = {
						isStatus: stopBtn,
						sutdentTimerArry: dataTimerArry,
						isShow: iconShow,
						isRestart: isRestart
					};
					_ServiceSignalling2['default'].sendSignallingTimerToStudent(data);
				}
			}
		}, {
			key: 'firstArr',
			value: function firstArr() {
				var _this3 = this;
	
				this.handlersetAnswerMessage(recvEventData);
				this.state.optionUl = this.state.initArr.map(function (item, index) {
					return _react2['default'].createElement(
						'li',
						{ className: 'answer-teach-lis', key: item.id, onTouchStart: _this3.changeColor.bind(_this3, index) },
						item.name
					);
				});
				this.setState({
					optionUl: this.state.optionUl
				});
			}
	
			/*重新开始*/
		}, {
			key: 'againBtnHandel',
			value: function againBtnHandel(e) {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					this.state.numContentBorder = 'black';
					this.setState({
						numContentBorder: this.state.numContentBorder
					});
					this.state.restarting = true;
					this.state.startAndStop = false;
					this.state.triangleStyle = "visible";
					this.state.againBtnStyle = "none";
					this.state.startAndStopImg = "none";
					this.state.startBtnStyle = "block";
					this.state.againUnClickableStyle = "block";
					clearInterval(this.stop);
					this.state.numContentBorder = 'black';
					this.state.timeDescArray = [0, 5, 0, 0];
					this.setState({
						triangleStyle: this.state.triangleStyle,
						againBtnStyle: this.state.againBtnStyle,
						startBtnStyle: this.state.startBtnStyle,
						timeDescArray: this.state.timeDescArray,
						startAndStopImg: this.state.startAndStopImg,
						startAndStop: this.state.startAndStop,
						restarting: this.state.restarting,
						numContentBorder: this.state.numContentBorder,
						againUnClickableStyle: this.state.againUnClickableStyle
					});
					var stopBtn = this.state.startAndStop;
					var dataTimerArry = this.state.timeDescArray;
					var iconShow = this.state.isShow;
					var isRestart = this.state.restarting;
					var data = {
						isStatus: stopBtn,
						sutdentTimerArry: dataTimerArry,
						isShow: iconShow,
						isRestart: isRestart
					};
					_ServiceSignalling2['default'].sendSignallingTimerToStudent(data);
				}
			}
		}, {
			key: 'timeReduce',
	
			/*倒计时*/
			value: function timeReduce() {
				var that = this;
				that.state.timeDescArray[3]--;
	
				if (that.state.timeDescArray[3] < 0) {
					that.state.timeDescArray[3] = 9;
					that.state.timeDescArray[2]--;
				}
				if (that.state.timeDescArray[2] < 0) {
					that.state.timeDescArray[2] = 5;
					that.state.timeDescArray[1]--;
				}
				if (that.state.timeDescArray[1] < 0) {
					that.state.timeDescArray[1] = 9;
					that.state.timeDescArray[0]--;
				}if (that.state.timeDescArray[0] < 0) {
					that.state.timeDescArray = [0, 0, 0, 0];
					that.state.numContentBorder = 'red';
					that.state.startBtnStyle = "none";
					clearInterval(that.stop);
					that.playAudioToAudiooutput();
				}
				if (that.state.timeDescArray[0] == 0 && that.state.timeDescArray[1] == 0 && that.state.timeDescArray[2] == 0 && that.state.timeDescArray[3] == 0) {
					that.playAudioToAudiooutput();
					that.state.timeDescArray = [0, 0, 0, 0];
					that.state.numContentBorder = 'red';
					that.state.startBtnStyle = "none";
					clearInterval(that.stop);
				}
	
				that.setState({
					timeDescArray: that.state.timeDescArray,
					startBtnStyle: that.state.startBtnStyle,
					numContentBorder: that.state.numContentBorder
				});
			}
		}, {
			key: 'timerCloseHandel',
	
			/*关闭*/
			value: function timerCloseHandel() {
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					this.state.timeDescArray = [0, 5, 0, 0];
					this.state.triangleStyle = "visible";
					this.state.startAndStop = false;
					this.state.againBtnStyle = "none";
					this.state.startAndStopImg = "none";
					this.state.numContentBorder = 'black';
					this.state.againUnClickableStyle = "block";
					clearInterval(this.stop);
					this.setState({
						timeDescArray: this.state.timeDescArray,
						triangleStyle: this.state.triangleStyle,
						startAndStop: this.state.startAndStop,
						numContentBorder: this.state.numContentBorder,
						startAndStopImg: this.state.startAndStopImg,
						againBtnStyle: this.state.againBtnStyle,
						againUnClickableStyle: this.state.againUnClickableStyle
					});
					this.state.timerTeachToolWrapDisplay = "none";
					this.setState({
						timerTeachToolWrapDisplay: this.state.timerTeachToolWrapDisplay
					});
					var stopBtn = this.state.startAndStop;
					var iconShow = this.state.isShow;
					var dataTimerArry = this.state.timeDescArray;
					var data = {
						isStatus: stopBtn,
						sutdentTimerArry: dataTimerArry,
						isShow: iconShow
					};
					var isDelMsg = true;
					_ServiceSignalling2['default'].sendSignallingTimerToStudent(data, isDelMsg);
					//初始化拖拽元素的位置
					var id = this.props.id;
	
					this.state[id].left = 6.6;
					this.state[id].top = 0;
					this.setState(_defineProperty({}, id, this.state[id]));
				}
			}
		}, {
			key: 'playAudioToAudiooutput',
	
			/*播放音乐*/
			value: function playAudioToAudiooutput() {
				var audioElement = document.getElementById('ring_audio');
				try {
					audioElement.play();
				} catch (e) {
					L.Logger.info('element id is audio play() is error!');
				}
			}
		}, {
			key: 'handlerOnStartDrag',
			value: function handlerOnStartDrag(e, dragData) {
				//开始拖拽
				var that = this;
				var id = that.props.id;
	
				var defalutFontSize = window.innerWidth / _TkConstant2['default'].STANDARDSIZE;
				that.state[id].offsetX = dragData.x / defalutFontSize - that.state[id].left;
				that.state[id].offsetY = dragData.y / defalutFontSize - that.state[id].top;
			}
		}, {
			key: 'handlerOnDragging',
			value: function handlerOnDragging(e, dragData) {
				//拖拽中
				var that = this;
				var id = that.props.id;
	
				var defalutFontSize = window.innerWidth / _TkConstant2['default'].STANDARDSIZE;
				// 触摸点相对白板区的位置-触摸点相对触摸元素边界的位置：
				that.state[id].left = dragData.x / defalutFontSize - that.state[id].offsetX;
				that.state[id].top = dragData.y / defalutFontSize - that.state[id].offsetY;
				var dragEleId = id; //拖拽的元素
				var boundsEleId = 'tk_app'; //控制拖拽边界的元素
				that.state[id] = _TkUtils2['default'].controlDragBounds(that, dragEleId, boundsEleId);
				that.setState(_defineProperty({}, id, that.state[id]));
			}
		}, {
			key: 'handlerOnStopDrag',
			value: function handlerOnStopDrag(e, dragData) {
				//拖拽结束
				var that = this;
				var id = that.props.id;
	
				that.state[id].offsetX = 0;
				that.state[id].offsetY = 0;
				if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
					var _that$state$id = that.state[id];
					var left = _that$state$id.left;
					var _top = _that$state$id.top;
	
					var _TkUtils$RemChangeToPercentage = _TkUtils2['default'].RemChangeToPercentage(that, left, _top, id);
	
					var percentLeft = _TkUtils$RemChangeToPercentage.percentLeft;
					var percentTop = _TkUtils$RemChangeToPercentage.percentTop;
	
					that[id] = {
						percentLeft: percentLeft,
						percentTop: percentTop
					};
					var data = {
						percentLeft: that[id].percentLeft,
						percentTop: that[id].percentTop,
						isDrag: true
					};
					_ServiceSignalling2['default'].sendSignallingFromTimerDrag(data);
				}
			}
		}, {
			key: 'render',
			value: function render() {
				var that = this;
				var timeDescArray = this.state.timeDescArray;
				var id = this.props.id;
	
				var _loadTimeDescArray2 = this._loadTimeDescArray(timeDescArray);
	
				var afterArray = _loadTimeDescArray2.afterArray;
				var beforeArray = _loadTimeDescArray2.beforeArray;
	
				var draggableData = {
					onStart: that.handlerOnStartDrag.bind(that), //开始拖拽
					onDrag: that.handlerOnDragging.bind(that), //拖拽中
					onStop: that.handlerOnStopDrag.bind(that) };
				//拖拽结束
				var timerDragStyle = {
					position: 'absolute',
					zIndex: 110,
					display: 'inline-block',
					left: this.state[id].left + 'rem',
					top: this.state[id].top + 'rem',
					transitionProperty: this.isHasTransition ? 'left,top' : undefined,
					transitionDuration: this.isHasTransition ? '0.4s' : undefined
				};
				return _react2['default'].createElement(
					_reactDraggable.DraggableCore,
					draggableData,
					_react2['default'].createElement(
						'div',
						{ id: 'timerDrag', style: timerDragStyle },
						_react2['default'].createElement(
							'div',
							{ className: 'timer-teachTool-wrap', style: { display: this.state.timerTeachToolWrapDisplay }, ref: 'timerTeachToolWrap' },
							_react2['default'].createElement(
								'div',
								{ className: 'timer-teachTool-header' },
								_react2['default'].createElement('span', null),
								_react2['default'].createElement(
									'span',
									null,
									_TkGlobal2['default'].language.languageData.timers.timerSetInterval.text
								),
								_react2['default'].createElement('span', { className: 'timer-teachTool-closeSpan', onTouchStart: this.timerCloseHandel.bind(this) })
							),
							beforeArray,
							_react2['default'].createElement(
								'div',
								{ className: 'timer-teachTool-colon' },
								_react2['default'].createElement('div', null),
								_react2['default'].createElement('div', null)
							),
							afterArray,
							_react2['default'].createElement('div', { className: 'timer-teachTool-startBtn', ref: 'timerStartBtn', style: { display: this.state.startBtnStyle }, onTouchStart: this.startBtnHandel.bind(this), title: _TkGlobal2['default'].language.languageData.timers.timerBegin.text }),
							_react2['default'].createElement('div', { className: 'timer-teachTool-stopBtn', style: { display: this.state.startAndStopImg }, onTouchStart: this.stopBtnHandel.bind(this), title: _TkGlobal2['default'].language.languageData.timers.timerStop.text }),
							_react2['default'].createElement('div', { className: 'timer-teachTool-againBtn', style: { display: this.state.againBtnStyle }, onTouchStart: this.againBtnHandel.bind(this), title: _TkGlobal2['default'].language.languageData.timers.again.text }),
							_react2['default'].createElement('div', { className: 'timer-teachTool-againBtn-unclickable', style: { display: this.state.againUnClickableStyle }, title: _TkGlobal2['default'].language.languageData.timers.again.text }),
							_react2['default'].createElement('audio', { id: 'ring_audio', src: "./music/ring.mp3?ts=" + this.listernerBackupid, className: 'audio-play' })
						),
						_react2['default'].createElement(_timerStudentToolComponent2['default'], null)
					)
				);
			}
		}]);
	
		return TimerTeachingToolSmart;
	})(_react2['default'].Component);
	
	exports['default'] = TimerTeachingToolSmart;
	module.exports = exports['default'];

/***/ }),

/***/ 270:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 右侧内容-白板标注工具以及全员操作的Smart组件
	 * @module WhiteboardToolAndControlOverallBarSmart
	 * @description   承载右侧内容-白板标注工具以及全员操作的所有Smart组件
	 * @author QiuShao
	 * @date 2017/08/14
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _controlOverallBar = __webpack_require__(262);
	
	var _controlOverallBar2 = _interopRequireDefault(_controlOverallBar);
	
	var _whiteboardToolBar = __webpack_require__(271);
	
	var _whiteboardToolBar2 = _interopRequireDefault(_whiteboardToolBar);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _reactDraggable = __webpack_require__(58);
	
	var _reactDraggable2 = _interopRequireDefault(_reactDraggable);
	
	var WhiteboardToolAndControlOverallBarSmart = (function (_React$Component) {
	    _inherits(WhiteboardToolAndControlOverallBarSmart, _React$Component);
	
	    function WhiteboardToolAndControlOverallBarSmart(props) {
	        _classCallCheck(this, WhiteboardToolAndControlOverallBarSmart);
	
	        _get(Object.getPrototypeOf(WhiteboardToolAndControlOverallBarSmart.prototype), 'constructor', this).call(this, props);
	        this.state = {
	            lc_tool_container: {
	                pagingToolLeft: "",
	                pagingToolTop: ""
	            },
	            updateState: false
	        };
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	    }
	
	    _createClass(WhiteboardToolAndControlOverallBarSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            _eventObjectDefine2['default'].CoreController.addEventListener(TkConstant.EVENTTYPE.RoomEvent.roomConnected, this.handlerRoomConnected.bind(this), this.listernerBackupid); //roomConnected事件
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	        }
	    }, {
	        key: 'handlerRoomConnected',
	        value: function handlerRoomConnected() {
	            this.setState({ updateState: !this.state.updateState });
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	            return _react2['default'].createElement(
	                _reactDraggable2['default'],
	                { bounds: '#tk_app' },
	                _react2['default'].createElement(
	                    'div',
	                    { id: 'lc_tool_container', className: "lc-tool-container clear-float tk-tool-right " + (_TkGlobal2['default'].mobileDeviceType === 'phone' ? 'phone ' : 'pc pad '), style: { position: "absolute" } },
	                    _TkGlobal2['default'].mobileDeviceType === 'phone' ? undefined : _react2['default'].createElement(_controlOverallBar2['default'], { parentId: "lc_tool_container" }),
	                    _react2['default'].createElement(_whiteboardToolBar2['default'], { parentId: "lc_tool_container" })
	                )
	            );
	        }
	    }]);
	
	    return WhiteboardToolAndControlOverallBarSmart;
	})(_react2['default'].Component);
	
	;
	exports['default'] = WhiteboardToolAndControlOverallBarSmart;
	module.exports = exports['default'];
	/*白板工具栏以及全体操作功能栏*/ /*教学工具箱*/

/***/ }),

/***/ 271:
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {/**
	 * 右侧内容-白板标注工具Smart组件
	 * @module WhiteboardToolBarSmart
	 * @description   承载右侧内容-白板标注工具的所有Smart组件
	 * @author QiuShao
	 * @date 2017/08/14
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _get = function get(_x5, _x6, _x7) { var _again = true; _function: while (_again) { var object = _x5, property = _x6, receiver = _x7; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x5 = parent; _x6 = property; _x7 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var WhiteboardToolBarSmart = (function (_React$Component) {
	    _inherits(WhiteboardToolBarSmart, _React$Component);
	
	    function WhiteboardToolBarSmart(props) {
	        _classCallCheck(this, WhiteboardToolBarSmart);
	
	        _get(Object.getPrototypeOf(WhiteboardToolBarSmart.prototype), 'constructor', this).call(this, props);
	        this.state = {
	            fileTypeMark: 'general',
	            selectColor: '000000',
	            show: false,
	            showItemJson: {
	                mouse: true,
	                laser: false,
	                brush: true,
	                text: true,
	                shape: true,
	                undo: false,
	                redo: false,
	                eraser: true,
	                clear: false,
	                colorAndSize: true,
	                colors: true,
	                measure: true
	            },
	            registerWhiteboardToolsList: {
	                action_clear: {
	                    toolKey: 'action_clear',
	                    disabled: false
	                },
	                action_redo: {
	                    toolKey: 'action_redo',
	                    disabled: false
	                },
	                action_undo: {
	                    toolKey: 'action_undo',
	                    disabled: false
	                },
	                tool_eraser: {
	                    toolKey: 'tool_eraser',
	                    disabled: false
	                }
	            },
	            currentUseTool: 'tool_mouse',
	            currentExtendToolContainer: undefined,
	            currentExtendToolExtraContainer: undefined,
	            showCurrentExtendToolContainer: false,
	            useBrush: 'tool_pencil',
	            useText: 'tool_text_msyh',
	            useShape: 'tool_rectangle_empty',
	            useStrokeSize: 'tool_color_measure_small',
	            useStrokeColor: 'simple_color_000000'
	        };
	        this.selectMouse = undefined;
	        this.colors = {
	            smipleList: ["#000000", "#2d2d2d", "#5b5b5b", "#8e8e8e", "#c5c5c5", "#ffffff", "#ff0001", "#06ff02", "#0009ff", "#ffff03", "#00ffff", "#ff03ff"],
	            moreList: [["#000000", "#002d00", "#015b00", "#028e01", "#03c501", "#06ff02", "#2d0000", "#2d2d00", "#2d5b00", "#2d8e01", "#2dc501", "#2eff02", "#5b0000", "#5b2d00", "#5b5b00", "#5b8e01", "#5bc501", "#5cff02"], ["#00002d", "#002d2d", "#015b2d", "#028e2d", "#03c52d", "#05ff2d", "#2d002d", "#2d2d2d", "#2d5b2d", "#2d8e2d", "#2dc52d", "#2eff2d", "#5b002d", "#5b2d2d", "#5b5b2d", "#5b8e2d", "#5bc52d", "#5cff2d"], ["#00015b", "#002d5b", "#005b5b", "#018e5b", "#02c55b", "#05ff5b", "#2d015b", "#2d2d5b", "#2d5b5b", "#2d8e5b", "#2dc55b", "#2eff5b", "#5b005b", "#5b2d5b", "#5b5b5b", "#5b8e5b", "#5bc55b", "#5cff5b"], ["#00038e", "#002d8e", "#005b8e", "#008e8e", "#01c58e", "#03ff8e", "#2c038e", "#2d2d8e", "#2d5b8e", "#2d8e8e", "#2dc58e", "#2dff8e", "#5b028e", "#5b2d8e", "#5b5b8e", "#5b8e8e", "#5bc58e", "#5bff8e"], ["#0005c5", "#002ec5", "#005bc5", "#008ec5", "#00c5c5", "#01ffc5", "#2c05c5", "#2c2ec5", "#2c5bc5", "#2c8ec5", "#2dc5c5", "#2dffc5", "#5b04c5", "#5b2ec5", "#5b5bc5", "#5b8ec5", "#5bc5c5", "#5bffc5"], ["#0009ff", "#002eff", "#005cff", "#008fff", "#00c5ff", "#00ffff", "#2c08ff", "#2c2eff", "#2c5cff", "#2c8fff", "#2cc5ff", "#2dffff", "#5b08ff", "#5b2eff", "#5b5cff", "#5b8fff", "#5bc5ff", "#5bffff"], ["#8e0000", "#8e2d00", "#8e5b01", "#8e8e01", "#8fc502", "#8fff03", "#c50001", "#c52c01", "#c55b01", "#c58e01", "#c5c502", "#c5ff03", "#ff0001", "#ff2c01", "#ff5b01", "#ff8e02", "#ffc502", "#ffff03"], ["#8e002d", "#8e2d2d", "#8e5b2d", "#8e8e2d", "#8fc52d", "#8fff2d", "#c5002d", "#c52c2d", "#c55b2d", "#c58e2d", "#c5c52d", "#c5ff2d", "#ff002d", "#ff2c2d", "#ff5b2d", "#ff8e2d", "#ffc52d", "#ffff2d"], ["#8e005b", "#8e2d5b", "#8e5b5b", "#8e8e5b", "#8fc55b", "#8fff5b", "#c5005b", "#c52c5b", "#c55b5b", "#c58e5b", "#c5c55b", "#c5ff5b", "#ff005b", "#ff2c5b", "#ff5b5b", "#ff8e5b", "#ffc55b", "#ffff5b"], ["#8e018e", "#8e2d8e", "#8e5b8e", "#8e8e8e", "#8ec58e", "#8fff8e", "#c5008e", "#c52d8e", "#c55b8e", "#c58e8e", "#c5c58e", "#c5ff8e", "#ff008e", "#ff2c8e", "#ff5b8e", "#ff8e8e", "#ffc58e", "#ffff8e"], ["#8e03c5", "#8e2dc5", "#8e5bc5", "#8e8ec5", "#8ec5c5", "#8effc5", "#c502c5", "#c52dc5", "#c55bc5", "#c58ec5", "#c5c5c5", "#c5ffc5", "#ff00c5", "#ff2dc5", "#ff5bc5", "#ff8ec5", "#ffc5c5", "#ffffc5"], ["#8e07ff", "#8e2eff", "#8e5cff", "#8e8fff", "#8ec5ff", "#8effff", "#c505ff", "#c52eff", "#c55bff", "#c58eff", "#c5c5ff", "#c5ffff", "#ff03ff", "#ff2dff", "#ff5bff", "#ff8eff", "#ffc5ff", "#ffffff"]]
	        };
	        this.listernerBackupid = new Date().getTime() + '_' + Math.random();
	    }
	
	    _createClass(WhiteboardToolBarSmart, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            //在完成首次渲染之前调用，此时仍可以修改组件的state
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.addEventListener('changeFileTypeMark', that.handlerChangeFileTypeMark.bind(that), that.listernerBackupid); //设置翻页栏属于普通文档还是动态PPT
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomConnected, that.handlerRoomConnected.bind(that), that.listernerBackupid); //roomConnected事件
	            _eventObjectDefine2['default'].CoreController.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent.roomPubmsg, that.handlerRoomPubmsg.bind(that), that.listernerBackupid); //roomPubmsg 事件
	            _eventObjectDefine2['default'].CoreController.addEventListener('callAllWrapOnClick', that.handlerCallAllWrapOnClick.bind(that), that.listernerBackupid); //callAllWrapOnClick 事件-点击整个页面容器
	            _eventObjectDefine2['default'].CoreController.addEventListener("updateAppPermissions_canDraw", that.handlerUpdateAppPermissions_canDraw.bind(that), that.listernerBackupid); //updateAppPermissions_canDraw：白板可画权限更新
	            _eventObjectDefine2['default'].CoreController.addEventListener("initAppPermissions", that.handlerInitAppPermissions.bind(that), that.listernerBackupid); //initAppPermissions：白板可画权限更新
	            _eventObjectDefine2['default'].CoreController.addEventListener('resetDefaultAppPermissions', that.handlerResetDefaultAppPermissions.bind(that), that.listernerBackupid); //resetDefaultAppPermissions：白板可画权限更新
	            _eventObjectDefine2['default'].CoreController.addEventListener('receive-msglist-whiteboardMarkTool', that.handlerReceive_msglist_whiteboardMarkTool.bind(that), that.listernerBackupid); //receive-msglist-whiteboardMarkTool
	            _eventObjectDefine2['default'].CoreController.addEventListener('commonWhiteboardTool_noticeUpdateToolDesc', that.handlerCommonWhiteboardTool_noticeUpdateToolDesc.bind(that), that.listernerBackupid);
	            _eventObjectDefine2['default'].CoreController.addEventListener('teacherToolBox', that.handlerTeacherToolBox.bind(that), that.listernerBackupid); //点击工具箱事件
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            //组件被移除之前被调用，可以用于做一些清理工作，在componentDidMount方法中添加的所有任务都需要在该方法中撤销，比如创建的定时器或添加的事件监听器
	            var that = this;
	            _eventObjectDefine2['default'].CoreController.removeBackupListerner(that.listernerBackupid);
	        }
	    }, {
	        key: 'handlerCallAllWrapOnClick',
	
	        /* //在组件完成更新后立即调用。在初始化时不会被调用
	         componentDidUpdate(prevProps , prevState) { }*/
	
	        value: function handlerCallAllWrapOnClick(recvEventData) {
	            if (TK.SDKTYPE === 'mobile') {
	                var _event = recvEventData.message.event;
	
	                var parentId = this.props.parentId || 'header_tool_vessel';
	                if (!(_event.target.id === parentId || $(_event.target) && $(_event.target).parents("#" + parentId).length > 0)) {
	                    if (this.state.showCurrentExtendToolContainer) {
	                        this.setState({ showCurrentExtendToolContainer: false }); //离开li则隐藏扩展框
	                    }
	                    if (this.state.currentExtendToolExtraContainer) {
	                        this.setState({ currentExtendToolExtraContainer: undefined }); //离开li则隐藏扩展框
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerRoomPubmsg',
	        value: function handlerRoomPubmsg(recvEventData) {
	            var that = this;
	            var pubmsgData = recvEventData.message;
	            switch (pubmsgData.name) {
	                case "whiteboardMarkTool":
	                    var selectMouse = pubmsgData.data.selectMouse;
	
	                    if (that.selectMouse !== selectMouse) {
	                        var isRemote = true;
	                        if (selectMouse) {
	                            that.selectCurrentUseTool({ toolId: 'tool_mouse', isRemote: isRemote });
	                        } else {
	                            that.selectExtendTool({ extendToolId: 'whiteboard_tool_vessel_brush', isRemote: isRemote });
	                        }
	                    }
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerReceive_msglist_whiteboardMarkTool',
	        value: function handlerReceive_msglist_whiteboardMarkTool(recvEventData) {
	            var that = this;
	            var pubmsgData = recvEventData.message;
	            var selectMouse = pubmsgData.data.selectMouse;
	
	            if (that.selectMouse !== selectMouse) {
	                var isRemote = true;
	                if (selectMouse) {
	                    that.selectCurrentUseTool({ toolId: 'tool_mouse', isRemote: isRemote });
	                } else {
	                    that.selectExtendTool({ extendToolId: 'whiteboard_tool_vessel_brush', isRemote: isRemote });
	                }
	            }
	        }
	    }, {
	        key: 'handlerChangeFileTypeMark',
	        value: function handlerChangeFileTypeMark(recvEventData) {
	            this.setState({ fileTypeMark: recvEventData.message.fileTypeMark });
	        }
	    }, {
	        key: 'handlerRoomConnected',
	        value: function handlerRoomConnected(recvEventData) {
	            if (_TkConstant2['default'].hasRole.roleChairman) {
	                //如果是老师
	                var _iteratorNormalCompletion = true;
	                var _didIteratorError = false;
	                var _iteratorError = undefined;
	
	                try {
	                    for (var _iterator = Object.keys(this.state.showItemJson)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                        var key = _step.value;
	
	                        this.state.showItemJson[key] = true;
	                    }
	                } catch (err) {
	                    _didIteratorError = true;
	                    _iteratorError = err;
	                } finally {
	                    try {
	                        if (!_iteratorNormalCompletion && _iterator['return']) {
	                            _iterator['return']();
	                        }
	                    } finally {
	                        if (_didIteratorError) {
	                            throw _iteratorError;
	                        }
	                    }
	                }
	
	                if (TK.SDKTYPE === 'mobile') {
	                    this.state.showItemJson.laser = false;
	                    this.state.showItemJson.undo = false;
	                    this.state.showItemJson.redo = false;
	                    this.state.showItemJson.clear = false;
	                    this.state.showItemJson.colorAndSize = false;
	                    this.state.showItemJson.colors = true;
	                    this.state.showItemJson.measure = true;
	                } else {
	                    this.state.showItemJson.colors = false;
	                    this.state.showItemJson.measure = false;
	                }
	                this.setState({ showItemJson: this.state.showItemJson });
	            } else {
	                if (TK.SDKTYPE === 'mobile') {
	                    this.state.showItemJson.laser = false;
	                    this.state.showItemJson.undo = false;
	                    this.state.showItemJson.redo = false;
	                    this.state.showItemJson.clear = false;
	                    this.state.showItemJson.colorAndSize = false;
	                    this.state.showItemJson.colors = true;
	                    this.state.showItemJson.measure = true;
	                    this.setState({ showItemJson: this.state.showItemJson });
	                }
	            }
	            if (_TkConstant2['default'].hasRole.roleChairman || _TkConstant2['default'].hasRole.roleTeachingAssistant) {
	                this.changeStrokeColorClick("simple_color_ff0001", 'ff0001');
	            } else {
	                this.changeStrokeColorClick("simple_color_000000", '000000');
	            }
	
	            if (this.selectMouse === undefined) {
	                var isRemote = true;
	                this.selectCurrentUseTool({ toolId: 'tool_mouse', isRemote: isRemote });
	            }
	            var sizeJson = undefined;
	            if (TK.SDKTYPE === 'mobile') {
	                if (_TkGlobal2['default'].mobileDeviceType === 'phone') {
	                    sizeJson = { pencil: 5, text: 25, eraser: 120, shape: 5 };
	                } else {
	                    sizeJson = { pencil: 5, text: 25, eraser: 50, shape: 5 };
	                }
	            } else {
	                sizeJson = { pencil: 5, text: 18, eraser: 30, shape: 5 };
	            }
	            this.changeStrokeSizeClick('tool_color_measure_small', sizeJson);
	        }
	    }, {
	        key: 'handlerUpdateAppPermissions_canDraw',
	        value: function handlerUpdateAppPermissions_canDraw(recvEventData) {
	            this._changeCanDrawPermissions();
	        }
	    }, {
	        key: 'handlerInitAppPermissions',
	        value: function handlerInitAppPermissions(recvEventData) {
	            this._changeCanDrawPermissions();
	        }
	    }, {
	        key: 'handlerResetDefaultAppPermissions',
	        value: function handlerResetDefaultAppPermissions() {
	            this._changeCanDrawPermissions();
	        }
	    }, {
	        key: 'handlerCommonWhiteboardTool_noticeUpdateToolDesc',
	        value: function handlerCommonWhiteboardTool_noticeUpdateToolDesc(recvEventData) {
	            var registerWhiteboardToolsList = recvEventData.message.registerWhiteboardToolsList;
	
	            var isChange = false;
	            var _iteratorNormalCompletion2 = true;
	            var _didIteratorError2 = false;
	            var _iteratorError2 = undefined;
	
	            try {
	                for (var _iterator2 = Object.keys(this.state.registerWhiteboardToolsList)[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	                    var key = _step2.value;
	
	                    if (registerWhiteboardToolsList[key]) {
	                        this.state.registerWhiteboardToolsList[key] = registerWhiteboardToolsList[key];
	                        isChange = true;
	                    }
	                }
	            } catch (err) {
	                _didIteratorError2 = true;
	                _iteratorError2 = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion2 && _iterator2['return']) {
	                        _iterator2['return']();
	                    }
	                } finally {
	                    if (_didIteratorError2) {
	                        throw _iteratorError2;
	                    }
	                }
	            }
	
	            if (isChange) {
	                this.setState({
	                    registerWhiteboardToolsList: this.state.registerWhiteboardToolsList
	                });
	            }
	        }
	    }, {
	        key: 'handlerTeacherToolBox',
	        value: function handlerTeacherToolBox(recvEventData) {
	            if (this.state.showCurrentExtendToolContainer) {
	                this.setState({ showCurrentExtendToolContainer: false }); //离开li则隐藏扩展框
	            }
	            if (this.state.currentExtendToolExtraContainer) {
	                this.setState({ currentExtendToolExtraContainer: undefined }); //离开li则隐藏扩展框
	            }
	        }
	    }, {
	        key: 'allLiMouseLeave',
	
	        /*所有li的鼠标移出事件处理*/
	        value: function allLiMouseLeave(elementId) {
	            if (TK.SDKTYPE !== 'mobile') {
	                if (this.state.showCurrentExtendToolContainer) {
	                    this.setState({ showCurrentExtendToolContainer: false }); //离开li则隐藏扩展框
	                }
	                if (this.state.currentExtendToolExtraContainer) {
	                    this.setState({ currentExtendToolExtraContainer: undefined }); //离开li则隐藏扩展框
	                }
	            }
	        }
	    }, {
	        key: 'changeStrokeSizeClick',
	
	        /*改变大小的点击事件*/
	        value: function changeStrokeSizeClick(strokeSizeId, strokeJson) {
	            var selectedTool = {};
	            if (this.state.currentExtendToolContainer === 'whiteboard_tool_vessel_brush') {
	                selectedTool.pencil = true;
	            } else if (this.state.currentExtendToolContainer === 'whiteboard_tool_vessel_text' || TK.SDKTYPE === 'mobile' && this.state.currentUseTool === 'tool_text') {
	                selectedTool.text = true;
	            } else if (this.state.currentExtendToolContainer === 'whiteboard_tool_vessel_shape') {
	                selectedTool.shape = true;
	            } else if (this.state.currentUseTool === 'tool_eraser') {
	                selectedTool.eraser = true;
	            }
	            this.setState({ useStrokeSize: strokeSizeId });
	            if (TK.SDKTYPE === 'mobile' && this.state.currentExtendToolExtraContainer) {
	                this.setState({ currentExtendToolExtraContainer: undefined });
	            }
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'changeStrokeSize', message: { strokeJson: strokeJson, selectedTool: selectedTool } });
	        }
	    }, {
	        key: 'changeStrokeColorClick',
	
	        /*改变选中的颜色点击事件*/
	        value: function changeStrokeColorClick(useStrokeColorId, selectColor) {
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'changeStrokeColor', message: { selectColor: selectColor } });
	            this.setState({ selectColor: selectColor, useStrokeColor: useStrokeColorId });
	            if (TK.SDKTYPE === 'mobile' && this.state.currentExtendToolExtraContainer) {
	                this.setState({ currentExtendToolExtraContainer: undefined });
	            }
	        }
	
	        /*选择当前使用的工具*/
	    }, {
	        key: 'selectCurrentUseTool',
	        value: function selectCurrentUseTool(_x, event) {
	            var _ref = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	            var toolId = _ref.toolId;
	            var extendToolId = _ref.extendToolId;
	            var _ref$isRemote = _ref.isRemote;
	            var isRemote = _ref$isRemote === undefined ? false : _ref$isRemote;
	            var _ref$initiative = _ref.initiative;
	            var initiative = _ref$initiative === undefined ? true : _ref$initiative;
	
	            this.setState({ currentUseTool: toolId });
	            if (this.state.currentExtendToolContainer !== extendToolId) {
	                this.setState({ currentExtendToolContainer: extendToolId });
	            }
	            if (this.state.currentExtendToolExtraContainer !== undefined) {
	                this.setState({ currentExtendToolExtraContainer: undefined });
	            }
	            if (initiative && (!extendToolId || TK.SDKTYPE === 'mobile' && this.state.showCurrentExtendToolContainer)) {
	                this.setState({ showCurrentExtendToolContainer: false });
	            }
	            if (initiative && !isRemote) {
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboardToolBox' });
	            }
	            if (extendToolId) {
	                switch (extendToolId) {
	                    case 'whiteboard_tool_vessel_brush':
	                        this.setState({ useBrush: toolId });
	                        break;
	                    case 'whiteboard_tool_vessel_text':
	                        var fontFamily = 'tool_text_msyh';
	                        switch (toolId) {
	                            case 'tool_text_msyh':
	                                fontFamily = _TkGlobal2['default'].language.languageData.header.tool.text.Msyh.text;
	                                break;
	                            case 'tool_text_ming':
	                                fontFamily = _TkGlobal2['default'].language.languageData.header.tool.text.Ming.text;
	                                break;
	                            case 'tool_text_arial':
	                                fontFamily = _TkGlobal2['default'].language.languageData.header.tool.text.Arial.text;
	                                break;
	                        }
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboard_updateWhiteboardToolsInfo', message: { whiteboardToolsInfo: { fontFamily: fontFamily } } });
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboard_updateTextFont' });
	                        this.setState({ useText: toolId });
	                        break;
	                    case 'whiteboard_tool_vessel_shape':
	                        this.setState({ useShape: toolId });
	                        break;
	                }
	            }
	            if (this.selectMouse !== (toolId === 'tool_mouse')) {
	                this.selectMouse = toolId === 'tool_mouse';
	                _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'updateSelectMouse', message: { selectMouse: this.selectMouse } }); //通知白板标注工具是否更换为鼠标
	                if (!isRemote) {
	                    _ServiceSignalling2['default'].sendMarkToolMouseIsSelect(this.selectMouse);
	                }
	            }
	            if (extendToolId === 'whiteboard_tool_vessel_text') {
	                this._whiteboard_activeCommonWhiteboardToolClick('tool_text');
	            } else {
	                this._whiteboard_activeCommonWhiteboardToolClick(toolId);
	            }
	            if (event) {
	                event.preventDefault();
	                event.stopPropagation();
	            }
	            return false;
	        }
	    }, {
	        key: 'selectExtendExtraTool',
	
	        /*选择额外的扩展工具*/
	        value: function selectExtendExtraTool(_x2, event) {
	            var _ref2 = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	            var extendToolId = _ref2.extendToolId;
	            var _ref2$isRemote = _ref2.isRemote;
	            var isRemote = _ref2$isRemote === undefined ? false : _ref2$isRemote;
	            var toolId = _ref2.toolId;
	
	            if (extendToolId) {
	                if (!isRemote) {
	                    if (this.state.currentExtendToolExtraContainer !== extendToolId) {
	                        this.setState({ currentExtendToolExtraContainer: extendToolId });
	                    } else {
	                        this.setState({ currentExtendToolExtraContainer: undefined });
	                    }
	                }
	                this.setState({ showCurrentExtendToolContainer: false });
	                if (!isRemote) {
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboardToolBox' });
	                }
	            }
	            if (event) {
	                event.preventDefault();
	                event.stopPropagation();
	            }
	            return false;
	        }
	    }, {
	        key: 'selectExtendTool',
	
	        /*选择扩展的工具*/
	        value: function selectExtendTool(_x3, event) {
	            var _ref3 = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	            var extendToolId = _ref3.extendToolId;
	            var _ref3$isRemote = _ref3.isRemote;
	            var isRemote = _ref3$isRemote === undefined ? false : _ref3$isRemote;
	            var toolId = _ref3.toolId;
	
	            if (extendToolId) {
	                if (!isRemote) {
	                    if (this.state.currentExtendToolContainer && this.state.currentExtendToolContainer === extendToolId) {
	                        this.setState({ showCurrentExtendToolContainer: !this.state.showCurrentExtendToolContainer }); //主动点击则显示扩展框
	                    } else {
	                            this.setState({ showCurrentExtendToolContainer: true }); //主动点击则显示扩展框
	                        }
	                    this.setState({ currentExtendToolExtraContainer: undefined });
	                } else {
	                    this.setState({ showCurrentExtendToolContainer: false, currentExtendToolExtraContainer: undefined });
	                }
	                switch (extendToolId) {
	                    case 'whiteboard_tool_vessel_brush':
	                        this.selectCurrentUseTool({ toolId: this.state.useBrush, extendToolId: extendToolId, isRemote: isRemote, initiative: false });
	                        break;
	                    case 'whiteboard_tool_vessel_text':
	                        this.selectCurrentUseTool({ toolId: this.state.useText, extendToolId: extendToolId, isRemote: isRemote, initiative: false });
	                        break;
	                    case 'whiteboard_tool_vessel_shape':
	                        this.selectCurrentUseTool({ toolId: this.state.useShape, extendToolId: extendToolId, isRemote: isRemote, initiative: false });
	                        break;
	                }
	                if (!isRemote) {
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboardToolBox' });
	                }
	            }
	            if (event) {
	                event.preventDefault();
	                event.stopPropagation();
	            }
	            return false;
	        }
	    }, {
	        key: 'useWhiteboardAction',
	
	        /*标注工具撤销、恢复、删除等操作*/
	        value: function useWhiteboardAction(_x4, event) {
	            var _ref4 = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	            var actionId = _ref4.actionId;
	            var _ref4$isRemote = _ref4.isRemote;
	            var isRemote = _ref4$isRemote === undefined ? false : _ref4$isRemote;
	
	            if (actionId) {
	                this.setState({ showCurrentExtendToolContainer: false });
	                this.setState({ currentExtendToolExtraContainer: undefined });
	                this._whiteboard_activeCommonWhiteboardToolClick(actionId);
	            }
	            if (event) {
	                event.preventDefault();
	                event.stopPropagation();
	            }
	            return false;
	        }
	    }, {
	        key: '_whiteboard_activeCommonWhiteboardToolClick',
	        value: function _whiteboard_activeCommonWhiteboardToolClick(toolKey) {
	            _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'whiteboard_activeCommonWhiteboardTool', message: { toolKey: toolKey } });
	        }
	    }, {
	        key: '_loadSmipleAndMoreListToArray',
	
	        /*加载*/
	        value: function _loadSmipleAndMoreListToArray(smipleList, moreList) {
	            var that = this;
	            var smipleColorElementArray = [];
	            var moreColorElementArray = [];
	            smipleList.map(function (item, index) {
	                smipleColorElementArray.push(_react2['default'].createElement('li', { key: index, className: " " + (that.state.useStrokeColor === "simple_color_" + that._colorFilter(item) ? 'active' : ''), onTouchStart: that.changeStrokeColorClick.bind(that, "simple_color_" + that._colorFilter(item), that._colorFilter(item)), style: { backgroundColor: item }, id: "simple_color_" + that._colorFilter(item) }));
	            });
	            moreList.map(function (itemArr, itemArrIndex) {
	                if (Array.isArray(itemArr)) {
	                    (function () {
	                        var tempArr = [];
	                        itemArr.map(function (item, itemIndex) {
	                            tempArr.push(_react2['default'].createElement('li', { key: itemIndex, className: " " + (that.state.useStrokeColor === "more_color_" + that._colorFilter(item) ? 'active' : ''), onTouchStart: that.changeStrokeColorClick.bind(that, "more_color_" + that._colorFilter(item), that._colorFilter(item)), style: { backgroundColor: item }, id: "more_color_" + that._colorFilter(item) }));
	                        });
	                        moreColorElementArray.push(_react2['default'].createElement(
	                            'ul',
	                            { key: itemArrIndex, className: 'clear-float' },
	                            tempArr
	                        ));
	                    })();
	                }
	            });
	            return {
	                smipleColorElementArray: smipleColorElementArray,
	                moreColorElementArray: moreColorElementArray
	            };
	        }
	    }, {
	        key: '_colorFilter',
	
	        /*颜色过滤器*/
	        value: function _colorFilter(text) {
	            return text.replace(/#/g, "");
	        }
	    }, {
	        key: '_changeCanDrawPermissions',
	
	        /*改变可画权限*/
	        value: function _changeCanDrawPermissions() {
	            var show = _CoreController2['default'].handler.getAppPermissions('canDraw');
	            this.setState({ show: show });
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var that = this;
	
	            var _that$_loadSmipleAndMoreListToArray = that._loadSmipleAndMoreListToArray(that.colors.smipleList, that.colors.moreList);
	
	            var smipleColorElementArray = _that$_loadSmipleAndMoreListToArray.smipleColorElementArray;
	            var moreColorElementArray = _that$_loadSmipleAndMoreListToArray.moreColorElementArray;
	            var _that$state$showItemJson = that.state.showItemJson;
	            var mouse = _that$state$showItemJson.mouse;
	            var laser = _that$state$showItemJson.laser;
	            var brush = _that$state$showItemJson.brush;
	            var text = _that$state$showItemJson.text;
	            var shape = _that$state$showItemJson.shape;
	            var undo = _that$state$showItemJson.undo;
	            var redo = _that$state$showItemJson.redo;
	            var eraser = _that$state$showItemJson.eraser;
	            var clear = _that$state$showItemJson.clear;
	            var colorAndSize = _that$state$showItemJson.colorAndSize;
	            var colors = _that$state$showItemJson.colors;
	            var measure = _that$state$showItemJson.measure;
	            var _state$registerWhiteboardToolsList = this.state.registerWhiteboardToolsList;
	            var action_clear = _state$registerWhiteboardToolsList.action_clear;
	            var action_redo = _state$registerWhiteboardToolsList.action_redo;
	            var action_undo = _state$registerWhiteboardToolsList.action_undo;
	            var _that$state = that.state;
	            var currentUseTool = _that$state.currentUseTool;
	            var currentExtendToolContainer = _that$state.currentExtendToolContainer;
	            var showCurrentExtendToolContainer = _that$state.showCurrentExtendToolContainer;
	            var useBrush = _that$state.useBrush;
	            var useText = _that$state.useText;
	            var useShape = _that$state.useShape;
	            var useStrokeSize = _that$state.useStrokeSize;
	            var currentExtendToolExtraContainer = _that$state.currentExtendToolExtraContainer;
	
	            return _react2['default'].createElement(
	                'div',
	                { className: 'whiteboard-tool-total-box add-fl clear-float' },
	                _TkGlobal2['default'].mobileDeviceType !== 'phone' ? _react2['default'].createElement(
	                    'ol',
	                    { className: 'add-fl clear-float h-tool tool-whiteboard-container pc pad ', id: 'header_tool_vessel', style: { display: !that.state.show ? 'none' : '' } },
	                    ' ',
	                    !mouse ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-mouse " + (currentUseTool === 'tool_mouse' ? 'active' : ''), id: 'whiteboard_tool_vessel_mouse', style: { display: !mouse ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', title: _TkGlobal2['default'].language.languageData.header.tool.mouse.title, id: 'tool_mouse', onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_mouse' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    ),
	                    !laser ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-laser " + (currentUseTool === 'tool_laser' ? 'active' : ''), id: 'whiteboard_tool_vessel_laser', style: { display: !laser ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', title: _TkGlobal2['default'].language.languageData.header.tool.pencil.laser.title, id: 'tool_laser', onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_laser' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    ),
	                    !brush ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-pencil " + (currentExtendToolContainer === 'whiteboard_tool_vessel_brush' ? 'active ' : ' ') + (currentExtendToolContainer === 'whiteboard_tool_vessel_brush' && showCurrentExtendToolContainer ? 'more ' : ' '), id: 'whiteboard_tool_vessel_brush', onMouseLeave: that.allLiMouseLeave.bind(that, 'whiteboard_tool_vessel_brush'), style: { display: !brush ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: "header-tool tool-pencil  tool-more ", id: 'tool_vessel_brush', title: _TkGlobal2['default'].language.languageData.header.tool.pencil.title, onTouchStart: that.selectExtendTool.bind(that, { extendToolId: 'whiteboard_tool_vessel_brush' }), 'data-iconclass': useBrush },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap tool-pencil-icon' })
	                        ),
	                        _react2['default'].createElement(
	                            'div',
	                            { className: 'header-tool-extend tool-pencil-extend' },
	                            _react2['default'].createElement(
	                                'ul',
	                                { className: 'clear-float' },
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_pencil', className: 'extend-brush-pencil ' + (useBrush === 'tool_pencil' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_pencil', extendToolId: 'whiteboard_tool_vessel_brush' }) },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        TK.SDKTYPE === 'mobile' ? undefined : _TkGlobal2['default'].language.languageData.header.tool.pencil.pen.text
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_highlighter', className: 'extend-brush-highlighter ' + (useBrush === 'tool_highlighter' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_highlighter', extendToolId: 'whiteboard_tool_vessel_brush' }) },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        TK.SDKTYPE === 'mobile' ? undefined : _TkGlobal2['default'].language.languageData.header.tool.pencil.Highlighter.text
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_line', className: 'extend-brush-line ' + (useBrush === 'tool_line' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_line', extendToolId: 'whiteboard_tool_vessel_brush' }) },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        TK.SDKTYPE === 'mobile' ? undefined : _TkGlobal2['default'].language.languageData.header.tool.pencil.linellae.text
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_arrow', className: 'extend-brush-arrow ' + (useBrush === 'tool_arrow' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_arrow', extendToolId: 'whiteboard_tool_vessel_brush' }) },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        TK.SDKTYPE === 'mobile' ? undefined : _TkGlobal2['default'].language.languageData.header.tool.pencil.arrow.text
	                                    )
	                                )
	                            )
	                        )
	                    ),
	                    !text ? undefined : TK.SDKTYPE !== 'mobile' ? _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-text " + (currentExtendToolContainer === 'whiteboard_tool_vessel_text' ? 'active ' : ' ') + (currentExtendToolContainer === 'whiteboard_tool_vessel_text' && showCurrentExtendToolContainer ? 'more ' : ' '), id: 'whiteboard_tool_vessel_text', onMouseLeave: that.allLiMouseLeave.bind(that, 'whiteboard_tool_vessel_text'), style: { display: !text ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool  tool-text  tool-more', title: _TkGlobal2['default'].language.languageData.header.tool.text.title, id: 'tool_text', onTouchStart: that.selectExtendTool.bind(that, { extendToolId: 'whiteboard_tool_vessel_text' }), 'data-iconclass': useText },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        ),
	                        _react2['default'].createElement(
	                            'div',
	                            { className: 'header-tool-extend tool-text-extend', id: 'tool_text_extend' },
	                            _react2['default'].createElement(
	                                'ul',
	                                { className: 'clear-float' },
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_text_msyh', className: 'extend-text-msyh ' + (useText === 'tool_text_msyh' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_text_msyh', extendToolId: 'whiteboard_tool_vessel_text' }) },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        _TkGlobal2['default'].language.languageData.header.tool.text.Msyh.text
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_text_ming', className: 'extend-text-ming ' + (useText === 'tool_text_ming' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_text_ming', extendToolId: 'whiteboard_tool_vessel_text' }) },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        _TkGlobal2['default'].language.languageData.header.tool.text.Ming.text
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_text_arial', className: 'extend-text-arial ' + (useText === 'tool_text_arial' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_text_arial', extendToolId: 'whiteboard_tool_vessel_text' }) },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        _TkGlobal2['default'].language.languageData.header.tool.text.Arial.text
	                                    )
	                                )
	                            )
	                        )
	                    ) : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-text " + (currentUseTool === 'tool_text' ? 'active' : ''), id: 'whiteboard_tool_vessel_text', style: { display: !text ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', title: _TkGlobal2['default'].language.languageData.header.tool.text.title, id: 'tool_text', onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_text' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    ),
	                    !shape ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-shape " + (currentExtendToolContainer === 'whiteboard_tool_vessel_shape' ? 'active ' : ' ') + (currentExtendToolContainer === 'whiteboard_tool_vessel_shape' && showCurrentExtendToolContainer ? 'more ' : ' '), id: 'whiteboard_tool_vessel_shape', onMouseLeave: that.allLiMouseLeave.bind(that, 'whiteboard_tool_vessel_shape'), style: { display: !shape ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool  tool-shape   tool-more', title: _TkGlobal2['default'].language.languageData.header.tool.shape.title, id: 'tool_shape_list', onTouchStart: that.selectExtendTool.bind(that, { extendToolId: 'whiteboard_tool_vessel_shape' }), 'data-iconclass': useShape },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        ),
	                        _react2['default'].createElement(
	                            'div',
	                            { className: 'header-tool-extend tool-shape-extend' },
	                            _react2['default'].createElement(
	                                'ul',
	                                { className: 'clear-float' },
	                                _react2['default'].createElement(
	                                    'li',
	                                    { className: 'extend-shape-rectangle-empty ' + (useShape === 'tool_rectangle_empty' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_rectangle_empty', extendToolId: 'whiteboard_tool_vessel_shape' }), id: 'tool_rectangle_empty' },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        TK.SDKTYPE === 'mobile' ? undefined : _TkGlobal2['default'].language.languageData.header.tool.shape.outlinedRectangle.text
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { className: 'extend-shape-rectangle ' + (useShape === 'tool_rectangle' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_rectangle', extendToolId: 'whiteboard_tool_vessel_shape' }), id: 'tool_rectangle' },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        TK.SDKTYPE === 'mobile' ? undefined : _TkGlobal2['default'].language.languageData.header.tool.shape.filledRectangle.text
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { className: 'extend-shape-ellipse-empty ' + (useShape === 'tool_ellipse_empty' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_ellipse_empty', extendToolId: 'whiteboard_tool_vessel_shape' }), id: 'tool_ellipse_empty' },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        TK.SDKTYPE === 'mobile' ? undefined : _TkGlobal2['default'].language.languageData.header.tool.shape.outlinedCircle.text
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { className: 'extend-shape-ellipse ' + (useShape === 'tool_ellipse' ? 'active' : ''), onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_ellipse', extendToolId: 'whiteboard_tool_vessel_shape' }), id: 'tool_ellipse' },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        { className: 'add-nowrap' },
	                                        TK.SDKTYPE === 'mobile' ? undefined : _TkGlobal2['default'].language.languageData.header.tool.shape.filledCircle.text
	                                    )
	                                )
	                            )
	                        )
	                    ),
	                    !colors ? undefined : TK.SDKTYPE === 'mobile' ? _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-colors " + (currentExtendToolExtraContainer === 'whiteboard_tool_vessel_colors' ? 'active more' : ''), id: 'whiteboard_tool_vessel_colors', onMouseLeave: that.allLiMouseLeave.bind(that, 'whiteboard_tool_vessel_colors'), style: { display: !colors ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool  tool-colors   tool-more', title: _TkGlobal2['default'].language.languageData.header.tool.colors.title, id: 'tool_colors_list', onTouchStart: that.selectExtendExtraTool.bind(that, { extendToolId: 'whiteboard_tool_vessel_colors' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap', style: { background: "#" + this.state.selectColor } })
	                        ),
	                        _react2['default'].createElement(
	                            'div',
	                            { className: 'header-tool-extend tool-colors-extend' },
	                            _react2['default'].createElement(
	                                'ul',
	                                { className: 'clear-float' },
	                                _react2['default'].createElement(
	                                    'li',
	                                    { className: "simple-color-000000 " + (that.state.useStrokeColor === "simple_color_000000" ? 'active' : ''), onTouchStart: that.changeStrokeColorClick.bind(that, "simple_color_000000", '000000'), id: "mobile_simple_color_000000" },
	                                    _react2['default'].createElement('span', { className: 'add-nowrap', style: { backgroundColor: '#000000' } })
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { className: "simple-color-ff0001 " + (that.state.useStrokeColor === "simple_color_ff0001" ? 'active' : ''), onTouchStart: that.changeStrokeColorClick.bind(that, "simple_color_ff0001", 'ff0001'), id: "mobile_simple_color_ff0001" },
	                                    _react2['default'].createElement('span', { className: 'add-nowrap', style: { backgroundColor: '#ff0001' } })
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { className: "simple-color-fcd000 " + (that.state.useStrokeColor === "simple_color_fcd000" ? 'active' : ''), onTouchStart: that.changeStrokeColorClick.bind(that, "simple_color_fcd000", 'fcd000'), id: "mobile_simple_color_fcd000" },
	                                    _react2['default'].createElement('span', { className: 'add-nowrap', style: { backgroundColor: '#fcd000' } })
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { className: "simple-color-0488f8 " + (that.state.useStrokeColor === "simple_color_0488f8" ? 'active' : ''), onTouchStart: that.changeStrokeColorClick.bind(that, "simple_color_0488f8", '0488f8'), id: "mobile_simple_color_0488f8" },
	                                    _react2['default'].createElement('span', { className: 'add-nowrap', style: { backgroundColor: '#0488f8' } })
	                                )
	                            )
	                        )
	                    ) : undefined,
	                    !measure ? undefined : TK.SDKTYPE === 'mobile' ? _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-measure " + (currentExtendToolExtraContainer === 'whiteboard_tool_vessel_measure' ? 'active more' : ''), id: 'whiteboard_tool_vessel_measure', onMouseLeave: that.allLiMouseLeave.bind(that, 'whiteboard_tool_vessel_measure'), style: { display: !measure ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool  tool-measure  tool-more', title: _TkGlobal2['default'].language.languageData.header.tool.measure.title, id: 'tool_measure_list', onTouchStart: that.selectExtendExtraTool.bind(that, { extendToolId: 'whiteboard_tool_vessel_measure' }) },
	                            _react2['default'].createElement(
	                                'span',
	                                { className: 'tool-img-wrap' },
	                                _react2['default'].createElement('em', { style: { width: (useStrokeSize === 'tool_color_measure_small' ? 0.1 : useStrokeSize === 'tool_color_measure_middle' ? 0.2 : 0.3) + 'rem', height: (useStrokeSize === 'tool_color_measure_small' ? 0.1 : useStrokeSize === 'tool_color_measure_middle' ? 0.2 : 0.3) + 'rem' } })
	                            )
	                        ),
	                        _react2['default'].createElement(
	                            'div',
	                            { className: 'header-tool-extend tool-measure-extend' },
	                            _react2['default'].createElement(
	                                'ul',
	                                { className: 'clear-float' },
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_color_measure_small', onTouchStart: that.changeStrokeSizeClick.bind(that, 'tool_color_measure_small', { pencil: 5, text: 25, eraser: 50, shape: 5 }), className: "h-tool-measure-mobile h-tool-measure-small-mobile " + (useStrokeSize === 'tool_color_measure_small' ? 'active' : '') },
	                                    _react2['default'].createElement('span', { className: 'add-nowrap', style: { width: '0.1rem', height: '0.1rem' } })
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_color_measure_middle', onTouchStart: that.changeStrokeSizeClick.bind(that, 'tool_color_measure_middle', { pencil: 15, text: 50, eraser: 100, shape: 15 }), className: "h-tool-measure-mobile h-tool-measure-middle-mobile " + (useStrokeSize === 'tool_color_measure_middle' ? 'active' : '') },
	                                    _react2['default'].createElement('span', { className: 'add-nowrap', style: { width: '0.2rem', height: '0.2rem' } })
	                                ),
	                                _react2['default'].createElement(
	                                    'li',
	                                    { id: 'tool_color_measure_big', onTouchStart: that.changeStrokeSizeClick.bind(that, 'tool_color_measure_big', { pencil: 30, text: 100, eraser: 200, shape: 30 }), className: "h-tool-measure-mobile h-tool-measure-big-mobile " + (useStrokeSize === 'tool_color_measure_big' ? 'active' : '') },
	                                    _react2['default'].createElement('span', { className: 'add-nowrap', style: { width: '0.3rem', height: '0.3rem' } })
	                                )
	                            )
	                        )
	                    ) : undefined,
	                    !undo ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: 'tool-li tl-undo', id: 'whiteboard_tool_vessel_undo', style: { display: !undo ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { disabled: action_undo.disabled, className: "header-tool not-active " + (action_undo.disabled ? 'disabled' : ''), id: 'tool_operation_undo', title: _TkGlobal2['default'].language.languageData.header.tool.undo.title, onTouchStart: that.useWhiteboardAction.bind(that, { actionId: 'action_undo' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    ),
	                    !redo ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: 'tool-li tl-redo', id: 'whiteboard_tool_vessel_redo', style: { display: !redo ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { disabled: action_redo.disabled, className: "header-tool not-active " + (action_redo.disabled ? 'disabled' : ''), id: 'tool_operation_redo', title: _TkGlobal2['default'].language.languageData.header.tool.redo.title, onTouchStart: that.useWhiteboardAction.bind(that, { actionId: 'action_redo' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    ),
	                    !eraser ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-eraser " + (currentUseTool === 'tool_eraser' ? 'active' : ''), id: 'whiteboard_tool_vessel_eraser', style: { display: !eraser ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool tool-eraser', title: _TkGlobal2['default'].language.languageData.header.tool.eraser.title, id: 'tool_eraser', onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_eraser' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    ),
	                    !clear ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: 'tool-li tl-clear', id: 'whiteboard_tool_vessel_clear', style: { display: !clear ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { disabled: action_clear.disabled, className: "header-tool not-active " + (action_clear.disabled ? 'disabled' : ''), id: 'tool_operation_clear', title: _TkGlobal2['default'].language.languageData.header.tool.clear.title, onTouchStart: that.useWhiteboardAction.bind(that, { actionId: 'action_clear' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    ),
	                    !colorAndSize ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-color " + (currentExtendToolExtraContainer === 'whiteboard_tool_vessel_color_strokesize' ? 'active more' : ''), id: 'whiteboard_tool_vessel_color_strokesize', onMouseLeave: that.allLiMouseLeave.bind(that, 'whiteboard_tool_vessel_color_strokesize'), style: { display: !colorAndSize ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', id: 'tool_stroke_color_vessel', title: _TkGlobal2['default'].language.languageData.header.tool.colorAndMeasure.title, onTouchStart: that.selectExtendExtraTool.bind(that, { extendToolId: 'whiteboard_tool_vessel_color_strokesize' }) },
	                            _react2['default'].createElement(
	                                'span',
	                                { id: 'tool_stroke_color', className: 'tool-img-wrap h-tool-color no-hover' },
	                                _react2['default'].createElement(
	                                    'span',
	                                    { 'data-curr-type': 'simple', 'data-curr-color': '000000', className: 'tool-color-show tk-tool-color', id: 'header_curr_color', style: { backgroundColor: "#" + that.state.selectColor } },
	                                    _react2['default'].createElement('span', { className: 'tool_triangle' })
	                                )
	                            )
	                        ),
	                        _react2['default'].createElement(
	                            'div',
	                            { className: 'header-tool-extend tool-color-extend clear-float tk-tool-color-extend' },
	                            _react2['default'].createElement(
	                                'div',
	                                { className: 'tool-measure-container add-fl', id: 'tool_measure' },
	                                _react2['default'].createElement(
	                                    'div',
	                                    { className: 'h-tool-measure-title' },
	                                    _react2['default'].createElement(
	                                        'span',
	                                        null,
	                                        _TkGlobal2['default'].language.languageData.header.tool.colorAndMeasure.selectMeasure
	                                    )
	                                ),
	                                _react2['default'].createElement(
	                                    'div',
	                                    { id: 'tool_color_measure_small', onTouchStart: that.changeStrokeSizeClick.bind(that, 'tool_color_measure_small', { pencil: 5, text: 18, eraser: 30, shape: 5 }), className: "h-tool-measure h-tool-measure-small " + (useStrokeSize === 'tool_color_measure_small' ? 'active' : '') },
	                                    _react2['default'].createElement('span', null)
	                                ),
	                                _react2['default'].createElement(
	                                    'div',
	                                    { id: 'tool_color_measure_middle', onTouchStart: that.changeStrokeSizeClick.bind(that, 'tool_color_measure_middle', { pencil: 15, text: 36, eraser: 90, shape: 15 }), className: "h-tool-measure h-tool-measure-middle " + (useStrokeSize === 'tool_color_measure_middle' ? 'active' : '') },
	                                    _react2['default'].createElement('span', null)
	                                ),
	                                _react2['default'].createElement(
	                                    'div',
	                                    { id: 'tool_color_measure_big', onTouchStart: that.changeStrokeSizeClick.bind(that, 'tool_color_measure_big', { pencil: 30, text: 72, eraser: 150, shape: 30 }), className: "h-tool-measure h-tool-measure-big " + (useStrokeSize === 'tool_color_measure_big' ? 'active' : '') },
	                                    _react2['default'].createElement('span', null)
	                                )
	                            ),
	                            _react2['default'].createElement(
	                                'div',
	                                { className: 'tool-color-container add-fl' },
	                                _react2['default'].createElement(
	                                    'div',
	                                    { className: 'header-tool-extend-option-wrap  header-tool-extend-option-color ' },
	                                    _react2['default'].createElement(
	                                        'div',
	                                        { className: 'h-tool-extend-option-title' },
	                                        _TkGlobal2['default'].language.languageData.header.tool.colorAndMeasure.selectColorText
	                                    ),
	                                    _react2['default'].createElement(
	                                        'div',
	                                        { className: 'h-tool-extend-option-content' },
	                                        _react2['default'].createElement(
	                                            'div',
	                                            { className: 'h-curr-color-wrap', id: 'header_curr_select_color' },
	                                            _react2['default'].createElement('span', { className: 'h-curr-color', style: { backgroundColor: "#" + this.state.selectColor } })
	                                        ),
	                                        _react2['default'].createElement(
	                                            'div',
	                                            { className: 'h-color-list-wrap clear-float', id: 'header_color_list' },
	                                            _react2['default'].createElement(
	                                                'div',
	                                                { className: 'h-color-simple add-fl' },
	                                                _react2['default'].createElement(
	                                                    'ul',
	                                                    { className: 'clear-float' },
	                                                    smipleColorElementArray
	                                                )
	                                            ),
	                                            _react2['default'].createElement(
	                                                'div',
	                                                { className: 'h-color-more add-fl' },
	                                                moreColorElementArray
	                                            )
	                                        )
	                                    )
	                                )
	                            )
	                        )
	                    )
	                ) : _react2['default'].createElement(
	                    'ol',
	                    { className: 'add-fl clear-float h-tool tool-whiteboard-container phone ', id: 'header_tool_vessel', style: { display: !that.state.show ? 'none' : '' } },
	                    ' ',
	                    !mouse ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-mouse " + (currentUseTool === 'tool_mouse' ? 'active' : ''), id: 'whiteboard_tool_vessel_mouse', style: { display: !mouse ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', title: _TkGlobal2['default'].language.languageData.header.tool.mouse.title, id: 'tool_mouse', onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_mouse' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    ),
	                    !colors ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li  tl-color simple-color-000000 " + (that.state.useStrokeColor === "simple_color_000000" ? 'active' : ''), id: "whiteboard_tool_vessel_color_000000", style: { display: !colors ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', id: 'tool_color_000000', onTouchStart: that.changeStrokeColorClick.bind(that, "simple_color_000000", '000000') },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap', style: { backgroundColor: '#000000' } })
	                        )
	                    ),
	                    !colors ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-color  simple-color-ff0001 " + (that.state.useStrokeColor === "simple_color_ff0001" ? 'active' : ''), id: "whiteboard_tool_vessel_color_ff0001", style: { display: !colors ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', id: 'tool_color_ff0001', onTouchStart: that.changeStrokeColorClick.bind(that, "simple_color_ff0001", 'ff0001') },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap', style: { backgroundColor: '#ff0001' } })
	                        )
	                    ),
	                    !colors ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li  tl-color simple-color-fcd000 " + (that.state.useStrokeColor === "simple_color_fcd000" ? 'active' : ''), id: "whiteboard_tool_vessel_color_fcd000", style: { display: !colors ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', id: 'tool_color_fcd000', onTouchStart: that.changeStrokeColorClick.bind(that, "simple_color_fcd000", 'fcd000') },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap', style: { backgroundColor: '#fcd000' } })
	                        )
	                    ),
	                    !colors ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li  tl-color simple-color-0488f8 " + (that.state.useStrokeColor === "simple_color_0488f8" ? 'active' : ''), id: "whiteboard_tool_vessel_color_0488f8", style: { display: !colors ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', id: 'tool_color_0488f8', onTouchStart: that.changeStrokeColorClick.bind(that, "simple_color_0488f8", '0488f8') },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap', style: { backgroundColor: '#0488f8' } })
	                        )
	                    ),
	                    !brush ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-pencil " + (currentUseTool === 'tool_pencil' ? 'active' : ''), id: 'whiteboard_tool_vessel_pencil', style: { display: !brush ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool', title: _TkGlobal2['default'].language.languageData.header.tool.pencil.title, id: 'tool_pencil', onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_pencil' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    ),
	                    !eraser ? undefined : _react2['default'].createElement(
	                        'li',
	                        { className: "tool-li tl-eraser " + (currentUseTool === 'tool_eraser' ? 'active' : ''), id: 'whiteboard_tool_vessel_eraser', style: { display: !eraser ? 'none' : undefined } },
	                        _react2['default'].createElement(
	                            'button',
	                            { className: 'header-tool tool-eraser', title: _TkGlobal2['default'].language.languageData.header.tool.eraser.title, id: 'tool_eraser', onTouchStart: that.selectCurrentUseTool.bind(that, { toolId: 'tool_eraser' }) },
	                            _react2['default'].createElement('span', { className: 'tool-img-wrap' })
	                        )
	                    )
	                )
	            );
	        }
	    }]);
	
	    return WhiteboardToolBarSmart;
	})(_react2['default'].Component);
	
	;
	exports['default'] = WhiteboardToolBarSmart;
	module.exports = exports['default'];
	/*白板工具栏*/ /*白板工具栏*/
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(41)))

/***/ }),

/***/ 272:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 信令发送接口封装类
	 * @class SignallingInterface
	 * @description   提供系统所需要的信令发送请求
	 * @author QiuShao
	 * @date 2017/08/09
	 */
	
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _tk_classTkConstant = __webpack_require__(18);
	
	var _tk_classTkConstant2 = _interopRequireDefault(_tk_classTkConstant);
	
	var SignallingInterface = (function () {
	    function SignallingInterface() {
	        _classCallCheck(this, SignallingInterface);
	    }
	
	    _createClass(SignallingInterface, [{
	        key: 'pubMsg',
	
	        /*发送room-pubMsg信令
	        * @method pubMsg*/
	        value: function pubMsg(signallingName, id, toID, data, do_not_save, expiresabs, associatedMsgID, associatedUserID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('pubMsg')) {
	                return;
	            };
	            if (_TkGlobal2['default'].appConnected) {
	                toID = toID || "__all";
	                var save = !do_not_save;
	                if (data && typeof data === 'object') {
	                    data = JSON.stringify(data);
	                }
	                _ServiceRoom2['default'].getTkRoom().pubMsg(signallingName, id, toID, data, save, expiresabs, associatedMsgID, associatedUserID);
	            }
	        }
	    }, {
	        key: 'delMsg',
	
	        /*发送room-delMsg信令
	         * @method pubMsg*/
	        value: function delMsg(signallingName, id, toID, data) {
	            if (!_CoreController2['default'].handler.getAppPermissions('delMsg')) {
	                return;
	            };
	            if (_TkGlobal2['default'].appConnected) {
	                toID = toID || "__all";
	                if (data && typeof data === 'object') {
	                    data = JSON.stringify(data);
	                }
	                _ServiceRoom2['default'].getTkRoom().delMsg(signallingName, id, toID, data);
	            }
	        }
	    }, {
	        key: 'setProperty',
	
	        /*发送room-setProperty更新参与者属性
	         * @method pubMsg*/
	        value: function setProperty(id, toID, properties) {
	            if (!_CoreController2['default'].handler.getAppPermissions('setProperty')) {
	                return;
	            };
	            if (_TkGlobal2['default'].appConnected) {
	                toID = toID || "__all";
	                _ServiceRoom2['default'].getTkRoom().changeUserProperty(id, toID, properties);
	            }
	        }
	    }, {
	        key: 'setParticipantPropertyToAll',
	
	        /*设置参与者属性发送给所有人
	        * @method setParticipantPropertyToAll*/
	        value: function setParticipantPropertyToAll(id, properties) {
	            if (!_CoreController2['default'].handler.getAppPermissions('setParticipantPropertyToAll')) {
	                return;
	            };
	            var that = this;
	            var toID = "__all";
	            var user = _ServiceRoom2['default'].getTkRoom().getUsers()[id];
	            if (!user) {
	                L.Logger.error('user is not exist  , user id is ' + id + '!');return;
	            };
	            if (!(user.role === _tk_classTkConstant2['default'].role.roleChairman || user.role === _tk_classTkConstant2['default'].role.roleStudent || user.role === _tk_classTkConstant2['default'].role.roleTeachingAssistant && _tk_classTkConstant2['default'].joinRoomInfo.assistantOpenMyseftAV) && properties && properties.publishstate != undefined) {
	                //xgd 17-09-15
	                return;
	            }
	            that.setProperty(id, toID, properties);
	        }
	    }, {
	        key: 'sendSignallingDataToParticipant',
	
	        /*发送delMsg或者pubMsg信令数据给服务器，由服务器负责分发给参与者
	        * @method sendSignallingDataToParticipant*/
	        value: function sendSignallingDataToParticipant(isDelMsg, signallingName, id, toID, data, do_not_save, expiresabs, associatedMsgID, associatedUserID) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendSignallingDataToParticipant')) {
	                return;
	            };
	            var that = this;
	            if (isDelMsg) {
	                that.delMsg(signallingName, id, toID, data);
	            } else {
	                that.pubMsg(signallingName, id, toID, data, do_not_save, expiresabs, associatedMsgID, associatedUserID);
	            }
	        }
	    }, {
	        key: 'sendTextMessage',
	
	        /*发送聊天消息
	        * @method sendTextMessage
	        * params[message:string(require) ,toId:string]*/
	        value: function sendTextMessage(message, toId) {
	            if (!_CoreController2['default'].handler.getAppPermissions('sendTextMessage')) {
	                return;
	            };
	            if (_TkGlobal2['default'].appConnected) {
	                if (message) {
	                    toId = toId || "__all";
	                    if (message && typeof message === 'object') {
	                        message = JSON.stringify(message);
	                    }
	                    _ServiceRoom2['default'].getTkRoom().sendMessage(message, toId);
	                }
	            }
	        }
	    }]);
	
	    return SignallingInterface;
	})();
	
	;
	exports['default'] = SignallingInterface;
	module.exports = exports['default'];

/***/ }),

/***/ 273:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 主要入口
	 * @module tkApp
	 * @description   提供 系统程序的入口
	 * @author QiuShao
	 * @date 2017/7/21
	 */
	
	'use strict';
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _react = __webpack_require__(4);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(42);
	
	var _reactDom2 = _interopRequireDefault(_reactDom);
	
	var _reactRouter = __webpack_require__(171);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _containersTkMobileTkMobile = __webpack_require__(253);
	
	var _containersTkMobileTkMobile2 = _interopRequireDefault(_containersTkMobileTkMobile);
	
	_CoreController2['default'].handler.loadSystemRequiredInfo(); //加载系统所需的信息
	/*根据路由决定渲染的页面*/
	_reactDom2['default'].render(_react2['default'].createElement(
	    _reactRouter.Router,
	    { history: _reactRouter.hashHistory },
	    _react2['default'].createElement(_reactRouter.Route, { path: '/', component: _containersTkMobileTkMobile2['default'] }),
	    _react2['default'].createElement(_reactRouter.Route, { path: '/mobile', component: _containersTkMobileTkMobile2['default'] }),
	    _react2['default'].createElement(_reactRouter.Route, { path: '/mobileApp', component: _containersTkMobileTkMobile2['default'] })
	), document.getElementById('tk_app'));

/***/ }),

/***/ 274:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 角色相关处理类
	 * @class RoleHandler
	 * @description   提供角色相关的处理功能
	 * @author QiuShao
	 * @date 2017/7/21
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _TkAppPermissions = __webpack_require__(122);
	
	var _TkAppPermissions2 = _interopRequireDefault(_TkAppPermissions);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var RoleHandler = (function () {
	    function RoleHandler(role) {
	        _classCallCheck(this, RoleHandler);
	
	        this.role = role;
	    }
	
	    /*获取角色的默认权限*/
	
	    _createClass(RoleHandler, [{
	        key: 'getRoleHasDefalutAppPermissions',
	        value: function getRoleHasDefalutAppPermissions(specifiedAppPermissions) {
	            /*默认权限*/
	            var roleHasDefalutAppPermissions = specifiedAppPermissions || _TkAppPermissions2['default'].productionDefaultAppAppPermissions();
	            if (_TkConstant2['default'].joinRoomInfo && _TkConstant2['default'].joinRoomInfo.roomrole != undefined) {
	                switch (_TkConstant2['default'].joinRoomInfo.roomrole) {
	                    case _TkConstant2['default'].role.roleChairman:
	                        //老师
	                        if (!_TkGlobal2['default'].classBegin) {
	                            //没有上课时的权限
	                            Object.assign(roleHasDefalutAppPermissions, {
	                                dynamicPptActionClick: true, //动态PPT点击动作的权限
	                                whiteboardPagingPage: true, //白板翻页权限
	                                newpptPagingPage: true, //动态ppt翻页权限
	                                h5DocumentPagingPage: true, //h5课件翻页权限
	                                jumpPage: true, //能否输入页数跳转到指定文档页权限
	                                pubMsg: true, //pubMsg 信令权限
	                                delMsg: true, //delMsg 信令权限
	                                setProperty: true, //setProperty 信令权限
	                                sendSignallingFromShowPage: true, //发送ShowPage相关的信令权限
	                                sendSignallingFromDynamicPptShowPage: true, //发送动态PPT的ShowPage相关数据权限
	                                sendSignallingFromH5ShowPage: true, //发送H5文档的ShowPage相关数据权限
	                                sendSignallingFromGeneralShowPage: true, //发送普通文档的ShowPage相关数据权限
	                                setParticipantPropertyToAll: true, //setParticipantPropertyToAll 设置参与者属性发送给所有人权限
	                                sendSignallingDataToParticipant: true, //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	                                h5DocumentActionClick: true, //h5课件点击动作的权限
	                                endClassbeginRevertToStartupLayout: true });
	                        } else //下课后恢复界面的默认界面的权限
	                            {
	                                var _iteratorNormalCompletion = true;
	                                var _didIteratorError = false;
	                                var _iteratorError = undefined;
	
	                                try {
	                                    for (var _iterator = Object.keys(roleHasDefalutAppPermissions)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                                        var key = _step.value;
	
	                                        roleHasDefalutAppPermissions[key] = true; //所有权限都有
	                                    }
	                                } catch (err) {
	                                    _didIteratorError = true;
	                                    _iteratorError = err;
	                                } finally {
	                                    try {
	                                        if (!_iteratorNormalCompletion && _iterator['return']) {
	                                            _iterator['return']();
	                                        }
	                                    } finally {
	                                        if (_didIteratorError) {
	                                            throw _iteratorError;
	                                        }
	                                    }
	                                }
	
	                                Object.assign(roleHasDefalutAppPermissions, {
	                                    raisehand: false, //举手权限
	                                    dialCircleClick: false });
	                            }
	                        //转盘是否可以点击
	                        break;
	                    case _TkConstant2['default'].role.roleTeachingAssistant:
	                        //助教
	                        if (!_TkGlobal2['default'].classBegin) {
	                            //没有上课时的权限
	                            Object.assign(roleHasDefalutAppPermissions, {
	                                dynamicPptActionClick: true, //动态PPT点击动作的权限
	                                whiteboardPagingPage: true, //白板翻页权限
	                                newpptPagingPage: true, //动态ppt翻页权限
	                                h5DocumentPagingPage: true, //h5课件ppt翻页权限
	                                jumpPage: true, //能否输入页数跳转到指定文档页权限
	                                sendSignallingFromShowPage: true, //发送ShowPage相关的信令权限
	                                sendSignallingFromDynamicPptShowPage: true, //发送动态PPT的ShowPage相关数据权限
	                                sendSignallingFromH5ShowPage: true, //发送H5文档的ShowPage相关数据权限
	                                sendSignallingFromGeneralShowPage: true, //发送普通文档的ShowPage相关数据权限
	                                pubMsg: true, //pubMsg 信令权限
	                                delMsg: true, //delMsg 信令权限
	                                setProperty: true, //setProperty 信令权限
	                                setParticipantPropertyToAll: true, //setParticipantPropertyToAll 设置参与者属性发送给所有人权限
	                                sendSignallingDataToParticipant: true, //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	                                h5DocumentActionClick: true });
	                        } else //h5课件点击动作的权限
	                            {
	                                var _iteratorNormalCompletion2 = true;
	                                var _didIteratorError2 = false;
	                                var _iteratorError2 = undefined;
	
	                                try {
	                                    for (var _iterator2 = Object.keys(roleHasDefalutAppPermissions)[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	                                        var key = _step2.value;
	
	                                        roleHasDefalutAppPermissions[key] = true; //先设置所有权限都有，后面再设置特殊权限
	                                    }
	                                } catch (err) {
	                                    _didIteratorError2 = true;
	                                    _iteratorError2 = err;
	                                } finally {
	                                    try {
	                                        if (!_iteratorNormalCompletion2 && _iterator2['return']) {
	                                            _iterator2['return']();
	                                        }
	                                    } finally {
	                                        if (_didIteratorError2) {
	                                            throw _iteratorError2;
	                                        }
	                                    }
	                                }
	
	                                Object.assign(roleHasDefalutAppPermissions, {
	                                    laser: false, //激光笔权限
	                                    endClassbeginRevertToStartupLayout: false });
	                            }
	                        //下课后恢复界面的默认界面的权限
	                        break;
	                    case _TkConstant2['default'].role.rolePatrol:
	                        //巡课
	                        if (!_TkGlobal2['default'].classBegin) {
	                            //没有上课时的权限
	                            Object.assign(roleHasDefalutAppPermissions, {
	                                pubMsg: true, //pubMsg 信令权限
	                                delMsg: true, //delMsg 信令权限
	                                setProperty: true, //setProperty 信令权限
	                                setParticipantPropertyToAll: true, //setParticipantPropertyToAll 设置参与者属性发送给所有人权限
	                                sendSignallingDataToParticipant: true, //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	                                whiteboardPagingPage: false, //白板翻页权限
	                                newpptPagingPage: false, //动态ppt翻页权限
	                                h5DocumentPagingPage: false });
	                        } else //h5课件ppt翻页权限
	                            {
	                                Object.assign(roleHasDefalutAppPermissions, {
	                                    pubMsg: true, //pubMsg 信令权限
	                                    delMsg: true, //delMsg 信令权限
	                                    setProperty: true, //setProperty 信令权限
	                                    setParticipantPropertyToAll: true, //setParticipantPropertyToAll 设置参与者属性发送给所有人权限
	                                    sendSignallingDataToParticipant: true, //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	                                    whiteboardPagingPage: false, //白板翻页权限
	                                    newpptPagingPage: false, //动态ppt翻页权限
	                                    h5DocumentPagingPage: false });
	                            }
	                        //h5课件ppt翻页权限
	                        break;
	                    case _TkConstant2['default'].role.roleStudent:
	                        //学生
	                        if (!_TkGlobal2['default'].classBegin) {
	                            //没有上课时的权限
	                            Object.assign(roleHasDefalutAppPermissions, {
	                                whiteboardPagingPage: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //白板翻页权限
	                                newpptPagingPage: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //动态ppt翻页权限
	                                h5DocumentPagingPage: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //h5课件翻页权限
	                                jumpPage: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //能否输入页数跳转到指定文档页权限
	                                h5DocumentActionClick: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //h5课件点击动作的权限
	                                dynamicPptActionClick: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //动态PPT点击动作的权限
	                                sendSignallingFromShowPage: true, //发送ShowPage相关的信令权限
	                                sendSignallingFromDynamicPptShowPage: true, //发送动态PPT的ShowPage相关数据权限
	                                sendSignallingFromH5ShowPage: true, //发送H5文档的ShowPage相关数据权限
	                                sendSignallingFromGeneralShowPage: true, //发送普通文档的ShowPage相关数据权限
	                                pubMsg: true, //pubMsg 信令权限
	                                delMsg: true, //delMsg 信令权限
	                                setProperty: true, //setProperty 信令权限
	                                setParticipantPropertyToAll: true, //setParticipantPropertyToAll 设置参与者属性发送给所有人权限
	                                sendSignallingDataToParticipant: true });
	                        } else //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	                            {
	                                Object.assign(roleHasDefalutAppPermissions, { //学生采用默认权限,如有需要可以在后面动态更改权限
	                                    whiteboardPagingPage: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //白板翻页权限
	                                    newpptPagingPage: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //动态ppt翻页权限
	                                    h5DocumentPagingPage: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //h5课件翻页权限
	                                    jumpPage: _TkConstant2['default'].joinRoomInfo.isSupportPageTrun, //能否输入页数跳转到指定文档页权限
	                                    sendSignallingFromShowPage: true, //发送ShowPage相关的信令权限
	                                    sendSignallingFromDynamicPptShowPage: true, //发送动态PPT的ShowPage相关数据权限
	                                    sendSignallingFromH5ShowPage: true, //发送H5文档的ShowPage相关数据权限
	                                    sendSignallingFromGeneralShowPage: true, //发送普通文档的ShowPage相关数据权限
	                                    pubMsg: true, //pubMsg 信令权限
	                                    delMsg: true, //delMsg 信令权限
	                                    setProperty: true, //setProperty 信令权限
	                                    setParticipantPropertyToAll: true, //setParticipantPropertyToAll 设置参与者属性发送给所有人权限
	                                    sendSignallingDataToParticipant: true, //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	                                    sendSignallingFromSharpsChange: true });
	                            }
	                        //发送白板数据相关的信令权限
	                        break;
	                    case _TkConstant2['default'].role.rolePlayback:
	                        //回放者
	                        if (!_TkGlobal2['default'].classBegin) {
	                            //没有上课时的权限
	                            Object.assign(roleHasDefalutAppPermissions, {
	                                pubMsg: false, //pubMsg 信令权限
	                                delMsg: false, //delMsg 信令权限
	                                setProperty: false, //setProperty 信令权限
	                                setParticipantPropertyToAll: false, //setParticipantPropertyToAll 设置参与者属性发送给所有人权限
	                                sendSignallingDataToParticipant: false });
	                        } else //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	                            {
	                                Object.assign(roleHasDefalutAppPermissions, { //回放者采用默认权限,如有需要可以在后面动态更改权限
	                                    pubMsg: false, //pubMsg 信令权限
	                                    delMsg: false, //delMsg 信令权限
	                                    setProperty: false, //setProperty 信令权限
	                                    setParticipantPropertyToAll: false, //setParticipantPropertyToAll 设置参与者属性发送给所有人权限
	                                    sendSignallingDataToParticipant: false });
	                            }
	                        //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	                        break;
	                    case _TkConstant2['default'].role.roleAudit:
	                        //直播 17-09-20
	                        var _iteratorNormalCompletion3 = true;
	                        var _didIteratorError3 = false;
	                        var _iteratorError3 = undefined;
	
	                        try {
	                            for (var _iterator3 = Object.keys(roleHasDefalutAppPermissions)[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
	                                var key = _step3.value;
	
	                                roleHasDefalutAppPermissions[key] = false; //先设置所有权限都没有，后面再设置特殊权限
	                            }
	                        } catch (err) {
	                            _didIteratorError3 = true;
	                            _iteratorError3 = err;
	                        } finally {
	                            try {
	                                if (!_iteratorNormalCompletion3 && _iterator3['return']) {
	                                    _iterator3['return']();
	                                }
	                            } finally {
	                                if (_didIteratorError3) {
	                                    throw _iteratorError3;
	                                }
	                            }
	                        }
	
	                        Object.assign(roleHasDefalutAppPermissions, {
	                            pubMsg: true, //pubMsg 信令权限
	                            sendSignallingDataToParticipant: true });
	                }
	            }
	            //sendSignallingDataToParticipant 发送信令pubmsg和delmsg的权限
	            return roleHasDefalutAppPermissions;
	        }
	
	        /*注册角色相关的事件*/
	    }, {
	        key: 'addEventListenerToRoomHandler',
	        value: function addEventListenerToRoomHandler() {
	            var that = this;
	        }
	    }]);
	
	    return RoleHandler;
	})();
	
	var RoleHandlerInstance = new RoleHandler();
	RoleHandlerInstance.addEventListenerToRoomHandler();
	exports['default'] = RoleHandlerInstance;
	module.exports = exports['default'];

/***/ }),

/***/ 275:
/***/ (function(module, exports, __webpack_require__) {

	/**
	 * 房间相关处理类
	 * @class RoomHandler
	 * @description   提供 房间相关的处理功能
	 * @author QiuShao
	 * @date 2017/7/21
	 */
	'use strict';
	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	
	var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i['return']) _i['return'](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError('Invalid attempt to destructure non-iterable instance'); } }; })();
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }
	
	var _reactRouter = __webpack_require__(171);
	
	var _eventObjectDefine = __webpack_require__(10);
	
	var _eventObjectDefine2 = _interopRequireDefault(_eventObjectDefine);
	
	var _TkConstant = __webpack_require__(18);
	
	var _TkConstant2 = _interopRequireDefault(_TkConstant);
	
	var _TkUtils = __webpack_require__(19);
	
	var _TkUtils2 = _interopRequireDefault(_TkUtils);
	
	var _RoleHandler = __webpack_require__(274);
	
	var _RoleHandler2 = _interopRequireDefault(_RoleHandler);
	
	var _CoreController = __webpack_require__(20);
	
	var _CoreController2 = _interopRequireDefault(_CoreController);
	
	var _ServiceTooltip = __webpack_require__(121);
	
	var _ServiceTooltip2 = _interopRequireDefault(_ServiceTooltip);
	
	var _TkGlobal = __webpack_require__(12);
	
	var _TkGlobal2 = _interopRequireDefault(_TkGlobal);
	
	var _ServiceRoom = __webpack_require__(22);
	
	var _ServiceRoom2 = _interopRequireDefault(_ServiceRoom);
	
	var _ServiceSignalling = __webpack_require__(25);
	
	var _ServiceSignalling2 = _interopRequireDefault(_ServiceSignalling);
	
	var _ServiceTools = __webpack_require__(120);
	
	var _ServiceTools2 = _interopRequireDefault(_ServiceTools);
	
	var _TkAppPermissions = __webpack_require__(122);
	
	var _TkAppPermissions2 = _interopRequireDefault(_TkAppPermissions);
	
	var _containersWhiteboardAndNewpptPlugsLiterallyJsHandlerWhiteboardAndCore = __webpack_require__(119);
	
	var _containersWhiteboardAndNewpptPlugsLiterallyJsHandlerWhiteboardAndCore2 = _interopRequireDefault(_containersWhiteboardAndNewpptPlugsLiterallyJsHandlerWhiteboardAndCore);
	
	var RoomHandler = (function () {
	    function RoomHandler(room) {
	        _classCallCheck(this, RoomHandler);
	
	        this.room = room;
	    }
	
	    _createClass(RoomHandler, [{
	        key: 'registerEventToRoom',
	
	        /*注册事件给room，与底层相关
	        * @method  registerEventToRoom*/
	        value: function registerEventToRoom() {
	            var _loop = function (eventKey) {
	                _ServiceRoom2['default'].getTkRoom().addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent[eventKey], function (recvEventData) {
	                    var isLog = true;
	                    if (recvEventData.type === 'stream-rtcStats') {
	                        isLog = false;
	                    }
	                    if (isLog) {
	                        L.Logger.debug(_TkConstant2['default'].EVENTTYPE.RoomEvent[eventKey] + " event:", recvEventData);
	                    }
	                    _eventObjectDefine2['default'].Room.dispatchEvent(recvEventData, false);
	                });
	            };
	
	            /**@description Room类-RoomEvent的相关事件**/
	            for (var eventKey in _TkConstant2['default'].EVENTTYPE.RoomEvent) {
	                _loop(eventKey);
	            }
	        }
	    }, {
	        key: 'addEventListenerToRoomHandler',
	
	        /*添加事件监听到Room*/
	        value: function addEventListenerToRoomHandler() {
	            var that = this;
	            /**@description Room类-RoomEvent的相关事件**/
	
	            var _loop2 = function (eventKey) {
	                _eventObjectDefine2['default'].Room.addEventListener(_TkConstant2['default'].EVENTTYPE.RoomEvent[eventKey], function (recvEventData) {
	                    if (that['handler' + _TkUtils2['default'].replaceFirstUper(eventKey)] && typeof that['handler' + _TkUtils2['default'].replaceFirstUper(eventKey)] === "function") {
	                        var isReturn = that['handler' + _TkUtils2['default'].replaceFirstUper(eventKey)](recvEventData);
	                        if (isReturn) {
	                            return;
	                        }; //是否直接return，不做后面的事件再次分发
	                    }
	                    var isLog = true;
	                    if (recvEventData.type === 'stream-rtcStats') {
	                        isLog = false;
	                    }
	                    _eventObjectDefine2['default'].CoreController.dispatchEvent(recvEventData, isLog);
	                });
	            };
	
	            for (var eventKey in _TkConstant2['default'].EVENTTYPE.RoomEvent) {
	                _loop2(eventKey);
	            }
	        }
	    }, {
	        key: 'handlerRoomPubmsg',
	        value: function handlerRoomPubmsg(recvEventData) {
	            //处理room-pubmsg事件
	            var that = this;
	            if (recvEventData.message && typeof recvEventData.message == "string") {
	                recvEventData.message = JSON.parse(recvEventData.message);
	            }
	            if (recvEventData.message.data && typeof recvEventData.message.data == "string") {
	                recvEventData.message.data = JSON.parse(recvEventData.message.data);
	            }
	            var pubmsgData = recvEventData.message;
	            if (!_TkGlobal2['default'].serviceTime) {
	                _TkGlobal2['default'].serviceTime = pubmsgData.ts * 1000;
	                _TkGlobal2['default'].remindServiceTime = pubmsgData.ts * 1000;
	            }
	            switch (pubmsgData.name) {
	                case "ClassBegin":
	                    //上课
	                    _TkGlobal2['default'].serviceTime = !_TkUtils2['default'].isMillisecondClass(pubmsgData.ts) ? pubmsgData.ts * 1000 : pubmsgData.ts; //服务器时间
	                    _TkGlobal2['default'].remindServiceTime = !_TkUtils2['default'].isMillisecondClass(pubmsgData.ts) ? pubmsgData.ts * 1000 : pubmsgData.ts; //remind的服务器时间
	                    that._classBeginStartHandler(pubmsgData); //上课之后的处理函数
	                    break;
	                case "UpdateTime":
	                    //更新服务器时间
	                    _TkGlobal2['default'].serviceTime = pubmsgData.ts * 1000; //服务器时间
	                    _TkGlobal2['default'].remindServiceTime = pubmsgData.ts * 1000; //remind的服务器时间
	                    if (!_TkGlobal2['default'].firstGetServiceTime && !_TkGlobal2['default'].isHandleMsglistFromRoomPubmsg && _TkGlobal2['default'].signallingMessageList) {
	                        _TkGlobal2['default'].firstGetServiceTime = true;
	                        _eventObjectDefine2['default'].Room.dispatchEvent({ type: _TkConstant2['default'].EVENTTYPE.RoomEvent.roomMsglist, message: _TkGlobal2['default'].signallingMessageList, source: 'roomPubmsg' });
	                        _TkGlobal2['default'].signallingMessageList = null;
	                        delete _TkGlobal2['default'].signallingMessageList;
	                    }
	                    break;
	                case "SharpsChange":
	                    _containersWhiteboardAndNewpptPlugsLiterallyJsHandlerWhiteboardAndCore2['default'].handlerPubmsg_SharpsChange(pubmsgData);
	                    break;
	                case "StreamFailure":
	                    L.Logger.info('StreamFailure signalling:' + JSON.stringify(pubmsgData));
	                    break;
	            }
	            if (pubmsgData.name === "sendNetworkState" || pubmsgData.name === 'BlackBoardDrag' || pubmsgData.name === 'videoDraghandle') {
	                return true;
	            }
	        }
	    }, {
	        key: 'handlerRoomDelmsg',
	        value: function handlerRoomDelmsg(recvEventData) {
	            //处理room-delmsg事件
	            var that = this;
	            if (recvEventData.message && typeof recvEventData.message == "string") {
	                recvEventData.message = JSON.parse(recvEventData.message);
	            }
	            if (recvEventData.message.data && typeof recvEventData.message.data == "string") {
	                recvEventData.message.data = JSON.parse(recvEventData.message.data);
	            }
	            var delmsgData = recvEventData.message;
	            switch (delmsgData.name) {
	                case "ClassBegin":
	                    //删除上课（也就是下课了）
	                    that._classBeginEndHandler(delmsgData); //下课之后的处理函数
	                    break;
	                case "SharpsChange":
	                    //删除白板数据
	                    _containersWhiteboardAndNewpptPlugsLiterallyJsHandlerWhiteboardAndCore2['default'].handlerDelmsg_SharpsChange(delmsgData);
	                    break;
	            }
	        }
	    }, {
	        key: 'handlerRoomConnected',
	        value: function handlerRoomConnected(roomConnectedEventData) {
	            //处理room-connected事件
	            //获取角色默认权限
	            this._bindInfoToTkConstant();
	            _TkGlobal2['default'].firstGetServiceTime = false;
	            _TkGlobal2['default'].isHandleMsglistFromRoomPubmsg = false;
	            _TkGlobal2['default'].appConnected = true; //房间连接成功
	            var roleHasDefalutAppPermissionsJson = _RoleHandler2['default'].getRoleHasDefalutAppPermissions();
	            _TkAppPermissions2['default'].initAppPermissions(roleHasDefalutAppPermissionsJson);
	            var signallingMessageList = roomConnectedEventData.message; //信令list数据
	            _TkGlobal2['default'].signallingMessageList = signallingMessageList;
	            _eventObjectDefine2['default'].Room.dispatchEvent({ type: _TkConstant2['default'].EVENTTYPE.RoomEvent.roomMsglist, message: _TkGlobal2['default'].signallingMessageList, source: 'roomConnected' });
	            if (_TkGlobal2['default'].serviceTime && !_TkGlobal2['default'].firstGetServiceTime && !_TkGlobal2['default'].isHandleMsglistFromRoomPubmsg && _TkGlobal2['default'].signallingMessageList) {
	                _TkGlobal2['default'].firstGetServiceTime = true;
	                _eventObjectDefine2['default'].Room.dispatchEvent({ type: _TkConstant2['default'].EVENTTYPE.RoomEvent.roomMsglist, message: _TkGlobal2['default'].signallingMessageList, source: 'roomPubmsg' });
	                _TkGlobal2['default'].signallingMessageList = null;
	                delete _TkGlobal2['default'].signallingMessageList;
	            }
	            /*if( ServiceRoom.getTkRoom().getMySelf().candraw !== CoreController.handler.getAppPermissions('canDraw') ){
	                ServiceSignalling.setParticipantPropertyToAll( ServiceRoom.getTkRoom().getMySelf().id , {candraw:CoreController.handler.getAppPermissions('canDraw') } );
	            }*/
	            var defalutFontSize = window.innerWidth / _TkConstant2['default'].STANDARDSIZE; //5rem = defalutFontSize*'5px' ;
	            _eventObjectDefine2['default'].Window.dispatchEvent({ type: _TkConstant2['default'].EVENTTYPE.WindowEvent.onResize, message: { defalutFontSize: defalutFontSize } });
	        }
	    }, {
	        key: 'handlerRoomDisconnected',
	        value: function handlerRoomDisconnected(roomDisconnectedEventData) {
	            _TkGlobal2['default'].appConnected = false;
	            _TkGlobal2['default'].classBegin = false;
	            _TkGlobal2['default'].serviceTime = undefined;
	            _TkGlobal2['default'].remindServiceTime = undefined;
	            _TkGlobal2['default'].signallingMessageList = null;
	            delete _TkGlobal2['default'].signallingMessageList;
	            _TkGlobal2['default'].isHandleMsglistFromRoomPubmsg = false;
	            _TkGlobal2['default'].participantGiftNumberJson = {};
	            //TkAppPermissions.resetDefaultAppPermissions(true); //恢复默认权限
	        }
	    }, {
	        key: 'handlerRoomUserpropertyChanged',
	        value: function handlerRoomUserpropertyChanged(roomUserpropertyChangedEventData) {
	            var changePropertyJson = roomUserpropertyChangedEventData.message;
	            var user = roomUserpropertyChangedEventData.user;
	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;
	
	            try {
	                for (var _iterator = Object.entries(changePropertyJson)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var _step$value = _slicedToArray(_step.value, 2);
	
	                    var key = _step$value[0];
	                    var value = _step$value[1];
	
	                    if (user.id === _ServiceRoom2['default'].getTkRoom().getMySelf().id) {
	                        if (key === 'candraw') {
	                            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromShowPage', value); //发送ShowPage相关的信令权限
	                            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromH5ShowPage', value); //发送H5文档的ShowPage相关数据权限
	                            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromDynamicPptShowPage', value); //发送动态PPT的ShowPage相关数据权限
	                            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromGeneralShowPage', value); //发送普通文档的ShowPage相关数据权限
	                            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromDynamicPptTriggerActionClick', value); //发送动态PPT触发器NewPptTriggerActionClick相关的信令权限
	                            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromH5DocumentAction', value); //发送h5文档相关动作的信令权限
	                            _TkAppPermissions2['default'].setAppPermissions('sendWhiteboardMarkTool', value); //发送标注工具信令权限
	                            _TkAppPermissions2['default'].setAppPermissions('h5DocumentActionClick', value); //h5课件点击动作的权限
	                            _TkAppPermissions2['default'].setAppPermissions('dynamicPptActionClick', value); //动态PPT点击动作的权限
	                            _TkAppPermissions2['default'].setAppPermissions('publishDynamicPptMediaPermission_video', value); //发布动态PPT视频的权限
	                            _TkAppPermissions2['default'].setAppPermissions('canDraw', value); //画笔权限
	                            if (_TkConstant2['default'].hasRole.roleStudent) {
	                                _TkAppPermissions2['default'].setAppPermissions('whiteboardPagingPage', value ? value : _TkConstant2['default'].joinRoomInfo.isSupportPageTrun); //白板翻页权限
	                                _TkAppPermissions2['default'].setAppPermissions('newpptPagingPage', value ? value : _TkConstant2['default'].joinRoomInfo.isSupportPageTrun); //动态ppt翻页权限
	                                _TkAppPermissions2['default'].setAppPermissions('h5DocumentPagingPage', value ? value : _TkConstant2['default'].joinRoomInfo.isSupportPageTrun); //h5课件翻页权限
	                                _TkAppPermissions2['default'].setAppPermissions('jumpPage', value ? value : _TkConstant2['default'].joinRoomInfo.isSupportPageTrun); //h5课件翻页权限
	                            }
	                        }
	                    }
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator['return']) {
	                        _iterator['return']();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }
	        }
	    }, {
	        key: 'handlerRoomMsglist',
	        value: function handlerRoomMsglist(roomMsglistEventData) {
	            //处理room-msglist事件
	            var that = this;
	            var _handlerRoomMsglist = function _handlerRoomMsglist(messageListData, source, ignoreSignallingJson) {
	                //room-msglist处理函数
	                var tmpSignallingData = {};
	                for (var x in messageListData) {
	                    if (ignoreSignallingJson && ignoreSignallingJson[messageListData[x].name]) {
	                        //如果有忽略的信令，则跳出本次循环
	                        continue;
	                    }
	                    if (messageListData[x].data && typeof messageListData[x].data == "string") {
	                        messageListData[x].data = JSON.parse(messageListData[x].data);
	                    }
	                    if (messageListData[x].name == "SharpsChange") {
	                        if (tmpSignallingData["SharpsChange"] == null || tmpSignallingData["SharpsChange"] == undefined) {
	                            tmpSignallingData["SharpsChange"] = [];
	                            tmpSignallingData["SharpsChange"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["SharpsChange"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "ShowPage") {
	                        if (tmpSignallingData["ShowPage"] == null || tmpSignallingData["ShowPage"] == undefined) {
	                            tmpSignallingData["ShowPage"] = [];
	                            tmpSignallingData["ShowPage"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["ShowPage"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "ClassBegin") {
	                        if (tmpSignallingData["ClassBegin"] == null || tmpSignallingData["ClassBegin"] == undefined) {
	                            tmpSignallingData["ClassBegin"] = [];
	                            tmpSignallingData["ClassBegin"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["ClassBegin"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "WBPageCount") {
	                        if (tmpSignallingData["WBPageCount"] == null || tmpSignallingData["WBPageCount"] == undefined) {
	                            tmpSignallingData["WBPageCount"] = [];
	                            tmpSignallingData["WBPageCount"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["WBPageCount"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "whiteboardMarkTool") {
	                        if (tmpSignallingData["whiteboardMarkTool"] == null || tmpSignallingData["whiteboardMarkTool"] == undefined) {
	                            tmpSignallingData["whiteboardMarkTool"] = [];
	                            tmpSignallingData["whiteboardMarkTool"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["whiteboardMarkTool"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "BlackBoard") {
	                        if (tmpSignallingData["BlackBoard"] == null || tmpSignallingData["BlackBoard"] == undefined) {
	                            tmpSignallingData["BlackBoard"] = [];
	                            tmpSignallingData["BlackBoard"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["BlackBoard"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "timer") {
	                        if (tmpSignallingData["timer"] == null || tmpSignallingData["timer"] == undefined) {
	                            tmpSignallingData["timer"] = [];
	                            tmpSignallingData["timer"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["timer"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "dial") {
	                        if (tmpSignallingData["dial"] == null || tmpSignallingData["dial"] == undefined) {
	                            tmpSignallingData["dial"] = [];
	                            tmpSignallingData["dial"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["dial"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "DialDrag") {
	                        if (tmpSignallingData["DialDrag"] == null || tmpSignallingData["DialDrag"] == undefined) {
	                            tmpSignallingData["DialDrag"] = [];
	                            tmpSignallingData["DialDrag"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["DialDrag"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "TimerDrag") {
	                        if (tmpSignallingData["TimerDrag"] == null || tmpSignallingData["TimerDrag"] == undefined) {
	                            tmpSignallingData["TimerDrag"] = [];
	                            tmpSignallingData["TimerDrag"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["TimerDrag"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "AnswerDrag") {
	                        if (tmpSignallingData["AnswerDrag"] == null || tmpSignallingData["AnswerDrag"] == undefined) {
	                            tmpSignallingData["AnswerDrag"] = [];
	                            tmpSignallingData["AnswerDrag"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["AnswerDrag"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "answer") {
	                        if (tmpSignallingData["answer"] == null || tmpSignallingData["answer"] == undefined) {
	                            tmpSignallingData["answer"] = [];
	                            tmpSignallingData["answer"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["answer"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "submitAnswers") {
	                        if (tmpSignallingData["submitAnswers"] == null || tmpSignallingData["submitAnswers"] == undefined) {
	                            tmpSignallingData["submitAnswers"] = [];
	                            tmpSignallingData["submitAnswers"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["submitAnswers"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "qiangDaQi") {
	                        if (tmpSignallingData["qiangDaQi"] == null || tmpSignallingData["qiangDaQi"] == undefined) {
	                            tmpSignallingData["qiangDaQi"] = [];
	                            tmpSignallingData["qiangDaQi"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["qiangDaQi"].push(messageListData[x]);
	                        }
	                    } else if (messageListData[x].name == "QiangDaZhe") {
	                        if (tmpSignallingData["QiangDaZhe"] == null || tmpSignallingData["QiangDaZhe"] == undefined) {
	                            tmpSignallingData["QiangDaZhe"] = [];
	                            tmpSignallingData["QiangDaZhe"].push(messageListData[x]);
	                        } else {
	                            tmpSignallingData["QiangDaZhe"].push(messageListData[x]);
	                        }
	                    }
	                };
	
	                if (source === 'roomConnected') {
	                    /*上课数据*/
	                    var classBeginArr = tmpSignallingData["ClassBegin"];
	                    if (classBeginArr != null && classBeginArr != undefined && classBeginArr.length > 0) {
	                        if (classBeginArr[classBeginArr.length - 1].name == "ClassBegin") {
	                            that._classBeginStartHandler(classBeginArr[classBeginArr.length - 1]);
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-ClassBegin',
	                                source: 'room-msglist',
	                                message: classBeginArr[classBeginArr.length - 1]
	                            });
	                        }
	                    } else {
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                            type: 'receive-msglist-not-ClassBegin',
	                            source: 'room-msglist',
	                            message: {}
	                        });
	                    }
	                    tmpSignallingData["ClassBegin"] = null;
	                } else if (source === 'roomPubmsg') {
	                    /*标注工具*/
	                    var whiteboardMarkToolArr = tmpSignallingData["whiteboardMarkTool"];
	                    if (whiteboardMarkToolArr != null && whiteboardMarkToolArr != undefined && whiteboardMarkToolArr.length > 0) {
	                        if (whiteboardMarkToolArr[whiteboardMarkToolArr.length - 1].name == "whiteboardMarkTool") {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-whiteboardMarkTool',
	                                source: 'room-msglist',
	                                message: whiteboardMarkToolArr[whiteboardMarkToolArr.length - 1]
	                            });
	                        }
	                    }
	                    tmpSignallingData["whiteboardMarkTool"] = null;
	
	                    /*画笔数据*/
	                    var sharpsChangeArr = tmpSignallingData["SharpsChange"];
	                    if (sharpsChangeArr != null && sharpsChangeArr != undefined && sharpsChangeArr.length > 0) {
	                        // eventObjectDefine.CoreController.dispatchEvent({type:'save-lc-waiting-process-data' , message:{ sharpsChangeArray:sharpsChangeArr } });
	                        _containersWhiteboardAndNewpptPlugsLiterallyJsHandlerWhiteboardAndCore2['default'].handlerMsglist_SharpsChange(sharpsChangeArr);
	                    }
	                    tmpSignallingData["SharpsChange"] = null;
	
	                    /*转盘拖拽的动作*/
	                    var DialDragArr = tmpSignallingData["DialDrag"];
	                    if (DialDragArr !== null && DialDragArr !== undefined && DialDragArr.length > 0) {
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                            type: 'receive-msglist-DialDrag',
	                            message: { DialDragArray: DialDragArr }
	                        });
	                    }
	                    tmpSignallingData["DialDrag"] = null;
	
	                    /*计时器拖拽的动作*/
	                    var TimerDragArr = tmpSignallingData["TimerDrag"];
	                    if (TimerDragArr !== null && TimerDragArr !== undefined && TimerDragArr.length > 0) {
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                            type: 'receive-msglist-TimerDrag',
	                            message: { TimerDragArray: TimerDragArr }
	                        });
	                    }
	                    tmpSignallingData["TimerDrag"] = null;
	
	                    /*答题卡拖拽的动作*/
	                    var AnswerDragArr = tmpSignallingData["AnswerDrag"];
	                    if (AnswerDragArr !== null && AnswerDragArr !== undefined && AnswerDragArr.length > 0) {
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                            type: 'receive-msglist-AnswerDrag',
	                            message: { AnswerDragArray: AnswerDragArr }
	                        });
	                    }
	                    tmpSignallingData["AnswerDrag"] = null;
	
	                    /*加页数据*/
	                    var wBPageCountArr = tmpSignallingData["WBPageCount"];
	                    if (wBPageCountArr != null && wBPageCountArr != undefined && wBPageCountArr.length > 0) {
	                        if (wBPageCountArr[wBPageCountArr.length - 1].name == "WBPageCount") {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-WBPageCount',
	                                source: 'room-msglist',
	                                message: wBPageCountArr[wBPageCountArr.length - 1]
	                            });
	                        }
	                    }
	                    tmpSignallingData["WBPageCount"] = null;
	
	                    /*倒计时数据*/
	                    var timerShowArr = tmpSignallingData["timer"];
	                    if (timerShowArr != null && timerShowArr != undefined && timerShowArr.length > 0) {
	                        if (timerShowArr[timerShowArr.length - 1].name == "timer") {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-timer',
	                                source: 'room-msglist',
	                                message: { timerShowArr: timerShowArr }
	                            });
	                        }
	                    }
	                    tmpSignallingData["timer"] = null;
	
	                    /*转盘数据*/
	                    var dialShowArr = tmpSignallingData["dial"];
	                    if (dialShowArr != null && dialShowArr != undefined && dialShowArr.length > 0) {
	                        if (dialShowArr[dialShowArr.length - 1].name == "dial") {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-dial',
	                                source: 'room-msglist',
	                                message: { dialShowArr: dialShowArr }
	                            });
	                        }
	                    }
	                    tmpSignallingData["dial"] = null;
	
	                    /*答题卡数据*/
	                    var answerShowArr = tmpSignallingData["answer"];
	                    if (answerShowArr != null && answerShowArr != undefined && answerShowArr.length > 0) {
	                        if (answerShowArr[answerShowArr.length - 1].name == "answer") {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-answer',
	                                source: 'room-msglist',
	                                message: { answerShowArr: answerShowArr }
	                            });
	                        }
	                    }
	                    tmpSignallingData["answer"] = null;
	
	                    /*答案数据*/
	                    var submitAnswersArr = tmpSignallingData["submitAnswers"];
	                    if (submitAnswersArr != null && submitAnswersArr != undefined && submitAnswersArr.length > 0) {
	                        if (submitAnswersArr[submitAnswersArr.length - 1].name == "submitAnswers") {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-submitAnswers',
	                                source: 'room-msglist',
	                                message: { submitAnswersArr: submitAnswersArr }
	                            });
	                        }
	                    }
	                    tmpSignallingData["submitAnswers"] = null;
	
	                    /*抢答器数据*/
	                    var qiangDaQiArr = tmpSignallingData["qiangDaQi"];
	                    if (qiangDaQiArr != null && qiangDaQiArr != undefined && qiangDaQiArr.length > 0) {
	                        if (qiangDaQiArr[qiangDaQiArr.length - 1].name == "qiangDaQi") {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-qiangDaQi',
	                                source: 'room-msglist',
	                                message: { qiangDaQiArr: qiangDaQiArr }
	                            });
	                        }
	                    };
	                    tmpSignallingData["qiangDaQi"] = null;
	
	                    /*抢答者数据*/
	                    var QiangDaZheArr = tmpSignallingData["QiangDaZhe"];
	                    if (QiangDaZheArr != null && QiangDaZheArr != undefined && QiangDaZheArr.length > 0) {
	                        if (QiangDaZheArr[QiangDaZheArr.length - 1].name == "QiangDaZhe") {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-QiangDaZhe',
	                                source: 'room-msglist',
	                                message: { QiangDaZheArr: QiangDaZheArr }
	                            });
	                        }
	                    };
	                    tmpSignallingData["QiangDaZhe"] = null;
	
	                    /*小白板数据*/
	                    var blackBoardArr = tmpSignallingData["BlackBoard"];
	                    if (blackBoardArr != null && blackBoardArr != undefined && blackBoardArr.length > 0) {
	                        if (blackBoardArr[blackBoardArr.length - 1].name == "BlackBoard") {
	                            _eventObjectDefine2['default'].CoreController.dispatchEvent({
	                                type: 'receive-msglist-BlackBoard',
	                                source: 'room-msglist',
	                                message: blackBoardArr[blackBoardArr.length - 1]
	                            });
	                        }
	                    }
	                    tmpSignallingData["BlackBoard"] = null;
	
	                    //最后打开的文档文件和媒体文件
	                    var lastDoucmentFileData = null,
	                        lastMediaFileData = null;
	                    var showPageArr = tmpSignallingData["ShowPage"];
	                    if (showPageArr != null && showPageArr != undefined && showPageArr.length > 0) {
	                        for (var i = 0; i < showPageArr.length; i++) {
	                            if (!showPageArr[i].data.isMedia) {
	                                lastDoucmentFileData = showPageArr[i];
	                            }
	                        }
	                    };
	                    tmpSignallingData["ShowPage"] = null;
	
	                    //打开文件列表中的一个
	                    if (lastDoucmentFileData != undefined && lastDoucmentFileData != null) {
	                        L.Logger.debug('receive-msglist-ShowPage-lastDocument info:', lastDoucmentFileData);
	                        _eventObjectDefine2['default'].CoreController.dispatchEvent({ type: 'receive-msglist-ShowPage-lastDocument', message: { data: lastDoucmentFileData.data, source: 'room-msglist' } });
	                    }
	                    _TkGlobal2['default'].isHandleMsglistFromRoomPubmsg = true;
	                }
	            };
	
	            var messageListData = roomMsglistEventData.message;
	            var source = roomMsglistEventData.source;
	            var ignoreSignallingJson = {};
	            _handlerRoomMsglist(messageListData, source, ignoreSignallingJson);
	        }
	    }, {
	        key: '_classBeginStartHandler',
	
	        /*上课之后的处理函数*/
	        value: function _classBeginStartHandler(classbeginInfo) {
	            var that = this;
	            _TkGlobal2['default'].classBeginTime = !_TkUtils2['default'].isMillisecondClass(classbeginInfo.ts) ? classbeginInfo.ts * 1000 : classbeginInfo.ts; //上课的时间
	            _TkGlobal2['default'].classBegin = true; //已经上课
	            var roleHasDefalutAppPermissionsJson = _RoleHandler2['default'].getRoleHasDefalutAppPermissions();
	            _TkAppPermissions2['default'].initAppPermissions(roleHasDefalutAppPermissionsJson);
	            var value = _ServiceRoom2['default'].getTkRoom().getMySelf().candraw;
	            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromShowPage', value); //发送ShowPage相关的信令权限
	            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromH5ShowPage', value); //发送H5文档的ShowPage相关数据权限
	            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromDynamicPptShowPage', value); //发送动态PPT的ShowPage相关数据权限
	            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromGeneralShowPage', value); //发送普通文档的ShowPage相关数据权限
	            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromDynamicPptTriggerActionClick', value); //发送动态PPT触发器NewPptTriggerActionClick相关的信令权限
	            _TkAppPermissions2['default'].setAppPermissions('sendSignallingFromH5DocumentAction', value); //发送h5文档相关动作的信令权限
	            _TkAppPermissions2['default'].setAppPermissions('sendWhiteboardMarkTool', value); //发送标注工具信令权限
	            _TkAppPermissions2['default'].setAppPermissions('h5DocumentActionClick', value); //h5课件点击动作的权限
	            _TkAppPermissions2['default'].setAppPermissions('dynamicPptActionClick', value); //动态PPT点击动作的权限
	            _TkAppPermissions2['default'].setAppPermissions('publishDynamicPptMediaPermission_video', value); //发布动态PPT视频的权限
	            _TkAppPermissions2['default'].setAppPermissions('canDraw', value); //画笔权限
	            if (_TkConstant2['default'].hasRole.roleStudent) {
	                _TkAppPermissions2['default'].setAppPermissions('whiteboardPagingPage', value ? value : _TkConstant2['default'].joinRoomInfo.isSupportPageTrun); //白板翻页权限
	                _TkAppPermissions2['default'].setAppPermissions('newpptPagingPage', value ? value : _TkConstant2['default'].joinRoomInfo.isSupportPageTrun); //动态ppt翻页权限
	                _TkAppPermissions2['default'].setAppPermissions('h5DocumentPagingPage', value ? value : _TkConstant2['default'].joinRoomInfo.isSupportPageTrun); //h5课件翻页权限
	                _TkAppPermissions2['default'].setAppPermissions('jumpPage', value ? value : _TkConstant2['default'].joinRoomInfo.isSupportPageTrun); //h5课件翻页权限
	            }
	        }
	    }, {
	        key: '_classBeginEndHandler',
	
	        /*下课之后的处理函数*/
	        value: function _classBeginEndHandler(classbeginInfo) {
	            _TkGlobal2['default'].classBegin = false; //下课状态
	            _TkGlobal2['default'].endClassBegin = true; //已经下课
	            var roleHasDefalutAppPermissionsJson = _RoleHandler2['default'].getRoleHasDefalutAppPermissions();
	            _TkAppPermissions2['default'].initAppPermissions(roleHasDefalutAppPermissionsJson);
	        }
	    }, {
	        key: '_bindInfoToTkConstant',
	
	        /*生成joinRoomInfo信息*/
	        value: function _bindInfoToTkConstant() {
	            var href = _TkUtils2['default'].decrypt(_TkConstant2['default'].SERVICEINFO.joinUrl) || window.location.href;
	            var chairmancontrol = _ServiceRoom2['default'].getTkRoom().getRoomProperties().chairmancontrol;
	            var joinRoomInfo = {
	                starttime: _ServiceRoom2['default'].getTkRoom().getRoomProperties().starttime,
	                endtime: _ServiceRoom2['default'].getTkRoom().getRoomProperties().endtime,
	                nickname: _ServiceRoom2['default'].getTkRoom().getMySelf().nickname,
	                thirdid: _ServiceRoom2['default'].getTkRoom().getMySelf().id,
	                joinUrl: _TkUtils2['default'].encrypt(href),
	                serial: _ServiceRoom2['default'].getTkRoom().getRoomProperties().serial,
	                roomrole: Number(_ServiceRoom2['default'].getTkRoom().getMySelf().role),
	                roomtype: Number(_ServiceRoom2['default'].getTkRoom().getRoomProperties().roomtype),
	                companyid: Number(_ServiceRoom2['default'].getTkRoom().getRoomProperties().companyid),
	                isSupportPageTrun: chairmancontrol ? Number(chairmancontrol.substr(38, 1)) == 1 : false, //是否支持文档翻页
	                roomname: _ServiceRoom2['default'].getTkRoom().getRoomProperties().roomname
	            };
	            _TkConstant2['default'].bindRoomInfoToTkConstant(joinRoomInfo); //绑定房间信息到TkConstant
	            _TkConstant2['default'].bindParticipantHasRoleToTkConstant(); //绑定当前登录对象事是否拥有指定角色到TkConstant
	            _TkConstant2['default'].bindParticipantHasRoomtypeToTkConstant(); //绑定当前登录对象事是否拥有指定教室到TkConstant
	        }
	    }]);
	
	    return RoomHandler;
	})();
	
	;
	var RoomHandlerInstance = new RoomHandler();
	RoomHandlerInstance.addEventListenerToRoomHandler();
	exports['default'] = RoomHandlerInstance;
	module.exports = exports['default'];

/***/ }),

/***/ 276:
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(__webpack_provided_window_dot_jQuery) {/**
	 * jquery模块本地定义
	 * @module jqueryDefine
	 * @description   提供 jquery依赖注入定义
	 * @author QiuShao
	 * @date 2017/7/21
	 */
	'use strict';
	
	Object.defineProperty(exports, '__esModule', {
	  value: true
	});
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _jquery = __webpack_require__(41);
	
	var _jquery2 = _interopRequireDefault(_jquery);
	
	window.$ = _jquery2['default'];
	__webpack_provided_window_dot_jQuery = _jquery2['default'];
	exports['default'] = _jquery2['default'];
	module.exports = exports['default'];
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(41)))

/***/ }),

/***/ 277:
/***/ (function(module, exports) {

	/**
	 * 拓课开发使用的日志类
	 * @module LogDevelopment
	 * @description   提供 拓课开发使用的日志类
	 * @author QiuShao
	 * @date 2017/7/20
	 */
	"use strict";
	
	var LogDevelopment = {
	    error: function error() {
	        var args = [];
	        for (var i = 0; i < arguments.length; i++) {
	            args[i] = arguments[i];
	        }
	        console.error.apply(console, args);
	    },
	    log: function log() {
	        var args = [];
	        for (var i = 0; i < arguments.length; i++) {
	            args[i] = arguments[i];
	        }
	        console.log.apply(console, args);
	    },
	    info: function info() {
	        var args = [];
	        for (var i = 0; i < arguments.length; i++) {
	            args[i] = arguments[i];
	        }
	        console.info.apply(console, args);
	    },
	    warn: function warn() {
	        var args = [];
	        for (var i = 0; i < arguments.length; i++) {
	            args[i] = arguments[i];
	        }
	        console.warn.apply(console, args);
	    },
	    trace: function trace() {
	        var args = [];
	        for (var i = 0; i < arguments.length; i++) {
	            args[i] = arguments[i];
	        }
	        console.trace.apply(console, args);
	    },
	    debug: function debug() {
	        var args = [];
	        for (var i = 0; i < arguments.length; i++) {
	            args[i] = arguments[i];
	        }
	        console.debug.apply(console, args);
	    }
	};
	window.Log = LogDevelopment;

/***/ }),

/***/ 278:
/***/ (function(module, exports) {

	/**
	 * 拓课中文语言包
	 * @module chineseLanguage
	 * @description   提供 拓课中文语言包
	 * @author QiuShao
	 * @date 2017/09/01
	 */
	
	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	    value: true
	});
	var chineseLanguage = {
	    "header": {
	        "tool": {
	            "blackBoard": {
	                "title": {
	                    "open": "小白板",
	                    "close": "关闭",
	                    "prev": "上一位",
	                    "next": "下一位",
	                    "shrink": "缩小"
	                },
	                "content": {
	                    "blackboardHeadTitle": "小白板"
	                },
	                "toolBtn": {
	                    "dispenseed": "分发",
	                    "recycle": "回收",
	                    "againDispenseed": "再次分发",
	                    "commonTeacher": '老师'
	                },
	                "tip": {
	                    "saveImage": "是否保存白板"
	                },
	                'boardTool': {
	                    "pen": "笔",
	                    "text": "文字",
	                    "eraser": "橡皮",
	                    "color": "颜色及粗细"
	                }
	            },
	            "sharing": {
	                "title": "屏幕共享"
	            },
	            "mouse": {
	                "title": "鼠标"
	            },
	            "pencil": {
	                "title": "笔",
	                "pen": {
	                    "text": "铅笔工具"
	                },
	                "Highlighter": {
	                    "text": "荧光笔工具"
	                },
	                "linellae": {
	                    "text": "线条工具"
	                },
	                "arrow": {
	                    "text": "箭头工具"
	                },
	                "laser": {
	                    "title": "激光笔",
	                    "text": "激光笔工具"
	                }
	            },
	            "text": {
	                "title": "文字",
	                "Msyh": {
	                    "text": "微软雅黑"
	                },
	                "Ming": {
	                    "text": "宋体"
	                },
	                "Arial": {
	                    "text": "Arial"
	                }
	            },
	            "shape": {
	                "title": "形状",
	                "outlinedRectangle": {
	                    "text": "空心矩形"
	                },
	                "filledRectangle": {
	                    "text": "矩形"
	                },
	                "outlinedCircle": {
	                    "text": "空心椭圆"
	                },
	                "filledCircle": {
	                    "text": "椭圆"
	                }
	            },
	            "eraser": {
	                "title": "橡皮擦"
	            },
	            "undo": {
	                "title": "撤销"
	            },
	            "redo": {
	                "title": "恢复"
	            },
	            "clear": {
	                "title": "清屏"
	            },
	            "tool_zoom_big": {
	                "title": "放大"
	            },
	            "tool_zoom_small": {
	                "title": "缩小"
	            },
	            "tool_rotate_left": {
	                "title": "逆时针旋转"
	            },
	            "tool_rotate_right": {
	                "title": "顺时针旋转"
	            },
	            "colorAndMeasure": {
	                "title": "颜色及粗细",
	                "selectColorText": "选择颜色",
	                "selectMeasure": "选择粗细"
	            },
	            "colors": {
	                "title": "颜色"
	            },
	            "measure": {
	                "title": "粗细"
	            }
	        },
	        "page": {
	            "prev": {
	                "text": "上一页"
	            },
	            "next": {
	                "text": "下一页"
	            },
	            "add": {
	                "text": "加页"
	            },
	            "lcFullBtn": {
	                "title": "绘制区域全屏"
	            },
	            "pptFullBtn": {
	                "title": "PPT全屏"
	            },
	            "h5FileFullBtn": {
	                "title": "h5课件全屏"
	            },
	            "skipPage": {
	                "text_one": "至第",
	                "text_two": "页"
	            },
	            "ok": {
	                "text": "确定"
	            }
	        }
	    },
	    "alertWin": {
	        "ok": {
	            "showError": {
	                "text": "确定"
	            },
	            "showPrompt": {
	                "text": "确定"
	            },
	            "showConfirm": {
	                "cancel": "取消",
	                "ok": "确定"
	            }
	        },
	        "title": {
	            "showError": {
	                "text": "错误信息"
	            },
	            "showPrompt": {
	                "text": "提示信息"
	            },
	            "showConfirm": {
	                "text": "确认消息"
	            }
	        }
	    },
	    "toolCase": {
	        "toolBox": {
	            "text": "工具箱"
	        }
	    },
	    "timers": {
	        "timerSetInterval": {
	            "text": "计时器"
	        },
	        "timerBegin": {
	            "text": "开始"
	        },
	        "timerStop": {
	            "text": "暂停"
	        },
	        "again": {
	            "text": "重新开始"
	        }
	    },
	    "dial": {
	        "turntable": {
	            "text": "转盘"
	        }
	    },
	    "answers": {
	        "headerTopLeft": {
	            "text": "答题器"
	        },
	        "headerMiddel": {
	            "text": "点击字母预设正确答案"
	        },
	        "beginAnswer": {
	            "text": "开始答题"
	        },
	        "tureAccuracy": {
	            "text": "正确率"
	        },
	        "trueAnswer": {
	            "text": "正确答案"
	        },
	        "endAnswer": {
	            "text": "结束答题"
	        },
	        "restarting": {
	            "text": "重新开始"
	        },
	        "myAnswer": {
	            "text": "我的答案"
	        },
	        "changeAnswer": {
	            "text": "修改答案"
	        },
	        "selectAnswer": {
	            "text": "请至少选择一个答案"
	        },
	        "submitAnswer": {
	            "text": "提交答案"
	        },
	        "numberOfAnswer": {
	            "text": "答题人数"
	        },
	        "PublishTheAnswer": {
	            "text": "公布答案"
	        },
	        "published": {
	            "text": "已公布"
	        },
	        "details": {
	            "text": "详情"
	        },
	        "statistics": {
	            "text": "统计"
	        },
	        "student": {
	            "text": "学生"
	        },
	        "TheSelectedTheAnswer": {
	            "text": "所选答案"
	        },
	        "AnswerTime": {
	            "text": "答题用时"
	        },
	        "end": {
	            "text": "请先结束答题"
	        }
	    },
	    "responder": {
	        "responder": {
	            "text": "抢答器"
	        },
	        "begin": {
	            "text": "开始抢答"
	        },
	        "restart": {
	            "text": "重新开始"
	        },
	        "close": {
	            "text": "关闭"
	        },
	        "update": {
	            "text": "当前浏览器不支持canvas组件请升级！"
	        },
	        "inAnswer": {
	            "text": "抢答中"
	        },
	        "answer": {
	            "text": "抢答"
	        },
	        "noContest": {
	            "text": "无人抢答"
	        }
	    },
	    "call": {
	        "fun": {
	            "page": {
	                "pageInteger": {
	                    "text": "输入的页数必须是整数！"
	                },
	                "pageMax": {
	                    "text": "输入的页数不能超过最大页数！"
	                },
	                "pageMin": {
	                    "text": "输入的页数不能小于1"
	                }
	            }
	        }
	    }
	};
	exports["default"] = chineseLanguage;
	module.exports = exports["default"];

/***/ }),

/***/ 279:
/***/ (function(module, exports) {

	/**
	 * 拓课中文繁体语言包
	 * @module complexLanguage
	 * @description   提供 拓课中文繁体语言包
	 * @author QiuShao
	 * @date 2017/09/01
	 */
	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	    value: true
	});
	var complexLanguage = {
	    "toolCase": {
	        "toolBox": {
	            "text": "工具箱"
	        }
	    },
	    "timers": {
	        "timerSetInterval": {
	            "text": "定時器"
	        },
	        "timerBegin": {
	            "text": "開始"
	        },
	        "timerStop": {
	            "text": "暫停"
	        },
	        "again": {
	            "text": "重新開始"
	        }
	    },
	    "dial": {
	        "turntable": {
	            "text": "轉盤"
	        }
	    },
	    "answers": {
	        "headerTopLeft": {
	            "text": "答題器"
	        },
	        "headerMiddel": {
	            "text": "點擊字母預設正確答案"
	        },
	        "beginAnswer": {
	            "text": "開始答題"
	        },
	        "tureAccuracy": {
	            "text": "正確率"
	        },
	        "trueAnswer": {
	            "text": "正確答案"
	        },
	        "endAnswer": {
	            "text": "結束答題"
	        },
	        "restarting": {
	            "text": "重新開始"
	        },
	        "myAnswer": {
	            "text": "我的答案"
	        },
	        "changeAnswer": {
	            "text": "修改答案"
	        },
	        "selectAnswer": {
	            "text": "請至少選擇壹個答案"
	        },
	        "submitAnswer": {
	            "text": "提交答案"
	        },
	        "numberOfAnswer": {
	            "text": "答題人數"
	        },
	        "PublishTheAnswer": {
	            "text": "公布答案"
	        },
	        "published": {
	            "text": "已公布"
	        },
	        "details": {
	            "text": "詳情"
	        },
	        "statistics": {
	            "text": "統計"
	        },
	        "student": {
	            "text": "學生"
	        },
	        "TheSelectedTheAnswer": {
	            "text": "所選答案"
	        },
	        "AnswerTime": {
	            "text": "答題用時"
	        },
	        "end": {
	            "text": "請先結束答題"
	        }
	    },
	    "responder": {
	        "responder": {
	            "text": "搶答器"
	        },
	        "begin": {
	            "text": "開始搶答"
	        },
	        "restart": {
	            "text": "重新開始"
	        },
	        "close": {
	            "text": "關閉"
	        },
	        "update": {
	            "text": "當前浏覽器不支持canvas組件請升級！"
	        },
	        "inAnswer": {
	            "text": "搶答中"
	        },
	        "answer": {
	            "text": "搶答"
	        },
	        "noContest": {
	            "text": "無人搶答"
	        }
	    }
	};
	exports["default"] = complexLanguage;
	module.exports = exports["default"];

/***/ }),

/***/ 280:
/***/ (function(module, exports) {

	/**
	 * 拓课英文语言包
	 * @module englishLanguage
	 * @description   提供 拓课英文语言包
	 * @author QiuShao
	 * @date 2017/09/01
	 */
	
	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	    value: true
	});
	var englishLanguage = {
	    "header": {
	        "tool": {
	            "blackBoard": {
	                "title": {
	                    "open": "Small Whiteboard",
	                    "close": "Close",
	                    "prev": "Previous one",
	                    "next": "Next person",
	                    "shrink": "缩小"
	                },
	                "content": {
	                    "blackboardHeadTitle": "Small Whiteboard"
	                },
	                "toolBtn": {
	                    "dispenseed": "Send",
	                    "recycle": "Send Back",
	                    "againDispenseed": "Again Send",
	                    "commonTeacher": 'Teacher'
	                },
	                "tip": {
	                    "saveImage": "Save Image"
	                },
	                'boardTool': {
	                    "pen": "Pen",
	                    "text": "Text Input",
	                    "eraser": "Eraser",
	                    "color": "Colors and Thickness"
	                }
	            },
	            "sharing": {
	                "title": "Sharing"
	            },
	            "mouse": {
	                "title": "Mouse"
	            },
	            "pencil": {
	                "title": "Pen",
	                "pen": {
	                    "text": "Pencils"
	                },
	                "Highlighter": {
	                    "text": "Highlighters"
	                },
	                "linellae": {
	                    "text": "Lines"
	                },
	                "arrow": {
	                    "text": "Arrows"
	                },
	                "laser": {
	                    "title": "Laser pen",
	                    "text": "Laser pen"
	                }
	            },
	            "text": {
	                "title": "Text Input",
	                "Msyh": {
	                    "text": "Microsoft YaHei"
	                },
	                "Ming": {
	                    "text": "SimSun"
	                },
	                "Arial": {
	                    "text": "Arial"
	                }
	            },
	            "shape": {
	                "title": "Shapes",
	                "outlinedRectangle": {
	                    "text": "Squares"
	                },
	                "filledRectangle": {
	                    "text": "Solid Squares"
	                },
	                "outlinedCircle": {
	                    "text": "Circles"
	                },
	                "filledCircle": {
	                    "text": "Solid Circles"
	                }
	            },
	            "eraser": {
	                "title": "Eraser"
	            },
	            "undo": {
	                "title": "Undo"
	            },
	            "redo": {
	                "title": "Recover"
	            },
	            "clear": {
	                "title": " Clear Screen"
	            },
	            "tool_zoom_big": {
	                "title": "Zoom In"
	            },
	            "tool_zoom_small": {
	                "title": "Zoom Out"
	            },
	            "tool_rotate_left": {
	                "title": "Contrarotate"
	            },
	            "tool_rotate_right": {
	                "title": "Clockwise rotation"
	            },
	            "colorAndMeasure": {
	                "title": "Colors and Thickness",
	                "selectColorText": "Select Colour",
	                "selectMeasure": "Select Thickness"
	            },
	            "colors": {
	                "title": "颜色"
	            },
	            "measure": {
	                "title": "粗细"
	            }
	        },
	        "page": {
	            "prev": {
	                "text": "Previous Page"
	            },
	            "next": {
	                "text": "Next Page"
	            },
	            "add": {
	                "text": "Add Page"
	            },
	            "lcFullBtn": {
	                "title": "Full Screen of Drawing Area"
	            },
	            "pptFullBtn": {
	                "title": "Full Screen  of PPT"
	            },
	            "h5FileFullBtn": {
	                "title": "Full Screen  of Courseware"
	            },
	            "skipPage": {
	                "text_one": "To ",
	                "text_two": " pages"
	            },
	            "ok": {
	                "text": "Confirm"
	            }
	        }
	    },
	    "alertWin": {
	        "ok": {
	            "showError": {
	                "text": "Confirm"
	            },
	            "showPrompt": {
	                "text": "Confirm"
	            },
	            "showConfirm": {
	                "cancel": "Cancel",
	                "ok": "Confirm"
	            }
	        },
	        "title": {
	            "showError": {
	                "text": "Error Message"
	            },
	            "showPrompt": {
	                "text": "Prompt Message"
	            },
	            "showConfirm": {
	                "text": "Confirmation Messages"
	            }
	        }
	    },
	    "toolCase": {
	        "toolBox": {
	            "text": "ToolBox"
	        }
	    },
	    "timers": {
	        "timerSetInterval": {
	            "text": "Timer"
	        },
	        "timerBegin": {
	            "text": "Start"
	        },
	        "timerStop": {
	            "text": "Pause"
	        },
	        "again": {
	            "text": "Restart"
	        }
	    },
	    "dial": {
	        "turntable": {
	            "text": "Turntable"
	        }
	    },
	    "answers": {
	        "headerTopLeft": {
	            "text": "The answer is"
	        },
	        "headerMiddel": {
	            "text": "Click the default answer"
	        },
	        "beginAnswer": {
	            "text": "Begin to answer"
	        },
	        "tureAccuracy": {
	            "text": "Accuracy"
	        },
	        "trueAnswer": {
	            "text": "The right answer"
	        },
	        "endAnswer": {
	            "text": "End of the answer"
	        },
	        "restarting": {
	            "text": "Restart"
	        },
	        "myAnswer": {
	            "text": "My Answer"
	        },
	        "changeAnswer": {
	            "text": "Modify the answer"
	        },
	        "selectAnswer": {
	            "text": "Please select at least one answer"
	        },
	        "submitAnswer": {
	            "text": "Submit the answer"
	        },
	        "numberOfAnswer": {
	            "text": "Number of answer"
	        },
	        "PublishTheAnswer": {
	            "text": "Publish the answer"
	        },
	        "published": {
	            "text": "Published"
	        },
	        "details": {
	            "text": "Details"
	        },
	        "statistics": {
	            "text": "Statistics"
	        },
	        "student": {
	            "text": "Student"
	        },
	        "TheSelectedTheAnswer": {
	            "text": "The selected the answer"
	        },
	        "AnswerTime": {
	            "text": "Answer Time"
	        },
	        "end": {
	            "text": "Please finish your questions first"
	        }
	    },
	    "responder": {
	        "responder": {
	            "text": "Responder"
	        },
	        "begin": {
	            "text": "Start"
	        },
	        "restart": {
	            "text": "Restart"
	        },
	        "close": {
	            "text": "Close"
	        },
	        "update": {
	            "text": "The current browser does not support canvas components please upgrade!"
	        },
	        "inAnswer": {
	            "text": "In answer"
	        },
	        "answer": {
	            "text": "Responder"
	        },
	        "noContest": {
	            "text": "No contest"
	        }
	    },
	    "call": {
	        "fun": {
	            "page": {
	                "pageInteger": {
	                    "text": "The page number entered must be integers."
	                },
	                "pageMax": {
	                    "text": "The page number entered is over!"
	                },
	                "pageMin": {
	                    "text": "The page number entered can't be less than 1."
	                }
	            }
	        }
	    }
	};
	exports["default"] = englishLanguage;
	module.exports = exports["default"];

/***/ }),

/***/ 281:
/***/ (function(module, exports, __webpack_require__) {

	'use strict';
	//引入样式文件
	
	__webpack_require__(487);
	
	__webpack_require__(491);
	
	__webpack_require__(498);
	
	__webpack_require__(489);
	
	__webpack_require__(495);
	
	__webpack_require__(490);
	
	__webpack_require__(493);
	
	__webpack_require__(488);
	
	__webpack_require__(492);
	
	//答题卡 倒计时 抢答器  转盘 样式
	
	__webpack_require__(486);
	
	__webpack_require__(494);
	
	__webpack_require__(496);
	
	__webpack_require__(497);
	
	//引入组件
	
	__webpack_require__(276);
	
	__webpack_require__(173);
	
	__webpack_require__(277);
	
	__webpack_require__(273);

/***/ }),

/***/ 486:
/***/ (function(module, exports) {

	// removed by extract-text-webpack-plugin

/***/ }),

/***/ 487:
486,

/***/ 488:
486,

/***/ 489:
486,

/***/ 490:
486,

/***/ 491:
486,

/***/ 492:
486,

/***/ 493:
486,

/***/ 494:
486,

/***/ 495:
486,

/***/ 496:
486,

/***/ 497:
486,

/***/ 498:
486,

/***/ 627:
/***/ (function(module, exports, __webpack_require__) {

	var map = {
		"./i18_chinese.js": 278,
		"./i18_complex.js": 279,
		"./i18_english.js": 280
	};
	function webpackContext(req) {
		return __webpack_require__(webpackContextResolve(req));
	};
	function webpackContextResolve(req) {
		return map[req] || (function() { throw new Error("Cannot find module '" + req + "'.") }());
	};
	webpackContext.keys = function webpackContextKeys() {
		return Object.keys(map);
	};
	webpackContext.resolve = webpackContextResolve;
	module.exports = webpackContext;
	webpackContext.id = 627;


/***/ })

});
//# sourceMappingURL=tkMain-6be4b2b8.js.map