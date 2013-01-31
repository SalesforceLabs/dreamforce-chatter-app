/**!
 * css_lists.css
 *
 *
 */

.horizontal,
.nostyle {
    margin: 0;
    padding: 0;
    list-style-type: none;
}

.horizontal li {
    display: block;
    float: left;
}

a.appNav {
    display: block;
    cursor: pointer;
}

a.appNavLink {
    background: transparent none;
    margin: 0;
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
    display: block;
    width: 100%;
    *width: auto;
    height: 100%;
    text-align: center;
}

.appNav {
    width: 100%;
    overflow: auto;
}

.appNavItem {
    height: 6.25em;
    width: 6.75em;
    font-size: .9em;
    color: #FFF;
}

.appNavItem:hover {
    color: #FFF;
}

.appNavItem.active {
    background-color: #256F9E;
}

.appNavItem.active .appNavTitle {
    color: #FFF;
}

.appNavItem:hover .appNavTitle {
    color: #FFF;
}

.appNavImage {
    width:32px;
    height:32px;
    display: block;
    margin: 1.2em auto 0;
}

.appNavTitle {
    margin: 0.6em 0 0;
    display: block;
}

/* begin basic menu component styles */

.basicMenu {
    display:block;
    float:left;
    height:2em;
    border:1px solid #205F87;
    background-color: #256F9E;
    margin:.33em .5em 0 0;
    background-position:10px 8px;
    position:relative;
    -moz-border-radius:4px;
    -webkit-border-radius:4px;
    border-radius:4px;
}

.basicMenuToggle {
    display:block;
    height:100%;
    color:#FFF;
    font-weight:bold;
    font-size:.9em;
}

.basicMenuToggle:hover {
    color:#FFF;
    background-image:   -moz-linear-gradient(rgba(255,255,255,0.1), rgba(255,255,255,0));
    background-image:-webkit-linear-gradient(rgba(255,255,255,0.1), rgba(255,255,255,0));
    background-image:    -ms-linear-gradient(rgba(255,255,255,0.1), rgba(255,255,255,0));
    background-image:        linear-gradient(rgba(255,255,255,0.1), rgba(255,255,255,0));
}

.basicMenuTitle {
    display:inline-block;
    *display:inline;
    *zoom:1;
    line-height:2em;
    margin-right:1em;
}

.basicMenuTitleTextOnly {
    margin-left:.8em;
    margin-right:2em;
}

.basicMenuOptions,
.basicMenuOption {
    margin:0;
    padding:0;
}

.basicMenuOptions {
    position:absolute;
    top:28px;
    left:-1px;
    background-color:#FFF;
    -moz-border-radius:0 4px 4px 4px;
    -webkit-border-radius:0 4px 4px 4px;
    border-radius:0 4px 4px 4px;
    border:1px solid #DADADA;
    border-top-width:0;
    padding-top:5px;
    display:none;
    -moz-box-shadow:1px 2px 3px #000;
    -webkit-box-shadow:1px 2px 3px #000;
    box-shadow:1px 2px 3px #000;
    min-width:6.5em;
    z-index:10000; /* higher than the #loadingMask, but less than #pageMask */
}

.basicMenuOptions.alignRight{
    left:auto;
    right:-1px;
    -moz-border-radius:4px 0 4px 4px;
    -webkit-border-radius:4px 0 4px 4px;
    border-radius:4px 0 4px 4px;
}

.basicMenu.menuOpen {
    background-color:#FFF;
    border-color:#DADADA;
    border-bottom-width:0;
}

.menuOpen .basicMenuOptions{
    display:block;
}

.basicMenuOption {
    line-height:normal;
    list-style:none;
}

.basicMenuLink {
    font-weight:normal;
    height:2.75em;
    line-height:2.75em;
    white-space:nowrap;
    display:block;
    padding:0 1em;
    color:#333;
    font-size:.85em;
}

.basicMenuLink:visited {
    color:#333;
}

.basicMenuLink:hover {
    background-color:#1F9BDD;
    color:#FFF;
}

.menuOpen .basicMenuToggle,
.menuOpen .basicMenuToggle:hover {
    color:#333;
}

.basicMenuLink.logout {
    border-top:1px solid #DADADA;
    background-color:#F3F3F3;
}

.basicMenuLink.logout:hover {
    background-color:#F3F3F3;
    color:#1F9BDD;
}

.basicMenuLink.last {
    -moz-border-radius:0 0 4px 4px;
    -webkit-border-radius: 0 0 4px 4px;
    border-radius:0 0 4px 4px;
}

.basicMenuLink.linkDisabled,
.basicMenuLink.linkDisabled:hover,
.basicMenuLink.linkDisabled:active,
.basicMenuLink.linkDisabled:visited{
    cursor:default;
    background-color:#F8F8F8;
    color:#CCC;
}

/* end basic menu component styles */

/* user menu overrides */

.userMenu {
    width: 4em;
}

.userAvatar {
    margin:2px 5px;
    width:26px;
    height:26px;
    -moz-border-radius:3px;
    -webkit-border-radius:3px;
    border-radius:3px;
}

.userAvatar.chatterPage {
    vertical-align:top;
}

/* subnav menu overrides */

.chatterPage .basicMenuTitle {
    display:block; /* i have no idea why the menu on the chatter page doesn't behave like all the others */
}

/* Don't have any content in .toolbarHeader yet and with padding, it's too big
 * on mobiles. If we get content, re-evaluate using media queries.
 */
.toggleListBar,
.utilityBar,
.toolbarHeader {
    height: 100%;
}

.sidebarRegList a.uneditable,
.sidebarRegList a.editable,
.sidebarRegList a.current {
    display: block;
    height: 100%;
    width: 100%;
    padding: 1em;
    text-decoration: none;
}

#filtersSidebar {
    width: 18.750em;  /* 300px */
    height: 100%;
    position: absolute;
    background: #F0F2F3;
    right: 0;
    visibility: hidden;
}

#filtersSidebar.active {
    visibility: visible;
}

.filterListContainer {
    border-bottom: 1px solid #E0E3E5;
}

.filterHeader {
    display:block;
    padding: 0.875em 0.625em 0.875em 1em;
    font-weight: bold;
    font-size: 0.875em;
    color: #009DDC;
    cursor: pointer;
}

.filterHeader img {
    margin-right: 0.4em;
}

a:hover.filterHeaderOpen,
.filterHeaderOpen {
    color:#727272;
}

#filterScroller .filterSectionWrapper {
    width: 100%;
    padding:0 25px;
    display:none;
    overflow:hidden;
    height: auto;
}

.filterItem {
    padding: 0.2em;
}

.filterButton {
    vertical-align: middle;
    text-align: left;
    border:1px solid #DDDFE0;
    padding: 0.25em 0.5em;
    background: #F9F9F9;
    cursor: pointer;
    line-height: 1.125em;
}

.filterButton.activeFilter {
    background: #2C82B9;
}

/* this renders the filters inaccessible */
.filterButton input {
    display: none !important;
}

.activeFilter .filterLabel {
    color:#FFF;
}

.filterLabel {
    display: block;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    color: #727272;
    font-weight: bold;
    font-size: 0.75em;
}

.activityListScroller {
    background: #F9F9F9;
}

.activityList {
    background-color:#F9F9F9;
}

/* =========================================​====================================
    "Table-style" Lists
    =========================================​================================= */

.sectionMainHeading {
    margin: 1.1em 1em 0.5em 1em;
    color: #F38C26;
    font-size: 1.75em;
}

.sectionMainHeading .smallText {
    font-size: 0.5em;
    color: #727272;
}

.sectionSubHeading {
    margin: 0 1.95em;
    padding: 0.5em 0.8em;
    background-color: #2C82B9;
    border: 1px solid #EBEBEB;
    font-size: 0.813em;
    color: #FFF;
}

.listTableView {
    list-style: none;
    margin: 0 25px;
    padding: 0;
}

.listItem {
    position: relative;
    border: 1px solid #EBEBEB;
    border-top:none;
    background: #FFF;
}

.dealViewContent .listItem {
    padding: 2em 2.25em 0;
    border: none;
    background: none;
}

.listTableView :last-child.listItem {
    border-bottom: none;
}

.hourList:last-child .listItem:last-child {
    border-bottom: 1px solid #EBEBEB;
}

.listInfo,
.listHeading {
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
}

.listHeading {
    margin: 0 0 0.35em;
    font-size: 1em;
    font-weight:bold;
    -webkit-font-smoothing:antialiased;
}

.listInfo {
    color: #6A7274;
    margin: 0;
}

.listText {
    position: relative;
    z-index: 1;
    width: 100%;
}

.listText .listLink {
    padding: 1.3em 0 1.4em 1.5em;
}

.listItem .listLink,
.listItem .listDetailTitle {
    min-height: 3.5em;
    padding-right: 9.5em;
    display: block;
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
    color: #009DDC;
    text-decoration: none;
}

/* Let the activity titles wrap in detail view */
.listItem .listDetailTitle,
.listDetailTitle .listInfo,
.listDetailTitle .listHeading {
    text-overflow: inherit;
    overflow: visible;
    white-space: normal;
}

.listDetailTitle .listHeading {
    font-size: 1.85em;
    line-height: 1.2em;
    width: 90%;
}

.listDetailTitle .listInfo {
    font-weight: bold;
}

.listAction {
    position: absolute;
    top: 0;
    right: 0;
    width: 4.25em;
    height: 100%;
    margin: 0;
    padding: 0;
    z-index: 2;
    display: block;
    text-align: center;
    cursor: pointer;
    color: #000;
    text-decoration: none;
    background-color: transparent;
    background-repeat: no-repeat;
    background-position: 50% 50%;
}

.dealViewContent .listAction {
    height: 110px;
}

.listActionInner {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    min-width: 0.75em;
    max-width: 6.5em;
    display: block;
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
    zoom: 1;
}

.fullItem .actionAddRemove .listActionInner {
    position: absolute;
    z-index: 1;
    top: 50%;
    line-height: 1.5em;
    margin-top: -0.75em; /* Half line-height */
    width: 100%;
    height: auto;
}

.fullItem .actionAddRemove {
    cursor: default;
}

.listTableView .emptyResults {
    background: #fff;
    color: #ababab;
    font-size: 0.813em;
}

.removeConfirm .listAction,
.addConfirm .listAction {
    display: none;
}

.removeConfirm .actionAddRemove {
    display: block;
}

.removeConfirm .uiButton,
.removeConfirm .uiButton:hover {
    display: block;
    border: 1px solid #771717;background: #bf3737; /* Old browsers */
    background: -moz-linear-gradient(top,  #bf3737 0%, #b92323 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#bf3737), color-stop(100%,#b92323)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top,  #bf3737 0%,#b92323 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top,  #bf3737 0%,#b92323 100%); /* Opera 11.10+ */
    background: -ms-linear-gradient(top,  #bf3737 0%,#b92323 100%); /* IE10+ */
    background: linear-gradient(to bottom,  #bf3737 0%,#b92323 100%); /* W3C */
}

.iconClock {
    display:block;
    float:left;
    width:15px;
    height:14px;
    margin: .1em 0.5em 0 0.5em;
    background-image: url('media_image_icons_png8_iconClock');
}

.addItem .actionAddRemove {
    background-image: url('media_image_icons_png8_activityListAdd');
}

.removeItem .actionAddRemove {
    background-image: url('media_image_icons_png8_activityListRemove');
}

.removeItem .actionBookmark {
    display: none;
}

.bookmarkFilters,
.addBookmark .actionBookmark {
    background-image: url('media_image_icons_png8_activityListBookmark');
}

.bookmarkFilters.selected,
.removeBookmark .actionBookmark {
    background-image: url('media_image_icons_png8_activityListUnbookmark');
}

.addConfirm .actionAddRemove,
.removeConfirm .actionAddRemove {
    background: none;
    display: block;
}

.fullItem {
    border-right:1px solid #F9F9F9;
    border-left:1px solid #F9F9F9;
    background: #F9F9F9;
}

.fullItem .actionAddRemove {
    color: #c7c7c7;
    font-weight: bold;
}

.addConfirm,
.addConfirm .actionAddRemove,
.removeConfirm,
.removeConfirm .actionAddRemove {
    z-index: 9001;
}

.addConfirm .listActionInner,
.addConfirm .listActionInner:hover,
.removeConfirm .listActionInner,
.removeConfirm .listActionInner:hover {
    width: auto;
    height: auto;
    top: 50%;
    left: -0.5em;
    margin-top: -1.25em;
}

.removeConfirm .listActionInner,
.removeConfirm .listActionInner:hover {
    left: -6em;
}
/* =============================================================================
    List header "tab" links
    ========================================================================== */
.listTabs ul {
    background-color: #f8f8f8;
    padding-left: 1em;
}

.listTabItem a,
.listTabItem a:hover,
.listTabItem a:visited {
    width: 100%;
    height: 100%;
    cursor: pointer;
    color: #727272;
}

.listTabItem span {
    padding: 2em 0.5em 0;
    font-size: 0.85em;
    font-weight: bold;
}

.tabSelected span {
    padding-top: 0.7em;
    font-size: 1.75em;
    color: #f38c26;
    position: relative;
    top: -0.228em;		/* 5px @ 1.375em font */
}

.tabDayLong,
.tabDayShort {
    height: 100%;
    width: 100%;
}

.tabDayShort {
    display: none;
}

.tabDayLong {
    display: block;
}


/* W-1356320: Remove button on Details page covers text */
#activityList .listItem.removeConfirm .listText {
    width: 75%;
}

#detailView .listItem.removeConfirm .listText {
    width: 85%;
}