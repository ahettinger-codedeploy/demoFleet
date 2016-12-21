if (typeof (Dea) === "undefined" || null === Dea) {
    var Dea = {};
}

if (typeof (Dea.dp) === "undefined" || null === Dea.dp) {
    Dea.dp = {};
}

Dea.dp.lastDateValue = "";

Dea.dp.validateDate = function () {
    /* if they pick a date, then it will always be in the correct format.  However, since
    we allow the user to type in the box, there is the chance that the value that we have 
    is not actually a date.  If this is the case, then we want to set the value back to whatever it was
    before the user started jacking with it.
    */
    var v = $(this).val();
    var d = -1;
    var m = -1;
    var y = -1;
    try {
        var formatArray = localizationDateFormat.split(localizationDateSeparator);
        var dateParts = v.split(localizationDateSeparator);
        if (dateParts.length == 3 && dateParts[2].indexOf(" ") !== -1) {
            try {
                dateParts[2] = dateParts[2].substr(0, (dateParts[2].length - dateParts[2].indexOf(" ") + 1));
            }
            catch (badThird)
			{ }
        }
        for (var i = 0; i < formatArray.length; i++) {
            if (formatArray[i].indexOf("d") >= 0) {
                if (dateParts.length > i) {
                    d = Number(dateParts[i]);
                }
            }
            else if (formatArray[i].indexOf("m") >= 0) {
                if (dateParts.length > i) {
                    m = Number(dateParts[i]);
                }
            }
            else if (formatArray[i].indexOf("y") >= 0) {
                if (dateParts.length > i) {
                    y = Number(dateParts[i]);
                }
            }
        }
    }
    catch (badDate) {
        $(this).val(Dea.dp.lastDateValue);
    }

    var newDate = new Date();
    if (d === -1 || m === -1 || isNaN(d) || isNaN(m)) {
        $(this).val(Dea.dp.lastDateValue);
        Dea.dp.afterSet();
        return;
    }
    if (y === -1 || isNaN(y)) {
        y = newDate.getFullYear();
    }
    else {
        if (y < 38)
            y += 2000;
        else {
            if (y < 1900) {
                y += 1900;
            }
        }
    }

    newDate.setFullYear(y, m - 1, d);
    $(this).datepicker('setDate', newDate);
    Dea.dp.afterSet();
}

Dea.dp.afterSet = function () {
    if(typeof(Dea.dp.callOnDateChange) === "function") {
        Dea.dp.callOnDateChange();
    }
}
