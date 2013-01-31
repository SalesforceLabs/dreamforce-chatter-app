/**!
 * css_ie
 *
 * IE only stylesheet...you stink
 *
 */
/*
.ie6 .main,
.ie7 .main,
.ie8 .main {
    overflow: auto;
    background-color: #fff;
}
*/

/* css_forms */
.ieLt8 body div.textField input,
.ieLt8 body div.selectField select {
    color: #2A2A2A;
}

.ie7 body .checkboxField .checkbox {
    width: auto;
    max-width: 1em;
}

/* css_themes_default */
.ieLt8 body input,
.ieLt8 body select,
.ieLt8 body textarea,
.ieLt8 body textarea.input {
    padding: 0.25em !important;
    height: auto !important;
}

/* css_panelPageContent */
.ieLt8 body .landingPage .loginForm select {
    width: 100%;
}

/* css_layout */
.ieLt8 body .uiScroller {
    position: static;
}


/* Fixed height pages  */
.ieLt8 .fixedHeightPage .main,
.ieLt8 .fixedHeightPage .content,
.ieLt8 .fixedHeightPage #panels,
.ieLt8 .fixedHeightPage #filtersSidebar {
    height: 700px;
}
.ieLt8 .fixedHeightPage #panelScroller,
.ieLt8 .fixedHeightPage #filterScroller {
    position: absolute;
    bottom: 0 !important; 	/* Need to override JS, but only in these cases */
}
.ieLt8 .fixedHeightPage .listItem {
    cursor: pointer;
}

.panels form {
    min-height: 40em; /* ~= 650px */
}

.feed-component-container form {
    min-height: 0;
}

.feed-list .feed-item h2 {
    display: inline !important;
}

.ie6 .sidebar {
    left: -20em;
}

.ie7 .loginForm {
    position: relative;
}

/* Box-shadow not looking good in older IEs, so just completely cover the list */
.ieLt9 #detailView {
    width: 100%;
    left: 0;
}

#detailViewContent {
    height: 100%;
    filter: alpha(opacity = 0)\9;
    zoom: 1\9;
}

.ie7 .filterItem {
    padding: 0.2em 0;
    width: 49.9%;
}

.ie7 .filterButton {
    height: 100%;
}

.ie7 .filterLabel {
    display: block;
    margin-top: 1em;
}

.ieLt8 #calendarContainer {
    min-width: 650px;
}

.ieLt8 .calendar .day {
    width: 90%;
}

/* This layout is working fine on IE7 just need to make the columns more narrow */
.ieLt9 .ieFixed{
    min-width: 650px;
}

.ieLt9 .wrapper {
    min-width: 1024px;
}

.ie8 .toggleNav {
    white-space:nowrap;
    overflow:visible;
}

.ie8 .toggleNavCurrentSelection {
    float:none;
}

.ie7 .toggleNav {
    position:relative;
}

.ie7 .toggleNavCurrentSelection {
    white-space:nowrap;
    position:absolute;
}

.ie7 .appBody {
    background-color: #3F484F;
}

.ie7 .size1of4 {
    width: 23%;
}

.ie7 .steps li {
    width:29%;
}

.ie7 .brnzSponsors {
    float: left;
    width: 200px;
}

.ie7 .bigButton {
    width: 300px;
}

.ie7 .toolbarButton {
    outline:none;
}

.ie7 .basicMenuImage {
    margin-top:-.75em;
}

/* the normal nav toggle icon doesn't display properly in IE7.
 * no matter what i try, it will not size the image properly
 * and i have absolutely no clue why ... here is my awful, awful
 * attempt at hacking a solution together
 */

.ie7 .toolbarButton .toggleNavIcon {
    display:none;
}

.ie7 #ie7ToggleNavIcon {
    float:none;
    display:inline;
    zoom:1;
}
