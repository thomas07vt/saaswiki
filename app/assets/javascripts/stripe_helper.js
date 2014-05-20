  var stripeResponseHandler = function(status, response) {

    var $form = $('#new_user');
   
    if (response.error) {
      // Show the errors on the form
      $form.find('.payment-errors').text(response.error.message);
      $form.find(":submit").removeAttr("disabled");
    } else {
      // token contains id, last4, and card type
      var token = response.id;
      // Insert the token into the form so it gets submitted to the server
      // This token will be used later upon user confirmation.
      $('#new_user #user_stripe_tok').val(token);
      // and re-submit
      $form.get(0).submit();
    }
  };
 
  // This Function will be called when the Sign_up view form is submitted
  jQuery(function($) {
    $('#new_user').submit(function(event) {
      $('input[type=submit]').prop('disabled', true);

      var $form = $(this);

      var planid = $("#new_user #user_plan").val();
      
      if (planid == 0) {
        //If the user chose the basic plan, then we just need to submit the form.
        var $form = $('#new_user');
        $form.get(0).submit();
      } else {
        // Disable the submit button to prevent repeated clicks
        //$form.find(":submit").attr("disabled", "disabled");
        
        // Grab all the CC info from the form
        var values = {};
        values['number'] = $("#new_user #number").val();
        values['cvc'] = $("#new_user #cvc").val();
        values['exp_year'] = $("#new_user #exp_year").val();
        values['exp_month'] = $("#new_user #exp_month").val();

        // Create the Stripe, one-time user token. The second parameter is the callback function.
        Stripe.createToken(values, stripeResponseHandler);

        // Prevent the form from submitting with the default action
        return false;
        //event.preventDefault();

      }
    });
  });

  jQuery(function($) {
    // This function Will get called when a user chooses a new plan from /Subscriptions/:id/edit
    $(".subscriptionUpdate").click(function(){
      // Get the plan that was clicked
      var planid = $(this).attr('id');

      // Set the plan id in the input forms.
      $("[id=user_plan]").val(planid);

      // Unhide the plyment form.
      $("#paymentForm").removeClass("hide");

      if (planid == "0") {
        // Make sure certain div's are hidden
        $(".premiumPlan").addClass("hide");
        $(".enterprisePlan").addClass("hide");
        $("#CardInfo").addClass("hide");

        // Show necessary div's
        $("#basicPlanUpdate").removeClass("hide");
        $(".basicPlan").removeClass("hide");

      } 
      else {
        // Make sure certain div's are hidden
        $("#basicPlanUpdate").addClass("hide");
        $(".basicPlan").addClass("hide");

        // Show necessary div's
        $("#CardInfo").removeClass("hide");
        if (planid == "1") {
          $(".enterprisePlan").addClass("hide");
          $(".premiumPlan").removeClass("hide");
        }
        else {
          $(".premiumPlan").addClass("hide");
          $(".enterprisePlan").removeClass("hide");
        }
      }
    });
  });
