class QaSuite < ActiveRecord::Base
	has_many :test_cases

	def self.import(logfile)
#		script = String.new
#		file = 'C:\Sites\rails_projects\TH_QA_Dashboard\public\medium_log.txt'
#		script = 'C:\Sites\rails_projects\TH_QA_Dashboard\public\log2data.rb'
#		qa_suite_hash = `ruby #{script} #{file}`
#		suite_hash, cases_index = `ruby #{script} #{file}`
		qa_suite_hash = Hash.new
		qa_suite_hash = QaSuite.get_suite_data(logfile)
		QaSuite.create! qa_suite_hash
	end

	def self.get_suite_data(suite_logfile)
		suite_info = Hash.new
		cases_info_index = Array.new
		suite_info[:suite_name], suite_info[:branch] = QaSuite.pre_parse_logfile(suite_logfile)
		File.open(suite_logfile, "r") do |file|
			while line = file.gets
				if not line =~ /^$/
					if line =~ /.+\sTESTCASE\s.+/
						c_info = Hash.new
						c_info[:case_name] = line[/.projs00.+/].split('/')[-1].gsub(/.pyt/, '')
						c_info[:group] = line[/.projs00.+/].split('/')[-2]
						c_info[:suite_name], c_info[:branch] = suite_info[:suite_name], suite_info[:branch]
						c_info[:start_time] = QaSuite.parse_time(line[/^.+[0-9]{2}:[0-9]{2}/])
						c_info[:host] = line[/sjo[a-zA-Z]+[0-9]+\W[0-9]+/]					
						c_info[:qa_log_path] = line[/.projs00.+/].gsub(/.pyt/, '.log') #need
						c_info[:status] = 'Passed'
						cases_info_index << c_info
					elsif line =~ /^FAILED.+file.+/
						c_info = Hash.new
						c_info[:case_name] = line[/.projs00.+/].split('/')[-1].gsub(/.log/, '')
						c_info[:group] = line[/.projs00.+/].split('/')[-2]
						c_info[:suite_name], c_info[:branch] = suite_info[:suite_name], suite_info[:branch]
#						c_info[:start_time] = parse_time(line[/^.+[0-9]{2}:[0-9]{2}/])
#						c_info[:host] = line[/sjo[a-zA-Z]+[0-9]+\W[0-9]+/]
						c_info[:status] = 'Failed'					
						c_info[:qa_log_path] = line[/.projs00.+/]
					elsif line =~ /^START\sTIME+/
						suite_info[:start_time]	= QaSuite.strp_time(line[/[0-9]{2}.+$/])
					elsif line =~ /^PID.+/
						suite_info[:pid] = line[/[0-9]+/]
					elsif line =~ /^DISPLAY.+/
						suite_info[:display] = line[/sjoth.+/]
					elsif line =~ /^HOST.+/
						suite_info[:host] = line[/sjo.+/]
					elsif line =~ /^EXECUTABLE.+/
						suite_info[:executable] = line[/\Wprojs00.+/]
					elsif line =~ /^COMMAND\sLINE.+/
						suite_info[:command_line] = line[/\W{2}runqa.+/]
					end
					suite_info[:pass_number] = 20
					suite_info[:failed_numnber] = 1
				end
			end
		end
		return suite_info
	end

	def self.parse_time(string)
		return DateTime.parse(string)
	end

	def self.strp_time(string)
		return DateTime.strptime(string,'%m/%d/%y %H:%M:%S')
	end

	def self.pre_parse_logfile(logfile)
		return String.new(logfile).split('/')[5], String.new(logfile).split('/')[-3]
	end
end
