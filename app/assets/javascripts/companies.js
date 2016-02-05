var addOfficeRow = function() {

  var $lastOfficeRow = $('.office-row-fieldset').last();
  var $newOfficeRow = $lastOfficeRow.clone();
  $newOfficeRow.find('input').val('');
  $newOfficeRow.find('.remove-office-row').show();
  var officeRowCount = $('.office-row-fieldset').length;

  $newOfficeRow.find('label').each(function() {
    var oldLabel = $(this).attr('for');
    var newLabel = oldLabel.replace(new RegExp(/_[0-9]+_/), "_" + officeRowCount + "_");
    $(this).attr('for', newLabel);
  });

  $newOfficeRow.find('input').each(function() {
    var oldId = $(this).attr('id');
    var newId = oldId.replace(new RegExp(/_[0-9]+_/), "_" + officeRowCount + "_");
    $(this).attr('id', newId);

    var oldName = $(this).attr('name');
    var newName = oldName.replace(new RegExp(/\[[0-9]+\]/), "[" + officeRowCount + "]");
    $(this).attr('name', newName);
  });

  $newOfficeRow.insertAfter($lastOfficeRow);
  bindRemovalButtons();
}

var bindRemovalButtons = function() {
  $('.remove-office-row').unbind('click').on('click', function() {
    $(this).closest('div.office-row-fieldset').remove();
  });
}

var ready = function() {
  $('#add-office-row').on('click', function() {
    addOfficeRow();
  });

  $('.office-row-fieldset').first().find('.remove-office-row').hide();

  bindRemovalButtons();
}

$(document).ready(ready);
$(document).on('page:load', ready);