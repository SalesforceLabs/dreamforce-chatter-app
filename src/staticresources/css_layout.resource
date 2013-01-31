/**!
 * css_layout.css
 *
 *
 */

h1,
h2,
h3,
h4,
h5,
h6,
p {
    margin-top: 0;
}



.header {
    position: relative;
    width: 100%;
    visibility: hidden;
}


.wrapper {
    position: absolute;
    /*top: 6.25em;		/* Same height as .masthead */
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 0;
    /* Don't use translate3d on elements containing form inputs (Android 2.x).
     * https://github.com/jquery/jquery-mobile/issues/search?utf8=✓&q=292
     * http://bit.ly/m7aNev
     */
/*	-moz-transform: 	translate(0, 4.625em); /* 74px */
/*	-webkit-transform: 	translate(0, 4.625em);
    -o-transform: 		translate(0, 4.625em);
    -ms-transform: 		translate(0, 4.625em);
    -moz-transition: 	-webkit-transform .3s ease-in;
    -webkit-transition: -webkit-transform .3s ease-in;
    -o-transition: 		-webkit-transform .3s ease-in;
    -ms-transition: 	-webkit-transform .3s ease-in;*/
}


.appBody,
.appBody > div {
    height: 100%;
}

.sidebar {
    width: 18em;
    max-width: 288px;   /* Keep it a reasonable size */
    height: 100%;
    /*margin-right: -12px; */
    position: relative;
    opacity: 1;
}


.content {
    height: 100%;
}

.panelHeaderBar,
.panelHeaderSearchBar {
    padding: 0.5em 1em 0.5em 1.5em;
}

.panelHeaderBar,
.panelHeaderSearchBar {
    height: 3.375em;
}

.panelHeaderBar .uiButton,
.panelHeaderBar .iconButton {
    margin-left: 1em;
}

.panelHeaderBar .iconButton {
    margin-top: 0.188em;
}

.filterAppliedLabel {
    position: absolute;
    top: 0.385em;
    right:10px;
    height:20px;
    border:2px solid #FFF;
    padding:0 4px;
    color:#FFF;
    text-align:center;
    line-height:1.3em;
    font-size: 0.8em;
    background-color:#F38C26;
    z-index:100;
    -moz-border-radius: 10px;
    -webkit-border-radius: 10px;
    border-radius:10px;
    -moz-box-shadow: 0 1px 5px rgba(0, 0, 0, 0.8);
    -webkit-box-shadow: 0 1px 5px rgba(0, 0, 0, 0.8);
    box-shadow: 0 1px 5px rgba(0, 0, 0, 0.8);
}

.hasPullToRefresh #refreshButton {
    display: none;
}

.hasPullToRefresh #filterAppliedLabel {
    margin-left: 0;
}


#filtersSidebar .panelHeaderBar {
    display: none;
    /* Make scroller JS use height value */
    height: 0;
}

/*
 *  Layout Block
 *  This handy component is based on Nicole Sullivan's media object (see .media below)
 *  http://www.stubbornella.org/content/2010/06/25/the-media-object-saves-hundreds-of-lines-of-code/
 */

.uiBlock,
.uiBlock .bBody {
    overflow: hidden;
    vertical-align: top;
    *overflow:visible;zoom:1;
}
.uiBlock .bLeft {
    float: left;
}
.uiBlock .bLeft img {
    display: block;
}
.uiBlock .bRight {
    float: right;
}


/* Not needed yet
.mobileTaskItem div.uiBlock {
    width: 100%;
}*/


/*
 * https://github.com/stubbornella/oocss/tree/master/core/media
 */

.media,
.media .bd {
    overflow: hidden;
    *overflow: visible;
    zoom:1;
}
.media .img {
    float: left;
    margin-right: 0.625em; /* 10px */
}
.media .img img {
    display: block;
}
.media .imgExt {
    float: right;
    margin-left: 0.625em; /* 10px */
}




/* =============================================================================
   Modals, dialogs, masks
   ========================================================================== */
/*
.modal {
    position: absolute;
    top: 10em;
    left: 0;
}*/

#modalContent {
    /* Don't need to display: none since the wrapper is already in that state */
    padding: 1em;
    width: 80%;
    max-width: 50em;
    text-align: left;
    margin: 0 auto;
}

.buttonContainer {
    width:100%;
    text-align:center;
    position: absolute;
    bottom: 0;
    left: 0;
}
#tosContent .buttonContainer {
    bottom: 0.5em;
    *bottom: 1em;
}


/* =============================================================================
   App page elements
   ========================================================================== */



tabSet.sidebarTabs { /* Was named mobileTabSet */
    padding: 0;
}


.sidebarTabs {
    font-size: 1em;
    font-weight: bold;
    padding: 1.25em 0.625em 1.25em 1em;
    background: -webkit-gradient(linear, left bottom, left top, color-stop(1, transparent), color-stop(0, rgba(0, 0, 0, .8)));
}


.panels {
    position: relative;
}


/* explicit margin-right 0 to make the filter section animation */
.ieLt9 #panels {
    margin-right: 0;
}


.stackItem {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 2;
    overflow: hidden;
}


/* For fixed header bars above .uiScollers, making it higher z-index than .uiScrollers */
.fixedBar {
    position: relative;
    z-index: 10;
}


.uiScroller, .uiScrollable {
    position: absolute;
    z-index: 1;
    width: 100%;
}

/*
 * Mitigates mousewheel scrolling issues when content does not fill panel area.
 * But, setting it higher than this causes the scrollbar to always show.
 */
#panelScroller > .uiScrollable {
    min-height: 85%;
}

.uiScroller {
    top: 0;
    left: 0;
    bottom: 0px;
}

body.fullpageScroll {
    overflow: visible;
}
body.fullpageScroll .wrapper,
body.fullpageScroll .main {
    overflow: visible !important;
    height: auto;
    min-height: 100%;
}

body.fullpageScroll .main {
    margin-left: 18em;
}

body.fullpageScroll #panelScroller .lastUnit {
    margin-bottom: 5em;
}

body.fullpageScroll .uiScroller {
    position: static;
}

body.fullpageScroll .sidebar {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
}

body.fullpageScroll .appBody,
body.fullpageScroll .appBody > div {
    height: auto;
    min-height: 100%;
}

/****** Activity Details Page ******/
#detailView {
    position: absolute;
    top: 0;
    left: 5.5%;
    height: 100%;
    width: 94.5%;
    z-index: 9999;
    /*display: none;*/
    -moz-box-shadow:    -1px 0 10px #000;
    -webkit-box-shadow: -1px 0 10px #000;
    box-shadow:         -1px 0 10px #000;
}

#detailViewContent {
    opacity: 0;
}

#activityDescription {
    min-height: 4em;
}

#contentSections {
    position: relative;
    min-height: 8em;
}

.detailsSection {
    border-bottom: 1px solid #D5D5D5;
}

.detailsAccordionSection.padGrid {
    padding-top: 0;
}

.tagsTable {
    margin: 0.75em 2.25em 0;
}

.tagsTable th,
.tagsTable td {
    font-size: 0.813em;
    vertical-align: top;
}

.tagsTable th {
    text-align: left;
    padding: 1.5em 1em 0 0;
}

.tagsTable td {
    padding-top: 1em;
}

.chatterSection img,
.chatterSection .img {
    height: 28px;
    width: 28px;
}
/****** End Activity Details Page ******/


/* =============================================================================
   Forms
   ========================================================================== */

/* See css_forms */


/* =============================================================================
   Help
   ========================================================================== */

.helpActions {
    max-width: 65em;
    overflow: hidden;
}

.helpAction {
    width: 45%;
    height: 6.5em;
    margin: 1%;
    padding: 1% 2%;
    float: left;
}

.helpAction img {
    float: left;
    width: 3em;
    height: 3em;
    margin: 1em 0.5em;
}

.helpActionTitle {
    display: block;
    margin-top: 0.3em;
}

.helpActionLink {
    display: block;
    margin-top: 0.5em;
}
