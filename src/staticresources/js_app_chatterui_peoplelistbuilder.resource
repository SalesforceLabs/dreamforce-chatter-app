
ChatterUI.namespace('ChatterUI.PeopleListBuilder');
ChatterUI.PeopleListBuilder = (function($) {
    var templates = ChatterUI.Templates,
        currentPage,
        PAGE_SIZE = 25;

    /**
     * grab people list from SFDC
     */
    function buildList($containerEl, $listEl, params) {
        var method,
            id = params.user || ChatterUI.UserContext.userId;
        params.filter = params.filter || 'following';
        method = params.method || (params.filter == 'followers' ? 'getFollowers' : 'getFollowing') ;
        $listEl.attr('data-method', method);
        if ($containerEl) {
            addFollowCounts(id, $containerEl.find('div.info-container'), params.filter);
            // type-ahead search
            ChatterUI.SearchManager.wireSearch($containerEl, $listEl, ChatterUI.Service.searchPeopleByName, ChatterUI.PeopleListBuilder.loadSearchResults, {listProp: 'users'});
        }

        ChatterUI.Service[method](id, function(list, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                displayListHandler(list, event, $containerEl, $listEl, method);
            } else {
                ChatterUI.showGenericError();
            }
        });

        ChatterUI.SearchManager.showResultSummary();

        setupHeader(params.headerContainer);
    }

    /**
     * Map people alphabetically
     * @param peopleResponse - a response from the REST api that contains a list of people.
     * @param method	- type of request.
     * @return {Object} {
     * 					  //alphabetized index of people
     * 					  sortedIndex : [],
     * 					  // letter => person
     * 					  people : {}
     * 					}
     */
    function createMappedList(peopleResponse, method) {
        var groupedPeople = {
                sortedIndex : [],
                people : {}
            },
            alphaMap = {},
            people = peopleResponse.following || peopleResponse.followers || peopleResponse.users || peopleResponse.members,
            key = '';
        if (method == 'getFollowers' || method == 'getSessionFollowers') {
            key = 'subscriber';
        } else if (method == 'getFollowing') {
            key = 'subject';
        } else if (method == 'getMembers') {
            key = 'user';
        }

        $.each(people, function(index, person) {
            //get the char that will be used as the key for each category.
            var firstName = (person[key]) ? person[key]['firstName'] : person['firstName'],
                lastName = (person[key]) ? person[key]['lastName'] : person['lastName'],
                name = (firstName) ? firstName : lastName,
                alphaKey = name.substring(0, 1).toUpperCase();
            //if the current category does not already exist, create a new category with the current key
            if (!alphaMap[alphaKey]) {
                alphaMap[alphaKey] = [];
                groupedPeople.sortedIndex.push(alphaKey);
            }
            //add the current item to its category
            alphaMap[alphaKey].push(person);
        });

        groupedPeople.people = alphaMap;
        groupedPeople.sortedIndex.sort();

        return groupedPeople;
    }

    function displayListHandler(result, event, $containerEl, $listEl, method) {
        method = method || '';
        if (event.status) {
            var listHeaders = [];
            ChatterUI.hideLoadingMask();
            if (ChatterUI.isValidResponseEvent(event)) {
                $listEl.empty();
                $('#more-people').attr('data-url', '').hide();
                currentPage = createMappedList(result, method);

                showNextPage($listEl, method);
                wireUI($containerEl, $listEl, result);
            } else {
              ChatterUI.showGenericError();
            }
        }
    }

    function loadSearchResults($peopleList, $resultList, result, options) {
        var searchResults = options.listProp ? result[options.listProp] : result,
            numResults = searchResults.length;

        if ($resultList) {
        	if (options.useMobileAlt) {
        		$resultList.append($.tmpl(templates['mobileSearchResult'], {
        			id:		'',
        			user:	'',
        			text:	'Please choose a name'
        		}));
        	}
            for (var i=0; i<numResults; i++) {
                var user = searchResults[i];
                $resultList.append($.tmpl(templates[options.useMobileAlt ? 'mobileSearchResult' : 'searchResult'], {
					className:	i == 0 ? 'selected' : '',
					id:     	user.id || user.Id,
					user:   	user.name || user.Name,
					url:    	'#page=profile&user=' + (user.id || user.Id),
					text:   	user.name || user.Name,
					src:    	(user.photo ? user.photo.smallPhotoUrl : user.SmallPhotoUrl)
				}));
            }
        }

        if ($peopleList) {
            wireSearchResults($peopleList, $resultList, result, options);
        }
    }

    function wireSearchResults($peopleList, $resultList, result, options) {
        var $peopleSearchContainer = $('div.people-search-container');
        $('#more-people').attr('data-url', '');
           $peopleList.attr('data-method', '');
        currentPage = createMappedList(result);
        showNextPage($peopleList, '');
        wireUI($peopleSearchContainer, $peopleList, result);
        wireMoreLink($peopleList, result.nextPageUrl, options.clickHandler);
    }

    function showGroupMembers($listEl, groupMemberResult, handler) {
    	var method = 'getMembers';
    	currentPage = createMappedList(groupMemberResult, method);
    	$listEl.attr('data-method', method);
    	showNextPage($listEl, method, handler);
    	wireMoreLink($listEl, groupMemberResult.nextPageUrl, handler);
    }

    function showNextPage($listEl, method, handler) {
        var displayedCount = 0;

        //iterate over each category and display the category header and the list of items in that category
        while(currentPage.sortedIndex.length && displayedCount < PAGE_SIZE ) {
            var header = currentPage.sortedIndex[0],
                people = [];
            showCategoryHeader(header, $listEl);

            while(currentPage.people[header].length > 0 && displayedCount < PAGE_SIZE) {
                people.push(currentPage.people[header].shift());
                displayedCount++;
            }
            addListItems($listEl, people, method);

            if(displayedCount < PAGE_SIZE || currentPage.people[header].length == 0) {
                currentPage.sortedIndex.shift();
            }
        }
        if (typeof(handler) === 'function') {
            handler();
        }
    }

    function showCategoryHeader(headerText, $listEl) {
        var headerHTML, $listRow,
        	headerRegex = new RegExp(ChatterUI.escapeMetachars(headerText));
        	$firstHeader = $listEl.find('li.list-header'),
        	$lastHeader = $listEl.find('li.list-header').filter(function(index) {
        	    return $(this).text().match(headerRegex);
        	});

        if($lastHeader.length > 0) {
            $listRow = $lastHeader;
        }
        else {
            headerHTML = $.tmpl(templates['groupingHeader'], {
                headerText : headerText,
                className: ($firstHeader.length) ? '' : ' first-row'
            });
            $listRow = $listEl.append(headerHTML);
        }

        return $listRow;
    }

    function setupHeader(container) {
        var $topBar = $(container);
        if ($topBar) {
            $topBar.empty();
            document.title = 'People';
            $topBar.html('<h3 class="flush truncate">People</h3>');
        }
    }

    function addListItems($listEl, people, method) {
        method = method || '';
        var key = '';
        if (method == 'getFollowers' || method == 'getSessionFollowers') {
            key = 'subscriber';
        } else if (method == 'getFollowing') {
            key = 'subject';
        } else if (method == 'getMembers') {
        	key = 'user';
        }

        for (var i=0; i<people.length; i++){
            var user = null;
            if (key) {
                user = people[i][key];
            } else {
                user = people[i];
            }
            if (user != null && $listEl != null) {
                addPerson($listEl, user);
            }
        }
    }

    function addFollowCounts(id, $el, filter) {
        ChatterUI.Service.getUserProfile(id, function(profile, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                $el.append($.tmpl(templates['peopleNav'], {
                    totalHtml:   		ChatterUI.formatTotal(profile.followingCounts.people + '', 'Following', true, true),
                    url:   			'#',
                    containerClass:	'',
                    className:		'following-total' + (filter != 'followers' ? ' selected' : '')
                })).append($.tmpl(templates['peopleNav'], {
                    totalHtml:   		ChatterUI.formatTotal(profile.followersCount + '', 'Follower', false, true),
                    url:   			'#',
                    containerClass:	'last',
                    className:		'follower-total' + (filter == 'followers' ? ' selected': '')
                }));
            } else {
                ChatterUI.showGenericError();
            }
        });
    }

    /**
     * grab the next page of results
     */
    function getNextPage($el, url, handler) {
        var $link = $el.find('a.more'),
            method = $el.attr('data-method');
        if (url) {
            ChatterUI.Service.getNextPage(url, function(list, event) {
                if (event.status && ChatterUI.isValidResponseEvent(event)) {
                    currentPage = createMappedList(list, method);
                    showNextPage($el, method);
                    wireUI('', $el, list);
                    wireMoreLink($el, list.nextPageUrl, handler);
                    if (typeof(handler) === 'function') {
                        handler();
                    }
                } else {
                    ChatterUI.showGenericError();
                }
            });
        }
    }

    function wireUI($container, $el, list) {

        ChatterUI.refreshScroller();

        ChatterUI.ProfileBuilder.wireFollowLinks($el);

        // nav links
        $('div.people-search-container').on('click', 'a.info-item', function() {
            var $this = $(this),
                $list = $('ul.people-list'),
                params = {};
            if ($this.hasClass('selected')) {
                return false;
            }

            $('a.info-item').removeClass('selected');
            $this.addClass('selected');

            if ($this.hasClass('following-total')) {
                params.filter = 'following';
            } else {
                params.filter = 'followers';
            }
            $('#more-link').hide();
            buildList('', $list, params);
            return false;
        });

        // next page
        wireMoreLink($el, list.nextPageUrl);
    }

    /**
     * appends a 'more' link if there are more rows
     */
    function wireMoreLink($el, url, handler) {
        var selector = 'more-people',
            $more;
        if (ChatterUI.getEl(selector)) {
            // update
            $more = $('#' + selector);
            if(url) {
                $more.attr('data-url', url);
            }
            if (currentPage.sortedIndex.length > 0 || url) {
                $more.off('click').on('click', function() {
                    if(currentPage.sortedIndex.length > 0){
                        showNextPage($el, $el.attr('data-method'), handler);
                        ChatterUI.refreshScroller();
                        wireMoreLink($el, url, handler);
                    } else {
                        getNextPage($el, $more.attr('data-url'), handler);
                        $more.attr('data-url', '');
                    }
                    return false;
                }).show();
            } else {
                $more.hide().off('click');
            }
        }
        return false;
    }

    function addPerson($el, user) {
        var markup = $.tmpl(templates['personItem'], {
            name:           user.name,
            title:          user.title || '',
            company:        user.company || '',
            ownerIconHtml:		(user.isGroupOwner) ? $.tmpl(templates['groupOwnerIndicator']) : '',
            src:            (user.photo ? user.photo.smallPhotoUrl : user.SmallPhotoUrl),
            url:            '/apex/Chatter#page=profile&user=' + user.id,
            actionsHtml:        user.id == ChatterUI.UserContext.userId ? '' : $.tmpl(templates['personItemFollowAction'], {
                className:     '',
                iconClass:      user.mySubscription === null ? 'follow' : 'following',
                follow:         user.mySubscription === null ? 'false' : 'true',
                followId:       user.mySubscription ? user.mySubscription.id : user.id,
                userId:         user.id
            })
        });
        $el.append(markup);
    }

    function addPersonWithPendingRequest($el, user, requestId) {
        var markup = $.tmpl(templates['personItem'], {
            name:           user.Name,
            title:          user.Title || '',
            company:        user.CompanyName || '',
            ownerIconHtml:		'',
            src:            (user.photo ? user.photo.smallPhotoUrl : user.SmallPhotoUrl),
            url:            '/apex/Chatter#page=profile&user=' + user.Id,
            actionsHtml:        $.tmpl(templates['personItemPendingRequestActions'], {requestId : requestId})
        });
        $el.append(markup);
    }

    return {
       buildList        			: buildList,
       showCategoryHeader			: showCategoryHeader,
       showGroupMembers				: showGroupMembers,
       loadSearchResults			: loadSearchResults,
       wireSearchResults			: wireSearchResults,
       addPerson                   	: addPerson,
       addPersonWithPendingRequest 	: addPersonWithPendingRequest
    };

})(jQuery);
