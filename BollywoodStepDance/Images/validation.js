String.prototype.trim = function() {
	var a = this.replace(/^\s+/, '');
    return a.replace(/\s+$/, '');
};
function check_field_name(f1){//Checks Name

   switch(f1){
	   
	// Category FORM
     case  "cat_name":
      	alert("Please Enter Name ");
     break;
     
     //Performance Posting
      
      case  "ptitle":
         alert("Please Enter Title");
      break;

	 
	//News Posting
      
      case  "news_title":
         alert("Please Enter Heading");
      break;

	  case  "news_author":
		return false;
      break;
}
   return true;
}

function isempty(f2){//Check If Empty
	if(f2==""){
      return true;
   }
   return false;
}

function validateForm(f1){//Validating Form
   
	var m=f1.elements.length;
	var tel1=/^[\+0-9 ][ 0-9_-]+\d$/;
	var vldname=/^[ a-zA-Z]+$/;
	var pqty=/^[ \d]+$/;
	 var cvvpat=/^[\d]{3,4}$/;
	//var mov1=/^[\d]+.?[\d]+$/;
	var mov1=/\b[0-9]*\.?([0-9]+)\b$/;
	var re_mail = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z])+$/;
	for(var i=0;i<m;i++){
		if(f1.elements[i].type=="text"){//Type Text
			if(isempty(f1.elements[i].value)){//Empty
				if(check_field_name(f1.elements[i].name)){
					f1.elements[i].focus();
					return false;
				}
			}else{//Have Value
				
				if(f1.elements[i].name=="tuser" || f1.elements[i].name=="fuser_name" || f1.elements[i].name=="emp_name" || f1.elements[i].name=="seeker_firstname" || f1.elements[i].name=="seeker_lastname" ||  f1.elements[i].name=="fname" || f1.elements[i].name=="myname"){
					if(!vldname.test(f1.elements[i].value)){
						alert('Name must be an alphabets');
						f1.elements[i].value='';
						f1.elements[i].focus();
						return false;
					}
				}
				
				if(f1.elements[i].name=="username" || f1.elements[i].name=="comp_email" || f1.elements[i].name=="seeker_email" || f1.elements[i].name=="seek_email" || f1.elements[i].name=="emp_email" || f1.elements[i].name=="mymail" || f1.elements[i].name=="user_email" || f1.elements[i].name=="visitor_email" || f1.elements[i].name=="demo_email" || f1.elements[i].name=="emp_email" || f1.elements[i].name=="temail"){
					if(!re_mail.test(f1.elements[i].value)){
						alert('Please Enter a Valid Email');
						f1.elements[i].value='';
						f1.elements[i].focus();
						return false;
					}
				}
				
				if(f1.elements[i].name=="keyword" && f1.elements[i].value=='' && f1.elements[i].value=='-- Type Your Keyword Here --'){
					alert("Please Enter Keyword");
					f1.elements[i].focus();
					return false;
					
				}
	
				if(f1.elements[i].name=="seeker_tel" || f1.elements[i].name=="comp_tel" || f1.elements[i].name=="rest_tel" || f1.elements[i].name=="bd_tel" || f1.elements[i].name=="fs_tel" || f1.elements[i].name=="feature_tel" || f1.elements[i].name=="city_tel" || f1.elements[i].name=="hotel_tel" || f1.elements[i].name=="hospital_tel" || f1.elements[i].name=="exchange_tel" || f1.elements[i].name=="q_tel" || f1.elements[i].name=="ban_comptel" || f1.elements[i].name=="classified_tel" || f1.elements[i].name=="event_tel" || f1.elements[i].name=="offer_tel" || f1.elements[i].name=="pf_tel" || f1.elements[i].name=="auto_tel" || f1.elements[i].name=="vehicle_tel" || f1.elements[i].name=="real_realtor_tel"){
					if (!tel1.test(f1.elements[i].value)) {
						alert("Please Enter Valid Phone Number");
						f1.elements[i].focus();
						return false;
					}
				}
				
				
				if(f1.elements[i].name=="price"  || f1.elements[i].name=="classified_price" || f1.elements[i].name=="range_fld1" || f1.elements[i].name=="range_fld2" || f1.elements[i].name=="prod_weight" || f1.elements[i].name=="cvalue"){
					if (!mov1.test(f1.elements[i].value)) {
						alert("Please Enter Numeric or 0.00 format value");
						f1.elements[i].focus();
						return false;
					}
				}
			}
		}
		
		if(f1.elements[i].type=="password"){//Type Password
	
			if(isempty(f1.elements[i].value)){
				if(check_field_name(f1.elements[i].name)){
					f1.elements[i].focus();
					return false;
				}
			}else{
				
				if(f1.elements[i].name=="cpwd" || f1.elements[i].name=="rpwd" || f1.elements[i].name=="seeker_cpwd" || f1.elements[i].name=="emp_cpwd"){//Confirm Password
					if(f1.elements[i].value!=f1.elements[i-1].value){
						alert('Password Mismatch');
						f1.elements[i].value='';
						f1.elements[i].focus();
						return false;
					}
				}
			}
	
		}
		
		if(f1.elements[i].type=="textarea"){//Type Textarea
			if(f1.elements[i].value==0){
				if(f1.elements[i].name=="enq_desc" || f1.elements[i].name=="fuser_comments" ){
					alert("Please Enter your Comments");
					f1.elements[i].focus();
					return false;
				}
				
				if(f1.elements[i].name=="rdesc"  || f1.elements[i].name=="psdesc" ){
					alert("Please Specify Brief Description");
					f1.elements[i].focus();
					return false;
				}
				
				if(f1.elements[i].name=="job_state"){
					alert("Please Specify State");
					f1.elements[i].focus();
					return false;
				}
				
				if(f1.elements[i].name=="job_city"){
					alert("Please Specify City");
					f1.elements[i].focus();
					return false;
				}

				if(f1.elements[i].name=="comp_address"){
					alert("Please Specify Company Street Address");
					f1.elements[i].focus();
					return false;
				}

				if(f1.elements[i].name=="user_req"){
					alert("Please Specify Your Comments/Query ");
					f1.elements[i].focus();
					return false;
				}

				if(f1.elements[i].name=="seeker_keyskills" ){
					alert("Please Specify Key Skills");
					f1.elements[i].focus();
					return false;
				}

				if(f1.elements[i].name=="comment"){
					alert("Please Specify Your requirement");
					f1.elements[i].focus();
					return false;
				}
				
				if(f1.elements[i].name=="job_desc"){
					alert("Please Specify Brief Job Description");
					f1.elements[i].focus();
					return false;
				}
				
				if(f1.elements[i].name=="seeker_address"){
					alert("Please Specify Address!");
					f1.elements[i].focus();
					return false;
				}
				
				if(f1.elements[i].name=="msg"){
					alert("Please Specify Your Message!");
					f1.elements[i].focus();
					return false;
				}
				
				if(f1.elements[i].name=="news_sdesc"   || f1.elements[i].name=="cat_desc" ){
					alert("Please Write Description");
					f1.elements[i].focus();
					return false;
				}
				
				if(f1.elements[i].name=="tdesc"){
					alert("Please Specify Your Testimonial");
					f1.elements[i].focus();
					return false;
				}
				
				if(f1.elements[i].name=="meta_title"){
					alert("Please  write  Meta Title");
					f1.elements[i].focus();
					return false;
				}
				if(f1.elements[i].name=="meta_key"){
					alert("Please  write  Meta Key");
					f1.elements[i].focus();
					return false;
				}
			}
		}
		
		if(f1.elements[i].type=="select-one"){//Type Select Box
			
			if(f1.elements[i].name=="country" || f1.elements[i].name=="seeker_country" || f1.elements[i].name=="emp_country"  || f1.elements[i].name=="user_country"){
				if(f1.elements[i].options[f1.elements[i].selectedIndex].value==''){
					alert("Please Select Country");
					f1.elements[i].focus();
					return false;
				}
			}
			
			if(f1.elements[i].name=="seeker_gender" || f1.elements[i].name=="candidate_gender"){
				if(f1.elements[i].options[f1.elements[i].selectedIndex].value==''){
					alert("Please Select Gender");
					f1.elements[i].focus();
					return false;
				}
			}
			
			if(f1.elements[i].name=="seeker_age" || f1.elements[i].name=="candidate_age"){
				if(f1.elements[i].options[f1.elements[i].selectedIndex].value==''){
					alert("Please Select Age");
					f1.elements[i].focus();
					return false;
				}
			}
			
			if(f1.elements[i].name=="seeker_cur_status"){
				if(f1.elements[i].options[f1.elements[i].selectedIndex].value==''){
					alert("Please Select Your Currnet Status");
					f1.elements[i].focus();
					return false;
				}
			}
			
			if(f1.elements[i].name=="comp_type"){
				if(f1.elements[i].options[f1.elements[i].selectedIndex].value==''){
					alert("Please Select Your Company Type");
					f1.elements[i].focus();
					return false;
				}
			}
			
			if(f1.elements[i].name=="resume_type"){
				if(f1.elements[i].options[f1.elements[i].selectedIndex].value==''){
					alert("Please Select Resume Type");
					f1.elements[i].focus();
					return false;
				}
			}
			
			
			
			if(f1.elements[i].name.substring(0,8)=="subcatid" || f1.elements[i].name=="catId" ||  f1.elements[i].name=="categoryId" ||  f1.elements[i].name=="main_category"){
				if(f1.elements[i].options[f1.elements[i].selectedIndex].value==''){
					alert("Please Select Category");
					f1.elements[i].focus();
					return false;
				}
			}
		}
		
		if(f1.elements[i].type=="select-multiple"){
			if(f1.elements[i].name=="job_category[]"){
				var fld_len=f1.elements[i].options.length;
				var errflag=0;
				var trackflag=0;
				for(var kk=0;kk<fld_len;kk++){
					if(f1.elements[i].options[kk].value=='' && f1.elements[i].options[kk].selected){
						errflag=1;
					}
					if(f1.elements[i].options[kk].selected){
						trackflag++;
					}
				}
				if(trackflag>=1 && errflag==1){
					alert("You cannot select 'Select' Option");
					return false;
				}
				if(trackflag==0){
					alert("Please Select at least one Category");
					return false;
				}
			}	
			if(f1.elements[i].name=="job_country[]"){
				var fld_len=f1.elements[i].options.length;
				var errflag=0;
				var trackflag=0;
				for(var kk=0;kk<fld_len;kk++){
					if(f1.elements[i].options[kk].value=='' && f1.elements[i].options[kk].selected){
						errflag=1;
					}
					if(f1.elements[i].options[kk].selected){
						trackflag++;
					}
				}
				if(trackflag>=1 && errflag==1){
					alert("You cannot select 'Select' Option");
					return false;
				}
				if(trackflag==0){
					alert("Please Select at least one Country");
					return false;
				}
			}	
		}

		if(f1.elements[i].type=="radio"){//Type Radio Box
			if(window.location.toString().indexOf("cpanel")==-1){
				if(!f1.plan[0].checked && !f1.plan[1].checked && !f1.plan[2].checked){
						alert("Please Select Your Subscription Plan");
						return false;
				}
			}
			
		}
		
		if(f1.elements[i].type=="checkbox"){//Type Check Box
			if((f1.elements[i].id=="seeker_pagree" || f1.elements[i].id=="emp_pagree") && !f1.elements[i].checked){
				alert("Are you agree with our Privacy Policy");
				return false;
			}
			if((f1.elements[i].id=="seeker_terms" || f1.elements[i].id=="emp_terms") && !f1.elements[i].checked){
				alert("Are you agree with our Terms And Conditions");
				return false;
			}
			if(f1.elements[i].name=="seeker_industry[]" || f1.elements[i].name=="job_industry[]"){
				var cklen=document.getElementsByName(f1.elements[i].name);
				var ckflag=0;
				for(var yh=0;yh<cklen.length;yh++){
					if(cklen[yh].checked){
						ckflag=1;
						break;
					}	
				}
				if(ckflag==0){
					alert("Please Choose At Least One Category");
					return false;
				}
			}
		}
		
		
		
		if(f1.elements[i].type=="file"){//Type File
			
			if((f1.elements[i].value!='' && f1.elements[i].name=="pimage1") || (f1.elements[i].value!='' && f1.elements[i].name=="pimage2") || (f1.elements[i].value!='' && f1.elements[i].name=="pimage3")|| (f1.elements[i].value!='' && f1.elements[i].name=="pimage4")){
				if(getFileName(f1.elements[i].value).search(/^[0-9A-Za-z\s_ -\[\]]+(.[jJ][pP][gG]|.[gG][iI][fF]|.[bB][mM][pP]|.[jJ][pP][eE][gG]|.[pP][nN][gG])$/)==-1){
					alert("Please upload only jpg or jpeg or png or gif or bmp format of images");
					return false;
				}
			}
			
			if((f1.elements[i].value=='' && f1.elements[i].name=="visitor_resume")){
				alert("Please upload your resume in doc, txt, rtf, pdf, docx formats.");
				return false;	
			}
			
			
			if((f1.elements[i].value!='' && f1.elements[i].name=="seeker_resume") || (f1.elements[i].value!='' && f1.elements[i].name=="visitor_resume")){
				if(getFileName(f1.elements[i].value).search(/^[0-9A-Za-z\s_ -\[\]]+(.[dD][oO][cC]|.[tT][xX][tT]|.[rR][tT][fF]|.[pP][dD][fF]|.[dD][oO][cC][xX])$/)==-1){
					alert("Please upload resume in doc, txt, rtf, pdf, docx formats only");
					return false;
				}
			}
			if((f1.elements[i].value=='' && f1.elements[i].name=="video_file" && (f1.act_video_file.value==''))){
				alert("Please upload only mov or wmv or mpg or mpeg format of videos");
				return false;
			}
			if((f1.elements[i].value!='' && f1.elements[i].name=="video_file")){
				if(getFileName(f1.elements[i].value).search(/^[0-9A-Za-z\s_ -\[\]]+(.[mM][oO][vV]|.[mM][pP][gG]|.[mM][pP][eE][gG]|.[wW][mM][vV])$/)==-1){
					alert("Please upload only mov or wmv or mpg or mpeg format of videos");
					return false;
				}
			}
		}
	
	
	}//End Of For Loop
	return true;
}

function getFileName(filePath){
     //return the length of file name from given path
     fPath= new String(filePath);
     fileName= fPath.substring(fPath.lastIndexOf('\\')+1);
     return fileName;
}


function addBookmark(title,url) {
	if (window.sidebar) { 
		window.sidebar.addPanel(title, url,""); 
	} else if( document.all ) {
		window.external.AddFavorite( url, title);
	} else if( window.opera && window.print ) {
		return true;
	}
}

function validateSearch(frm){
	var mov1=/^[\d]+.?[\d]+$/;
	if(frm.srch_price.value!=''){
		if (!mov1.test(frm.srch_price.value)) {
			alert("Please Enter Numeric or 0.00 format value");
			frm.srch_price.focus();
			return false;
		}
	}
}

function createProd(m1){
	if(document.getElementById("productcontainer")){
		var box=document.getElementById("productcontainer");
		if(navigator.appName.indexOf("Netscape")!=-1 || navigator.appName.indexOf("Mozilla")!=-1){
			var box2=document;
		}else{
			var box2=box.document;
		}
		if(box2.getElementById("prod_div")){
			box2.getElementById("prod_div").innerHTML=m1;
		}else{
			
			var newdiv=document.createElement("div");
			newdiv.setAttribute("id","prod_div");
			newdiv.setAttribute("style","padding-top:10px;");
			newdiv.innerHTML=m1;
			box.appendChild(newdiv);
		}  
	}	
}



function make_catreq(f11,f12,fld,ix){
	//alert(ix);
	try{
			ob1=new ActiveXObject("Msxml2.XMLHTTP");
		}catch(e){
			try{
				ob1=new ActiveXObject("Microsoft.XMLHTTP");
			}catch(e2){
				ob1=false;
			}
		}
	if(!ob1 && typeof XMLHttpRequest!='undefined'){
			ob1=new XMLHttpRequest();
		}
		if(ix==0){//Root Category
   			var v=document.getElementById("categorycontainer");		
   			var m=v.getElementsByTagName("div");
   			var zz=m.length;
   			for(var kk=1;kk<=zz;kk++){
      			//document.getElementById("sub"+kk+"").style.display='none';		
             	v.removeChild(document.getElementById("sub"+kk+""));	
   			}
   		}else{
      
               	if(document.getElementById(""+fld+"")){
                        var v=document.getElementById("categorycontainer");		
            		      var m=v.getElementsByTagName("div");
            		      var zz=m.length;
            		      var rid='sub'+ix;
                  		for(var kk=1;kk<=zz;kk++){
                     		   if(m.id!=rid && kk>ix){
                                 v.removeChild(document.getElementById("sub"+kk+""));	
                              }	
                  		  }	
                     }
             
      }
      var url=f11+"/remote.php?id2="+f12+"&sl="+ix;;
      if(location.href.search("cpanel")==-1){
	    if(location.href.search("advd-search")!=-1){
		   url+="&cssreq=C"; 
  		} 
      }
    ob1.open("GET",url,true);
   	ob1.onreadystatechange=show_form;
   	ob1.send(null);
}
function show_form(){
	if(ob1.readyState==4){
	 	var resp=ob1.responseText;
	 	//alert(resp);
	 	var fresp=resp.split("~");
	 	if(fresp[0]!='no' && fresp[0]!=''){
      	 	var box=document.getElementById("categorycontainer");
      	 	var newdiv=document.createElement("div");
      	 	newdiv.setAttribute("id","sub"+fresp[0]);
      	 	newdiv.setAttribute("style","padding-top:10px;");
      	 	newdiv.innerHTML=fresp[1];
      	 	box.appendChild(newdiv);
       }
       if(fresp[0]=='no'){//No Category
            var v=document.getElementById("categorycontainer");		
		      var m=v.getElementsByTagName("div");
		      var zz=m.length;
		      for(var zk=fresp[1];zk<=zz;zk++){
         		  v.removeChild(document.getElementById("sub"+zk+""));	
              }	
       }
    }
}



//Ajax Call
function makeRequest(val,bsurl,form_name,key,uid){
   try{
			ob1=new ActiveXObject("Msxml2.XMLHTTP");
		}catch(e){
			try{
				ob1=new ActiveXObject("Microsoft.XMLHTTP");
			}catch(e2){
				ob1=false;
			}
	}
	if(!ob1 && typeof XMLHttpRequest!='undefined'){
			ob1=new XMLHttpRequest();
	}
	if(key=="seeker_email1"){//Check Seeker Email
	  	var url=bsurl+"/check-login.php?seek_mail="+val+"&uid="+uid;
   	}
   	if(key=="emp_email1"){//Check Employer Email
	  	var url=bsurl+"/check-login.php?emp_mail="+val+"&uid="+uid;
   	}
   	if(key=="email2"){//Check UserName
	  	var url=bsurl+"/check-login.php?umail2="+val+"&uid="+uid;
   	}
   	if(key=="job1"){//Check Jobs
	  	var url=bsurl+"/remote.php?jcatid="+uid;
   	}
   	if(key=="jobtop"){//Check Top Level Jobs
	  	var url=bsurl+"/remote.php?tcatid="+uid;
   	}
	if(key=="news1"){//Check UserName
	  	var url=bsurl+"/remote.php?newsid="+uid;
   	}
   	if(key=="price3"){//Check Price Crit
	  	var url=bsurl+"/remote.php?prid="+uid;
   	}
	ob1.open("GET",url,true);
	ob1.onreadystatechange=takeResponse;
	ob1.send(null);
	
}

//Ajax Response
function takeResponse(){
	if(ob1.readyState==4){
		var resp=Array();
		resp=ob1.responseText.split("^~^");
	 	if(resp[0]=='duplicate_umail'){
		 	if(document.getElementById(resp[1])){
			 	document.getElementById(resp[1]).value="";
			 	alert("" + resp[2] + "");
			 	document.getElementById(resp[1]).focus();		
		 	}
		 }
		 if(resp[0]=='rfound'){
			document.getElementById("mypriceInfo").innerHTML=resp[1]; 
		 }
	}
}

function Check_Bill_Ship(chk){
	if(chk.check_add.checked==1){
		  chk.saddress.value= chk.baddress.value;
		  chk.scity.value= chk.bcity.value;
		  chk.szipcode.value= chk.bzipcode.value;
		  chk.sstate.value= chk.bstate.value;
		  chk.scountry.value= chk.bcountry.options[chk.bcountry.selectedIndex].value;
		  chk.stel.value= chk.btel.value;
		  chk.sfax.value= chk.bfax.value;
		}   
	 if(chk.check_add.checked==0){
		  chk.saddress.value= '';
		  chk.scity.value= '';
		  chk.szipcode.value= '';
		  chk.sstate.value= '';
		  chk.scountry.value=chk.bcountry.options[0].value;
		  chk.stel.value= '';
		  chk.sfax.value= '';
		}   
}

function validateAddress(chk){
	
		  if(chk.saddress.value!=chk.baddress.value){
		  	return 'Y';
		  }
		  if(chk.szipcode.value!=chk.bzipcode.value){
			  return 'Y';
		  }
		  if(chk.scity.value!=chk.bcity.value){
			  return 'Y';
		  }
		  if(chk.sstate.value!=chk.bstate.value){
			  return 'Y';
		  }
		  if(chk.scountry.options[chk.scountry.selectedIndex].value!=chk.bcountry.options[chk.bcountry.selectedIndex].value){
			  return 'Y';
		  }
		  if(chk.stel.value!=chk.btel.value){
			  return 'Y';
		  }
		  if(chk.sfax.value!=chk.bfax.value){
			  return 'Y';
		  }
		  
}

function validateCart(frm,event){
	var m=frm.elements.length;
	var mov1=/^[\d]+$/;
	
	if (navigator.appVersion.indexOf("MSIE")!=-1){
		var taObj=event.srcElement;
		var evObj=event.srcElement.name;
	}else{
		var taObj=event.target;
		var evObj=event.target.name;
	}
	
	for(var i=0;i<m;i++){
		if(frm.elements[i].type=="text" && frm.elements[i].name!="shipping_zip"){//Type Text
			if(frm.elements[i].value==""){
				alert("Please Enter Quantity");
				frm.elements[i].focus();
				return false;
			}else{
				if(parseInt(frm.elements[i].value)==0){
					alert("Quantity must not be zero");
					frm.elements[i].value='';
					frm.elements[i].focus();
					return false;
				}
				if(parseInt(frm.elements[i].value)<0){
					alert("Quantity must be greater than zero");
					frm.elements[i].value='';
					frm.elements[i].focus();
					return false;
				}
				if (!mov1.test(frm.elements[i].value)) {
					alert("Please Enter Number Only");
					frm.elements[i].value='';
					frm.elements[i].focus();
					return false;
				}
				if(parseInt(frm.elements[i].value)>parseInt(frm.elements[i+1].value)){
                      alert("Only "+frm.elements[i+1].value+" Quantity is in Stock\n Please pay for this much quantity and \n we will let you know when others will be in Stock.");
                      frm.elements[i].value='';
                      frm.elements[i].focus();
                      return false;
                 }
	
			}
		}
		if(frm.elements[i].type=="password"){
			if(frm.elements[i].name=="cpassword" && (evObj=="dcoup" || event.keyCode==13)){
             	if(frm.elements[i].value==""){
                 	alert("Please Enter the Coupon Code");
                 	frm.elements[i].focus();
                 	return false;
              	}
         	}	
		}
		if(frm.elements[i].type=="select-one"){
			/*if(frm.elements[i].options[frm.elements[i].selectedIndex].value=='' && (evObj!="dcoup")){
					alert("Please Select Dimension");
					frm.elements[i].focus();
					return false;
			}*/	
		}
	}
}



function check_all(f1,f2){
	var len=f1.elements.length;
	if(f2=='value'){
		var id1=document.getElementById('change_box').value;
	}else{
		var id1=document.getElementById('change_box').innerHTML;
	}
	
	for(var i=0;i<len;i++){
		if(f1.elements[i].type=="checkbox"){
			if(id1=='Check All'){
			   f1.elements[i].checked=1;
				if(f2=='value'){
					document.getElementById('change_box').value='UncheckAll';
				}else{
					document.getElementById('change_box').innerHTML='UncheckAll';
				}
			}else{
				f1.elements[i].checked=0;
				if(f2=='value'){
					document.getElementById('change_box').value='Check All';
				}else{
					document.getElementById('change_box').innerHTML='Check All';
				}
			}
		}
	}
}



function chkdelete(frm,k1){
	//var frm=document.form2;
	count = frm.elements.length;
	var c=0;
	
	
	if(k1=='D'){
		k1='Deactivate the selected record(s)';
	}
	if(k1=='A'){
		k1='Activate the selected record(s)';
	}
	if(k1=='del'){
		k1='Delete the selected record(s)';
	}
	if(k1=='del3'){
		k1='Delete the selected record(s) and its job appliers';
	}
	if(k1=='del4'){
		k1='Delete the selected record(s) and its related jobs';
	}
	if(k1=='delprod'){
		k1='Delete the selected item(s)';
	}
	if(k1=="unsub"){
		k1='Unsubscribe the selected record(s)';
	}
	if(k1=="sub"){
		k1='Subscribe the selected record(s)';
	}
	if(k1=="Acart"){
		k1='add selected items to the cart';
	}
	if(k1=='R'){
		k1='assign the selected record(s) as Related Products';
	}
	if(k1=='Rd'){
		k1='remove the selected record(s) from Related Products';
	}
	if(k1=='P'){
		k1='assign the selected record(s) as Paid Products';
	}
	if(k1=='Up'){
		k1='remove the selected record(s) from Paid Products';
	}
	if(k1=='C'){
		k1='set the selected record(s) as Paid Orders';
	}
	if(k1=='F'){
		k1='assign the selected record(s) as Featured Jobs';
	}
	if(k1=='RmF'){
		k1='remove the selected record(s) from Featured Jobs';
	}
	
	
	for (i=0; i < count; i++){
		if(frm.elements[i].type=="checkbox"){
			if(frm.elements[i].checked == 1){
				c = 1;
			}
		}
	}
	if(c == 0){
		alert('First, select the record');
		return false;
	}
	var m=confirm("Do you want to "+k1+" ?");
	if(m){
	return true;	
	}else{
		return false;	
	}
}

function swapDiv(pre,showId,maxval){
	for(var tx=1;tx<=maxval;tx++){
		if(document.getElementById(pre+showId) && showId==tx){
			document.getElementById(pre+showId).style.display='block';
		}else{
			if(document.getElementById(pre+tx)){
				document.getElementById(pre+tx).style.display='none';
			}
		}	
	}	
}

function showContent(eleId,val,val1){
	
	if(val==val1){
		document.getElementById(""+eleId+"").style.display='block';
	}else{
		document.getElementById(""+eleId+"").style.display='none';
	}	
	
}

function CheckAll(f1,f2){
	var len=f1.elements.length;
	var c=0;
	for(var i=0;i<len;i++){
		if(f1.elements[i].type=="checkbox" && document.getElementById(f2).checked==1){
			f1.elements[i].checked=1;
			var c=1;
		}else{
				f1.elements[i].checked=0;
			}
	}
	if(document.getElementById('change_box')){
		if(c==1){
			document.getElementById('change_box').value='UncheckAll';
		}else{
			document.getElementById('change_box').value='Check All';
		}
	}
}

function hide(){
 document.getElementById('printbtn').style.display="none";
 document.getElementById('printbtn1').style.display="none";
 window.print();  
}

function showMyDiv(divId,total_div){	
	document.getElementById("Prod_0").style.display='none';
	document.getElementById("Prod_"+divId+"").style.display='block';
	for(var tt=1;tt<=total_div;tt++){
		if(tt!=divId){
			
			document.getElementById("Prod_"+tt+"").style.display='none';
		}	
	}
}

function translator(pattern) {
	var open_in_same_window = 1;
	var my_location = unescape(document.location.toString());
	var new_location ='';
	var new_pattern = '';
	if (my_location.indexOf('translate_c?') != -1) {
		/// From google...
		var indexof_u = my_location.indexOf('u=');
		if (indexof_u == -1) {
			new_location = document.location;
		}
		else {
			var subs = my_location.substring(indexof_u, my_location.length);
			var ss = subs.split('&');
			new_location = ss[0].substring(2, ss[0].length);
		}
	}
	else {
		new_location = document.location;
	}

	indexof_p = pattern.indexOf('|');

	var isen = '';
	if (indexof_p == -1) {
		indexof_p1 = pattern.indexOf('><');
		if (indexof_p1 == -1) {
			new_pattern = pattern;
			if (pattern == 'en') {
				isen = 1;
			}
		}
		else {
			var psplit =pattern.split('><');
			new_pattern = psplit[0]+'|'+psplit[1];
			if (psplit[1] == 'en') {
				isen = 1;
			}
		}
	}
	else {
		var psplit = pattern.split('|');
		new_pattern = psplit[0]+'|'+psplit[1];
		if (psplit[1] == 'en') {
			isen = 1;
		}
	}

	var thisurl = '';
	if (isen == 1) {
		thisurl = new_location;
	}
	else {
		thisurl = 'http://translate.google.com/translate_c?langpair=' + new_pattern + "&u=" + new_location;
	}

	if (open_in_same_window == 1) {
		window.location.href = thisurl;
	}
	else {
		if (CanAnimate ){
			msgWindow=window.open('' ,'subwindow','toolbar=yes,location=yes,directories=yes,status=yes,scrollbars=yes,menubar=yes,resizable=yes,left=0,top=0');
			msgWindow.focus();
			msgWindow.location.href = thisurl;
		}
		else {
			msgWindow=window.open(thisurl,'subwindow','toolbar=yes,location=yes,directories=yes,status=yes,scrollbars=yes,menubar=yes,resizable=yes,left=0,top=0');
		}
	}
}

function chkjobapply(){
	var f1=document.getElementsByTagName("input");
	count = f1.length;
	var c=0;
	var arr_chk=Array();
	var j=0;
	for (i=0; i < count; i++){
		if(f1[i].checked == 1 && f1[i].type=="checkbox"){
			c = 1;
			arr_chk[j]=f1[i].value;
			j++;
		}
	}
	if(c == 0){
		alert('First, select the record');
		return false;
	}else{
		var chkval=arr_chk.join(",");
		if(document.getElementById("jbid")){
			document.getElementById("jbid").value=chkval;
			var k=confirm('Are you sure to apply for the selected jobs');
			if(!k){
				return false;	
			}
		}
	}
}

function chkdeleteapply(){
	var f1=document.getElementsByTagName("input");
	count = f1.length;
	var c=0;
	var arr_chk=Array();
	var j=0;
	for (i=0; i < count; i++){
		if(f1[i].checked == 1 && f1[i].type=="checkbox"){
			c = 1;
			arr_chk[j]=f1[i].value;
			j++;
		}
	}
	if(c == 0){
		alert('First, select the record');
		return false;
	}else{
		var chkval=arr_chk.join(",");
		if(document.getElementById("jbid")){
			document.getElementById("jbid").value=chkval;
			var k=confirm('Are you sure to delete the selected records');
			if(!k){
				return false;	
			}
		}
	}
}

function chkjoball(ele){
	var f1=document.getElementsByTagName("input");
	count = f1.length;
	var c=0;
	for (i=0; i < count; i++){
		if(document.getElementById(ele).value=="Check All"){
			f1[i].checked=1;
		}else{
			f1[i].checked=0;
		}
	}
	if(document.getElementById(ele).value=="Check All"){
		document.getElementById(ele).value="UnCheck All";
	}else{
		document.getElementById(ele).value="Check All";
	}
	return false;
}

function chksendmail(fm2,f2){
	var re_mail = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z])+$/;
	var f1=document.getElementById(""+fm2+"");
	count = f1.elements.length;
	var c=0;
	var arr_chk=Array();
	var j=0;
	for (i=0; i < count; i++){
		if(f1.elements[i].checked == 1){
			c = 1;
			arr_chk[j]=f1.elements[i].value;
			j++;
		}
	}
	if(c == 0){
		alert('First, select the record');
		return false;
	}else{
			var chkval=arr_chk.join(",");
			if(document.getElementById("chk_user")){
				document.getElementById("chk_user").value=chkval;
			}
			var m=f2.elements.length;
			for(var i=0;i<m;i++){
		            if(f2.elements[i].type=="text"){//Type Text
		            	if(f2.elements[i].value=='' && f2.elements[i].name=='subject'){
			            	alert("Please Enter Subject");
			            	f2.elements[i].focus();
			            	return false;
		            	}
		        
						if(f2.elements[i].value=='' && f2.elements[i].name=='email'){
							alert('Please enter Sender mail.');
							f2.elements[i].focus();
							return false;
						}
						
						if(f2.elements[i].value!='' && f2.elements[i].name=='email'){
							if(!re_mail.test(f2.elements[i].value)){
								alert('Please enter Sender mail correctly.');
								f2.elements[i].focus();
								return false;
							}
						}
					}
					if(f2.elements[i].type=="textarea"){//Type Text
						if(f2.elements[i].value=='' && f2.elements[i].name=='message'){
							alert('Please enter Your Message.');
							f2.elements[i].focus();
							return false;
						}
					
					}
			}
	}
}



function swapImage(fpath,param1,param2,param3,param4){
	try{
			ob1=new ActiveXObject("Msxml2.XMLHTTP");
		}catch(e){
			try{
				ob1=new ActiveXObject("Microsoft.XMLHTTP");
			}catch(e2){
				ob1=false;
			}
	}
	if(!ob1 && typeof XMLHttpRequest!='undefined'){
			ob1=new XMLHttpRequest();
	}
	var url = fpath + '/remote.php?prodId=' + param1 + '&traceImg=' + param2 + '&title2=' + param3 + '&uqid=' + param4;
	
	ob1.open("GET",url,true);
	ob1.onreadystatechange=ImgResponse;
	ob1.send(null);
	
}

//Ajax Response
function ImgResponse(){
	if(ob1.readyState==4){
	 	var resp=ob1.responseText;
	 	if(resp!=''){
		 	respArray=Array();
		 	respArray=resp.split("^~^");
		 	document.getElementById("img_container").innerHTML=respArray[0];
	 	}
	}else{
		document.getElementById("img_container").innerHTML='<img src="images/loading1.gif" width="30" height="30">';
	}
}

function getDownload(val,obj){
	document.getElementById("demo_frame").src="down_seeker_resume.php?seek_id=" + val;	
}

document.write('');
document.write('');