function createChargePermission () {
  var args = {};
  var inputs = $('#chargePermissionTable input').each(function(i, item) {
    args[item.id] = item.value;
  });
  var request = {};
  request.url = "charge_permission";
  request.type = "POST";
  request.data = $.param(args);
  request.success = function(data) {
    $('#charge_permission_id').val(data);
    $('#operating_charge_permission_sid').val(data);
  };
  $.ajax(request);
}

function findChargePermission () {
  var args = {};
  args.email_address = $('#email_address').val()
  var request = {};
  request.url = "charge_permission/find";
  request.type = "POST";
  request.data = $.param(args);
  request.success = function(data) {
    $('#find_charge_permission_results').html(data);
  };
  request.error = function() {
    $('#find_charge_permission_results').html('');
  };
  $.ajax(request);
}

function deactivateChargePermission () {
  var args = {};
  args.sid = $('#charge_permission_id').val()
  var request = {};
  request.url = "charge_permission/deactivate";
  request.type = "POST";
  request.data = $.param(args);
  $.ajax(request);
}

function startChargePermissionIFrame() {
  // invoke charge permission iframe
  var args = {
    success: chargePermissionSuccessCallback,
    error: chargePermissionErrorCallback,
    charge_permission_sid: $('#charge_permission_id').val(),
    server: $('#charge_permission_server').val(),
    name: $('#charge_permission_cardholder_name').val(),
    address_street: '',
    address_city: '',
    address_state: '',
    address_zip: '',
    poundroot_id: 'pound-pcp'
  };
  PoundPay.init(args);
}

function chargePermissionSuccessCallback() {
  $("#pound-pcp").hide();
  $('#chargePermissionComplete').show();
}

function chargePermissionErrorCallback() {
  $("#pound-pcp").hide();
  alert("an error occurred");
}

function createPayment () {
  var args = {};
  var inputs = $('#paymentsTable input').each(function(i, item) {
    args[item.id] = item.value;
  });
  var request = {};
  request.url = "payment";
  request.type = "POST";
  request.data = $.param(args);
  request.success = function(data) {
    $('#payment_id').val(data);
    $('#operating_payment_sid').val(data);
  };
  $.ajax(request);
}

function createUser () {
  var args = {};
  var inputs = $('#create_user_table input').each(function(i, item) {
    args[item.id] = item.value;
  });
  var request = {};
  request.url = "user";
  request.type = "POST";
  request.data = $.param(args);
  request.success = function(data) {
    $('#created_user_results').append(data);
  };
  $.ajax(request);
}

function authorizePayment () {
  var args = {};
  args.sid = $('#operating_payment_sid').val()
  var request = {};
  request.url = "payment/authorize";
  request.type = "POST";
  request.data = $.param(args);
  request.success = function(data) {
    $('#operation_results').append(data);
  };
  $.ajax(request);
}

function escrowPayment () {
  var args = {};
  args.sid = $('#operating_payment_sid').val()
  var request = {};
  request.url = "payment/escrow";
  request.type = "POST";
  request.data = $.param(args);
  request.success = function(data) {
    $('#operation_results').append(data);
  };
  $.ajax(request);
}

function releasePayment () {
  var args = {};
  args.sid = $('#operating_payment_sid').val()
  var request = {};
  request.url = "payment/release";
  request.type = "POST";
  request.data = $.param(args);
  request.success = function(data) {
    $('#operation_results').append(data);
  };
  $.ajax(request);
}

function cancelPayment () {
  var args = {};
  args.sid = $('#operating_payment_sid').val()
  var request = {};
  request.url = "payment/cancel";
  request.type = "POST";
  request.data = $.param(args);
  request.success = function(data) {
    $('#operation_results').append(data);
  };
  $.ajax(request);
}

function startIFrame() {
  // invoke Pound iframe
  var args = {
    success: paymentSuccessCallback,
    error: paymentErrorCallback,
    payment_sid: $('#payment_id').val(),
    server: $('#server').val(),
    name: $('#cardholder_name').val(),
    address_street: '',
    address_city: '',
    address_state: '',
    address_zip: ''
  };
  PoundPay.init(args);
}

function paymentSuccessCallback() {
  $("#pound-root").hide();
  $('#paymentComplete').show();
}

function paymentErrorCallback() {
  $("#pound-root").hide();
  alert("an error occurred");
}
