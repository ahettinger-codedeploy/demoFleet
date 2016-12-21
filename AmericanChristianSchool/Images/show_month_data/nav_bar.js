/**
 * Used by top Navigation Bar.  
 * Put in a separate file because in many cases the nav bar is loaded twice (at top and bottom of screen
 */
function open_calc_window()
{
 window.open("http://www.keepandshare.com/global/calculator.htm","Calculator","menubar=no,scrollbars=yes,resizable=1,width=320,height=380");
}
function open_upgrade_window()
{
 window.open("http://www.keepandshare.com/business/purchase.php","Upgrade","menubar=yes,scrollbars=yes,resizable=1,width=600,height=500");
}
function NavBarShareBtnOff(obj)
{
	if (obj && obj.setAttribute)
	{
		obj.setAttribute('background', '/graphics/menushareup.gif')
	}
}

function NavBarBtnOn(obj)
{
	if (obj && obj.setAttribute)
	{
		obj.setAttribute('background', '/graphics/menubackdn.gif')
	}
}

function NavBarBtnOff(obj)
{
	if (obj && obj.setAttribute)
	{
		obj.setAttribute('background', '/graphics/menubackup.gif')
	}
}

function NavBarBtnClick(strName, do_not_display_popup )
{
	if (document.getElementById)
	{
		
		
      // In New/Edit pages, give user warning if they are leaving without saving this work
      if( g_QWebEditorIsBeingUsed == 'y' )  
	  {
	    if( HtmlEditIsModified( "MyQWeb" ) == true )
        {
          // This warning is also in global/global_output.php function global_display_nav_bar()
          if( window.confirm( "Do you want to save your work before leaving?  \n\n   To save your work, press \"OK\" and then \"Save and Exit\" \n   To leave without saving your work, press \"Cancel\"" ) == true )
            return( false );
        }
	  }
      else if( g_calendar_modified == 'y' )
      {
        // This warning is also in global/javascript/nav_bar.js function NavBarBtnClick()
		if( do_not_display_popup != 'n' )
          if( window.confirm( "Do you want to save your calendar changes before leaving?  \n\n   To save your changes, press \"OK\" and then \"Save\" \n   To leave without saving your changes, press \"Cancel\"" ) == true )
            return( false );
      }
	  
 	  obj = document.getElementById(strName)
	  if (!obj.target || obj.target.length == 0)
	  {
		str = "_self"
	  }
	  else
	  {
		str = obj.target
 	  }
	  window.open(obj.href, obj.target)
	}
}



