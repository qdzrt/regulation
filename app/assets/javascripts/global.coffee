$(document).on 'turbolinks:load', ->

  $("input[name='active-checkbox']").bootstrapSwitch

  $("input[name='active-checkbox']").on 'switchChange.bootstrapSwitch', (event, state)->
    console.log event
    console.log state

  if $('.error-404').length > 0
    $('.header').hide()