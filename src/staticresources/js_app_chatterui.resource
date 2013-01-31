/**
 * IE needs array.indexOf
 */
if(!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(o, start) {
        for(var i = (start || 0), j = this.length; i < j; i++) {
            if(this[i] === o) { return i; }
        }
        return -1;
    }
}

/**
 * Core namespace for Chatter UI framework
 * @namespace
 * @static
 */
var ChatterUI = ChatterUI || (function($) {
    var ua = window.navigator.userAgent;

    /**
     * Determines if the passed variable is a javascript String object
     * @name isString
     * @function
     * @param {Object} s
     * @returns {boolean}
     */
    function isString(s) {
        if(s) {
            return typeof(s) == 'string';
        }
        return false;
    }

    /**
     * @static
     * @name gelEl
     * @member ChatterUI
     */
    function getEl(id) {
        if(isString(id)) {
            return document.getElementById(id);
        }

        return false;
    }

    function namespace() {
        var a=arguments, o=null, i, j, d;
        for (i=0; i<a.length; i=i+1) {
            d=a[i].split(".");
            o=window;
            for (j=0; j<d.length; j=j+1) {
                o[d[j]]=o[d[j]] || {};
                o=o[d[j]];
            }
        }
        return o;
    }

    /**
     * Formats text, replacing \r\n control characters with text wrapped in &lt;p&gt; tags.
     * @function
     * @param   {String}
     * @return  {String}
     * @member  ChatterUI
     */
    function nl2p(s) {
        s = s.replace(/[\r\n]/gim, "<br/>");
        s = s.replace(/<br>/gim, "<br/>");
        s = s.replace(/<br\/>/gi, "\n");
        s = s.replace(/(^.*)/gim, "<p>$1</p>");
        s = s.replace("<p></p>", "");
        s = s.replace(/\r\n/gm, '');

        var x = new RegExp("[\n\r\|]", "gm");
        s = s.replace(x, '');
        s = s.replace(/<p[a-z0-9_=\"\']*>\s*<\/p>/gmi, "");

        return s;
    }

    /**
     * Convenience wrapper for nl2p.
     * @param   {String|Object}     DOM ID or pointer of container to nl2p
     */
    function breakMe(x) {
        x = getEl(x);
        if(x) {
            $(x).html(nl2p(x.innerHTML));
        }
    }

    /**
     * Trims string to given length, keeping words intact (i.e will trim to
     * smaller length in order to avoid truncating mid-word).
     *
     * @name trimKeepWordsTogether
     * @static
     * @memberOf ChatterUI
     * @param {String} str The string to trim.
     * @param {Number} nChars The max length of the return value.
     * @return {String} The trimmed string.
     */
    function trimKeepWordsTogether(str, nChars) {
        if (isString(str) && nChars > 0 && (str.length > nChars)) {
            var s = '.{0,' + nChars + '}\\s';
                re = new RegExp(s), // eg new RegExp(/.{0,100}\s/) when nChars === 100
                m = str.match(re);

            if (m && m[0]) {
                // replace last space
                str = m[0].replace(/\s$/, '');
            }

        }
        return str;
    }

    /**
     * Trims a string to a given length and appends ellipses (...).
     * Uses {@link trimKeepWordsTogether} to avoid truncating mid-word.
     *
     * @name ellipsify
     * @static
     * @memberOf GE
     * @param {String} str The string to ellipsify.
     * @param {Number} nChars The max length of the return value.
     * @return {String} the ellipsified string.
     */
    function ellipsify(str, nChars) {
        if (isString(str) && nChars > 2 && (str.length > nChars)) {
            str = trimKeepWordsTogether(str, nChars - 3) + '...';
        }
        return str;
    }

    /**
     * Takes a SFDC date/time string and parses it for use with javascript Date() objects.
     * Handles IEx's inability to parse UTZ strings.
     * @param   {String}    d       SFDC UTZ format date/time
     * @return  {Date}              JavaScript date ready for consumption
     */
    function sDate(uDate) {
        if(typeof uDate != 'undefined' && uDate !== null) {
            /* handle SFDC's time format - fine for non-IE browser, but we have to force it in IEx :: "2011-09-30T21:12:12.000Z" */
            var d = new Date(),
                mDate = uDate.replace("+0000", "Z"), // sfdc time format is funky and inconsistent
                exDate = mDate.split("T"),
                exDateDate = exDate[0].split("-"),
                exDateTime = exDate[1].replace(".000Z", '').split(":");
            d.setUTCFullYear(exDateDate[0]);
            d.setUTCMonth(exDateDate[1] - 1);
            d.setUTCDate(exDateDate[2]);
            d.setUTCHours(exDateTime[0]);
            d.setUTCMinutes(exDateTime[1]);
            d.setUTCSeconds(exDateTime[2]);

            return d;
        } else {
            return new Date(-1);
        }
    }

    // From hogan.js: https://github.com/twitter/hogan.js
    function coerceToString(val) {
        return String((val === null || val === undefined) ? '' : val);
    }

    /**
     *  Replace chars with HTML entities.
     *  From hogan.js: https://github.com/twitter/hogan.js
     *
     *  @method replaceStrings
     *  @param  {String}    str String to replace chars in
     *  @return {String}        Modified string of chars
     *
     *  @private
     */
    function replaceStrings(str) {
        str = coerceToString(str);
        return htmlEncode(str);
    }

    /**
     *  Escapes characters to be used in a selector
     *
     *  @method escapeMetachars
     *  @param  {String}   value        String to escape chars in
     *  @return {String} The escaped version of the passed in string.
     */
    function escapeMetachars(value) {
        if(value) {
            return value.replace(/([!\"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~])/g,'\\\\\\$1')
        } else {
            return '';
        }
    }

    /**
     *  Escapes HTML in strings. Can iterate on an array or object as well as a primitive string.
     *
     *  @method escapeHtml
     *  @param  {String|Object|Array}   data        Data to escape chars in
     *  @param  [Object|Array]          ignoreList  Optional. Set of values to not escape.
     *  @return {String|Object|Array}               The modified version of the same data type passed in.
     *
     *  @private
     */
    function escapeHtml(data, ignoreList) {
        var ret;

        if (typeof data === 'string') {
            return replaceStrings(data);
        // Escape strings in an array
        } else if (data && $.isArray(data) && data.length) {
            ret = [];
            if (ignoreList && $.isArray(ignoreList)) {
                $.each(data, function (index) {
                    if ($.inArray(data[index], ignoreList) !== -1) {
                        // Don't replace if in ignoreList
                        ret.push(data[index]);
                    } else {
                        ret.push(replaceStrings(data[index]));
                    }
                });
            } else {
                $.each(data, function (index) {
                    ret.push(replaceStrings(data[index]));
                });
            }
            return ret;
        // Escape strings in an object
        } else if (typeof data === 'object') {
            ret = {};
            for (var prop in data) {
                if (data.hasOwnProperty(prop)) {
                    ret[prop] = replaceStrings(data[prop]);
                }
            }
            // Mix back in the ones we really don't want to escape
            if (typeof ignoreList === 'object') {
                $.extend(ret, ignoreList);
            }
            return ret;
        } else {
            return '';
        }
    }

    /**
     * Encodes any HTML tags from a string
     *
     *  @method htmlEncode
     *  @param  {String} value String to encode HTML from
     *  @return {String} The enconded HTML String
     */
    function htmlEncode(value) {
        if (value) {
            var el = document.createElement('div');
            el.innerText = el.textContent = value;
            var returnValue = el.innerHTML;
            // Also replace single and double quotes as this is not done just by reading the inner html.
            // This is needed in case the encoded value is used as an attribute value of a html tag.
            returnValue =  returnValue.replace('\'', '&#39;');
            returnValue =  returnValue.replace('"', '&#34;');
            return returnValue;
        }
        return value;
    }

    function showGenericError() {
       $Cloud.newModal({type: 'error', message: escapeHtml($Cloud.GC.labels.genericRequestFailure)});
    }

    /**
     * Display an error message about a field being too long
     *
     *  @method showLengthErrorMessage
     *  @param  {String}   objectName		Display name for object
     *  @param  {String}   fieldName        Name of field with error
     *  @param  {Number}   length        	The maximum length
     */
    function showLengthErrorMessage(objectName, fieldName, length) {
        var lengthErrorMsg = 'Error saving {0}: {1} can only be {2} characters long.';
        $Cloud.newModal({type: 'error', message: lengthErrorMsg.replace('{0}', objectName).replace('{1}', fieldName).replace('{2}', length)});
    }

    function moveCursorToEnd($el) {
        var el = $el.get(0);
        if (typeof el.selectionStart == "number") {
            el.selectionStart = el.selectionEnd = el.value.length;
        } else if (typeof el.createTextRange != "undefined") {
            el.focus();
            var range = el.createTextRange();
            range.collapse(false);
            range.select();
        }
    }

    function isValidResponseEvent(event) {
        if ((event.status && event.status == 'error')
            || (event.result && event.result.status == 'error')) {
            return false;
        }
        return true;
    }

    function getBaseUrl() {
       var host = document.location.hostname,
           protocol = document.location.protocol;

       host = protocol + '//' + host;
       return host;
    }

    /**
     * Get the current user's profile object
     *
     *  @method getCurrentUserProfile
     */
    function getCurrentUserProfile() {
        var profile = {};
        ChatterUI.Service.getUserProfile(ChatterUI.UserContext.userId, function(user, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                profile.smallPhotoUrl = user.photo.smallPhotoUrl;
                profile.name = user.name;
                profile.title = user.title === null ? '' : user.title;
            }
        });
        return profile;
    }

    function getHash() {
        var params = {}
            ,hash = '#' + (document.location.href.split("#")[1] || '');
        hash.replace(/\#?(?:([^=]+)=([^&]*)&?)/g, function() {
            function decode(s) {
                return decodeURIComponent(s.split("+").join(" "));
            }

            params[decode(arguments[1])] = decode(arguments[2]);
        });

        return params;
    };

    function refreshScroller() {
        //Refreshing scrollers if we are on chatter App.
        if ($Cloud && typeof $Cloud.refreshScrollers == 'function') {
            setTimeout(function() {
                $Cloud.refreshScrollers();
            }, 200);
        }
    };

    /**
     *  Block #panel area UI by adding an overlay.
     *  Used when loading data, etc.
     *
     *  @method showLoadingMask
     *  @static
     */
    function showLoadingMask() {
        $('#loadingMask').show();
        $('body').addClass('blocked');
    };

    /**
     *  Unblock #panel area UI by removing overlay.
     *
     *  @method hideLoadingMask
     *  @static
     */
    function hideLoadingMask() {
        $('#loadingMask').hide();
        $('body').removeClass('blocked');
    };

    function formatTotal(obj, name, skipPlural, allowZero) {
        skipPlural = skipPlural || false;
        allowZero = allowZero || false;
        if (typeof(obj) != 'object' && typeof(obj) != 'string' && typeof(obj) != 'number') {
            return '';
        }

        var total = typeof(obj) == 'object' ?  parseInt(obj.total) : parseInt(obj)
            ,markup;
        if (!total && !allowZero) {
            return '';
        }
         return '<span class="total">' + total + '</span> ' + (typeof(name) == 'undefined' ? '' : name + (total == 1 || skipPlural ? '' : 's'));
    };

    function addTemplates(templates, newTemplates) {

        for (var tpl in newTemplates) {
            if (newTemplates.hasOwnProperty(tpl)) {
                templates[tpl] = newTemplates[tpl];
            }
        }

        return templates;
    };

    /**
     *  sends data to OmniConfig for tracking
     *
     *  @method track
     *  @param  {Object}   hash        the hash containing Chatter page data
     *  @param  [String]   action      an action to track taken on a given Chatter page (post, like, etc.)
     *  @return nothing
     *
     *  @public
     */
    function track(hash, action) {
        if (typeof(OmniConfig) != 'undefined') {
            OmniConfig.trackChatter(hash, action);
        }
    };

    return {
        defaults        : {
            postFieldValue          : 'What are you doing?',
            profilePostFieldValue   : 'Share with {user}...',
            groupPostFieldValue     : 'Share with {group}...',
            commentFieldValue       : 'Write a comment...',
            chatterFeed             : 'main-chatter-feed'
        },
        feeds              : {
            USER_PROFILE_FEED: 'getUserProfileFeed',
            USER_FEED: 'getCurrentUserFeed',
            GROUP_FEED: 'getGroupFeed',
            AT_ME_FEED: 'getFeedsAtMe',
            USER_SESSIONS_FEED: 'getMyObjectFeed',
            SESSION_FEED: 'getSessionFeed',
            FILES_FEED: 'getMyFilesFeed'
        },
        env                : {
            // feed location
            baseUrl     : getBaseUrl(),

            // user-agent
            isChrome	: (ua.toLowerCase().indexOf('chrome') > -1),
            isGecko		: (ua.indexOf("Gecko") > -1),
            isIpad		: (ua.toLowerCase().indexOf('ipad') > -1),
            isIE		: (ua.indexOf("MSIE") > -1),
            isIE7		: (ua.indexOf("MSIE 7") > -1),
            isIE8		: (ua.indexOf("MSIE 8") > -1),
            isIE9		: (ua.indexOf("MSIE 9") > -1),
            isTouch		: 'createTouch' in document,
            isIELt8		: function() {
                return $('html').hasClass('ieLt8');
            },
            isIELt9		: function() {
                return $('html').hasClass('ieLt9');
            },
            isMac		: (ua.toLowerCase().indexOf("macintosh") > 1),
            locale		: 'en_us'
        },
        ua : ua,

        // static functions
        breakMe                : breakMe,
        ellipsify              : ellipsify,
        getEl                  : getEl,
        nl2p                   : nl2p,
        isString               : isString,
        namespace              : namespace,
        sDate                  : sDate,
        trim                   : trimKeepWordsTogether,
        isValidResponseEvent   : isValidResponseEvent,
        getHash                : getHash,
        formatTotal            : formatTotal,
        escapeHtml             : escapeHtml,
        escapeMetachars		   : escapeMetachars,
        htmlEncode			   : htmlEncode,
        addTemplates           : addTemplates,
        moveCursorToEnd        : moveCursorToEnd,
        showGenericError       : showGenericError,
        showLengthErrorMessage : showLengthErrorMessage,
        track				   : track,
        refreshScroller		   : refreshScroller,
        getCurrentUserProfile  : getCurrentUserProfile,
        showLoadingMask		   : showLoadingMask,
        hideLoadingMask		   : hideLoadingMask
    };
})(jQuery);

/**
 * Create a hash of all query params / hash params
 * takes the current URL query string and does a replace on it,
 * using the callback function to append each token/param to a global array
 * that can then be used like a server-side language's built-in access to all query params
 */
var $_GET = {};
// regex to identify the query-string portion of the URL
document.location.search.replace(/\??(?:([^=]+)=([^&]*)&?)/g, function() {
    function decode(s) {
        return decodeURIComponent(s.split("+").join(" "));
    }

    // for all matches, add the decoded pieces of a query parameter (key/value) to the global array
    $_GET[decode(arguments[1])] = decode(arguments[2]);
});
