ChatterUI.namespace('ChatterUI.Templates');
if (!ChatterUI.Templates) {
    ChatterUI.Templates = {};
}

ChatterUI.Templates = (function($, templates) {

    return ChatterUI.addTemplates(templates, {
        'searchResult':     				'<li class="#{className}"><a data-id="#{id}" data-user="#{user}" href="#{url}"><img src="#{src}" class="search-foto" /><span class="search-text">#{text}</span></a></li>',
        'mobileSearchResult':				'<option data-id="#{id}" data-user="#{user}" value="#{user}">#{text}</option>',
        'peopleWrapper':					'<div class="people-container">#{{bodyHtml}}</div>',
        'peopleSearch':						'<div class="people-search-container clearfix chatter-info-bar">' +
                                                '<div class="search-container">' +
                                                    '<form class="form-post people-search type-ahead">' +
                                                        '<div class="form-post-input border-1 radius-1">' +
                                                            '<input type="text" maxlength="1000" class="search-input" placeholder="Search people..."/>' +
                                                        '</div>' +
                                                        '<div class="icon-mag-glass"></div>' +
                                                        '<div class="icon-clear"></div>' +
                                                    '</form>' +
                                                    '<div class="search-results">' +
                                                        '<ul></ul>' +
                                                    '</div>' +
                                                '</div>' +
                                                   '<div class="info-container"></div>' +
                                            '</div>' +
                                            '<div class="search-results-container">#{{listHtml}}</div>',
        'peopleList':						'<div class="list-container">' +
                                                '<div class="search-results-header"></div>' +
                                                '<ul class="people-list list clearfix"></ul>' +
                                                '<div class="more-container">' +
                                                    '<a id="more-people" href="#" class="cta bg-gradient-2" data-url="">Show more</a>' +
                                                '</div>' +
                                            '</div>',
        'peopleNav':        				'<div class="info-item-container #{containerClass}">' +
                                                '<a href="#{url}" class="info-item #{className}">&nbsp;#{{totalHtml}}</a>' +
                                            '</div>',
        'personItem':       				'<li class="list-item">' +
                                                '<div class="list-foto border-1">' +
                                                    '<a href="#{url}"><img src="#{src}"/></a>' +
                                                    '#{{ownerIconHtml}}' +
                                                '</div>' +
                                                '#{{actionsHtml}}' +
                                                '<div class="list-name">' +
                                                    '<a href="#{url}">' +
                                                        '<h3>#{name}</h3>' +
                                                        '<span class="title">#{title}</span>' +
                                                        '<span class="company">#{company}</span>' +
                                                    '</a>' +
                                                '</div>' +
                                            '</li>',
        'personItemFollowAction': 			'<a class="follow-link#{className} border-3 radius-1 #{iconClass}" data-id="#{followId}" data-user-id="#{userId}" data-follow="#{follow}" href="#"></a>',
        'personItemPendingRequestActions':	'<div class="f-right margin-right-10">' +
                                                '<a class="cta request-link bg-gradient-4" data-id="#{requestId}" data-request="approve" href="#"><span class="icon-approve"></span></a>' +
                                                '<a class="cta request-link bg-gradient-1" data-id="#{requestId}" data-request="deny" href="#"><span class="icon-deny"></span></a>' +
                                            '</div>'
    });

})(jQuery, ChatterUI.Templates);
