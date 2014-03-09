$:.unshift 'lib'
require 'cachew'
require 'fileutils'

class Logger
  def info(message)
    puts "[ INFO] #{message}"
  end
end

describe "cachew" do

  before :all do
  end

  it 'performs a chached process'  do
    cacheproc = Entrepot::Entrepot.new(:salt => "x2",
                                   :entrepotfolder => 'zz_cache',
                                   :logger => Logger.new
                                   )

    data = "foobar " + Time.now.to_s
    name = "a/b/c/foobar.txt"
    result = cacheproc.process( data, name ) do | data, name |
      data
    end

    result = cacheproc.process( data, name ) do | data, name |
      data + Time.now().to_s
    end
    result.should== data
  end

  it 'manages the cachefolder' do
    cacheproc = Entrepot::Entrepot.new(:salt => "x2",
                                   :entrepotfolder => 'zz_cache/x2',
                                   :logger => Logger.new
                                   )
    name = "a/b/c/foobar.txt"
    cacheproc.clean(name)

    cacheproc.process(Time.now.to_s, name) do |data, name|
      data
    end

    cacheproc.files(name).count.should == 1
    cacheproc.clean(name)
    cacheproc.files(name).count.should == 0
  end

  it 'can be turned off' do
    cacheproc = Entrepot::Entrepot.new(:salt => "x2",
                                   :entrepotfolder => 'zz_cache',
                                   :logger => Logger.new,
                                   :mode => :passive
                                   )

    data = "foobar " + Time.now.to_s
    name = "a/b/c/foobar.txt"
    result = cacheproc.process( data, name ) do | data, name |
      data
    end

    newdata = data + Time.now().to_s
    result = cacheproc.process( data, name ) do | data, name |
      newdata
    end
    result.should== newdata
  end

  it 'can refresh the cache' do
    cacheproc = Entrepot::Entrepot.new(:salt => "x2",
                                   :entrepotfolder => 'zz_cache',
                                   :logger => Logger.new,
                                   :mode => :active
                                   )

    data = "foobar " + Time.now.to_s
    name = "a/b/c/foobar.txt"
    result = cacheproc.process( data, name ) do | data, name |
      data
    end

    newdata = data + Time.now().to_s
    result1 = cacheproc.process( data, name ) do | data, name |
      newdata
    end

    cacheproc = Entrepot::Entrepot.new(:salt => "x2",
                                   :entrepotfolder => 'zz_cache',
                                   :logger => Logger.new,
                                   :mode => :refresh
                                   )

    result2 = cacheproc.process( data, name ) do | data, name |
      newdata
    end

    result1.should== data
    result2.should== newdata
  end

  it "can specify the cache filename" do
    cacheproc = Entrepot::Entrepot.new(:salt => "x2",
                                   :entrepotfolder => 'zz_cache',
                                   :mkname => lambda do |f, salt, mdsum|
                                     "_#{mdsum}_#{f}_#{salt}"
                                   end,

                                   :logger => Logger.new,

                                   :mode => :refresh
                                   )
    name = nil;Time.now()
    cacheproc.clean(name)
    result2 = cacheproc.process( "a", name ) do | data, name |
      "foo"
    end
    result2 = cacheproc.process( "b", name ) do | data, name |
      "foo"
    end

    a=Dir["zz_cache/_*_#{name}_x2"]
    a.count.should==2
    cacheproc.clean(name)
  end

end
