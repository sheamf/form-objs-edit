var addOfficeRow = function() {

    var $lastOfficeRow = $('.office-row-fieldset').last();
    var $newOfficeRow = $lastOfficeRow.clone();
    $newOfficeRow.find('input').val('');
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
}

$(document).ready(function() {
  $('#add-office-row').on('click', function() {
    addOfficeRow();
  });
});