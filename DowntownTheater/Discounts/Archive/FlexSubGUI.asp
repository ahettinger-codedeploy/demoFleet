<%

'CHANGE LOG
'SSR 1/6/2012
'Web page interface for the FlexSubDiscount script

%>


<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'===============================================

Page = "Management"
SecurityFunction = "FlexSubDiscount"
ReportFileName = "FlexSubDiscountasp"
ReportTitle = "Season Subscription Wizard"

'===============================================

Server.ScriptTimeout = 1200

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If SecurityCheck(SecurityFunction) = False Then Response.Redirect("/Management/Default.asp")


'===============================================

'Season Subscription Parameters
'(1) SeriesCount
'(2) AllowedSeatTypeList
'(3) Percentage / FixedPrice / DiscountAmount / SeriesPrice
'(4) Surcharge

'===============================================


Select Case Request("FormName")
Case "VenueName"
	Call SearchResults
Case Else
	Call Inquiry(Message)
End Select

'===============================================

Sub Inquiry(Message)

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Venue Inquiry</title>

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.js" ></script>

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js" ></script>

<link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/base/jquery-ui.css"/>

<script type="text/javascript"></script>
$(function() {
    var d=300;
    $('#navigation a').each(function(){
        $(this).stop().animate({
            'marginTop':'-80px'
        },d+=150);
    });

    $('#navigation > li').hover(
    function () {
        $('a',$(this)).stop().animate({
            'marginTop':'-2px'
        },200);
    },
    function () {
        $('a',$(this)).stop().animate({
            'marginTop':'-80px'
        },200);
    }
);
});
</script>
<style type="text/css">
   
#wrapper
{
    -moz-box-shadow:0px 0px 3px #aaa;
    -webkit-box-shadow:0px 0px 3px #aaa;
    box-shadow:0px 0px 3px #aaa;
    -moz-border-radius:10px;
    -webkit-border-radius:10px;
    border-radius:10px;
    border:2px solid #fff;
    background-color:#f9f9f9;
    width:600px;
    overflow:hidden;
}
#steps{
    width:600px;
    overflow:hidden;
}
.step{
    float:left;
    width:600px;
}
#navigation{
    height:45px;
    background-color:#e9e9e9;
    border-top:1px solid #fff;
    -moz-border-radius:0px 0px 10px 10px;
    -webkit-border-bottom-left-radius:10px;
    -webkit-border-bottom-right-radius:10px;
    border-bottom-left-radius:10px;
    border-bottom-right-radius:10px;
}
#navigation ul{
    list-style:none;
	float:left;
	margin-left:22px;
}
#navigation ul li{
	float:left;
    border-right:1px solid #ccc;
    border-left:1px solid #ccc;
    position:relative;
	margin:0px 2px;
}
ul#navigation li a:hover{
     background-color:#CAE3F2;
}
ul#navigation li a span{
    letter-spacing:2px;
    font-size:11px;
    color:#60ACD8;
    text-shadow: 0 -1px 1px #fff;
}    
</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"--> 

<div id="content">
    <h1>Fancy Sliding Form with jQuery</h1>
    <div id="wrapper">
        <div id="steps">
            <form id="formElem" name="formElem" action="" method="post">
                <fieldset class="step">
                    <legend>Account</legend>
                    <p>
                        <label for="username">User name</label>
                        <input id="username" name="username" />
                    </p>
                    <p>
                        <label for="email">Email</label>
                        <input id="email" name="email" placeholder="info@tympanus.net" type="email" AUTOCOMPLETE=OFF />
                    </p>
                    <p>
                        <label for="password">Password</label>
                        <input id="password" name="password" type="password" AUTOCOMPLETE=OFF />
                    </p>
                </fieldset>
                <fieldset class="step">
                    <legend>Personal Details</legend>
                    <p>
                        <label for="name">Full Name</label>
                        <input id="name" name="name" type="text" AUTOCOMPLETE=OFF />
                    </p>
                    <p>
                        <label for="country">Country</label>
                        <input id="country" name="country" type="text" AUTOCOMPLETE=OFF />
                    </p>
                    <p>
                        <label for="phone">Phone</label>
                        <input id="phone" name="phone" placeholder="e.g. +351215555555" type="tel" AUTOCOMPLETE=OFF />
                    </p>
                    <p>
                        <label for="website">Website</label>
                        <input id="website" name="website" placeholder="e.g. http://www.codrops.com" type="tel" AUTOCOMPLETE=OFF />
                    </p>
                </fieldset>
                <fieldset class="step">
                    <legend>Payment</legend>
                    <p>
                        <label for="cardtype">Card</label>
                        <select id="cardtype" name="cardtype">
                            <option>Visa</option>
                            <option>Mastercard</option>
                            <option>American Express</option>
                        </select>
                    </p>
                    <p>
                        <label for="cardnumber">Card number</label>
                        <input id="cardnumber" name="cardnumber" type="number" AUTOCOMPLETE=OFF />
                    </p>
                    <p>
                        <label for="secure">Security code</label>
                        <input id="secure" name="secure" type="number" AUTOCOMPLETE=OFF />
                    </p>
                    <p>
                        <label for="namecard">Name on Card</label>
                        <input id="namecard" name="namecard" type="text" AUTOCOMPLETE=OFF />
                    </p>
                </fieldset>
                <fieldset class="step">
                    <legend>Settings</legend>
                    <p>
                        <label for="newsletter">Newsletter</label>
                        <select id="newsletter" name="newsletter">
                            <option value="Daily" selected>Daily</option>
                            <option value="Weekly">Weekly</option>
                            <option value="Monthly">Monthly</option>
                            <option value="Never">Never</option>
                        </select>
                    </p>
                    <p>
                        <label for="updates">Updates</label>
                        <select id="updates" name="updates">
                            <option value="1" selected>Package 1</option>
                            <option value="2">Package 2</option>
                            <option value="0">Don't send updates</option>
                        </select>
                    </p>
					<p>
                        <label for="tagname">Newsletter Tag</label>
                        <input id="tagname" name="tagname" type="text" AUTOCOMPLETE=OFF />
                    </p>
                </fieldset>
				<fieldset class="step">
                    <legend>Confirm</legend>
					<p>
						Everything in the form was correctly filled 
						if all the steps have a green checkmark icon.
						A red checkmark icon indicates that some field 
						is missing or filled out with invalid data. In this
						last step the user can confirm the submission of
						the form.
					</p>
                    <p class="submit">
                        <button id="registerButton" type="submit">Register</button>
                    </p>
                </fieldset>
            </form>
        </div>
        <div id="navigation" style="display:none;">
            <ul>
                <li class="selected">
                    <a href="#">Account</a>
                </li>
                <li>
                    <a href="#">Personal Details</a>
                </li>
                <li>
                    <a href="#">Payment</a>
                </li>
                <li>
                    <a href="#">Settings</a>
                </li>
				<li>
                    <a href="#">Confirm</a>
                </li>
            </ul>
        </div>
    </div>
</div>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->



<%