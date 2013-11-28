# Copyright Nodally Technologies Inc. 2013
# Licensed under the Open Software License version 3.0
# http://opensource.org/licenses/OSL-3.0

# 
# @version 0.2.0
#
# Gmail Sender Xenode reads its input message context and data, composes an email message based on the input data, and sends  
# the composed email through your gmail account. It leverages the "gmail" Ruby Gem to perform the email operations. 
# The Xenode will read the attachment file from a local temporary folder based on the path and file information specified in the 
# message context that it receives. The Gmail Sender Xenode will take multiple email addresses and send the composed email to every
# email address specified in the configuration. Email "To", "Subject", and "Body" can all be read from the either the configuration 
# of the Xenode or from values specified within input data context.  
#
# Config file options:
#   loop_delay:         Expected value: a float. Defines number of seconds the Xenode waits before running process(). 
#   enabled:            Expected value: true/false. Determines if the xenode process is allowed to run.
#   debug:              Expected value: true/false. Enables extra logging messages in the log file.
#   username:           Expected value: a string. Defines your gmail username.
#   password:           Expected value: a string. Defines your gmail application access token / password.
#   email_to:           Expected value: a string. Defines the email address to send an email to.
#   email_subject:      Expected value: a string. Defines the subject of the email to compose.
#   email_body:         Expected value: a string. Defines the body text of the email to compose.
#
# Example Configuration File:
#   enabled: false
#   loop_delay: 30
#   debug: false
#   username: jsmith@gmail.com
#   password: abcdef123456
#   email_to: "jdoe@youremaildomain.com,jdoe2@myemaildomain.com"
#   email_subject: Scanned document
#   email_body: |
#     Hello,
#     Attached is a scanned copy of the document under discussion.
#     Please review, Thanks.
#
# Example Input:     
#   msg.context['file_path']: "tmp_dir/scan1.pdf" 
#   msg.data:  "This string contains the actual body text of the email to be sent."
#
# Example Output:   The Gmail Sender Xenode does not generate any output.  
#

require 'gmail'

class GmailSenderXenode
  include XenoCore::NodeBase
  
  def startup
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"
    
    begin 
      
      @to = @config[:email_to]
      @subject = @config[:email_subject]
      @body = @config[:email_body]

    rescue Exception => e
      do_debug("#{mctx} - ERROR - e.inspect", true)
    end
  end
  
  def process_message(msg_in)
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"

    if msg_in
      do_debug("#{mctx} - received msg: #{msg_in.inspect}", true)
      @body << "\n" if @body.to_s.length > 0
      @body << msg_in.data if msg_in.data
      send_the_mail(msg_in)
    else
      do_debug("#{mctx} - process_message() called but msg was nil.", true)
    end
  end
  
  def override_to(msg)
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"

    ret_val = ""
    if msg && msg.context
      if msg.context['mail'] && msg.context['mail']['to']
        if msg.context['mail']['to'].is_a?(Array)  
          msg.context['mail']['to'].each do |mc|
            ret_val = ", " if ret_val.length > 0
            ret_val << mc
          end
        elsif msg.context['mail']['to'].is_a?(String)
          ret_val = msg.context['mail']['to']
        end
      end
    end
    ret_val
  end
  
  def overrride_subject(msg)
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"

    ret_val = ""
    if msg && msg.context
      if msg.context['mail'] && msg.context['mail']['subject']
        ret_val = msg.context['mail']['subject']
      end
    end
    ret_val
  end
  
  def override_body(msg)
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"

    ret_val = ""
    if msg 
      if msg.context && msg.context['mail'] && msg.context['mail']['body']
        ret_val = msg.context['mail']['body']
      end
    end
    ret_val
  end
  
  def send_the_mail(msg)
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"
    
    begin
      
      to_str = override_to(msg)
      to_str = @to if to_str.to_s.empty?
      
      subj = overrride_subject(msg)
      subj = @subject if subj.to_s.empty?

      override_bdy = override_body(msg)
      body = @body if body.to_s.empty?

      do_debug("#{mctx} - to_str: #{to_str.inspect} subj: #{subj.inspect} body: #{body.inspect}", true)
      
      file_path = msg.context['file_path'] if msg.context && msg.context['file_path']
      
      Gmail.connect!(@config[:username], @config[:password]) do |gmail|
        gmail.deliver do |email|
          email.to       to_str
          email.subject  subj
          email.body     body
          email.add_file file_path unless file_path.to_s.empty?
        end
      end
      
    rescue Exception => e
      do_debug("#{mctx} - ERROR - #{e.inspect} #{e.backtrace[0]}", true)
    end
  end
  
end