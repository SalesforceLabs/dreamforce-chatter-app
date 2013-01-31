/**!
 * css_forms
 *
 * Styles for form layout and elements.
 *
 * See also css_themes_default for colors, borders, etc
 *
 */

form {
    width: 100%;
}

.fieldContainer,
.flush .fieldContainer {
    position: relative;
    padding: 0 2px; /* 2px allows outline to not be cutoff in Safari when input focused */
    /*height: 4em;*/
    margin-bottom: 0.25em;  /* 4px */
}


.fieldContainer .bRight {
    width: 2em;
}

/* Stack form elements */
.stacked label,
.stacked input,
.stacked select,
.stacked textarea {
    display: block;
}

/* For use with forms that have complicated "rows" */
/*.bBody > input,
.bBody > select,
.bBody > textarea {
    width: 100%;
}*/

.errorText {
    visibility: hidden;                     /* Make the text take up space so the UI doesn't need to shift to show it */
    /*display: none;*/
    font-size: 0.8em;
}

/* Validation has found an error, show the error text */
.error .errorText {
    visibility: visible;
    /*display: block;*/
}

.message .messageText {
    font-weight: bold;
}

/* Complex form floated img when the input uses a label above the field */
.fieldContainer .withLabel {
    display: block;
    margin-top: 1.4em;                      /* For links, etc */
}
.fieldContainer img.withLabel {
    margin-top: 1.05em;                     /* Needs to be same height as label line-height */
}


/* Use for radios/checkboxes etc. */
.inlineLabel {
    padding-bottom: 3em;
}

.fieldContainer label,
.fieldContainer .errorText {
    /*padding-left: 0.625em;                /* 10px - Make text line up vertically with input field values */
    padding: 0 0.2em;
}

.dateField {
    position: relative;
}

.dateField input[type="text"] {
    width: 8em;
}

.textField {
    position: relative;
}


.textField input[type="text"],
.textField input[type="password"],
.textField input[type="email"] {
    padding-right: 2em;                     /* Give space for validation visual indicator */
}

.textField input,
.selectField select {
    color: inherit;
}

.checkboxField input[type="checkbox"],
.radioField input[type="radio"],
.checkboxField .checkbox,
.radioField .radio,
.horizontalRadio input[type="radio"] {
    position: absolute;
    top: 0.625em;   /* 10px */
    left: 0.375em;  /* 6px */
}

.checkboxField input[type="checkbox"],
.radioField input[type="radio"],
.checkboxField .checkbox,
.radioField .radio {
    width: 1.3em;
    border: none;
    font-size: 1em;
    line-height: 1em;
    margin-left: 0;
    max-width: 1.3em;
    min-width: 0;
}

.checkboxField .checkboxLabel,
.radioField .radioLabel,
.horizontalRadio label {
    display: block;
    position: relative;
    padding: 0.75em 0.25em 0 2em;   /* 9px 3px 0 24px @ 0.75em font-size */
}

.horizontalRadio td{
    position:relative;
}

.checkboxField .checkboxLabel.alignWithGrid {
    margin-left: 0.5em;
}


.textField .validInput,
.textField .inValidInput {
    position: absolute;
    top: 0.5em;
    *top: 0.3em;
    right: 0.5em;
    display: none;
    height: 1em;
    width: 1em;
    margin-top: 0.125em; /* 2px, the input field height is 2.25em */
}

.error .inValidInput {
    display: block;
}

.valid .validInput {
    display: block;
}

input.small {
    width: 8em;
}

/*
.fieldContainer .bRight img {
    margin-left: 3px;
}
*/

input[type="text"].hasDatepicker {
    width: 72%;
    padding-right: 0.5em;
    display: inline-block;
    *display: inline;
    *zoom: 1;
}

img.ui-datepicker-trigger {
    margin-left: 0.35em;
}



.priorityCodeContainer {
    background-color: #F0F3F4;
    border-bottom: 1px solid #DADADA;
    margin-top: -3px;
    margin-bottom: 0;
    padding-top: 1em;
    padding-left: 1.5em;
}

.priorityCodeContainer input[type="text"] {
    width: 14em;
    margin-right: 1em;
}
