/*
 * JobServiceID:
 * urn:moat:{:your_application_id}:blink-rgx-led:blink-rgx-led:1.0
 */

var moat = require('moat');
var context = moat.init();
var session = context.session;

session.log('blink-rgx-led', 'Start to control blinking LED!');

var mapper = session.newModelMapperStub('Led');
var device = mapper.newModelStub();

device.startBlink(session, null, {
  success: function(obj) {
    session.log('blink-rgx-led', 'Succeeded to start blinking the led');
  },
  error: function(type, code) {
    session.log('blink-rgx-led', 'Type:' + type + ', Unexpected status => ' + code);
  }
});

session.log('blink-rgx-led', 'Done!');
