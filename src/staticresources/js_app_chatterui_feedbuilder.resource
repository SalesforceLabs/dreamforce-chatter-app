ChatterUI.namespace('ChatterUI.FeedBuilder');
ChatterUI.FeedBuilder = (function($) {
    var feeds = {}
        templates = ChatterUI.Templates,
        lastMention = '',
        searchTerm = '',
        atPos = -1;

    /**
     * add new feed to the list
     */
    function create(container, params, id) {
        id = id || ChatterUI.defaults.chatterFeed;
        var $container,
            moreText = params.moreText || 'Show More Chatter...',
            param = params.feedParam || '';
        if (!ChatterUI.getEl(id)) {
            $container = $(container);
            // append markup so that it will be there in configPage
            $container.append($.tmpl(templates['feedsWrapper'], {
                id:         id,
                method:     params.feed,
                moreText:   moreText,
                param:      param,
                url:        '',
                formHtml:       params.postMethod ? $.tmpl(templates['feedForm'], {
                    id:         	id,
                    postMethod: 	params.postMethod,
                    param:      	param,
                    uploadIcon:		ChatterUI.UserContext.usingMobile ? 'camera' : 'clip',
                    hideFileUpload:	ChatterUI.FileManager.isFileUploadEnabled() ? '' : 'display-none',
                    listContainerHtml:	ChatterUI.env.isTouch ? '<select></select>' : '<ul></ul>'
                }) : ''
            }));
        }

        var $el = $('#' + id);
        feeds[id] = $el;
        getFeed($el);
    }

    /**
     * grab feed from SFDC
     */
    function getFeed($el) {
        var id = $el.attr('id'),
            itemsDisplayed = false,
            itemsLen,
            method = $el.attr('data-method') || 'currentUserFeed',
            param = $el.attr('data-feed-param');

        if (id && ChatterUI.Service[method]) {
            $el.fadeOut(200).empty();
            var isError = false;
            if (param) {
                ChatterUI.Service[method](param, function(feed, event) {
                    if (event.status && ChatterUI.isValidResponseEvent(event)) {
                        itemsLen = feed.items.length;
                        for (var i=0; i<itemsLen; i++){
                            if (ChatterUI.FeedItemBuilder.addItem(feed.items[i], feeds[id])) {
                                itemsDisplayed = true;
                            }
                        }

                        if (itemsLen > 0 && !itemsDisplayed) {
                            $el.append($.tmpl(templates['searchMessage'], {
                                msg:    'No feed items available'
                            }));
                        }

                        wireMoreLink(feeds[id], feed.nextPageUrl);
                    } else {
                        isError = true;
                    }
                });
            } else {
                ChatterUI.Service[method](function(feed, event) {
                    if (event.status && ChatterUI.isValidResponseEvent(event)) {
                        for (var i=0; i<feed.items.length; i++){
                            ChatterUI.FeedItemBuilder.addItem(feed.items[i], feeds[id]);
                        }
                        wireMoreLink(feeds[id], feed.nextPageUrl);
                    } else {
                        isError = true;
                    }
                });
            }

            if (isError) {
                ChatterUI.showGenericError();
            } else {
                ChatterUI.PostBuilder.resetMentionList();
            }

            wireUI($el);
            $el.fadeIn();
        }
    }

    /**
     * grab the next page of results
     */
    function getNextPage($el, url) {
        var id = $el.attr('id');
        if (url) {
            ChatterUI.Service.getNextPage(url, function(feed, event) {
                if (event.status && ChatterUI.isValidResponseEvent(event)) {
                    for (var i=0; i<feed.items.length; i++){
                        ChatterUI.FeedItemBuilder.addItem(feed.items[i], feeds[id]);
                    }
                    wireMoreLink(feeds[id], feed.nextPageUrl);
                } else {
                    ChatterUI.showGenericError();
                }
            });
        }
    }

    /**
     * appends a 'more' link if there are more rows
     */
    function wireMoreLink($el, url) {

        ChatterUI.refreshScroller();
        ChatterUI.hideLoadingMask();

        var selector = 'more-' + $el.attr('id');
        if (!url) {
            $('#' + selector).hide().off('click');
            return;
        }

        if (ChatterUI.getEl(selector)) {
            // update
            $('#' + selector).attr('data-url', url).off('click').on('click', function() {
                getNextPage($el, url);
                return false;
            }).show();
        }
    }

    function wireUI($el) {
        // configure all forms on page
        var $wrapper = $('#wrapper-' + $el.attr('id'));
        $wrapper.find('form.feed-post').each(function() {
            var $this = $(this);
            ChatterUI.PostBuilder.wireSubmit($this);
            wireTextAreas($this);
            $this.find('textarea.share').attr('placeholder', ChatterUI.defaults.postFieldValue);
        });

        wirePostActionsContainer();
    }

    /**
     * sets line wrapping for text areas
     */
    function wireTextAreas($form) {
        var curRows = 1,
            charsInRow = 0,
            prevLength = 0,
            lastKeyCode = -1,
            selector = 'textarea.textarea-input',
            $search;

        ChatterUI.SearchManager.resetGlobalState();
        $form.off('keydown', selector).on('keydown', selector, function(e) {
        	lastKeyCode = (e.keyCode ? e.keyCode : e.which);
        }).off('keyup', selector).on('keyup', selector, function(e){
            var code = (e.keyCode ? e.keyCode : e.which),
                $this = $(this),
                val = $this.val(),
                width = $this.width(),
                pixelsPerChar = 8, // adjust?
                atMentionLength = 10,
                maxCharsInRow = Math.floor(width / pixelsPerChar),
                $longMessage = $('div.long-message'),
                maxPostLength  = parseInt($this.attr('maxLength'));

            if (val.length > prevLength) {
                charsInRow += (val.length - prevLength);
            }
            prevLength = val.length;

            if (val.length >= (maxPostLength - 50) && $longMessage.length == 0) {
                // give a warning at 50 chars
                $(templates['longPostMessage']).insertBefore($this);
            } else if (val.length <= (maxPostLength - 100) && $longMessage.length > 0) {
                // when we're back down below, remove the warning
                $longMessage.remove();
            }

            if (val.length > maxPostLength) {
                // enforce the max length if the browser won't
                $this.val($this.val().substring(0, maxPostLength - 1));
            }

            if (!lastMention && val.length < 2 && val.indexOf("\n") == -1) {
                // reset to 1 (needs to be < 2 because after a post, your first keyup makes the length > 0)
                curRows = 1;
                if (charsInRow > maxCharsInRow && code !== 13) {
                    curRows += 1;
                    charsInRow = 0;
                }
            } else if ((charsInRow > maxCharsInRow) || (code === 13 && !lastMention) || ((code === 13 || code === 9) && (charsInRow + atMentionLength > maxCharsInRow))) {
                // if we've exceeded the max; or there was an enter key not involved in an @mention; or an @mention will take us over the max
            	curRows += 1;
                charsInRow = 0;
            }

            $this.css('height', 'auto').attr('rows', curRows);

            $search = $this.siblings('div.search-results');
            // @mention type-ahead search
            if ((val.lastIndexOf('@') == val.length - 1)) {
                $search.find(ChatterUI.env.isTouch ? 'select' : 'ul').empty().prepend($.tmpl(templates[ChatterUI.env.isTouch ? 'mobileSearchMessage' : 'searchMessage'], {
                    msg:	'Type in a name...'
                }));
                $search.show();
                atPos = val.lastIndexOf('@');
                lastMention = val.substring(atPos);

            } else if (lastMention) {
                if (code === 40 || code === 38 || code === 13 || code === 9) {
                    ChatterUI.SearchManager.doKeyDown($search, code, $this);
                    if (code === 13) {
                        $this.val($this.val().substring(0, $this.val().length - 1));
                    }
                } else if (val.lastIndexOf('@') != atPos) {
                    lastMention = '';
                    atPos = -1;
                } else {
                    lastMention = val.substring(atPos);
                    if (lastMention.length > 2 && lastMention == $.trim(lastMention)) {
                        searchTerm = lastMention.substring(1);
                        ChatterUI.SearchManager.doSearch($this, $search, searchTerm, ChatterUIController.searchUsersByName, ChatterUI.PeopleListBuilder.loadSearchResults, {clickHandler: ChatterUI.FeedBuilder.wireAtMentions, useMobileAlt: ChatterUI.env.isTouch});
                        searchTerm = '';
                    }
                }
            }

            if (!lastMention) {
            	// no mention in progress; no timer needed
                ChatterUI.SearchManager.hideTypeAheadSearch($search);
            }
        }).off('blur', selector).on('blur', selector, function(e) {
        	// check for blur of the textarea
        	if (lastKeyCode === 9 && lastMention != '') {
       			e.preventDefault();
        		e.stopPropagation();
   	    		setTimeout(function() {
       				e.target.focus();
       			}, 0);
       			return false;
       		} else {
       			// set a timer on the type-ahead; it may be cleared by picklist scroller
       			ChatterUI.SearchManager.setTypeAheadTimer($search, 200);
       		}
        });
    }

    function wireAtMentions($textarea, $results) { 
        if (ChatterUI.env.isTouch) {
        	$results.find('select').off('change').on('change', function() {
        		mentionUser($textarea, $results, $(this).find('option:selected'));
       			return false;
       		}).off('blur').on('blur', function() {
       			ChatterUI.SearchManager.setTypeAheadTimer($results, 200);
       		}).off('focus').on('focus', function() {
				ChatterUI.SearchManager.clearTypeAheadTimer();
			});
		} else {
			$results.off('click', 'a').on('click', 'a', function() {
				mentionUser($textarea, $results, $(this));
				return false;
			});
		}
		$results.show();
    }
    
    function resetAtMentions() {
    	lastMention = '';
    }
    
    function mentionUser($textarea, $results, $selected) {
    	if ($textarea.val().indexOf(lastMention) > -1) {
			$textarea.val($textarea.val().replace(lastMention, '@[' + $selected.attr('data-user') + ']'));
			ChatterUI.PostBuilder.mentionedUsers.push({ id: $selected.attr('data-id'), name: $selected.attr('data-user') });
			lastMention = '';
			atPos = -1;
			// mention just completed; no timer needed
			ChatterUI.SearchManager.hideTypeAheadSearch($results);
			$textarea.trigger('focus');
			ChatterUI.SearchManager.advanceCursor($textarea);
		}
    }

    function wirePostActionsContainer() {
        // paperclip icon for toggling the mobile / desktop upload area
        $('form.form-post').on('click', 'a.post-menu', function(){
            var $toggle = $(this);

            if ($toggle.hasClass('active')){
                hidePostActionsContainer();

            }else{
                showPostActionsContainer();
            }
            return false;
        });

        // close icon for the mobile / desktop upload area
        $("div.post-img-upload div.post-actions-container").on('click', 'a.icon-close', function(){
            hidePostActionsContainer();
            return false;
        });

        // wire up the camera and gallery buttons
        var actionsContainer = $('div.feed-component div.actions-bucket.' + (ChatterUI.UserContext.usingMobile ? 'mobile' : 'desktop'));
        actionsContainer.removeClass('display-none');

        if (ChatterUI.UserContext.usingMobile) {
            ChatterUI.FileManager.wireMobilePhotoActions(actionsContainer);
        }
    }

    function hidePostActionsContainer() {
        $('div.post-img-upload div.post-actions-container').hide('medium');

        // clear out photos that were previously selected but not necessarily posted
        ChatterUI.FileManager.resetUploadInfo();

        // deactivate the main clip toggle
        $('form.form-post a.post-menu').removeClass('active');
        //Refreshing scrollers if we are on chatter App.
        ChatterUI.refreshScroller();
    }

    function showPostActionsContainer() {
        if (!ChatterUI.UserContext.usingMobile) {
            // load file upload iframe for desktop, even if it was previously loaded
            // this is to handle cases when there are timeout or network connection issues
            $('div.form-post-container.post-img-upload div.iframeContainer').html($.tmpl(templates['fileUploadIframe'], {section:'', width:330, height:40}));
        }
        $('div.post-img-upload div.post-actions-container').show('medium');

        // activate the main clip toggle
        $('form.form-post a.post-menu').addClass('active');
        ChatterUI.refreshScroller();
    }

    return {
        feeds                   : feeds,
        create                  : create,
        wireTextAreas           : wireTextAreas,
        wireAtMentions          : wireAtMentions,
        resetAtMentions			: resetAtMentions,
        hidePostActionsContainer: hidePostActionsContainer
    };

})(jQuery);
