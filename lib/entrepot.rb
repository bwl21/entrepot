require "entrepot/version"
require 'digest'

module Entrepot
  class Entrepot

    # 
    # the Constructor
    # @param  args [Hash] Hash of options
    # 
    def initialize(args)
      @options = args
      if @options[:mkname].nil?
        @options[:mkname] = lambda{|cachename, salt, mdsum|
          "_#{salt}_#{File.basename(cachename)}_#{mdsum}.cache"
        }
      end

      if @options[:salt].nil?
        @options[:salt] = "_"
      end

      if @options[:mode].nil?
        @options[:mode] = :active
      end

      if @options[:entrepotfolder].nil?
        @ptions[:entrepotfolder] = "zz_entrepot"
      end
    end


    # 
    # provide a list of cachfiles for a given name
    # 
    # @param  name [String] The name of the cache
    # 
    # @return [Array of String] list of cache filenames
    #  
    def files(name)
      Dir[_cachefile(name, @options[:salt], "*")].select{|f| File.file?(f)}
    end


    # 
    # Clean the cache for a given name
    # 
    # @param  name [String] Name of the cache to be cleaned
    # 
    # @return [Nil] [description]
    def clean(name)
      files(name).each{|f|
        log "delete: #{f}"
        File.delete(f)
        nil
      }
    end


    # 
    # yield a result using the cache
    # 
    # @param  object [String] The input data to be processed
    # @param  name [String] The name of the cache, usually a filename
    # @param  &block [lambda] Procedure to process the string. Note that
    # the block shall yield one object as a result of processing.
    # 
    # @return [Object] The result of the processing
    # 
    def process(object, name, &block)

      FileUtils.mkdir_p(@options[:entrepotfolder])

      salt = @options[:salt]
      digest = Digest::MD5.hexdigest(object + salt)
      cachefile = _cachefile(name, salt, digest)

      # examine the cache
      dumpset = {:salt => nil}
      if @options[:mode] == :active
        if File.exists?(cachefile)
          File.open(cachefile, "rb"){|f| dumpset = Marshal.load(f)}
        end
      end

      # examine the success: Salt is read from the cachefile!
      if dumpset[:salt] != salt
        dumpset = {:salt => salt}
        log "reprocessing #{name}"

        result = block.call(object, name)  # yield the expected result

        dumpset[:result] = result
        if [:active, :refresh].include? @options[:mode]
          File.open(cachefile, "wb"){|f| Marshal.dump(dumpset, f)}
        end
      else
        log "using cache for #{name}"
        result = dumpset[:result]
      end
      result
    end

    private

    def log(message)
      logger =  @options[:logger]
      logger.info(message) if logger.respond_to? :info
    end

    def _cachefile(name, salt, digest)
      "#{@options[:entrepotfolder]}/#{@options[:mkname].call(name, @options[:salt], digest)}"
    end
  end
end
