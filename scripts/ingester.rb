require_relative '../config/environment'
require_relative '../config/ingest'
require 'pathname'
require 'fileutils'

# Searches the inbox pointed to by IngestConfig::INBOX for folders with marker files
# Marker files are named 'disk.<disk_id>' where <disk_id> is the id of the disk this
# ingest should be associated with.
#
# The following files should exist in the directory:
#  raw.img
#  dfxml.xml
#  raw.info
#
# These files will be moved (or copied and deleted) to a new folder under the storage
# path pointed to by IngestConfig::STORAGE_PATH. A DiskImage object will be created in
# Fedora and data streams for the three files above will be created.
#
# The input folder will be deleted unless it contains unknown files.
class Ingester
  def ingest
    unless Pathname.new(IngestConfig::INBOX).directory? then
      puts 'Inbox is not a directory: ' + IngestConfig::INBOX
      return
    end
    unless Pathname.new(IngestConfig::STORAGE_PATH).directory? then
      puts 'Storage path is not a directory: ' + IngestConfig::STORAGE_PATH
      return
    end
  
    search_inbox IngestConfig::INBOX
  end
  
  # Looks for subdirectories of inbox_dir with marker files and runs ingest_disk_image
  def search_inbox inbox_dir
    inbox_path = Pathname.new(inbox_dir)
    unless inbox_path.directory? then
      return
    end
    inbox_path.each_entry do |path|
      ingest_path = inbox_path.join(path)

      if ingest_path.directory? && !/^\.+$/.match(path.to_s) then
        ingest_path.each_entry do |ingest_file|
          if /^disk\.[0-9]+/.match(ingest_file.to_s) then
            ingest_disk_image ingest_path, ingest_file
          end
        end
      end
    end
  end

  # Runs the ingest for one directory
  def ingest_disk_image dir, marker_file
      puts 'Found disk image in directory ' + dir.to_s
      disk_id = /^disk\.([0-9]+)/.match(marker_file.to_s)[1]

      # Verify that all three files exist
      ['raw.info', 'raw.img', 'dfxml.xml'].each do |filename|
        unless dir.join(filename).exist? then
          puts 'ERROR: Could not find the file ' + filename
          return
        end
      end

      # Verify that the disk exists in Fedora
      disk = lookup_disk disk_id      
      if disk then
        puts 'Found disk with id ' + disk_id.to_s
      else
        puts 'ERROR: Could not find disk with id ' + disk_id.to_s
        return
      end

      # Create the disk image object in Fedora
      disk_image = create_disk_image()

      # Move the data files and create data streams for them in Fedora
      move_files(dir, disk_image)

      # Create the relation between the disk and the disk image      
      rels = disk_image.obj.relationship('info:fedora/fedora-system:def/relations-external#isSubsetOf')
      rels << disk.obj

      # Remove the marker file and the input directory
      dir.join(marker_file).delete
      dir.delete
  end
  
  def lookup_disk id
    disk = Disk.find(id.to_s.to_i)
    disk
  end
  
  def create_disk_image
    disk_image = DiskImage.create()
  end
  
  def move_files dir, disk_image
    disk_image_id = disk_image.id
    
    storage_path = calculate_storage_path disk_image_id
    puts 'Moving files from ' + dir.to_s + ' to ' + storage_path

    FileUtils.mkdir_p storage_path

    FileUtils.mv dir.to_s + '/raw.info', storage_path + '/raw.info'
    create_datastream(disk_image, 'INFO', storage_path + '/raw.info', 'text/plain')

    FileUtils.mv dir.to_s + '/raw.img', storage_path + '/raw.img'
    create_datastream(disk_image, 'RAW', storage_path + '/raw.img', 'application/octet-stream')

    FileUtils.mv dir.to_s + '/dfxml.xml', storage_path + '/dfxml.xml'
    create_datastream(disk_image, 'DFXML', storage_path + '/dfxml.xml', 'text/xml')
    Dfxml.from_file(storage_path + '/dfxml.xml',disk_image_id)
  end
  
  # Returns the storage path for a disk_image id
  def calculate_storage_path disk_image_id
    base_dir = IngestConfig::STORAGE_PATH

    id_string = pad_id(disk_image_id)
    base_dir +  '/c' + id_string.length.to_s + '/' + id_to_path(id_string)
  end

  # Takes a numeric id and creates a string padded with zeros to an even number of digits
  def pad_id id
    id_string = ''
    id_string_length = id.to_s.length
    if(id_string_length % 2 == 1) then
      id_string = '0'
    end
    id_string += id.to_s
  end

  # Takes a string and divides it into character pairs separated by slashes   
  def id_to_path id_string
    return id_string if id_string.length < 3
    id_string[0, 2] + '/' + id_to_path(id_string[2..-1])
  end
  
  # Create one data stream in Fedora. The DS will be External with a 'file:' URL
  def create_datastream disk_image, datastream_name, file_path, mimeType
     ds = disk_image.obj.datastreams[datastream_name]
     ds.mimeType=mimeType
     ds.dsLabel=datastream_name
     ds.default_attributes = { :controlGroup => 'E', :dsState => 'A', :versionable => true, :dsLocation => 'file:' + file_path }
     ds.save()
  end
end

# Run the ingest
Ingester.new.ingest
