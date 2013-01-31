/**!
 * css_mediaquery.css
 *
 *
 */


body:after {
    content: 'large';
    display: none; /* comment this line for debugging purposes */
}

#mediaWidth,
#mediaDeviceWidth {
    height: 0;
    display: none;
    position: absolute;
    left: -999999em;
    z-index: -10;
    width: 64px;
}

/* Using ems for breakpoints. See http://blog.cloudfour.com/the-ems-have-it-proportional-media-queries-ftw/ */
@media only screen and (max-width: 63em) {  /* ~= 1008px  */
    body:after {
        content: 'medium';
    }

    #mediaWidth {
        width: 63px;
    }

    .sidebar {
        display: none;
        position: absolute;
        top: 0;
        left: 0;
        bottom: 0;
        height: auto;
        z-index: 10000;		/* Should be higher than details page: W-1337012 */
        -moz-box-shadow: 	1px 0 2px #000;
        -webkit-box-shadow: 1px 0 2px #000;
        box-shadow: 		1px 0 2px #000;
    }

    .showOnSideBarHide,
    .hideOnSideBarShow {
        display: block !important;
    }
    .showOnSideBarShow,
    .hideOnSideBarHide {
        display: none !important;
    }

    .toggleNavIcon {
        top: 0;
    }

    body.fullpageScroll .main {
        margin-left: 0;
    }

    .priorityCodeContainer input,
    .priorityCodeContainer input[type="text"] {
        width: 100%;
        margin-bottom: 0.5em;
        margin-right: 0;
    }
    .priorityCodeContainer {
        padding-top: 1em !important; /* Need !important to override .unit .fieldContainer in max-width 45em below */
    padding-left: 1.5em !important;
    }

    .expand {
        width: 100%;
    }
    .padPanelPage	{
        padding-left: 0.75em;
        padding-right: 0.75em;
    }

    .calendar .evt-detail {
        display: none;
    }

    .helpAction {
        width: 45%;
    }

}

@media only screen and (max-width: 45em) { 	/* ~= 720px */
    body:after {
        content: 'small';
    }

    #mediaWidth {
        width: 45px;
    }

    /* 2px allows outline to not be cutoff in Safari when input focused */
    .unit .fieldContainer {
        padding: 0 2px;
    }

    .stacked button,
    .stacked input,
    .stacked select,
    .stacked textarea {
        width: 100%;
    }

    .unit {
        float: none;
        width: 100%;
    }

    .landingPage .loginFormWrap,
    .panelPage .formWrap {
        width: 100%;
    }

    .padGrid {
        padding-right: 1.5em;
    }

    .padPanelPage {
        padding-left: 0.25em;
        padding-right: 0.25em;
    }

    .uiButton,
    .uiButton:hover {
        margin: 0.5em 0;
    }

    .panelHeaderSearchBar .uiButton,
    .panelHeaderSearchBar .uiButton:hover {
        margin: 0;
        min-width: 5em;
    }

    /* Need some kind of width in order for ellipsis to work */
    .panelHeaderBar h3 {
        max-width: 90%;
    }

    #filtersSidebar .uiButton {
        float: right;
        margin-left: 0.5em;
    }

    #filtersSidebar .uiButton.toggleFilters,
    #filtersSidebar .panelHeaderBar,
    #filtersSidebar .panelHeaderBar h3 {
        display: block;
        /* Create a height for scrollers */
        height: auto;
    }

    .panelHeaderBar .uiButton,
    .panelHeaderBar .uiButton:hover {
        margin: 0;
    }

    .panelHeaderBar .uiButton.toggleFilters {
        display: none;
    }
    .panelHeaderBar .iconButton.toggleFilters {
        display: block;
    }

    .masthead {
        background-position: 50% 0%;
    }

    .compact {
        display: block !important;	/* Needs !important to override non-media query !important */
    }

    span.compact {
        display: none !important;
    }

    .lineBreak {
        display: block;
    }
    /*
     * For text or other elements that are not important to be viewed on smaller screens.
     * This is technically a 'helper' class, but putting here to keep media queries together
     * at the end of the rules.
     */
    .unimportant {
        display: none;
    }

    .paginator {
        float: none;
    }
    #simplemodal-container h1 {
        margin: 0.25em 0;
        font-size: 0.9em;
    }
    #simplemodal-container p {
        font-size: 0.8em;
    }
    .accordionItem .description {
        margin-right: 0;
    }
    .accordionItem .unitRight {
        float: none;
        display: block;	/* Needed to make images drop to a new line too */
    }
    .listHeading {
        margin-bottom: 1em;
    }
    .listDetailTitle .listHeading {
        font-size: 1em;
    }
    .listDetailTitle .listInfo {
        font-weight: normal;
    }
    .listItem .listLink,
    .listItem .listDetailTitle {
        padding-right: 6.5em;
    }
    #activityList .listItem.removeConfirm .listText {
        width: 75%;
    }
    .listAction {
        width: 3em;
    }
    .listActionFirst {
        right: 0.313em;
    }
    .actionBookmark {
        right: 3.313em;
    }
    /* Make buttons a little smaller and adjust vertical align so
     * they don't overlap session title (on remove)
     */
    .listItem .uiButton,
    .listItem .uiButton:hover {
        margin-top: -1em;
        padding: 0.25em 0.5em;
    }
    .addConfirm .listActionInner,
    .addConfirm .listActionInner:hover {
        left: -0.813em;
    }
    .removeConfirm .listActionInner,
    .removeConfirm .listActionInner:hover {
        left: -5.5em;
    }
    #filtersSidebar {
        width: 100%;
    }

    /* All rows should equal (78% - (numItems * 2%)) / numItems
     * The 2% represents the left+right margins
     */
    .calendar .evt1 {
        width: 77.5%;	/* We need to subtract an extra 0.5% from this one. */
    }

    .calendar .evt2 {
        width: 38%;
    }

    .calendar .evt3 {
        width: 24.667%;
    }

    .calendar .evt4 {
        width: 18%;
    }

    .calendar .evt5 {
        width: 14%;
    }

    .calendar .evt6 {
        width: 11.667%;
    }

    ul.steps li {
        width: auto;
        padding-bottom: 2em;
    }

    ul.steps li.notFirst {
        border-top: 1px solid #ececec;
        border-left: none;
    }

    ul.steps span.info {
        margin-top: 1em;
    }

    .bigButton {
        width: 90%;
    }

    .helpAction {
        width: 99%;
    }

    .helpActionTitle {
        margin-top: 0.8em;
    }

    .logo {
        display:none;
    }

}

@media only screen and (max-device-width: 45em) { 	/* ~= 720px */
    #mediaDeviceWidth {
        width: 45px;
    }
}

@media only screen and (max-device-width: 30em) {   /* ~= 720px */
    #mediaDeviceWidth {
        width: 30px;
    }
}

@media only screen and (max-width: 30em) { /* ~= 480px */
    body:after {
        content: 'smaller';
    }

    #mediaWidth {
        width: 30px;
    }

    span.compact {
        display: inline !important;
    }

    #detailView {
        left: 0;
        width: 100%;
    }

    .tabDayShort {
        display: block;
    }

    .tabDayLong {
        display: none;
    }

    .listTableView {
        margin: 0 0.625em; 	/* 10px*/
    }

    .sectionSubHeading {
        margin: 0 0.77em; 	/* 10px @ 0.813em font-size */
    }

    .iconClock {
        margin-left: 0;
    }

    .listText .listLink {
        padding-top: 0.625em;
        padding-bottom: 0.625em;
        padding-left: 0.625em;
        /* padding-right already defined above */
    }

    .listTabs ul {
        padding-left: 0.625em;
        background-color: #fff;
        border-bottom: 1px solid #AFAFAF;
    }

    /* Adding class to id just to make it more apparent that it is related to the above selector */
    #listTabsFooter.listTabs ul {
        border-top: 1px solid #AFAFAF;
        border-bottom: 1px solid #E7E7E7;
    }

    .listTabItem span {
        padding: 0.75em 1.25em;
        font-size: 1em;
        font-weight: bold;
    }

    .tabSelected span {
        padding-top: 0.75em;
        font-size: 1em;
        background-color: #f8f8f8;
        color: #4e4e4f;
        position: static;
        border-bottom: 2px solid #f38c26;
    }

    #listTabsFooter.listTabs .tabSelected span {
        border-top: 2px solid #f38c26;
        border-bottom: none;
    }

    .chunkDaysHasTabs {
        padding-top: 0.625em;
        border-top: 3px solid #f0f0f0;
        padding-bottom: 0.625em;
        border-bottom: 3px solid #f0f0f0;
    }

    .dealViewContent .listItem {
        padding: 1em 1.25em 0;
    }

    #detailViewContent .padGridEqSidesXtra {
        padding-left: 1.25em;
        padding-right: 1.25em;
        /* For some reason we need this to get padding to trigger */
        margin-right: 0.1em;
    }

    .dealViewContent .whiteAccordion .accordionHeader h4,
    .dealViewContent .whiteAccordion .accordionHeader.open h4 {
        background-position: 1.5em 1.15em;
    }

    .dealViewContent .whiteAccordion .accordionHeader h4 {
        padding-left: 3em;
    }

    .tagsTable {
        margin-left: 1.75em;
        margin-right: 1.75em;
    }

    .listInfo span.lineBreak,
    .listItem.removeConfirm .listDetailTitle,
    .removeConfirm .listDetailTitle .listInfo,
    .removeConfirm .listDetailTitle .listHeading {
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
        /* Need a width */
        max-width: 100%;
    }

    .calendar .timecol {
        padding-left: 0.625em;
    }

    .calendar .sectionMainHeading {
        margin-left: 0.77em;
    }
}

@media only screen and (-webkit-min-device-pixel-ratio: 1.5),
only screen and (min--moz-device-pixel-ratio: 1.5),
only screen and (min-resolution: 240dpi) {
    /* Make icons sharper on high res devices. */
    .addItem .actionAddRemove,
    .removeItem .actionAddRemove  {
        -moz-background-size: 32px 32px;
        -o-background-size: 32px 32px;
        -webkit-background-size: 32px 32px;
        background-size: 32px 32px;
    }
    .bookmarkFilters,
    .addBookmark .actionBookmark,
    .removeBookmark .actionBookmark  {
        -webkit-background-size: 20px 20px;
           -moz-background-size: 20px 20px;
             -o-background-size: 20px 20px;
                background-size: 20px 20px;
    }
    #printButton,
    #calendarSync,
    .listItem .saving {
        -moz-background-size: 24px 24px;
        -o-background-size: 24px 24px;
        -webkit-background-size: 24px 24px;
        background-size: 24px 24px;
    }
    #qrReader {
        -webkit-background-size: 18px 19px;
           -moz-background-size: 18px 19px;
             -o-background-size: 18px 19px;
                background-size: 18px 19px;
    }

    .uibutton.close {
        -webkit-background-size: 17px 17px;
           -moz-background-size: 17px 17px;
             -o-background-size: 17px 17px;
                background-size: 17px 17px;
    }

    .iconClock {
        -webkit-background-size: 15px 14px;
           -moz-background-size: 15px 14px;
             -o-background-size: 15px 14px;
                background-size: 15px 14px;
    }

    .whiteAccordion .accordionHeader h4 {
        -webkit-background-size: 11px 11px;
           -moz-background-size: 11px 11px;
             -o-background-size: 11px 11px;
                background-size: 11px 11px;
    }

    .whiteAccordion .accordionHeader.open h4 {
        -webkit-background-size: 11px 11px;
           -moz-background-size: 11px 11px;
             -o-background-size: 11px 11px;
                background-size: 11px 11px;
    }

    /** http://www.motobit.com/util/base64-decoder-encoder.asp **/

    .addItem .actionAddRemove {
        background-image: url('media_image_icons_png8_activityListAddHighRes');
    }

    .removeItem .actionAddRemove {
        background-image: url('media_image_icons_png8_activityListRemoveHighRes');
    }

    .bookmarkFilters,
    .addBookmark .actionBookmark {
        background-image: url('media_image_icons_png8_activityListBookmarkHighRes');
    }

    .bookmarkFilters.selected,
    .removeBookmark .actionBookmark {
        background-image: url('media_image_icons_png8_activityListUnbookmarkHighRes');
    }

    #pullDown .pullDownIcon {
        /* Original image: media_image_icons_png8_pullToRefreshHighRes */
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE4AAABPBAMAAAC32O6LAAAALVBMVEX////39/fz8/Pv7+/q6urm5ubi4uLe3t7a2trW1tbS0tLOzs7KysrFxcX7+/uVY02PAAAAAXRSTlMAQObYZgAAANNJREFUeF7t1cEJwkAQheGXGCEidqBgAwFLsAEhF48LKcUGAjYg2IBgAynBHCIaJC6kFFHB4M5sZk+CsN9x+E/vMnDgTfRH9cvO7yJ3/7KL73znu8H6SXVd/TosYQg1awGT4rIaxIjr9qAKmt1bUAntzmAMaZeBszOzG1hjsyvBCsXx+AmvsIi/uy1sCjIeL2HGEyfMYJeT8cQJS/QIum6OPoqMx4uN8aQJm1boZo5fMHp3KSQ5Hc8+4RGi4ETG4620voBgJ9zAxaGBk2kFJ1EKV94DPOQ0rOm8ijYAAAAASUVORK5CYII=);
    }

    #pullDown.noRotate.flip .pullDownIcon {
        /* Original image: media_image_icons_png8_pullToRefreshReleaseHighRes */
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE4AAABPBAMAAAC32O6LAAAALVBMVEX////39/fz8/Pv7+/q6urm5ubi4uLe3t7a2trW1tbS0tLOzs7KysrFxcX7+/uVY02PAAAAAXRSTlMAQObYZgAAANFJREFUeF7t07EJwkAYxXExqARBHCELOIJgYx/QYOUI7uACggsILiBkAQsHsFAUlPgm0CE0HgdHksv7Kgv5Xv2r/vAa8ummMtZ89EWui63IrXCTsBaAkcANABwEbg8g4yxEviV186+70HgwYwmfMEuJ2xjGErZhF5N4dqc61jvCLuPxQBMuHHf1swDuIq97wV3K4tmEJB5NOCy4M4lHEoYobl0XjyUMUF7kj0cT7ircvcw6qFrsi0cTjpPPZg5J8k38b7MzQJ06db/Y33XRfna6Nw1cNKw4zacSAAAAAElFTkSuQmCC);
    }

    .panelHeaderSearchBar .refreshButton {
        background-image: url('media_image_icons_png8_refreshHighRes');
    }

    #printButton {
        background-image: url('media_image_icons_png8_printButtonHighRes');
    }

    #qrReader {
        background-image: url('media_image_icons_png8_qrHighRes');
    }

    .iconButton.toggleFilters .toggleFiltersIcon {
        background-image: url('media_image_icons_png_toggleFiltersHighRes');
    }

    .uibutton.close {
        background-image: url('media_image_icons_png8_closeXHiRes');
    }

    .iconClock {
        background-image: url('media_image_icons_png8_iconClockHiRes');
    }

    .whiteAccordion .accordionHeader h4 {
        background-image: url('media_image_icons_png8_accordionArrowRightHiRes');
    }

    .whiteAccordion .accordionHeader.open h4 {
        background-image: url('media_image_icons_png8_accordionArrowDownHiRes');
    }

    .panelHeaderBar .refreshButton,
    .panelHeaderBar .refreshButton:hover,
    .panelHeaderBar .refreshButton:visited {
        -webkit-background-size: 28px 25px;
           -moz-background-size: 28px 25px;
             -o-background-size: 28px 25px;
                background-size: 28px 25px;
        background-image: url('media_image_icons_png8_refreshHighRes');
    }
}

/* iPhone retina display only */
@media only screen and (-webkit-min-device-pixel-ratio: 1.5) and (max-width: 45em) {

    .appNavItem {
        width: 7.42em;
    }

}
