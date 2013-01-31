/**!
 * css_buttons.css
 *
 *
 */


.osButton {
    display: inline-block;
    *display: inline;
    *zoom: 1;
    cursor: pointer;
}


.osButton .label {
    white-space: nowrap;
}


.osButton.styled {
    margin: 2px;
    padding: 4px 6px;
    text-decoration: none;
    text-align: center;
}


.osButton.styled .label {
    white-space: nowrap;
    padding: 0 1px;
}

.uiButton {
    cursor: pointer;
    text-decoration: none;
    line-height: 1.5em;
    font-size: 1em;
    text-align: center;
    padding: 0.313em 0.75em;	/* 5px 12px */
    -moz-border-radius: 	2px;
    -webkit-border-radius: 	2px;
    border-radius: 			2px;
    background-image: none;
    width: auto;
    min-width: 6em;
    background-clip: padding-box;
    position: relative;
    display: inline-block;
    *display: inline;
    *zoom: 1;
}


.iconButton,
.iconButton:hover,
.iconButton:visited {
    display: block;
    float: left;
    cursor: pointer;
    height: 34px;
    min-width: 2.25em;
    width: 2.25em;
    background-position: 50% 50%;
    background-repeat: no-repeat;
}

.uiButton.tag,
.uiButton.tag:hover {
    -moz-border-radius: 	10px;
    -webkit-border-radius: 	10px;
    border-radius: 			10px;
    float: left;
    margin: 0.5em 0.5em 0 0;
    font-weight: normal;
    cursor: default;
}

#filtersSidebar .uiButton.toggleFilters {
    display: none;
    float: left;
    margin: 0;
}

/* Hide icon on large form factors by default */
.panelHeaderBar .iconButton.toggleFilters {
    display: none;
}

.iconButton.toggleFilters,
.iconButton.toggleFilters:hover,
.iconButton.toggleFilters:visited {
    -webkit-border-radius:	2px;
       -moz-border-radius:	2px;
            border-radius:	2px;
}

.iconButton.toggleFilters .toggleFiltersIcon {
    display: block;
    height: 100%;
    width: 100%;
}

.bigButton {
    background: #fff;
    border: 1px solid #ebebeb;
    padding: 2em;
    cursor: pointer;
}

.bigButton h4 {
    margin: 0.13em 0;
}
