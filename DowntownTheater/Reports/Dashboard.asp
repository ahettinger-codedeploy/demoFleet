<%

'CHANGE LOG - Inception
'SSR (1/31/2012)
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
SurveyName = "Survey.asp"
BoxOfficeByPass = False

'===============================================

SurveyTitle = "Sed Perspiciatis"
SurveyHeader = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium"
SurveyFooter = "Sed ut perspiciatis unde omnis"

'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomRightCorner16.txt"
End If

'============================================================
 
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
	
Sub SurveyForm

%>

<!doctype html>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html lang="en-us">
<head>
	<meta charset="utf-8">
	
	<title>White Label - a full featured Admin Skin</title>
	
	<meta name="description" content="">
	<meta name="author" content="revaxarts.com">
	
	
	<!-- Google Font and style definitions -->
	<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=PT+Sans:regular,bold">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/ui.spinner.css">
	
	<!-- include the skins (change to dark if you like) -->
	<link rel="stylesheet" href="css/light/theme.css" id="themestyle">
	<!-- <link rel="stylesheet" href="css/dark/theme.css" id="themestyle"> -->
	
	<!--[if lt IE 9]>
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<link rel="stylesheet" href="css/ie.css">
	<![endif]-->
	
	
	<!-- Use Google CDN for jQuery and jQuery UI -->
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.12/jquery-ui.min.js"></script>
	
	<!-- Loading JS Files this way is not recommended! Merge them but keep their order -->
	
	<!-- some basic functions -->
	<script src="js/functions.js"></script>
		
	<!-- all Third Party Plugins and Whitelabel Plugins -->
	<script src="js/plugins.js"></script>
	<script src="js/editor.js"></script>
	<script src="js/calendar.js"></script>
	<script src="js/flot.js"></script>
	<script src="js/elfinder.js"></script>
	<script src="js/datatables.js"></script>
	<script src="js/wl_Alert.js"></script>
	<script src="js/wl_Autocomplete.js"></script>
	<script src="js/wl_Breadcrumb.js"></script>
	<script src="js/wl_Calendar.js"></script>
	<script src="js/wl_Chart.js"></script>
	<script src="js/wl_Color.js"></script>
	<script src="js/wl_Date.js"></script>
	<script src="js/wl_Editor.js"></script>
	<script src="js/wl_File.js"></script>
	<script src="js/wl_Dialog.js"></script>
	<script src="js/wl_Fileexplorer.js"></script>
	<script src="js/wl_Form.js"></script>
	<script src="js/wl_Gallery.js"></script>
	<script src="js/wl_Multiselect.js"></script>
	<script src="js/wl_Number.js"></script>
	<script src="js/wl_Password.js"></script>
	<script src="js/wl_Slider.js"></script>
	<script src="js/wl_Store.js"></script>
	<script src="js/wl_Time.js"></script>
	<script src="js/wl_Valid.js"></script>
	<script src="js/wl_Widget.js"></script>
	<script src="js/ui.spinner.js"></script>
	
	<!-- configuration to overwrite settings -->
	<script src="js/config.js"></script>
		
	<!-- the script which handles all the access to plugins etc... -->
	<script src="js/script.js"></script>
	
	<script type="text/javascript">
		jQuery().ready(function($) {
			$('#actcount').spinner({ min: 2, max: 20 });
		});
	</script>
	
	<script type="text/javascript">
		jQuery().ready(function($) {	
			$('.link').click(function(e){ 
			e.preventDefault(); 
			var content = $(this).attr('rel'); 
			$('.active').removeClass('active'); 
			$(this).addClass('active'); 
			$('.content').hide(); 
			$('#'+content).show(); 
		}); 
		</script>
		
	
</head>
<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->		
			
		<section id="content">			
			<div class="g12">		
				<form id="form" action="submit.php" method="post" autocomplete="off">
				
					<fieldset>
						<label>Act Count</label>
						
						<section><label for="text_field">How Many Acts?</label>
							<div><input id="actcount" name="actcount" type="number" class="integer" value="20" /></div>
						</section>
					</fieldset>
					
					<fieldset>
						<label>Ticket Type</label>
						
						<section>
							<label for="multiselect">Select valid ticket types</label>
							<div>					
								<select name="multiselect" id="multiselect" multiple>
										<option value="artichoke">Adult</option>
										<option value="beans">Child</option>
										<option value="broccoli">Senior</option>
										<option value="carrot">Student</option>
										<option value="corn">Military</option>
										<option value="chicory">Comp</option>
										<option value="kohlrabi">General Admission</option>
										<option value="melon">Senior (65 and over)</option>
										<option value="onion">Student (12 and over)</option>
										<option value="potato">VIP</option>
										<option value="pumpkin">Comp</option>
										<option value="spinach">Youth</option>
										<option value="tomato">Member</option>
								</select>
							</div>
						</section>
						
					</fieldset>
					
					<fieldset>
						<label>Discount Type</label>
						
						<section>
							<label for="text_field">What Type of Discount?</label>
							<div>
								<a class="link" href="#" rel="div1">Link 1</a> 
								<a class="link" href="#" rel="div2">Link 2</a> 
								<a class="link" href="#" rel="div3">Link 3</a> 

								<div id="div1">Content 1</div> 
								<div id="div2">Content 2</div> 
								<div id="div3">Content 3</div> 
							</div>
						</section>
					</fieldset>
					

				
					<fieldset>
						<label>Text Fields</label>
						<section><label for="text_field">Text Field</label>
							<div><input type="text" id="text_field" name="text_field"></div>
						</section>
						<section><label for="text_tooltip">Field with Tooltip</label>
							<div><input type="text" id="text_tooltip" name="text_tooltip" title="A Tooltip">
							<span>Just specify a title attribut to get a Tooltip</span>
							</div>
						</section>
						<section><label for="text_tooltip">Placeholder Text</label>
							<div><input type="text" id="text_placeholder" name="text_placeholder" placeholder="your placeholder text">
							<span>use the placeholder attribute <code>placeholder="your placeholder text"</code></span>
							</div>
						</section>
						<section><label for="textarea">Textarea</label>
							<div><textarea id="textarea" name="textarea" rows="10"></textarea></div>
						</section>
						<section><label for="textarea_auto">Autogrow Textarea<br><span>Some extra information</span></label>
							<div><textarea id="textarea_auto" name="textarea_auto" data-autogrow="true"></textarea>
								<span>will expand after you hit the bottom edge</span>
							</div>
						</section>
						<section><label for="textarea_auto">WYSIWYG Editor<br><span>(W)hat (y)ou (s)ee (i)s (w)hat (y)ou (g)et</span></label>
							<div><textarea id="textarea_wysiwyg" name="textarea_wysiwyg" class="html" rows="12"></textarea>
							</div>
						</section>
					</fieldset>
					
					<div class="alert info">Some Fields are MouseWheel enabled!</div>
					<fieldset>
					<label>Numbers</label>
						<section><label for="integer">Integer</label>
							<div><input id="integer" name="integer" type="number" class="integer">
							<br><span>This must be an integer</span>
							</div>
						</section>
						<section><label for="decimal">Decimal</label>
							<div><input id="decimal" name="decimal" type="number" class="decimal">
							<br><span>This must be a decimal number</span>
							</div>
						</section>
						<section><label for="integer_minmax">Define min and max values</label>
							<div><input id="integer_minmax" name="integer_minmax" type="number" class="integer" min="20" max="40"><input id="decimal_minmax" name="decimal_minmax" type="number" class="decimal" min="-20" max="20">
							<br><span>Define ranges with <code>data-min="20" data-max="40"</code> and <code>data-min="-20" data-max="20"</code></span>
							</div>
						</section>
						<section><label for="integer_minmax">Define steps<br><span>only for mousewheel</span></label>
							<div><input id="integer_steps" name="integer_steps" type="number" class="integer" data-step="50" title="Use your MouseWheel!"><input id="decimal_steps" name="decimal_steps" type="number" class="decimal" step="0.04" data-decimals="4">
							<br><span>Define steps with <code>data-step="50"</code> and <code>data-step="0.04" data-decimals="4"</code></span>
							</div>
						</section>
						<section><label for="integer_start_from">Define a start<br><span>only for mousewheel</span></label>
							<div><input id="integer_start_from" name="integer_start_from" type="number" class="integer" data-start="1900" min="1900"> - <input id="integer_start_to" name="integer_start_to" type="number" class="integer" data-start="2000" max="2011">
							<br><span>Simulate Year Fields with <code>data-start="1900" data-min="1900"</code> and <code>data-start="2000" data-max="2011"</code></span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Validation <span>with regular expressions</span></label>
						<section><label for="regex_letter">Only Letters</label>
							<div><input id="regex_letter" name="regex_letter" type="text" data-regex="^[a-zA-Z ]+$"><span>Regular Expression: <code>data-regex="^[a-zA-Z ]+$"</code></span></div>
						</section>
						<section><label for="regex_number">Only Numbers</label>
							<div><input id="regex_number" name="regex_number" type="text" data-regex="^[0-9 ]+$"><span>Regular Expression: <code>data-regex="^[0-9 ]+$"</code></span></div>
						</section>
						<section><label for="email">Email</label>
							<div><input id="email" name="email" type="email"></div>
						</section>
						<section><label for="url">Url</label>
							<div><input id="url" name="url" type="url" placeholder="http://">
							<br><span>Instant is off for URLs. Use <code>data-instant="true"</code> for instant validation</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>File Upload <span>not all files are allowed in the livepreview</span></label>
						<section><label for="file_upload">Single File Upload<br><span>your uploaded data will get delete within 1 hour</span></label>
							<div><input type="file" id="file_upload" name="file_upload"></div>
						</section>
						<section><label for="file_upload_multiple">Multi File Upload</label>
							<div><input type="file" id="file_upload_multiple" name="file_upload_multiple" multiple>
							</div>
						</section>
						<section><label for="file_upload_manual">Manual start<br><span>only jpgs and gifs are allowed with less than 100 kb</span></label>
							<div><input type="file" id="file_upload_manual" name="file_upload_manual" data-auto-upload="false" multiple data-allowed-extensions="[jpg,jpeg,gif]" data-max-file-size="100000">
							<span>drag &amp; drop is currenlty only supported on Firefox 3.6+ Safari 5+ and Chrome 6+</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Other Fields</label>
						<section><label for="password">Password<br><span>with confirmation</span></label>
							<div><input type="password" id="password" name="password"></div>
						</section>
						<section><label for="color">Color</label>
							<div><input type="text" id="color" name="color" class="color"><br>
							<span>use mousewheel for brightness, mousewheel+shift for saturation and mousewheel+shift+alt for hue (not supported in all browsers)</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Autocomplete</label>
						<section><label for="autocomplete">Simple Autocomplete</label>
							<div><input id="autocomplete" name="autocomplete" type="text" class="autocomplete">
							<br><span>the source is defined within the call <code>$(selector).wl_Autocomplete({source:[...,...]});</code></span>
							</div>
						</section>
						<section><label for="autocomplete_inline">Autocomplete with inline data</label>
							<div><input id="autocomplete_inline" name="autocomplete_inline" type="text" class="autocomplete" data-source="[abc,def,ghi,jkl,mno,pqr,stu,vwx,yz]">
							<br><span>inline data with <code>data-source="[abc,def,ghi,jkl,mno,pqr,stu,vwx,yz]"</code></span>
							</div>
						</section>
						<section><label for="autocomplete_function">Autocomplete with user function</label>
							<div><input id="autocomplete_function" name="autocomplete_function" type="text" class="autocomplete" data-source="myAutocompleteFunction">
							<br><span>source is a user function with <code>data-source="myAutocompleteFunction"</code>. Function must return an array</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Date &amp; Time</label>
						<section><label for="date">Simple Date Field</label>
							<div><input id="date" name="date" type="text" class="date">
							<br><span>You can define displayed format within the settings. yyyy-mm-dd will always be used on submit</span>
							</div>
						</section>
						<section><label for="datetime">Date Field with Time<br><span>mousewheel enabled!</span></label>
							<div><input id="datetime" name="datetime" type="text" class="date"><input type="text" class="time" data-connect="datetime">
							<br><span>These fields get converted to a single date value on submit (yyyy-mm-dd hh:mm)</span>
							</div>
						</section>
						<section><label for="predefined_time">Predefined Time</label>
							<div><input id="predefined_time" name="predefined_time" type="text" class="date" data-value="+7"><input type="text" class="time" data-connect="predefined_time" data-value="now">
							<br><span>This fields always display the date in one week with <code>data-value="+7"</code> for the date field and <code>data-value="now"</code> for the time field</span>
							</div>
						</section>
						<section><label for="time_only_12">Time only</label>
							<div><input type="text" class="time" id="time_only_12" data-timeformat="12"><input type="text" class="time" id="time_only_24" title="Hold down the shift key to scroll hours!">
							<br><span>Use 12h timeformat with <code>data-timeformat="12"</code>. Both fields are always in 24h format on submit</span>
							</div>
						</section>
						<section><label>Inline Date Field<br><span>mousewheel enabled! Use shift key to scroll trough month</span></label>
							<div><div class="date" id="inline_date" data-value="tomorrow"></div>
							<br><span>yyyy-mm-dd on submit. Can't be undefined</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Sliders <span>working on iPhone and iPad!</span></label>
						<section><label>Slider</label>
							<div><div class="slider" id="slider"></div></div>
						</section>
						<section><label>vertical Sliders</label>
							<div>
								<div>
									<div class="slider" data-connect="slider_v_1" data-orientation="vertical" data-range="min"></div>
									<div class="slider" data-connect="slider_v_2" data-orientation="vertical" data-range="min"></div>
									<div class="slider" data-connect="slider_v_3" data-orientation="vertical" data-range="min"></div>
									<div class="slider" data-connect="slider_v_4" data-orientation="vertical" data-range="min"></div>
									<div class="slider" data-connect="slider_v_5" data-orientation="vertical" data-range="min"></div>
								</div>
								<div>
									<input type="number" class="integer w_25p" id="slider_v_1">
									<input type="number" class="integer w_25p" id="slider_v_2">
									<input type="number" class="integer w_25p" id="slider_v_3">
									<input type="number" class="integer w_25p" id="slider_v_4">
									<input type="number" class="integer w_25p" id="slider_v_5">
								</div>
							</div>
						</section>
						<section><label>Slider with tooltip</label>
							<div><div class="slider" id="slider_tooltip" data-tooltip="true" data-range="min"></div></div>
						</section>
						<section><label>Slider with custom tooltip Pattern</label>
							<div><div class="slider" id="slider_tooltip_pattern" data-tooltip="true" data-orientation="vertical" data-tooltip-pattern="current value is $ %n,-" data-range="min"></div><br><span>use <code>data-tooltip-pattern="current value is $ %n,-"</code></span></div>
						</section>
						<section><label>Slider with connected input field</label>
							<div><div class="slider" data-connect="slider_connect" data-value="30" data-range="min"></div>
							<input type="number" class="integer" id="slider_connect"><span>set the start value within the input or with <code>data-value="30"</code> within the slider</span>
							</div>
						</section>
						<section><label>Range Slider</label>
							<div><div id="slider_range" class="slider" data-range="true" data-max="1000" data-values="[350,650]"></div>
							</div>
						</section>
						<section><label>Connected Range Slider</label>
							<div><div class="slider" data-range="true" data-max="1000" data-values="[250,750]" data-connect="[slider_range_from,slider_range_to]"></div>
							<input type="number" class="integer" id="slider_range_from">
							<input type="number" class="integer" id="slider_range_to">
							<br><span>Use the shift key for faster scrolling</span>
							</div>
						</section>
						<section><label>Custom Callback</label>
							<div><div class="slider" id="slider_callback"></div>
								<div id="slider_callback_bar" style="background:#aaa;padding:2px;">Scroll!</div>
							</div>
						</section>
					</fieldset>
					
					<fieldset>
						<label>Other Basic Fields</label>
						<section>
							<label>Checkboxes</label>
							<div>
								<input type="checkbox" id="apples_check" ><label for="apples_check">Apples</label>
								<input type="checkbox" id="bananas_check" ><label for="bananas_check">Bananas</label>
								<input type="checkbox" id="oranges_check" ><label for="oranges_check">Oranges</label>
							</div>
						</section>
						<section>
							<label>Radio Buttons</label>
							<div>
								<input type="radio" id="apples_radio" name="radio" value="Apples" ><label for="apples_radio">Apples</label>
								<input type="radio" id="bananas_radio" name="radio" value="Bananas" ><label for="bananas_radio">Bananas</label>
								<input type="radio" id="oranges_radio" name="radio" ><label for="oranges_radio">Oranges</label>
							</div>
						</section>
						<section>
							<label for="dropdown_vegetables">Dropdown</label>
							<div>					
								<select name="dropdown_vegetables" id="dropdown_vegetables">
									<optgroup label="Vegetables">
										<option value="Broccoli">Broccoli</option>
										<option value="Corn">Corn</option>
										<option value="Spinach">Spinach</option>
									</optgroup>
								</select>
								<select name="dropdown_fruits" id="dropdown_fruits">
									<optgroup label="Fruits">
										<option value="Apples">Apples</option>
										<option value="Bananas">Bananas</option>
										<option value="Oranges">Oranges</option>
									</optgroup>
								</select>
							</div>
						</section>
						<section>
							<label for="multiselect">Multiple Select<br><span>use ctrl + shift key. The selection(right) is sortable with drag n' drop</span></label>
							<div>					
								<select name="multiselect" id="multiselect" multiple>
										<option value="artichoke">Artichoke</option>
										<option value="beans">Beans</option>
										<option value="broccoli">Broccoli</option>
										<option value="carrot">Carrot</option>
										<option value="corn">Corn</option>
										<option value="chicory">Chicory</option>
										<option value="kohlrabi">Kohlrabi</option>
										<option value="melon">Melon</option>
										<option value="onion">Onion</option>
										<option value="potato">Potato</option>
										<option value="pumpkin">Pumpkin</option>
										<option value="spinach">Spinach</option>
										<option value="tomato">Tomato</option>
								</select>
							</div>
						</section>
					</fieldset>
					
					<fieldset>
						<label>Required Fields</label>
						<section><label for="required_field">Required Text Field</label>
							<div><input type="text" id="required_field" name="required_field" required></div>
						</section>
						<section><label for="required_field_msg">Required Text Field with custom error message</label>
							<div><input type="text" id="required_field_msg" name="required_field_msg" required data-errortext="This is an custom error text!">
							<br><span>use <code>data-errortext="This is an custom error text!"</code> for custom message</span>
							</div>
						</section>
						<section><label for="required_valid_field">Required Field with validation</label>
							<div>
							<span>Please type in 'OK':</span><br>
							<input type="text" id="required_valid_field" name="required_valid_field" required data-regex="^OK$" class="w_10">
							</div>
						</section>
						<section>
							<div>
								<input type="checkbox" id="agreed" data-errortext="This is mandatory!" required><label for="agreed">I agree that this form is awesome ;)</label>
							</div>
						</section>
						<section>
							<div><button class="reset">Reset</button><button class="submit" name="submitbuttonname" value="submitbuttonvalue">Submit</button></div>
						</section>
					</fieldset>
				</form>	
				</div>
		</section><!-- end div #content -->
		<footer>Copyright by revaxarts.com 2011</footer>
		
		
<!--#INCLUDE virtual="FooterInclude.asp"-->		
</body>
</html>

<%

End Sub ' SurveyForm

'==========================================================

Sub UpdateSurveyAnswer

If Session("OrderNumber") <> "" Then

	For AnswerNumber = 1 To NumQuestions
		If Clean(Request("Answer" & AnswerNumber)) <> "" Then
				For Each Item IN Request("Answer" & AnswerNumber)
					If Item <> "" Then
						SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Question(AnswerNumber) & "')"
						Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
					End If
				Next
		End If
	Next
	
Else

   Call Continue

End If

End Sub

'==========================================================

Sub Continue

    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
        
End Sub 'Continue

'==========================================================

%>