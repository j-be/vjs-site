#usage:
#{% loop_directory directory:images iterator:image filter:*.jpg sort:descending %}
#   <img src="{{ image }}" />
#{% endloop_directory %}

module Jekyll
    class LoopDirectoryTag < Liquid::Block

        include Liquid::StandardFilters
        Syntax = /(#{Liquid::QuotedFragment}+)?/

        def initialize(tag_name, markup, tokens)
            @attributes = {}

            @attributes['directory'] = '';
            @attributes['gallery'] = '';
            @attributes['iterator'] = 'item';
            @attributes['filter'] = 'item';
            @attributes['sort'] = 'ascending';

            # Parse parameters
            if markup =~ Syntax
                markup.scan(Liquid::TagAttributes) do |key, value|
                    @attributes[key] = value
                end
            else
                raise SyntaxError.new("Bad options given to 'loop_directory' plugin.")
            end

            #if @attributes['directory'].nil?
            #   raise SyntaxError.new("You did not specify a directory for loop_directory.")
            #end

            super
        end

        def render(context)
            context.registers[:loop_directory] ||= Hash.new(0)

            #p context[@attributes['directory']]['folder']
            images = Dir.glob(File.join(@attributes['directory'] + context[@attributes['gallery']]['folder'], @attributes['filter']))

            if @attributes['sort'].casecmp( "descending" ) == 0
                # Find files and sort them reverse-lexically. This means
                # that files whose names begin with YYYYMMDD are sorted newest first.
                images.sort! {|x,y| y <=> x }
            else
                # sort normally in ascending order
                images.sort!
            end

            result = []

            context.stack do

                images.each { |pathname| 
                  context[@attributes['iterator']] = pathname
                  result << render_all(@nodelist, context)
                }  

            end

            result
        end
    end
end

Liquid::Template.register_tag('loop_directory', Jekyll::LoopDirectoryTag)
