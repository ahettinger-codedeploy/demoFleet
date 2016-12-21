<!--
// Courtesy of SimplytheBest.net (http://simplythebest.net/info/dhtml_scripts.html)
function makeArray(n) {
this.length = n
return this
}
monthNames = new makeArray(12)
monthNames[1] = "January"
monthNames[2] = "February"
monthNames[3] = "March"
monthNames[4] = "April"
monthNames[5] = "May"
monthNames[6] = "June"
monthNames[7] = "July"
monthNames[8] = "August"
monthNames[9] = "September"
monthNames[10] = "October"
monthNames[11] = "November"
monthNames[12] = "December"
function dateString(oneDate) {
var theMonth = monthNames[oneDate.getMonth() + 1]
var theYear = oneDate.getFullYear()
return theMonth + " " + oneDate.getDate() + ", " + theYear
}

//-->
