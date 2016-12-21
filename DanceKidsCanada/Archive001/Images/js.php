	var req;
	var td = null;
	var ret = "";
	var url = 'http://www.dancekidscanada.com/news/remote.php';
	var counter =0;
	var xml = '';
	var what ='';
	function DoCallback(data)
	{
		// branch for native XMLHttpRequest object
		if (window.XMLHttpRequest) {
			req = new XMLHttpRequest();
			req.onreadystatechange = processReqChange;
			req.open('POST', url, true);
			req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			req.send(data);
		// branch for IE/Windows ActiveX version
		} else if (window.ActiveXObject) {
			req = new ActiveXObject('Microsoft.XMLHTTP')
			if (req) {
				req.onreadystatechange = processReqChange;
				req.open('POST', url, true);
				req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				req.send(data);
			}
		}
	}

	function processReqChange() {
		// only if req shows 'loaded'
		if (req.readyState == 4) {
			// only if 'OK'
			if (req.status == 200) {
				 eval(what);
			} else {
				alert('There was a problem retrieving the XML data:\n' +
					req.responseText);
			}
		}
	}

function clearFont()
{
	code = wysiwyg.getHTMLContent();
	code = code.replace(/<font([^>])*face="([^"]*)"/gi,"<font $1");
	code = code.replace(/<([\w]+) style="([^"]*)font-family:[^;"]*[;]?([^"]*)"/gi, "<$1 style=\"$2 $3\"");
	code = code.replace(/<([\w]+) style=" "/gi, "<$1 ");
	wysiwyg.writeHTMLContent(code);

}

function reloadCaptchaImg(){
	window.location.reload();
}

function CheckAdvancedSearchForm()
{
	if(document.getElementById("AQuery").value == "")
	{
		alert("Please enter your search query.");
		document.getElementById("AQuery").focus();
		return false;
	}

	if(document.getElementById("searchArticles").checked == false && document.getElementById("searchComments").checked == false && document.getElementById("searchBlogs").checked == false && document.getElementById("searchPages").checked == false && document.getElementById("searchNews").checked == false)
	{
		alert("Please select a search area.");

		return false;
	}

	if(document.getElementById("searchAuthor").checked == false && document.getElementById("searchContentBody").checked == false && document.getElementById("searchTitle").checked == false)
	{
		alert("Please select a search field.");

		return false;
	}



	return true;
}
function swapComment(){
	if(document.getElementById("addCommentBox").checked == true){
	document.getElementById("commentField").style.display = "";	
	}else{
		document.getElementById("commentField").style.display = "none";	
	}
	return true;
}
function SwitchField(ArticleType)
{
	articleType = ArticleType;

	switch(ArticleType)
	{
		case 0: // Article
		{
			document.getElementById("FileRow").style.display = "";
			document.getElementById("ArticleURLRow").style.display = "none";
			break;
		}
		case 1: // Summary Only
		{
			document.getElementById("FileRow").style.display = "none";
			document.getElementById("ArticleURLRow").style.display = "none";
			break;
		}
		case 2: // Link
		{
			document.getElementById("FileRow").style.display = "none";
			document.getElementById("ArticleURLRow").style.display = "";
			break;
		}
	}
}

function CheckUsernameExists(){
	if(document.getElementById('Username').value.length > 0){
		what = "CheckUsernameReturn(req.responseXML)";
		DoCallback("w=CheckUsername" + "&Username=" + document.getElementById('Username').value	);
		return true;
	}else{
		alert('Please enter a username to check its availability.');
	}
}


function CheckLength(textarea) {
	var MaxLength = 500;

	biolen = textarea.value.length;

	if (biolen > MaxLength) {
		textarea.value = textarea.value.substr(0, MaxLength);
		return;
	}

	var RemainingLength = (MaxLength - biolen);
	limitcheck = 'You can type another ' + RemainingLength + ' characters into your biography.';
	document.getElementById('biolength').innerHTML = limitcheck;
}

function CheckUsernameReturn(returned){
		
		// get the status of the ajax response
		// our getXMLData function relies on a global variable called 'xml'
		// so we just put the response into that.
		xml = returned.documentElement;
		var status = getXMLData('status');

		if(status == 1){
			// user account was successfully create
			document.getElementById("UsernameCheck").innerHTML =  getXMLData('message');
			return true;
			
		}else{
			document.getElementById("UsernameCheck").innerHTML = 'There was an error checking that username.';
			return false;
		}

}

function CheckSubmitArticleForm()
{
	if(document.getElementById("Title").value == "")
	{
		alert("Please enter an article title.");
		document.getElementById("Title").focus();
		return false;
	}

	if(document.getElementById("Summary").value == "")
	{
		alert("Please enter a summary.");
		document.getElementById("Summary").focus();
		return false;
	}

	if(document.getElementById("ACategories").selectedIndex == -1)
	{
		alert("Please select a category.");
		document.getElementById("ACategories").focus();
		return false;
	}

	
	return true;
}


function CheckSubmitBlogForm(){
	
	if(document.getElementById("Title").value == "")
	{
		alert("Please enter a title");
		document.getElementById("Title").focus();
		return false;
	}

	if(wysiwyg.getHTMLContent() == "&nbsp;" || wysiwyg.getHTMLContent() == "<br/>" || wysiwyg.getHTMLContent() == "<br/> " || wysiwyg.getHTMLContent() == "" || wysiwyg.getHTMLContent() == "&nbsp;<br/>" || wysiwyg.getHTMLContent() == "<br/>&nbsp;")
	{
		alert('Please enter some content for your blog post');
		return false;
	}
}

function CheckSubmitArticleForm2()
{

	atype = document.getElementById('ArticleType');
	articleType = atype.options[atype.selectedIndex].value;
	
	if(document.getElementById("Title").value == "")
	{
		alert("Please enter an article title.");
		document.getElementById("Title").focus();
		return false;
	}

	if(document.getElementById("Summary").value == "")
	{
		alert("Please enter a summary.");
		document.getElementById("Summary").focus();
		return false;
	}

	if(document.getElementById("ACategories").selectedIndex == -1)
	{
		alert("Please select a category.");
		document.getElementById("ACategories").focus();
		return false;
	}

	if(articleType == 1) // full article
	{
		if(document.getElementById("PageTitle").value == "")
		{
			alert("You need to insert a both an article title and a page title.");
			document.getElementById("PageTitle").focus();
			return false;
		}

		if(wysiwyg.getHTMLContent() == "&nbsp;" || wysiwyg.getHTMLContent() == "<br/>" || wysiwyg.getHTMLContent() == "" || wysiwyg.getHTMLContent() == "&nbsp;<br/>")
		{
			alert('Please enter some content for the article into the editor.');
			return false;
		}

	}

	return true;
}
function CheckLoginForm()
{
	if(document.getElementById("Username").value == "")
	{
		alert("Please enter your username.");
		document.getElementById("Username").focus();
		return false;
	}

	if(document.getElementById("Password").value == "")
	{
		alert("Please enter your password.");
		document.getElementById("Password").focus();
		return false;
	}

	return true;
}

function CheckAuthorForm()
{
	

	if(document.getElementById("Username").value == "")
	{
		alert("Please enter your username.");
		document.getElementById("Username").focus();
		return false;
	}

	if(document.getElementById("Password").value == "")
	{
		alert("Please enter your password.");
		document.getElementById("Password").focus();
		return false;
	}

	if(document.getElementById("Password").value != document.getElementById("PasswordConfirm").value)
	{
		alert("Your passwords don't match.");
		document.getElementById("Password").focus();
		document.getElementById("Password").select();
		return false;
	}

	if(document.getElementById("FirstName").value == "")
	{
		alert("Please enter your first name.");
		document.getElementById("FirstName").focus();
		return false;
	}

	if(document.getElementById("LastName").value == "")
	{
		alert("Please enter your last name.");
		document.getElementById("LastName").focus();
		return false;
	}

	if(document.getElementById("Email2").value == "")
	{
		alert("Please enter your email address.");
		document.getElementById("Email2").focus();
		return false;
	}
	
	if(document.getElementById("Email2").value.indexOf('.') == -1 || document.getElementById("Email2").value.indexOf('@') == -1)
			{
				alert('This email address is not valid.');
				document.getElementById("Email2").focus();
				document.getElementById("Email2").select();
				return false;
			}

	if(document.getElementById("Biography").value == "")
	{
		alert("Please enter your biography.");
		document.getElementById("Biography").focus();
		return false;
	}

	return true;
}


function CheckUserForm()
{
	if(document.getElementById("Username").value == "")
	{
		alert("Please enter your username.");
		document.getElementById("Username").focus();
		return false;
	}

	if(document.getElementById("Password").value == "")
	{
		alert("Please enter your password.");
		document.getElementById("Password").focus();
		return false;
	}

	if(document.getElementById("Password").value != document.getElementById("PasswordConfirm").value)
	{
		alert("Your passwords don't match.");
		document.getElementById("Password").focus();
		document.getElementById("Password").select();
		return false;
	}

	if(document.getElementById("FirstName").value == "")
	{
		alert("Please enter your first name.");
		document.getElementById("FirstName").focus();
		return false;
	}

	if(document.getElementById("LastName").value == "")
	{
		alert("Please enter your last name.");
		document.getElementById("LastName").focus();
		return false;
	}

	if(document.getElementById("Email2").value == "")
	{
		alert("Please enter your email address.");
		document.getElementById("Email2").focus();
		return false;
	}
	
	if(document.getElementById("Email2").value.indexOf('.') == -1 || document.getElementById("Email2").value.indexOf('@') == -1)
	{
		alert('This email address is not valid.');
		document.getElementById("Email2").focus();
		document.getElementById("Email2").select();
		return false;
	}

	
	return true;
}

function UserAccountReturn(returned){
		
		// get the status of the ajax response
		// our getXMLData function relies on a global variable called 'xml'
		// so we just put the response into that.
		xml = returned.documentElement;
		var status = getXMLData('status');

		if(status == 1){
			// user account was successfully create
			document.getElementById("custom").value = getXMLData('usertoken');
			document.getElementById("UserForm").submit();
			return true;
			
		}else{
			var message = getXMLData('message');
			alert(message);
			return false;
		}

}

function isdefined(variable)
{
    return eval('(typeof('+variable+') != "undefined");');
}

function getXMLData(name){
	// we rely on a global variable called 'xml'
	if(isdefined('xml')){
		return xml.getElementsByTagName(name)[0].firstChild.data;
	}else{
		return '';
	}
}

function emailToFriend(ArticleLink)
{
	var t = (screen.availHeight/2) - (485/2);
	var l = (screen.availWidth/2) - (605/2);
	var emailWin = window.open(ArticleLink+"/articleemail", "emailWin", "scrollbars=yes,toolbar=1,statusbar=0,width=605,height=485,top="+t+",left="+l);
}

function CheckArticleCommentForm()
{
	if(document.getElementById('ArticleRating_3')){
		var sel = false;
		var ok = false;

		for(i = 1; i < 6; i++)
		{
			eval("sel = document.getElementById('ArticleRating_"+i+"').checked;");

			if(sel)
			ok = true;
		}

		if(!ok){
			alert("Please select a rating for this article.");
			return false;
		}
	}

	if(document.getElementById('ArticleComment')){
		if(document.getElementById('ArticleComment').value.length < 3){
			alert('Please enter a comment.');
			return false;
		}
	}

	if('0' == '1'){
		if(document.getElementById('FromEmail').value.length < 3){
			alert('Please enter your email address. It will not be published anywhere on the site.');
			return false;
		}
	}

	if('0' == '1'){
		if(document.getElementById('FromName').value.length < 3){
			alert('Please enter your name.');
			return false;
		}
	}


	return true;
}


function CheckBlogCommentForm()
{
	if(document.getElementById('ArticleComment')){
		if(document.getElementById('ArticleComment').value.length < 3){
			alert('Please enter a comment.');
			return false;
		}
	}

	if('0' == '1'){
		if(document.getElementById('FromEmail').value.length < 3){
			alert('Please enter your email address. It will not be published anywhere on the site.');
			return false;
		}
	}

	if('0' == '1'){
		if(document.getElementById('FromName').value.length < 3){
			alert('Please enter your name.');
			return false;
		}
	}


	return true;
}

function CheckArticleCommentForm1()
{
	var sel = false;
	var ok = false;

	for(i = 1; i < 6; i++)
	{
		eval("sel = document.getElementById('ArticleRating_"+i+"').checked;");

		if(sel)
		ok = true;
	}

	if(ok)
	{
		if(document.getElementById("addCommentBox").checked == 1){
			if(document.getElementById("ArticleComment").value == "")
			{
				alert("Please enter a comment.");
				document.getElementById("ArticleComment").focus();
				return false;
			}
			else
			{
				return true;
			}
		}
		
	}
	else
	{
		alert("Please select a rating for this article.");
		return false;
	}
}

function CheckArticleCommentForm2()
{
	var sel = false;
	var ok = false;


		if(document.getElementById("ArticleComment").value == "")
		{
			alert("Please enter a comment.");
			document.getElementById("addCommentBox").checked = true;
			swapComment();
			document.getElementById("ArticleComment").focus();
			return false;
		}
		else
		{
			return true;
		}
	
}

function CheckEmailForm(frm)
{
	if(frm.YourName.value == "")
	{
		alert("Please enter your name.");
		frm.YourName.focus();
		return false;
	}

	if(frm.YourEmail.value == "")
	{
		alert("Please enter your email address.");
		frm.YourEmail.focus();
		return false;
	}

	if(frm.YourEmail.value.indexOf(".") == -1 || frm.YourEmail.value.indexOf("@") == -1)
	{
		alert("Your email address is invalid.");
		frm.YourEmail.focus();
		return false;
	}

	if(frm.FriendsName.value == "")
	{
		alert("Please enter your friend\'s name.");
		frm.FriendsName.focus();
		return false;
	}

	if(frm.FriendsEmail.value == "")
	{
		alert("Please enter your friend\'s email address.");
		frm.FriendsEmail.focus();
		return false;
	}

	if(frm.FriendsEmail.value.indexOf(".") == -1 || frm.FriendsEmail.value.indexOf("@") == -1)
	{
		alert("Your friend\'s email address is invalid.");
		frm.FriendsEmail.focus();
		return false;
	}

	frm.Message.disabled = false;

	return true;
}

function CheckEditArticleForm() {
	
}

var CurrentReplyBox = 0;

function ReplyToComment(id){
	if(id > 0){
		if(CurrentReplyBox == 0){
			// we're moving from the default position to a comment
			document.getElementById('ReplyToComment'+id).innerHTML = document.getElementById('SubmitCommentForm').innerHTML;
			$('#ReplyToComment'+id).show("normal");
			$('#SubmitCommentForm').hide("normal");
			document.getElementById('SubmitCommentForm').innerHTML = '';
		//	document.getElementById('commentReplyRow').style.display = '';
			document.getElementById('ReplyToCommentLink'+id).style.display = 'none';
			document.getElementById('CancelReplyLink'+id).style.display = '';
			document.getElementById('CommentParentID').value = id;
		} else {
			// we're moving from one comment to another
			document.getElementById('ReplyToComment'+id).innerHTML = document.getElementById('ReplyToComment'+CurrentReplyBox).innerHTML;
			$('#ReplyToComment'+id).show("normal");
			$('#ReplyToComment'+CurrentReplyBox).hide("normal");
			document.getElementById('ReplyToComment'+CurrentReplyBox).innerHTML = '';
			//document.getElementById('commentReplyRow').style.display = '';

			document.getElementById('ReplyToCommentLink'+CurrentReplyBox).style.display = '';
			document.getElementById('CancelReplyLink'+CurrentReplyBox).style.display = 'none';

			document.getElementById('ReplyToCommentLink'+id).style.display = 'none';
			document.getElementById('CancelReplyLink'+id).style.display = '';
			document.getElementById('CommentParentID').value = id;
		}
		
	} else {
		// we are cancelling a reply
		document.getElementById('SubmitCommentForm').innerHTML = document.getElementById('ReplyToComment'+CurrentReplyBox).innerHTML;
		$('#SubmitCommentForm').show("slow");
		$('#ReplyToComment'+CurrentReplyBox).hide("slow");
		document.getElementById('ReplyToComment'+CurrentReplyBox).innerHTML = '';
		//document.getElementById('commentReplyRow').style.display = 'none';
		document.getElementById('ReplyToCommentLink'+CurrentReplyBox).style.display = '';
		document.getElementById('CancelReplyLink'+CurrentReplyBox).style.display = 'none';
		document.getElementById('CommentParentID').value = 0;

	}
	CurrentReplyBox = id;
}


function LoadUploadedImage(){
	var FeatureImageThumbnailName = document.getElementById('FeatureImageThumbnailName').value;
	var FeatureImageName = document.getElementById('FeatureImageName').value;
	document.getElementById('FeatureImageFrame').src = 'http://www.dancekidscanada.com/news/remote.php?w=ArticleImageForm';
	document.getElementById('FeatureImageFrame').style.display = 'none';
	document.getElementById('FeatureImagePreview').src = 'http://www.dancekidscanada.com/news/content_images/'+FeatureImageThumbnailName;
	document.getElementById('FullImageLink').href = 'http://www.dancekidscanada.com/news/content_images/'+FeatureImageName;
	document.getElementById('FeatureImageOptions').style.display = '';
}

function ArticleImageToggle(onlyEnabled){
	var list = new Array;
	list[0] = 'artimage_url_row';
	list[1] = 'artimage_file_row';

	if(onlyEnabled == 'artimage_file_row'){
		document.getElementById('FeatureImageFrame').style.display = '';
	}

	if(onlyEnabled == 'artimage_file_row1'){
		document.getElementById('FeatureImageFrame').style.display = 'none';
		onlyEnabled = 'artimage_file_row';
	}
	
	for(i=0;i<list.length;i++){
		if(onlyEnabled == list[i]){
			document.getElementById(onlyEnabled).style.display = '';
		}else{
			document.getElementById(list[i]).style.display = 'none';
		}
	}
}


function PodcastToggle(onlyEnabled){
	var list = new Array;
	list[0] = 'podcast_url_row';
	list[1] = 'podcast_file_row';
	
	for(i=0;i<list.length;i++){
		if(onlyEnabled == list[i]){
			document.getElementById(onlyEnabled).style.display = '';
		}else{
			document.getElementById(list[i]).style.display = 'none';
		}
	}
}

function checkWhat(){
	if(document.getElementById('searchWhat').value == "searchArticles"){
		document.getElementById('catDiv').style.display = '';
	}else{
		document.getElementById('catDiv').style.display = 'none';
	}
	return true;
}

function CheckSmallSearchForm()
{
	if (document.getElementById('Query').value == '')
	{
		alert('Please enter a search query.');
		document.getElementById('Query').focus();
		document.getElementById('Query').select();
		return false;
	}
	else
	{
		return true;
	}
}


function CheckChangeStyle(object){
	if(DesignMode.enabled == false){
		object.style.backgroundColor="#FFFFCC";
		object.style.cursor="text";
	}
}

function CheckCatAuthForm()
{
	if(document.getElementById("catAuthPass").value == "")
	{
		alert("Please enter a password.");
		document.getElementById("catAuthPass").focus();
		return false;
	}

	return true;
}

function CheckArtAuthForm()
{
	if(document.getElementById("artAuthPass").value == "")
	{
		alert("Please enter a password.");
		document.getElementById("artAuthPass").focus();
		return false;
	}

	return true;
}



function CheckNewsletterForm(){
	if($('#newsletter_first_name').val() == '') {
		alert('You forgot to enter your first name.');
		$('#newsletter_first_name').focus();
		return false;
	}

	if($('#newsletter_email').val().indexOf('@') == -1 || $('#newsletter_email').val().indexOf('.') == -1) {
		alert('Please enter a valid email address, such as john@example.com');
		$('#newsletter_email').focus();
		$('#newsletter_email').select();
		return false;
	}

	return true;
}

function ValidateForm(callback) {
	returnValue = callback();
	if(window.event) {
		window.event.returnValue = returnValue;
	}
	else {
		return returnValue;
	}
}
