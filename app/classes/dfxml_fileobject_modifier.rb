class DfxmlFileobjectModifier
	def modify! object
	end

	class DfxmlFileobjectModifier::Names < DfxmlFileobjectModifier
		def modify! object
		    name = object['filename'].sub(/^.*\/([^\/]*)$/,'\1')
    		object.merge!({ 'name' => name })

	    	extension = name.sub(/^.*\.([^.]*)$/,'\1')
   		 	object['extension'] = extension
    
		    object['class'] = name.match(/^\.(\.)?$/) ? 'hide' : '';
		end
	end

	class DfxmlFileobjectModifier::DiskImageId < DfxmlFileobjectModifier
		def initialize diskimageid
			@diskimageid = diskimageid
		end

		def modify! object
			object.merge!({'disk_image' => @diskimageid})
		end
	end
end
