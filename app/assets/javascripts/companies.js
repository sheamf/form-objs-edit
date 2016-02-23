var addOfficeRow = function() {
  var $lastOfficeRow = $('.office-row-fieldset').last();
  var $newOfficeRow = $lastOfficeRow.clone();
  $newOfficeRow.find('input').val('');
  $newOfficeRow.find('.remove-office-row').show();
  var officeRowCount = $('.office-row-fieldset').length;

  // oh jeez.  the count only matches 0-indexing because the dom hasn't updated with the new fieldset by the 
  // time the length is checked, so it checks the existing fieldset count.
  var oldId = $newOfficeRow.prop('id');
  var newId = oldId.replace(new RegExp(/[0-9]/), officeRowCount);
  $newOfficeRow.prop('id', newId);

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
  bindRemovalLinks();
}

var bindRemovalLinks = function() {
  $('.remove-office-row').unbind('click').on('click', function() {
    var $fieldset = $(this).closest('div.office-row-fieldset');
    var $removalLink = $(this);
    
    manageRemovalLinks($fieldset, $removalLink);
  });
}

// TODO: when adding a row, unhide the first row's remove link
//       when removing a row, hide first row's remove link IF it's the only one left


var manageRemovalLinks = function($fieldset, $removalLink) {
  event.preventDefault();
  var $confirmLinksDiv = $fieldset.find('.remove-confirm');
  var $confirmLinks = $confirmLinksDiv.find('.remove-office-row');

  $removalLink.hide();
  $confirmLinksDiv.css('display', 'inline');

  $confirmLinks.unbind('click').on('click', function() {
    event.preventDefault();
    var $confirmLink = $(this);

    if ($confirmLink.hasClass('yes')) {
      removeOfficeRow($confirmLink);
    } else if ($confirmLink.hasClass('no')) {
      $confirmLink.closest('.remove-confirm').hide();
      $removalLink.show();      
    }
  });
}

var removeOfficeRow = function($confirmLink) {
  var $fieldset = $confirmLink.closest('div.office-row-fieldset');
  var $removalField = $fieldset.find('.removal-field');

  if ($removalField.length != 0) {
    $removalField.val('true');
    $fieldset.hide();
  } else {
    $fieldset.remove();
  }
}

var ready = function() {
  $('#add-office-row').on('click', function() {
    addOfficeRow();
  });

  $('.office-row-fieldset').first().find('.remove-office-row').hide();

  bindRemovalLinks();
}

$(document).ready(ready);
$(document).on('page:load', ready);