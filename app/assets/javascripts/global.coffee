$(document).on 'turbolinks:load', ->

  $("input[name='active-checkbox']").bootstrapSwitch

  $("input[name='active-checkbox']").on 'switchChange.bootstrapSwitch', (event, state)->
    console.log event
    console.log state

  if $('.error-404').length > 0
    $('.header').hide()

  $('.seckill').click (e) ->
    $.ajax
      url: 'loan_fees/seckill',
      method: 'get',
      data: {loan_fee_id: $(this).data('target')}
      success: (resp) ->
        toastr.info(resp.message)
        setTimeout(->
          window.location.reload()
        ,1500)