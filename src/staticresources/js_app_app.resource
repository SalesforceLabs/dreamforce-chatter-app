/**!
 * js_app_app.js
 *
 * The Main App
 *
 */

;(function (window, document, $, undefined) {

    var $Cloud = window.$Cloud || {},
        $formFieldNames = [ "SELECT", "INPUT", "TEXTAREA", "LABEL" ],
        docElem = document.documentElement;

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

    // Add properties
    $.extend($Cloud, {
        // Selectors. These won't work here if we move this file into <head> because DOM isn't ready. I'm just saying.
        $wrapper: $('#wrapper'),
        $header: $('#header'),
        $masthead: $('#masthead'),
        $sidebar: $('#appBody').find('.sidebar'), 			// http://jsperf.com/css-selector-perf
        $panels: $('#panels'),
        $panelScroller: $('#panelScroller'),
        $toggleListBar: $('#wrapper').find('.toggleListBar'),
        LARGE_WIDTH: 64,
        MEDIUM_WIDTH: 63,
        SMALL_WIDTH: 45,
        SMALLER_WIDTH: 30,
        SCROLL_DURATION: 500,
        ACCORDION_DURATION: 500,
        // Class name strings
        styleClass: {
            hideNav: "hideNav",
            showSidebar: "showSidebar",
            listSelected: "listSelected",
            hover: "hover"
        },
        // Short markup template strings and other simple strings
        strings: {
            sectionMainHeading: '<section id="#{htmlId}" data-date="#{dataDate}" class="dayList #{styleClass}"><h3 class="sectionMainHeading">#{agendaHeadingText}</h3>',
            sectionMainHeadingNone: '<section id="#{htmlId}" data-date="#{dataDate}" class="dayList #{styleClass}">',
            sectionSubHeading: '<section class="#{styleClass}"><h2 class="sectionSubHeading"><span class="iconClock"></span> #{headingText}</h2>',
            dateHeadingFormat: 'dddd, MMMM Do',
            dateHeadingDayFormat: 'dddd',
            dateHeadingMonthDateFormat: 'MMMM Do',
            basicModal: '<h1 class="modalHeading">' + $Cloud.GC.labels.modalInfoHeading + '</h1><p class="modalBody"></p><div class="buttonContainer"><a class="uiButton closeButton" title="' + $Cloud.GC.labels.btnClose + '">' + $Cloud.GC.labels.btnClose + '</a></div>'
        },
        scrollers: [],
        lang: (navigator.language) ? navigator.language.toLowerCase() : navigator.userLanguage.toLowerCase(),
        /**
         * Tells use whether we can safely use translate3d with this browsers
         * that may say they can support 3d.
         *
         * Notes:
         * Don't use translate3d on elements containing form inputs (Android 2.x).
         * https://github.com/jquery/jquery-mobile/issues/search?utf8=‚úì&q=292
         * http://bit.ly/m7aNev
         * Google's recommended way to detect Android phones:
         * http://bit.ly/fC7hhf
         * The check against "Silk" is Kindle Fire's browser, which is also Android 2.x
         *
         * @property use3d
         * @return Boolean
         *
         * @static
         */
        use3d: !((/android/i.test(navigator.userAgent) && /mobile/i.test(navigator.userAgent)) || /silk/i.test(navigator.userAgent)),

        // https://bugzilla.mozilla.org/show_bug.cgi?id=747081
        hasMozBug747081: (function () {
                var testPosition = function(doTransform) {
                    var select = document.createElement('select'),
                        option = document.createElement('option'),
                        ret;

                    select.appendChild(option);

                    if (doTransform) { select.style.MozTransform = "translate(0, 1px)"; }

                    document.body.appendChild(select);
                    ret = option.offsetTop;
                    document.body.removeChild(select);

                    return ret;
                };

                return testPosition(false) !== testPosition(true);
            })(),
        hasTouch: "ontouchmove" in document,

        /**
         *	Overflow scrolling detection
         *	Credit Scott Jehl: https://github.com/scottjehl/Overthrow
         */
        overflowProbablyAlreadyWorks:
            // Features-first. iOS5 overflow scrolling property check - no UA needed here. thanks Apple :)
            "WebkitOverflowScrolling" in docElem.style ||
            // Touch events aren't supported and screen width is greater than X
            // ...basically, this is a loose "desktop browser" check.
            // It may wrongly opt-in very large tablets with no touch support.
            ( !("ontouchmove" in document) && window.screen.width > 1200 ) ||
            // Hang on to your hats.
            // Whitelist some popular, overflow-supporting mobile browsers for now and the future
            // These browsers are known to get overlow support right, but give us no way of detecting it.
            (function(){
                var w = window,
                    ua = w.navigator.userAgent,
                    // Webkit crosses platforms, and the browsers on our list run at least version 534
                    webkit = ua.match( /AppleWebKit\/([0-9]+)/ ),
                    wkversion = webkit && webkit[1],
                    wkLte534 = webkit && wkversion >= 534;

                return (
                    /* Android 3+ with webkit gte 534
                    ~: Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13 */
                    ua.match( /Android ([0-9]+)/ ) && RegExp.$1 >= 3 && wkLte534 ||
                    /* Blackberry 7+ with webkit gte 534
                    ~: Mozilla/5.0 (BlackBerry; U; BlackBerry 9900; en-US) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.0.0 Mobile Safari/534.11+ */
                    ua.match( / Version\/([0-9]+)/ ) && RegExp.$1 >= 0 && w.blackberry && wkLte534 ||
                    /* Blackberry Playbook with webkit gte 534
                    ~: Mozilla/5.0 (PlayBook; U; RIM Tablet OS 1.0.0; en-US) AppleWebKit/534.8+ (KHTML, like Gecko) Version/0.0.1 Safari/534.8+ */
                    ua.indexOf( /PlayBook/ ) > -1 && RegExp.$1 >= 0 && wkLte534 ||
                    /* Firefox Mobile (Fennec) 4 and up
                    ~: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:2.1.1) Gecko/ Firefox/4.0.2pre Fennec/4.0. */
                    ua.match( /Fennec\/([0-9]+)/ ) && RegExp.$1 >= 4 ||
                    /* WebOS 3 and up (TouchPad too)
                    ~: Mozilla/5.0 (hp-tablet; Linux; hpwOS/3.0.0; U; en-US) AppleWebKit/534.6 (KHTML, like Gecko) wOSBrowser/233.48 Safari/534.6 TouchPad/1.0 */
                    ua.match( /wOSBrowser\/([0-9]+)/ ) && RegExp.$1 >= 233 && wkLte534 ||
                    /* Nokia Browser N8
                    ~: Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaN8-00/012.002; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/533.4 (KHTML, like Gecko) NokiaBrowser/7.3.0 Mobile Safari/533.4 3gpp-gba
                    ~: Note: the N9 doesn't have native overflow with one-finger touch. wtf */
                    ua.match( /NokiaBrowser\/([0-9\.]+)/ ) && parseFloat(RegExp.$1) === 7.3 && webkit && wkversion >= 533
                );
            })()

    }); //end add properties


    // Add methods
    $.extend($Cloud, {

        isIpad: function () {
            try {
                // http://bit.ly/bmENkh
                return navigator.platform === "iPad";
            } catch (e) {}
        },


        isIOS: function () {
            try {
                return navigator.platform === "iPad" || navigator.platform === "iPhone" || navigator.platform === "iPod";
            } catch (e) {}
        },


        isIeLt9: function () {
            return !!($.browser.msie && (parseInt($.browser.version, 10) < 9)); // returns true or false for IE < 9
        },


        /**
         * Checks whether we have a certain browser identification string on <html>
         * Example $Cloud.browserCheck("ieLt9");
         *
         * @method browserCheck
         * @param {String} browserStr String of CSS class expected to be on <html> element
         *
         * @static
         */
        browserCheck: function (browserStr) {
            return $('html').hasClass(browserStr);
        },


        /**
         * Returns an integer value representing the 24-hour value from a time text
         * string for using with Date or moment.js
         *
         * @method  getHourFromStr
         * @param   {String} str    The text string to parse. Example: '12:00pm'
         * @return  {Number}        The 24-hour integer value parsed from the text string
         *
         * @static
         */
        getHourFromStr: function (str) {
            var isPm = /pm/i.test(str),
                // Don't add 12 if 12pm
                addTwelve = (isPm && !(/^12:/i.test(str))),
                num = parseInt(str.split(':')[0], 10);

            return addTwelve ? num + 12 : num;
        },


        /**
         * Returns an integer value representing the minutes parsed from a time text
         * string for using with Date or moment.js
         *
         * @method  getMinutesFromStr
         * @param   {String} str        The text string to parse. Example: '12:45pm'
         * @return  {Number}            Integer value representing minutes parsed from a text string
         *
         * @static
         */
        getMinutesFromStr: function (str) {
            return parseInt(str.split(':')[1], 10);
        },


        /**
         * Creates a new modal and ensures that it works correctly in IE.
         *
         * @method  newModal
         *
         * Example: Page already contains the necessary overlay content inside #overlayContent:
         *          $Cloud.newModal();
         *
         * Example: Closable AJAX modal with no callback:
         *          $Cloud.newModal({url: $(this).attr('href')});
         *
         * Example: Closable basic non-ajax alert with simple string alert message:
         *          $Cloud.newModal('There was an error');
         *
         * Example: Closable non-ajax, alert message object style modal with a callback:
         *          $Cloud.newModal({type: 'error', message: 'Show me'}, function () {
         *              console.log("holla!");
         *          });
         *
         * @param   {Object|String} data               If 'data' is a String, we assume it to be some type of message. Otherwise, we
         *                                             check some properties on the object to determine whether to load a URL with AJAX
         *                                             of if additional information was passwed with the message string, like error code, etc.
         * @param   [Boolean]       data.renderHTML    Optional. Defines if the message needs to be rendered as HTML.
         * @param   [Boolean]       closable           Optional. Defines if the dialog could be closed using esc or overlay click.
         * @param   [Function]      callback           Optional. Callback function to run on modal close.
         *
         * @static
         */
        newModal: function(data, closable, callback) {

            var $content = $('#overlayContent'),
                args = [].slice.call(arguments),
                callbackFn = args.pop(),
                // Default show for inline page content. We don't want to $content.empty() when closing
                // these, so these types of modals need to handle $.modal.close() on their
                // own instead of using $Cloud.closeModal(), but we still want to handle any closeButtons, if any.
                onShow = function (dialog) {
                    var modal = this,
                        $elem = $(dialog.data[0]);
                    $elem.find('.closeButton').one('click', function () {
                        // Need to run the callback here since we aren't calling closeModal
                        if (typeof callbackFn === 'function') {
                            callbackFn.apply();
                        }
                        modal.close();
                        return false;
                    });
                },
                config,
                message;

            // The modal is closable by default, unless otherwise indicated
            if (closable === undefined) {
                closable = true;
            }

            config = {
                    close: closable,
                    overlayClose: closable,
                    autoResize: true,
                    onShow: onShow
            };

            if ($Cloud.browserCheck('ieLt9')) {
                $.extend(config, {
                        minWidth: 500,
                        minHeight: 400,
                        autoResize: false
                 });
            }

            // If only a string was passed in, we assume it to be an href to load via AJAX
            // AJAX modal
            if (data && data.url) {
                $.extend(config, {
                    onShow: function (dialog) {
                        var $elem = $(dialog.data[0]);
                        $elem.html('<div class="transparentMask alternate" id="transparentMask" style="display:block;"><div class="spinner"></div></div>');
                        $elem.load(data.url, function(response, status, xhr) {
                            if (status === 'success') {
                                $elem.find('.closeButton').one('click', function () {
                                    $Cloud.closeModal($elem, callbackFn);
                                    return false;
                                });
                            }
                        });
                    }
                });

                // Make sure to close existing modals
                $Cloud.closeModal();
                $content.modal(config);
            }
            // Alert style modal with dynamic messages
            else if (data && (data.message || typeof data === 'string')) {
                // Fallback to the string version
                message = data.message || data;
                // Extend the config object with an onShow that will append custom content
                $.extend(config, {
                    onShow: function (dialog) {
                        var $elem = $(dialog.data[0]),
                            heading = data.heading;

                        $elem.append($Cloud.strings.basicModal);
                        if (heading) {
                            $elem.find('.modalHeading').text(heading);
                        }
                        if (data.renderHTML) {
                            $elem.find('.modalBody').html(message);
                        } else {
                            $elem.find('.modalBody').text(message);
                        }

                        $elem.find('.closeButton').one('click', function () {
                            $Cloud.closeModal($elem, callbackFn);
                            return false;
                        });
                    }
                });

                // Make sure to close existing modals
                $Cloud.closeModal();
                // Open the modal
                $content.modal(config);
            }
            // Inline page content modal. That is, the page already contains content inside #overlayContent.
            else {
                $.modal.close();
                $content.modal(config);
            }
        },


        /**
         * Close the existing modal
         *
         * @method  closeModal
         *
         * Example: No arguments:
         *          $Cloud.closeModal();
         *
         * Example: Pass a callback:
         *          $Cloud.closeModal(function () {
         *              console.log("holla!");
         *          });
         *
         * Example: Pass a callback and a jQuery object to empty():
         *          $Cloud.closeModal($('#overlayContent'), function () {
         *              console.log("holla!");
         *          });
         *
         * @param   [Object]    $elem       Optional. jQuery object of the element we need to empty().
         * @param   [Function]  callback    Optional. Callback function to run.
         *
         * @static
         */
        closeModal: function ($elem, callback) {
            var args = [].slice.call(arguments),
                callbackFn = args.pop();

            // Fallback if only a callback was passed
            $elem = ($elem instanceof jQuery) ? $elem : $('#overlayContent');

            if (typeof callbackFn === 'function') {
                callbackFn.apply();
            }

            $.modal.close();
            $elem.empty();
        },


        /**
         * Automagically bind overlays to links with specified classes
         *
         * @method  applyOverlays
         * @static
         */
        applyOverlays: function () {

            var $infos = $('a.overlayInfo'),
                $close = $('a.closeButton');

            /**
             * $infos.click(function (e) doesnt work for IE7/8 (not even in a document.ready).
             * We are going to use live instead.
             */
            $infos.live("click", function(e) {
                e.preventDefault();
                $Cloud.newModal({url: $(this).attr('href'), type: 'ajax'});
            });

        },


        /**
         * Block entire app UI by adding an overlay. Used when submit buttons
         * clicked, etc.
         *
         * @method showPageMask
         * @static
         */
        showPageMask: function () {
            $('#pageMask').show();
            $('body').addClass('blocked');
        },


        /**
         * Unblock entire app UI by removing the overlay
         *
         * @method hidePageMask
         * @static
         */
        hidePageMask: function () {
            $('#pageMask').hide();
            $('body').removeClass('blocked');
        },


        /**
         *  Block #panel area UI by adding an overlay.
         *  Used when loading data, etc.
         *
         *  @method showLoadingMask
         *  @static
         */
        showLoadingMask: function () {
            $('#loadingMask').show();
            $('body').addClass('blocked');
        },


        /**
         *  Unblock #panel area UI by removing overlay.
         *
         *  @method hideLoadingMask
         *  @static
         */
        hideLoadingMask: function () {
            $('#loadingMask').hide();
            $('body').removeClass('blocked');
        },


        /**
         * Tells us whether to we can safely use $.transition
         * (You better have loaded js_plugins_jqueryTransitCustom_min!!) or if
         * it needs to be delegated back to $.animate() for frame-based
         * animations in older browsers or if we need to change the animation
         * properties we pass in the object (For example: {y:0} vs {'top':0}).
         * Runs immediately so we can access it as a property.
         *
         * @property useAnimate
         * @return Boolean
         *
         * @static
         */
        useAnimate: (function () {
            // Go ahead an delegate this now, if needed
            if (!$.support.transition) {
                $.fn.transition = $.fn.animate;
                return true;
            }
            if ($Cloud.hasMozBug747081) {
                return true;
            }
            return !$Cloud.use3d; // false if using 3d
        })(),


        /**
         * Emulates a media query. Checks the width of the browser or screen against
         * a specified width (in ems).
         *
         * @method checkMaxWidth
         * @param {Number} [maxWidth]   The width in ems to compare against. Optional.
         * @param {Boolean} [useDeviceWidth]    Whether to check against the max device width. Optional.
         *
         * @static
         */
        checkMaxWidth: function(maxWidth, useDeviceWidth) {
            var baseSize = parseInt($('body').css('font-size'), 10),
                width = useDeviceWidth ? screen.width : $(document).width();

            // Max-Width defined in the media query css file.
            maxWidth = maxWidth || MEDIUM_WIDTH;

            return width / baseSize < maxWidth;
        }, // end shouldHideSidebar


        /**
         *	Use CSS media queries to get reliable values for the viewport width using with JS.
         *
         *	@method	getMediaWidth
         *	@return	{Number}		The width of the element at the current viewport size
         *
         *	@static
         */
        getMediaWidth: function () {
            if (!window.getComputedStyle) {
                return;
            }
            return parseInt(window.getComputedStyle(document.getElementById('mediaWidth')).getPropertyValue('width'), 10);
        },


        /**
         *	Use CSS media queries to get reliable values for the viewport width using with JS.
         *
         *	@method	getMediaDeviceWidth
         *	@return	{Number}			The width of the element at the current DEVICE size
         *
         *	@static
         */
        getMediaDeviceWidth: function () {
            if (!window.getComputedStyle) {
                return;
            }
            return parseInt(window.getComputedStyle(document.getElementById('mediaDeviceWidth')).getPropertyValue('width'), 10);
        },

        matchMediaWidth: function (value) {
            if (value) {
                return parseInt(value, 10) === $Cloud.getMediaWidth();
            }
        },

        matchMediaDeviceWidth: function (value) {
            if (value) {
                return parseInt(value, 10) === $Cloud.getMediaDeviceWidth();
            }
        },

        belowMediaWidth: function (value) {
            if (value) {
                return $Cloud.getMediaWidth() < parseInt(value, 10);
            }
        },

        belowMediaDeviceWidth: function (value) {
            if (value) {
                return $Cloud.getMediaDeviceWidth() < parseInt(value, 10);
            }
        },


        /**
         *  Handles case where a CSS id selector was passed in, but a getElementById
         *  string format is preferrable.
         *
         *  @method trimIdSelector
         *  @param  {String}    str     HTML id selector string
         *  @return {String}            Returns the resulting string
         *
         *  @static
         */
        trimIdSelector: function (str) {
            if (typeof str !== 'string') {
                return;
            }
            if (/^#/.test(str)) {
                str = str.substring(1);
            }
            return str;
        },


        /**
         *  Scrolls to the top of an element and abstracts out differences
         *  between iScroll and normal scrolling.
         *
         *  @method scrollTop
         *  @param  {String}    idSelector  Id string of the element
         *
         *  @static
         */
        scrollTop: function (idSelector) {
            if (typeof idSelector !== 'string') {
                return;
            }

            idSelector = $Cloud.trimIdSelector(idSelector);

            if ($Cloud.scrollers.length) {
                $Cloud.refreshScrollers(idSelector);
                $Cloud.getScroller(idSelector).scrollTo(0,0,0);
            } else {
                $('#' + idSelector).scrollTop(0);
            }
        },


        /**
         *  Library abstraction for scrolling to a specific element within the
         *  wrapper area.
         *
         *  @method scrollToElement
         *  @param  {String}    wrapperId           HTML id selector for the parent element
         *  @param  {String}    targetElemSelector  The desired element to scroll to
         *  @param  [Number]    duration            Optional. The duration (ms) of the animation
         *
         *  @static
         */
        scrollToElement: function (wrapperId, targetElemSelector, duration) {
            if (typeof wrapperId !== 'string' || typeof targetElemSelector !== 'string') {
                return;
            }
            duration = duration || 0;

            wrapperId = $Cloud.trimIdSelector(wrapperId);

            if ($Cloud.scrollers.length) {
                $Cloud.refreshScrollers(wrapperId);
                // Doesn't seem to work without putting in setTimeout
                setTimeout(function () {
                    $Cloud.getScroller(wrapperId).scrollToElement(targetElemSelector, duration);
                }, 0);
            } else {
                $('#' + wrapperId).scrollTo($(targetElemSelector), {duration: duration});
            }

        },


        /**
         *  Gets a plugin's config options from an HTML attribute that contains
         *  the options in a VALID JSON string. Note: You currently cannot pass in functions this way.
         *
         *  Example: Allow scrolling in span areas, but still preventDefault on touchstart
         *  <div class="uiScroller" id="panelScroller" data-scroller='{"scrollSpan":"true"}'>
         *
         *  Example: Enable pull-to-refresh
         *  <div class="uiScroller" id="panelScroller" data-scroller='{"enableRefresh":"true"}'>
         *
         *  Example: Snap the scroll to lis and also pass in a false value for vScrollbar
         *  <div class="uiScroller" id="panelScroller" data-scroller='{"snap":"li", "vScrollbar":""}'>
         *  $Cloud.getPluginOptions($('#panelScroller'));
         *
         *  @method getPluginOptions
         *  @param  {Object}    $elem   jQuery selected DOM node
         *  @param  [String]    attr    Optional. String representing the attribute containing the config
         *  @return [Object]    cfg     The configuration object, if any was found and it was valid JSON
         *
         *  @static
         */
        getPluginOptions: function ($elem, attr) {
            attr = attr || 'data-scroller';
            try {
                return JSON.parse($elem.attr(attr));
            } catch (e) {}
        },


        /**
         * Adds iScroll elements to the page or adjusts the CSS for non-supported browsers.
         * It accepts a jQuery selector string and iterates on each node found in the nodeList to
         * apply scrollers. If you pass in an id selector, it will just iterate once.
         *
         * @method addScroller
         * @param {String} elems    A jQuery selector string for elements to iterate. Example: '.uiScroller'
         * @param {Object} [config] Contains extra iScroll options. Optional.
         *
         * @static
         *
         */
        addScroller: function (elems, config) {
            $elems = $(elems);
            if (!$elems.length) {
                return;
            }

            /**	Browser conditions to use the scroller with
             *	I found native scrolling to be somewhat flaky, so just giving iOS iScroll. iOS6 native implementation seems to be better though.
             *	So this is another reason to use iScroll until we either figure out a way to test for that or get iOS to consistently be able to
             *	repaint/reflow that area. Android does not have this issue.
             */
            var doScroller = $Cloud.isIOS() || $Cloud.$panelScroller.hasClass('scrollEnabled') && !$Cloud.hasMozBug747081,
                $panels	= $Cloud.$panels;


            // Do this if the element is getting a scroller
            function initScroller(options) {
                // If there is a fixed bar above us, we need to know to adjust the offset height
                var $fixedBar   = this.siblings().filter('.fixedBar'),
                    fbHeight    = 0;

                // just in case there are more than one fixed bar
                $.each($fixedBar, function (index) {
                    fbHeight += $(this).outerHeight();
                });

                var childOffset = parseInt(this.find('.padGrid').first().css('padding-top'), 10),
                    id          = this.attr('id'),
                    height      = (fbHeight === 0 ? 0 : fbHeight) + (isNaN(childOffset) ? 0 : childOffset);

                // We need to pass an id to iScroll. If something's not working, make sure you give your scroller an id
                if (!id) {
                    return;
                }

                // Automagically put a child container for scrollable stuff
                this.wrapInner('<div class="uiScrollable" />');

                // Adjust this position to take into account
                this.css({'top': height});


                // Don't put this show() inside the check for refresh below. It will break things. Don't ask why.
                $('#pullDown').show();

                // Make scrollers - Yay!!
                $Cloud.scrollers.push(new iScroll(id, options));

                if (options.enableRefresh) {
                    $panels.addClass('hasPullToRefresh');
                }

            }

            // Do this if we are not using a scroller in order to adjust the layout
            function noScroller() {

                var $fixedBar   = this.siblings().filter('.fixedBar'),
                    fbHeight    = 0,
                    // Hide vert scrollbar in sidebar
                    vertScrollbar = this.attr('id') === 'sideBarScroller' ? 'hidden' : 'auto';

                // just in case there are more than one fixed bar
                $.each($fixedBar, function (index) {
                    fbHeight += $(this).outerHeight();
                });

                // Fix credit Gonzalo
                var offset      = (this.length ? this.offset().top : 0),
                    height      = (fbHeight === 0 ? 0 : fbHeight);


                this.css({'top': height, 'bottom': offset, 'overflow-y': vertScrollbar, 'overflow-x': 'hidden', '-webkit-overflow-scrolling': 'touch'});

            }


            $.each($elems, function (index) {
                var cfg = {
                        hScrollbar: false,
                        // Prevent iScroll from stealing events on form fields. See https://github.com/cubiq/iscroll/issues/83
                        onBeforeScrollStart: function (e) {
                            var target = e.target,
                                i = $formFieldNames.length,
                                tagName;
                            while (target.nodeType !== 1) {
                                target = target.parentNode;
                            }
                            tagName = target.tagName.toUpperCase();

                            // http://jsperf.com/inarray-versus-comparison-operators
                            // Block scrolling and do not preventDefault on spans unless data-scroller='{"scrollSpan":"true"}' is used.
                            // (W-1348713, W-1347346, W-1352219 - most important)
                            while (i--) {
                                if ((this.options.scrollSpan !== 'true' && tagName === 'SPAN') || tagName === $formFieldNames[i]) {
                                    throw "stop";
                                }
                            }
                            e.preventDefault();
                        }
                    },
                    $this = $(this);

                /// Mix-in any passed options
                config = config || $Cloud.getPluginOptions($this);
                if (typeof config === 'object') {
                    $.extend(cfg, config);

                    // Enable pull-to-refresh.
                    // Pass {"enableRefresh":"true"} on data-scroller and a $Cloud.pullToRefresh method
                    if (cfg.enableRefresh) {
                        var $pullDownEl = $('#pullDown'),
                            pullDownOffset = $pullDownEl[0].offsetHeight,
                            pullSensitivity = $Cloud.belowMediaWidth($Cloud.MEDIUM_WIDTH, true) ? 40 : 80,
                            duration = 250;

                        $.extend(cfg, {
                            topOffset: pullDownOffset,
                            onRefresh: function () {
                                if ($pullDownEl.hasClass('loading')) {
                                    $pullDownEl.removeClass('loading flip');
                                    $pullDownEl.find('.pullDownLabel').text($Cloud.GC.labels.pullToRefresh);
                                }
                            },
                            onScrollMove: function () {
                                if (this.y > pullSensitivity && !$pullDownEl.hasClass('flip')) {
                                    $pullDownEl.removeClass('loading').addClass('flip');
                                    $pullDownEl.find('.pullDownLabel').text($Cloud.GC.labels.releaseToRefresh);
                                    if (!$pullDownEl.hasClass('noRotate')) {
                                        $pullDownEl.find('.pullDownIcon').transition({ rotate: '-180deg' }, duration);
                                    }
                                    this.minScrollY = 0;
                                } else if (this.y < pullSensitivity && $pullDownEl.hasClass('flip')) {
                                    $pullDownEl.removeClass('loading flip');
                                    $pullDownEl.find('.pullDownLabel').text($Cloud.GC.labels.pullToRefresh);
                                    if (!$pullDownEl.hasClass('noRotate')) {
                                        $pullDownEl.find('.pullDownIcon').transition({ rotate: '0' }, duration);
                                    }
                                    this.minScrollY = -pullDownOffset;
                                }
                            },
                            onScrollEnd: function () {
                                if ($pullDownEl.hasClass('flip')) {
                                    $pullDownEl.removeClass('flip').addClass('loading');
                                    $pullDownEl.find('.pullDownLabel').text($Cloud.GC.labels.pullToRefreshLoading);
                                    if (!$pullDownEl.hasClass('noRotate')) {
                                        $pullDownEl.find('.pullDownIcon').transition({ rotate: '0' }, 0);
                                    }
                                    $Cloud.pullToRefresh();
                                }
                            }
                        });
                    } //end cfg.enableRefresh
                }


                /**
                 * 	Enable scrollTop in #panels area by clicking on the fixed header bar
                 *	The toggleListBar check is a check for Registration. We don't want to change anything there at this point.
                 */
                if ($this.attr('id') === 'panelScroller' && $Cloud.$toggleListBar.hasClass('canToggleNav') && !cfg.disableScrollTop) {
                    $panels.on('click', '.fixedBar .uiButton, .fixedBar .iconButton', function (e) {
                        e.stopPropagation();
                    });

                    $panels.on('click', '.fixedBar', function (e) {
                        var $scroller2 = $('#detailView'),
                            $pullDown = $('#pullDown'),
                            scrollSel = '',
                            childSel = ':first-child';
                        if ($scroller2.length) {
                            $Cloud.scrollTop('panelScroller2');
                        } else {
                            if ($pullDown.length) {
                                childSel = ':nth-child(2)';
                            }
                            if (doScroller) {
                                scrollSel = '.uiScrollable';
                            }
                            $Cloud.scrollToElement('#panelScroller', '#panelScroller ' + scrollSel + ' > div' + childSel, $Cloud.SCROLL_DURATION);
                        }
                    });
                }

                doScroller ? initScroller.call($this, cfg) : noScroller.call($this);

            });

            // Prevents elastic scrolling within entire screen on iPad, BUT it also prevents scrolling anywhere
            // that does not use iScroll, so this can't be used on Landing-type pages.
            // This check does the job right now. It will need to be reevaluated once we add
            // a scroller for the tabs in the top nav area.
            if ($Cloud.scrollers.length) {
                $(document).bind('touchmove', function (e) { e.preventDefault(); }, false);
            }

        }, // end addScroller


        /**
         *  Remove a scroller from the page
         *
         *  @method removeScroller
         *  @param  {String}    id      String representing the HTML id for the element
         *  @param  [Array]     [arr]   Optional. Array of known scroller objects.
         *
         *  @static
         */
        removeScroller: function (id, arr) {
            arr = arr || $Cloud.scrollers;
            var i = arr.length;

            if (!id) {
                return;
            }

            while (i--) {
                if (arr[i].wrapper.id === id) {
                    arr[i].destroy();   // Destroy iScroll instance
                    arr.splice(i, 1);   // Remove from our reference array
                    break;
                }
            }
        },


        /**
         *  Finds a scroller instance in the page and returns it so you
         *  can use public methods on it.
         *
         *  @method getScroller
         *  @param  {String}    id      String representing the HTML id for the element
         *  @param  [Array]     [arr]   Optional. Array of known scroller objects.
         *  @return
         *
         *  @static
         */
        getScroller: function (id, arr) {
            arr = arr || $Cloud.scrollers;
            var i = arr.length;

            if (typeof id !== 'string') {
                return;
            }

            while (i--) {
                if (arr[i].wrapper.id === id) {
                    return arr[i];
                }
            }
        },


        /**
         * Provides a way to eat events until the last one fires and run a callback
         * function after the specified interval.
         * Example use:
         *  $(window).resize(function () {
         *      delayEvent(updateTabs, 200, "ccheck tabs");
         *  });
         *
         * @method delayEvent
         * @param {string} callback The method to run after the last event has fired
         * @param {number} interval The interval (in ms) to check if events are done firing
         * @param {string} [uniqueId] A unique string to identify this instance. Technically, it is required.
         *
         * @static
         */
        delayEvent: (function () {
            var timers = {};                // Use an object to allow multiple timers for different events
            return function (callback, interval, uniqueId) {
                if (!uniqueId) {
                    uniqueId = "Do not call twice without a unique ID";
                }
                if (timers[uniqueId]) {
                    clearTimeout(timers[uniqueId]);
                }
                timers[uniqueId] = setTimeout(callback, interval);
            };
        })(),



        /**
         * Refresh all uiScrollers from $Cloud.scrollers (optionally passed in via an array)
         * or a single scroller if 'id' is used.
         *
         * @method refreshScrollers
         * @param {string} [id] The HTML id of a specifc scroller to target. This is optional, but you need to pass 'null' if using 'arr'
         * @param {array} [arr] The array of uiScroller elements that have been instantiated and you want to refresh. This is optional.
         * @static
         */
        refreshScrollers: function (id, arr) {
            arr = arr || $Cloud.scrollers;
            var i = arr.length;

            // From iScroll documentation: "So the golden rule is: if unsure call the refresh inside a timeout."
            // And since we are using setTimeout in a loop, we need to create a new scope
            // where 'current' is bound to the current value of the counter variable ('i'). Confusing. I know.
            function callRefresh() {
                setTimeout(
                        (function(current) {
                            return function () {
                                arr[current].refresh();
                            };
                        })(i), 0);                  // pass in current value of 'i'
            }

            while (i--) {
                // Break the loop if we are only targeting a single scroller
                if (!id) {
                    callRefresh();
                } else {
                    if (arr[i].wrapper.id === id) {
                        callRefresh();
                        break;
                    }
                }
            }


        }, // end refreshScrollers


        /**
         * Generalized convenience method for doing slide (up/down, left/right) transitions.
         * Make sure you have inlcuded js_plugins_jqueryTransitCustom_min!!
         *
         * @method slide
         * @param {object}   $elem      jQuery object for the element you want to transition.
         * @param {object}   [config]   Override or extend the default configuration. Optional.
         * @param {function} [callback] Callback function. Optional.
         *
         * @static
         */
        slide: function ($elem, config, callback) {
            if (!$elem) { return; }

            var useAnimate = $Cloud.useAnimate,             // Do we need to do frame-based animations?
                cfg = {                                     // Default configuration object
                    anim: {},                               // This is empty now so we can figure out direction later
                    distance: 0,                            // Original absolute position value
                    direction: useAnimate ? 'left' : 'x',   // Use 'x' for 3d transitions
                    speed: 200,
                    reverse: false
                };

            if (typeof config === 'object') {
                $.extend(cfg, config);
            }

            // Do this here so we can just pass in 'top' without figuring it out beforehand
            if (cfg.direction === 'top' && !useAnimate) {
                cfg.direction = 'y';
            }

            // Which direction are we going?
            cfg.distance = cfg.reverse ? -$elem.width() : cfg.distance;

            // We need to set 'top','left','x','y', etc. as the property name, etc on the anim object
            cfg.anim[cfg.direction] = cfg.distance;

            // Call the plugin
            $elem.transition(cfg.anim, cfg.speed, callback);

        }, // end slide()


        toggleTopNav: function(action) {
            var $wrapper = $Cloud.$wrapper,
                $header = $Cloud.$header,
                speed = 300,
                direction = 'top';
            if (action === 'open') {
                // Fix repaint issue in Chrome
                $header.height($header.height() + 1);
                $header.height($header.height() - 1);
                $header.css({'height': '', 'visibility': 'visible'});
                // Don't do this in the anim callback. Phones have a big delay on pages with many nodes.
                $Cloud.slide($wrapper, { direction: direction, distance: $header.height(), speed: speed}, function () {
                    $wrapper.removeClass('hideNav');
                });
            } else {
                $Cloud.slide($wrapper, { direction: direction, speed: speed}, function () {
                    $wrapper.addClass('hideNav');
                    $header.css({'visibility': 'hidden'});
                });
            }
        },

        bindUI: function () {

            var c = $Cloud.styleClass,
                hideNav = c.hideNav,
                showSidebar = c.showSidebar,
                listSelected = c.listSelected,
                hover = c.hover,
                $wrapper = $Cloud.$wrapper,
                $sidebar = $Cloud.$sidebar;

            // Check whether we need to hide the sidebar on page load since media queries
            // don't handle it for us anymore.
            if ($Cloud.belowMediaWidth($Cloud.LARGE_WIDTH) && !$Cloud.isIeLt9()) {
                $Cloud.slide($sidebar, {reverse: true});
            }


            // Top nav interactions
            $('.canToggleNav').on('mousedown', function (event) {
                var $targetElement = $(event.target);
                // if a header menu was clicked, skip toggling the top nav
                if (!$targetElement.hasClass('basicMenu')) {
                    $('.basicMenu').removeClass('menuOpen');
                    if ($wrapper.hasClass(hideNav)) {
                        $Cloud.toggleTopNav('open');
                    } else {
                        $Cloud.toggleTopNav('close');
                    }
                }
                event.stopPropagation();
            });

            adjustNavSize = function() {
                if (!$wrapper.hasClass(hideNav)) {
                    $Cloud.toggleTopNav('open');
                }
            };

            var toggleSideBar = function () {
                // Can't just re-use $sidebar on iPhone 3G and some Androids
                var $sidebar = $Cloud.$sidebar;

                $sidebar.toggleClass(showSidebar);

                if ($sidebar.hasClass(showSidebar)) {
                    $Cloud.slide($sidebar);
                } else {
                    $Cloud.slide($sidebar, {reverse: true});
                }

            };

            $('body').on('click', function () {
                $('.basicMenu').removeClass('menuOpen');
            });


            $(window).resize(function () {
                // This fires a lot, so we want to wait until resizing is actually finished before doing stuff
                $Cloud.delayEvent(function () {
                    adjustNavSize();
                    $Cloud.refreshScrollers();
                    if (!$Cloud.isIeLt9()) {
                        var $sidebar = $Cloud.$sidebar;
                        if($Cloud.belowMediaWidth($Cloud.LARGE_WIDTH)) {
                            // Keeps from hiding sidebar if window resize, but didn't change to a new breakpoint size
                            if ($sidebar.hasClass(showSidebar)) {
                                return;
                            }
                            $Cloud.slide($sidebar, {reverse: true});
                        } else {
                            $Cloud.slide($sidebar, {speed: 0}, function () {
                                $sidebar.removeClass(showSidebar);
                            });
                        }
                    }
                }, 50, "window resize");
            });

            $('#qrReader').click(function() {
                $Cloud.qrScanner();
            });

            $('.aurasma').click(function() {
                $Cloud.openARTool();
            });

            $('.userMenuLink.logout').click(function() {
                if (typeof SalesforceOAuthPlugin !== 'undefined') {
                    SalesforceOAuthPlugin.logout();
                }
            });

            $('.customAccordion').live("click", function(e) {
                $Cloud.accordionAnimation($(this));
            });

            /*
             * We have to do this, cause the DynamicContent doens't allow href's like tel: or sms:
             */
            $('.telLink').on("click", function() {
                window.location = 'tel:' + $(this).text();
            });

            $('.smsLink').on("click", function() {
                window.location = 'sms:' + $(this).text();
            });

            $('.mailtoLink').on("click", function() {
                window.location = 'mailto:' + $(this).text();
            });

        }, // end bindUI

        /*
         * Accordion Animation
         */
        accordionAnimation: function(header) {

            //toggle the calendar
            var value   = header.attr('data-value'),
                opentab = $(".customAccordion.open").attr('data-value');

            $(".pf"+opentab).slideToggle($Cloud.ACCORDION_DURATION, function(){
                $Cloud.refreshScrollers();
            });
            $(".customAccordion").removeClass('open');
            if (opentab != value) {
                $(".pf" + value + ":not(.hidden)").slideToggle($Cloud.ACCORDION_DURATION, function(){
                    $Cloud.refreshScrollers();
                });
                header.addClass('open');
            }
        },

        //Formats number to currency including comma, negative amounts and dollar sign
        formatCurrency : function(num) {
            num = num.toString().replace(/\$|\,/g, '');

            if (isNaN(num)) {
                num = "0";
            }

            var sign = (num == (num = Math.abs(num)));
            num = Math.floor(num * 100 + 0.50000000001);
            var cents = num % 100;
            num = Math.floor(num / 100).toString();
            var numLength = num.length;

            if (cents < 10) {
                cents = "0" + cents;
            }

            for (var i = 0; i < Math.floor((numLength - (1 + i)) / 3); i++) {
                num = num.substring(0, numLength - (4 * i + 3)) + ',' + num.substring(numLength - (4 * i + 3));
            }

            return (((sign) ? '' : '-') + '$' + num + '.' + cents);
        },

        //function for getting query string parameters
        getParams: function(){
            var vars = [],
                hash,
                hashes = window.location.search.substring(1).split('&'),
                i = hashes.length;

            while (i--) {
                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = escapeHtml(decodeURIComponent(hash[1]));
            }

            return vars;
        },

        getParam: function(name){
            return $Cloud.getParams()[name];
        },

        /**
         * Apply text truncation to the passed in jQuery node list
         *
         * REQUIRES: js_plugins_jqueryExpander_min
         *
         * @method expander
         * @param {array}  $elems Array of jQuery node elements
         * @param {object} [cfg] $.expander plugin configuration values (Optional)
         *
         * @static
         */
        expander : function ($elems, nowrap, cfg) {
            if (!$elems || !$elems.length) {
                return;
            }

            cfg = cfg || {
                slicePoint: 256,
                expandEffect: 'show',
                expandSpeed: 0,
                collapseEffect: 'hide',
                collapseSpeed: 0
            };

            // Truncate
            $elems.expander(cfg);

            // Make sure the link inherits the same font-size as read-more by adding <p>
            // If parent already has font-size, this won't work as expected since
            // it will then add another em'd font-size. In that case pass in 'nowrap' as true
            if (!nowrap) {
                $elems.find('.read-less').wrap('<p />');
            }
        },

        /**
         * If a map is shown allow the user to click on it so they can zoom
         *
         * @method $map: recieves the img elements that have to be binded or wrapped, if no element is recieved it looks for all the images with a class map
         *
         * @static
         */
        bindMaps : function($map) {
            $map = $map || $('img.map');
            if($map.length) {
                var isMobile = $Cloud.isPhonegap(),
                    src      = ($map.attr('src').indexOf('http') == 0)? $map.attr('src') : document.location.protocol + '//' + document.location.hostname + $map.attr('src'),
                    title     = src.split('/').slice(-1)[0],
                    mimes     = {
                        jpg : 'image/jpeg',
                        png : 'image/png'
                    },
                    mime,
                    extension,
                    mimeType;

                if (isMobile) {
                    $.each(mimes, function(extension, mimeType){
                        if(title.indexOf(extension, title.length - extension.length) !== -1) { // If the String ends with the extension
                            mime = mimeType;
                        }
                    });
                    if (!mime) {    // Fail Safe In case no mime type found in the mimes object
                        mime = mimes.png;
                    }
                    $map.on('click', function() {
                        window.plugins.chWebView.openImage($Cloud.phonegapOnSuccess, $Cloud.phonegapOnError, {file: src, name: title, mimeType: mime, authorization: ' '});
                    });
                } else {
                    $map.wrap('<a href="'+src+'" target="_blank" />');
                }
            }
        },

        // Probably we should move all this Phonegap stuffs to a new plugin

       /**
        * PHONEGAP
        * When this function is called, PhoneGap has been initialized and is ready to roll
        */
       onDeviceReady: function() {
            $Cloud.showPhonegapFeatures();
            $Cloud.hideNotPhonegapFeatures();
            $Cloud.findNewWindowsLinks();
            $Cloud.addScroller('.uiScroller');
            navigator.splashscreen.hide();
        },

        /**
         * PHONEGAP
         * Returns whether the user is accessing the app through Phonegap
         */
        isPhonegap: function() {
            return typeof PhoneGap !== 'undefined';
        },

        /**
         * PHONEGAP
         * Show the scpecific Phonegap Features (that are hide by default)
         */
        showPhonegapFeatures: function() {
            $.each($('.phonegapFeature'), function (index) {
                $(this).removeClass('phonegapHidden');
            });
        },

        /**
         * PHONEGAP
         * Hide the not Phonegap Features (that are visible by default)
         */
        hideNotPhonegapFeatures: function() {
            $.each($('.notPhonegapFeature'), function (index) {
                $(this).addClass('phonegapHidden');
            });
        },

        /**
         * PHONEGAP
         * Find all the target="_blank" links, and let the Url Manager open it
         */
        findNewWindowsLinks: function() {
            // we are going to use "live" instead of "on" to avoid issues on modals
            $('a[target="_blank"]').live('click', function(e) {
                if(!$(this).hasClass('overlayInfo')) {
                    if($(this).attr('href').indexOf('http') == 0) {
                        $Cloud.openURLManager($(this).attr('href'));
                    } else {
                        $Cloud.openURLManager(window.location.origin + $(this).attr('href'));
                    }
                    e.preventDefault();
                }
            });
        },

        /**
         * PHONEGAP
         * QR Reader Tool
         */
        qrScanner: function() {
            window.plugins.barcodeScanner.scan($Cloud.onScannerSuccess, $Cloud.phonegapOnError);
        },

        /**
         * PHONEGAP
         * Url Manager tool
         */
        openURLManager: function(url) {
            window.plugins.urlManager.handleUrl($Cloud.phonegapOnSuccess, $Cloud.phonegapOnError, {url: url});
        },

        /**
         * PHONEGAP
         * File Manager tool
         */
        openFileManager: function(url, name, mimeType, authorization) {
            window.plugins.chWebView.openFile($Cloud.phonegapOnSuccess, $Cloud.phonegapOnError, {file: url, name: name, mimeType: mimeType, authorization: authorization});
        },

        /**
         * PHONEGAP
         * Open aurasma ar tool
         */
        openARTool: function() {
            window.plugins.aurasma.startAR($Cloud.phonegapOnSuccess, $Cloud.phonegapOnError, []);
        },

        /**
         * PHONEGAP
         * Sync with the native calendar
         */
        showCalendarSyncConfirm: function() {
            var callback = function(yes){
                if(yes){
                    $Cloud.getData({
                        type: 'get',
                        method: 'getAllEnrollmentsForAllDays',
                        viewHandler: function (result) {
                             window.plugins.calendar.syncCalendar($Cloud.onCalendarSyncComplete, $Cloud.phonegapOnError, result);
                        }
                    });
                }
            };

            $Cloud.phonegapShowConfirm(
                $Cloud.GC.labels.calendarSyncConfirmMessage,
                callback,
                $Cloud.GC.labels.calendarSyncOK,
                $Cloud.GC.labels.calendarSyncCancel,
                $Cloud.GC.labels.calendarSyncTitle
            );
        },

        /**
         * PHONEGAP
         * Default Error Callback
         */
        phonegapOnError: function(error) {
            // Error
        },

        /**
         * PHONEGAP
         * Default Success Callback
         */
        phonegapOnSuccess: function(message) {
            // Success
        },

        /**
         * PHONEGAP
         * Calendar Sync complete Callback
         */
        onCalendarSyncComplete: function(message) {
            navigator.notification.alert(
                $Cloud.GC.labels.calendarSyncCompleteMessage,
                null,
                $Cloud.GC.labels.calendarSyncTitle,
                $Cloud.GC.labels.calendarSyncOK
            );
        },

        /**
         * PHONEGAP
         * QR Reader Success Callback
         */
        onScannerSuccess: function(result) {
            var cancelled = result.cancelled,
                format = result.format,
                userInfo = result.text,
                id = userInfo.split('^')[0];

            if(!cancelled && format === 'QR_CODE') {
                if(id.indexOf('http') == 0) {
                    $Cloud.openURLManager(id);
                } else {
                    window.location.href = 'UserProfile?RegId=' + id;
                }
            }
        },

        /**
         * PHONEGAP
         * Default Confirm Modal
         */
        phonegapShowConfirm: function(message, callback, okButtonLabel, cancelButtonLabel, title) {

            //Set default values if not specified by the user.
            okButtonLabel = okButtonLabel || 'OK';
            cancelButtonLabel = cancelButtonLabel || 'cancellation';
            title = title || "Confirm";

            //Use Cordova version of the confirm box if possible.
            if(navigator.notification && navigator.notification.confirm) {
                if(typeof callback === 'function') {
                    var _callback = function(index) {
                        if(callback) {
                            callback(index == 1);
                        }
                    };
                };

                navigator.notification.confirm(
                    message,
                    _callback,
                    title,
                    okButtonLabel + "," + cancelButtonLabel
                );

            //Default to the usual JS confirm method.
            } else {
                invoke(callback, confirm(message));
            }
        },

        init: function () {
            // Do we need fullpage scrolling or fixed header?
            if (!$Cloud.$panelScroller.length) {
                $('body').addClass('fullpageScroll');
            } else if (!$Cloud.overflowProbablyAlreadyWorks) {
                $Cloud.$panelScroller.addClass('scrollEnabled');
            }

            $Cloud.bindUI();

            $Cloud.applyOverlays();

            if ($Cloud.isPhonegap()) {
                // Phonegap Device Ready event listener
                document.addEventListener("deviceready", $Cloud.onDeviceReady, false);
            } else {
                // Add scroller to all elements with uiScroller class
                $Cloud.addScroller('.uiScroller');
            }

            // Do this after everything is done
            $('body').removeClass('blocked');

            // IE6 originally shows content, but then it disappears. Apparently, reapplying
            // these styles to the CSS will get it to rerender...
            if ($Cloud.browserCheck('ie6')) {
                $(window).load(function () {
                    $('#content, .sidebar').css({'position': 'relative'});
                });
            }

            $('.appNavItem').hover(function() {
                var img = $(this).find('img');
                img.attr('data-originalState', img.css('backgroundPosition') || img.css('background-position-x') + ' ' + img.css('background-position-y'));
                img.css('backgroundPosition', img.attr('data-xyHover'));
            }, function() {
                var img = $(this).find('img');
                img.css('backgroundPosition', img.attr('data-originalState'));
            });

        } // end init


    }); // end add methods


    // init() handled in Template


    /***** Misc plugin utilities *****/


    // Handles case of iOS user hitting 'Next' button on soft keyboard and select list
    // change event not updating a dependent list appropriately:
    // http://bit.ly/KqTirE
    // http://jsfiddle.net/qGjWp/12/
    $.fn.quickChange = function(handler) {
        return this.each(function() {
            var self = this;
            self.qcindex = self.selectedIndex;
            var interval;
            function handleChange() {
                if (self.selectedIndex != self.qcindex) {
                    self.qcindex = self.selectedIndex;
                    handler.apply(self);
                }
            }
            $(self).focus(function() {
                interval = setInterval(handleChange, 100);
            }).blur(function() { window.clearInterval(interval); })
            .change(handleChange); //also wire the change event in case the interval technique isn't supported (chrome on android)
        });
    };

})(this, this.document, jQuery);

