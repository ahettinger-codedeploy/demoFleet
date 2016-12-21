/// <reference path="jquery-1.7.2-vsdoc.js" />
function registrationCallBack(iFrame) {

}


//sortElements written by: James Padolsey (http://james.padolsey.com)
jQuery.fn.sortElements = (function () {
    var sort = [].sort;
    return function (comparator, getSortable) {
        getSortable = getSortable || function () { return this; };
        var placements = this.map(function () {
            var sortElement = getSortable.call(this),
                parentNode = sortElement.parentNode,
                nextSibling = parentNode.insertBefore(
                    document.createTextNode(''),
                    sortElement.nextSibling
                );
            return function () {

                if (parentNode === this) {
                    throw new Error(
                        "You can't sort elements if any one is a descendant of another."
                    );
                }
                parentNode.insertBefore(this, nextSibling);
                // Remove flag:
                parentNode.removeChild(nextSibling);

            };

        });
        return sort.call(this, comparator).each(function (i) {
            placements[i].call(getSortable.call(this));
        });
    };
})();

if (typeof ews == "undefined")
    var ews = {};

if (typeof ews.CalendarBlock == "undefined")
    ews.CalendarBlock = {};

ews.CalendarBlock.Grid = {};
ews.CalendarBlock.Grids = [];

ews.CalendarBlock.Grid.Months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"];
ews.CalendarBlock.Grid.Days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"];

//hate to do this but when working with iframes don't know a better way
ews.CalendarBlock.Grid.EditFrame = null;
ews.CalendarBlock.Grid.EditGrid = null;
ews.CalendarBlock.Grid.EditCallBack = function () {
    ews.CalendarBlock.Grid.EditFrame.hide();
    try {
        if (!$.browser.msie) {
            ews.CalendarBlock.Grid.EditFrame.remove();
        }
        else {
            //jquery fails to remove it in IE http://bugs.jquery.com/ticket/8779
            ews.CalendarBlock.Grid.EditFrame[0].src = "about: blank";
            setTimeout(function () { ews.CalendarBlock.Grid.EditFrame.remove(); }, 100);
        }
    }
    catch (err) { }
    $(".ews_cal_lightboxbackground").remove();
    ews.CalendarBlock.Grid.EditGrid.BuildGrid(true);
};

function dGrid(ClientID, sUrl, bRights, sEventTypes, sDisplayTags, bShowFusionTags, bShowFusionTypesTags, sToken, bCalendarTags, oIDs) {
    var  oCalendarManager = this;
    this.CalendarTags = bCalendarTags == "False" || bCalendarTags == "" ? false : true;
    this.Month = new Date().getMonth();
    this.Year = new Date().getFullYear();
    this.Container = $("#" + ClientID + "_container");
    this.Table = this.Container.children("#ews_cb_grid");
    this.TableHeader = this.Container.find(".ews_cal_grid_week");
    this.Sources = sUrl.split(',');
    this.Events = [];
    this.AllEvents = [];
    this.Tags = [];
    this.TagsSelected = [];
    this.iCalAdd = "";
    this.DisplayTags = sDisplayTags;
    this.EventTypes = sEventTypes;
    this.Rights = bRights;
    this.FilterExpanded = false;
    this.ShowFusionTags = bShowFusionTags == "False" || bShowFusionTags == "" ? false : true;
    this.ShowFusionTypeTags = bShowFusionTypesTags == "False" || bShowFusionTypesTags == "" ? false : true;
    this.Token = sToken;
    this.SourceStatus = [];
    this.IDs = oIDs.split('|');

    this.viewModel = new function () {
        this.Events = ko.observableArray();
        this.Title = ko.observable();
        this.Rows = ko.observableArray();
        this.Month = ko.observable();
        this.Day = ko.observable("GLAH");
        this.Year = ko.observable();
        this.MonthText = ko.observable();
        this.SelectedEvents = ko.observableArray();
        this.MobileSelectedEvents = ko.observableArray();
        this.Tags = ko.observableArray(["blah", "blah2"]);
        this.filter = function (data, e) {
            if (e.target.checked)
                oCalendarManager.Tags.push(data);
            if (!e.target.checked) 
                ews.Util.Remove(oCalendarManager.Tags, data);

            oCalendarManager.Filter();
            return true;
        }
    }

    this.Row = function () {
        this.Days = ko.observableArray();
    }

    this.Day = function () {
        this.Year = ko.observable();
        this.Month = ko.observable();
        this.MonthText = ko.observable();
        this.Day = ko.observable();
        this.DayOfWeek = ko.observable();
        this.Hidden = ko.observable(false);
        this.Today = ko.observable(false);
        this.Events = ko.observableArray();
        this.SelectDay = function (data) {
            oCalendarManager.viewModel.SelectedEvents(data.Events());
            oCalendarManager.viewModel.Day(data.Day());
            //$("body").css("overflow", "hidden");
            $("body").addClass("lock-position");
            window.location.hash = oCalendarManager.Container.find(".mobile-daily-events").prop('id');
        }
    }

    this.iCalTimeFormat = function (oStartDate, oEndDate, oEvent) {
        var oMonth = (oStartDate.getMonth() + 1);
        if (oMonth < 10) { oMonth = "0" + oMonth.toString(); } else { oMonth = oMonth.toString(); }
        var oDay = oStartDate.getDate();
        if (oDay < 10) { oDay = "0" + oDay.toString(); } else { oDay = oDay.toString(); }

        var sStart = oStartDate.getFullYear() + oMonth + oDay;

        if (oEvent.Event.HasStartTime) {
            sStart += "T";
            if (oStartDate.getHours() < 10)
                sStart += "0";
            sStart += oStartDate.getHours();
            if (oStartDate.getMinutes() < 10)
                sStart += "0";
            sStart += oStartDate.getMinutes();
            sStart += "00";
        }

        var sEnd = sStart;
        if (oEndDate) {
            var oMonth = (oEndDate.getMonth() + 1);
            if (oMonth < 10) { oMonth = "0" + oMonth.toString(); } else { oMonth = oMonth.toString(); }
            var oDay = oEndDate.getDate();
            if (oDay < 10) { oDay = "0" + oDay.toString(); } else { oDay = oDay.toString(); }
            sEnd = oEndDate.getFullYear() + oMonth + oDay;
        }

        if (oEvent.Event.HasEndTime) {
            sEnd += "T";
            if (oEndDate.getHours() < 10)
                sEnd += "0";
            sEnd += oEndDate.getHours();
            if (oEndDate.getMinutes() < 10)
                sEnd += "0";
            sEnd += oEndDate.getMinutes();
            sEnd += "00";
        }

        return [ sStart , sEnd ];
    }
    this.LoadTags = function () {
        oCalendarManager.viewModel.Tags.removeAll();
        $(oCalendarManager.Events).each(function (i, oItem) {
            if (oItem.Event.Source.indexOf("GetFusionCalendar") > -1 && oCalendarManager.ShowFusionTypeTags) {
                if (oCalendarManager.viewModel.Tags.indexOf(oItem.Event.Type) == -1) {
                    oCalendarManager.viewModel.Tags.push(oItem.Event.Type);
                }
            }
            if (oItem.Event.Source.indexOf("GetFusionCalendar") == -1 || oCalendarManager.ShowFusionTags) {
                $(oItem.Event.Categories).each(function (t, oTag) {
                    if (oTag.replace(' ', '') != '' && oCalendarManager.viewModel.Tags.indexOf(oTag) == -1) {
                        oCalendarManager.viewModel.Tags.push(oTag);
                    }
                });
            }
            if (oItem.Event.Source.indexOf("GetFusionCalendar") == -1 && oCalendarManager.CalendarTags) {
                if (oItem.Event.Source.indexOf("http://") > -1 || oItem.Event.Source.indexOf("https://") > -1) {
                    var oCalendarName = oItem.Event.CalendarName;
                    if (oCalendarName.replace(' ', '') != '' && oCalendarManager.viewModel.Tags.indexOf(oCalendarName) == -1) {
                        oCalendarManager.viewModel.Tags.push(oCalendarName);
                    }
                }
                else {
                    var oCalendarName = oItem.Event.Source.replace(/_/g, ' ').replace('.ics', '');
                    if (oCalendarName.replace(' ', '') != '' && oCalendarManager.viewModel.Tags.indexOf(oCalendarName) == -1) {
                        oCalendarManager.viewModel.Tags.push(oCalendarName);
                    }
                }
            }
        });
        oCalendarManager.viewModel.Tags.sort(function (a, b) {
            return a.toLowerCase().localeCompare(b.toLowerCase());
        });
        
    }
    this.Filter = function () {
        oCalendarManager.Events = oCalendarManager.AllEvents.filter(function (oEvent) {
            if (oCalendarManager.Tags.length == 0)
                return true;
            var bRetVal = false;
            $(oCalendarManager.Tags).each(function (i, oTag) {
                if (oEvent.Event.Categories.indexOf(oTag) > -1)
                    bRetVal = true;
                if (oCalendarManager.ShowFusionTypeTags && oEvent.Event.Source.indexOf("GetFusionCalendar") > -1) {
                    if (oEvent.Event.Type == oTag) {
                        bRetVal = true;
                    }
                }
                if (oCalendarManager.CalendarTags && oEvent.Event.Source.indexOf("GetFusionCalendar") == -1) {
                    var oCalendarName = oEvent.Event.Source.replace(/_/g, ' ').replace('.ics', '');
                    if (oCalendarName == oTag) {
                        bRetVal = true;
                    }
                    else if (oEvent.Event.CalendarName && oEvent.Event.CalendarName == oTag) {
                        bRetVal = true;
                    }
                }
            });

            return bRetVal;
        });
        oCalendarManager.BuildGrid(false);
    }
    //if passed true it will load them from a webservice other wise it will just build a blank grid
    this.BuildGrid = function (bReloadEvents) {
        var dStart = new Date(this.Year, this.Month, 1); dStart.setDate(dStart.getDate() - dStart.getDay());
        var dWorkingDate = new Date(this.Year, this.Month, 1); dWorkingDate.setDate(dWorkingDate.getDate() - dWorkingDate.getDay());
        var dEnd = dWorkingDate;
        this.viewModel.Title(ews.CalendarBlock.Grid.Months[this.Month] + " " + this.Year);
        this.viewModel.Year(this.Year);
        this.viewModel.Month(this.Month);
        this.viewModel.MonthText(ews.CalendarBlock.Grid.Months[this.Month].substr(0,3));
        this.viewModel.Rows.removeAll();
        var nEvalMonth = this.Month;

        var oRow = new oCalendarManager.Row();

        while (dWorkingDate.getMonth() <= nEvalMonth || dWorkingDate.getFullYear() < this.Year || dWorkingDate.getDay() != 0) {
            if (dWorkingDate.getDay() == 0) {
                oRow = new oCalendarManager.Row();
            }
            
            var oDay = new oCalendarManager.Day();
            oDay.Day(dWorkingDate.getDate());
            oDay.Month(dWorkingDate.getMonth() + 1);
            oDay.MonthText(ews.CalendarBlock.Grid.Months[dWorkingDate.getMonth()].substr(0, 3));
            oDay.Year(dWorkingDate.getFullYear());

            

            if (dWorkingDate.getMonth() != this.Month)
                oDay.Hidden(true);

            if (dWorkingDate.getDate() == new Date().getDate() && dWorkingDate.getMonth() == new Date().getMonth())
                oDay.Today(true);

            oRow.Days.push(oDay);

            oDay.DayOfWeek(ews.CalendarBlock.Grid.Days[dWorkingDate.getDay()]);

            if (dWorkingDate.getDay() == 6) {
                oCalendarManager.viewModel.Rows.push(oRow);
            }

            dWorkingDate.setDate(dWorkingDate.getDate() + 1);

            if (dWorkingDate.getMonth() == 0 && this.Month == 11)
                nEvalMonth = -1;

        }

        if (bReloadEvents) {
            var sSources = oCalendarManager.Sources.join(',');
            oCalendarManager.Events = [];
            oCalendarManager.AllEvents = [];
            $(oCalendarManager.Sources).each(function () {
                var sParam = '{Start:"' + (dStart.getMonth() + 1) + "/" + dStart.getDate() + "/" + dStart.getFullYear() + '", End: "' + (dEnd.getMonth() + 1) + "/" + dEnd.getDate() + "/" + dEnd.getFullYear() + '", Calendar:"' + this + '", EventTypes: "' + oCalendarManager.EventTypes + '", DisplayTags: "' + oCalendarManager.DisplayTags + '"}'; //hard coded for now
                var dSrc = this;
                oCalendarManager.SourceStatus.push(false);
                $.ajax({
                    type: "POST",
                    url: "/Blocks/CalendarBlock/CalendarBlock.asmx/GetOccurences",
                    data: sParam,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    error: function (e, xhr) {
                        console.log('Something went wrong loading ' + dSrc + ' - ' + xhr);
                    },
                    success: function (msg) {
                        var i = 0;
                        var oTEvents = $.parseJSON(msg.d);
                        
                        if (msg.d) {
                            $(oTEvents).each(function () {
                                var oEvent = this;

                                oEvent.Cost = "";
                                oEvent.LocationName = "";
                                oEvent.LocationAddress = "";
                                oEvent.Campus = "";
                                oEvent.Key = "";
                                oEvent.Image = "";
                                oEvent.Register = false;
                                oEvent.LoginRegister = false;
                                oEvent.DefinitionID = "";
                                oEvent.Image = "";
                                

                                
                                var oStartDate = new Date(new Date(oEvent.JDStart).toDateString());
                                var oEndDate = oStartDate;
                                if (this.DTEnd)
                                    oEndDate = new Date(new Date(oEvent.JDEnd).toDateString());
                                if (this.DTEnd && oStartDate > oEndDate)
                                    oEndDate = oStartDate;

                                oEvent.Edit = function (data, e) {
                                    var oEvent = data;
                                    if (oEvent.Event.Source.indexOf('http://') > -1) {
                                        alert('You can not edit Google, Fusion, Yahoo, External Events using these tools');
                                    }
                                    else {
                                        ews.CalendarBlock.Grid.EditGrid = oCalendarManager;
                                        ews.CalendarBlock.Grid.EditFrame = ews.CalendarBlock.LightBox('/Blocks/CalendarBlock/EditEvent.aspx?EventID=' + oEvent.Event.UID + '&CalendarID=' + oEvent.Event.Source.replace("&", "%26") + "&startime=" + (oStartDate.getMonth() + 1) + "/" + oStartDate.getDate() + "/" + oStartDate.getFullYear() + "&endtime=" + (oEndDate.getMonth() + 1) + "/" + oEndDate.getDate() + "/" + oEndDate.getFullYear());
                                    }
                                }

                                oEvent.RegisterClick = function (data, e) {
                                    if ($.browser.platform == "iphone" || $.browser.platform == "android") {
                                        var sFrameSrc = "https://www.elexiopulse.com/external/eventregistration.aspx?href=";
                                        var sHref = "http://" + location.hostname + "&occurrenceid=0&definitionid=" + oEvent.DefinitionID + "&eventstart=" + (oStartDate.getMonth() + 1) + "/" + oStartDate.getDate() + "/" + oStartDate.getFullYear() + "%20" + oStartDate.toLocaleTimeString().replace(/ /g/i,"%20");

                                        if (oCalendarManager.Token != "") {
                                            sHref += "&logintoken=" + oCalendarManager.Token;
                                        }
                                        window.open(sFrameSrc + sHref);
                                        return;
                                    }

                                    $("body").removeClass("lock-position");
                                    window.location.hash = "";
                                    oCalendarManager.Container.find(".SliderDialog").removeClass("open");

                                    //oCalendarManager.Container.find(".register-details").css({ minHeight: oCalendarManager.Container.find(".calendar").height() })
                                    oCalendarManager.Container.find(".elexio-calendar").fadeOut(20, null, function () {
                                        oCalendarManager.Container.find(".register-details").show();

                                        var sFrameSrc = "https://www.elexiopulse.com/external/eventregistration.aspx?href=";
                                        var sHref = "http://" + location.hostname + "&occurrenceid=0&definitionid=" + oEvent.DefinitionID + "&eventstart=" + (oStartDate.getMonth() + 1) + "/" + oStartDate.getDate() + "/" + oStartDate.getFullYear() + " " + oStartDate.toLocaleTimeString();

                                        if (oCalendarManager.Token != "") {
                                            sHref += "&logintoken=" + oCalendarManager.Token;
                                        }

                                        oCalendarManager.Container.find(".register-details div iframe").attr("src", sFrameSrc + sHref);

                                        $.receiveMessage(
                                            function (e) {
                                                if (e.data == "cancel" || e.data == "done") {
                                                    oCalendarManager.Container.find(".register-details div iframe").attr("src", null);
                                                    oCalendarManager.Container.find(".register-details").hide();
                                                    oCalendarManager.Container.find(".elexio-calendar").fadeIn();
                                                }
                                            }
                                          );
                                    });
                                }

                                oEvent.Select = function (data, e) {
                                    oCalendarManager.viewModel.SelectedEvents.removeAll();
                                    oCalendarManager.viewModel.SelectedEvents.push(data);
                                    oCalendarManager.Container.find(".events .selected").removeClass("selected");
                                    $(e.target).addClass("selected");
                                    oCalendarManager.Container.find(".SliderDialog").addClass("open");
                                    //window.location.hash = oCalendarManager.Container.find(".SliderDialog").prop('id');
                                    e.preventDefault();
                                };
                                oEvent.SelectLocation = function (data, e) {
                                    if (data.Navigate()) {
                                        window.open('http://maps.google.com/maps?hl=en&q=' + data.Event.Location);
                                        //document.location.href = 'http://maps.google.com/maps?hl=en&amp;q=' + data.Event.Location;
                                    }
                                }
                                oEvent.SelectMobileEvent = function (data, e) {
                                    oCalendarManager.viewModel.MobileSelectedEvents.removeAll();
                                    oCalendarManager.viewModel.MobileSelectedEvents.push(data);
                                    $("body").addClass("lock-position");                                    
                                    window.location.hash = oCalendarManager.Container.find(".mobile-details").prop('id');
                                }
                                oEvent.Navigate = function (data, e) {
                                    if (oEvent.Event.Location) {
                                        var re = new RegExp("[0-9]{5}", "g");
                                        var myArray = oEvent.Event.Location.match(re);
                                        if (myArray != null) {
                                            //window.open('http://maps.google.com/maps?hl=en&amp;q=' + oEvent.Event.Location);
                                            return true;
                                        }
                                    }
                                    return false;
                                }
                                oEvent.AddToCalendar = function (data, e) {
                                    var $target = $(e.target), oLocation = "", oDescription = "";

                                    if (($.browser.platform == "ipad" || $.browser.platform == "iphone") && $target.hasClass("ical")) {
                                        window.location.href = "/Event.vcs?uid=" + data.Event.UID;
                                    }
                                    else {
                                        var aDates = oCalendarManager.iCalTimeFormat(oStartDate, oEndDate, oEvent);

                                        if ($.browser.platform == "android" && ($target.hasClass("google") || $target.hasClass("ical"))) {
                                            //android does not so bump to google calendar which is most likely what they are using
                                            window.open("https://www.google.com/calendar/gp#~calendar:view=e&action=template&text=" + escape(oEvent.Event.Summary) +
                                                "&dates=" + aDates[0] + "/" + aDates[1] +
                                                "&sprop=website:www.elexio.com&sprop=name:elexio&details=" + escape(oEvent.Event.Description), "GoogleCal");
                                            return;
                                        }
                                        else {
                                            var aDates = oCalendarManager.iCalTimeFormat(oStartDate, oEndDate, oEvent);

                                            if (oEvent.Event.Location)
                                                oLocation = escape(oEvent.Event.Location);
                                            if (oEvent.Event.Description)
                                                oDescription = escape(oEvent.Event.Description);

                                            if ($target.hasClass("google")) {
                                                window.open("http://www.google.com/calendar/event?action=TEMPLATE&text=" + escape(oEvent.Event.Summary) +
                                                    "&dates=" + aDates[0] + "/" + aDates[1] +
                                                    "&sprop=website:www.elexio.com&sprop=name:elexio&details=" + oDescription, "GoogleCal");
                                            }
                                            else if ($target.hasClass("yahoo")) {
                                                window.open("http://calendar.yahoo.com/?v=60&TITLE=" + encodeURIComponent(oEvent.Event.Summary) +
                                                    "&ST=" + aDates[0] +
                                                    "&in_loc=" + oLocation +
                                                    "&DESC=" + oDescription +
                                                    "&URL=" + document.URL, "yCal");
                                            }
                                            else if ($target.hasClass("microsoft")) {
                                                window.open("http://calendar.live.com/calendar/calendar.aspx?rru=addevent&summary=" + encodeURIComponent(oEvent.Event.Summary) +
                                                    "&dtstart=" + aDates[0] +
                                                    "&dtend=" + aDates[1] +
                                                    "&location=" + oLocation +
                                                    "&description=" + oDescription +
                                                    "&URL=" + document.URL, "mCal");
                                            }
                                            else {
                                                //window.open("webcal://" + window.location.hostname + "/Event.vcs?uid=" + data.Event.UID, "_self");

                                                window.location.href = "/Event.vcs?uid=" + data.Event.UID;
                                            }
                                        }
                                    }

                                };
                                
                                //load custom properties
                                $(oEvent.Event.Properties).each(function (indexInArray, valueOfElement) {

                                    if (this.Key == "COST" || this.Key == "X-COST") {
                                        if (this.Value != "0.00") {
                                            oEvent.Cost = this.Value;
                                        }
                                    }


                                    
                                    if (this.Key == "X-ADDRESS")
                                        oEvent.LocationAddress = this.Value.replace("\\", "").replace("\\","");

                                    if (this.Key == "X-LOCATION")
                                        oEvent.LocationName = this.Value.replace("\\", "").replace("\\", "");

                                    if (this.Key == "X-CAMPUS")
                                        oEvent.Campus = this.Value.replace("\\", "").replace("\\", "");

                                    if (this.Key == "KEY")
                                        oEvent.Key = this.Value;

                                    if (this.Key == "KEY")
                                        oEvent.Key = this.Value;
                                    if (this.Key == "IMAGE") 
                                        oEvent.Image = this.Value;
                                    if (this.Key == "ATTACH" && this.Value != "")
                                        oEvent.Image = this.Value.split(':')[1];

                 
                                    if (this.Key == "OPEN") {
                                        if (this.Value == "True")
                                            oEvent.Register = true;
                                        else if (this.Value == "Login")
                                            oEvent.LoginRegister = true;
                                    }
                                    if (this.Key == "DEFINITIONID" || this.Key == "X-DEFINITIONID")
                                        oEvent.DefinitionID = this.Value;
                                });
                                oCalendarManager.AllEvents.push(this)
                                oCalendarManager.Events.push(this)
                            });
                            oCalendarManager.LoadTags();
                        }
                        oCalendarManager.LoadEvents();
                        oCalendarManager.CalculateOverflow();
                        if ($.browser.platform == "ipad" || $.browser.platform == "iphone" || $.browser.platform == "android") {
                            if (oCalendarManager.viewModel.MobileSelectedEvents().length == 0) {
                                window.location.hash = "";
                            }
                        }

                    }
                });
            });
        }
        else
        {
            oCalendarManager.LoadEvents();
        }
    }

    this.LoadEvents = function () {
        var maxxerror = 0;
        $(oCalendarManager.viewModel.Rows()).each(function (h, oRow) {
            $(oRow.Days()).each(function (f, oDay) {
                maxxerror++;
                
                if (maxxerror > 1000)
                    throw DOMException();
                var oWorkingDate = new Date(oDay.Month() + "/" + oDay.Day() + "/" + oDay.Year());
                var oTemp = oCalendarManager.Events
                    .sort(function (a, b) {
                        var vA = new Date(a.JDStart).getTime();
                        var vB = new Date(b.JDStart).getTime();
                        return (vA < vB) ? -1 : (vA > vB) ? 1 : 0;
                    })
                    .filter(function (oEvent) {
                    var oStartDate = new Date(new Date(oEvent.JDStart).toDateString());
                    var oEndDate = oStartDate;
                    if (oEvent.JDEnd)
                        oEndDate = new Date(new Date(oEvent.JDEnd).toDateString());
                    if (oEvent.JDEnd && oStartDate > oEndDate)
                        oEndDate = oStartDate;
                    var bRetVal = false;

                    //this day is the start of the event regardless show it
                    if (oStartDate.getDate() == oWorkingDate.getDate() && oStartDate.getMonth() == oWorkingDate.getMonth()) {
                        bRetVal = true
                    }
                    else if (oWorkingDate > oStartDate && oWorkingDate <= oEndDate) {
                        if (oWorkingDate.getDate() == oEndDate.getDate() &&
                            oWorkingDate.getMonth() == oEndDate.getMonth() && 
                            oWorkingDate.getFullYear() == oEndDate.getFullYear() && 
                            new Date(oEvent.JDStart).getHours() == 0) // they are the same day and the end date happens all at 0 hours (doesn't include this day)
                            bRetVal = false;
                        else
                            bRetVal = true
                    }
                    return bRetVal;
                });
                oDay.Events(oTemp);
            });
        });
    }

    this.CloseMobileDetails = function (e) {
        window.location.hash = oCalendarManager.Container.find(".mobile-daily-events").prop('id');
        e.preventDefault();
    }

    this.Foward = function (e) {
        var oGrid;
        if (e.data)
            oGrid = e.data;
        else
            oGrid = e;

        oGrid.Month++;
        if (oGrid.Month == 12) {
            oGrid.Month = 0;
            oGrid.Year++;
        }
        this.TagsSelected = [];
        oGrid.BuildGrid(true);
        e.preventDefault();
    }

    this.Back = function (e) {
        var oGrid;
        if (e.data)
            oGrid = e.data;
        else
            oGrid = e;
        oGrid.Month--;
        if (oGrid.Month == -1) {
            oGrid.Month = 11;
            oGrid.Year--;
        }
        this.TagsSelected = [];
        oGrid.BuildGrid(true);
        e.preventDefault();
    }

    this.EmailPopup = function () {
        oCalendarManager.Container.find(".cal-emailsend").click(function () {
            var sTo = oCalendarManager.Container.find(".cal-emailfrm").val();
            var sFrom = oCalendarManager.Container.find(".cal-emailto").val();
            var sMessage = oCalendarManager.Container.find(".cal-emailmessage").val();

            var sUrl = window.location;
            sTo = escape(sTo);
            sUrl = escape(sUrl);
            var sData = "{'To':'" + sTo + "','Url':'" + sUrl + "','From':'" + sFrom + "','Message':'" + sMessage + "'}";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "/blocks/calendarblock/calendarblock.asmx/Email",
                data: sData,
                dataType: "json",
                success: function (data) {
                    alert("Your message has been sent");
                    oCalendarManager.Container.find(".options-menu-icon").next().fadeToggle();
                    oCalendarManager.Container.find(".cal-emailto").val("");
                    oCalendarManager.Container.find(".cal-emailmessage").val("")
                },
                error: function (e, xhr) {
                    alert("Unable to send the email, this is most likely because either the 'From' or 'Their' email address is invalid.");
                }
            });

        });
    }

    this.Print = function (arg1) {
        var oGrid = arg1.data;
        var oOutput = $("<div></div>");
        var nCurrent = -1;
        $(oGrid.Events).each(function () {
            var oStartDate = new Date(parseInt(this.DTStart.substr(6)));
            if (nCurrent != oStartDate.getMonth()) {
                nCurrent = oStartDate.getMonth();
                oOutput.append("<header>" + ews.CalendarBlock.Grid.Months[oStartDate.getMonth()] + " " + oStartDate.getFullYear() + "</header>\n");
            }

            var oEventHtml = "<section class='summary'><b>" + this.Event.Summary + "</b></section>\n" +
                             "<article class='event'>\n" +
                                "<div class='date'><strong>Date:</strong>" + this.FDShortStart + " " + this.Formated + "</div>\n";
            if (this.Event.Description)
                oEventHtml += "<div class='location'><strong>Description:</strong>" + this.Event.Description + "</div>\n";

            if (this.Event.Location)
                  oEventHtml += "<div class='location'><strong>Location:</strong>" + this.Event.Location + "</div>\n";


               oEventHtml += "</article>";
            oOutput.append(oEventHtml);
        });

        var src = "<ht" + "ml>\n" +
            "<head>\n" +
            "<title></title>\n" +
            "<style type='text/css'>@import url('/Blocks/CalendarBlock/Css/Default.css');</style>\n" +
            "<style type='text/css'>@import url('/Blocks/CalendarBlock/Css/styles.css');</style>\n" +            
            "<scr" + "ipt>\n" +
            "function step1() {\n" +
            "  setTimeout('step2()', 10);\n" +
            "}\n" +
            "function step2() {\n" +
            "  window.print();\n" +
            "  window.close();\n" +
            "}\n" +
            "</scr" + "ipt>\n" +
            "</head>\n" +
            "<body class='calendar-print' onLoad='step1()'>\n" +
            oOutput.html() + "\n" +
            "</body>\n" +
            "</html>\n";
        link = "about:blank";
        var printwindow = window.open(link, "_new");
        printwindow.document.open();
        printwindow.document.write(src);
        printwindow.document.close();
    }

    this.NewEvent = function (arg1) {
        var oGrid = arg1.data;
        ews.CalendarBlock.Grid.EditGrid = oGrid;
        var oSelectedDate = $(".ews_cal_grid_box_selected");
        var sDate = (oGrid.Month + 1) + "/1/" + oGrid.Year;
        if (oSelectedDate.length > 0) {
            var sTemp = oSelectedDate.attr("date").split('/')[1];
            sDate = (oGrid.Month + 1) + "/" + sTemp + "/" + oGrid.Year;
        }
        ews.CalendarBlock.Grid.EditFrame = ews.CalendarBlock.LightBox('/Blocks/CalendarBlock/EditEvent.aspx?EventID=' + sDate + ' PM&CalendarID=add&Sources=' + oGrid.Sources.join());
    }

    this.AddCalendar = function (arg1) {
        var oGrid = arg1.data;
        window.open("webcal://" + window.location.hostname + "/" + oGrid.IDs.join(',').replace("://", "") + ".id.ics", "_self");
    }
    this.CalculateOverflow = function () {
        $(".calendar-grid .events").removeClass("overflowed");
        $(".events ul").each(function (i, oItem) {
            if ($(this).children().length > 1 && $(this).isChildOverflowingVertically($(this).children().last())) {
                $(this).parent().addClass("overflowed");
            }
        });
    }
    this.Init = function () {
        $(window).on('hashchange', function () {
            if (window.location.hash == "" || window.location.hash == "#close")
                $("body").removeClass("lock-position");
        });
        var oGrid = this;
        this.Container.find(".calendar-header .previous-month").click(this, this.Back);
        this.Container.find(".calendar-header .next-month").click(this, this.Foward);
        this.Container.find(".calendar-header .print").click(this, this.Print);
        this.Container.find(".calendar-header .new").click(this, this.NewEvent);
        this.Container.find(".calendar-header .add-ical, .calendar-header .add-outlook").click(this, this.AddCalendar);
        this.Container.find(".mobile-details-close").click(this, this.CloseMobileDetails);
        this.Container.find(".SliderDialog .close").click(function (e) {
            oCalendarManager.Container.find(".SliderDialog").toggleClass("open");
            e.preventDefault();
        });
        this.Container.find(".mobile-daily-events .close").click(function (e) {
            //$("body").css("overflow", "auto");
            $("body").removeClass("lock-position");
        });
        $(window).resize(function () {
            oCalendarManager.CalculateOverflow();
        });

        this.Container.find(".options-menu-icon").next().click(function (e) {
            e.stopPropagation();
        });
        $("body").click(function () {
            oCalendarManager.Container.find(".options-menu-icon").next().fadeOut();
        });
        if (($.browser.platform == "ipad" || $.browser.platform == "iphone")) {
            $(".calendar-grid").hover(function () {
                oCalendarManager.Container.find(".options-menu-icon").next().fadeOut();
            });
        }
        
        this.Container.find(".icon-cal").click(this, this.AddCalendar);

        this.Container.find(".email, .filter-tags").click(this, function (e) {
            $(e.target).toggleClass("open");
            $(e.target).next().fadeToggle();
            e.preventDefault();
        });
        
        this.Container.find(".options-menu-icon").click(this, function (e) {
            $(e.target).next().fadeToggle();
            e.stopPropagation();
            e.preventDefault();
        });
        this.Container.find(".mobile-daily-events, .mobile-details, .SliderDialog").uniqueId();

        ko.applyBindings(oCalendarManager.viewModel, oCalendarManager.Container[0]);
        
        this.BuildGrid(true);
        this.EmailPopup();
    }

}

ews.CalendarBlock.Grid.Init = function (ClientID, sUrl, bRights, sEventTypes, sDisplayTags, bShowFusionTags, bShowFusionTypesTags, sToken, bCalendarTags, oIDs) {
    var oGrid = new dGrid(ClientID, sUrl, bRights, sEventTypes, sDisplayTags, bShowFusionTags, bShowFusionTypesTags, sToken, bCalendarTags, oIDs);
    oGrid.Init();
    ews.CalendarBlock.Grids.push(oGrid);
}

