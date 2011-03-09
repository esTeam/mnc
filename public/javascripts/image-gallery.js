
// Set the starting image.
var i = 0;			

// The number of images in the gallery. Is passed as a parameter to StartGalley.
var NumOfImages = 0;
			
// The time to wait before moving to the next image. Set to 3 seconds by default.
var wait = 3000;

// Holds the interval of the Play() function. 
var play = null;


function StartGallery(num) {
	NumOfImages = num;
	if (num > 0) {
    	$('image-0').appear({ duration: 3 });
	};
	$('play_button').appear();
	$('pause_button').hide({ duration: 0});						
}
function StartSlideShow() {
    play = setInterval('Play()',wait);
	$('play_button').hide();
	$('pause_button').appear({ duration: 0});
}
function SwapImage(x,y) {
	image_y_id = 'image-' + y;
	image_x_id = 'image-' + x;	
	if (image_x_id != image_y_id) {
		$(image_y_id).fade({duration: 1.5});
	    $(image_x_id).appear({ duration: 3 });
	};
}
function Play() {
	var imageShow, imageHide;

	imageShow = i+1;
	imageHide = i;

	if (imageShow == NumOfImages) {
		SwapImage(0,imageHide);	
		i = 0;					
	} else {
		SwapImage(imageShow,imageHide);			
		i++;
	}
}
function Stop () {
	clearInterval(play);				
	$('play_button').appear({ duration: 0});
	$('pause_button').hide();
}
function ShowImage(x) {
    y = i;
    i = x;
    SwapImage(x,y);
	
}
function GoNext() {
	clearInterval(play);
	$('play_button').appear({ duration: 0});
	$('pause_button').hide();
	
	var imageShow, imageHide;

	imageShow = i+1;
	imageHide = i;
	
	if (imageShow == NumOfImages) {
		SwapImage(0,imageHide);	
		i = 0;					
	} else {
		SwapImage(imageShow,imageHide);			
		i++;
	}
}
function GoPrevious() {
	clearInterval(play);
	$('play_button').appear({ duration: 0});
	$('pause_button').hide();

	var imageShow, imageHide;
				
	imageShow = i-1;
	imageHide = i;
	
	if (i == 0) {
		SwapImage(NumOfImages-1,imageHide);	
		i = NumOfImages-1;		
		
		//alert(NumOfImages-1 + ' and ' + imageHide + ' i=' + i)
					
	} else {
		SwapImage(imageShow,imageHide);			
		i--;
		
		//alert(imageShow + ' and ' + imageHide)
	}
}