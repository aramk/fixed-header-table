# Creates a fixed header which remains aligned during vertical and horizontal scrolling of the
# table content. Repeated calls will update the width of columns.
$.fn.fixedTableHeader = (args) ->
  $table = @
  exists = $table.hasClass('fixed-header')
  # return if exists and !args?
  
  # Use existing elements if possible to avoid moving the table template, which causes event
  # handlers to break.
  $container = $table.closest('.table-fixed-container')
  if hasElement($container)
    $header = $('.table-fixed-container-header', $container)
    $footer = $('.table-fixed-container-footer', $container)
    $body = $('.table-fixed-container-body', $container)
    $headerTable = $('.ui.table', $header)
    $footerTable = $('.ui.table', $footer)
  else
    $container = $('<div class="table-fixed-container"></div>')
  $body = $('<div class="table-fixed-container-body"></div>') unless hasElement($body)
  $header = $('<div class="table-fixed-container-header"></div>') unless hasElement($header)
  $footer = $('<div class="table-fixed-container-footer"></div>') unless hasElement($footer)
  $headerTable = $('<table class="ui table unstackable"></table>') unless hasElement($headerTable)
  $footerTable = $('<table class="ui table unstackable"></table>') unless hasElement($footerTable)
  
  unless exists
    $container.append($header).append($body).append($footer)
    unless $.contains($container[0], $table[0])
      $table.after($container)
    $body.append($table)

  # Create a clone of the header and leave it in the body to ensure the column widths expand to the
  # header cells as well as the body cells. Move the original header which will also be bound to
  # the Meteor templates.
  $tbody = $('tbody', $table)

  if exists
    $thead = $('thead', $headerTable)
    $theadClone = $('thead', $table)
    $tfoot = $('tfood', $footerTable)
    $tfootClone = $('tfood', $footerTable)
  else
    $thead = $('thead:first', $table)
    $theadClone = $thead.clone(true)
    $thead.after $theadClone
    $header.append($headerTable)
    $headerTable.append($thead)
    
    $tfoot = $('tfoot:first', $table)
    $tfootClone = $tfoot.clone(true)
    $tfoot.after $tfootClone
    if $tfoot.length
      $footer.append($footerTable)
      $footerTable.append($tfoot)

  # Set the width of the original header to that of the cloned header so they align.
  setWidths = ->
    $headerTable.width($table[0].scrollWidth)
    $cells = $('th', $theadClone)
    $('th', $thead).each (i) ->
      $th = $(@)
      width = $($cells[i]).width()
      $th.width(width)
    
    # TODO Refactor
    $footerTable.width($table[0].scrollWidth)
    $cells = $('th', $tfootClone)
    $('th', $tfoot).each (i) ->
      $th = $(@)
      width = $($cells[i]).width()
      $th.width(width)

  unless exists
    # Scrolling the body should keep the header aligned.
    setScroll = ->
      _.each [$header, $footer], ($em) -> $em.css 'margin-left', $tbody.position().left
    $body.scroll(setScroll)
  
    # Re-calculate widths and scroll on resize.
    $(window).resize ->
      setWidths()
      setScroll()

  setWidths()
  # Shift the table up to hide the header clone.
  $table.css 'margin-top', -$thead.outerHeight()
  $table.addClass('fixed-header')
  $tfootClone.css({visibility: 'hidden', height: 0})

hasElement = (elem) -> $(elem).length != 0
