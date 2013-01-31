/**!
 * css_helpers.css
 *
 *
 */


/* =============================================================================
   Positioning and Display
   ========================================================================== */

.center {
    margin: 0 auto;
}
.relative {
    position: relative;
}
.absolute {
    position: absolute;
}
.zeroPos {
    position: absolute;
    top: 0;
    left: 0;
}
.flush {
    margin: 0;
    padding: 0;
}
.inlineBlock {
    display: inline-block;
    *display: inline;
    *zoom: 1;
}
.block {
    display: block;
}
/* Meant to help vertical align of text in rows that also have form elements like <select> */
.inputRowAlign {
    line-height: 2.25em;
}
/*
 * For page elements that get shown in a 'compacted' state like on mobile.
 * Need to use important to make sure it wins specificity wars for things
 * like '.horizontal li', etc.
 */
.compact {
    display: none !important;
}
.truncate {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.showOnSideBarHide,
.hideOnSideBarShow {
      display: none !important;
}
.showOnSideBarShow,
.hideOnSideBarHide {
      display: block !important;
}
.stackBottom {
    z-index: -2;
}
.stackTop {
    z-index: 2;
}
.stackResetZ {
    z-index: 0;
}


/* Paddings */
.line.grid			{ padding: 0 1.5em; }
.padGrid 			{ padding: 0.75em 0.5em 0 1.5em; }
.padGridEqSides		{ padding: 0.75em 1.5em 0; }
.padGridEqSidesXtra { padding: 0.75em 2.25em 0; }
.padGrid.lastUnit 	{ padding-right: 1.5em; }
.padHalf   			{ padding: 0.5em; }
.padHalfVert   		{ padding: 0.5em 0; }
.padHalfSides   	{ padding: 0 0.5em; }
.padHalfTop   		{ padding-top: 0.5em; }
.padHalfRight   	{ padding-right: 0.5em; }
.padHalfBottom   	{ padding-bottom: 0.5em; }
.padHalfLeft    	{ padding-left: 0.5em; }
.pad1emVert   		{ padding: 1em 0; }
.pad1emSides   		{ padding: 0 1em; }
.pad2em 			{ padding: 2em; }
.pad1emTop          { padding-top: 1em; }
.pad2emTop          { padding-top: 2em; }
.pad1emRight        { padding-right: 1em; }
.pad2emRight        { padding-right: 2em; }
.pad1emBottom       { padding-bottom: 1em; }
.pad2emBottom       { padding-bottom: 2em; }
.pad1emLeft         { padding-left: 1em; }
.pad2emLeft         { padding-left: 2em; }
.pad1em 			{ padding: 1em; }
.padPanelPage		{ padding: 1.5em; }
.doubleBorderProgress {
    height:3px;
    display:block;
    position:relative;
    top:-3px;
    margin-left: 24px;
    background-color: #32B3DD;
}


/* Margins */
.marginHalf   		{ margin: 0.5em; }
.marginHalfVert   	{ margin: 0.5em 0; }
.marginHalfSides    { margin: 0 0.5em; }
.marginHalfTop    	{ margin-top: 0.5em; }
.marginHalfRight    { margin-right: 0.5em; }
.marginHalfBottom   { margin-bottom: 0.5em; }
.marginHalfLeft    	{ margin-left: 0.5em; }
.margin1emVert   	{ margin: 1em 0; }
.margin1emSides   	{ margin: 0 1em; }
.margin1em 			{ margin: 1em; }
.margin1emTop 		{ margin-top: 1em; }
.margin1emRight		{ margin-right: 1em; }
.margin1emBottom	{ margin-bottom: 1em; }
.margin1emLeft		{ margin-left: 1em; }
.margin2em 			{ margin: 2em; }
.margin2emTop 		{ margin-top: 2em; }
.margin2emRight		{ margin-right: 2em; }
.margin2emBottom	{ margin-bottom: 2em; }
.margin2emLeft		{ margin-left: 2em; }
.margin3em          { margin: 3em; }
.margin3emTop       { margin-top: 3em; }
.margin3emRight     { margin-right: 3em; }
.margin3emBottom    { margin-bottom: 3em; }
.margin3emLeft      { margin-left: 3em; }
.margin8emTop       { margin-top: 8em; }
.margin8emBottom    { margin-bottom: 8em; }
.marginNoneTop    	{ margin-top: 0; }
.marginNoneRight  	{ margin-right: 0; }
.marginNoneBottom  	{ margin-bottom: 0; }
.marginNoneLeft  	{ margin-left: 0; }


.floatRight 		{ float: right; }

.floatLeft	 		{ float: left; }

/* =============================================================================
   Widths
   ========================================================================== */

.width100 {
    width: 100%;
}
.width90 {
    width: 90%;
}
.width80 {
    width: 80%;
}
.width60 {
    width: 60%;
}
.width50 {
    width: 50%;
}
.width30 {
    width: 30%;
}
.width20 {
    width: 20%;
}
.width10 {
    width: 10%;
}


/* =============================================================================
   Text
   ========================================================================== */
.center-text {
    text-align: center;
}
.textRight {
    text-align: right;
}
.upper {
    text-transform: uppercase;
}
.noTransform {
    text-transform: none;
}

.fontSize1em {
    font-size: 1em;
}

.fontExtraSmall {
    font-size: 0.687em; /* 11px */
}

.fontSizeSmall {
    font-size: 0.813em;
}
.fontSizeBig {
    font-size: 0.875em; /* 14px */
}
.fontSizeBigger {
    font-size: 0.938em; /* 15px */
}

.normal {
    font-weight: normal;
}


/* =============================================================================
   Borders
   ========================================================================== */

.border {
    border: 1px solid #c0c0c0;
}

.borderBottom {
    border-bottom: 1px solid #c0c0c0;
}

.borderRight {
    border-right: 1px solid #c0c0c0;
}

.boxRound {
    -moz-border-radius: 	0.75em;
    -webkit-border-radius: 	0.75em;
    border-radius: 			0.75em;
    /*
     * Prevent bg color from leaking outside the border:
     * http://tumble.sneak.co.nz/post/928998513/fixing-the-background-bleed
     */
    -moz-background-clip: padding; -webkit-background-clip: padding-box; background-clip: padding-box;
}

.headingBorder {
    color: #2a2a2a;
}

.headingBorder h4 {
    font-size: 2em;
    padding-left: 0.8em;
    margin-bottom: 0.8em;
}

.doubleBorder {
    border-bottom: 3px double #dee2e4;
}

.doubleBorderThick {
    border-bottom: 4px double #aaa;
}

.doubleBorderProgress,
.doubleBorderProgressFlush {
    height:3px;
    display:block;
    position:relative;
    top:-3px;
    margin-left: 24px;
    background-color: #32B3DD;
}

.doubleBorderProgressFlush {
    margin-left: 0;
}

.hr {
    display: block;
    border-bottom: 1px solid #ccc;
    height: 1em;
    margin-bottom: 0.5em;
}

/* =============================================================================
   Opacity
   ========================================================================== */

.opacity0 {
    opacity: 0;
    /* IE lte 8 */
    filter: alpha(opacity = 0)\9;
    zoom: 1\9;
}
.opacity30 {
    opacity: 0.3;
    filter: alpha(opacity = 30)\9;
    zoom: 1\9;
}
.opacity50 {
    opacity: 0.5;
    filter: alpha(opacity = 50)\9;
    zoom: 1\9;
}
.opacity100 {
    opacity: 1;
    filter: alpha(opacity = 100)\9;
    zoom: 1\9;
}



/* =============================================================================
   Misc
   ========================================================================== */


/*
 * prevent callout
 */

.nocallout {
    -webkit-touch-callout: none;
}


/*
 * A hack for HTML5 contenteditable attribute on mobile
 */

textarea[contenteditable] {
    -webkit-appearance: none;
}


/*
 * A workaround for S60 3.x and 5.0 devices which do not hide animated gif images
 * if they have been set as display: none
 */

.gifhidden {
    position: absolute;
    left: -100%;
}


/*
 * For image replacement
 */
.ir {
    display: block;
    border: 0;
    text-indent: -999em;
    overflow: hidden;
    background-color: transparent;
    background-repeat: no-repeat;
    text-align: left;
    direction: ltr;
}

.ir br {
    display: none;
}


/*
 * Hide from both screenreaders and browsers: h5bp.com/u
 */

.hidden {
    display: none !important;
    visibility: hidden;
}


/*
 * Hide from both screenreaders and browsers, and also zero height to avoid issues in pg (Phonegap)
 */
.phonegapHidden {
    display: none !important;
    visibility: hidden;
    height: 0;
    padding: 0;
    margin: 0;
    border: 0 !important;
}

.hide {
    display: none;
}

/*
 * Hide only visually, but have it available for screenreaders: h5bp.com/v
 */

.visuallyhidden {
    border: 0;
    clip: rect(0 0 0 0);
    height: 1px;
    margin: -1px;
    overflow: hidden;
    padding: 0;
    position: absolute;
    width: 1px;
}


/*
 * Extends the .visuallyhidden class to allow the element to be focusable when
 * navigated to via the keyboard: h5bp.com/p
 */

.visuallyhidden.focusable:active,
.visuallyhidden.focusable:focus {
    clip: auto;
    height: auto;
    margin: 0;
    overflow: visible;
    position: static;
    width: auto;
}


/*
 * Hide visually and from screenreaders, but maintain layout
 */

.invisible {
    visibility: hidden;
}


/*
 * Contain floats: h5bp.com/q
 */

.clearfix:before,
.clearfix:after {
    content: "";
    display: table;
}

.clearfix:after {
    clear: both;
}

.clearfix {
    *zoom: 1;
}

.clear {
    clear: both;
}

.bold {
    font-weight: bold;
}

.clearList {
    height: 100%;
    list-style: none;
    margin: 0;
    padding: 0;
}

.overflowHidden {
    overflow :hidden;
}

.fullWidth {
    width: 100%;
}
