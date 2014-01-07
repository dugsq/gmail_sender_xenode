# Copyright Nodally Technologies Inc. 2013
# Licensed under the Open Software License version 3.0
# http://opensource.org/licenses/OSL-3.0

# 
# @version 1.0.0
#
# Gmail Sender Xenode reads its input message context and data, composes an email message based on the input data, and sends  
# the composed email through your gmail account. It leverages the "gmail" Ruby Gem to perform the email operations. 
# The Xenode will read the attachment file from a local temporary folder based on the path and file information specified in the 
# message context that it receives. The Gmail Sender Xenode will take multiple email addresses and send the composed email to every
# email address specified in the configuration. Email "To", "Subject", and "Body" can all be read from the either the configuration 
# of the Xenode or from values specified within input data context.  
#
# Config file options:
#   loop_delay:         Optional; Float; Defines number of seconds the Xenode waits before running process(). 
#   enabled:            Optional; Boolean; Determines if the xenode process is allowed to run.
#   debug:              Optional; Boolean; Enables extra logging messages in the log file.
#   username:           Mandatory; String; Defines your gmail username.
#   password:           Mandatory; String; Defines your gmail application access token / password.
#   to:                 Mandatory; String OR Array; Defines the email address to send an email to.
#   subject:            Mandatory; String; Defines the subject of the email to compose.
#   body:               Mandatory; String; Defines the body text of the email to compose.
#   content_type:       Optional; String; 'html' OR 'plain'(default)
#   file_path:          Optional; String OR Array; file path for the attachement(s)
#
# Example Configuration File:
#   username: jsmith@gmail.com
#   password: abcdef123456
#   to: "jdoe@youremaildomain.com,jdoe2@myemaildomain.com"
#   subject: Scanned document
#   body: |
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
  include XenoCore::XenodeBase
  
  def startup
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"
  end
  
  def process_message(msg)
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"
    do_debug("#{mctx} - received msg: #{msg.inspect}", true)
    send_email(msg)
  end
  
  def send_email(msg)
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"
    begin
      # default
      
      username = @config[:username]
      password = @config[:password]
      to = @config[:to]
      subject = @config[:subject]
      body = @config[:body]
      content_type = @config[:content_type]
      file_path = @config[:file_path]
      
      # overwrite
      
      to = msg.context['mail']['to'] if msg.context && msg.context['mail'] && msg.context['mail']['to'] && !msg.context['mail']['to'].empty?
      to = to.join('|') if to.kind_of?(Array)
      
      subject = msg.context['mail']['subject'] if msg.context && msg.context['mail'] && msg.context['mail']['subject'] && !msg.context['mail']['subject'].empty?
      
      body << "\n" if body.to_s.length > 0
      body << msg.data if msg.data
      body = msg.context['mail']['body'] if msg.context && msg.context['mail'] && msg.context['mail']['body'] && !msg.context['mail']['body'].empty?
      
      content_type = msg.context['mail']['content_type'] if msg.context && msg.context['mail'] && msg.context['mail']['content_type'] && !msg.context['mail']['content_type'].empty?
      
      file_path = msg.context['file_path'] if msg.context && msg.context['file_path'] && !msg.context['file_path'].empty?
      
      # begin to send email
      
      gmail = Gmail.connect(username, password)
      do_debug "Hey have I logged in? #{gmail.logged_in?}"
      do_debug("#{mctx}\nto:#{to.inspect}\nsubject:#{subject.inspect}\nbody:#{body.inspect}\nfile_path:#{file_path.inspect}", true)
      
      # Yuan: do NOT use class varibale within the block!!
      # Yuan: it only allow one type in body, html or plain, it will only choose one
      # Yuan: if more than 2 content type present, it will use html over plain
      email = gmail.compose do
        to "#{to}"
        subject "#{subject}"

        if content_type == "html"
          html_part do
            content_type 'text/html; charset=UTF-8'
            body "#{body}"
          end
        else
          text_part do
            body "#{body}"
          end
        end
        # /if

        if file_path
          if file_path.kind_of?(Array)
            file_path.each do |f|
              add_file "#{f}"
            end
          else
            add_file "#{file_path}"
          end
        end
        # /if
      end
      # /compose

      email.deliver!
      gmail.logout
      do_debug "Hey have I logged out? #{!gmail.logged_in?}"
      
    rescue Exception => e
      do_debug("#{mctx} - ERROR - #{e.inspect} #{e.backtrace[0]}", true)
    end
  end
  # /send_email
  
end
