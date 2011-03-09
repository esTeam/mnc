
// set global variables
// var i = 0;			
// open a popup window
function DoPopup(url, name, width, height) {
    // no spaces are allowed between the settings
    // Note: Browsers interprtates setting differently
         settings= "toolbar=yes,location=yes,directories=yes,"+
                   "status=no,menubar=no,scrollbars=yes,"+
                   "resizable=yes,width="+width+",height="+height;
         MyNewWindow=window.open(url,name,settings);
         return false;
}
// return value to popup window
 function ReturnValueToPopup(element,value) {
            window.opener.document.getElementById(element).value=value;
            window.close();
            }

// removes nested fields from the _form. (from epizode 197)
function remove_fields(link, cl) { 
    // The Element.up and Element.previous methods are part of Prototype’s ultimate DOM traversal toolkit
    // first sibling (brother) element, which has input[type=hidden]  
    $(link).previous("input[type=hidden]").value ="1";
   // firstancestor (parent) element, which its class=cl. (cl must be a name of a class)
    $(link).up(cl).hide();
}
// adds nested fields to the _form. (from epizode 197)
function add_fields(link, association, content) { 
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g") 
    $(link).up().insert({    before: content.replace(regexp, new_id)  });
}

function FlashEmbed(movie_url, object_div, window_div) {
	var movie_url;
	var object_div;
	var object_text;	
	var flashvars = {};
	var params = {
		wmode: "opaque"
		};
	var attributes = {};
	Effect.Appear(window_div, { duration:1, from:0.0, to:1.0 });
 //   $('description').update(object_text);
	swfobject.embedSWF(movie_url, object_div, "600", "450", "9.0.0", false, 
					   flashvars, params, attributes);
}
    
function FlashClose(window_div) {
	Effect.Fade(window_div, { duration:1, from:1.0, to:0.0 });
}

// removes mugshot_id from post, during edit
function RemovePostImage(div,img_id) {
    $(img_id).value="0";
    $(div).hide();
}
// just for tests of javascript call
function hello() {
     document.write('<b>Hello World</b>');
}
