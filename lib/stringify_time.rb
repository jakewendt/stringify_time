# StringifyTime

## models/task.rb
#stringify_time :due_at
#
#def validate
#	errors.add(:due_at, "is invalid") if due_at_invalid?
#end

# stringify_time.rb
module StringifyTime
	def stringify_time(*names)
		names.each do |name|
			define_method "#{name}_string" do
				read_attribute(name).to_s(:db) unless read_attribute(name).nil?
			end
			
			define_method "#{name}_string=" do |time_str|
				begin
#					write_attribute(name, Time.parse(time_str))
#	Chronic.parse will not raise an error to rescue from
#	chronic actually returns a time
					time = Chronic.parse(time_str)	
					raise ArgumentError if time.nil?
					write_attribute(name, time)
				rescue ArgumentError
					instance_variable_set("@#{name}_invalid", true)
				end
			end
			
			define_method "#{name}_invalid?" do
				instance_variable_get("@#{name}_invalid")
			end
		end
	end
end
ActiveRecord::Base.send(:extend, StringifyTime)
