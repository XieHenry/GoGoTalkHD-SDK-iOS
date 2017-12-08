/*global L*/
'use strict';
/*
 * Class EventDispatcher provides event handling to sub-classes.
 * It is inherited from Publisher, Room, etc.
 */
var TK = TK || {};
TK.EventDispatcher = function (spec) {
    var that = {};
    var isArray = function (object){
        return  object && typeof object==='object' &&
            typeof object.length==='number' &&
            typeof object.splice==='function' &&
            //判断length属性是否是可枚举的 对于数组 将得到false
            !(object.propertyIsEnumerable('length'));
    }
    // Private vars
    spec.dispatcher = {};
    spec.dispatcher.eventListeners = {};
    spec.dispatcher.backupListerners = {};
    // Public functions

    // It adds an event listener attached to an event type.
    that.addEventListener = function (eventType, listener , backupid ) {
        if(eventType === undefined || eventType === null){
            return;
        }
        if (spec.dispatcher.eventListeners[eventType] === undefined) {
            spec.dispatcher.eventListeners[eventType] = [];
        }
        spec.dispatcher.eventListeners[eventType].push(listener);
        if(backupid){
            if (spec.dispatcher.backupListerners[backupid] === undefined) {
                spec.dispatcher.backupListerners[backupid] = [];
            }
            spec.dispatcher.backupListerners[backupid].push({eventType:eventType ,listener:listener });
        }
    };

    // It removes an available event listener.
    that.removeEventListener = function (eventType, listener) {
        var index;
		if(!spec.dispatcher.eventListeners[eventType]){ L.Logger.info('[tk-mobile-sdk]not event type: ' +eventType);  return ;} ;
        index = spec.dispatcher.eventListeners[eventType].indexOf(listener);
        if (index !== -1) {
            spec.dispatcher.eventListeners[eventType].splice(index, 1);
        }
    };
	
    // It removes all event listener.
    that.removeAllEventListener = function (eventTypeArr) {
        if( isArray(eventTypeArr) ){
            for(var i in eventTypeArr){
                var eventType = eventTypeArr[i] ;
                delete spec.dispatcher.eventListeners[eventType] ;
            }
        }else if(typeof eventTypeArr === "string"){
			delete spec.dispatcher.eventListeners[eventTypeArr] ;  
		}else if(typeof eventTypeArr === "object"){
            for(var key in eventTypeArr){
                var eventType = key  , listener = eventTypeArr[key];
                that.removeEventListener(eventType , listener);
            }
		}		  
    };

    // It dispatch a new event to the event listeners, based on the type
    // of event. All events are intended to be TalkEvents.
    that.dispatchEvent = function (event , log ) {
        var listener;
        log = log!=undefined?log:true ;
        if(log){
            L.Logger.debug('[tk-mobile-sdk]dispatchEvent , event type: ' + event.type);
        }
        for (listener in spec.dispatcher.eventListeners[event.type]) {
            if (spec.dispatcher.eventListeners[event.type].hasOwnProperty(listener)) {
                spec.dispatcher.eventListeners[event.type][listener](event);
            }
        }
    };

    that.removeBackupListerner = function (backupid) {
        if(backupid){
            if( spec.dispatcher.backupListerners[backupid] ){
                for(var i=0; i<spec.dispatcher.backupListerners[backupid].length ; i++){
                    var backupListernerInfo = spec.dispatcher.backupListerners[backupid][i] ;
                    that.removeEventListener(backupListernerInfo.eventType , backupListernerInfo.listener);
                }
                spec.dispatcher.backupListerners[backupid].length = 0 ;
                delete spec.dispatcher.backupListerners[backupid] ;
            }
        }
    };

    return that;
};

// **** EVENTS ****

/*
 * Class TalkEvent represents a generic Event in the library.
 * It handles the type of event, that is important when adding
 * event listeners to EventDispatchers and dispatching new events.
 * A TalkEvent can be initialized this way:
 * var event = TalkEvent({type: "room-connected"});
 */
TK.TalkEvent = function (spec) {
    var that = {};

    // Event type. Examples are: 'room-connected', 'stream-added', etc.
    that.type = spec.type;

    return that;
};

/*
 * Class RoomEvent represents an Event that happens in a Room. It is a
 * TalkEvent.
 * It is usually initialized as:
 * var roomEvent = RoomEvent({type:"room-connected", streams:[stream1, stream2]});
 * Event types:
 * 'room-connected' - points out that the user has been successfully connected to the room.
 * 'room-disconnected' - shows that the user has been already disconnected.
 */
TK.RoomEvent = function (spec , extraSpec) {
    var that = TK.TalkEvent(spec);

    // A list with the streams that are published in the room.
    that.streams = spec.streams;
    that.message = spec.message;
    that.user = spec.user;
    if(extraSpec && typeof extraSpec === 'object'){
        for(var key in extraSpec){
            that[key] = extraSpec[key];
        }
    }
    return that;
};

/*
 * Class StreamEvent represents an event related to a stream. It is a TalkEvent.
 * It is usually initialized this way:
 * var streamEvent = StreamEvent({type:"stream-added", stream:stream1});
 * Event types:
 * 'stream-added' - indicates that there is a new stream available in the room.
 * 'stream-removed' - shows that a previous available stream has been removed from the room.
 */
TK.StreamEvent = function (spec , extraSpec) {
    var that = TK.TalkEvent(spec);

    // The stream related to this event.
    that.stream = spec.stream;
    that.message = spec.message;
    that.bandwidth = spec.bandwidth;
    that.attrs = spec.attrs ;
    if(extraSpec && typeof extraSpec === 'object'){
        for(var key in extraSpec){
            that[key] = extraSpec[key];
        }
    }
    return that;
};

/*
 * Class PublisherEvent represents an event related to a publisher. It is a TalkEvent.
 * It usually initializes as:
 * var publisherEvent = PublisherEvent({})
 * Event types:
 * 'access-accepted' - indicates that the user has accepted to share his camera and microphone
 */
TK.PublisherEvent = function (spec , extraSpec) {
    var that = TK.TalkEvent(spec);
    if(extraSpec && typeof extraSpec === 'object'){
        for(var key in extraSpec){
            that[key] = extraSpec[key];
        }
    }
    return that;
};
TK.mobileSdkEventManager = TK.EventDispatcher({});
TK.mobileUICoreEventManager = TK.EventDispatcher({});var TK = TK || {};
TK.SDKTYPE = 'mobile' ;
TK.PUBLISH_STATE_NONE = 0; //下台
TK.PUBLISH_STATE_AUDIOONLY = 1; //只发布音频
TK.PUBLISH_STATE_VIDEOONLY = 2; //只发布视频
TK.PUBLISH_STATE_BOTH = 3; //音视频都发布
TK.PUBLISH_STATE_MUTEALL = 4; //音视频都关闭
TK.Room = function () {
    'use strict';
    var SDKVERSIONS =  window.__SDKVERSIONS__  || "2.0.8";
    var SDKVERSIONSTIME =  window.__SDKVERSIONSTIME__  || "2017110910";
    L.Logger.info('[tk-sdk-version]sdk-version:'+ SDKVERSIONS +' , sdk-time: '+ SDKVERSIONSTIME) ;
    var spec={};
    var that = TK.EventDispatcher(spec);

    var _myself = {}  , _users = {}   , _room_properties = {};

    that.getRoomProperties = function () {
        return _room_properties;
    };
    that.getUsers = function () {
        return _users ;
    };
    that.getUser = function (userid ) {
        return _users[userid];
    };
    that.getMySelf = function () {
        return _myself ;
    };
    that.getSpecifyRoleList = function (specifyRoleKey , callback) {
        var specifyRole = {} ;
        for(var key in _users){
            var user = _users[key] ;
            if(user.role === specifyRoleKey){
                specifyRole[key] = user ;
            }
        }
       return specifyRole ;
    };

    that.logMessage = function (message,clientType) {
        MOBILETKSDK.sendInterface.logMessage( message,clientType);
    };
    that.dynamicPptVideoAutoPlay = function (dynamicPptVideoJson) {
        MOBILETKSDK.sendInterface.dynamicPptVideoAutoPlay( dynamicPptVideoJson );
    };
    that.changeWebPageFullScreen = function (isFullScreen) {
        MOBILETKSDK.sendInterface.changeWebPageFullScreen( isFullScreen );
    };
    that.onPageFinished = function () {
        MOBILETKSDK.sendInterface.onPageFinished(  );
    };
    that.pubMsg = function (msgName, msgId, toId, data, save, expiresabs ,  associatedMsgID , associatedUserID) {
        MOBILETKSDK.sendInterface.pubMsg( msgName, msgId, toId, data, save, expiresabs ,  associatedMsgID , associatedUserID);
    };
    that.delMsg = function (msgName, msgId, toId, data) {
        MOBILETKSDK.sendInterface.delMsg(msgName, msgId, toId, data );
    };
    that.changeUserProperty = function (id, tellWhom, properties) {
        MOBILETKSDK.sendInterface.changeUserProperty( id, tellWhom, properties );
    };

    that.handleMobileSdk_dispatchEvent = {
        'room-userproperty-changed':function (recvEventData) {
            var param = recvEventData.message ;
            L.Logger.debug('[tk-mobile-sdk]room-userproperty-changed info:' + L.Utils.toJsonStringify(param) );
            var userid = param.userid;
            if(param.hasOwnProperty("properties")){
                var properties =  param.properties;
                var user = _users[userid];
                if (user === undefined){
                    L.Logger.error( '[tk-mobile-sdk]room-userproperty-changed user is not exist , userid is '+userid+'!'  );
                    return true;
                }
                for (var key in properties) {
                    if (key != 'id' && key != 'watchStatus'){
                        user[key]=properties[key];
                    }
                }
                var roomEvt = TK.RoomEvent({type: 'room-userproperty-changed', user:user, message:properties} , { fromID:param.fromID} );
                that.dispatchEvent(roomEvt);
            }
            return true ;
        } ,
        'room-participant_leave':function (recvEventData) {
            var userid = recvEventData.userid ;
            L.Logger.debug('[tk-mobile-sdk]room-participant_leave userid:' +userid );
            var user = _users[userid]  ;
            if (user === undefined){
                L.Logger.error( '[tk-mobile-sdk]participantLeft user is not exist , userid is '+userid+'!'  );
                return true;
            }
            //if( TK.global.initPageParameterFormPhone.playback){
            // user.leaveTs = userinfo.ts ;
            //}
            if(!TK.global.initPageParameterFormPhone.playback){
                delete _users[userid];
            }else{
                if(_users[userid]){
                    _users[userid].playbackLeaved = true ;
                }
            }
            var roomEvt = TK.RoomEvent({type: 'room-participant_leave', user: user});
            that.dispatchEvent(roomEvt);
            return true ;
        } ,
        'room-participant_join':function (recvEventData) {
            var user = recvEventData.user;
            L.Logger.debug('[tk-mobile-sdk]room-participant_join user:'+ L.Utils.toJsonStringify(user) );
            _users[user.id]=user;
            if(TK.global.initPageParameterFormPhone.playback && _users[user.id]){
                delete _users[user.id].playbackLeaved ;
            }
            var roomEvt = TK.RoomEvent({type: 'room-participant_join', user: user});
            that.dispatchEvent(roomEvt);
            return true ;
        },
        'room-connected':function (recvEventData) {
            L.Logger.debug('[tk-mobile-sdk]room-connected info:'+ L.Utils.toJsonStringify(recvEventData) );
            var userlist = recvEventData.userlist ;
            var msglist = recvEventData.msglist ;
            var myself = recvEventData.myself ;
            var roomProperties = recvEventData.roomProperties ;
            if(myself){
                _myself =myself;
            }
            if(roomProperties){
                _room_properties = roomProperties ;
            }
            _users = {};
            _users[_myself.id] = _myself;

            for (var index in userlist) {
                if (userlist.hasOwnProperty(index)) {
                    var user = userlist[index];
                    if (user !== undefined) {
                        _users[user.id]=user;
                        if(TK.global.initPageParameterFormPhone.playback && _users[user.id]){
                            delete _users[user.id].playbackLeaved ;
                        }
                    }
                }
            }
            var msgs = new Array();
            if(msglist && typeof msglist == "string") {
                msglist = L.Utils.toJsonParse(msglist);
            }
            for (index in msglist) {
                if (msglist.hasOwnProperty(index)) {
                    msgs.push(msglist[index]);
                }
            }

            msgs.sort(function(obj1, obj2){
                if (obj1 === undefined || !obj1.hasOwnProperty('seq') || obj2 === undefined || !obj2.hasOwnProperty('seq'))
                    return 0;
                return obj1.seq - obj2.seq;
            });

            var connectEvt = TK.RoomEvent({type: 'room-connected' ,  message:msgs});
            that.dispatchEvent(connectEvt);
            return true ;
        },
        'room-disconnected':function (recvEventData) {
            L.Logger.debug('[tk-mobile-sdk]room-disconnected' );
            that._resetRoomState(false);
            var disconnectEvt = TK.RoomEvent({type: 'room-disconnected'});
            that.dispatchEvent(disconnectEvt);
            return true;
        },
        'room-playback-clear_all':function (recvEventData) {
            if(!TK.global.initPageParameterFormPhone.playback){L.Logger.warning('[tk-mobile-sdk]room-playback-clear_all:No playback environment!');return ;} ;
            L.Logger.debug('[tk-mobile-sdk]room-playback-clear_all' );
            var roomEvt = TK.RoomEvent({type: 'room-playback-clear_all'});
            that.dispatchEvent(roomEvt);
            return true;
        },
        'room-pubmsg':function (recvEventData) {
            var message = recvEventData.message ;
            var roomEvt = TK.RoomEvent({type: 'room-pubmsg', message:message});
            that.dispatchEvent(roomEvt);
            return true;
        },
        'room-delmsg':function (recvEventData) {
            var message = recvEventData.message ;
            var roomEvt = TK.RoomEvent({type: 'room-delmsg', message:message});
            that.dispatchEvent(roomEvt);
            return true;
        } ,
    };

    if(TK.mobileSdkEventManager){
        TK.mobileSdkEventManager.addEventListener('mobileSdk_dispatchEvent' , function (dispatchEventData) { //接收到原生给的服务器数据接口
            var recvEventData = dispatchEventData.message ;
            var type = recvEventData.type ;
            var isReturn = false ;
            if(that.handleMobileSdk_dispatchEvent[type] && typeof  that.handleMobileSdk_dispatchEvent[type] === 'function'){
                isReturn = that.handleMobileSdk_dispatchEvent[type](recvEventData);
            }
            if(!isReturn){
                that.dispatchEvent(recvEventData);
            }
        });
    }

    function _resetRoomState(clearUsers) { //重置房间状态
        var clearUsers = clearUsers!=undefined?clearUsers:true ;
        if (_users && clearUsers) {
            _clearUsers(_users);
        }
        if(_myself){
            _myself.publishstate = TK.PUBLISH_STATE_NONE;
        }
    };
    function _clearUsers(obj) {
        if(!TK.global.initPageParameterFormPhone.playback){ //回放则不清空用户列表
            for(var key in obj){
                delete obj[key];
            }
        }
    };
    return that;
};

;(function () {
    var DEV = false ;
    var _getUrlParams = function(key){
        // var urlAdd = decodeURI(window.location.href);
        var urlAdd = decodeURIComponent(window.location.href);
        var urlIndex = urlAdd.indexOf("?");
        var urlSearch = urlAdd.substring(urlIndex + 1);
        var reg = new RegExp("(^|&)" + key + "=([^&]*)(&|$)", "i");   //reg表示匹配出:$+url传参数名字=值+$,并且$可以不存在，这样会返回一个数组
        var arr = urlSearch.match(reg);
        if(arr != null) {
            return arr[2];
        } else {
            return "";
        }
    };
    if(window.__SDKDEV__ !== undefined && window.__SDKDEV__!== null && typeof window.__SDKDEV__ === 'boolean'){
        try{
            DEV = window.__SDKDEV__ ;
        }catch (e){
            DEV = false ;
        }
    }
    var debug = (DEV || _getUrlParams('debug') );
    window.__TkSdkBuild__ = !debug ;
    if(window.localStorage){
        var debugStr =  debug ? '*' : 'none';
        window.localStorage.setItem('debug' ,debugStr );
    }
})();/*global document, console*/
'use strict';
var L = L || {};
var TK = TK || {} ;
/*
 * API to write logs based on traditional logging mechanisms: debug, trace, info, warning, error
 */
L.Logger = (function (L) {
    var DEBUG = 0,
        TRACE = 1,
        INFO = 2,
        WARNING = 3,
        ERROR = 4,
        NONE = 5,
        enableLogPanel,
        setLogLevel,
        setOutputFunction,
        setLogPrefix,
        outputFunction,
        logPrefix = '',
        print,
        debug,
        trace,
        info,
        log,
        warning,
        error , 
		setLogDevelopment,
		developmentEnvironment = false;

    // By calling this method we will not use console.log to print the logs anymore.
    // Instead we will use a <textarea/> element to write down future logs
    enableLogPanel = function () {
        L.Logger.panel = document.createElement('textarea');
        L.Logger.panel.setAttribute('id', 'licode-logs');
        L.Logger.panel.setAttribute('style', 'width: 100%; height: 100%; display: none');
        L.Logger.panel.setAttribute('rows', 20);
        L.Logger.panel.setAttribute('cols', 20);
        L.Logger.panel.setAttribute('readOnly', true);
        document.body.appendChild(L.Logger.panel);
    };

    // It sets the new log level. We can set it to NONE if we do not want to print logs
    setLogLevel = function (level) {
        if (level > L.Logger.NONE) {
            level = L.Logger.NONE;
        } else if (level < L.Logger.DEBUG) {
            level = L.Logger.DEBUG;
        }
        L.Logger.logLevel = level;
    };
	
	setLogDevelopment = function(isDevelopmentEnvironment){
		developmentEnvironment = isDevelopmentEnvironment ;
	};
	
    outputFunction = function (args , level) {
        try{
            switch (level){
                case L.Logger.DEBUG:
                    developmentEnvironment ? console.warn.apply(console, args) : console.debug.apply(console, args)  ;
                    break;
                case L.Logger.TRACE:
                    console.trace.apply(console, args);
                    break;
                case L.Logger.INFO:
                    developmentEnvironment ? console.warn.apply(console, args) :  console.info.apply(console, args);
                    break;
                case L.Logger.WARNING:
                    console.warn.apply(console, args);
                    break;
                case L.Logger.ERROR:
                    console.error.apply(console, args);
                    break;
                case L.Logger.NONE:
					console.warn("log level is none!");
                    break;
                default:
                    developmentEnvironment ? console.warn.apply(console, args) : console.log.apply(console, args);
                    break;
            }
        }catch (e){
            console.log.apply(console, args);
        }
    };

    setOutputFunction = function (newOutputFunction) {
        outputFunction = newOutputFunction;
    };

    setLogPrefix = function (newLogPrefix) {
        logPrefix = newLogPrefix;
    };

    // Generic function to print logs for a given level:
    //  L.Logger.[DEBUG, TRACE, INFO, WARNING, ERROR]
    print = function (level) {
        var out = logPrefix;
        if (level < L.Logger.logLevel) {
            return;
        }
        if (level === L.Logger.DEBUG) {
            out = out + 'DEBUG('+new Date().toLocaleString()+')';
        } else if (level === L.Logger.TRACE) {
            out = out + 'TRACE('+new Date().toLocaleString()+')';
        } else if (level === L.Logger.INFO) {
            out = out + 'INFO('+new Date().toLocaleString()+')';
        } else if (level === L.Logger.WARNING) {
            out = out + 'WARNING('+new Date().toLocaleString()+')';
        } else if (level === L.Logger.ERROR) {
            out = out + 'ERROR('+new Date().toLocaleString()+')';
        }
        out = out + ':';
        var args = [];
        for (var i = 0; i < arguments.length; i++) {
            args[i] = arguments[i];
        }
        var tempArgs = args.slice(1);
        args = [out].concat(tempArgs);
        if (L.Logger.panel !== undefined) {
            var tmp = '';
            for (var idx = 0; idx < args.length; idx++) {
                tmp = tmp + args[idx];
            }
            L.Logger.panel.value = L.Logger.panel.value + '\n' + tmp;
        } else {
            outputFunction.apply(L.Logger, [args , level] );
        }
    };

    // It prints debug logs
    debug = function () {
        var args = [];
        for (var i = 0; i < arguments.length; i++) {
            args[i] = arguments[i];
        }
        L.Logger.print.apply(L.Logger,[L.Logger.DEBUG].concat(args));
    };

    // It prints trace logs
    trace = function () {
        var args = [];
        for (var i = 0; i < arguments.length; i++) {
            args[i] = arguments[i];
        }
        L.Logger.print.apply(L.Logger,[L.Logger.TRACE].concat(args));
    };

    // It prints info logs
    info = function () {
        var args = [];
        for (var i = 0; i < arguments.length; i++) {
            args[i] = arguments[i];
        }
        L.Logger.print.apply(L.Logger,[L.Logger.INFO].concat(args));
    };

    // It prints warning logs
    warning = function () {
        var args = [];
        for (var i = 0; i < arguments.length; i++) {
            args[i] = arguments[i];
        }
        L.Logger.print.apply(L.Logger,[L.Logger.WARNING].concat(args));
    };

    // It prints error logs
    error = function () {
        var args = [];
        for (var i = 0; i < arguments.length; i++) {
            args[i] = arguments[i];
        }
        L.Logger.print.apply(L.Logger,[L.Logger.ERROR].concat(args));
    };

    return {
        DEBUG: DEBUG,
        TRACE: TRACE,
        INFO: INFO,
        WARNING: WARNING,
        ERROR: ERROR,
        NONE: NONE,
		setLogDevelopment:setLogDevelopment , 
        enableLogPanel: enableLogPanel,
        setLogLevel: setLogLevel,
        setOutputFunction: setOutputFunction,
        setLogPrefix: setLogPrefix,
        print:print ,
        debug: debug,
        trace: trace,
        info: info,
        warning: warning,
        error: error 
    };
}(L));

/*设置日志输出,通过配置项*/
TK.tkLogPrintConfig =  function (socketLogConfig , loggerConfig , adpConfig ) {
    loggerConfig = loggerConfig || {} ;
    socketLogConfig = socketLogConfig || {} ;
    adpConfig = adpConfig || {} ;
    var development = loggerConfig.development != undefined  ? loggerConfig.development : true;
    var logLevel =  loggerConfig.logLevel  != undefined  ? loggerConfig.logLevel  : 0;
    var debug = socketLogConfig.debug != undefined  ? socketLogConfig.debug  : true ;
    var webrtcLogDebug =  adpConfig.webrtcLogDebug!= undefined  ? adpConfig.webrtcLogDebug : true ;
    L.Logger.setLogDevelopment(development);
    L.Logger.setLogLevel(logLevel);
    if(window.localStorage){
        var debugStr =  debug ? '*' : 'none';
        window.localStorage.setItem('debug' ,debugStr );
    }
    window.webrtcLogDebug = webrtcLogDebug;
};/**
 * SDK常量
 * @class L.Constant
 * @description   提供常量存储对象
 * @author QiuShao
 * @date 2017/7/29
 */
'use strict';
var L = L || {};
L.Constant = (function () {
    return {
        mClientType:{
            flash:0 ,
            pc:1 ,
            ios:2 ,
            andriod:3 ,
		},
		IOS:'ios' ,
        ANDRIOD:'andriod' ,
    };
}(L));
/**
 * SDK工具类
 * @class L.Utils
 * @description   提供SDK所需要的工具
 * @author QiuShao
 * @date 2017/7/29
 */
'use strict';
var L = L || {};
L.hex64Instance = undefined ;
;(function() {
    //
    // 密文字符集（size:65）。
    // [0-9A-Za-z$_~]
    //
    // var _hexCHS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz$_~';
    var _hexCHS = 'JKijklmnoz$_01234ABCDEFGHI56789LMNOPQRpqrstuvwxySTUVWXYZabcdefgh~';

    if(_hexCHS.length !== 65){L.Logger.error('密文字符集长度必须是65位，当前长度为:'+_hexCHS.length );return ;}
    //
    // Base64 变形加密法
    // 算法与 Base64 类似，即将 8 位字节用 6 位表示。
    // 规则：
    // 1. 码值 <= 0xff 的用 1 个字节表示；
    // 2. 码值 > 0xff 的用 2 字节表示；
    // 3. 单/双字节序列间用 0x1d 进行分隔；
    // 4. 首字为双字节时即前置 0x1d 分隔符。
    //
    // @param array key  - [0-63] 互斥值数组，length == 64
    //
    var  Hex64 = function( key )
    {
        this._key = [], this._tbl = {};

        for (var _i=0; _i<64; ++_i) {
            this._key[_i] = _hexCHS.charAt(key[_i]);
            this._tbl[this._key[_i]] = _i;
        }
        this._pad = _hexCHS.charAt(64);
    };

    // 加密
    Hex64.prototype.enc = function( s )
    {
        var _rs = '';
        var _c1, _c2, _c3, _n1, _n2, _n3, _n4;
        var _i = 0;
        var _a = Hex64._2to1(s);
        var _en = _a.length % 3, _sz = _a.length - _en;
        while (_i < _sz) {
            _c1 = _a[_i++];
            _c2 = _a[_i++];
            _c3 = _a[_i++];
            _n1 = _c1 >> 2;
            _n2 = ((_c1 & 3) << 4) | (_c2 >> 4);
            _n3 = ((_c2 & 15) << 2) | (_c3 >> 6);
            _n4 = _c3 & 63;
            _rs += this._key[_n1]
                + this._key[_n2]
                + this._key[_n3]
                + this._key[_n4];
        }
        if (_en > 0) {
            _c1 = _a[_i++];
            _c2 = _en > 1 ? _a[_i] : 0;
            _n1 = _c1 >> 2;
            _n2 = ((_c1 & 3) << 4) | (_c2 >> 4);
            _n3 = (_c2 & 15) << 2;
            _rs += this._key[_n1] + this._key[_n2]
                + (_n3 ? this._key[_n3] : this._pad)
                + this._pad;
        }
        return  _rs.replace(/.{76}/g, function(s) {
            return  s + '\n';
        });
    };

    // 解密
    Hex64.prototype.dec = function( s )
    {
        var _sa = [],
            _n1, _n2, _n3, _n4,
            _i = 0, _c = 0;
        s = s.replace(/[^0-9A-Za-z$_~]/g, '');
        while (_i < s.length) {
            _n1 = this._tbl[s.charAt(_i++)];
            _n2 = this._tbl[s.charAt(_i++)];
            _n3 = this._tbl[s.charAt(_i++)];
            _n4 = this._tbl[s.charAt(_i++)];
            _sa[_c++] = (_n1 << 2) | (_n2 >> 4);
            _sa[_c++] = ((_n2 & 15) << 4) | (_n3 >> 2);
            _sa[_c++] = ((_n3 & 3) << 6) | _n4;
        }
        var _e2 = s.slice(-2);
        if (_e2.charAt(0) == this._pad) {
            _sa.length = _sa.length - 2;
        } else if (_e2.charAt(1) == this._pad) {
            _sa.length = _sa.length - 1;
        }
        return  Hex64._1to2(_sa);
    };

    //
    // 辅助：
    // Unicode 字符串 -> 单字节码值数组
    // 注意：
    // 原串中值为 0x1d 的字节（非字符）会被删除。
    //
    // @param string s  - 字符串（UCS-16）
    // @return array  - 单字节码值数组
    //
    Hex64._2to1 = function( s )
    {
        var _2b = false, _n = 0, _sa = [];

        if (s.charCodeAt(0) > 0xff) {
            _2b = true;
            _sa[_n++] = 0x1d;
        }
        for (var _i=0; _i<s.length; ++_i) {
            var _c = s.charCodeAt(_i);
            if (_c == 0x1d) continue;
            if (_c <= 0xff) {
                if (_2b) {
                    _sa[_n++] = 0x1d;
                    _2b = false;
                }
                _sa[_n++] = _c;
            } else {
                if (! _2b) {
                    _sa[_n++] = 0x1d;
                    _2b = true;
                }
                _sa[_n++] = _c >> 8;
                _sa[_n++] = _c & 0xff;
            }
        }
        return  _sa;
    };

    //
    // 辅助：
    // 单字节码值数组 -> Unicode 字符串
    //
    // @param array a  - 单字节码值数组
    // @return string  - 还原后的字符串（UCS-16）
    //
    Hex64._1to2 = function( a )
    {
        var _2b = false, _rs = '';

        for (var _i=0; _i<a.length; ++_i) {
            var _c = a[_i];
            if (_c == 0x1d) {
                _2b = !_2b;
                continue;
            }
            if (_2b) {
                _rs += String.fromCharCode(_c * 256 + a[++_i]);
            } else {
                _rs += String.fromCharCode(_c);
            }
        }
        return  _rs;
    };
    // var _k3 = [38,48,18,11,26,19,55,58,10,33,34,49,14,25,44,52,61,16,2,56,23,29,45,9,3,12,39,30,42,47,22,21,60,1,54,28,57,17,27,15,40,46,43,13,0,51,35,63,36,50,6,32,4,31,62,5,24,8,53,59,41,20,7,37];
    var _k3 = [15,40,46,43,13,0,51,35,63,36,50,6,32,4,31,62,5,24,8,53,59,41,20,7,37,38,48,18,11,26,19,55,58,10,33,34,49,14,25,44,52,61,16,2,56,23,29,45,9,3,12,39,30,42,47,22,21,60,1,54,28,57,17,27];
    if(_k3.length !== 64){L.Logger.error('互斥值数组长度必须是65位，当前长度为:'+_k3.length );return ;}
    L.hex64Instance = new Hex64(_k3);
})();
L.Utils = ( function () {
    return {
        /**绑定事件
         @method addEvent
         @param   {element} element 添加事件元素
         {string} eType 事件类型
         {Function} handle 事件处理器
         {Bollean} bol false 表示在事件第三阶段（冒泡）触发，true表示在事件第一阶段（捕获）触发。
         */
        addEvent:function(element, eType, handle, bol){
            bol = (bol!=undefined && bol!=null)?bol:false ;
            if(element.addEventListener){           //如果支持addEventListener
                element.addEventListener(eType, handle, bol);
            }else if(element.attachEvent){          //如果支持attachEvent
                element.attachEvent("on"+eType, handle);
            }else{                                  //否则使用兼容的onclick绑定
                element["on"+eType] = handle;
            }
        },
        /**事件解绑
         @method addEvent
         @param   {element} element 添加事件元素
         {string} eType 事件类型
         {Function} handle 事件处理器
         {Bollean} bol false 表示在事件第三阶段（冒泡）触发，true表示在事件第一阶段（捕获）触发。
         */
        removeEvent:function(element, eType, handle, bol) {
            if(element.addEventListener){
                element.removeEventListener(eType, handle, bol);
            }else if(element.attachEvent){
                element.detachEvent("on"+eType, handle);
            }else{
                element["on"+eType] = null;
            }
        },
        /*toStringify*/
        toJsonStringify:function (json , isChange) {
            isChange = isChange!=undefined?isChange:true;
            if(!isChange){
                return json ;
            }
            if(!json){
                return json ;
            }
            try{
                if( typeof  json !== 'object'){
                    // L.Logger.debug('[tk-sdk]toJsonStringify:json must is object!');
                    return json ;
                }
                var jsonString = JSON.stringify(json);
                if(jsonString){
                    json = jsonString ;
                }else{
                    L.Logger.debug('[tk-sdk]toJsonStringify:data is not json!'  );
                }
            }catch (e){
                L.Logger.debug('[tk-sdk]toJsonStringify:data is not json!' );
            }
            return json ;
        },
        /*toParse*/
        toJsonParse:function (jsonStr , isChange) {
            isChange = isChange!=undefined?isChange:true;
            if(!isChange){
                return jsonStr ;
            }
            if(!jsonStr){
                return jsonStr ;
            }
            try{
                if( typeof  jsonStr !== 'string'){
                    // L.Logger.debug('[tk-sdk]toJsonParse:jsonStr must is string!');
                    return jsonStr ;
                }
                var json =  JSON.parse(jsonStr);
                if(json){
                    jsonStr = json;
                }else{
                    L.Logger.debug('[tk-sdk]toJsonParse:data is not json string!' );
                }
            }catch (e){
                L.Logger.debug('[tk-sdk]toJsonParse:data is not json string!' );
            }
            return jsonStr ;
        },
        /**
         * 加密函数
         * @param str 待加密字符串
         * @returns {string}
         */
        encrypt: function(str , encryptRandom ) {
            if(!str){return str;}
            encryptRandom = encryptRandom != undefined ? encryptRandom : 'talk_2017_@beijing' ;
            var out = L.hex64Instance.enc(str);
            out = encryptRandom + out + encryptRandom ;
            return out
        },
        /**
         * 解密函数
         * @param str 待解密字符串
         * @returns {string}*/
        decrypt: function(str , encryptRandom ) {
            if(!str){return str;}
            encryptRandom = encryptRandom != undefined ? encryptRandom : 'talk_2017_@beijing' ;
            var regExp = new RegExp( encryptRandom , 'gm' ) ;
            str = str.replace( regExp , '' );
            var out = L.hex64Instance.dec(str);
            return out
        },
    };
}(L));/*global document, console*/
'use strict';
var TK = TK || {} ;
var MOBILETKSDK = MOBILETKSDK || {};
;(function () {
    var _getUrlParams = function(key){
        // var urlAdd = decodeURI(window.location.href);
        var urlAdd = decodeURIComponent(window.location.href);
        var urlIndex = urlAdd.indexOf("?");
        var urlSearch = urlAdd.substring(urlIndex + 1);
        var reg = new RegExp("(^|&)" + key + "=([^&]*)(&|$)", "i");   //reg表示匹配出:$+url传参数名字=值+$,并且$可以不存在，这样会返回一个数组
        var arr = urlSearch.match(reg);
        if(arr != null) {
            return arr[2];
        } else {
            return "";
        }
    };
    var DEV = false ;
    if(window.__SDKDEV__ !== undefined && window.__SDKDEV__!== null && typeof window.__SDKDEV__ === 'boolean'){
        try{
            DEV = window.__SDKDEV__ ;
        }catch (e){
            DEV = false ;
        }
    }
    var debug = (DEV || _getUrlParams('debug') );
    TK.__TkMobileBuild__ = !debug ;
})();
TK.temporary = TK.temporary || {
    callbackMap:{}
};
TK.constant = TK.constant || {};
TK.global = TK.global || {
    initPageParameterFormPhone:{
        mClientType:null , //0:flash,1:PC,2:IOS,3:andriod,4:tel,5:h323	6:html5 7:sip
        serviceUrl:{
            address:null ,
            port:null
        } , //服务器地址
        //addPagePermission:false , //加页权限
        deviceType:null , //0-手机 , 1-ipad
        role:null , //角色
        //classBegin:null , //是否上课,1-上课 , 2-下课， 0-没上课
        playback:null , //是否是回放
        isSendLogMessageToProtogenesis:true, //是否发送日志信息给原生移动端
    },
};
TK.variable = TK.variable || {} ;

/*与移动原生的通信接口-接收原生的数据*/
MOBILETKSDK.receiveInterface = MOBILETKSDK.receiveInterface || {
    /*joinRoom:function(data){
        MOBILETKSDK.sendInterface.logMessage( {method:'joinRoom',data:data} );
        data = L.Utils.toJsonParse(data);
        TK.mobileSdkEventManager.dispatchEvent({type:'mobileSdk_joinRoom' , message:data});
    },*/
    dispatchEvent:function(recvEventData){
        MOBILETKSDK.sendInterface.logMessage( {method:'dispatchEvent',recvEventData:recvEventData});
        recvEventData = L.Utils.toJsonParse(recvEventData);
        TK.mobileSdkEventManager.dispatchEvent({type:'mobileSdk_dispatchEvent' , message:recvEventData } , false);
    },
    /*  drawPermission:function(candraw){ //白板可画权限控制，true-可话画 ， false-不可画
        MOBILETKSDK.sendInterface.logMessage( {method:'drawPermission',candraw:candraw} );
        if(typeof candraw === 'number'){
            candraw = (candraw !== 0) ;
        }
        TK.mobileUICoreEventManager.dispatchEvent({type:'mobileSdk_drawPermission' , message:{candraw:candraw}});
    } ,
    pageTurningPermission:function(isPageTurning){ //翻页权限控制，true-可翻页， false-不可翻页
        MOBILETKSDK.sendInterface.logMessage( {method:'pageTurningPermission',isPageTurning:isPageTurning} );
        if(typeof isPageTurning === 'number'){
            isPageTurning = (isPageTurning !== 0) ;
        }
        TK.mobileUICoreEventManager.dispatchEvent({type:'mobileSdk_pageTurningPermission' , message:{isPageTurning:isPageTurning}});
    } ,*/
    setInitPageParameterFormPhone:function (data){ //设置初始化手机端参数
        MOBILETKSDK.sendInterface.logMessage( {method:'setInitPageParameterFormPhone',data:data} );
        data = L.Utils.toJsonParse(data);
        if(!TK.global.isLoadInitPageParameterFormPhone){
            TK.global.isLoadInitPageParameterFormPhone = true ;
            for(var key in data){
                TK.global.initPageParameterFormPhone[key] = data[key] ;
            }
            TK.mobileUICoreEventManager.dispatchEvent({type:'mobileSdk_setInitPageParameterFormPhone' , message:data});
        }
    } ,
    /*修改页面初始化参数*/
    changeInitPageParameterFormPhone:function(changeInitJson){  //修改手机初始化参数
        MOBILETKSDK.sendInterface.logMessage( {method:'changeInitPageParameterFormPhone' , changeInitJson:changeInitJson} );
        changeInitJson = L.Utils.toJsonParse(changeInitJson);
        for (var key in changeInitJson) {
            var value = changeInitJson[key];
            TK.global.initPageParameterFormPhone[key] = value ;
        }
        TK.mobileUICoreEventManager.dispatchEvent({type:'mobileSdk_changeInitPageParameterFormPhone' , message:changeInitJson});
    },
    /*receivePhoneByTriggerEvent:function(eventName, params){ //接收手机端数据
        MOBILETKSDK.sendInterface.logMessage( {method:'receivePhoneByTriggerEvent',eventName:eventName , params:params} );
        TK.mobileUICoreEventManager.dispatchEvent({type:eventName , message:params});
    },*/
    changeDynamicPptSize:function(data){ //改变动态ppt大小
        MOBILETKSDK.sendInterface.logMessage( {method:'changeDynamicPptSize' , data:data} );
        data = L.Utils.toJsonParse(data);
        TK.mobileUICoreEventManager.dispatchEvent({type:'mobileSdk_changeDynamicPptSize' , message:data });
    },
    /*关闭web动态PPT界面的视频播放*/
    closeDynamicPptWebPlay:function () {
        MOBILETKSDK.sendInterface.logMessage( {method:'closeDynamicPptWebPlay'} );
        TK.mobileUICoreEventManager.dispatchEvent({type:'mobileSdk_closeDynamicPptWebPlay'});
    },
    /*执行回调函数*/
    executeWebCallback:function (callbackJson) {
        MOBILETKSDK.sendInterface.logMessage( {method:'executeWebCallback' , callbackJson:callbackJson} );
        callbackJson = L.Utils.toJsonParse(callbackJson);
        var callbackId = callbackJson.callbackId ;
        if(callbackId){
            if(TK.temporary.callbackMap[callbackId] && typeof TK.temporary.callbackMap[callbackId] === 'function'){
                if(callbackJson.data && typeof callbackJson.data === 'string'){
                    callbackJson.data = L.Utils.toJsonParse(callbackJson.data);
                }
                TK.temporary.callbackMap[callbackId](callbackJson.data);
            }else{
                L.Logger.info('[tk-mobile-sdk]executeWebCallback:callbackMap[callbackId]  is not exist or not\'s function , callbackJson:'+L.Utils.toJsonStringify(callbackJson)+'!' );
            }
        }else{
            L.Logger.info('[tk-mobile-sdk]executeWebCallback:callbackId is not exist , callbackJson:'+L.Utils.toJsonStringify(callbackJson)+'!' );
        }
    },
    /*接收全屏的回调接口
    * @params isFullScreen:boolean 当前是否全屏
    * */
    fullScreenChangeCallback(isFullScreen){
        MOBILETKSDK.sendInterface.logMessage( {method:'fullScreenChangeCallback' , isFullScreen:isFullScreen} );
        if(typeof isFullScreen === 'number'){
            isFullScreen = (isFullScreen !== 0) ;
        }
        TK.mobileUICoreEventManager.dispatchEvent({type:'mobileSdk_fullScreenChangeCallback' , message:{isFullScreen:isFullScreen}} );
    }
 };

/*与移动原生的通信接口-发送原生的数据*/
MOBILETKSDK.sendInterface = MOBILETKSDK.sendInterface || {
        /*基础接口*/
        interface:function (interfaceName , data ,  clientType ) {
            if(!TK.global.initPageParameterFormPhone){return ;} ;
            clientType = clientType ||  TK.global.initPageParameterFormPhone.mClientType ;
            switch ( clientType){
                case L.Constant.mClientType.ios://ios
                    if(window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers[interfaceName] ){
                        data = data || "";
                        L.Logger.debug("[tk-mobile-sdk]interface:window.webkit.messageHandlers."+interfaceName+".postMessage has been performed!");
                        window.webkit.messageHandlers[interfaceName].postMessage({"data":data});
                    }else{
                        L.Logger.error("[tk-mobile-sdk]interface:window.webkit.messageHandlers."+interfaceName+".postMessage is not exist!");
                    }
                    break;
                case L.Constant.mClientType.andriod://android
                    if(window.JSWhitePadInterface && window.JSWhitePadInterface[interfaceName]){
                        L.Logger.debug("[tk-mobile-sdk]interface:window.JSWhitePadInterface."+interfaceName+" has been performed!");
                        window.JSWhitePadInterface[interfaceName]( data );
                    }else{
                        L.Logger.error("[tk-mobile-sdk]interface:window.JSWhitePadInterface."+interfaceName+" is not exist!");
                    }
                    break;
                default:
                    L.Logger.error('[tk-mobile-sdk]clientType not in sdk , will not be able to execute method(window.JSWhitePadInterface.'+interfaceName+')');
                    break;
            }
        },

        /*获取信息基础接口*/
        getInfoBaseInterface:function (interfaceName , callback , extraJson) {
            if(!callback || typeof callback !== 'function' ){
                L.Logger.error('[tk-mobile-sdk]'+interfaceName+' callback is not exist or not\'s function!');
                return undefined ;
            };
            var callbackId = interfaceName+'_'+new Date().getTime()+"_"+Math.round(Math.random()*1000000) ;
            TK.temporary.callbackMap[callbackId] = callback ;
            var json = {callbackId:callbackId} ;
            if(extraJson && typeof extraJson === 'object'){
                for(var key in extraJson){
                    json[key] = extraJson[key];
                }
            }
            json = L.Utils.toJsonStringify(json);
            MOBILETKSDK.sendInterface.interface(interfaceName , json );
        },

        /*日志发送接口*/
        logMessage:function(message,clientType){
            if(!TK.global.initPageParameterFormPhone){return ;} ;
            message = L.Utils.toJsonStringify(message);
            var mClientType  = null ;
            switch (clientType){
                case L.Constant.IOS:
                    mClientType = L.Constant.mClientType.ios ;
                    break;
                case L.Constant.ANDRIOD:
                    mClientType = L.Constant.mClientType.andriod ;
                    break;
                default:
                    mClientType = TK.global.initPageParameterFormPhone.mClientType ;
                    clientType =  mClientType === L.Constant.mClientType.andriod ? L.Constant.ANDRIOD : (
                        mClientType === L.Constant.mClientType.ios ? L.Constant.IOS : 'unknown'
                    );
                    break;
            }
            L.Logger.debug("[tk-mobile-sdk]logMessage info ,  clientType:"+clientType+" , mClientType:"+mClientType+" , message:"+message );
            if(mClientType != TK.global.initPageParameterFormPhone.mClientType){
                return ;
            }
            if(!TK.global.initPageParameterFormPhone.isSendLogMessageToProtogenesis){
                MOBILETKSDK.sendInterface.interface('printLogMessage' ,  L.Utils.toJsonStringify({msg:message})  , mClientType );
            }
        },

        /*动态PPT视频自动播放接口*/
        dynamicPptVideoAutoPlay:function (dynamicPptVideoJson) {
            var dynamicPptVideoData = L.Utils.toJsonStringify(dynamicPptVideoJson);
            MOBILETKSDK.sendInterface.interface('onJsPlay' ,  dynamicPptVideoData );
        },

        /*页面全屏接口*/
        changeWebPageFullScreen:function (isFullScreen) {
            MOBILETKSDK.sendInterface.interface('changeWebPageFullScreen' ,  isFullScreen );
        } ,

        /*页面加载完毕通知原生接口*/
        onPageFinished:function () {
            var clientType = undefined ;
            if(window.JSWhitePadInterface){
                clientType =  L.Constant.mClientType.andriod ;
            }else if(window.webkit && window.webkit.messageHandlers){
                clientType =  L.Constant.mClientType.ios ;
            }
            MOBILETKSDK.sendInterface.interface('onPageFinished' , undefined , clientType );
        },

        /*发送数据的接口*/
        pubMsg:function (msgName, msgId, toId, data, save, expiresabs ,  associatedMsgID , associatedUserID) {
            var params = {};
            if(data && typeof data === 'object' ){
                data = L.Utils.toJsonStringify(data);
            }
            params.signallingName=msgName;
            params.id=msgId;
            params.toID=toId;
            params.data=data;
            if(!save){
                params.do_not_save=true;
            }
            if(expiresabs !== undefined){
                params.expiresabs = expiresabs;
            }
            if(associatedMsgID !== undefined){
                params.associatedMsgID = associatedMsgID ;
            }
            if(associatedUserID !== undefined){
                params.associatedUserID = associatedUserID ;
            }
            params = L.Utils.toJsonStringify(params);
            MOBILETKSDK.sendInterface.interface('pubMsg' , params );
        } ,

        /*删除数据的接口*/
        delMsg:function (msgName, msgId, toId, data) {
            if(data && typeof data === 'object' ){
                data = L.Utils.toJsonStringify(data);
            }
            var params = {};
            params.signallingName=msgName;
            params.id=msgId;
            params.toID=toId;
            params.data=data;
            params = L.Utils.toJsonStringify(params);
            MOBILETKSDK.sendInterface.interface('delMsg' , params );
        },

        /*改变用户属性*/
        changeUserProperty(id, tellWhom, properties){
            if (properties === undefined || id === undefined){
                L.Logger.error('[tk-mobile-sdk]changeUserProperty properties or id is not exist!');
                return ;
            }
            var params = {};
            params.id = id;
            params.toID = tellWhom || "__all";
            if( !(properties && typeof properties === 'object') ){L.Logger.error('[tk-mobile-sdk]properties must be json , user id: '+id+'!'); return ;} ;
            params.properties = properties;
            params = L.Utils.toJsonStringify(params);
            MOBILETKSDK.sendInterface.interface('setProperty' , params );
        } ,

} ;
