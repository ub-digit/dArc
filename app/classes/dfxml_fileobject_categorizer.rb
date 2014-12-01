class DfxmlFileobjectCategorizer < DfxmlFileobjectModifier
	def initialize categorizer_config
		@categorizer_config = categorizer_config
	end

	def modify! object
		@categorizer_config.each do |tag, rules|
			# rules can be either an array of rules (with implied 'or') or a singe rule
			if rules.kind_of?(Array) then
				rules.each do |rule|
					match_rule object, rule, tag
				end
			else
				match_rule object, rules, tag
			end
		end
	end

	def match_rule object, rule, tag
		matches = true
		# all patterns must match their fields (implied 'and')
		rule.each do |field, pattern|
			if object[field.to_s] then
				if Regexp.new(pattern).match(object[field.to_s].to_s) == nil then
					matches = false
				end
			end
		end
		if matches then
			object.merge!({'categories' => [ tag.to_s ]}){ |key,oldval,newval| oldval | newval }
		end
	end

	def self.read_config categorizer_config_filename
		JSON.parse(File.read(categorizer_config_filename))
	end
end
