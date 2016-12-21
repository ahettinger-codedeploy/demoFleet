
function toggleFolder( id, makeVisible ) {

  // perform visibility toggle

  var icon = document.getElementById( "folderToggleIcon" + id );
  var content = document.getElementById( "folderContent" + id );
  var btn = document.getElementById( "folderControl" + id );

  // see if we're forcing visibility

  if (makeVisible && isVisible(content)) { return; }

  // perform toggle

  toggleVisibility( content );

  if (!icon) {

    if (isHidden(content)) {
      folderState[id] = false;
      btn.className = "folder-link-expand";
    } else {
      folderState[id] = true;
      btn.className = "folder-link-contract";
    }

  } else {

    if (isHidden(content)) {
      folderState[id] = false;
      icon.src = icon.src.replace("contract", "expand");
    } else {
      folderState[id] = true;
      icon.src = icon.src.replace("expand", "contract");
    }

  }

  // serialize folder state

  var folderStateSerialized = "";

  for( s in folderState ) {
    if (folderState[s] == true) {
      folderStateSerialized += ",";
      folderStateSerialized += s
    }
  }

  setCookie( "folderStateSerialized", folderStateSerialized.substr(1), null, '/' );

}
