require 'net/smtp'
gem 'rubyzip'
require 'zip'
require 'ostruct'
#require 'zip/zipfilesystem'

def sendmail path
	paramsHash = eval(File.open('config.rb')  {|f| f.read })

	params = OpenStruct.new(paramsHash)

	path.sub!(%r[/$],'')
	archive = File.join(path,File.basename(path))+'.zip'
	FileUtils.rm archive, :force=>true

	print "#{archive}\n"

	::Zip::File.open(archive, 'w') do |zipfile|
		Dir["#{path}/**/**"].reject{|f|f==archive}.each do |file|
		  zipfile.add(file.sub(path+'/',''),file)
		end
	end

	filename=archive

	# Read a file and encode it into base64 format
	filecontent = File.read(filename)
	encodedcontent = [filecontent].pack("m")   # base64

	baseFileName = File.basename(filename)

	marker = "AUNIQUEMARKER"

body =<<EOF
This is a test email to send an attachement.
EOF

# Define the main headers.
part1 =<<EOF
From: Private Person <#{params.email}>
To: A Test User <#{params.email}>
Subject: Sending Attachement
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{marker}
--#{marker}
EOF

# Define the message action
part2 =<<EOF
Content-Type: text/plain
Content-Transfer-Encoding:8bit

#{body}
--#{marker}
EOF

# Define the attachment section
part3 =<<EOF
Content-Type: multipart/mixed; name=\"#{baseFileName}\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; baseFileName="#{baseFileName}"

#{encodedcontent}
--#{marker}--
EOF

	mailtext = part1 + part2 + part3

	#params = eval(File.open('config.rb')  {|f| f.read }))

	#smtp = Net::SMTP.new 'smtp.abv.bg', 465
	smtp = Net::SMTP.new 'smtp.gmail.com', 587
	smtp.enable_starttls

	print "starting...\n"
	smtp.start('google.com', params.email, params.secret, :login) do
	  print "sending...\n"
	  smtp.send_message mailtext, params.email, params.email
	end

	FileUtils.rm archive, :force=>true

end


sendmail "/usr/share/zoneminder/events/1/15/07/24/21/41/27"
