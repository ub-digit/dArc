class Dataformats::Xml

  def initialize obj
     @obj = obj
     @doc = document_for_ds(datastream_name)
  end

  # returns the contents of a datastream as a parsed xml document
  def document_for_ds ds_name
     ds = @obj.datastreams[ds_name]
     if ds.has_content?
       Nokogiri::XML(ds.content.strip)
     end
  end

  # returns the name of the datastream for this format
  def datastream_name
  end

  # checks if this is a newly created object without xml contents
  def is_new?
     @doc == nil
  end

  # saves the xml data from the document to the datastream
  def save
     ds = @obj.datastreams[datastream_name]
     ds.mimeType='text/xml'
     ds.controlGroup='X'
     ds.dsLabel='EAC'
     ds.content=@doc.to_xml
     ds.save()
  end
  
  # returns the document as an xml string
  def to_xml
     @doc.to_xml
  end

  def read_attribute xpath, namespace
     if is_new?
       return nil
     end
     @doc.xpath(xpath, namespace)[0].value
  end

  def write_attribute xpath, namespace, value
     if is_new?
       @doc = create_empty
     end

     nodes = @doc.xpath(xpath, namespace)

     if !value
       nodes.remove()
     else
       nodes[0].value = value
     end
  end

  def read_element xpath, namespace
     if is_new?
       return nil
     end
     @doc.xpath(xpath, namespace)[0].text
  end

  def write_element xpath, namespace, value
     if is_new?
       @doc = create_empty
     end
     
     nodes = @doc.xpath(xpath, namespace)
     if nodes.length == 0
       raise ArgumentError, 'does not exist', caller
     end
     @doc.xpath(xpath, namespace)[0].content = value
  end

  def write_or_create_element path, value
     if is_new?
       @doc = create_empty
     end
     
     nodes = path.eval_xpath(@doc)
     if nodes.length == 0
       path.create(@doc)
     end
     path.eval_xpath(@doc)[0].content = value
  end
  
  # holds an XML path as an array and can be used to create all elements and attributes
  # included in the path 
  class Path
     attr_accessor :path, :ns_prefix, :ns_uri

     def initialize path, ns_prefix, ns_uri
       @path = path
       @ns_prefix = ns_prefix
       @ns_uri = ns_uri
     end
    
     # evaluate this path as an xpath in the context of the supplied node
     def eval_xpath node
       nodes = node.xpath(as_xpath, as_namespace)
     end
    
     # returns this path as an xpath string
     def as_xpath
       xpath = '/'
       @path.each{|x|
         case x
           when String
             xpath += '/' + @ns_prefix + ':' + x
           when Hash
             xpath += '['
             x.each {|name, value| xpath += '@' + name.to_s + '="' + value + '"'}
             xpath += ']'
         end
       }
       xpath
     end
    
     # returns the namespace prefix and uri associated with this path as a hash
     def as_namespace
       Hash[@ns_prefix, @ns_uri]
     end

     # ensures that the element/attribute structure represented by this path is present
     # in the supplied document. elements and attributes are created as needed
     def create doc
       if path == nil || path.empty?
         return
       end

       parent_path = parent
       nodes = parent.eval_xpath(doc)
       if nodes.length == 0
         parent.create doc
       end

       thing_to_create = path.last
       case thing_to_create
         when String
           parent.add_child thing_to_create, doc
         when Hash
           thing_to_create.each {|key, value| parent.set_attribute(key,value, doc) }
       end
     end
     
     # returns a path object representing the parent element of this path
     def parent
       self.class.new @path[0..-2], @ns_prefix, @ns_uri
     end

     # adds a child element to the element represented by this path
     def add_child element_name, doc
       element = doc.create_element element_name
       eval_xpath(doc)[0].add_child element
     end

     # sets an attribute on the element represented by this path
     def set_attribute name, value, doc
       eval_xpath(doc)[0].set_attribute name, value
     end
  end
end
