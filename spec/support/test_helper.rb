module TestHelper

	def json
		@json ||= JSON.parse(response.body)
	end

	# Waits until given code block (yield) is fulfilled, or until timeout is reached
	def wait_for_relation(timeout = 20)
		relation_found = false
		while (!relation_found && timeout > 0)
			if(yield)
				relation_found = true
				puts "Time waiting for relation: #{20-timeout}s"
				next
			end
			sleep(1)
			timeout -= 1
		end
	end
end