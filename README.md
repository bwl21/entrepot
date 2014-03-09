# _entrepot_ -  process and save intermediate results

Ruby is excellent for transforming and filtering data.

Rubyists often use these capabilities to manipulate large amounts of data in a multi-step pipeline way.
Entrepot memorizes the results along the way to speed up repetitive processing. If only parts of the original data change, not all of it has to be recomputed. 

Immerdiate results are stored on disk, to enable defered processing and reuse of previous results.

To some extend entrepot can be considered as a kind of cache. But

- entities in entrepot have no expiration date
- entrepot also handles the processing of entities

# Installation

Add this line to your application's Gemfile:

    gem 'entrepot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install entrepot

# Usage

    require 'entrepot'
    proc = Entrepot.new( :entrepotfolder => "zz_myentrepot", 
                             :salt => "1234", 
                             :mkname => lambda{|f, salt, mdsum| 
                                "_#{salt}_#{f.basename}_#{mdsum}"}
                             :logger = $log 
                             :mode = :active
                             )
    proc.mode = :active # :active | :refresh | :passive

    Dir["*.tex"].each do |filename|
       object = File.open(filename).read
       result = proc.process(object, file ) do | object, file |
          l_result = mytransform( object )
          l_result
       end

    puts result

Note that the entrepot is configured upon instantiation is created. If
you want to change the options, simply create a new Entrepot instance with
the desire options.

For more usage examples, please refer to the spec files.

## options

- **:entrepot** - This is the folder where entrepot keeps the entities for latter reuse

- **:salt** - The content is salted by this in order to ensure that the objects stored in the entrepot
    matches the current version of the software.

- **:mkname** - A procedure yielding a string which is used as filename for an
    individual entrepot.

- **:logger** - a logger object which is used to log the entrepot operation. Messages
    are sent by logger.info. Therefore the object needs to respond_to 'info'

- **:mode** - Sets the operation mode of the entrepot. This allows to disable caching
    for debug purposes. The following values apply:

    - *:active* - the entrepot is active

    - *:refresh* - the entrepot files are rebuilt, but not read before. Use this during development. Otherwise you need to change :salt whenever you change the processing of your program

    - *:passive* - entrepot does not operate at all. Entprepot files are neither read
        nor read. This is basically for debugging purposes

## methods

- **process** - performs a entrepot supported processing. This is the heart of the whole thing. See example above

- **files** - provides an array of entrpot internal filenames for a given name

- **clean** - cleans all entrepot entities. In this all internal in the entrepot are
    removed. Thereby basename and mdsum are replaced by "\*" in order to
    get a globber.

    Of course cou can also manually delete the files in the entrepot
    directoy

# License

see LICENSE.txt

# Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request
