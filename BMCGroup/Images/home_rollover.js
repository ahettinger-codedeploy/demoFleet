// JavaScript Document

function rolloverButton1 (id, state) {
  if (document.getElementById) {
    var element_id = document.getElementById(id);
	if (state == 'over') {
	  element_id.className = 'interOver'
	}else{
	  element_id.className = 'interUp'
	}
  }
}

function rolloverButton2 (id, state) {
  if (document.getElementById) {
    var element_id = document.getElementById(id);
	if (state == 'over') {
	  element_id.className = 'creativeOver'
	}else{
	  element_id.className = 'creativeUp'
	}
  }
}

function rolloverButton3 (id, state) {
  if (document.getElementById) {
    var element_id = document.getElementById(id);
	if (state == 'over') {
	  element_id.className = 'printOver'
	}else{
	  element_id.className = 'printUp'
	}
  }
}