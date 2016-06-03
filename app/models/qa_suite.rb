require 'date'
class QaSuite < ActiveRecord::Base
	has_many :test_cases

	def self.import(logfile)
#		script = String.new
#		file = 'C:\Sites\rails_projects\TH_QA_Dashboard\public\medium_log.txt'
#		script = 'C:\Sites\rails_projects\TH_QA_Dashboard\public\log2data.rb'
#		qa_suite_hash = `ruby #{script} #{file}`
#		suite_hash, cases_index = `ruby #{script} #{file}`
		qa_suite_hash = Hash.new
		tc_index = Array.new
		time_hash = Hash.new
		qa_suite_hash, tc_index = QaSuite.get_suite_data(logfile)
		qa_suite = QaSuite.create! qa_suite_hash
		tc_index.each do |tc|
			tc[:suite_id] = qa_suite.id
			TestCase.create! tc
		end
	end

	def self.get_suite_data(suite_logfile)
		suite_info = Hash.new
		pass_number = 0
		failed_number = 0
		tc_info_index = []
		times_hash = Hash.new
		suite_info[:log_file] = suite_logfile
		#suite_info[:suite_name], suite_info[:branch] = QaSuite.pre_parse_logfile(suite_logfile)
		suite_info[:branch] = 'Master'
		suite_info[:suite_name] = 'Medium'
		suite_info[:build_type] = 'Release'
		File.open(suite_logfile, "r") do |file|
			while line = file.gets
				if not line =~ /^$/
					if line =~ /.+\sTESTCASE\s.+/
						c_info = Hash.new
						c_info[:case_name] = line[/.projs00.+/].split('/')[-1].gsub(/.pyt/, '')
						c_info[:group] = line[/.projs00.+/].split('/')[-2]
						c_info[:suite_name], c_info[:branch] = suite_info[:suite_name], suite_info[:branch]
						c_info[:s_time] = QaSuite.parse_time(line[/^.+[0-9]{2}:[0-9]{2}/])
						c_info[:host] = line[/sjo[a-zA-Z]+[0-9]+\W[0-9]+/]					
						c_info[:qa_log_path] = line[/.projs00.+/].gsub(/.pyt/, '.log') #need
						c_info[:status] = 'Passed'
						tc_info_index << c_info
						pass_number += 1
					elsif line =~ /^FAILED.+file.+/
						c_info = Hash.new
						c_info[:case_name] = line[/.projs00.+/].split('/')[-1].gsub(/.log/, '')
						c_info[:group] = line[/.projs00.+/].split('/')[-2]
						c_info[:suite_name], c_info[:branch] = suite_info[:suite_name], suite_info[:branch]
#						c_info[:s_time] = QaSuite.parse_time(line[/^.+[0-9]{2}:[0-9]{2}/])
#						c_info[:start_time] = parse_time(line[/^.+[0-9]{2}:[0-9]{2}/])
#						c_info[:host] = line[/sjo[a-zA-Z]+[0-9]+\W[0-9]+/]
						c_info[:status] = 'Failed'					
						c_info[:qa_log_path] = line[/.projs00.+/]
						tc_info_index << c_info
						failed_number += 1
					elsif line =~/^\s+[0-9]+\W[0-9]{2}.+/
						times_hash[line.split('/')[-1].split('.')[0..-2].join('.')] = line.split('.')[0].strip
					elsif line =~ /^START\sTIME+/
						suite_info[:start_time]	= QaSuite.strp_time(line[/[0-9]{2}.+$/])
						suite_info[:date] = Date.today.to_s
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
				end
			end
			suite_info[:pass_number] = pass_number - failed_number
			suite_info[:failed_numnber] = failed_number
			suite_info[:pass_number] = 'Release'
		end
		tc_info_index.each do |h|
			if not h[:s_time].nil?
				h[:e_time] = h[:s_time] + times_hash[h[:case_name]].to_i.seconds
			end
		end
		return suite_info, tc_info_index
	end

	def self.parse_time(string)
		return DateTime.parse(string)
	end

	def self.strp_time(string)
		return DateTime.strptime(string,'%m/%d/%y %H:%M:%S')
		#DateTime.strptime('05/02/16 03:58:26','%m/%d/%y %H:%M:%S')
	end
        def self.pre_parse_logfile(logfile)
            return String.new(logfile).split('/')[5].downcase, String.new(logfile).split('/')[4], String.new(logfile).split('/')[-2], String.new(logfile).split('/')[6], String.new(logfile).split('/')[-5]
        end

        def self.homepage_qa_suites_today(version, platform)
                QaSuite.where("date = ?", Date.today.to_s).where("version = ?", version).where("platform = ?", platform)
        end

        def self.homepage_qa_suites_today_rhel5
                QaSuite.where("date = ?", Date.today.to_s).where("platform = ?", "linux_x86_64_rhel5")
        end

        def self.homepage_qa_suites_yesterday
                QaSuite.where("date = ?", Date.today.prev_day.to_s).where("platform = ?", "linux_x86_64_rhel6")
        end

        def self.homepage_qa_suites_yesterday_rhel5
                QaSuite.where("date = ?", Date.today.prev_day.to_s).where("platform = ?", "linux_x86_64_rhel5")
        end
        def rm_UTC (tstr)
           return 'N/A' if tstr == nil
           return tstr.to_s.sub(/ UTC/, '')
        end

end

