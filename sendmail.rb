require 'net/smtp'

message = <<MESSAGE_END
From: Private Person <p5kov.backup@gmail.com>
To: A Test User <p5kov.backup@gmail.com>
Subject: SMTP e-mail test

This is a test e-mail message.
MESSAGE_END

params = eval(File.open('config.rb') {|f| f.read })

#smtp = Net::SMTP.new 'smtp.abv.bg', 465
smtp = Net::SMTP.new 'smtp.gmail.com', 587
smtp.enable_starttls

println "starting..."
smtp.start('gmail.com', 'p5kov.backup@gmail.com', 'p@roli4ka', :login) do
  println "sending..."
  smtp.send_message message, 'p5kov.backup@gmail.com', 'p5kov.backup@gmail.com'
end