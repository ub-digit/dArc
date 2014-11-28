class DfxmlFileobjectModifier
	def modify! object
	end

	# adds some standard fields like name and extension
	class DfxmlFileobjectModifier::Names < DfxmlFileobjectModifier
		def modify! object
		    name = object['filename'].sub(/^.*\/([^\/]*)$/,'\1')
    		object.merge!({ 'name' => name })

	    	extension = name.sub(/^.*\.([^.]*)$/,'\1')
   		 	object['extension'] = extension
    
		    object['class'] = name.match(/^\.(\.)?$/) ? 'hide' : '';
		end
	end

	# adds the disk image id
	class DfxmlFileobjectModifier::DiskImageId < DfxmlFileobjectModifier
		def initialize diskimageid
			@diskimageid = diskimageid
		end

		def modify! object
			object.merge!({'disk_image' => @diskimageid})
		end
	end
end
