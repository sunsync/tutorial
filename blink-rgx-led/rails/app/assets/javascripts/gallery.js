var current = -1;

// Sahara http://farm9.staticflickr.com/8251/8634450244_56c2c2330a_b_d.jpg
// PuertoIguazu http://farm9.staticflickr.com/8110/8634450282_f6c4e563a1_b_d.jpg
// Namib http://farm9.staticflickr.com/8250/8633343831_4a9a6c1d03_b_d.jpg
// MachuPicchu http://farm9.staticflickr.com/8529/8634450388_665f5165ac_b_d.jpg
// Camels http://farm9.staticflickr.com/8113/8634450438_7331bf8cd0_b_d.jpg
// Atacama http://farm9.staticflickr.com/8107/8633343921_75d68253b5_b_d.jpg
// Uyuni http://farm9.staticflickr.com/8256/8633343941_98ed2fb613_b_d.jpg

// Copyright 2013 Yuko Homma All Rights Reserved.
// The use of the photos is licensed under CC BY-ND 2.1 JP.
// http://www.flickr.com/photos/94782828@N05/
var imgs = [
	 'http://farm9.staticflickr.com/8251/8634450244_56c2c2330a_b_d.jpg'
	,'http://farm9.staticflickr.com/8110/8634450282_f6c4e563a1_b_d.jpg'
	,'http://farm9.staticflickr.com/8250/8633343831_4a9a6c1d03_b_d.jpg'
	,'http://farm9.staticflickr.com/8529/8634450388_665f5165ac_b_d.jpg'
	,'http://farm9.staticflickr.com/8113/8634450438_7331bf8cd0_b_d.jpg'
	,'http://farm9.staticflickr.com/8107/8633343921_75d68253b5_b_d.jpg'
	,'http://farm9.staticflickr.com/8256/8633343941_98ed2fb613_b_d.jpg'
];

function loadCurrent() {
	var c = document.cookie;
	var i = c.indexOf('_cur=');
	if (i >= 0) {
		var e = c.indexOf(';', i);
		if (e < 0) {
			current = c.substring(i + 5);
		} else {
			current = c.substring(i + 5, e);
		}
	}
	return current;
}

function storeCurrent() {
	document.cookie = '_cur=' + current;
}

function show() {
	if (current >= 0) {
		$('body')
			.css('background', 'url(' + imgs[current] + ') no-repeat center center fixed');
	} else {
		$('body')
			.css('background', 'white');
	}
}

$(document).ready(function() {
	loadCurrent();
	show();
	$('body')
		.css('-webkit-background-size','cover')
		.css('-moz-background-size','cover')
		.css('-o-background-size','cover')
		.css('background-size','cover');

	$('#btn-off').click(function() {
		current = -1;
		storeCurrent();
		show();
	});

	$('#btn-bck').click(function() {
		current--;
		if (current < 0) {
			current = imgs.length -1;
		}
		storeCurrent();
		show();
	});

	$('#btn-fwd').click(function() {
		current++;
		if (current >= imgs.length) {
			current = 0;
		}
		storeCurrent();
		show();
	});
});
