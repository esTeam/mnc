class Notifications < ActionMailer::Base
  
  def contact(email_params, sent_at = Time.now)
      
    subject    'For Gili Adler: '<< email_params[:subject]
    recipients ESTEAM_CST_TO_EMAIL    
    from       ESTEAM_CST_FROM_EMAIL
    reply_to   email_params[:email_address]
    sent_on    sent_at
    
    body       :message => email_params[:body], :sender_name => email_params[:name]
  
  end


end