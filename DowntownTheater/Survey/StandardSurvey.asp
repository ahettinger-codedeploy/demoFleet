<%

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 0000
SurveyName = "SurveyName.asp"
BoxOfficeByPass = True

'===============================================

SurveyTitle = "SurveyTitle"
SurveyHeader = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

'===============================================

'Verify that Order Number exists - if not bounce back to default page
'Verify that User Number exists - if so display management tabs

If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If	
Else
	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If	
End If

'============================================================

'Bypass this survey on all Comp Orders
'Bypass this survey for Box Office Users

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

If Session("OrderTypeNumber") <> 1 Then
    If BoxOfficeByPass Then
	    Call Continue
    End If
End If

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
 End Select   

'==========================================================

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" SYSTEM "http://www.w3.org/TR/html4/strict.dtd">

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html xmlns="http://www.w3.org/1999/xhtml"> 

<head>

<title>TIX.com</title>

</head>

<style>
    span.reference{
        position:fixed;
        left:5px;
        top:5px;
        font-size:10px;
        text-shadow:1px 1px 1px #fff;
    }
    span.reference a{
        color:#555;
        text-decoration:none;
		text-transform:uppercase;
    }
    span.reference a:hover{
        color:#000;
        
    }
    h1{
        color:#ccc;
        font-size:36px;
        text-shadow:1px 1px 1px #fff;
        padding:20px;
    }
</style>

</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<div id="content">
    <h1>2011 Standard Survey Form</h1>
    <div id="wrapper">
        <div id="steps">
            <form id="formElem" name="formElem" action method="post">
                <fieldset class="step">
                    <legend>Account</legend>
                    <p>
                        <label for="username">User name</label>
                        <input id="username" name="username">
                    </p>
                    <p>
                        <label for="email">Email</label>
                        <input id="email" name="email" placeholder="info@tympanus.net" type="email" autocomplete="OFF">
                    </p>
                    <p>
                        <label for="password">Password</label>
                        <input id="password" name="password" type="password" autocomplete="OFF">
                    </p>
                </fieldset>
                <fieldset class="step">
                    <legend>Personal Details</legend>
                    <p>
                        <label for="name">Full Name</label>
                        <input id="name" name="name" type="text" autocomplete="OFF">
                    </p>
                    <p>
                        <label for="country">Country</label>
                        <input id="country" name="country" type="text" autocomplete="OFF">
                    </p>
                    <p>
                        <label for="phone">Phone</label>
                        <input id="phone" name="phone" placeholder="e.g. +351215555555" type="tel" autocomplete="OFF">
                    </p>
                    <p>
                        <label for="website">Website</label>
                        <input id="website" name="website" placeholder="e.g. http://www.codrops.com" type="tel" autocomplete="OFF">
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
                        <input id="cardnumber" name="cardnumber" type="number" autocomplete="OFF">
                    </p>
                    <p>
                        <label for="secure">Security code</label>
                        <input id="secure" name="secure" type="number" autocomplete="OFF">
                    </p>
                    <p>
                        <label for="namecard">Name on Card</label>
                        <input id="namecard" name="namecard" type="text" autocomplete="OFF">
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
                        <input id="tagname" name="tagname" type="text" autocomplete="OFF">
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
                    <a href="http://tympanus.net/Tutorials/FancySlidingForm/#">Account</a>
                </li>
                <li>
                    <a href="http://tympanus.net/Tutorials/FancySlidingForm/#">Personal Details</a>
                </li>
                <li>
                    <a href="http://tympanus.net/Tutorials/FancySlidingForm/#">Payment</a>
                </li>
                <li>
                    <a href="http://tympanus.net/Tutorials/FancySlidingForm/#">Settings</a>
                </li>
				<li>
                    <a href="http://tympanus.net/Tutorials/FancySlidingForm/#">Confirm</a>
                </li>
            </ul>
        </div>
    </div>
</div>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

