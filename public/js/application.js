$(document).ready(function() {

  var checkJobRecursively = function(job_id) {
    $.post('/status/' + job_id, function(job_status){ 
        if(job_status == "false")
        {
          console.log("Not yet...");
          setTimeout(checkJobRecursively(job_id), 1000)
        }
        else
        {
          $('form').replaceWith("<h1>JOB'S DONE!</h1>");
          console.log("Finally!");
          return true;
        }
      });
  }

  $(document).on("submit", "form", function(event) {
    event.preventDefault();

    var tweet = $('textarea').val();
    var tweet_time = $('#time_to_send').val();

    $.post('/sendtweet', {theTweet: tweet, theTime: tweet_time}, function(response){
      $('form').replaceWith("<form><h1>JOB IN PROGRESS</h1></form>");
      checkJobRecursively(response);
    });
  });
});
