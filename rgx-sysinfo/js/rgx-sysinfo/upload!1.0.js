/*
 * JobServiceID:
 * urn:moat:{:your_application_id}:rgx-sysinfo:upload:1.0
 */

var moat = require('moat');
var context = moat.init();
var session = context.session;
var clientRequest = context.clientRequest;
var database = context.database;

session.log('upload', '!!! SysInfo data arrived !!!');

var objects = clientRequest.objects;
var size = objects.length;
var count = 0;
for ( var i = 0; i < size; i++) {
	var container = objects[i];
	if (container.array) {
		var array = container.array;
		for ( var j = 0; j < array.length; j++) {
			save(array[j]);
		}
		count += array.length;
	} else {
		save(container);
		count++;
	}
}

session.log('upload', '=> ' + count + ' objects are stored.');

function save(entity) {
	// Now the given model object is stored into the database.
	var result;
	if (entity.uid) {
		// try to find
		var array = database.queryByUids('SysInfo', [entity.uid]);
		if (array && array.length > 0) {
			// Copy revision
			entity.rev = array[0].rev;
			result = database.update(entity);
		} else {
			result = database.insert(entity);
		}
	} else {
		result = database.insert(entity);
	}
	// The inserted object is internally associated with the device
	// where the
	// data origins.
	session.log('upload:save', 'The object@uid:' + result.uid
			        + ' has been saved to the database.');
}
