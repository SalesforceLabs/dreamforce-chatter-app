ChatterUI.namespace('ChatterUI.SearchManager');
ChatterUI.SearchManager = (function($) {
    var templates = ChatterUI.Templates,
        searchTerm = '',
        hideTimer = null,
        $currentItem = null,
        $containerEl = null,
        $resultsEl = null,
        $contentListEl = null;
    
    /**
     * Sets up type ahead for search box
     * @param container to wire the search within
     * @param {function} optional callback function to be used to handle search results
     */
    function wireSearch($container, $contentList, searchMethod, listHandler, options) {
        if ($container) {
            var $form = $($container.selector + ' form.type-ahead');
			$contentListEl = $contentList;
			 
            $form.off('submit').on('submit', function(e) {
                e.preventDefault();
                return false;
            }).find('input').off('keyup').on('keyup', function(e) {
                var $input = $(this),
                    val = $.trim($input.val()),
                    len = $input.val().length,
                    code = (e.keyCode ? e.keyCode : e.which);
				
                if (code === 40 || code === 38 || code === 13) {
                    doKeyDown($resultsEl, code, $input);
                } else if (val && (len > 1) && (val != searchTerm) && (searchTerm.indexOf(val) == -1)) {
                    searchTerm = val;
                    doSearch($input, $container, searchTerm, searchMethod, listHandler, options);
                } else if (len == 0) {
                    // hide search results div
                    hideTypeAheadSearch();
                    searchTerm = '';
                }
                return false;
            }).off('blur').on('blur', function() {
           		setTypeAheadTimer('', 200);
            });

            $('div.icon-clear').off('click').on('click', function() {
                $containerEl.find('form.type-ahead input').attr('value', '');
                hideTypeAheadSearch();
            });
        }
    }
    
    function doSearch($input, $container, term, searchMethod, listHandler, options) {
        options = options || {};
        if (!term) {
        	term = searchTerm;
        } else {
        	searchTerm = term;
        }
		
        $containerEl = $container;
        if ($containerEl.hasClass('search-results')) {
        	$resultsEl = $containerEl;
        } else {
			$resultsEl = $containerEl.find('div.search-results');
		}
		
		$resultsEl.off('scroll').on('scroll', function() {
			clearTypeAheadTimer();
		}).off('blur').on('blur', function() {
			setTypeAheadTimer($resultsEl, 200);
		});
		
        searchMethod(encodeURIComponent(term), function(result, event) {
        	if (event.status && ChatterUI.isValidResponseEvent(event)) {
                handleSearch(term, $input, result, listHandler, options);
            } else {
                ChatterUI.showGenericError();
            }
        });
    }
    
    function handleSearch(term, $input, result, listHandler, options) {
		if (searchTerm == term) {
			var numResults = options.listProp ? result[options.listProp].length : result.length,
				$resultListEl = $resultsEl.find(options.useMobileAlt ? 'select' : 'ul');
			
			$resultListEl.empty();
			if ($contentListEl) {
				$contentListEl.empty();
				showResultSummary(numResults);
			}
			
			if (numResults > 0 && searchTerm != '') {
				// load results
				listHandler($contentListEl, $resultListEl, result, options);
				if (!options.leaveTabsSelected) {
					$('a.info-item').removeClass('selected');
				}
				if (typeof(options.clickHandler) === 'function') {
					options.clickHandler($input, $resultsEl);
				} else {
					$resultsEl.off('click', 'a').on('click', 'a', function() {
						window.location.href = $(this).attr('href');
					});
				}
				
				doKeyDown($resultsEl);
				searchTerm = '';
			} else if (numResults == 0) {
				$resultListEl.append($.tmpl(templates['searchMessage'], {
					msg:	'No results found'
				}));
				searchTerm = '';
			}
			if (options.hideTypeAhead !== true && $resultListEl.html()) {
				$resultsEl.show();
			}
		}
    }
    
    function showResultSummary(results) {
    	var $searchHeader = $('div.search-results-header');
		
		if (searchTerm) {
        	$searchHeader.html($.tmpl(templates['searchHeader'], {
        		term: 		searchTerm,
        		noResults:	results > 0 ? '' : ': no results found'
			}));	
        } else {
        	$searchHeader.empty();
        }
    }

    function doKeyDown($list, code, $input) {
        var $items = $list.find('li'),
            index = 0;
        if ($items.length < 1) {
            return;
        } else if (!code) {
            $currentItem = $items.eq(0);
            $currentItem.addClass('selected');
            $list.scrollTop(0);
            return;
        } else if (!$currentItem) {
            $currentItem = $items.eq(0);
            $items.removeClass('selected');
        } else {
            index = $currentItem.index();
        }
        
        if (code === 40 || code === 38) {
            if (code === 40) {
                // down
                index = (index == $items.length - 1) ? 0 : index + 1;
            } else {
                // up
                index = (index == 0) ? $items.length - 1 : index - 1;
            }
            $currentItem.removeClass('selected');
            $currentItem = $items.eq(index);
            $currentItem.addClass('selected');
            var itemTop = $currentItem.get(0).offsetTop,
                listHeight = $list.height(),
                totalHeight = $list.get(0).scrollHeight,
                itemHeight = 30;
			
			if (ChatterUI.env.isIELt8()) {
				itemTop = totalHeight + (itemTop - itemHeight);
			}
			
            if (itemTop > itemHeight * 2) {
                $list.scrollTop(itemTop - (itemHeight * 2));
            } else if (index = $items.length - 1) {
                $list.scrollTop(0);
            }
        } else if (code === 13 || code === 9) {
            // enter
            $currentItem.find('a').trigger('click');
        }

        if ($input) {
            // move cursor to end
            advanceCursor($input);
        }
    }
    
    /**
     * advances the cursor to the end of an input or textarea
     * @param $input (the input or textarea)
     */
    function advanceCursor($input) {
        var input = $input.get(0);
        if (input.setSelectionRange) {
            var len = $input.val().length * 2;
            input.setSelectionRange(len, len);
        } else {
            $input.val($input.val());
        }

        // Scroll to the bottom, in case we're in a tall textarea
        input.scrollTop = 999999;
    }
	
    function hideTypeAheadSearch($searchContainer) {
    	if (!$searchContainer && $containerEl) {
    		$searchContainer = $containerEl.find('div.search-results');
    	}
    	if ($searchContainer) {
    		$searchContainer.hide().find('ul, select').empty();
    	}
    	searchTerm = '';
    	$currentItem = null;
    	hideTimer = null;
    	ChatterUI.FeedBuilder.resetAtMentions();
    }
    
    function setTypeAheadTimer($searchContainer, secs) {
    	secs = secs || 200;
    	hideTimer = setTimeout(function() {
    		hideTypeAheadSearch($searchContainer);
    	}, secs);
    }
    
    function clearTypeAheadTimer() {
    	 clearTimeout(hideTimer);
    }
    
    function resetGlobalState() {
		searchTerm = '';
        $currentItem = null;
        $containerEl = null;
        $resultsEl = null;
        $contentListEl = null;    	
    }
	
    return {
		doSearch					: doSearch,
		doKeyDown        			: doKeyDown,
		advanceCursor    			: advanceCursor,
		showResultSummary			: showResultSummary,
		wireSearch					: wireSearch,
		hideTypeAheadSearch			: hideTypeAheadSearch,
		setTypeAheadTimer			: setTypeAheadTimer,
		clearTypeAheadTimer			: clearTypeAheadTimer,
		resetGlobalState			: resetGlobalState
    };

})(jQuery);
