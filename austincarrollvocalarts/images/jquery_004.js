/**
 * FILE: jQuery.ptTileSelect.js
 *  
 * @fileOverview
 * jQuery plugin for displaying a popup that allows a user
 * to define a time and set that time back to a form's input
 * field.
 *  
 * @version 0.8
 * @author  Paul Tavares, www.purtuga.com
 * @see     http://pttimeselect.sourceforge.net
 * 
 * @requires jQuery {@link http://www.jquery.com}
 * 
 * 
 * LICENSE:
 * 
 *  Copyright (c) 2007 Paul T. (purtuga.com)
 *  Dual licensed under the:
 *
 *  -   MIT
 *      <http://www.opensource.org/licenses/mit-license.php>
 * 
 *  -   GPL
 *      <http://www.opensource.org/licenses/gpl-license.php>
 *  
 *  User can pick whichever one applies best for their project
 *  and doesn not have to contact me.
 * 
 * 
 * INSTALLATION:
 * 
 * There are two files (.css and .js) delivered with this plugin and
 * that must be included in your html page after the jquery.js library
 * and the jQuery UI style sheet (the jQuery UI javascript library is
 * not necessary).
 * Both of these are to be included inside of the 'head' element of
 * the document. Example below demonstrates this along side the jQuery
 * libraries.
 * 
 * |    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
 * |    <link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.22/themes/redmond/jquery-ui.css" />
 * |
 * |    <link rel="stylesheet" type="text/css" href="jquery.ptTimeSelect.css" />
 * |    <script type="text/javascript" src="jquery.ptTimeSelect.js"></script>
 * |
 * 
 * USAGE:
 * 
 *     -    See <$(ele).ptTimeSelect()>
 * 
 * 
 * 
 * LAST UPDATED:
 * 
 *         - $Date: 2012/08/05 19:40:21 $
 *         - $Author: paulinho4u $
 *         - $Revision: 1.8 $
 * 
 */
(function(t){jQuery.ptTimeSelect={},jQuery.ptTimeSelect.version="__BUILD_VERSION_NUMBER__",jQuery.ptTimeSelect.options={containerClass:void 0,containerWidth:"22em",hoursLabel:"Hour",minutesLabel:"Minutes",setButtonLabel:"Set",popupImage:void 0,onFocusDisplay:!0,zIndex:10,onBeforeShow:void 0,onClose:void 0},jQuery.ptTimeSelect._ptTimeSelectInit=function(){jQuery(document).ready(function(){if(!jQuery("#ptTimeSelectCntr").length){jQuery("body").append('<div id="ptTimeSelectCntr" class="">        <div class="ui-widget ui-widget-content ui-corner-all">        <div class="ui-widget-header ui-corner-all">            <div id="ptTimeSelectCloseCntr" style="float: right;">                <a href="javascript: void(0);" onclick="jQuery.ptTimeSelect.closeCntr();"                         onmouseover="jQuery(this).removeClass(\'ui-state-default\').addClass(\'ui-state-hover\');"                         onmouseout="jQuery(this).removeClass(\'ui-state-hover\').addClass(\'ui-state-default\');"                        class="ui-corner-all ui-state-default">                    <span class="ui-icon ui-icon-circle-close">X</span>                </a>            </div>            <div id="ptTimeSelectUserTime" style="float: left;">                <span id="ptTimeSelectUserSelHr">1</span> :                 <span id="ptTimeSelectUserSelMin">00</span>                 <span id="ptTimeSelectUserSelAmPm">AM</span>            </div>            <br style="clear: both;" /><div></div>        </div>        <div class="ui-widget-content ui-corner-all">            <div>                <div class="ptTimeSelectTimeLabelsCntr">                    <div class="ptTimeSelectLeftPane" style="width: 50%; text-align: center; float: left;" class="">Hour</div>                    <div class="ptTimeSelectRightPane" style="width: 50%; text-align: center; float: left;">Minutes</div>                </div>                <div>                    <div style="float: left; width: 50%;">                        <div class="ui-widget-content ptTimeSelectLeftPane">                            <div class="ptTimeSelectHrAmPmCntr">                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);"                                         style="display: block; width: 45%; float: left;">AM</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);"                                         style="display: block; width: 45%; float: left;">PM</a>                                <br style="clear: left;" /><div></div>                            </div>                            <div class="ptTimeSelectHrCntr">                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">1</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">2</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">3</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">4</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">5</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">6</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">7</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">8</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">9</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">10</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">11</a>                                <a class="ptTimeSelectHr ui-state-default" href="javascript: void(0);">12</a>                                <br style="clear: left;" /><div></div>                            </div>                        </div>                    </div>                    <div style="width: 50%; float: left;">                        <div class="ui-widget-content ptTimeSelectRightPane">                            <div class="ptTimeSelectMinCntr">                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">00</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">05</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">10</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">15</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">20</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">25</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">30</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">35</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">40</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">45</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">50</a>                                <a class="ptTimeSelectMin ui-state-default" href="javascript: void(0);">55</a>                                <br style="clear: left;" /><div></div>                            </div>                        </div>                    </div>                </div>            </div>            <div style="clear: left;"></div>        </div>        <div id="ptTimeSelectSetButton">            <a href="javascript: void(0);" onclick="jQuery.ptTimeSelect.setTime()"                    onmouseover="jQuery(this).removeClass(\'ui-state-default\').addClass(\'ui-state-hover\');"                         onmouseout="jQuery(this).removeClass(\'ui-state-hover\').addClass(\'ui-state-default\');"                        class="ui-corner-all ui-state-default">                SET            </a>            <br style="clear: both;" /><div></div>        </div>        <!--[if lte IE 6.5]>            <iframe style="display:block; position:absolute;top: 0;left:0;z-index:-1;                filter:Alpha(Opacity=\'0\');width:3000px;height:3000px"></iframe>        <![endif]-->    </div></div>');var e=jQuery("#ptTimeSelectCntr");e.find(".ptTimeSelectMin").bind("click",function(){jQuery.ptTimeSelect.setMin(t(this).text())}),e.find(".ptTimeSelectHr").bind("click",function(){jQuery.ptTimeSelect.setHr(t(this).text())}),t(document).mousedown(jQuery.ptTimeSelect._doCheckMouseClick)}})}(),jQuery.ptTimeSelect.setHr=function(t){t.toLowerCase()=="am"||t.toLowerCase()=="pm"?jQuery("#ptTimeSelectUserSelAmPm").empty().append(t):jQuery("#ptTimeSelectUserSelHr").empty().append(t)},jQuery.ptTimeSelect.setMin=function(t){jQuery("#ptTimeSelectUserSelMin").empty().append(t)},jQuery.ptTimeSelect.setTime=function(){var t=jQuery("#ptTimeSelectUserSelHr").text()+":"+jQuery("#ptTimeSelectUserSelMin").text()+" "+jQuery("#ptTimeSelectUserSelAmPm").text();jQuery(".isPtTimeSelectActive").val(t),this.closeCntr()},jQuery.ptTimeSelect.openCntr=function(t){jQuery.ptTimeSelect.closeCntr(),jQuery(".isPtTimeSelectActive").removeClass("isPtTimeSelectActive");var e=jQuery("#ptTimeSelectCntr"),i=jQuery(t).eq(0).addClass("isPtTimeSelectActive"),s=i.data("ptTimeSelectOptions"),a=i.offset();a["z-index"]=s.zIndex,a.top=a.top+i.outerHeight(),s.containerWidth&&(a.width=s.containerWidth),s.containerClass&&e.addClass(s.containerClass),e.css(a);var n=1,r="00",o="AM";if(i.val()){var l=/([0-9]{1,2}).*:.*([0-9]{2}).*(PM|AM)/i,u=l.exec(i.val());u&&(n=u[1]||1,r=u[2]||"00",o=u[3]||"AM")}e.find("#ptTimeSelectUserSelHr").empty().append(n),e.find("#ptTimeSelectUserSelMin").empty().append(r),e.find("#ptTimeSelectUserSelAmPm").empty().append(o),e.find(".ptTimeSelectTimeLabelsCntr .ptTimeSelectLeftPane").empty().append(s.hoursLabel),e.find(".ptTimeSelectTimeLabelsCntr .ptTimeSelectRightPane").empty().append(s.minutesLabel),e.find("#ptTimeSelectSetButton a").empty().append(s.setButtonLabel),s.onBeforeShow&&s.onBeforeShow(i,e),e.slideDown("fast")},jQuery.ptTimeSelect.closeCntr=function(e){var i=t("#ptTimeSelectCntr");if(i.is(":visible")==1){if(jQuery.support.tbody==0&&!(i[0].offsetWidth>0||i[0].offsetHeight>0))return;if(jQuery("#ptTimeSelectCntr").css("display","none").removeClass().css("width",""),e||(e=t(".isPtTimeSelectActive")),e){var s=e.removeClass("isPtTimeSelectActive").data("ptTimeSelectOptions");s&&s.onClose&&s.onClose(e)}}},jQuery.ptTimeSelect._doCheckMouseClick=function(e){t("#ptTimeSelectCntr:visible").length&&!jQuery(e.target).closest("#ptTimeSelectCntr").length&&jQuery(e.target).not("input.isPtTimeSelectActive").length&&jQuery.ptTimeSelect.closeCntr()},jQuery.fn.ptTimeSelect=function(e){return this.each(function(){if(this.nodeName.toLowerCase()=="input"){var i=jQuery(this);if(i.hasClass("hasPtTimeSelect"))return this;var s={};if(s=t.extend(s,jQuery.ptTimeSelect.options,e),i.addClass("hasPtTimeSelect").data("ptTimeSelectOptions",s),s.popupImage||!s.onFocusDisplay){var a=jQuery('<span>&nbsp;</span><a href="javascript:" onclick="jQuery.ptTimeSelect.openCntr(jQuery(this).data(\'ptTimeSelectEle\'));">'+s.popupImage+"</a>").data("ptTimeSelectEle",i);i.after(a)}return s.onFocusDisplay&&i.focus(function(){jQuery.ptTimeSelect.openCntr(this)}),this}})}})(jQuery);